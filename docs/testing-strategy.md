# Testing Strategy

OT Math must be trustworthy because users will rely on it for mathematical reasoning. Tests should be layered, deterministic, and privacy-preserving.

## Default Test Requirements

- No network access.
- No live AI provider calls.
- No secrets.
- No telemetry.
- Deterministic outputs where possible.

## Test Layers

### Unit Tests

Cover individual functions:

- Parser accepts supported syntax.
- Parser rejects unsafe or invalid input.
- Engine operations return expected results.
- Renderers produce expected text and LaTeX.
- Config helpers handle missing and malformed input.
- Redaction helpers remove sensitive values.

### Integration Tests

Cover boundaries:

- CLI calls engine correctly.
- CLI JSON output is parseable.
- VS Code command builder invokes the expected local command.
- LaTeX snippets are generated from engine output.

### Optional Environment Tests

These may run only when local tools are available:

- TeX compilation.
- VS Code extension host tests.
- Local Ollama-compatible provider tests.

Optional tests must skip clearly when dependencies are missing.

### Regression Tests

Every bug fix should add a regression test that would have failed before the fix.

## Acceptance By Phase

Each phase in `PROJECT_PHASES.md` includes its own test requirements. A phase is not complete until tests exist for its public behavior and failure paths.

## Manual QA

Manual QA should be documented when automated coverage is impractical, especially for:

- VS Code command palette behavior.
- Editor selection replacement.
- LaTeX PDF rendering.
- Cross-platform shell quoting.
