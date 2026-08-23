import pytest

from otmath.ai import (
    FakeAIProvider,
    NoAIProvider,
    ProviderConfig,
    redact_mapping,
    select_provider,
    structured_request_prompt,
    validate_provider_output,
)
from otmath.errors import AIProviderError
from otmath.models import MathOperation


def test_no_ai_provider_rejects_parsing() -> None:
    provider = NoAIProvider()

    with pytest.raises(AIProviderError):
        provider.parse_request("solve x squared")


def test_fake_provider_returns_validated_request() -> None:
    provider = FakeAIProvider(
        {
            "operation": "solve",
            "expression": "x**2 - 5*x + 6",
            "variable": "x",
        }
    )

    request = provider.parse_request("solve the quadratic")

    assert request.operation is MathOperation.SOLVE
    assert request.expression == "x**2 - 5*x + 6"


def test_validate_provider_output_rejects_missing_fields() -> None:
    with pytest.raises(AIProviderError):
        validate_provider_output({"operation": "solve"})


def test_validate_provider_output_rejects_malformed_assumptions() -> None:
    with pytest.raises(AIProviderError):
        validate_provider_output(
            {
                "operation": "solve",
                "expression": "x",
                "assumptions": "real",
            }
        )


def test_select_provider_defaults_to_none() -> None:
    provider = select_provider(ProviderConfig())

    assert provider.name == "none"


def test_select_provider_rejects_unknown_provider() -> None:
    with pytest.raises(AIProviderError):
        select_provider(ProviderConfig(name="cloud"))


def test_structured_request_prompt_instructs_provider_not_to_solve() -> None:
    prompt = structured_request_prompt("solve x squared equals four")

    assert "Do not solve" in prompt
    assert "operation" in prompt


def test_redact_mapping_redacts_sensitive_values() -> None:
    redacted = redact_mapping(
        {
            "api_key": "secret",
            "nested": {"authorization_header": "Bearer token"},
            "provider": "none",
        }
    )

    assert redacted["api_key"] == "[REDACTED]"
    assert redacted["nested"]["authorization_header"] == "[REDACTED]"
    assert redacted["provider"] == "none"
