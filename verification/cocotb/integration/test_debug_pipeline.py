"""Standalone diagnostic test for pipelined tiled vector add."""
import sys, os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..')))
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), '..', 'tools')))

import cocotb
from cocotb.triggers import RisingEdge, ReadOnly, Timer
from test_integration_common import *
from tools.dsl import HardwareCapabilities, compile_kernel
from tools.dsl.examples.pipelined_vector_add import (
    build_pipelined_tiled_vector_add_kernel,
    build_tiled_vector_add_kernel,
)


@cocotb.test()
async def test_debug_pipelined_add(dut):
    """Diagnostic: run pipelined tiled vector add with cycle-by-cycle signal monitoring."""
    harness = VliwCoreHarness(dut)

    lhs_tiles = [list(range(base, base + 8)) for base in (1, 9)]
    rhs_tiles = [[value * 3 for value in tile] for tile in lhs_tiles]
    lhs = [0] * 24
    rhs = [0] * 24
    golden = [0] * 24
    for tile_idx, (lhs_tile, rhs_tile) in enumerate(zip(lhs_tiles, rhs_tiles)):
        start = tile_idx * 16
        lhs[start:start + 8] = lhs_tile
        rhs[start:start + 8] = rhs_tile
        golden[start:start + 8] = [a + b for a, b in zip(lhs_tile, rhs_tile)]

    harness.axi_mem.preload(512, lhs)
    harness.axi_mem.preload(576, rhs)
    await harness.init()

    kernel = build_pipelined_tiled_vector_add_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"lhs": 512, "rhs": 576, "out": 640},
        assemble=True,
    )
    assert result.binary_bundles is not None
    dut._log.info(f"Program has {len(result.binary_bundles)} bundles")

    await harness.load_program(result.binary_bundles)

    # Access VliwCore internal signals directly (it's the hdl_toplevel)
    core = dut
    clk = dut.clk

    # Run manually with signal monitoring
    dut.io_start.value = 1
    await RisingEdge(clk)
    dut.io_start.value = 0

    cycle = 0
    for _ in range(2000):
        await RisingEdge(clk)
        cycle += 1
        halted = int(dut.io_halted.value)

        def safe_int(sig, default=-1):
            try:
                return int(sig.value)
            except (ValueError, AttributeError):
                return default

        # Read key signals - use safe_int to handle X values
        stall = safe_int(getattr(core, "pipelineStall", None), -1)
        hold = safe_int(getattr(core, "pipelineStall", None), -1)
        fire = safe_int(getattr(core, "engineFireValid", None), -1)
        use_held = safe_int(getattr(core, "useHeldReadData", None), -1)
        held_valid = safe_int(getattr(core, "heldReadDataValid", None), -1)
        ex_valid = safe_int(getattr(core, "exSlotsReg_valid", None), -1)
        valu_valid = safe_int(getattr(core, "exSlotsReg_valuSlots_0_valid", None), -1)
        store_valid = safe_int(getattr(core, "exSlotsReg_storeSlots_0_valid", None), -1)
        store_busy = safe_int(getattr(core, "mem_io_scalarStoreBusy", None), -1)

        # Log EVERY cycle from 28 onwards (critical region)
        should_log = (cycle >= 28) or any(v not in (0, -1) for v in [stall, hold, fire, use_held, valu_valid, store_valid, store_busy])

        if should_log:
            store_opc = safe_int(getattr(core, "exSlotsReg_storeSlots_0_opcode", None)) if store_valid == 1 else -1
            store_src = safe_int(getattr(core, "exSlotsReg_storeSlots_0_srcReg", None)) if store_valid == 1 else -1
            store_addr = safe_int(getattr(core, "exSlotsReg_storeSlots_0_addrReg", None)) if store_valid == 1 else -1

            valu_src1 = safe_int(getattr(core, "exSlotsReg_valuSlots_0_src1Base", None)) if valu_valid == 1 else -1
            valu_src2 = safe_int(getattr(core, "exSlotsReg_valuSlots_0_src2Base", None)) if valu_valid == 1 else -1
            valu_dest = safe_int(getattr(core, "exSlotsReg_valuSlots_0_destBase", None)) if valu_valid == 1 else -1

            # Read VSTORE source data when store is valid and VSTORE opcode
            vstore_data = []
            if store_valid == 1 and store_opc == 2:
                for lane in range(8):
                    vstore_data.append(safe_int(getattr(core, f"mem_io_vstoreSrcData_0_{lane}", None), 0))

            # Read VALU operands whenever VALU is valid
            valu_opA = []
            valu_opB = []
            if valu_valid == 1:
                for lane in range(8):
                    valu_opA.append(safe_int(getattr(core, f"valu_io_operandA_0_{lane}", None), -1))
                    valu_opB.append(safe_int(getattr(core, f"valu_io_operandB_0_{lane}", None), -1))

            msg = (f"C{cycle:3d}: stall={stall} hold={hold} fire={fire} "
                   f"held={held_valid}/{use_held} ex_v={ex_valid} "
                   f"valu_v={valu_valid} store_v={store_valid} busy={store_busy}")
            if valu_valid == 1:
                msg += f" VALU[s1={valu_src1} s2={valu_src2} d={valu_dest}]"
                msg += f" opA={valu_opA} opB={valu_opB}"
            if store_valid == 1:
                msg += f" STORE[opc={store_opc} src={store_src} addr={store_addr}]"
            if vstore_data:
                msg += f" vstore_data={vstore_data}"
            dut._log.info(msg)

        if halted:
            for _ in range(20):
                await RisingEdge(clk)
            break

    dut._log.info(f"Halted at cycle {cycle}")

    # Dump output region
    dut._log.info("Output memory dump (words 640..680):")
    all_ok = True
    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(640 + idx)
        marker = " <-- MISMATCH" if got != exp else ""
        if got != exp:
            all_ok = False
        dut._log.info(f"  word[{640+idx}] = {got:10d}  (expected: {exp}){marker}")

    assert all_ok, "Output mismatch detected"


