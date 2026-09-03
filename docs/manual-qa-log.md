# Manual QA Log

## 2026-08-23

Environment:

- OS: Windows
- Python: 3.13.15
- Node.js: 24.19.0
- npm: 11.17.0
- TeX engine: MiKTeX-pdfTeX 4.26 (MiKTeX 26.2)

Checks:

- LaTeX PDF visual review: approved by user.
- VS Code Extension Host review: approved by user.

LaTeX notes:

- Command: `otcalc latex-build examples/latex/sample.tex --compile`
- Output: `examples/latex/sample.pdf`
- Preview rendered with `pypdfium2`.
- Renderer spacing was adjusted before approval so explanation labels and math no longer collide.

VS Code notes:

- Scratch file: `%TEMP%\otmath-vscode-qa.txt`
- Extension Host used `otmath.otcalcPath` pointing to the local `.venv\Scripts\otcalc.exe`.
- `OT Math: Solve Selection` passed.
- `OT Math: Explain Selection` passed.
- `OT Math: Insert LaTeX Result` passed.
- `OT Math: Show Result` passed.

## 2026-08-31

Environment:

- OS: Windows
- VS Code: 1.135.0
- Extension: OT Math 0.1.0 beta-track local Extension Host

Checks:

- Extension command-builder compile/test: passed.
- `OT Math: Run Selected Operation` command is contributed and activation is declared.
- Installed `vscode-otmath-0.1.0.vsix` locally and confirmed VS Code shows OT Math
  version `0.1.0` from a VSIX source.
- Command Palette smoke check confirmed `OT Math: Run Selected Operation` is visible.
- Supported-operation picker covers symbolic, numeric, statistics, unit, system, and
  matrix CLI commands.
- `OT Math: Diagnose Extension` includes active document data, resolved commands, and a
  local `otcalc --version` probe.
- Local VSIX packaging passed with only runtime files, README, package metadata, and
  license included.
- Bundled LaTeX macro follow-up passed:
  `npm test` synced `integrations/latex/otmath.sty` into
  `extensions/vscode-otmath/latex/otmath.sty`, and VSIX packaging included
  `latex/otmath.sty`.
- Release verification passed:
  `.venv\Scripts\python.exe -m ruff check .`,
  `.venv\Scripts\python.exe -m mypy src`,
  `.venv\Scripts\python.exe -m pytest`,
  `python -m build`, and `npm test`.

Notes:

- On-save LaTeX refresh had already been verified from the OT Math output panel after
  the local extension was activated.
- Diagnostic command implementation was covered by TypeScript compile and command
  contribution checks; the live command-palette smoke check was limited to visibility
  because the window-control layer reported focus-safety interruptions during execution.

## 2026-09-03

Environment:

- OS: Windows
- Extension: OT Math 0.1.0 beta-track local VSIX build

Checks:

- Parser follow-up passed for braced, parenthesized, and simple one-token LaTeX
  function arguments.
- Matrix domain follow-up passed for `norm` and `cond` through engine, CLI, LaTeX
  builder, and VS Code operation picker coverage.
- LaTeX workflow follow-up passed for `OT Math: Check Setup` and
  `OT Math: Insert LaTeX Setup Snippet` TypeScript compile coverage.
- Bundled macro sync passed and kept `extensions/vscode-otmath/latex/otmath.sty`
  aligned with `integrations/latex/otmath.sty`.
- Release verification passed:
  `.venv\Scripts\python.exe -m ruff check .`,
  `.venv\Scripts\python.exe -m mypy src`,
  `.venv\Scripts\python.exe -m pytest`,
  `python -m build`, `npm test`, and VSIX packaging.
