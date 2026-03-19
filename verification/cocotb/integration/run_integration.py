"""
Integration test runner for VliwCore.

Runs the full VliwCore Verilog with scheduler-based integration tests.

RTL generation is auto-detected: Scala sources and config properties are
hashed and compared against the last successful build. RTL is only
regenerated when changes are detected (or when --rebuild-rtl is given).
"""

import csv
import datetime as dt
import hashlib
import os
import shutil
import subprocess
import sys
import time
from pathlib import Path


def _configure_console_encoding() -> None:
    for stream_name in ("stdout", "stderr"):
        stream = getattr(sys, stream_name, None)
        reconfigure = getattr(stream, "reconfigure", None)
        if reconfigure is not None:
            reconfigure(encoding="utf-8", errors="replace")


_configure_console_encoding()
os.environ.setdefault("PYTHONUTF8", "1")
os.environ.setdefault("PYTHONIOENCODING", "utf-8")

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from verification.cocotb.config import active_test_config, default_config_path, load_test_config, slot_env
from verification.cocotb.result_summary import collect_results_summary, print_results_summary

iverilog_bin = r"C:\iverilog\bin"
if os.path.isdir(iverilog_bin) and iverilog_bin not in os.environ.get("PATH", ""):
    os.environ["PATH"] = iverilog_bin + os.pathsep + os.environ["PATH"]

INTEGRATION_DIR = Path(__file__).parent
RTL_DIR = PROJECT_ROOT / "generated_rtl" / "modules"

USAGE_TEXT = """Usage:
    python run_integration.py                      # auto-detect RTL changes, run all tests
    python run_integration.py --help              # show this help
    python run_integration.py --no-rtl            # skip RTL generation entirely
    python run_integration.py --rebuild-rtl       # force RTL regeneration
    python run_integration.py test_add_sub        # run selected tests (auto RTL)
    python run_integration.py --config path/to/test_config.properties
    python run_integration.py --modules test_integration
    python run_integration.py --modules test_algorithms
    python run_integration.py --modules test_integration_scalar
    python run_integration.py --modules test_integration_memory
    python run_integration.py --modules test_integration_control
    python run_integration.py --modules test_integration_vector
    python run_integration.py --modules test_dsl_integration
    python run_integration.py --modules test_dsl_helpers_integration
    python run_integration.py --modules test_dsl_algorithms_integration
    python run_integration.py --modules test_algorithms_kernels
    python run_integration.py --modules test_algorithms_multiwidth

Default module if --modules is omitted: test_slot_configs
"""


def _parse_args(argv: list[str]) -> tuple[Path, list[str], str, Path, str, str]:
    cfg_path = default_config_path(PROJECT_ROOT)
    run_label = "manual"
    log_file = PROJECT_ROOT / "verification" / "results" / "integration_runs_v2.csv"
    modules = "test_slot_configs"
    rtl_mode = "auto"
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
        if token == "--rebuild-rtl":
            rtl_mode = "force"
            idx += 1
            continue
        if token == "--no-rtl":
            rtl_mode = "skip"
            idx += 1
            continue
        tests.append(token)
        idx += 1
    return cfg_path, tests, run_label, log_file, modules, rtl_mode


def _append_run_log(log_file: Path, run_label: str, modules: str, cfg, requested_tests: list[str], summary: dict[str, int | float], duration_sec: float):
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
    with log_file.open("a", newline="", encoding="utf-8") as handle:
        writer = csv.writer(handle)
        if write_header:
            writer.writerow(header)
        writer.writerow(row)


_RTL_HASH_FILE = RTL_DIR / ".rtl_source_hash"
_SCALA_SRC_DIR = PROJECT_ROOT / "src"


def _compute_source_hash(cfg) -> str:
    h = hashlib.sha256()
    if _SCALA_SRC_DIR.exists():
        for path in sorted(_SCALA_SRC_DIR.rglob("*.scala")):
            h.update(str(path.relative_to(PROJECT_ROOT)).encode())
            h.update(path.read_bytes())
    cfg_path = Path(cfg.config_path)
    if cfg_path.exists():
        h.update(cfg_path.read_bytes())
    build_sbt = PROJECT_ROOT / "build.sbt"
    if build_sbt.exists():
        h.update(build_sbt.read_bytes())
    return h.hexdigest()


def _rtl_needs_rebuild(cfg) -> bool:
    if not (RTL_DIR / "VliwCore.v").exists():
        return True
    if not _RTL_HASH_FILE.exists():
        return True
    stored = _RTL_HASH_FILE.read_text(encoding="utf-8").strip()
    return stored != _compute_source_hash(cfg)