@cocotb.test()
async def test_debug_non_pipelined_add(dut):
    """Diagnostic: run NON-pipelined tiled vector add for comparison."""
    harness = VliwCoreHarness(dut)

    lhs_tiles = [list(range(base, base + 8)) for base in (1, 9)]
    rhs_tiles = [[value * 3 for value in tile] for tile in lhs_tiles]
    lhs = [0] * 24
    rhs = [0] * 24
    golden = [0] * 24
    for tile_idx, (lhs_tile, rhs_tile) in enumerate(zip(lhs_tiles, rhs_tiles)):
        start = tile_idx * 16
        lhs[start:start + 8] = lhs_tile
        rhs[start:start + 8] = rhs_tile
        golden[start:start + 8] = [a + b for a, b in zip(lhs_tile, rhs_tile)]

    harness.axi_mem.preload(512, lhs)
    harness.axi_mem.preload(576, rhs)
    await harness.init()

    kernel = build_tiled_vector_add_kernel(tiles=2, tile_elements=8, tile_stride_elements=16)
    caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
    result = compile_kernel(
        kernel,
        caps,
        bindings={"lhs": 512, "rhs": 576, "out": 640},
        assemble=True,
    )
    assert result.binary_bundles is not None
    dut._log.info(f"Program has {len(result.binary_bundles)} bundles (non-pipelined)")

    await harness.load_program(result.binary_bundles)
    cycles = await harness.run(max_cycles=40000)

    dut._log.info(f"Completed in {cycles} cycles")
    dut._log.info(f"AXI write txn count: {harness.axi_mem.write_txn_count}")

    # Dump output region
    all_ok = True
    for idx, exp in enumerate(golden):
        got = harness.axi_mem.read_word(640 + idx)
        marker = " <-- MISMATCH" if got != exp else ""
        if got != exp:
            all_ok = False
        dut._log.info(f"  word[{640+idx}] = {got:10d}  (expected: {exp}){marker}")
    dut._log.info(f"Non-pipelined result: {'ALL OK' if all_ok else 'MISMATCHES FOUND'}")
