"""
VliwCore integration test harness.

Provides a reusable test harness that:
  - Initializes clock and reset
  - Loads programs (from assembler output) into IMEM
  - Pre-loads AXI memory with data
  - Starts the core and waits for halt
  - Reads back AXI memory for result verification

Uses the assembler from tools/assembler.py and the AXI memory model.
"""

import inspect
import json
import os
import sys
from pathlib import Path

# Add project root to path for assembler import
PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT / "tools") not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT / "tools"))

import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge

from assembler import Assembler, AssemblerConfig
from axi_mem_model import Axi4MemoryModel


class VliwCoreHarness:
    """
    Reusable test harness for VliwCore integration tests.

    Usage:
        harness = VliwCoreHarness(dut)
        harness.axi_mem.preload(0x1000, [1, 2, 3, 4])
        await harness.init()
        program = asm.assemble_program([...])
        await harness.load_program(program)
        cycles = await harness.run()
        result = harness.axi_mem.read_word(0x2000)
    """

    def __init__(self, dut, clock_period_ns: int = 10, mem_words: int = 16384,
                 axi_latency: int = 0):
        self.dut = dut
        self.clock_period = clock_period_ns
        self.axi_mem = Axi4MemoryModel(dut, "io_dmemAxi", mem_words, axi_latency)

    async def init(self, reset_cycles: int = 5):
        """Initialize clock, reset, and tie off control signals."""
        cocotb.start_soon(Clock(self.dut.clk, self.clock_period, units="ns").start())

        # Drive all inputs to safe defaults
        self.dut.reset.value = 1
        self.dut.io_start.value = 0
        self.dut.io_imemWrite_valid.value = 0
        self.dut.io_imemWrite_payload_addr.value = 0
        self.dut.io_imemWrite_payload_data.value = 0

        # AXI defaults (before memory model takes over)
        self.dut.io_dmemAxi_aw_ready.value = 0
        self.dut.io_dmemAxi_w_ready.value = 0
        self.dut.io_dmemAxi_b_valid.value = 0
        self.dut.io_dmemAxi_b_payload_id.value = 0
        self.dut.io_dmemAxi_b_payload_resp.value = 0
        self.dut.io_dmemAxi_ar_ready.value = 0
        self.dut.io_dmemAxi_r_valid.value = 0
        self.dut.io_dmemAxi_r_payload_data.value = 0
        self.dut.io_dmemAxi_r_payload_id.value = 0
        self.dut.io_dmemAxi_r_payload_resp.value = 0
        self.dut.io_dmemAxi_r_payload_last.value = 1

        for _ in range(reset_cycles):
            await RisingEdge(self.dut.clk)
        self.dut.reset.value = 0
        await RisingEdge(self.dut.clk)

        # Start AXI memory model
        self.axi_mem.start()

    async def load_program(self, bundles: list):
        """Load a list of 256-bit bundle integers into IMEM via io_imemWrite."""
        rtl_width = len(self.dut.io_imemWrite_payload_data)
        for addr, bundle in enumerate(bundles):
            if bundle >> rtl_width:
                raise AssertionError(
                    f"Bundle width mismatch: bundle at addr {addr} exceeds RTL IMEM width {rtl_width} bits"
                )
            self.dut.io_imemWrite_valid.value = 1
            self.dut.io_imemWrite_payload_addr.value = addr
            self.dut.io_imemWrite_payload_data.value = bundle
            await RisingEdge(self.dut.clk)
        self.dut.io_imemWrite_valid.value = 0
        await RisingEdge(self.dut.clk)

    async def start(self):
        """Pulse io_start to begin execution."""
        self.dut.io_start.value = 1
        await RisingEdge(self.dut.clk)
        self.dut.io_start.value = 0

    async def run(self, max_cycles: int = 500, drain_cycles: int = 20) -> int:
        """Start the core and wait for halt. Returns number of cycles.
        
        After halt, continues for drain_cycles to allow pending AXI
        transactions to complete (e.g. stores that were in-flight).
        Stops AXI model coroutines to prevent leaking into subsequent tests.
        """
        await self.start()
        caller_test = inspect.stack()[1].function
        for i in range(max_cycles):
            await RisingEdge(self.dut.clk)
            try:
                halted = int(self.dut.io_halted.value)
            except ValueError:
                # X/Z values during pipeline startup — treat as not halted
                halted = 0
            if halted == 1:
                cycles = i + 1
                # Drain remaining AXI transactions
                for _ in range(drain_cycles):
                    await RisingEdge(self.dut.clk)
                self.dut._log.info(f"[cycles] halted after {cycles} cycles")
                self._emit_cycle_metric(caller_test, cycles)
                # Stop AXI model to prevent coroutine leakage between tests
                self.axi_mem.stop()
                return cycles
        self.axi_mem.stop()
        self.dut._log.info(f"[cycles] timeout after {max_cycles} cycles")
        self._emit_cycle_metric(caller_test, "timeout")
        raise AssertionError(f"Core did not halt within {max_cycles} cycles")

    def _emit_cycle_metric(self, test_name: str, cycles):
        metric_path = os.getenv("VLIW_CYCLE_METRICS_FILE")
        if not metric_path:
            return
        payload = {"test": test_name, "cycles": cycles}
        path = Path(metric_path)
        path.parent.mkdir(parents=True, exist_ok=True)
        with path.open("a", encoding="utf-8") as fp:
            fp.write(json.dumps(payload) + "\n")

    async def run_and_trace(self, max_cycles: int = 500) -> list:
        """Start core, trace PC each cycle, return trace list."""
        await self.start()
        trace = []
        for i in range(max_cycles):
            await RisingEdge(self.dut.clk)
            pc = int(self.dut.io_pc.value)
            halted = int(self.dut.io_halted.value)
            running = int(self.dut.io_running.value)
            trace.append({"cycle": i, "pc": pc, "halted": halted, "running": running})
            if halted:
                return trace
        raise AssertionError(f"Core did not halt within {max_cycles} cycles")

    @property
    def cycle_count(self) -> int:
        return int(self.dut.io_cycleCount.value)

    @property
    def pc(self) -> int:
        return int(self.dut.io_pc.value)

    @property
    def halted(self) -> bool:
        return int(self.dut.io_halted.value) == 1

    @property
    def running(self) -> bool:
        return int(self.dut.io_running.value) == 1
