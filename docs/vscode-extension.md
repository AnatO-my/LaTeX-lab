# VS Code Extension

The VS Code extension should connect editor selections to the local OT Math engine.

## Commands

- Solve selected expression.
- Explain selected expression.
- Insert LaTeX result.
- Show result in an output panel.

## Local CLI Bridge

The extension calls the configured local `otcalc` executable using argument arrays rather
than shell strings. This keeps expressions with spaces or operators away from shell
interpolation problems.

## Settings

- `otmath.otcalcPath`: path to `otcalc`
- `otmath.provider`: currently `none`
- `otmath.privacyMode`: currently `localOnly`
- `otmath.variable`: default variable

## Manual QA

Before release, verify in a VS Code extension host. See [manual-qa.md](manual-qa.md)
for the release checklist.

- Extension activates without errors.
- `OT Math: Solve Selection` shows a result for selected text.
- `OT Math: Explain Selection` shows deterministic steps.
- `OT Math: Insert LaTeX Result` replaces selection with LaTeX.
- Paths with spaces work when `otmath.otcalcPath` points to the local command.

## Privacy

The extension must work offline and must not include bundled provider keys.
