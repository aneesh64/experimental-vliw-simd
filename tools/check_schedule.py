"""Quick schedule diagnostic for load_store_roundtrip test."""
import sys
from pathlib import Path

ROOT = Path(__file__).parents[1]
sys.path.insert(0, str(ROOT / "tools"))
sys.path.insert(0, str(ROOT / "verification" / "cocotb"))
sys.path.insert(0, str(ROOT / "verification" / "cocotb" / "integration"))

from scheduler import VliwScheduler, SchedulerConfig, LOAD_RESULT_LATENCY
from config import load_test_config

cfg = load_test_config()
print(f"mem_post_gap={cfg.mem_post_gap}, LOAD_RESULT_LATENCY={LOAD_RESULT_LATENCY}")

S = VliwScheduler(SchedulerConfig(
    n_alu_slots=cfg.n_alu_slots, n_valu_slots=cfg.n_valu_slots,
    n_load_slots=cfg.n_load_slots, n_store_slots=cfg.n_store_slots,
    n_flow_slots=cfg.n_flow_slots, mem_post_gap=cfg.mem_post_gap
))

ops = [
    S.const(0, 42),
    S.const(1, 0),
    S.store(1, 0),
    S.const(30, 0),
    S.add_imm(30, 30, 0),
    S.add_imm(30, 30, 0),
    S.add_imm(30, 30, 0),
    S.add_imm(30, 30, 0),
    S.load(3, 1),          # loads should fire here
    S.add_imm(30, 30, 0),
    S.add_imm(30, 30, 0),
    S.add_imm(30, 30, 0),
    S.add_imm(30, 30, 0),
    S.const(5, 256),
    S.store(5, 3),         # reads s[3] — consumer of load
    S.halt(),
]

bundles = S.schedule(ops)
print(f"Total bundles: {len(bundles)}")
for i, b in enumerate(bundles):
    if b:
        print(f"  bundle {i}: {b}")
