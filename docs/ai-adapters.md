# AI Adapters

AI adapters are optional. They are intended for interpretation and explanation, not authoritative solving.

## Default Provider

The default provider is `none`. It rejects natural-language parsing and directs callers
to use structured math commands instead.

```python
from otmath.ai import ProviderConfig, select_provider

provider = select_provider(ProviderConfig(name="none"))
```

## Adapter Contract

Providers must return structured output that validates into `MathRequest`:

```json
{
  "operation": "solve",
  "expression": "x**2 - 5*x + 6",
  "variable": "x",
  "assumptions": {}
}
```

Provider output is untrusted. OT Math validates it before it reaches the deterministic
engine. Invalid output raises `AIProviderError`.

## Fake Provider

`FakeAIProvider` exists for tests and adapter development. It is deterministic and makes
no network calls.

## Future Providers

Planned provider categories:

- Local runtime such as Ollama.
- Gemini with user-owned key.
- Groq with user-owned key.
- Hugging Face with user-owned key.

No shared project API key should be shipped.

## Validation

Provider output must be converted into structured models and validated before engine execution.

## Redaction

Use `redact_mapping` before logging provider settings. It redacts common sensitive keys
such as API keys, authorization headers, tokens, secrets, and prompts.
