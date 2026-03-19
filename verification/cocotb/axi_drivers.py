"""
AXI4-Lite driver utilities for cocotb verification.

Provides simple read/write helpers for both the CSR interface (HostInterface)
and the IMEM loading port.
"""

import cocotb
from cocotb.triggers import RisingEdge, Timer, ReadOnly
from cocotb.handle import SimHandleBase
import math


class AxiLiteDriver:
    """
    Simple AXI4-Lite master driver for cocotb.

    Drives AW, W channels and waits for B response (writes).
    Drives AR channel and waits for R response (reads).
    """

    def __init__(self, dut, prefix: str, clock):
        """
        Args:
            dut: cocotb DUT handle
            prefix: signal prefix (e.g., "io_csrAxi" for the CSR port)
            clock: clock signal
        """
        self.dut = dut
        self.prefix = prefix
        self.clock = clock

    def _sig(self, name: str):
        return getattr(self.dut, f"{self.prefix}_{name}")

    async def _wait_for(self, signal_name: str, timeout_cycles: int, message: str):
        for _ in range(timeout_cycles):
            await RisingEdge(self.clock)
            if int(self._sig(signal_name).value) == 1:
                return
        raise AssertionError(f"{self.prefix}: {message}")

    async def write(self, addr: int, data: int, timeout_cycles: int = 100):
        """Perform an AXI4-Lite write transaction."""
        clock = self.clock

        # Drive AW channel
        self._sig("aw_valid").value = 1
        self._sig("aw_payload_addr").value = addr
        # Drive W channel
        self._sig("w_valid").value = 1
        self._sig("w_payload_data").value = data
        self._sig("w_payload_strb").value = 0xF

        # Wait for both AW and W to be accepted
        aw_done = False
        w_done = False
        for _ in range(timeout_cycles):
            await RisingEdge(clock)
            if not aw_done and self._sig("aw_ready").value:
                aw_done = True
                self._sig("aw_valid").value = 0
            if not w_done and self._sig("w_ready").value:
                w_done = True
                self._sig("w_valid").value = 0
            if aw_done and w_done:
                break
        else:
            raise AssertionError(f"{self.prefix}: AXI-Lite write AW/W handshake timed out at 0x{addr:X}")

        # Wait for B response
        self._sig("b_ready").value = 1
        await self._wait_for("b_valid", timeout_cycles, f"AXI-Lite write response timed out at 0x{addr:X}")
        self._sig("b_ready").value = 0
        await RisingEdge(clock)

    async def read(self, addr: int, timeout_cycles: int = 100) -> int:
        """Perform an AXI4-Lite read transaction. Returns data."""
        clock = self.clock

        # Drive AR channel
        self._sig("ar_valid").value = 1
        self._sig("ar_payload_addr").value = addr

        # Wait for AR accept
        await self._wait_for("ar_ready", timeout_cycles, f"AXI-Lite read address handshake timed out at 0x{addr:X}")
        self._sig("ar_valid").value = 0

        # Wait for R response
        self._sig("r_ready").value = 1
        await self._wait_for("r_valid", timeout_cycles, f"AXI-Lite read data timed out at 0x{addr:X}")
        data = int(self._sig("r_payload_data").value)
        self._sig("r_ready").value = 0
        await RisingEdge(clock)
        return data


