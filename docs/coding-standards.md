# Coding Standards

## Python

- Target Python 3.11 or newer.
- Prefer typed public functions.
- Use dataclasses or typed models for structured data.
- Keep public APIs exported from `otmath.__init__`.
- Avoid arbitrary evaluation of user input.
- Keep engine logic separate from CLI formatting.
- Add docstrings to public functions.

## TypeScript

- Use TypeScript for the VS Code extension.
- Keep command construction testable without launching VS Code.
- Avoid hidden network calls.
- Treat local process execution as a boundary that needs validation and friendly errors.

## Tests

- Add tests for every behavior change.
- Keep default tests offline.
- Use fake providers for AI adapter tests.
- Prefer small, deterministic fixtures.
- Add regression tests for reported math bugs.

## Documentation

- Update docs in the same change as behavior.
- Document limitations plainly.
- Include examples for user-facing commands.
- Keep security and privacy notes close to features that need them.

## Style

- Use clear names over clever abbreviations.
- Keep modules focused.
- Keep formatting automated with Ruff where possible.
- Do not introduce broad abstractions before repeated patterns exist.
