# Release Process

This project is beta-track. The release process should stay strict before publishing
packages or sharing packaged editor builds.

## Checklist

- All tests pass.
- Lint and type checks pass.
- README quick start is accurate.
- CHANGELOG is updated.
- Version number is updated.
- Package builds locally.
- Optional extension package builds if included in the release.
- Extension Host QA is recorded for command-palette, selection, and LaTeX refresh flows.
- Security and privacy notes are current.
- No secrets are required for normal pull request CI.
- Optional toolchains either run successfully or skip clearly.

## Local Verification

```bash
ruff check src tests examples
mypy src tests
pytest
python -m build
```

For the VS Code extension:

```bash
cd extensions/vscode-otmath
npm ci
npm test
```

## Versioning

The Python package version is currently declared in `pyproject.toml`. The VS Code
extension version is declared in `extensions/vscode-otmath/package.json`.

During beta, use `0.x.y` versions:

- Patch changes for fixes and documentation-only release polish.
- Minor changes for new CLI, engine, extension, or integration capabilities.
- Avoid publishing if tests, type checks, or package builds fail.

For local beta tags, prefer `v0.x.y-beta.n` until the first public package is ready.

## Release Notes

Each release should summarize:

- Engine behavior changes.
- CLI and integration changes.
- Privacy/security impact.
- Known limitations.
- Verification commands run.
