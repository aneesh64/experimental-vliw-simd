"""
Run integration suites across slot configuration matrix:
  - load/store/flow fixed to 1
  - valu in {1, 2}
  - alu in {1, 2, 4}

Each run appends a dense row in verification/results/integration_runs.csv
through run_integration.py logging.
"""

from __future__ import annotations

import argparse
import csv
import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).parents[3]
if str(PROJECT_ROOT) not in sys.path:
    sys.path.insert(0, str(PROJECT_ROOT))

from verification.cocotb.config import default_config_path


def _parse_props(path: Path) -> dict[str, str]:
    props: dict[str, str] = {}
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, val = line.split("=", 1)
        props[key.strip()] = val.strip()
    return props


def _write_props(path: Path, props: dict[str, str]):
    lines = [f"{k}={v}" for k, v in sorted(props.items())]
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text("\n".join(lines) + "\n", encoding="utf-8")


def _read_latest_row(log_file: Path, label: str, modules: str) -> dict[str, str] | None:
    if not log_file.exists():
        return None

    latest_row: dict[str, str] | None = None
    latest_ts = ""
    with log_file.open("r", newline="", encoding="utf-8") as fp:
        reader = csv.DictReader(fp)
        for row in reader:
            if row.get("label") != label:
                continue
            if row.get("modules") != modules:
                continue
            ts = row.get("timestamp_utc", "")
            if ts >= latest_ts:
                latest_ts = ts
                latest_row = row
    return latest_row


def _safe_int(value: str, default: int = 0) -> int:
    try:
        return int(value)
    except (TypeError, ValueError):
        return default


def _safe_float(value: str, default: float = 0.0) -> float:
    try:
        return float(value)
    except (TypeError, ValueError):
        return default


def _print_matrix_summary(rows: list[dict[str, str]]):
    if not rows:
        print("\nMatrix summary unavailable: no matching run rows found in log file")
        return

    print("\n=== Matrix summary (lower cycles is better) ===")
    header = (
        "Config", "Pass", "Fail", "Total", "CyclesTotal", "CyclesAvg", "CyclesMin", "CyclesMax", "Time(s)"
    )
    print(
        f"{header[0]:<14} {header[1]:>4} {header[2]:>4} {header[3]:>5} "
        f"{header[4]:>11} {header[5]:>9} {header[6]:>9} {header[7]:>9} {header[8]:>8}"
    )
    print("-" * 86)

    best = min(
        rows,
        key=lambda row: (
            _safe_int(row.get("failed", "0")),
            _safe_int(row.get("cycles_total", "0")),
            _safe_float(row.get("cycles_avg", "0")),
            _safe_float(row.get("duration_sec", "0")),
        ),
    )

    for row in rows:
        cfg = f"a{row.get('alu_slots', '?')}-v{row.get('valu_slots', '?')}"
        passed = _safe_int(row.get("passed", "0"))
        failed = _safe_int(row.get("failed", "0"))
        total = _safe_int(row.get("total", "0"))
        cycles_total = _safe_int(row.get("cycles_total", "0"))
        cycles_avg = _safe_float(row.get("cycles_avg", "0"))
        cycles_min = _safe_int(row.get("cycles_min", "0"))
        cycles_max = _safe_int(row.get("cycles_max", "0"))
        duration_sec = _safe_float(row.get("duration_sec", "0"))
        marker = "*" if row is best else " "
        print(
            f"{marker}{cfg:<13} {passed:>4} {failed:>4} {total:>5} "
            f"{cycles_total:>11} {cycles_avg:>9.3f} {cycles_min:>9} {cycles_max:>9} {duration_sec:>8.3f}"
        )

    print("\n* Best config = lowest failed, then lowest cycles_total (tie-break: cycles_avg, duration)")
    print(
        "Best configuration: "
        f"ALU={best.get('alu_slots', '?')}, VALU={best.get('valu_slots', '?')}, "
        f"LOAD={best.get('load_slots', '?')}, STORE={best.get('store_slots', '?')}, FLOW={best.get('flow_slots', '?')} "
        f"| cycles_total={_safe_int(best.get('cycles_total', '0'))}, cycles_avg={_safe_float(best.get('cycles_avg', '0')):.3f}"
    )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("--config", default=str(default_config_path(PROJECT_ROOT)))
    parser.add_argument("--modules", default="test_slot_configs")
    parser.add_argument("--log-file", default=str(PROJECT_ROOT / "verification" / "results" / "integration_runs_v2.csv"))
    args = parser.parse_args()

    base_cfg = Path(args.config).resolve()
    base_props = _parse_props(base_cfg)

    matrix_cfg = PROJECT_ROOT / "verification" / "config" / "generated" / "matrix_tmp.properties"
    run_integration = Path(__file__).parent / "run_integration.py"

    combos = [(alu, valu) for valu in (1, 2) for alu in (1, 2, 4)]
    failures = 0
    log_file = Path(args.log_file).resolve()
    matrix_rows: list[dict[str, str]] = []

    for alu, valu in combos:
        label = f"slot-matrix-alu{alu}-valu{valu}"
        props = dict(base_props)
        props["slots.alu"] = str(alu)
        props["slots.valu"] = str(valu)
        props["slots.load"] = "1"
        props["slots.store"] = "1"
        props["slots.flow"] = "1"
        _write_props(matrix_cfg, props)

        cmd = [
            sys.executable,
            str(run_integration),
            "--config",
            str(matrix_cfg),
            "--label",
            label,
            "--modules",
            args.modules,
            "--log-file",
            str(log_file),
        ]

        print(f"\n=== Running {label} ===")
        rc = subprocess.call(cmd, cwd=str(Path(__file__).parent))
        row = _read_latest_row(log_file, label, args.modules)
        if row is not None:
            matrix_rows.append(row)
        else:
            print(f"WARNING: no summary row found in {log_file} for label={label}")
        if rc != 0:
            failures += 1

    if matrix_cfg.exists():
        matrix_cfg.unlink()

    _print_matrix_summary(matrix_rows)

    if failures:
        print(f"\nMatrix completed with {failures} failing configuration(s)")
        return 1

    print("\nMatrix completed successfully")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
