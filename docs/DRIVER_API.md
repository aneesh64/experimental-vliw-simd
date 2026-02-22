# VLIW SoC Driver Interface Specification

## Overview

The VLIW SoC exposes itself as a memory-mapped co-processor peripheral. A **driver** (hardware + software) manages the control flow: loading programs, starting execution, and retrieving results.

---

## 1. Memory Map

All addresses are byte-addressable. The SoC occupies a contiguous 4 KB region (configurable).

```
┌─────────────────────────────────────────┐
│ VliwSimdSoc Memory Map (Base + Offset)  │
├─────────────────┬──────────┬────────────┤
│ Offset   │ Name │ RW │ Reset │ Width │
├─────────────────┼──────────┼────────────┤
│ 0x000    │ CTRL │ RW │ 0x0   │ 32b   │
│ 0x004    │ STAT │ R  │ 0x0   │ 32b   │
│ 0x008    │ PC   │ R  │ 0x0   │ 32b   │
│ 0x00C    │ CYCS │ R  │ 0x0   │ 32b   │
│ 0x010    │ IMBAS│ RW │ 0x0   │ 32b   │
│ 0x014    │ IMWD │ W  │ 0x0   │ 32b   │
│ 0x018    │ SCRA │ RW │ 0x0   │ 32b   │
│ 0x01C    │ SCRD │ RW │ 0x0   │ 32b   │
│ 0x020    │ DMWA │ RW │ 0x0   │ 32b   │
│ 0x024    │ DMWD │ RW │ 0x0   │ 32b   │
│ ...      │ ...  │    │       │       │
│ 0x400... │ IMEM │ R  │ 0x0   │ Data  │
│ 0x800... │ DMEM │ RW │ 0x0   │ Data  │
└─────────────────┴──────────┴────────────┘
```

---

## 2. Control Register (CTRL @ 0x000)

### Bit Fields

| Bits | Name | RW | Function |
|------|------|----|-|
| 0 | **START** | W  | Pulse to begin execution (auto-clears) |
| 1 | **RESET** | W  | Assert to reset all cores (auto-clears after 1 cycle) |
| 2 | **STOP** | W  | Halt execution immediately (debug) |
| 3-7 | (reserved) | - | - |
| 31-8 | (reserved) | - | - |

### Example: Start Execution

```c
volatile uint32_t *ctrl = (uint32_t*)(SOC_BASE + 0x000);
*ctrl = 0x1;  // Set START bit
// Hardware starts on next clock; bit auto-clears after 1 cycle
```

---

## 3. Status Register (STAT @ 0x004)

### Bit Fields

| Bits | Name | RW | Meaning |
|------|------|----|-|
| 0 | **HALTED** | R | True if all cores have halted (after halt instruction) |
| 1 | **ERROR** | R | True if error occurred (e.g., DMEM access out of bounds) |
| 2 | **MEM_STALL** | R | True if any core is stalled waiting for DMEM response |
| 3-31 | (reserved) | R | Reserved for future use |

### Example: Wait for Halt

```c
volatile uint32_t *stat = (uint32_t*)(SOC_BASE + 0x004);

// Poll until halted
while ((*stat & 0x1) == 0) {
    // Still running
    usleep(100);
}

if (*stat & 0x2) {
    fprintf(stderr, "ERROR bit set!\n");
    return -1;
}
```

---

## 4. Program Counter (PC @ 0x008) — Debug Only

Read the current PC of core 0 (for debugging/monitoring).

**Note:** In a multi-core system, this would be per-core. For simplicity, assumes single core initially.

---

## 5. Cycle Counter (CYCS @ 0x00C) — Debug Only

Increments every clock cycle. Useful for timing analysis.

```c
uint32_t start_cycles = *(uint32_t*)(SOC_BASE + 0x00C);
// ... run program ...
uint32_t end_cycles = *(uint32_t*)(SOC_BASE + 0x00C);
printf("Execution time: %u cycles\n", end_cycles - start_cycles);
```

---

## 6. Instruction Memory Load Protocol

### Writes to IMEM

The IMEM is loaded via two registers: address and data.

#### IMEM Base Address (IMBAS @ 0x010)

Specifies the starting bundle address for the next IMEM write(s).

```c
volatile uint32_t *imbas = (uint32_t*)(SOC_BASE + 0x010);
volatile uint32_t *imwd = (uint32_t*)(SOC_BASE + 0x014);

// Load program starting at bundle address 0
*imbas = 0x0;

// Write first bundle (4 words in LittleEndian order)
for (int i = 0; i < 4; i++) {
    *imwd = program_data[i];  // Word 0, Word 1, Word 2, Word 3
    // After word 3, the bundle is committed and IMBAS auto-increments
}

// Next bundle at address 1
for (int i = 0; i < 4; i++) {
    *imwd = program_data[4 + i];
}
```