def _save_source_hash(cfg):
    _RTL_HASH_FILE.parent.mkdir(parents=True, exist_ok=True)
    _RTL_HASH_FILE.write_text(_compute_source_hash(cfg), encoding="utf-8")


def _find_sbt_command() -> str:
    for candidate in ("sbt.bat", "sbt.cmd", "sbt"):
        resolved = shutil.which(candidate)
        if resolved:
            return resolved
    return "sbt"


def _runmain_command(main_class: str) -> list[str]:
    return [_find_sbt_command(), f"runMain {main_class}"]


def _regenerate_rtl(cfg):
    env = dict(os.environ.copy())
    env.update(slot_env(cfg))
    env["VLIW_CONFIG_FILE"] = str(cfg.config_path)

    print(
        "Regenerating RTL with slots: "
        f"ALU={cfg.n_alu_slots}, VALU={cfg.n_valu_slots}, LOAD={cfg.n_load_slots}, "
        f"STORE={cfg.n_store_slots}, FLOW={cfg.n_flow_slots}, MATRIX={cfg.n_matrix_slots}"
    )
    subprocess.run(
        _runmain_command(cfg.rtl_generator_core),
        cwd=str(PROJECT_ROOT),
        env=env,
        check=True,
    )
    _save_source_hash(cfg)


def main():
    from cocotb_tools.runner import get_runner

    if any(arg in ("--help", "-h") for arg in sys.argv[1:]):
        print(USAGE_TEXT)
        sys.exit(0)

    started = time.perf_counter()

    try:
        cfg_path, requested_tests, run_label, log_file, modules, rtl_mode = _parse_args(sys.argv[1:])
        cfg = load_test_config(config_path=cfg_path, project_root=PROJECT_ROOT)
    except (ValueError, FileNotFoundError) as exc:
        print(f"ERROR: {exc}")
        sys.exit(1)

    if rtl_mode == "skip":
        print("RTL generation skipped (--no-rtl)")
    elif rtl_mode == "force":
        try:
            _regenerate_rtl(cfg)
        except subprocess.CalledProcessError as exc:
            print(f"ERROR: RTL generation failed with exit code {exc.returncode}")
            sys.exit(exc.returncode)
    else:
        if _rtl_needs_rebuild(cfg):
            print("Source changes detected; regenerating RTL...")
            try:
                _regenerate_rtl(cfg)
            except subprocess.CalledProcessError as exc:
                print(f"ERROR: RTL generation failed with exit code {exc.returncode}")
                sys.exit(exc.returncode)
        else:
            print("RTL up-to-date (no source/config changes detected)")

    verilog_file = RTL_DIR / "VliwCore.v"
    if not verilog_file.exists():
        print(f"ERROR: VliwCore.v not found at {verilog_file}")
        print("RTL generation step did not produce VliwCore.v")
        sys.exit(1)

    build_dir = INTEGRATION_DIR / "sim_build"
    cycle_metrics_file = build_dir / "cycle_metrics.jsonl"
    if cycle_metrics_file.exists():
        cycle_metrics_file.unlink()

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

    test_filter = None
    if requested_tests:
        test_filter = ",".join(requested_tests)
        print(f"Running filtered tests: {test_filter}")

    extra_env = {
        "PYTHONPATH": os.pathsep.join([str(PROJECT_ROOT), cocotb_dir, str(INTEGRATION_DIR), tools_dir]),
        "VLIW_CYCLE_METRICS_FILE": str(cycle_metrics_file),
        "PYTHONUTF8": "1",
        "PYTHONIOENCODING": "utf-8",
    }
    extra_env.update(slot_env(cfg))
    if test_filter:
        extra_env["TESTCASE"] = test_filter

    try:
        with active_test_config(cfg.config_path, PROJECT_ROOT):
            runner.test(
                hdl_toplevel="VliwCore",
                test_module=modules,
                build_dir=str(build_dir),
                extra_env=extra_env,
            )
    except Exception:
        pass

    results_xml = build_dir / "results.xml"
    if results_xml.exists():
        passed, failed = print_results_summary(results_xml, cycle_metrics_file)
        summary = collect_results_summary(results_xml, cycle_metrics_file)
        duration_sec = time.perf_counter() - started
        _append_run_log(log_file, run_label, modules, cfg, requested_tests, summary, duration_sec)
        if cycle_metrics_file.exists():
            cycle_metrics_file.unlink()
        sys.exit(1 if failed > 0 else 0)

    print("ERROR: No results.xml found")
    sys.exit(1)


if __name__ == "__main__":
    main()
