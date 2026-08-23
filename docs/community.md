# Community

OT Math is pre-alpha software moving toward beta use. Community work should keep the
project welcoming, mathematically careful, privacy-preserving, and easy to review.

## Asking For Help

Open an issue with:

- The exact command or Python snippet.
- The expression or equations used.
- The expected result.
- The actual output.
- The operating system and Python version.

Do not post API keys, private documents, unpublished notes, or sensitive data.

## Contributor Onboarding Tasks

Good first contributions include:

- Add a missing CLI example to the docs.
- Add a regression test for a parser rejection case.
- Improve a warning message without changing behavior.
- Add a system-of-equations example.
- Expand documentation for shell quoting on a platform you use.
- Add a skipped optional test for a local tool such as TeX.

## Triage Labels

Maintainers should use labels consistently:

- `needs-triage`: issue has not been reviewed yet.
- `bug`: existing behavior is incorrect or regressed.
- `enhancement`: new capability or improvement.
- `docs`: documentation-only change.
- `good-first-issue`: small, well-scoped contributor task.
- `help-wanted`: maintainers agree outside help is useful.
- `security`: security or privacy-sensitive work.
- `parser`: parser syntax, validation, or safety.
- `engine`: deterministic math behavior.
- `cli`: command-line behavior.
- `vscode`: VS Code extension work.
- `latex`: LaTeX integration work.
- `manual-qa`: human verification for editor or document workflows.

## Triage Process

1. Confirm whether the report includes a reproducible command or snippet.
2. Decide whether the issue is a bug, enhancement, documentation task, or question.
3. Check whether the default path stays local and offline.
4. Ask for a minimal expression when the report includes a large private example.
5. Add the narrowest component label.
6. Mark small, clear tasks as `good-first-issue`.

## Support Expectations

OT Math is not a hosted service. Maintainers should prioritize reproducible bugs,
security/privacy concerns, installation blockers, and documentation that helps users
make progress without private support.