#### Instruction Data (IMWD @ 0x014)

Write a 32-bit word of the bundle. The hardware accumulates words and commits the full bundle when the last word is written (auto-increment of IMBAS).

**Protocol:**
1. Write word 0: hardware buffers it
2. Write word 1: hardware buffers it
3. Write word 2: hardware buffers it
4. Write word 3: hardware buffers it, then **commits bundle** and increments IMBAS automatically

---

## 7. Scratch Memory Access (Debug CSR)

### SCRA: Scratch Address (0x018)

Specifies which scratch register to read/write (0–31 typically).

### SCRD: Scratch Data (0x01C)

- **Read:** Returns the data in the scratch register specified by SCRA
- **Write:** Updates the scratch register specified by SCRA

**Warning:** These CSR accesses occur outside the pipeline; reading during execution may see stale data.

```c
volatile uint32_t *scra = (uint32_t*)(SOC_BASE + 0x018);
volatile uint32_t *scrd = (uint32_t*)(SOC_BASE + 0x01C);

// Read scratch[5]
*scra = 5;
uint32_t val = *scrd;
printf("s[5] = 0x%x\n", val);

// Write scratch[10] = 0x1234
*scra = 10;
*scrd = 0x1234;
```

---

## 8. Data Memory Access (Optional CSR Bypass)

### DMWA: Data Memory Write Address (0x020)

Byte address for DMEM reads/writes via CSR (alternative to AXI).

### DMWD: Data Memory Write Data (0x024)

- **Read:** Returns word at DMWA
- **Write:** Writes word to DMWA