class Axi4Driver:
    """
    Simple AXI4 (full) master driver for cocotb.

    Supports single-beat read/write transactions.
    """

    def __init__(self, dut, prefix: str, clock):
        self.dut = dut
        self.prefix = prefix
        self.clock = clock

    def _sig(self, name: str):
        return getattr(self.dut, f"{self.prefix}_{name}")

    def _beat_bytes(self) -> int:
        return len(self._sig("w_payload_data")) // 8

    def _size_code(self) -> int:
        return int(math.log2(self._beat_bytes()))

    def _full_strb(self) -> int:
        return (1 << self._beat_bytes()) - 1

    async def _wait_for(self, signal_name: str, timeout_cycles: int, message: str):
        for _ in range(timeout_cycles):
            await RisingEdge(self.clock)
            if int(self._sig(signal_name).value) == 1:
                return
        raise AssertionError(f"{self.prefix}: {message}")

    async def write_single(self, addr: int, data: int, axi_id: int = 0, strb: int | None = None, timeout_cycles: int = 100):
        """Single-beat AXI4 write. Returns the BRESP code."""
        resp, _ = await self.write_single_with_meta(addr, data, axi_id=axi_id, strb=strb, timeout_cycles=timeout_cycles)
        return resp

    async def write_single_with_meta(self, addr: int, data: int, axi_id: int = 0, strb: int | None = None, timeout_cycles: int = 100):
        """Single-beat AXI4 write. Returns ``(bresp, bid)``."""
        clock = self.clock
        if strb is None:
            strb = self._full_strb()

        # AW
        self._sig("aw_valid").value = 1
        self._sig("aw_payload_addr").value = addr
        self._sig("aw_payload_id").value = axi_id
        self._sig("aw_payload_len").value = 0     # 1 beat
        self._sig("aw_payload_size").value = self._size_code()
        self._sig("aw_payload_burst").value = 1   # INCR

        await self._wait_for("aw_ready", timeout_cycles, f"AXI4 write address handshake timed out at 0x{addr:X}")
        self._sig("aw_valid").value = 0

        # W
        self._sig("w_valid").value = 1
        self._sig("w_payload_data").value = data
        self._sig("w_payload_strb").value = strb
        self._sig("w_payload_last").value = 1

        await self._wait_for("w_ready", timeout_cycles, f"AXI4 write data handshake timed out at 0x{addr:X}")
        self._sig("w_valid").value = 0

        # B
        self._sig("b_ready").value = 1
        await self._wait_for("b_valid", timeout_cycles, f"AXI4 write response timed out at 0x{addr:X}")
        resp = int(self._sig("b_payload_resp").value)
        bid = int(self._sig("b_payload_id").value)
        self._sig("b_ready").value = 0
        await RisingEdge(clock)
        return resp, bid

    async def read_single(self, addr: int, axi_id: int = 0, timeout_cycles: int = 100) -> int:
        """Single-beat AXI4 read. Returns the data word."""
        data, _, _, _ = await self.read_single_with_meta(addr, axi_id=axi_id, timeout_cycles=timeout_cycles)
        return data

    async def read_word(self, addr: int, axi_id: int = 0, timeout_cycles: int = 100) -> int:
        """Single-beat AXI4 read returning the addressed 32-bit word within the beat."""
        clock = self.clock

        self._sig("ar_valid").value = 1
        self._sig("ar_payload_addr").value = addr
        self._sig("ar_payload_id").value = axi_id
        self._sig("ar_payload_len").value = 0
        self._sig("ar_payload_size").value = self._size_code()
        self._sig("ar_payload_burst").value = 1

        await self._wait_for("ar_ready", timeout_cycles, f"AXI4 read address handshake timed out at 0x{addr:X}")
        self._sig("ar_valid").value = 0

        self._sig("r_ready").value = 1
        await self._wait_for("r_valid", timeout_cycles, f"AXI4 read data timed out at 0x{addr:X}")
        data_value = self._sig("r_payload_data").value
        byte_offset = addr % self._beat_bytes()
        bit_offset = byte_offset * 8
        word_value = int(data_value[bit_offset + 31:bit_offset])
        self._sig("r_ready").value = 0
        await RisingEdge(clock)
        return word_value

    async def read_single_with_meta(self, addr: int, axi_id: int = 0, timeout_cycles: int = 100):
        """Single-beat AXI4 read. Returns ``(data, rresp, rid, last)``."""
        clock = self.clock

        # AR
        self._sig("ar_valid").value = 1
        self._sig("ar_payload_addr").value = addr
        self._sig("ar_payload_id").value = axi_id
        self._sig("ar_payload_len").value = 0
        self._sig("ar_payload_size").value = self._size_code()
        self._sig("ar_payload_burst").value = 1

        await self._wait_for("ar_ready", timeout_cycles, f"AXI4 read address handshake timed out at 0x{addr:X}")
        self._sig("ar_valid").value = 0

        # R
        self._sig("r_ready").value = 1
        await self._wait_for("r_valid", timeout_cycles, f"AXI4 read data timed out at 0x{addr:X}")
        data = int(self._sig("r_payload_data").value)
        resp = int(self._sig("r_payload_resp").value)
        rid = int(self._sig("r_payload_id").value)
        last = int(self._sig("r_payload_last").value)
        self._sig("r_ready").value = 0
        await RisingEdge(clock)
        return data, resp, rid, last

    async def write_burst_with_meta(self, addr: int, data_words, axi_id: int = 0, strbs=None):
        """Incrementing AXI4 write burst. Returns ``(bresp, bid)``."""
        if not data_words:
            raise ValueError("write_burst_with_meta requires at least one data beat")

        clock = self.clock
        beat_count = len(data_words)
        full_strb = (1 << self._beat_bytes()) - 1
        if strbs is None:
            strbs = [full_strb] * beat_count
        if len(strbs) != beat_count:
            raise ValueError("strbs length must match data_words length")

        self._sig("aw_valid").value = 1
        self._sig("aw_payload_addr").value = addr
        self._sig("aw_payload_id").value = axi_id
        self._sig("aw_payload_len").value = beat_count - 1
        self._sig("aw_payload_size").value = self._size_code()
        self._sig("aw_payload_burst").value = 1

        while True:
            await RisingEdge(clock)
            if self._sig("aw_ready").value:
                break
        self._sig("aw_valid").value = 0

        for idx, (data_word, strb) in enumerate(zip(data_words, strbs)):
            self._sig("w_valid").value = 1
            self._sig("w_payload_data").value = data_word
            self._sig("w_payload_strb").value = strb
            self._sig("w_payload_last").value = 1 if idx == beat_count - 1 else 0

            while True:
                await RisingEdge(clock)
                if self._sig("w_ready").value:
                    break
            self._sig("w_valid").value = 0

        self._sig("b_ready").value = 1
        while True:
            await RisingEdge(clock)
            if self._sig("b_valid").value:
                resp = int(self._sig("b_payload_resp").value)
                bid = int(self._sig("b_payload_id").value)
                break
        self._sig("b_ready").value = 0
        await RisingEdge(clock)
        return resp, bid

    async def write_burst(self, addr: int, data_words, axi_id: int = 0, strbs=None):
        resp, _ = await self.write_burst_with_meta(addr, data_words, axi_id=axi_id, strbs=strbs)
        return resp

    async def read_burst_with_meta(self, addr: int, beats: int, axi_id: int = 0):
        """Incrementing AXI4 read burst. Returns ``(data_words, rresp_list, rid_list, last_list)``."""
        if beats <= 0:
            raise ValueError("read_burst_with_meta requires beats > 0")

        clock = self.clock
        self._sig("ar_valid").value = 1
        self._sig("ar_payload_addr").value = addr
        self._sig("ar_payload_id").value = axi_id
        self._sig("ar_payload_len").value = beats - 1
        self._sig("ar_payload_size").value = self._size_code()
        self._sig("ar_payload_burst").value = 1

        while True:
            await RisingEdge(clock)
            if self._sig("ar_ready").value:
                break
        self._sig("ar_valid").value = 0

        data_words = []
        resps = []
        ids = []
        lasts = []
        self._sig("r_ready").value = 1
        while len(data_words) < beats:
            await RisingEdge(clock)
            if self._sig("r_valid").value:
                data_words.append(int(self._sig("r_payload_data").value))
                resps.append(int(self._sig("r_payload_resp").value))
                ids.append(int(self._sig("r_payload_id").value))
                lasts.append(int(self._sig("r_payload_last").value))
        self._sig("r_ready").value = 0
        await RisingEdge(clock)
        return data_words, resps, ids, lasts

    async def read_burst(self, addr: int, beats: int, axi_id: int = 0):
        data_words, _, _, _ = await self.read_burst_with_meta(addr, beats, axi_id=axi_id)
        return data_words
