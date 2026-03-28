/**
 * Example: Simple count-up program using VLIW driver.
 *
 * Program bundles are written to DDR at a known offset, then loaded
 * into on-chip IMEM via the hardware IMEM loader triggered through CSR.
 *
 * Expected behavior:
 * - Driver writes bundles to DDR
 * - Triggers IMEM load via CSR
 * - Starts core
 * - Waits for halt
 * - Reads results
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "../../drivers/vliw_driver.h"

/* Mock addresses (in real system, these come from device tree or config) */
#define VLIW_CSR_BASE   0x60000000
#define VLIW_DDR_BASE   0x40000000

/* DDR layout: program bundles at offset 0, data at offset 0x100000 */
#define PROG_DDR_OFFSET 0x00000000
#define DATA_DDR_OFFSET 0x00100000

int main(void) {
    printf("=== VLIW SoC Driver Example ===\n");

    /* Initialize driver */
    vliw_handle_t vliw;
    vliw_init(&vliw,
              (uint32_t *)VLIW_CSR_BASE,
              (uint8_t *)VLIW_DDR_BASE);

    printf("Initialized driver:\n");
    printf("  Cores: %u\n", vliw.n_cores);
    printf("  Vector Length: %u\n", vliw.vlen);
    printf("  Scratch Size: %u words\n", vliw.scratch_size);
    printf("  Bundle Width: %u bits\n", vliw.bundle_width);

    /* Reset */
    vliw_reset(&vliw);
    printf("Reset all cores.\n");

    /* Write mock instruction bundles to DDR.
     * In a real system, you'd place properly assembled VLIW bundles here.
     * Each bundle occupies 64 bytes (one AXI beat) in DDR, with the lower
     * bundle_width bits holding the instruction.
     */
    printf("Writing mock bundles to DDR...\n");
    uint8_t bundle_buf[64];
    for (int i = 0; i < 4; i++) {
        memset(bundle_buf, 0, sizeof(bundle_buf));
        /* Place a dummy 32-bit word at the start of each bundle slot */
        uint32_t mock_instr = (i == 3) ? 0x00000000 : 0xDEADBEEF + i;
        memcpy(bundle_buf, &mock_instr, sizeof(mock_instr));
        vliw_ddr_write(&vliw, PROG_DDR_OFFSET + i * 64, bundle_buf, 64);
        printf("  bundle[%d] @ DDR+0x%04x\n", i, PROG_DDR_OFFSET + i * 64);
    }

    /* Load program from DDR into IMEM */
    printf("Loading %d bundles from DDR into IMEM...\n", 4);
    int rc = vliw_load_program(&vliw, VLIW_DDR_BASE + PROG_DDR_OFFSET, 4, 100000);
    if (rc != 0) {
        printf("ERROR: IMEM load timeout.\n");
        return 1;
    }
    printf("IMEM load complete.\n");

    /* Start execution */
    printf("Starting execution...\n");
    vliw_start(&vliw);

    /* Wait for halt */
    printf("Waiting for core to halt (max 100000 cycles)...\n");
    int status = vliw_wait_halted(&vliw, 100000);

    if (status == 0) {
        printf("SUCCESS: Core halted.\n");
    } else {
        printf("ERROR: Timeout waiting for halt.\n");
        return 1;
    }

    /* Read results */
    uint32_t cycles = vliw_get_core_cycles(&vliw, 0);
    uint32_t pc = vliw_get_core_pc(&vliw, 0);

    printf("Results:\n");
    printf("  Core 0 cycle count: %u\n", cycles);
    printf("  Core 0 final PC: 0x%04x\n", pc);

    printf("\n=== Test Complete ===\n");
    return 0;
}
