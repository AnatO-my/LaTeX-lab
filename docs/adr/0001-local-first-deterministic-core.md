# ADR 0001: Local-First Deterministic Core

## Status

Accepted

## Context

OT Math may eventually use AI models to understand natural-language prompts and draft explanations. However, users need reliable, reproducible mathematical answers.

## Decision

The deterministic engine is the authority for mathematical operations. AI support is optional and must be able to be disabled.

## Consequences

- Core math must work offline.
- AI provider output must be validated.
- Cloud providers require user-owned keys.
- Tests for default behavior must not require network access.
