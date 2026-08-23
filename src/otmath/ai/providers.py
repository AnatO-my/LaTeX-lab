"""Provider interfaces for optional AI interpretation."""

from __future__ import annotations

from collections.abc import Mapping
from dataclasses import dataclass, field
from typing import Any, Protocol

from otmath.errors import AIProviderError
from otmath.models import MathRequest


@dataclass(frozen=True)
class ProviderConfig:
    """Configuration for selecting an optional AI provider."""

    name: str = "none"
    settings: dict[str, str] = field(default_factory=dict)


class AIProvider(Protocol):
    """Provider-neutral interface for future AI adapters."""

    name: str

    def parse_request(self, prompt: str) -> MathRequest:
        """Convert a natural-language prompt to a validated math request."""


class NoAIProvider:
    """Default provider used when AI is disabled."""

    name = "none"

    def parse_request(self, prompt: str) -> MathRequest:
        raise AIProviderError("AI parsing is disabled. Use a structured math command instead.")


class FakeAIProvider:
    """Deterministic fake provider for tests and adapter contract development."""

    name = "fake"

    def __init__(self, output: Mapping[str, Any]) -> None:
        self._output = output

    def parse_request(self, prompt: str) -> MathRequest:
        if not prompt.strip():
            raise AIProviderError("Prompt cannot be empty.")
        return validate_provider_output(self._output)


def select_provider(config: ProviderConfig) -> AIProvider:
    """Select an AI provider from configuration without making network calls."""

    if config.name == "none":
        return NoAIProvider()
    if config.name == "fake":
        return FakeAIProvider(config.settings)
    raise AIProviderError(f"Unsupported AI provider: {config.name}")


def validate_provider_output(output: Mapping[str, Any]) -> MathRequest:
    """Validate untrusted provider output into a structured math request."""

    try:
        operation = output["operation"]
        expression = output["expression"]
    except KeyError as exc:
        raise AIProviderError(f"Provider output missing field: {exc.args[0]}") from exc

    variable = output.get("variable", "x")
    assumptions = output.get("assumptions", {})
    if not isinstance(assumptions, dict):
        raise AIProviderError("Provider output assumptions must be a dictionary.")

    try:
        return MathRequest(
            operation=operation,
            expression=expression,
            variable=variable,
            assumptions=assumptions,
        )
    except Exception as exc:
        raise AIProviderError(f"Provider output did not validate: {exc}") from exc


def structured_request_prompt(prompt: str) -> str:
    """Build a provider-neutral prompt for natural-language parsing."""

    return (
        "Convert the user's math request into JSON with operation, expression, "
        "variable, and assumptions. Do not solve the problem.\n"
        f"User request: {prompt}"
    )


_SENSITIVE_KEY_PARTS = ("api_key", "authorization", "token", "secret", "prompt")


def redact_mapping(values: Mapping[str, Any]) -> dict[str, Any]:
    """Redact sensitive provider settings before logging or diagnostics."""

    redacted: dict[str, Any] = {}
    for key, value in values.items():
        normalized = key.lower()
        if any(part in normalized for part in _SENSITIVE_KEY_PARTS):
            redacted[key] = "[REDACTED]"
        elif isinstance(value, Mapping):
            redacted[key] = redact_mapping(value)
        else:
            redacted[key] = value
    return redacted
