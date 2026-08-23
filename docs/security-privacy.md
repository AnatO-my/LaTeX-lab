# Security And Privacy

OT Math is local-first. The project should protect user trust even when optional AI providers are introduced.

## Defaults

- AI provider is `none`.
- Telemetry is disabled.
- Local history is disabled.
- Privacy mode is `local`.
- Network calls are absent from default tests.
- Cloud provider keys are never bundled.

## User Input

Mathematical input is untrusted. The engine must not execute raw input as Python code. Parsing should be limited to symbolic math syntax and validated before operation dispatch.

## AI Provider Output

AI output is also untrusted. Provider output must be validated into structured request models before it reaches the engine.

The adapter boundary validates provider output through `MathRequest`. Unknown operations,
empty expressions, invalid variables, and malformed assumptions are rejected. Default tests
use only `none` and fake providers; they must not call live services.

## Secrets

Secrets must not be committed. Documentation may show placeholder names only, such as:

```text
OTMATH_GROQ_API_KEY=
```

## Logs

Logs should avoid sensitive content by default. Future diagnostic modes should redact:

- API keys.
- Authorization headers.
- Full private prompts.
- File paths when privacy mode requires it.

Use `redact_mapping` for provider settings before adding diagnostic output.

## Configuration

Config files are optional. Environment variables can override config file values, but
unsupported providers and privacy modes are rejected. History is never written unless the
user opts in through CLI flags, config, or environment.

## Shell Escape And LaTeX

LaTeX shell escape can execute commands on the user's machine. OT Math should prefer pre-generated snippets and treat shell escape workflows as advanced, optional, and documented.

## Extension Privacy

The VS Code extension must disclose what data it sends to local processes or configured providers. It must work offline.
