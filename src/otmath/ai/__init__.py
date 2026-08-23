"""Optional AI adapter boundary.

The default provider is intentionally `none`. AI providers must never become
required for deterministic math operations.
"""

from otmath.ai.providers import (
    AIProvider,
    FakeAIProvider,
    NoAIProvider,
    ProviderConfig,
    redact_mapping,
    select_provider,
    structured_request_prompt,
    validate_provider_output,
)

__all__ = [
    "AIProvider",
    "FakeAIProvider",
    "NoAIProvider",
    "ProviderConfig",
    "redact_mapping",
    "select_provider",
    "structured_request_prompt",
    "validate_provider_output",
]
