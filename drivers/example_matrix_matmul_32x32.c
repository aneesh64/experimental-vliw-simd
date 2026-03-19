/**
 * Example: load pre-generated 32x32 tiled matrix-matmul artifacts through the VLIW driver.
 *
 * Expected workflow:
 *   1. Generate artifacts with:
 *        python tools/matrix_matmul_32x32_demo.py --emit-dir <artifact_dir>
 *   2. Run this program with that same artifact directory.
 *   3. The program loads IMEM words and packed DMEM inputs, starts execution,
 *      waits for halt, then compares the packed output buffer against the expected file.
 *
 * This is a host-side usage example. The base addresses below are still platform-specific.
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

#include "vliw_driver.h"

#define VLIW_CSR_BASE   0x60000000
#define VLIW_IMEM_BASE  0x60000400
#define VLIW_DMEM_BASE  0x60000800

#define LHS_DMEM_WORD_ADDR   0u
#define RHS_DMEM_WORD_ADDR   256u
#define OUT_DMEM_WORD_ADDR   512u

static uint32_t *read_hex_words(const char *path, size_t *count_out) {
    FILE *fp = fopen(path, "r");
    char line[64];
    size_t cap = 1024;
    size_t count = 0;
    uint32_t *words = (uint32_t *)malloc(cap * sizeof(uint32_t));
    if (fp == NULL || words == NULL) {
        fclose(fp);
        free(words);
        return NULL;
    }

    while (fgets(line, sizeof(line), fp) != NULL) {
        unsigned int value = 0;
        if (sscanf(line, "%x", &value) != 1) {
            continue;
        }
        if (count == cap) {
            cap *= 2;
            uint32_t *grown = (uint32_t *)realloc(words, cap * sizeof(uint32_t));
            if (grown == NULL) {
                free(words);
                fclose(fp);
                return NULL;
            }
            words = grown;
        }
        words[count++] = (uint32_t)value;
    }

    fclose(fp);
    *count_out = count;
    return words;
}

static uint8_t *read_binary_file(const char *path, size_t *size_out) {
    FILE *fp = fopen(path, "rb");
    uint8_t *data;
    long size;
    if (fp == NULL) {
        return NULL;
    }
    if (fseek(fp, 0, SEEK_END) != 0) {
        fclose(fp);
        return NULL;
    }
    size = ftell(fp);
    if (size < 0) {
        fclose(fp);
        return NULL;
    }
    rewind(fp);

    data = (uint8_t *)malloc((size_t)size);
    if (data == NULL) {
        fclose(fp);
        return NULL;
    }
    if (fread(data, 1, (size_t)size, fp) != (size_t)size) {
        free(data);
        fclose(fp);
        return NULL;
    }
    fclose(fp);
    *size_out = (size_t)size;
    return data;
}

static int load_program_words(vliw_handle_t *h, const uint32_t *words, size_t word_count) {
    size_t word_index;
    for (word_index = 0; word_index < word_count; ++word_index) {
        vliw_imem_write_word(h, 0, (uint32_t)word_index, words[word_index]);
    }
    return 0;
}

int main(int argc, char **argv) {
    char path_buf[512];
    const char *artifact_dir;
    size_t imem_word_count = 0;
    size_t lhs_size = 0;
    size_t rhs_size = 0;
    size_t expected_size = 0;
    uint32_t *imem_words;
    uint8_t *lhs_tiles;
    uint8_t *rhs_tiles;
    uint8_t *expected_out;
    uint8_t *actual_out;
    vliw_handle_t vliw;
    int rc;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <artifact_dir>\n", argv[0]);
        return 1;
    }
    artifact_dir = argv[1];

    snprintf(path_buf, sizeof(path_buf), "%s/matrix_matmul_32x32_imem_words.txt", artifact_dir);
    imem_words = read_hex_words(path_buf, &imem_word_count);
    snprintf(path_buf, sizeof(path_buf), "%s/matrix_matmul_32x32_lhs_tiles_u8.bin", artifact_dir);
    lhs_tiles = read_binary_file(path_buf, &lhs_size);
    snprintf(path_buf, sizeof(path_buf), "%s/matrix_matmul_32x32_rhs_tiles_u8.bin", artifact_dir);
    rhs_tiles = read_binary_file(path_buf, &rhs_size);
    snprintf(path_buf, sizeof(path_buf), "%s/matrix_matmul_32x32_expected_out_tiles_u32_le.bin", artifact_dir);
    expected_out = read_binary_file(path_buf, &expected_size);
    if (imem_words == NULL || lhs_tiles == NULL || rhs_tiles == NULL || expected_out == NULL) {
        fprintf(stderr, "Failed to load one or more artifact files from %s\n", artifact_dir);
        free(imem_words);
        free(lhs_tiles);
        free(rhs_tiles);
        free(expected_out);
        return 1;
    }

    if (lhs_size != 1024 || rhs_size != 1024 || expected_size != 4096) {
        fprintf(stderr, "Unexpected artifact sizes: lhs=%zu rhs=%zu expected_out=%zu\n", lhs_size, rhs_size, expected_size);
        free(imem_words);
        free(lhs_tiles);
        free(rhs_tiles);
        free(expected_out);
        return 1;
    }

    vliw_init(&vliw,
              (uint32_t *)VLIW_CSR_BASE,
              (uint32_t *)VLIW_IMEM_BASE,
              (uint8_t *)VLIW_DMEM_BASE);
    vliw_reset(&vliw);

    load_program_words(&vliw, imem_words, imem_word_count);
    vliw_dmem_write(&vliw, LHS_DMEM_WORD_ADDR * 4u, lhs_tiles, lhs_size);
    vliw_dmem_write(&vliw, RHS_DMEM_WORD_ADDR * 4u, rhs_tiles, rhs_size);

    vliw_start(&vliw);
    rc = vliw_wait_halted(&vliw, 1000000);
    if (rc != 0) {
        fprintf(stderr, "Timed out waiting for tiled matrix program to halt\n");
        free(imem_words);
        free(lhs_tiles);
        free(rhs_tiles);
        free(expected_out);
        return 1;
    }

    actual_out = (uint8_t *)malloc(expected_size);
    if (actual_out == NULL) {
        free(imem_words);
        free(lhs_tiles);
        free(rhs_tiles);
        free(expected_out);
        return 1;
    }
    vliw_dmem_read(&vliw, OUT_DMEM_WORD_ADDR * 4u, actual_out, expected_size);

    if (memcmp(actual_out, expected_out, expected_size) != 0) {
        fprintf(stderr, "Matrix output mismatch against generated expected tile-packed output\n");
        free(actual_out);
        free(imem_words);
        free(lhs_tiles);
        free(rhs_tiles);
        free(expected_out);
        return 1;
    }

    printf("Matrix tiled 32x32 example completed successfully.\n");
    printf("  IMEM words loaded: %zu\n", imem_word_count);
    printf("  Output bytes checked: %zu\n", expected_size);
    printf("  Core cycles: %u\n", vliw_get_core_cycles(&vliw, 0));

    free(actual_out);
    free(imem_words);
    free(lhs_tiles);
    free(rhs_tiles);
    free(expected_out);
    return 0;
}