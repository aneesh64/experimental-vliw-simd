"""Dump the compiled schedule for the pipelined tiled vector add kernel."""
import sys, os
sys.path.insert(0, os.path.join(os.path.dirname(__file__)))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'verification', 'cocotb', 'integration'))
sys.path.insert(0, os.path.join(os.path.dirname(__file__), '..', 'verification', 'cocotb'))

from config import load_test_config
from pathlib import Path
CFG = load_test_config(project_root=Path(os.path.dirname(__file__)).parent)
from assembler import Assembler, AssemblerConfig
from scheduler import VliwScheduler, SchedulerConfig
from dsl import HardwareCapabilities, compile_kernel
from dsl.examples.pipelined_vector_add import build_pipelined_tiled_vector_add_kernel
from dsl.examples.dsp_kernels import (
    build_pipelined_fused_dsp_gain_monitor_kernel,
    build_pipelined_fused_dsp_dual_output_kernel,
)

ASM = Assembler(AssemblerConfig(
    n_alu_slots=CFG.n_alu_slots, n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots, n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots, n_matrix_slots=CFG.n_matrix_slots,
    vlen=CFG.vlen, scratch_size=CFG.scratch_size, imem_depth=CFG.imem_depth
))
S = VliwScheduler(SchedulerConfig(
    n_alu_slots=CFG.n_alu_slots, n_valu_slots=CFG.n_valu_slots,
    n_load_slots=CFG.n_load_slots, n_store_slots=CFG.n_store_slots,
    n_flow_slots=CFG.n_flow_slots, n_matrix_slots=CFG.n_matrix_slots,
    mem_post_gap=CFG.mem_post_gap
))
caps = HardwareCapabilities.from_configs(scheduler_config=S.cfg, assembler_config=ASM.cfg)
def dump_kernel(name, kernel):
    result = compile_kernel(kernel, caps, bindings={"lhs": 512, "rhs": 576, "out": 640,
        "samples": 512, "probe": 640, "meta": 704,
        "gain_out": 640, "bias_out": 768}, assemble=True)
    bundles = result.scheduled_bundles
    print(f"\n=== {name} ({len(bundles)} bundles) ===")
    for i, b in enumerate(bundles):
        parts = []
        for engine in ['alu', 'valu', 'load', 'store', 'flow', 'matrix']:
            ops = b.get(engine, [])
            for op in ops:
                parts.append(f"{engine}: {op}")
        print(f"  B{i:3d}: {' | '.join(parts) if parts else 'NOP'}")
    print(f"  Scratch: {result.scratch_map}")

kernel1 = build_pipelined_tiled_vector_add_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1)
dump_kernel("Pipelined Vector Add", kernel1)

kernel2 = build_pipelined_fused_dsp_gain_monitor_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1)
dump_kernel("Fused DSP Gain Monitor", kernel2)

kernel3 = build_pipelined_fused_dsp_dual_output_kernel(tiles=2, tile_elements=8, tile_stride_elements=16, unroll=1)
dump_kernel("Fused DSP Dual Output", kernel3)
