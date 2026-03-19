"""
Python-based cocotb runner for the top-level VliwSimdSoc smoke suite.

Runs the generated SoC RTL in generated_rtl/Sim against verification/cocotb/test_smoke.py,
including host-facing AXI protocol checks for the five basic AXI channels.
"""

import hashlib
import os
import re
import shutil
import subprocess
import sys
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

PROJECT_ROOT = Path(__file__).parents[2]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from verification.cocotb.config import active_test_config, default_config_path, load_test_config
from verification.cocotb.result_summary import collect_results_summary, print_results_summary


def _prepend_existing_path_entries(*entries: str) -> None:
    current_entries = os.environ.get("PATH", "").split(os.pathsep)
    normalized_existing = {
        os.path.normcase(os.path.normpath(entry))
        for entry in current_entries
        if entry
    }
    to_prepend = []
    for entry in entries:
        if not entry:
            continue
        if not os.path.isdir(entry):
            continue
        normalized_entry = os.path.normcase(os.path.normpath(entry))
        if normalized_entry in normalized_existing:
            continue
        to_prepend.append(entry)
        normalized_existing.add(normalized_entry)
    if to_prepend:
        os.environ["PATH"] = os.pathsep.join(to_prepend + current_entries)


def _configure_runtime_path() -> None:
    python_dir = Path(sys.executable).resolve().parent
    candidate_entries = []
    if os.name == "nt":
        candidate_entries.extend([
            str(python_dir),
            str(python_dir / "DLLs"),
            str(python_dir / "Library" / "mingw-w64" / "bin"),
            str(python_dir / "Library" / "usr" / "bin"),
            str(python_dir / "Library" / "bin"),
            str(python_dir / "Scripts"),
            r"C:\iverilog\bin",
        ])
    else:
        candidate_entries.extend([
            str(python_dir),
            str(python_dir.parent / "bin"),
        ])
    _prepend_existing_path_entries(*candidate_entries)


_configure_runtime_path()

SIM_RTL_DIR = PROJECT_ROOT / "generated_rtl" / "Sim"
SIM_RTL_HASH_FILE = SIM_RTL_DIR / ".rtl_source_hash"
SCALA_SRC_DIR = PROJECT_ROOT / "src"


def _compute_source_hash() -> str:
    h = hashlib.sha256()
    if SCALA_SRC_DIR.exists():
        for path in sorted(SCALA_SRC_DIR.rglob("*.scala")):
            h.update(str(path.relative_to(PROJECT_ROOT)).encode())
            h.update(path.read_bytes())
    build_sbt = PROJECT_ROOT / "build.sbt"
    if build_sbt.exists():
        h.update(build_sbt.read_bytes())
    return h.hexdigest()


def _soc_rtl_needs_rebuild() -> bool:
    verilog_file = SIM_RTL_DIR / "VliwSimdSoc_1c.v"
    if not verilog_file.exists():
        return True
    if not SIM_RTL_HASH_FILE.exists():
        return True
    stored = SIM_RTL_HASH_FILE.read_text(encoding="utf-8").strip()
    return stored != _compute_source_hash()


def _save_source_hash() -> None:
    SIM_RTL_DIR.mkdir(parents=True, exist_ok=True)
    SIM_RTL_HASH_FILE.write_text(_compute_source_hash(), encoding="utf-8")


def _find_sbt_command() -> str:
    for candidate in ("sbt.bat", "sbt.cmd", "sbt"):
        resolved = shutil.which(candidate)
        if resolved:
            return resolved
    return "sbt"


def _runmain_command(main_class: str) -> list[str]:
    return [_find_sbt_command(), f"runMain {main_class}"]


def _regenerate_soc_rtl() -> None:
    print("Source changes detected; regenerating SoC RTL...")
    subprocess.run(
        _runmain_command("vliw.gen.GenerateSim"),
        cwd=str(PROJECT_ROOT),
        check=True,
    )
    _save_source_hash()


def main() -> None:
    from cocotb_tools.runner import get_runner

    args = sys.argv[1:]
    cfg_path = default_config_path(PROJECT_ROOT)
    selected_tests: list[str] = []
    idx = 0
    while idx < len(args):
        token = args[idx]
        if token == "--config":
            if idx + 1 >= len(args):
                print("ERROR: --config requires a file path")
                sys.exit(1)
            cfg_path = Path(args[idx + 1])
            idx += 2
            continue
        selected_tests.append(token)
        idx += 1

    try:
        cfg = load_test_config(config_path=cfg_path, project_root=PROJECT_ROOT)
    except (ValueError, FileNotFoundError) as exc:
        print(f"ERROR: {exc}")
        sys.exit(1)

    try:
        if _soc_rtl_needs_rebuild():
            _regenerate_soc_rtl()
        else:
            print("SoC RTL up-to-date (no source changes detected)")
    except subprocess.CalledProcessError as exc:
        print(f"ERROR: SoC RTL generation failed with exit code {exc.returncode}")
        sys.exit(exc.returncode)

    verilog_file = SIM_RTL_DIR / "VliwSimdSoc_1c.v"
    if not verilog_file.exists():
        print(f"ERROR: SoC RTL not found: {verilog_file}")
        sys.exit(1)

    build_dir = Path(__file__).parent / "sim_build_soc"
    runner = get_runner("icarus")
    runner.build(
        sources=[str(verilog_file)],
        hdl_toplevel="VliwSimdSoc_1c",
        build_dir=str(build_dir),
        always=True,
    )

    extra_env = {
        "PYTHONPATH": os.pathsep.join([str(PROJECT_ROOT), str(Path(__file__).parent)]),
        "PYTHONUTF8": "1",
        "PYTHONIOENCODING": "utf-8",
    }
    results_xml = build_dir / "results.xml"
    test_filter = None
    if selected_tests:
        print(f"Running filtered SoC smoke tests: {', '.join(selected_tests)}")
        normalized_names = []
        for name in selected_tests:
            normalized_names.append(name if "." in name else f"test_smoke.{name}")
        test_filter = "^(?:" + "|".join(re.escape(name) for name in normalized_names) + ")$"

    try:
        with active_test_config(cfg.config_path, PROJECT_ROOT):
            runner.test(
                hdl_toplevel="VliwSimdSoc_1c",
                test_module="test_smoke",
                build_dir=str(build_dir),
                test_filter=test_filter,
                extra_env=extra_env,
                results_xml=str(results_xml),
            )
    except Exception:
        pass

    if not results_xml.exists():
        print("ERROR: No results.xml found")
        sys.exit(1)

    passed, failed = print_results_summary(results_xml)
    summary = collect_results_summary(results_xml)
    print()
    print(f"Total: {summary['passed']} passed, {summary['failed']} failed, {summary['skipped']} skipped")
    sys.exit(1 if failed > 0 else 0)


if __name__ == "__main__":
    main()
