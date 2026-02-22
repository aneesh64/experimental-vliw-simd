"""
Python-based cocotb test runner for all VLIW SIMD modules.
Uses cocotb_tools.runner instead of Makefiles (better Windows support).

Usage:
    python run_tests.py                    # run all tests
    python run_tests.py divider            # run only the divider test
    python run_tests.py divider alu flow   # run specific modules
"""

import sys
import os
import traceback
import subprocess
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from verification.cocotb.config import load_test_config, slot_env, default_config_path
from verification.cocotb.result_summary import print_results_summary

# Ensure iverilog is on PATH
iverilog_bin = r"C:\iverilog\bin"
if os.path.isdir(iverilog_bin) and iverilog_bin not in os.environ.get("PATH", ""):
    os.environ["PATH"] = iverilog_bin + os.pathsep + os.environ["PATH"]

from cocotb_tools.runner import get_runner

TESTS_DIR = Path(__file__).parent
RTL_DIR   = PROJECT_ROOT / "generated_rtl" / "modules"

# Module definitions
MODULE_DEFS = {
    "divider":  {"toplevel": "UnsignedDivider",     "verilog": "UnsignedDivider.v",     "module": "test_divider"},
    "alu":      {"toplevel": "AluEngine",            "verilog": "AluEngine.v",            "module": "test_alu"},
    "valu":     {"toplevel": "ValuEngine",           "verilog": "ValuEngine.v",           "module": "test_valu"},
    "flow":     {"toplevel": "FlowEngine",           "verilog": "FlowEngine.v",           "module": "test_flow"},
    "mem":      {"toplevel": "MemoryEngine",         "verilog": "MemoryEngine.v",         "module": "test_mem"},
    "scratch":  {"toplevel": "BankedScratchMemory",  "verilog": "BankedScratchMemory.v",  "module": "test_scratch"},
    "core":     {"toplevel": "VliwCore",             "verilog": "VliwCore.v",             "module": "test_core"},
}


def _regenerate_rtl(cfg):
    env = dict(os.environ.copy())
    env.update(slot_env(cfg))
    env["VLIW_CONFIG_FILE"] = str(cfg.config_path)

    generator_main = cfg.rtl_generator_all
    print(
        "Regenerating RTL with slots: "
        f"ALU={cfg.n_alu_slots}, VALU={cfg.n_valu_slots}, LOAD={cfg.n_load_slots}, "
        f"STORE={cfg.n_store_slots}, FLOW={cfg.n_flow_slots}"
    )
    if os.name == "nt":
        subprocess.run(
            f'sbt "runMain {generator_main}"',
            cwd=str(PROJECT_ROOT),
            env=env,
            check=True,
            shell=True,
        )
    else:
        subprocess.run(
            ["sbt", "runMain", generator_main],
            cwd=str(PROJECT_ROOT),
            env=env,
            check=True,
        )


def run_test(name: str, info: dict, cfg, sim: str = "icarus") -> dict:
    """Run a single module's tests. Returns dict with pass/fail counts."""
    verilog_file = RTL_DIR / info["verilog"]
    if not verilog_file.exists():
        print(f"  ERROR: Verilog file not found: {verilog_file}")
        return {"name": name, "error": "verilog_not_found", "passed": 0, "failed": 1}

    build_dir = TESTS_DIR / name / "sim_build"

    runner = get_runner(sim)
    runner.build(
        verilog_sources=[str(verilog_file)],
        hdl_toplevel=info["toplevel"],
        build_dir=str(build_dir),
        always=True,
    )

    try:
        runner.test(
            hdl_toplevel=info["toplevel"],
            test_module=info["module"],
            build_dir=str(build_dir),
            extra_env={
                "PYTHONPATH": str(PROJECT_ROOT),
                "VLIW_CONFIG_FILE": str(cfg.config_path),
                **slot_env(cfg),
            },
        )
    except Exception:
        pass  # cocotb may raise on test failures; parse XML instead

    # Parse results.xml for detailed pass/fail counts
    results_xml = build_dir / "results.xml"
    if results_xml.exists():
        print_results_summary(results_xml)
        import xml.etree.ElementTree as ET
        tree = ET.parse(results_xml)
        passed = 0
        failed = 0
        for ts in tree.iter("testsuite"):
            for tc in ts.iter("testcase"):
                if tc.find("failure") is not None:
                    failed += 1
                else:
                    passed += 1
        return {"name": name, "error": None if failed == 0 else "test failures",
                "passed": passed, "failed": failed}
    else:
        return {"name": name, "error": "no results.xml", "passed": 0, "failed": 1}


def main():
    args = sys.argv[1:]
    cfg_path = default_config_path(PROJECT_ROOT)
    filtered_args = []
    idx = 0
    while idx < len(args):
        if args[idx] == "--config":
            if idx + 1 >= len(args):
                print("ERROR: --config requires a file path")
                sys.exit(1)
            cfg_path = Path(args[idx + 1])
            idx += 2
            continue
        filtered_args.append(args[idx])
        idx += 1

    try:
        cfg = load_test_config(config_path=cfg_path, project_root=PROJECT_ROOT)
    except (ValueError, FileNotFoundError) as e:
        print(f"ERROR: {e}")
        sys.exit(1)

    try:
        _regenerate_rtl(cfg)
    except subprocess.CalledProcessError as e:
        print(f"ERROR: RTL generation failed with exit code {e.returncode}")
        sys.exit(e.returncode)

    # Determine which modules to run
    if filtered_args:
        modules = {k: MODULE_DEFS[k] for k in filtered_args if k in MODULE_DEFS}
        unknown = [k for k in filtered_args if k not in MODULE_DEFS]
        if unknown:
            print(f"Unknown modules: {unknown}")
            print(f"Available: {list(MODULE_DEFS.keys())}")
            sys.exit(1)
    else:
        modules = MODULE_DEFS

    # Ensure test files can be found
    original_path = sys.path.copy()
    if str(TESTS_DIR) not in sys.path:
        sys.path.insert(0, str(TESTS_DIR))

    print("=" * 60)
    print(" VLIW SIMD cocotb Test Runner (Python)")
    print(f" Config: {cfg.config_path}")
    print(f" RTL dir: {RTL_DIR}")
    print(f" Modules: {', '.join(modules.keys())}")
    print("=" * 60)
    print()

    results = []
    for name, info in modules.items():
        print(f">>> {name} ({info['toplevel']})")
        try:
            r = run_test(name, info, cfg)
        except Exception as e:
            traceback.print_exc()
            r = {"name": name, "error": str(e), "passed": 0, "failed": 1}
        results.append(r)

        if r["error"]:
            print(f"  FAIL: {r['error'][:200]}")
        else:
            print(f"  PASS")
        print()

    # Summary
    print("=" * 60)
    print(" Summary")
    print("=" * 60)
    total_pass = 0
    total_fail = 0
    for r in results:
        status = "PASS" if not r["error"] else "FAIL"
        print(f"  {r['name']:12s} {status}")
        total_pass += r["passed"]
        total_fail += r["failed"]

    print()
    print(f"Total: {total_pass} passed, {total_fail} failed")
    sys.exit(1 if total_fail > 0 else 0)


if __name__ == "__main__":
    main()
