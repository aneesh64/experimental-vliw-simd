#!/usr/bin/env python3
"""
Scheduler output validator: checks for hazards that hardware can't detect.

This validator ensures the scheduler has enforced the compiler's contract:
- No load-use hazards within LOAD_RESULT_LATENCY cycles
- No BRAM write-read conflicts in adjacent bundles
- At most 1 store per bundle

If the compiler breaks these, the validator will catch it before hardware issues.
Compiler should trust both this validator AND the hardware to be redundantly safe.

Usage:
    python scheduler_validator.py <schedule_json>
    OR call from scheduler: validator.validate_all(schedule)
"""

import json
import sys
from pathlib import Path


class ScheduleValidator:
    """Validates a VLIW schedule for compiler safety guarantees."""

    def __init__(self, bundles: list, config: dict):
        """
        Args:
            bundles: List of bundle dicts from schedule
            config: Config dict with LOAD_RESULT_LATENCY, n_slots, etc.
        """
        self.bundles = bundles
        self.cfg = config
        self.errors = []
        self.warnings = []

    def validate_load_use_latency(self):
        """
        Ensure no load-use within LOAD_RESULT_LATENCY cycles.
        
        The compiler knows that when a LOAD is issued at cycle N,
        the result is available at cycle N + LOAD_RESULT_LATENCY.
        Any read of that register must occur at cycle N + LOAD_RESULT_LATENCY + 1 or later.
        """
        load_result_latency = self.cfg.get("LOAD_RESULT_LATENCY", 20)

        # Map: register -> bundle_index_when_loaded
        load_destinations = {}

        for bundle_idx, bundle in enumerate(self.bundles):
            # Find loads in this bundle
            for op in bundle.get("ops", []):
                if op.get("type") == "load":
                    dest_reg = op.get("dest_register")
                    if dest_reg is not None:
                        load_destinations[dest_reg] = bundle_idx

            # Check for load-use hazards in this and all subsequent bundles
            for src_reg, load_bundle_idx in load_destinations.items():
                cycle_gap = bundle_idx - load_bundle_idx

                # Only check if we're looking at bundles after the load
                if cycle_gap > 0:
                    for op in bundle.get("ops", []):
                        for read_src in op.get("source_registers", []):
                            if read_src == src_reg and cycle_gap <= load_result_latency:
                                self.errors.append(
                                    f"Load-use hazard: "
                                    f"LOAD s[{src_reg}] at bundle {load_bundle_idx}, "
                                    f"consumed at bundle {bundle_idx} "
                                    f"(gap={cycle_gap}, need >{load_result_latency})"
                                )

    def validate_bram_write_read_conflict(self):
        """
        Ensure no BRAM write-read same register in adjacent bundles.
        
        Since BRAM reads are combinatorial (latency 0), a write in bundle N
        cannot provide data to a read in bundle N (they happen same cycle).
        And if write happens in N and read in N+1, the read gets old data
        (BRAM output is registered).
        
        So: minimum 2-cycle gap between write and read of same register.
        Simpler rule for compiler: write in N, read earliest at N+2.
        """

        for bundle_idx in range(len(self.bundles) - 1):
            bundle_now = self.bundles[bundle_idx]
            bundle_next = self.bundles[bundle_idx + 1]

            # Get write destinations from current bundle
            # Exclude 'store' and 'load' as those don't write to scratch registers
            written_regs = set()
            for op in bundle_now.get("ops", []):
                op_type = op.get("type")
                # Only ALU/VALU/const/immediate produce scratch register writes
                if op_type in ["alu", "valu", "const", "immediate"]:
                    dest_reg = op.get("dest_register")
                    if dest_reg is not None:
                        written_regs.add(dest_reg)

            # Check if next bundle reads any of them (BRAM conflict)
            for op in bundle_next.get("ops", []):
                for src_reg in op.get("source_registers", []):
                    if src_reg in written_regs:
                        self.errors.append(
                            f"BRAM write-read conflict: "
                            f"bundle {bundle_idx} writes s[{src_reg}], "
                            f"bundle {bundle_idx + 1} reads s[{src_reg}] "
                            f"(need 2-cycle gap)"
                        )

    def validate_store_count(self):
        """Ensure at most 1 store per bundle."""
        for bundle_idx, bundle in enumerate(self.bundles):
            store_ops = [op for op in bundle.get("ops", []) if op.get("type") == "store"]
            if len(store_ops) > 1:
                self.errors.append(
                    f"Multiple stores in bundle {bundle_idx}: {len(store_ops)} stores "
                    f"(max 1 allowed)"
                )

    def validate_single_issue_requirement(self):
        """
        If compiler guarantees single-issue (at most 1 non-bubble op per bundle),
        ensure this holds. Optional check, depends on pipeline config.
        """
        max_ops_per_slot = self.cfg.get("max_ops_per_slot", 1)  # Usually 1

        for bundle_idx, bundle in enumerate(self.bundles):
            ops = bundle.get("ops", [])
            non_bubble_ops = [op for op in ops if op.get("type") != "bubble"]

            if len(non_bubble_ops) > max_ops_per_slot:
                self.warnings.append(
                    f"Bundle {bundle_idx} has {len(non_bubble_ops)} non-bubble ops "
                    f"(max {max_ops_per_slot} per slot). "
                    f"May cause issues if hardware expects single-issue."
                )

    def validate_all(self) -> tuple[bool, list[str], list[str]]:
        """
        Run all validators.
        
        Returns:
            (passed: bool, errors: list[str], warnings: list[str])
        """
        self.validate_load_use_latency()
        self.validate_bram_write_read_conflict()
        self.validate_store_count()
        self.validate_single_issue_requirement()

        return len(self.errors) == 0, self.errors, self.warnings

    def print_results(self):
        """Print validation results to stdout."""
        for err in self.errors:
            print(f"ERROR: {err}")
        for warn in self.warnings:
            print(f"WARN: {warn}")

        passed = len(self.errors) == 0
        print(f"\nValidation: {'PASSED' if passed else 'FAILED'}")
        if passed:
            print(f"Schedule is safe (0 errors, {len(self.warnings)} warnings)")
        else:
            print(f"Schedule has {len(self.errors)} critical errors")

        return passed


def validate_schedule_file(json_file: str) -> bool:
    """
    Load a schedule JSON file and validate it.
    
    Expected JSON structure:
    {
        "schedule": {
            "bundles": [
                {
                    "ops": [
                        {
                            "type": "const",
                            "dest_register": 0,
                            "source_registers": []
                        },
                        ...
                    ]
                },
                ...
            ]
        },
        "config": {
            "LOAD_RESULT_LATENCY": 20,
            "n_alu_slots": 1,
            ...
        }
    }
    """
    with open(json_file) as f:
        data = json.load(f)

    bundles = data["schedule"]["bundles"]
    config = data.get("config", {})

    validator = ScheduleValidator(bundles, config)
    passed, errors, warnings = validator.validate_all()
    validator.print_results()

    return passed


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python scheduler_validator.py <schedule.json>")
        sys.exit(1)

    schedule_file = sys.argv[1]
    if not Path(schedule_file).exists():
        print(f"ERROR: File not found: {schedule_file}")
        sys.exit(1)

    try:
        passed = validate_schedule_file(schedule_file)
        sys.exit(0 if passed else 1)
    except Exception as e:
        print(f"ERROR: {e}")
        import traceback

        traceback.print_exc()
        sys.exit(1)
