/**
 * VLIW SoC Driver — C API for host control
 *
 * Exposes CSR register access, IMEM loading via DDR, and execution control.
 * Program bundles and data operands live in DDR.  The host writes them
 * directly (e.g., via Zynq PS memory controller), then triggers the
 * hardware IMEM loader through CSR registers.
 *
 * All CSR offsets are relative to the CSR base address.
 */

#ifndef __VLIW_DRIVER_H__
#define __VLIW_DRIVER_H__

#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>

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
#define VLIW_IMEM_SRC_ADDR     0x030   /* IMEM DDR source address (R/W)     */
#define VLIW_IMEM_BUNDLE_COUNT 0x034   /* IMEM bundle count (R/W)           */
#define VLIW_IMEM_STATUS       0x038   /* IMEM loader status (R)            */
#define VLIW_CORE_PC(n)   (0x100 + (n) * 4)   /* Core n PC (R)              */
#define VLIW_CORE_CYC(n)  (0x200 + (n) * 4)   /* Core n cycle count (R)     */

/* ==================== CTRL Register Bits ==================== */

#define VLIW_CTRL_START    (1U << 0)   /* Write 1 to start execution        */
#define VLIW_CTRL_RESET    (1U << 1)   /* Write 1 to reset all cores        */
#define VLIW_CTRL_LOAD     (1U << 2)   /* Write 1 to trigger IMEM load      */

/* ==================== STATUS Register Bits ==================== */

#define VLIW_STAT_RUNNING   (1U << 0)  /* Bit 0: any core running           */
#define VLIW_STAT_HALTED(n) (1U << ((n) + 1))  /* Bit [n+1]: core n halted   */

/* ==================== IMEM Status Register Bits ==================== */

#define VLIW_IMEM_STAT_BUSY (1U << 0)  /* Bit 0: loader busy                */
#define VLIW_IMEM_STAT_DONE (1U << 1)  /* Bit 1: loader done                */

/* ==================== Driver Handle ==================== */

typedef struct {
    volatile uint32_t *csr_base;    /* Base address of CSR block              */
    volatile uint8_t  *ddr_base;    /* Base address of DDR region (program+data) */
    uint32_t n_cores;               /* Number of cores                        */
    uint32_t vlen;                  /* Vector length                          */
    uint32_t scratch_size;          /* Words per core                         */
    uint32_t bundle_width;          /* Bundle width in bits                   */
} vliw_handle_t;

/* ==================== API Functions ==================== */

/**
 * Initialize driver handle.
 * Queries hardware config registers to populate structure.
 *
 * @param h      Handle to initialize
 * @param csr    Virtual address of CSR block
 * @param ddr    Virtual address of DDR region used for program+data
 */
void vliw_init(vliw_handle_t *h, uint32_t *csr, uint8_t *ddr);

/**
 * Load instruction bundles from DDR into on-chip IMEM.
 *
 * The caller must have already written the program bundles into DDR
 * at the specified byte address.  Each bundle occupies one AXI beat
 * (64 bytes for 512-bit AXI data bus), with the lower bundle_width
 * bits holding the instruction and the upper bits zero-padded.
 *
 * @param h            Initialized handle
 * @param ddr_addr     DDR byte address where bundles start
 * @param bundle_count Number of bundles to load
 * @param timeout      Max poll iterations (0 = no limit)
 * @return             0 if loaded successfully, -1 if timeout
 */
int vliw_load_program(vliw_handle_t *h, uint32_t ddr_addr,
                       uint32_t bundle_count, uint32_t timeout);

/**
 * Start all cores (pulse CTRL.START).
 *
 * @param h Initialized handle
 */
void vliw_start(vliw_handle_t *h);

/**
 * Poll until all cores have halted.
 *
 * @param h        Initialized handle
 * @param timeout  Max poll iterations (0 = no limit)
 * @return         0 if all halted, -1 if timeout
 */
int vliw_wait_halted(vliw_handle_t *h, uint32_t timeout);

/**
 * Read global cycle counter.
 */
uint32_t vliw_get_cycles(vliw_handle_t *h);

/**
 * Read per-core cycle count.
 */
uint32_t vliw_get_core_cycles(vliw_handle_t *h, uint32_t core);

/**
 * Read per-core program counter.
 */
uint32_t vliw_get_core_pc(vliw_handle_t *h, uint32_t core);

/**
 * Soft reset: pulse CTRL.RESET.
 */
void vliw_reset(vliw_handle_t *h);

/**
 * Read from DDR (byte-level).
 */
void vliw_ddr_read(vliw_handle_t *h, uint32_t offset, uint8_t *data, size_t len);

/**
 * Write to DDR (byte-level).
 */
void vliw_ddr_write(vliw_handle_t *h, uint32_t offset, const uint8_t *data, size_t len);

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
