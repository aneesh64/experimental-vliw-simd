from __future__ import annotations

import json
import xml.etree.ElementTree as ET
from pathlib import Path


def _load_cycle_metrics(path: Path) -> dict[str, int | str]:
    if not path.exists():
        return {}
    metrics: dict[str, int | str] = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line:
            continue
        try:
            item = json.loads(line)
        except json.JSONDecodeError:
            continue
        name = item.get("test")
        cycles = item.get("cycles")
        if isinstance(name, str):
            metrics[name] = cycles
    return metrics


def collect_results_summary(results_xml: Path, cycle_metrics_file: Path | None = None) -> dict[str, int | float]:
    tree = ET.parse(results_xml)
    cycle_metrics = _load_cycle_metrics(cycle_metrics_file) if cycle_metrics_file else {}

    passed = 0
    failed = 0
    cycles_numeric: list[int] = []

    for testsuite in tree.iter("testsuite"):
        for tc in testsuite.iter("testcase"):
            name = tc.get("name", "?")
            fail_elem = tc.find("failure")
            if fail_elem is not None:
                failed += 1
            else:
                passed += 1

            cyc = cycle_metrics.get(name)
            if isinstance(cyc, int):
                cycles_numeric.append(cyc)

    total = passed + failed
    cycles_total = sum(cycles_numeric)
    cycles_count = len(cycles_numeric)
    cycles_max = max(cycles_numeric) if cycles_numeric else 0
    cycles_min = min(cycles_numeric) if cycles_numeric else 0
    cycles_avg = (cycles_total / cycles_count) if cycles_count else 0.0

    return {
        "passed": passed,
        "failed": failed,
        "total": total,
        "cycles_count": cycles_count,
        "cycles_total": cycles_total,
        "cycles_max": cycles_max,
        "cycles_min": cycles_min,
        "cycles_avg": cycles_avg,
    }


def print_results_summary(results_xml: Path, cycle_metrics_file: Path | None = None) -> tuple[int, int]:
    tree = ET.parse(results_xml)
    cycle_metrics = _load_cycle_metrics(cycle_metrics_file) if cycle_metrics_file else {}

    passed = 0
    failed = 0

    for testsuite in tree.iter("testsuite"):
        for tc in testsuite.iter("testcase"):
            name = tc.get("name", "?")
            sim_time_ns = tc.get("sim_time_ns", "?")
            cycles = cycle_metrics.get(name, "n/a")
            fail_elem = tc.find("failure")
            if fail_elem is not None:
                failed += 1
                msg = fail_elem.get("message", fail_elem.text or "").strip().replace("\n", " ")[:180]
                print(f"  FAIL: {name} | sim_ns={sim_time_ns} | cycles={cycles} | {msg}")
            else:
                passed += 1
                print(f"  PASS: {name} | sim_ns={sim_time_ns} | cycles={cycles}")

    print()
    print(f"Total: {passed} passed, {failed} failed")
    return passed, failed
