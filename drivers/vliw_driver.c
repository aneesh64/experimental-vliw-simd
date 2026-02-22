/**
 * VLIW SoC Driver — C Implementation
 */

#include "vliw_driver.h"
#include <string.h>

void vliw_init(vliw_handle_t *h, uint32_t *csr, uint32_t *imem, uint8_t *dmem) {
    h->csr_base = csr;
    h->imem_base = imem;
    h->dmem_base = dmem;
    
    /* Query config from hardware */
    h->n_cores = vliw_csr_read(h, VLIW_NCORES);
    h->vlen = vliw_csr_read(h, VLIW_VLEN);
    h->scratch_size = vliw_csr_read(h, VLIW_SCRA_SIZE);
}

void vliw_imem_write_word(vliw_handle_t *h, uint32_t core, uint32_t addr, uint32_t data) {
    /* Address encoding: [coreIdx] [instrAddr] [wordIdx within bundle]
     * For simplicity, assume single word per bundle or packed word index
     * Address = (core << (imemAddrWidth + 2)) | (addr << 2) | (wordIdx)
     * Easiest: just offset by core and addr in 32-bit space
     */
    uint32_t offset = (core << 20) | addr;  /* Shift core to upper bits */
    h->imem_base[offset] = data;
}

void vliw_imem_write_bundle(vliw_handle_t *h, uint32_t core, uint32_t addr,
                             const uint8_t *bundle, size_t size) {
    /* Write bundle in 32-bit chunks */
    for (size_t i = 0; i < size; i += 4) {
        uint32_t word = 0;
        word |= (bundle[i + 0] << 0);
        if (i + 1 < size) word |= (bundle[i + 1] << 8);
        if (i + 2 < size) word |= (bundle[i + 2] << 16);
        if (i + 3 < size) word |= (bundle[i + 3] << 24);
        
        vliw_imem_write_word(h, core, addr + i / 4, word);
    }
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

void vliw_dmem_read(vliw_handle_t *h, uint32_t addr, uint8_t *data, size_t len) {
    memcpy(data, &h->dmem_base[addr], len);
}

void vliw_dmem_write(vliw_handle_t *h, uint32_t addr, const uint8_t *data, size_t len) {
    memcpy(&h->dmem_base[addr], data, len);
}
