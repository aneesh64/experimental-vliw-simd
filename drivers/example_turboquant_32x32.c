/**
 * Example: load pre-generated TurboQuant-style 32x32 score artifacts through the VLIW driver.
 *
 * Expected workflow:
 *   1. Generate artifacts with:
 *        python tools/turboquant_demo.py --emit-dir <artifact_dir>
 *   2. Run this program with that same artifact directory.
 *   3. The program loads IMEM words and encoded DMEM inputs, starts execution,
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
#define PROG_DDR_OFFSET            0x00000000
#define DATA_DDR_OFFSET            0x00100000
#define AXI_BEAT_BYTES             64

/* Data offsets within DDR data region (byte addresses) */
#define COARSE_KEYS_DDR_OFFSET      (DATA_DDR_OFFSET + 0u)
#define COARSE_QUERIES_DDR_OFFSET   (DATA_DDR_OFFSET + 1024u)
#define RESIDUAL_KEYS_DDR_OFFSET    (DATA_DDR_OFFSET + 2048u)
#define RESIDUAL_QUERIES_DDR_OFFSET (DATA_DDR_OFFSET + 2304u)
#define OUT_DDR_OFFSET              (DATA_DDR_OFFSET + 2560u)

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

static int pack_and_load_program(vliw_handle_t *h, const uint32_t *words, size_t word_count) {
    uint32_t bundle_bits = h->bundle_width;
    uint32_t words_per_bundle = bundle_bits / 32;
    if (words_per_bundle == 0) {
        words_per_bundle = 1;
    }
    size_t bundle_count = word_count / words_per_bundle;

    uint8_t beat[AXI_BEAT_BYTES];
    for (size_t bundle = 0; bundle < bundle_count; bundle++) {
        memset(beat, 0, sizeof(beat));
        size_t copy_bytes = words_per_bundle * 4;
        if (copy_bytes > AXI_BEAT_BYTES) {
            copy_bytes = AXI_BEAT_BYTES;
        }
        memcpy(beat, &words[bundle * words_per_bundle], copy_bytes);
        vliw_ddr_write(h, PROG_DDR_OFFSET + bundle * AXI_BEAT_BYTES, beat, AXI_BEAT_BYTES);
    }

    return vliw_load_program(h, VLIW_DDR_BASE + PROG_DDR_OFFSET, (uint32_t)bundle_count, 1000000);
}

