"""
AXI4 Memory Model for cocotb simulation — 512-bit data bus.

Provides a simulated AXI4 slave memory that the VliwCore's MemoryEngine
talks to for load/store operations. Supports:
  - Single-beat reads (LOAD / VLOAD) — 512-bit per beat
  - Single-beat writes (STORE / VSTORE) — 512-bit per beat, WSTRB-masked
  - Configurable latency
  - Memory pre-loading and readback for verification

All AXI transfers are single-beat (AxLEN=0, SIZE=6). The MemoryEngine
places 32-bit scalars or 8×32-bit vectors within the 512-bit data word
and uses WSTRB byte strobes to select which bytes are written.
"""

import cocotb
from cocotb.triggers import RisingEdge


class Axi4MemoryModel:
    """
    AXI4 slave memory model driven by cocotb coroutines.

    Memory is word-addressed internally (32-bit words).
    AXI uses byte addresses; this model packs/unpacks 16 words per 512-bit beat.

    Args:
        dut:       The DUT handle
        prefix:    AXI signal prefix (e.g., "io_dmemAxi")
        mem_words: Number of 32-bit words
        latency:   Read latency in cycles (0 = next cycle)
        data_width_bits: AXI data bus width (default 512)
    """

    def __init__(self, dut, prefix: str = "io_dmemAxi", mem_words: int = 16384,
                 latency: int = 0, data_width_bits: int = 512):
        self.dut = dut
        self.prefix = prefix
        self.mem = [0] * mem_words
        self.mem_words = mem_words
        self.latency = latency
        self.data_width_bits = data_width_bits
        self.data_bytes = data_width_bits // 8        # 64 for 512-bit
        self.words_per_beat = data_width_bits // 32   # 16 for 512-bit
        self._running = False
        self._tasks = []

    def _sig(self, name: str):
        """Get a DUT signal by name under the AXI prefix."""
        return getattr(self.dut, f"{self.prefix}_{name}")

    def preload(self, addr_word: int, data: list):
        """Pre-load memory starting at word address."""
        for i, val in enumerate(data):
            if addr_word + i < self.mem_words:
                self.mem[addr_word + i] = val & 0xFFFFFFFF

    def read_word(self, addr_word: int) -> int:
        """Read a single word from memory."""
        if 0 <= addr_word < self.mem_words:
            return self.mem[addr_word]
        return 0

    def read_region(self, addr_word: int, count: int) -> list:
        """Read a region of memory."""
        return [self.read_word(addr_word + i) for i in range(count)]

    def start(self):
        """Start the AXI slave coroutines."""
        if not self._running:
            self._running = True
            self._tasks.append(cocotb.start_soon(self._ar_channel()))
            self._tasks.append(cocotb.start_soon(self._aw_w_channel()))

    def stop(self):
        """Stop the AXI slave coroutines and prevent further transactions."""
        self._running = False
        for task in self._tasks:
            try:
                task.kill()
            except Exception:
                pass
        self._tasks.clear()

    def _pack_beat(self, base_word_addr: int) -> int:
        """Pack words_per_beat consecutive 32-bit words into a single integer."""
        value = 0
        for w in range(self.words_per_beat):
            wa = (base_word_addr + w) % self.mem_words
            value |= (self.mem[wa] & 0xFFFFFFFF) << (w * 32)
        return value

    def _unpack_beat(self, base_word_addr: int, data: int, strb: int):
        """Unpack a data beat into memory using WSTRB byte-level masking."""
        for byte_idx in range(self.data_bytes):
            if strb & (1 << byte_idx):
                word_idx = byte_idx // 4
                byte_in_word = byte_idx % 4
                wa = (base_word_addr + word_idx) % self.mem_words
                byte_val = (data >> (byte_idx * 8)) & 0xFF
                # Clear and set the specific byte
                mask = 0xFF << (byte_in_word * 8)
                self.mem[wa] = (self.mem[wa] & ~mask) | (byte_val << (byte_in_word * 8))

    async def _ar_channel(self):
        """Handle AXI read (AR + R) transactions — single-beat, 512-bit."""
        while self._running:
            await RisingEdge(self.dut.clk)

            try:
                ar_valid = int(self._sig("ar_valid").value)
            except Exception:
                continue

            if ar_valid:
                try:
                    addr = int(self._sig("ar_payload_addr").value)
                except ValueError:
                    # X/Z on address — complete the handshake with zero data
                    # to avoid permanently blocking the requester.
                    addr = 0
                burst_len = int(self._sig("ar_payload_len").value)  # should be 0

                # Accept AR
                self._sig("ar_ready").value = 1
                await RisingEdge(self.dut.clk)
                self._sig("ar_ready").value = 0

                # Optional read latency
                for _ in range(self.latency):
                    await RisingEdge(self.dut.clk)

                # Base word address: byte_addr aligned down to beat boundary
                base_word = (addr >> 2) & ~(self.words_per_beat - 1)

                # Send R beats (typically just 1)
                for beat in range(burst_len + 1):
                    beat_base = (base_word + beat * self.words_per_beat) % self.mem_words
                    data = self._pack_beat(beat_base)

                    self._sig("r_valid").value = 1
                    self._sig("r_payload_data").value = data
                    self._sig("r_payload_resp").value = 0  # OKAY
                    self._sig("r_payload_id").value = 0
                    self._sig("r_payload_last").value = 1 if beat == burst_len else 0

                    # Wait for R handshake
                    while True:
                        await RisingEdge(self.dut.clk)
                        try:
                            if int(self._sig("r_ready").value):
                                break
                        except Exception:
                            break

                self._sig("r_valid").value = 0

    async def _aw_w_channel(self):
        """Handle AXI write (AW + W + B) transactions — 512-bit with WSTRB."""
        while self._running:
            await RisingEdge(self.dut.clk)

            try:
                aw_valid = int(self._sig("aw_valid").value)
            except Exception:
                continue

            if aw_valid:
                try:
                    addr = int(self._sig("aw_payload_addr").value)
                except ValueError:
                    # X/Z on address — complete the handshake with dummy write
                    # to avoid permanently blocking the requester.
                    addr = 0
                burst_len = int(self._sig("aw_payload_len").value)  # should be 0

                # Accept AW
                self._sig("aw_ready").value = 1
                await RisingEdge(self.dut.clk)
                self._sig("aw_ready").value = 0

                # Base word address aligned to beat boundary
                base_word = (addr >> 2) & ~(self.words_per_beat - 1)

                # Receive W beats
                for beat in range(burst_len + 1):
                    # Wait for w_valid WITHOUT asserting w_ready
                    while True:
                        await RisingEdge(self.dut.clk)
                        try:
                            if int(self._sig("w_valid").value):
                                break
                        except Exception:
                            pass

                    # Capture data and strobe
                    beat_base = (base_word + beat * self.words_per_beat) % self.mem_words
                    try:
                        data = int(self._sig("w_payload_data").value)
                    except ValueError:
                        # X/Z bits in write data — treat as 0 (best effort)
                        data = 0
                    try:
                        strb = int(self._sig("w_payload_strb").value)
                    except Exception:
                        # Fallback: if no strb signal, write all bytes
                        strb = (1 << self.data_bytes) - 1

                    self._unpack_beat(beat_base, data, strb)

                    # Assert w_ready to complete handshake
                    self._sig("w_ready").value = 1
                    await RisingEdge(self.dut.clk)
                    self._sig("w_ready").value = 0

                # Send B response
                self._sig("b_valid").value = 1
                self._sig("b_payload_resp").value = 0  # OKAY
                self._sig("b_payload_id").value = 0
                while True:
                    await RisingEdge(self.dut.clk)
                    try:
                        if int(self._sig("b_ready").value):
                            break
                    except Exception:
                        break
                self._sig("b_valid").value = 0
