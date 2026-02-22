/**
 * VLIW SoC Driver — C API for host control
 *
 * Exposes CSR register access, instruction loading, and execution control.
 * All offsets relative to base address.
 */

#ifndef __VLIW_DRIVER_H__
#define __VLIW_DRIVER_H__

#include <stdint.h>
#include <stdbool.h>

/* ==================== CSR Register Offsets ==================== */

#define VLIW_CTRL         0x000   /* Control register (W)                    */
#define VLIW_STAT         0x004   /* Status register (R)                     */
#define VLIW_CYCS         0x008   /* Cycle counter (R)                       */
#define VLIW_NCORES       0x00C   /* Number of cores (R)                     */
#define VLIW_VLEN         0x010   /* Vector length (R)                       */
#define VLIW_SCRA_SIZE    0x014   /* Scratch size per core (R)               */
#define VLIW_IMEM_DEPTH   0x018   /* Instruction memory words (R)            */
#define VLIW_BWIDTH       0x01C   /* Bundle width in bits (R)                */
#define VLIW_SLOT_CFG     0x020   /* Slot config packed (R)                  */
#define VLIW_CORE_PC(n)   (0x100 + (n) * 4)   /* Core n PC (R)              */
#define VLIW_CORE_CYC(n)  (0x200 + (n) * 4)   /* Core n cycle count (R)     */

/* IMEM write port (via AXI4-Lite) */
#define VLIW_IMEM_BASE    0x400   /* IMEM base address (32-bit word writes)  */

/* DMEM read/write port (via AXI4) — N cores + 1 host */
#define VLIW_DMEM_BASE    0x800   /* DMEM base address (any AXI size)        */

/* ==================== CTRL Register Bits ==================== */

#define VLIW_CTRL_START    (1U << 0)   /* Write 1 to start execution        */
#define VLIW_CTRL_RESET    (1U << 1)   /* Write 1 to reset all cores        */
#define VLIW_CTRL_STOP     (1U << 2)   /* Write 1 to halt execution (debug) */

/* ==================== STATUS Register Bits ==================== */

#define VLIW_STAT_RUNNING   (1U << 0)  /* Bit 0: any core running           */
#define VLIW_STAT_HALTED(n) (1U << ((n) + 1))  /* Bit [n+1]: core n halted   */

/* ==================== Driver Handle ==================== */

typedef struct {
    volatile uint32_t *csr_base;    /* Base address of CSR block              */
    volatile uint32_t *imem_base;   /* Base address of IMEM (32-bit writes)   */
    volatile uint8_t  *dmem_base;   /* Base address of DMEM (byte-addressable)*/
    uint32_t n_cores;               /* Number of cores                        */
    uint32_t vlen;                  /* Vector length                          */
    uint32_t scratch_size;          /* Words per core                         */
} vliw_handle_t;

/* ==================== API Functions ==================== */

/**
 * Initialize driver handle with base addresses.
 * Queries hardware config registers to populate structure.
 *
 * @param h      Handle to initialize
 * @param csr    Virtual address of CSR block (typically 0x..xxx_0000)
 * @param imem   Virtual address of IMEM block (typically 0x..xxx_0400)
 * @param dmem   Virtual address of DMEM block (typically 0x..xxx_0800)
 */
void vliw_init(vliw_handle_t *h, uint32_t *csr, uint32_t *imem, uint8_t *dmem);

/**
 * Write a single 32-bit instruction word to core's IMEM at byte offset.
 *
 * @param h      Initialized handle
 * @param core   Core index (0..n_cores-1)
 * @param addr   Word address in IMEM (0..imem_depth-1)
 * @param data   32-bit instruction word or bundle word
 *
 * Note: If bundle width > 32 bits, call once per 32-bit chunk.
 * Accumulator in hardware commits on last word of bundle.
 */
void vliw_imem_write_word(vliw_handle_t *h, uint32_t core, uint32_t addr, uint32_t data);

/**
 * Write multi-word instruction bundle to IMEM.
 *
 * @param h      Initialized handle
 * @param core   Core index
 * @param addr   Bundle address in IMEM
 * @param bundle Pointer to bundle data (width = cfg.bundleWidth bits)
 * @param size   Bundle size in bytes
 */
void vliw_imem_write_bundle(vliw_handle_t *h, uint32_t core, uint32_t addr, 
                             const uint8_t *bundle, size_t size);

/**
 * Start all cores (pulse CTRL.START).
 * Hardware takes 1 cycle to process; execution begins cycle N+1.
 *
 * @param h Initialized handle
 */
void vliw_start(vliw_handle_t *h);

/**
 * Poll until all cores have halted.
 * Reads STATUS register repeatedly until all halted bits are set.
 *
 * @param h        Initialized handle
 * @param timeout  Max poll iterations (0 = no limit)
 * @return         0 if all halted, -1 if timeout
 */
int vliw_wait_halted(vliw_handle_t *h, uint32_t timeout);

/**
 * Read global cycle counter.
 *
 * @param h Initialized handle
 * @return  Cycle count since last reset
 */
uint32_t vliw_get_cycles(vliw_handle_t *h);

/**
 * Read per-core cycle count.
 *
 * @param h    Initialized handle
 * @param core Core index
 * @return     Cycle count for that core
 */
uint32_t vliw_get_core_cycles(vliw_handle_t *h, uint32_t core);

/**
 * Read per-core program counter.
 *
 * @param h    Initialized handle
 * @param core Core index
 * @return     Current PC (IMEM address)
 */
uint32_t vliw_get_core_pc(vliw_handle_t *h, uint32_t core);

/**
 * Soft reset: pulse CTRL.RESET.
 * Clears all core state and halts execution.
 *
 * @param h Initialized handle
 */
void vliw_reset(vliw_handle_t *h);

/**
 * Read from shared DMEM (byte-level).
 *
 * @param h      Initialized handle
 * @param addr   Byte address in DMEM (0..dmem_size-1)
 * @param data   Output buffer
 * @param len    Bytes to read
 */
void vliw_dmem_read(vliw_handle_t *h, uint32_t addr, uint8_t *data, size_t len);

/**
 * Write to shared DMEM (byte-level).
 *
 * @param h      Initialized handle
 * @param addr   Byte address in DMEM
 * @param data   Input buffer
 * @param len    Bytes to write
 */
void vliw_dmem_write(vliw_handle_t *h, uint32_t addr, const uint8_t *data, size_t len);

/**
 * Helper: read 32-bit word from CSR.
 */
static inline uint32_t vliw_csr_read(vliw_handle_t *h, uint32_t offset) {
    return h->csr_base[offset >> 2];
}

/**
 * Helper: write 32-bit word to CSR.
 */
static inline void vliw_csr_write(vliw_handle_t *h, uint32_t offset, uint32_t val) {
    h->csr_base[offset >> 2] = val;
}

#endif /* __VLIW_DRIVER_H__ */
