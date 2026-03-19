"""
Python-based cocotb test runner for all VLIW SIMD modules.
Uses cocotb_tools.runner instead of Makefiles (better Windows support).

RTL generation is auto-detected: Scala sources and config properties are
hashed and compared against the last successful build. RTL is only
regenerated when changes are detected (or when --rebuild-rtl is given).

Usage:
    python run_tests.py                    # auto-detect RTL changes, run all
    python run_tests.py --no-rtl           # skip RTL generation entirely
    python run_tests.py --rebuild-rtl      # force RTL regeneration
    python run_tests.py divider            # run only the divider test
    python run_tests.py divider alu flow   # run specific modules
"""

import hashlib
import os
import shutil
import subprocess
import sys
import traceback
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
from verification.cocotb.result_summary import print_results_summary

# Ensure iverilog is on PATH
iverilog_bin = r"C:\iverilog\bin"
if os.path.isdir(iverilog_bin) and iverilog_bin not in os.environ.get("PATH", ""):
    os.environ["PATH"] = iverilog_bin + os.pathsep + os.environ["PATH"]

from cocotb_tools.runner import get_runner

TESTS_DIR = Path(__file__).parent
RTL_DIR = PROJECT_ROOT / "generated_rtl" / "modules"

MODULE_DEFS = {
    "divider": {"toplevel": "UnsignedDivider", "verilog": "UnsignedDivider.v", "module": "test_divider"},
    "alu": {"toplevel": "AluEngine", "verilog": "AluEngine.v", "module": "test_alu"},
    "valu": {"toplevel": "ValuEngine", "verilog": "ValuEngine.v", "module": "test_valu"},
    "flow": {"toplevel": "FlowEngine", "verilog": "FlowEngine.v", "module": "test_flow"},
    "mem": {"toplevel": "MemoryEngine", "verilog": "MemoryEngine.v", "module": "test_mem"},
    "matrix": {"toplevel": "MatrixEngine", "verilog": "MatrixEngine.v", "module": "test_matrix"},
    "scratch": {"toplevel": "BankedScratchMemory", "verilog": "BankedScratchMemory.v", "module": "test_scratch"},
    "core": {"toplevel": "VliwCore", "verilog": "VliwCore.v", "module": "test_core"},
    "core_alu2": {"toplevel": "VliwCore", "verilog": "VliwCore.v", "module": "test_core_alu2", "config": "verification/config/test_config_alu2.properties"},
    "core_a2_v2": {"toplevel": "VliwCore", "verilog": "VliwCore.v", "module": "test_core_alu2", "config": "verification/config/test_config_a2_v2.properties"},
    "core_matrix": {"toplevel": "VliwCore", "verilog": "VliwCore.v", "module": "test_core_matrix", "config": "verification/config/test_config_matrix.properties"},
}

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
        _runmain_command(cfg.rtl_generator_all),
        cwd=str(PROJECT_ROOT),
        env=env,
        check=True,
    )
    _save_source_hash(cfg)


def _cfg_for_module(info: dict, default_cfg):
    config_override = info.get("config")
    if not config_override:
        return default_cfg
    return load_test_config(config_path=PROJECT_ROOT / config_override, project_root=PROJECT_ROOT)


def run_test(name: str, info: dict, cfg, sim: str = "icarus") -> dict:
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

    # Set env vars in os.environ so the cocotb simulator subprocess inherits
    # them reliably (extra_env alone may not override existing vars on all
    # platforms).
    test_env = {
        "PYTHONPATH": str(PROJECT_ROOT),
        "PYTHONUTF8": "1",
        "PYTHONIOENCODING": "utf-8",
        **slot_env(cfg),
    }
    saved_env = {k: os.environ.get(k) for k in test_env}
    os.environ.update(test_env)

    try:
        with active_test_config(cfg.config_path, PROJECT_ROOT):
            runner.test(
                hdl_toplevel=info["toplevel"],
                test_module=info["module"],
                build_dir=str(build_dir),
                extra_env=test_env,
            )
    except Exception:
        pass
    finally:
        for k, v in saved_env.items():
            if v is None:
                os.environ.pop(k, None)
            else:
                os.environ[k] = v

    results_xml = build_dir / "results.xml"
    if results_xml.exists():
        print_results_summary(results_xml)
        import xml.etree.ElementTree as ET

        tree = ET.parse(results_xml)
        passed = 0
        failed = 0
        for testsuite in tree.iter("testsuite"):
            for testcase in testsuite.iter("testcase"):
                if testcase.find("failure") is not None:
                    failed += 1
                elif testcase.find("skipped") is None:
                    passed += 1
        return {
            "name": name,
            "error": None if failed == 0 else "test failures",
            "passed": passed,
            "failed": failed,
        }

    return {"name": name, "error": "no results.xml", "passed": 0, "failed": 1}


def main():
    args = sys.argv[1:]
    cfg_path = default_config_path(PROJECT_ROOT)
    rtl_mode = "auto"
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
        if args[idx] == "--rebuild-rtl":
            rtl_mode = "force"
            idx += 1
            continue
        if args[idx] == "--no-rtl":
            rtl_mode = "skip"
            idx += 1
            continue
        filtered_args.append(args[idx])
        idx += 1

    try:
        cfg = load_test_config(config_path=cfg_path, project_root=PROJECT_ROOT)
    except (ValueError, FileNotFoundError) as exc:
        print(f"ERROR: {exc}")
        sys.exit(1)

    if filtered_args:
        modules = {key: MODULE_DEFS[key] for key in filtered_args if key in MODULE_DEFS}
        unknown = [key for key in filtered_args if key not in MODULE_DEFS]
        if unknown:
            print(f"Unknown modules: {unknown}")
            print(f"Available: {list(MODULE_DEFS.keys())}")
            sys.exit(1)
    else:
        modules = MODULE_DEFS

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
    force_pending = rtl_mode == "force"
    for name, info in modules.items():
        print(f">>> {name} ({info['toplevel']})")
        module_cfg = _cfg_for_module(info, cfg)
        if rtl_mode == "skip":
            print("  RTL generation skipped (--no-rtl)")
        else:
            try:
                if force_pending or _rtl_needs_rebuild(module_cfg):
                    print(f"  Preparing RTL with config: {module_cfg.config_path}")
                    _regenerate_rtl(module_cfg)
                else:
                    print(f"  RTL up-to-date for config: {module_cfg.config_path}")
            except subprocess.CalledProcessError as exc:
                print(f"  FAIL: RTL generation failed with exit code {exc.returncode}")
                results.append({"name": name, "error": f"rtl generation failed ({exc.returncode})", "passed": 0, "failed": 1})
                print()
                force_pending = False
                continue
            force_pending = False

        try:
            result = run_test(name, info, module_cfg)
        except Exception as exc:
            traceback.print_exc()
            result = {"name": name, "error": str(exc), "passed": 0, "failed": 1}

        results.append(result)
        if result["error"]:
            print(f"  FAIL: {result['error'][:200]}")
        else:
            print("  PASS")
        print()

    print("=" * 60)
    print(" Summary")
    print("=" * 60)
    total_pass = 0
    total_fail = 0
    for result in results:
        status = "PASS" if not result["error"] else "FAIL"
        print(f"  {result['name']:12s} {status}")
        total_pass += result["passed"]
        total_fail += result["failed"]

    print()
    print(f"Total: {total_pass} passed, {total_fail} failed")
    sys.exit(1 if total_fail > 0 else 0)


if __name__ == "__main__":
    main()
