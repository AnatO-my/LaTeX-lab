# Contributing To OT Math

Thank you for helping build OT Math. The project is intended to be friendly to new contributors while staying careful about correctness, privacy, and reproducibility.

## Start Here

1. Read `README.md`.
2. Read `docs/getting-started.md`.
3. Read `PROJECT_PHASES.md`.
4. Read `docs/architecture.md`.
5. Install the project in editable mode.
6. Run tests before making changes.

```bash
python -m pip install -e ".[dev]"
pytest
```

## Contribution Types

Contributions should fit one of these categories:

- Engine behavior.
- CLI behavior.
- Explanation steps.
- AI adapter boundaries.
- VS Code integration.
- LaTeX integration.
- Documentation.
- Tests and quality.
- Security and privacy.
- Examples.
- Release and packaging.
- Community and triage.

If your work does not fit a category, open an issue first.

## Good First Issues

Beginner-friendly issues should be small, reproducible, and labeled `good-first-issue`.
Good examples include docs examples, parser rejection tests, clearer warning text, or
small CLI coverage additions. See [docs/community.md](docs/community.md) for triage
labels and contributor onboarding tasks.

## Development Rules

- Keep the deterministic engine authoritative.
- Do not require AI for core math operations.
- Do not introduce cloud calls into default code paths.
- Do not commit secrets or sample real API keys.
- Add tests for behavior changes.
- Update documentation in the same pull request.
- Keep changes focused and reviewable.
- Prefer explicit models over loosely shaped dictionaries.

## Pull Request Checklist

- The change has a clear problem statement.
- Tests were added or updated.
- Relevant docs were updated.
- Privacy impact was considered.
- No secrets were added.
- Default tests run offline.
- The PR description includes verification steps.

## Review Standards

Review should prioritize:

- Mathematical correctness.
- Determinism.
- Security and privacy.
- API stability.
- Test coverage.
- Documentation clarity.
- Cross-platform behavior.

Style polish matters, but correctness and user trust matter more.
