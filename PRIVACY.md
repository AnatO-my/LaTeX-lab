# Privacy Principles

OT Math should be useful without sending data anywhere.

## Defaults

- AI provider: none.
- Telemetry: off.
- Local history: off.
- Cloud provider keys: not required.
- Network calls in tests: none.

## User Control

If a future feature sends prompts, expressions, documents, logs, or metadata to an external service, it must be:

- Clearly documented.
- Explicitly configured by the user.
- Possible to disable.
- Covered by tests or manual verification.

## Logging

Logs must avoid recording:

- API keys.
- Full private documents.
- Sensitive prompts by default.
- Environment variables containing secrets.

Use redaction helpers before adding diagnostic output.
