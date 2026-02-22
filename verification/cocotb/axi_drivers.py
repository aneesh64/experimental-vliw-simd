"""
AXI4-Lite driver utilities for cocotb verification.

Provides simple read/write helpers for both the CSR interface (HostInterface)
and the IMEM loading port.
"""

import cocotb
from cocotb.triggers import RisingEdge, Timer, ReadOnly
from cocotb.handle import SimHandleBase


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

    async def write(self, addr: int, data: int):
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
        while not (aw_done and w_done):
            await RisingEdge(clock)
            if not aw_done and self._sig("aw_ready").value:
                aw_done = True
                self._sig("aw_valid").value = 0
            if not w_done and self._sig("w_ready").value:
                w_done = True
                self._sig("w_valid").value = 0

        # Wait for B response
        self._sig("b_ready").value = 1
        while True:
            await RisingEdge(clock)
            if self._sig("b_valid").value:
                break
        self._sig("b_ready").value = 0
        await RisingEdge(clock)

    async def read(self, addr: int) -> int:
        """Perform an AXI4-Lite read transaction. Returns data."""
        clock = self.clock

        # Drive AR channel
        self._sig("ar_valid").value = 1
        self._sig("ar_payload_addr").value = addr

        # Wait for AR accept
        while True:
            await RisingEdge(clock)
            if self._sig("ar_ready").value:
                break
        self._sig("ar_valid").value = 0

        # Wait for R response
        self._sig("r_ready").value = 1
        while True:
            await RisingEdge(clock)
            if self._sig("r_valid").value:
                data = int(self._sig("r_payload_data").value)
                break
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

    async def write_single(self, addr: int, data: int, axi_id: int = 0):
        """Single-beat AXI4 write."""
        clock = self.clock

        # AW
        self._sig("aw_valid").value = 1
        self._sig("aw_payload_addr").value = addr
        self._sig("aw_payload_id").value = axi_id
        self._sig("aw_payload_len").value = 0     # 1 beat
        self._sig("aw_payload_size").value = 2    # 4 bytes
        self._sig("aw_payload_burst").value = 1   # INCR

        while True:
            await RisingEdge(clock)
            if self._sig("aw_ready").value:
                break
        self._sig("aw_valid").value = 0

        # W
        self._sig("w_valid").value = 1
        self._sig("w_payload_data").value = data
        self._sig("w_payload_strb").value = 0xF
        self._sig("w_payload_last").value = 1

        while True:
            await RisingEdge(clock)
            if self._sig("w_ready").value:
                break
        self._sig("w_valid").value = 0

        # B
        self._sig("b_ready").value = 1
        while True:
            await RisingEdge(clock)
            if self._sig("b_valid").value:
                break
        self._sig("b_ready").value = 0
        await RisingEdge(clock)

    async def read_single(self, addr: int, axi_id: int = 0) -> int:
        """Single-beat AXI4 read."""
        clock = self.clock

        # AR
        self._sig("ar_valid").value = 1
        self._sig("ar_payload_addr").value = addr
        self._sig("ar_payload_id").value = axi_id
        self._sig("ar_payload_len").value = 0
        self._sig("ar_payload_size").value = 2
        self._sig("ar_payload_burst").value = 1

        while True:
            await RisingEdge(clock)
            if self._sig("ar_ready").value:
                break
        self._sig("ar_valid").value = 0

        # R
        self._sig("r_ready").value = 1
        while True:
            await RisingEdge(clock)
            if self._sig("r_valid").value:
                data = int(self._sig("r_payload_data").value)
                break
        self._sig("r_ready").value = 0
        await RisingEdge(clock)
        return data
