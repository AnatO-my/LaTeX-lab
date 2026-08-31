# Manual QA

Automated tests cover the deterministic engine, CLI, LaTeX generation, package build,
and VS Code command assembly. Human QA is still required for interfaces that depend on
editor UI behavior or visual document review.

## VS Code Extension Host

Run from `extensions/vscode-otmath`:

```bash
npm install
npm test
```

Then open the extension in a VS Code Extension Host and verify:

- Extension activates without errors.
- `OT Math: Solve Selection` sends selected text to the configured local `otcalc`.
- `OT Math: Explain Selection` displays deterministic steps.
- `OT Math: Insert LaTeX Result` replaces the selected expression with LaTeX output.
- `OT Math: Show Result` opens output without mutating the document.
- `OT Math: Run Selected Operation` runs at least one newer domain command from the
  picker, such as `nsolve`, `mean`, or `unit`.
- `OT Math: Diagnose Extension` reports the active document, resolved commands, and
  local `otcalc --version` probe.
- Paths with spaces work when `otmath.otcalcPath` points to the local command.
- The extension works with `provider=none` and without network access.

## LaTeX Document Output

Run from the repository root:

```bash
otcalc latex-build examples/latex/sample.tex --compile
```

Then visually inspect `examples/latex/sample.pdf` and verify:

- The quadratic expression renders in display math.
- The equation line renders with the generated left-hand side.
- The system result renders as `{ x = 3, y = 2 }`.
- The explanation steps render as an aligned display.
- There are no missing-result placeholders in the PDF.

## Release Gate

Before a beta release, record the operating system, Python version, Node version, TeX
engine, and VS Code version used for manual QA in the release notes.
