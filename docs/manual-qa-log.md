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
