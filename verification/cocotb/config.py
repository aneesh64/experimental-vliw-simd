from __future__ import annotations

from dataclasses import dataclass
import os
from pathlib import Path


@dataclass(frozen=True)
class TestConfig:
    config_path: Path
    n_alu_slots: int
    n_valu_slots: int
    n_load_slots: int
    n_store_slots: int
    n_flow_slots: int
    mem_post_gap: int
    vlen: int
    scratch_size: int
    imem_depth: int
    clock_period_ns: int
    rtl_generator_core: str
    rtl_generator_all: str


def _project_root_from(path_hint: Path | None = None) -> Path:
    if path_hint is None:
        return Path(__file__).parents[2]
    return path_hint if path_hint.is_dir() else path_hint.parent


def default_config_path(project_root: Path | None = None) -> Path:
    root = _project_root_from(project_root)
    return root / "verification" / "config" / "test_config.properties"


def bundle_width_bits(n_alu_slots: int, n_valu_slots: int, n_load_slots: int, n_store_slots: int, n_flow_slots: int) -> int:
    raw = (40 * n_alu_slots +
           56 * n_valu_slots +
           48 * n_load_slots +
           28 * n_store_slots +
           48 * n_flow_slots)
    return ((raw + 63) // 64) * 64


def _parse_properties(path: Path) -> dict[str, str]:
    data: dict[str, str] = {}
    for raw in path.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        if not line or line.startswith("#"):
            continue
        if "=" not in line:
            continue
        key, value = line.split("=", 1)
        data[key.strip()] = value.strip()
    return data


def _get_int(props: dict[str, str], key: str, default: int, min_value: int = 1) -> int:
    raw = props.get(key, str(default))
    try:
        value = int(raw)
    except ValueError as exc:
        raise ValueError(f"Invalid integer for '{key}': {raw!r}") from exc
    if value < min_value:
        raise ValueError(f"Invalid value for '{key}': expected >= {min_value}, got {value}")
    return value


def load_test_config(config_path: Path | None = None, project_root: Path | None = None) -> TestConfig:
    if config_path is None:
        env_cfg = os.getenv("VLIW_CONFIG_FILE")
        if env_cfg:
            cfg_path = Path(env_cfg)
            if not cfg_path.is_absolute():
                cfg_path = _project_root_from(project_root) / cfg_path
        else:
            cfg_path = default_config_path(project_root)
    else:
        cfg_path = config_path

    cfg_path = cfg_path.resolve()
    if not cfg_path.exists():
        raise FileNotFoundError(f"Config file not found: {cfg_path}")

    props = _parse_properties(cfg_path)

    return TestConfig(
        config_path=cfg_path,
        n_alu_slots=_get_int(props, "slots.alu", 1),
        n_valu_slots=_get_int(props, "slots.valu", 1),
        n_load_slots=_get_int(props, "slots.load", 1),
        n_store_slots=_get_int(props, "slots.store", 1),
        n_flow_slots=_get_int(props, "slots.flow", 1),
        mem_post_gap=_get_int(props, "scheduler.mem_post_gap", 0, min_value=0),
        vlen=_get_int(props, "arch.vlen", 8),
        scratch_size=_get_int(props, "arch.scratch_size", 1536),
        imem_depth=_get_int(props, "arch.imem_depth", 1024),
        clock_period_ns=_get_int(props, "clock.period_ns", 10),
        rtl_generator_core=props.get("rtl.generator.core", "vliw.gen.GenerateCore"),
        rtl_generator_all=props.get("rtl.generator.all", "vliw.gen.GenerateAllModules"),
    )


def slot_env(cfg: TestConfig) -> dict[str, str]:
    return {
        "VLIW_N_ALU_SLOTS": str(cfg.n_alu_slots),
        "VLIW_N_VALU_SLOTS": str(cfg.n_valu_slots),
        "VLIW_N_LOAD_SLOTS": str(cfg.n_load_slots),
        "VLIW_N_STORE_SLOTS": str(cfg.n_store_slots),
        "VLIW_N_FLOW_SLOTS": str(cfg.n_flow_slots),
        "N_ALU_SLOTS": str(cfg.n_alu_slots),
        "N_VALU_SLOTS": str(cfg.n_valu_slots),
        "N_LOAD_SLOTS": str(cfg.n_load_slots),
        "N_STORE_SLOTS": str(cfg.n_store_slots),
        "N_FLOW_SLOTS": str(cfg.n_flow_slots),
        "VLIW_MEM_POST_GAP": str(cfg.mem_post_gap),
    }
