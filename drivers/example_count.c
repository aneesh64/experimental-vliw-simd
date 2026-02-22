/**
 * Example: Simple count-up program using VLIW driver.
 *
 * Program: Count from 0 to 9, accumulate in r1.
 * Assembler:
 *   .loop: ADD r1, r0, #1
 *          ADDI r2, r1, #10
 *          BLT r2, #10, .loop  (if r2 < 10, jump to .loop)
 *          HALT
 *
 * After execution, r1 should contain 10.
 *
 * Expected behavior:
 * - Driver loads 4 instructions to IMEM
 * - Starts core
 * - Waits for halt
 * - Reads r1 via DMEM (if accessible) or query cycle count
 */

#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include "../../drivers/vliw_driver.h"

/* Mock addresses (in real system, these come from device tree or config) */
#define VLIW_CSR_BASE   0x60000000
#define VLIW_IMEM_BASE  0x60000400
#define VLIW_DMEM_BASE  0x60000800

int main(void) {
    printf("=== VLIW SoC Driver Example ===\n");
    
    /* Initialize driver */
    vliw_handle_t vliw;
    vliw_init(&vliw, 
              (uint32_t *)VLIW_CSR_BASE,
              (uint32_t *)VLIW_IMEM_BASE,
              (uint8_t *)VLIW_DMEM_BASE);
    
    printf("Initialized driver:\n");
    printf("  Cores: %u\n", vliw.n_cores);
    printf("  Vector Length: %u\n", vliw.vlen);
    printf("  Scratch Size: %u words\n", vliw.scratch_size);
    
    /* Reset */
    vliw_reset(&vliw);
    printf("Reset all cores.\n");
    
    /* Load instructions (mock 32-bit words for bundle)
     * In a real system, you'd assemble a proper VLIW bundle.
     * For demo, we use dummy instruction words.
     */
    printf("Loading instructions to core 0...\n");
    
    uint32_t instr[4] = {
        0xDEADBEEF,  /* Instruction 0: (mock) */
        0xCAFEBABE,  /* Instruction 1: (mock) */
        0x12345678,  /* Instruction 2: (mock) */
        0x00000000,  /* Instruction 3: HALT   */
    };
    
    for (int i = 0; i < 4; i++) {
        vliw_imem_write_word(&vliw, 0, i, instr[i]);
        printf("  [0x%04x] <- 0x%08x\n", i * 4, instr[i]);
    }
    
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
