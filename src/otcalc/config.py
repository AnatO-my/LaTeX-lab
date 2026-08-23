"""Configuration helpers for the OT Math CLI."""

from __future__ import annotations

import json
import os
from collections.abc import Mapping
from dataclasses import dataclass
from pathlib import Path
from typing import Any

from otmath.ai import redact_mapping
from otmath.errors import OTMathError


class ConfigError(OTMathError):
    """Raised when CLI configuration cannot be loaded."""


@dataclass(frozen=True)
class OtcalcConfig:
    """Resolved CLI configuration."""

    provider: str = "none"
    history: bool = False
    history_file: Path = Path(".otmath_history.jsonl")
    quiet: bool = False
    privacy_mode: str = "local"

    def as_dict(self) -> dict[str, Any]:
        """Return a JSON-serializable representation."""

        return {
            "provider": self.provider,
            "history": self.history,
            "history_file": str(self.history_file),
            "quiet": self.quiet,
            "privacy_mode": self.privacy_mode,
        }

    def redacted_dict(self) -> dict[str, Any]:
        """Return redacted configuration for diagnostics."""

        return redact_mapping(self.as_dict())


def default_config_path(env: Mapping[str, str] | None = None) -> Path:
    """Return the default user config path."""

    values = env or os.environ
    if values.get("APPDATA"):
        return Path(values["APPDATA"]) / "otmath" / "config.json"
    return Path.home() / ".config" / "otmath" / "config.json"


def discover_config_path(env: Mapping[str, str] | None = None) -> Path | None:
    """Discover an optional config file without requiring one."""

    values = env or os.environ
    if values.get("OTMATH_CONFIG"):
        return Path(values["OTMATH_CONFIG"])

    local_config = Path(".otmath.json")
    if local_config.exists():
        return local_config

    user_config = default_config_path(values)
    if user_config.exists():
        return user_config
    return None


def load_config(
    path: Path | None = None,
    *,
    env: Mapping[str, str] | None = None,
) -> OtcalcConfig:
    """Load config from defaults, optional JSON file, and environment overrides."""

    values = env or os.environ
    config_data: dict[str, Any] = {}
    resolved_path = path if path is not None else discover_config_path(values)

    if resolved_path is not None:
        config_data.update(_read_config_file(resolved_path))

    _apply_env_overrides(config_data, values)
    return _config_from_mapping(config_data)


def config_path_message(path: Path | None = None, env: Mapping[str, str] | None = None) -> str:
    """Return the active or default config path as text."""

    resolved = path if path is not None else discover_config_path(env)
    if resolved is not None:
        return str(resolved)
    return str(default_config_path(env))


def _read_config_file(path: Path) -> dict[str, Any]:
    try:
        raw = path.read_text(encoding="utf-8")
        data = json.loads(raw)
    except OSError as exc:
        raise ConfigError(f"Could not read config file: {path}") from exc
    except json.JSONDecodeError as exc:
        raise ConfigError(f"Config file is not valid JSON: {path}") from exc

    if not isinstance(data, dict):
        raise ConfigError("Config file must contain a JSON object.")
    return data


def _apply_env_overrides(config_data: dict[str, Any], env: Mapping[str, str]) -> None:
    if "OTMATH_PROVIDER" in env:
        config_data["provider"] = env["OTMATH_PROVIDER"]
    if "OTMATH_HISTORY" in env:
        config_data["history"] = _parse_bool(env["OTMATH_HISTORY"])
    if "OTMATH_HISTORY_FILE" in env:
        config_data["history_file"] = env["OTMATH_HISTORY_FILE"]
    if "OTMATH_QUIET" in env:
        config_data["quiet"] = _parse_bool(env["OTMATH_QUIET"])
    if "OTMATH_PRIVACY_MODE" in env:
        config_data["privacy_mode"] = env["OTMATH_PRIVACY_MODE"]


def _config_from_mapping(data: Mapping[str, Any]) -> OtcalcConfig:
    provider = data.get("provider", "none")
    history = data.get("history", False)
    history_file = data.get("history_file", ".otmath_history.jsonl")
    quiet = data.get("quiet", False)
    privacy_mode = data.get("privacy_mode", "local")

    if provider != "none":
        raise ConfigError("Only provider 'none' is currently supported.")
    if privacy_mode != "local":
        raise ConfigError("Only privacy_mode 'local' is currently supported.")
    if not isinstance(history, bool):
        raise ConfigError("Config field 'history' must be a boolean.")
    if not isinstance(quiet, bool):
        raise ConfigError("Config field 'quiet' must be a boolean.")
    if not isinstance(history_file, str):
        raise ConfigError("Config field 'history_file' must be a string path.")

    return OtcalcConfig(
        provider=provider,
        history=history,
        history_file=Path(history_file),
        quiet=quiet,
        privacy_mode=privacy_mode,
    )


def _parse_bool(value: str) -> bool:
    normalized = value.strip().lower()
    if normalized in {"1", "true", "yes", "on"}:
        return True
    if normalized in {"0", "false", "no", "off"}:
        return False
    raise ConfigError(f"Invalid boolean environment value: {value}")
