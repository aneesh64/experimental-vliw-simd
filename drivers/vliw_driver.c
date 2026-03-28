/**
 * VLIW SoC Driver — C Implementation
 *
 * Program and data live in DDR.  The host writes bundles into DDR, then
 * triggers the hardware IMEM loader via CSR registers to DMA them into
 * on-chip instruction memory before starting execution.
 */

#include "vliw_driver.h"
#include <string.h>

void vliw_init(vliw_handle_t *h, uint32_t *csr, uint8_t *ddr) {
    h->csr_base = csr;
    h->ddr_base = ddr;

    /* Query config from hardware */
    h->n_cores      = vliw_csr_read(h, VLIW_NCORES);
    h->vlen         = vliw_csr_read(h, VLIW_VLEN);
    h->scratch_size = vliw_csr_read(h, VLIW_SCRA_SIZE);
    h->bundle_width = vliw_csr_read(h, VLIW_BWIDTH);
}

int vliw_load_program(vliw_handle_t *h, uint32_t ddr_addr,
                       uint32_t bundle_count, uint32_t timeout) {
    /* Set source address and bundle count in CSR */
    vliw_csr_write(h, VLIW_IMEM_SRC_ADDR, ddr_addr);
    vliw_csr_write(h, VLIW_IMEM_BUNDLE_COUNT, bundle_count);

    /* Trigger IMEM load via CTRL.LOAD bit */
    vliw_csr_write(h, VLIW_CTRL, VLIW_CTRL_LOAD);

    /* Poll IMEM status until done */
    uint32_t count = 0;
    while (timeout == 0 || count < timeout) {
        uint32_t imem_stat = vliw_csr_read(h, VLIW_IMEM_STATUS);
        if (imem_stat & VLIW_IMEM_STAT_DONE) {
            return 0;  /* Load complete */
        }
        count++;
    }

    return -1;  /* Timeout */
}

void vliw_start(vliw_handle_t *h) {
    vliw_csr_write(h, VLIW_CTRL, VLIW_CTRL_START);
}

int vliw_wait_halted(vliw_handle_t *h, uint32_t timeout) {
    uint32_t count = 0;
    uint32_t all_halted_mask = 0;

    /* Build mask for all cores */
    for (uint32_t i = 0; i < h->n_cores; i++) {
        all_halted_mask |= VLIW_STAT_HALTED(i);
    }

    while (timeout == 0 || count < timeout) {
        uint32_t stat = vliw_csr_read(h, VLIW_STAT);
        if ((stat & all_halted_mask) == all_halted_mask) {
            return 0;  /* All halted */
        }
        count++;
    }

    return -1;  /* Timeout */
}

uint32_t vliw_get_cycles(vliw_handle_t *h) {
    return vliw_csr_read(h, VLIW_CYCS);
}

uint32_t vliw_get_core_cycles(vliw_handle_t *h, uint32_t core) {
    return vliw_csr_read(h, VLIW_CORE_CYC(core));
}

uint32_t vliw_get_core_pc(vliw_handle_t *h, uint32_t core) {
    return vliw_csr_read(h, VLIW_CORE_PC(core));
}

void vliw_reset(vliw_handle_t *h) {
    vliw_csr_write(h, VLIW_CTRL, VLIW_CTRL_RESET);
}

void vliw_ddr_read(vliw_handle_t *h, uint32_t offset, uint8_t *data, size_t len) {
    memcpy(data, &h->ddr_base[offset], len);
}

void vliw_ddr_write(vliw_handle_t *h, uint32_t offset, const uint8_t *data, size_t len) {
    memcpy(&h->ddr_base[offset], data, len);
}
