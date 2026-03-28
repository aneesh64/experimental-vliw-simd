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
#define VLIW_DDR_BASE   0x40000000

/* DDR layout: program bundles at 0x0, data at 0x100000 */
#define PROG_DDR_OFFSET      0x00000000
#define DATA_DDR_OFFSET      0x00100000
#define AXI_BEAT_BYTES       64

/* Data offsets within DDR data region (byte addresses) */
#define LHS_DDR_OFFSET  (DATA_DDR_OFFSET + 0u)
#define RHS_DDR_OFFSET  (DATA_DDR_OFFSET + 1024u)
#define OUT_DDR_OFFSET  (DATA_DDR_OFFSET + 2048u)

/* Core-side DMEM word addresses (must match assembled program expectations) */
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

static int pack_and_load_program(vliw_handle_t *h, const uint32_t *words,
                                  size_t word_count) {
    /* Determine bundle size in 32-bit words from hardware config */
    uint32_t bundle_bits = h->bundle_width;
    uint32_t words_per_bundle = bundle_bits / 32;
    if (words_per_bundle == 0) words_per_bundle = 1;
    size_t bundle_count = word_count / words_per_bundle;

    /* Pack each bundle into one AXI beat (64 bytes) in DDR */
    uint8_t beat[AXI_BEAT_BYTES];
    for (size_t b = 0; b < bundle_count; b++) {
        memset(beat, 0, sizeof(beat));
        size_t copy_bytes = words_per_bundle * 4;
        if (copy_bytes > AXI_BEAT_BYTES) copy_bytes = AXI_BEAT_BYTES;
        memcpy(beat, &words[b * words_per_bundle], copy_bytes);
        vliw_ddr_write(h, PROG_DDR_OFFSET + b * AXI_BEAT_BYTES, beat, AXI_BEAT_BYTES);
    }

    /* Trigger hardware IMEM loader */
    return vliw_load_program(h, VLIW_DDR_BASE + PROG_DDR_OFFSET,
                              (uint32_t)bundle_count, 1000000);
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
              (uint8_t *)VLIW_DDR_BASE);
    vliw_reset(&vliw);

    if (pack_and_load_program(&vliw, imem_words, imem_word_count) != 0) {
        fprintf(stderr, "Timed out loading program into IMEM\n");
        free(imem_words);
        free(lhs_tiles);
        free(rhs_tiles);
        free(expected_out);
        return 1;
    }
    vliw_ddr_write(&vliw, LHS_DDR_OFFSET, lhs_tiles, lhs_size);
    vliw_ddr_write(&vliw, RHS_DDR_OFFSET, rhs_tiles, rhs_size);

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
    vliw_ddr_read(&vliw, OUT_DDR_OFFSET, actual_out, expected_size);

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