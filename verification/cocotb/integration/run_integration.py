"""
Integration test runner for VliwCore.

Runs the full VliwCore Verilog with scheduler-based integration tests.

Usage:
    python run_integration.py                      # regenerate RTL, then run all tests
    python run_integration.py test_add_sub         # regenerate RTL, run selected tests
    python run_integration.py --config path/to/test_config.properties
    python run_integration.py --modules test_slot_configs
"""

import sys
import os
import subprocess
import csv
import datetime as dt
import time
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from verification.cocotb.config import load_test_config, slot_env, default_config_path
from verification.cocotb.result_summary import print_results_summary, collect_results_summary

# Ensure iverilog is on PATH
iverilog_bin = r"C:\iverilog\bin"
if os.path.isdir(iverilog_bin) and iverilog_bin not in os.environ.get("PATH", ""):
    os.environ["PATH"] = iverilog_bin + os.pathsep + os.environ["PATH"]

INTEGRATION_DIR = Path(__file__).parent
RTL_DIR = PROJECT_ROOT / "generated_rtl" / "modules"


def _parse_args(argv: list[str]) -> tuple[Path, list[str], str, Path, str]:
    cfg_path = default_config_path(PROJECT_ROOT)
    run_label = "manual"
    log_file = PROJECT_ROOT / "verification" / "results" / "integration_runs_v2.csv"
    modules = "test_slot_configs"
    tests: list[str] = []
    idx = 0
    while idx < len(argv):
        token = argv[idx]
        if token == "--config":
            if idx + 1 >= len(argv):
                raise ValueError("--config requires a file path")
            cfg_path = Path(argv[idx + 1])
            idx += 2
            continue
        if token == "--label":
            if idx + 1 >= len(argv):
                raise ValueError("--label requires a value")
            run_label = argv[idx + 1]
            idx += 2
            continue
        if token == "--log-file":
            if idx + 1 >= len(argv):
                raise ValueError("--log-file requires a file path")
            log_file = Path(argv[idx + 1])
            idx += 2
            continue
        if token == "--modules":
            if idx + 1 >= len(argv):
                raise ValueError("--modules requires a value")
            modules = argv[idx + 1]
            idx += 2
            continue
        tests.append(token)
        idx += 1
    return cfg_path, tests, run_label, log_file, modules


def _append_run_log(
    log_file: Path,
    run_label: str,
    modules: str,
    cfg,
    requested_tests: list[str],
    summary: dict[str, int | float],
    duration_sec: float,
):
    log_file.parent.mkdir(parents=True, exist_ok=True)
    header = [
        "timestamp_utc",
        "label",
        "config_path",
        "tests_filter",
        "modules",
        "alu_slots",
        "valu_slots",
        "load_slots",
        "store_slots",
        "flow_slots",
        "passed",
        "failed",
        "total",
        "cycles_count",
        "cycles_total",
        "cycles_min",
        "cycles_max",
        "cycles_avg",
        "duration_sec",
    ]
    row = [
        dt.datetime.now(dt.timezone.utc).isoformat(),
        run_label,
        str(cfg.config_path),
        ",".join(requested_tests) if requested_tests else "all",
        modules,
        cfg.n_alu_slots,
        cfg.n_valu_slots,
        cfg.n_load_slots,
        cfg.n_store_slots,
        cfg.n_flow_slots,
        summary["passed"],
        summary["failed"],
        summary["total"],
        summary["cycles_count"],
        summary["cycles_total"],
        summary["cycles_min"],
        summary["cycles_max"],
        f"{summary['cycles_avg']:.3f}",
        f"{duration_sec:.3f}",
    ]

    write_header = not log_file.exists()
    with log_file.open("a", newline="", encoding="utf-8") as fp:
        writer = csv.writer(fp)
        if write_header:
            writer.writerow(header)
        writer.writerow(row)


def _regenerate_rtl(cfg):
    env = dict(os.environ.copy())
    env.update(slot_env(cfg))
    env["VLIW_CONFIG_FILE"] = str(cfg.config_path)

    print(
        "Regenerating RTL with slots: "
        f"ALU={cfg.n_alu_slots}, VALU={cfg.n_valu_slots}, LOAD={cfg.n_load_slots}, "
        f"STORE={cfg.n_store_slots}, FLOW={cfg.n_flow_slots}"
    )

    generator_main = cfg.rtl_generator_core
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


def main():
    from cocotb_tools.runner import get_runner

    started = time.perf_counter()

    try:
        cfg_path, requested_tests, run_label, log_file, modules = _parse_args(sys.argv[1:])
        cfg = load_test_config(config_path=cfg_path, project_root=PROJECT_ROOT)
    except (ValueError, FileNotFoundError) as e:
        print(f"ERROR: {e}")
        sys.exit(1)

    try:
        _regenerate_rtl(cfg)
    except subprocess.CalledProcessError as e:
        print(f"ERROR: RTL generation failed with exit code {e.returncode}")
        sys.exit(e.returncode)

    verilog_file = RTL_DIR / "VliwCore.v"
    if not verilog_file.exists():
        print(f"ERROR: VliwCore.v not found at {verilog_file}")
        print("RTL generation step did not produce VliwCore.v")
        sys.exit(1)

    build_dir = INTEGRATION_DIR / "sim_build"
    cycle_metrics_file = build_dir / "cycle_metrics.jsonl"
    if cycle_metrics_file.exists():
        cycle_metrics_file.unlink()

    # Ensure tools/ and integration/ are importable
    tools_dir = str(PROJECT_ROOT / "tools")
    cocotb_dir = str(PROJECT_ROOT / "verification" / "cocotb")
    if tools_dir not in sys.path:
        sys.path.insert(0, tools_dir)
    if str(INTEGRATION_DIR) not in sys.path:
        sys.path.insert(0, str(INTEGRATION_DIR))

    runner = get_runner("icarus")
    runner.build(
        verilog_sources=[str(verilog_file)],
        hdl_toplevel="VliwCore",
        build_dir=str(build_dir),
        always=True,
    )

    # Optional: filter to specific test(s)
    test_filter = None
    if requested_tests:
        test_filter = ",".join(requested_tests)
        print(f"Running filtered tests: {test_filter}")

    extra_env = {
        "PYTHONPATH": os.pathsep.join([str(PROJECT_ROOT), cocotb_dir, str(INTEGRATION_DIR), tools_dir]),
        "VLIW_CONFIG_FILE": str(cfg.config_path),
        "VLIW_CYCLE_METRICS_FILE": str(cycle_metrics_file),
    }
    extra_env.update(slot_env(cfg))
    if test_filter:
        extra_env["TESTCASE"] = test_filter

    try:
        runner.test(
            hdl_toplevel="VliwCore",
            test_module=modules,
            build_dir=str(build_dir),
            extra_env=extra_env,
        )
    except Exception:
        pass  # cocotb may raise on test failures; we parse results.xml

    # Parse results
    results_xml = build_dir / "results.xml"
    if results_xml.exists():
        passed, failed = print_results_summary(results_xml, cycle_metrics_file)
        summary = collect_results_summary(results_xml, cycle_metrics_file)
        duration_sec = time.perf_counter() - started
        _append_run_log(log_file, run_label, modules, cfg, requested_tests, summary, duration_sec)
        if cycle_metrics_file.exists():
            cycle_metrics_file.unlink()
        sys.exit(1 if failed > 0 else 0)
    else:
        print("ERROR: No results.xml found")
        sys.exit(1)


if __name__ == "__main__":
    main()