**Note:** Requires synchronization (can't access while cores are running).

---

## 9. Full Boot Sequence (Example)

```c
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#define SOC_BASE 0x80000000
#define SOC_CTRL   (SOC_BASE + 0x000)
#define SOC_STAT   (SOC_BASE + 0x004)
#define SOC_IMBAS  (SOC_BASE + 0x010)
#define SOC_IMWD   (SOC_BASE + 0x014)
#define SOC_SCRA   (SOC_BASE + 0x018)
#define SOC_SCRD   (SOC_BASE + 0x01C)

// Simplified program: increment s[0] by 1, store to mem[0]
const uint32_t program[] = {
    // Bundle 0: const(0, 0) — initialize s[0] = 0
    0x00000000, 0x00000000, 0x00000000, 0x00000001,
    
    // Bundle 1: add_imm(0, 0, 1) — s[0] += 1
    0x00000001, 0x00000000, 0x00000000, 0x00000001,
    
    // Bundle 2: store(0, 0) — mem[0] = s[0]
    0x00000000, 0x00000000, 0x00000000, 0x00000001,
    
    // Bundle 3: halt
    0x00000000, 0x00000000, 0x00000000, 0xFFFFFFFF,
};
const size_t program_bundles = 4;

int main() {
    // Reset
    volatile uint32_t *ctrl = (uint32_t*)SOC_CTRL;
    *ctrl = 0x2;  // Set RESET bit
    for (int i = 0; i < 10; i++) {
        volatile int j = 0; j++;  // Delay
    }
    *ctrl = 0x0;  // Clear RESET
    
    // Load program
    volatile uint32_t *imbas = (uint32_t*)SOC_IMBAS;
    volatile uint32_t *imwd = (uint32_t*)SOC_IMWD;
    
    *imbas = 0x0;  // Start at bundle 0
    
    for (int b = 0; b < program_bundles; b++) {
        for (int w = 0; w < 4; w++) {
            *imwd = program[b * 4 + w];
            printf("  Wrote bundle[%d].word[%d] = 0x%08x\n", b, w, program[b * 4 + w]);
        }
    }
    
    printf("Program loaded. Starting execution...\n");
    
    // Start
    *ctrl = 0x1;  // Set START bit
    
    // Wait for halt
    volatile uint32_t *stat = (uint32_t*)SOC_STAT;
    int timeout = 1000000;
    while ((*stat & 0x1) == 0 && timeout-- > 0) {
        // Polling
    }
    
    if (*stat & 0x1) {
        printf("Core halted successfully.\n");
    } else {
        fprintf(stderr, "Timeout waiting for halt!\n");
        return -1;
    }
    
    if (*stat & 0x2) {
        fprintf(stderr, "ERROR flag set!\n");
        return -1;
    }
    
    // Read result
    volatile uint32_t *scra = (uint32_t*)SOC_SCRA;
    volatile uint32_t *scrd = (uint32_t*)SOC_SCRD;
    
    *scra = 0;  // Read s[0]
    uint32_t result = *scrd;
    printf("s[0] after execution = %u\n", result);
    
    // Expected: s[0] = 1 (started at 0, incremented by 1)
    if (result == 1) {
        printf("SUCCESS: Result matches expected value.\n");
        return 0;
    } else {
        printf("FAIL: Expected 1, got %u\n", result);
        return -1;
    }
}
```

---

## 10. Linux Kernel Driver (Optional)

For embedded systems with a Linux kernel, a kernel module provides device access:

```c
// drivers/misc/vliw.c

#include <linux/module.h>
#include <linux/ioctl.h>
#include <asm/io.h>

#define VLIW_IOC_MAGIC  'V'
#define VLIW_IOC_START      _IO(VLIW_IOC_MAGIC, 1)
#define VLIW_IOC_RESET      _IO(VLIW_IOC_MAGIC, 2)
#define VLIW_IOC_WAIT_HALT  _IO(VLIW_IOC_MAGIC, 3)
#define VLIW_IOC_LOAD_PROG  _IOW(VLIW_IOC_MAGIC, 4, struct vliw_prog)

struct vliw_prog {
    uint32_t *bundles;
    size_t num_bundles;
};

struct vliw_device {
    void __iomem *base;
};

static struct vliw_device vliw_dev;

static long vliw_ioctl(struct file *file, unsigned int cmd, unsigned long arg) {
    switch (cmd) {
        case VLIW_IOC_START:
            iowrite32(0x1, vliw_dev.base + 0x000);  // CTRL.START
            return 0;
        
        case VLIW_IOC_RESET:
            iowrite32(0x2, vliw_dev.base + 0x000);  // CTRL.RESET
            msleep(1);
            iowrite32(0x0, vliw_dev.base + 0x000);
            return 0;
        
        case VLIW_IOC_WAIT_HALT:
            while ((ioread32(vliw_dev.base + 0x004) & 0x1) == 0) {
                cond_resched();
            }
            return 0;
        
        case VLIW_IOC_LOAD_PROG: {
            struct vliw_prog *prog = (struct vliw_prog*)arg;
            void __iomem *imbas = vliw_dev.base + 0x010;
            void __iomem *imwd = vliw_dev.base + 0x014;
            
            iowrite32(0, imbas);  // Start at bundle 0
            
            for (int i = 0; i < prog->num_bundles * 4; i++) {
                iowrite32(prog->bundles[i], imwd);
            }
            return 0;
        }
        
        default:
            return -ENOTTY;
    }
}

static const struct file_operations vliw_fops = {
    .owner = THIS_MODULE,
    .unlocked_ioctl = vliw_ioctl,
};

// Module registration...
```

**User-space usage:**

```c
#include <fcntl.h>
#include <unistd.h>
#include <sys/ioctl.h>

int fd = open("/dev/vliw0", O_RDWR);
ioctl(fd, VLIW_IOC_LOAD_PROG, &program_data);
ioctl(fd, VLIW_IOC_START);
ioctl(fd, VLIW_IOC_WAIT_HALT);
close(fd);
```

---

## 11. Testing Checklist

- [ ] Write/read CTRL, STAT registers
- [ ] Load simple 1-bundle program; verify execution
- [ ] Multi-bundle program with jumps
- [ ] Read scratch memory post-execution
- [ ] Verify cycle counter increments
- [ ] Test ERROR flag on invalid memory access
- [ ] Test MEM_STALL flag during DMEM operations
- [ ] Multi-core variant (if applies)

---

## 12. Performance Considerations

1. **IMEM load:** 4 words per bundle; ~1 µs per word over AXI (assumes 100 MHz clock)
2. **Execution:** Typically 10–10,000 cycles depending on workload
3. **Result readback:** Via CSR (slow, ~µs per word) or via AXI DMEM read (faster)

For large workloads, prefer AXI-based result transfer over CSR.

---

## Appendix A: Register Layout Summary

| Address | Reg | Width | Usage |
|---------|-----|-------|-------|
| 0x000 | CTRL | 32b | Write START/RESET/STOP bits |
| 0x004 | STAT | 32b | Read HALTED/ERROR/MEM_STALL |
| 0x008 | PC | 32b | Read debug PC |
| 0x00C | CYCS | 32b | Read cycle count |
| 0x010 | IMBAS | 32b | Write bundle address |
| 0x014 | IMWD | 32b | Write instruction word (4 per bundle) |
| 0x018 | SCRA | 32b | Write scratch address |
| 0x01C | SCRD | 32b | Read/write scratch data |
| 0x020 | DMWA | 32b | Write DMEM address |
| 0x024 | DMWD | 32b | Read/write DMEM data |