int main(int argc, char **argv) {
    char path_buf[512];
    const char *artifact_dir;
    size_t imem_word_count = 0;
    size_t coarse_keys_size = 0;
    size_t coarse_queries_size = 0;
    size_t residual_keys_size = 0;
    size_t residual_queries_size = 0;
    size_t expected_size = 0;
    uint32_t *imem_words;
    uint8_t *coarse_keys;
    uint8_t *coarse_queries;
    uint8_t *residual_keys;
    uint8_t *residual_queries;
    uint8_t *expected_out;
    uint8_t *actual_out;
    vliw_handle_t vliw;
    int rc;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <artifact_dir>\n", argv[0]);
        return 1;
    }
    artifact_dir = argv[1];

    snprintf(path_buf, sizeof(path_buf), "%s/turboquant_32x32_imem_words.txt", artifact_dir);
    imem_words = read_hex_words(path_buf, &imem_word_count);
    snprintf(path_buf, sizeof(path_buf), "%s/turboquant_32x32_coarse_keys_tiles_i8.bin", artifact_dir);
    coarse_keys = read_binary_file(path_buf, &coarse_keys_size);
    snprintf(path_buf, sizeof(path_buf), "%s/turboquant_32x32_coarse_queries_tiles_i8.bin", artifact_dir);
    coarse_queries = read_binary_file(path_buf, &coarse_queries_size);
    snprintf(path_buf, sizeof(path_buf), "%s/turboquant_32x32_residual_keys_tiles_i8.bin", artifact_dir);
    residual_keys = read_binary_file(path_buf, &residual_keys_size);
    snprintf(path_buf, sizeof(path_buf), "%s/turboquant_32x32_residual_queries_tiles_i8.bin", artifact_dir);
    residual_queries = read_binary_file(path_buf, &residual_queries_size);
    snprintf(path_buf, sizeof(path_buf), "%s/turboquant_32x32_expected_out_tiles_u32_le.bin", artifact_dir);
    expected_out = read_binary_file(path_buf, &expected_size);
    if (imem_words == NULL || coarse_keys == NULL || coarse_queries == NULL || residual_keys == NULL || residual_queries == NULL || expected_out == NULL) {
        fprintf(stderr, "Failed to load one or more artifact files from %s\n", artifact_dir);
        free(imem_words);
        free(coarse_keys);
        free(coarse_queries);
        free(residual_keys);
        free(residual_queries);
        free(expected_out);
        return 1;
    }

    if (coarse_keys_size != 1024 || coarse_queries_size != 1024 || residual_keys_size != 256 || residual_queries_size != 256 || expected_size != 4096) {
        fprintf(stderr, "Unexpected artifact sizes: coarse_keys=%zu coarse_queries=%zu residual_keys=%zu residual_queries=%zu expected_out=%zu\n",
                coarse_keys_size, coarse_queries_size, residual_keys_size, residual_queries_size, expected_size);
        free(imem_words);
        free(coarse_keys);
        free(coarse_queries);
        free(residual_keys);
        free(residual_queries);
        free(expected_out);
        return 1;
    }

    vliw_init(&vliw, (uint32_t *)VLIW_CSR_BASE, (uint8_t *)VLIW_DDR_BASE);
    vliw_reset(&vliw);

    if (pack_and_load_program(&vliw, imem_words, imem_word_count) != 0) {
        fprintf(stderr, "Timed out loading program into IMEM\n");
        free(imem_words);
        free(coarse_keys);
        free(coarse_queries);
        free(residual_keys);
        free(residual_queries);
        free(expected_out);
        return 1;
    }
    vliw_ddr_write(&vliw, COARSE_KEYS_DDR_OFFSET, coarse_keys, coarse_keys_size);
    vliw_ddr_write(&vliw, COARSE_QUERIES_DDR_OFFSET, coarse_queries, coarse_queries_size);
    vliw_ddr_write(&vliw, RESIDUAL_KEYS_DDR_OFFSET, residual_keys, residual_keys_size);
    vliw_ddr_write(&vliw, RESIDUAL_QUERIES_DDR_OFFSET, residual_queries, residual_queries_size);

    vliw_start(&vliw);
    rc = vliw_wait_halted(&vliw, 1000000);
    if (rc != 0) {
        fprintf(stderr, "Timed out waiting for TurboQuant score program to halt\n");
        free(imem_words);
        free(coarse_keys);
        free(coarse_queries);
        free(residual_keys);
        free(residual_queries);
        free(expected_out);
        return 1;
    }

    actual_out = (uint8_t *)malloc(expected_size);
    if (actual_out == NULL) {
        free(imem_words);
        free(coarse_keys);
        free(coarse_queries);
        free(residual_keys);
        free(residual_queries);
        free(expected_out);
        return 1;
    }
    vliw_ddr_read(&vliw, OUT_DDR_OFFSET, actual_out, expected_size);

    if (memcmp(actual_out, expected_out, expected_size) != 0) {
        fprintf(stderr, "TurboQuant output mismatch against generated expected tile-packed output\n");
        free(actual_out);
        free(imem_words);
        free(coarse_keys);
        free(coarse_queries);
        free(residual_keys);
        free(residual_queries);
        free(expected_out);
        return 1;
    }

    printf("TurboQuant-style 32x32 example completed successfully.\n");
    printf("  IMEM words loaded: %zu\n", imem_word_count);
    printf("  Output bytes checked: %zu\n", expected_size);
    printf("  Core cycles: %u\n", vliw_get_core_cycles(&vliw, 0));

    free(actual_out);
    free(imem_words);
    free(coarse_keys);
    free(coarse_queries);
    free(residual_keys);
    free(residual_queries);
    free(expected_out);
    return 0;
}