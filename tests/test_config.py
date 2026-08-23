import json
from pathlib import Path

import pytest

from otcalc.config import ConfigError, OtcalcConfig, config_path_message, load_config


def test_default_config_requires_no_file() -> None:
    config = load_config(env={})

    assert config == OtcalcConfig()


def test_load_config_from_json_file(tmp_path: Path) -> None:
    config_file = tmp_path / "config.json"
    config_file.write_text(
        json.dumps(
            {
                "provider": "none",
                "history": True,
                "history_file": "history.jsonl",
                "quiet": True,
                "privacy_mode": "local",
            }
        ),
        encoding="utf-8",
    )

    config = load_config(config_file, env={})

    assert config.history is True
    assert config.history_file == Path("history.jsonl")
    assert config.quiet is True


def test_environment_overrides_config_file(tmp_path: Path) -> None:
    config_file = tmp_path / "config.json"
    config_file.write_text(json.dumps({"history": False}), encoding="utf-8")

    config = load_config(
        config_file,
        env={
            "OTMATH_HISTORY": "true",
            "OTMATH_HISTORY_FILE": "env-history.jsonl",
            "OTMATH_QUIET": "yes",
        },
    )

    assert config.history is True
    assert config.history_file == Path("env-history.jsonl")
    assert config.quiet is True


def test_malformed_config_file_is_rejected(tmp_path: Path) -> None:
    config_file = tmp_path / "config.json"
    config_file.write_text("{", encoding="utf-8")

    with pytest.raises(ConfigError):
        load_config(config_file, env={})


def test_unsupported_provider_is_rejected(tmp_path: Path) -> None:
    config_file = tmp_path / "config.json"
    config_file.write_text(json.dumps({"provider": "cloud"}), encoding="utf-8")

    with pytest.raises(ConfigError):
        load_config(config_file, env={})


def test_invalid_boolean_environment_value_is_rejected() -> None:
    with pytest.raises(ConfigError):
        load_config(env={"OTMATH_HISTORY": "maybe"})


def test_config_path_message_uses_env_override(tmp_path: Path) -> None:
    config_file = tmp_path / "config.json"

    assert config_path_message(env={"OTMATH_CONFIG": str(config_file)}) == str(config_file)
