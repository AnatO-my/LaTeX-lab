# VS Code Extension

The VS Code extension should connect editor selections to the local OT Math engine.

## Commands

- Solve selected expression.
- Explain selected expression.
- Insert LaTeX result.
- Show result in an output panel.
- Run any supported selected operation from a picker.
- Refresh generated LaTeX results for the current `.tex` document.
- Build the current `.tex` document.
- Refresh and view the current `.tex` document's PDF.
- Install the bundled `otmath.sty` macros into the active document folder or workspace.
- Diagnose extension activation, settings, generated include detection, and resolved CLI commands.

## LaTeX On Save

By default, saving a `.tex` document that contains `\OTMathCompute` or `\OTMathExplain`
refreshes its generated OT Math include file. The save hook does not compile the
document; LaTeX Workshop can keep handling build and view commands such as
`Ctrl+Alt+B` and `Ctrl+Alt+V`.

When a document declares a generated include such as
`\OTMathGeneratedInput{generated/otmath-stress-results.tex}`, the extension writes back
to that same include path. This keeps custom generated files such as the stress bench
from falling back to the default `generated/otmath-results.tex` path.

## Local CLI Bridge

The extension calls the configured local `otcalc` executable using argument arrays rather
than shell strings. This keeps expressions with spaces or operators away from shell
interpolation problems.

When `otmath.otcalcPath` is left as the default `otcalc`, document build commands prefer
the workspace `.venv` Python executable when it exists and run `python -m otcalc.cli`.
The OT Math output panel prints the exact command and working directory before the build
starts.

If on-save refresh does not run, execute `OT Math: Diagnose Extension` from the Command
Palette with the `.tex` file active. If that command is missing, the local extension is
not installed or the Extension Host is not running the compiled extension. If it appears,
copy the OT Math output panel diagnostics for debugging. Diagnostics include a local
`otcalc --version` probe so the active CLI path can be checked quickly.

The extension packages a synced copy of `integrations/latex/otmath.sty` at
`latex/otmath.sty`. Use `OT Math: Install LaTeX Macros Into Workspace` to copy that
file beside the active `.tex` document, or into the first workspace folder when no
`.tex` file is active. Existing `otmath.sty` files require confirmation before
replacement.

## Settings

- `otmath.otcalcPath`: path to `otcalc`
- `otmath.provider`: currently `none`
- `otmath.privacyMode`: currently `localOnly`
- `otmath.variable`: default variable
- `otmath.latexEngine`: LaTeX engine for document build commands, default `pdflatex`
- `otmath.refreshLatexOnSave`: refresh generated snippets on `.tex` save, default `true`

## Manual QA

Before release, verify in a VS Code extension host. See [manual-qa.md](manual-qa.md)
for the release checklist.

- Extension activates without errors.
- `OT Math: Solve Selection` shows a result for selected text.
- `OT Math: Explain Selection` shows deterministic steps.
- `OT Math: Insert LaTeX Result` replaces selection with LaTeX.
- `OT Math: Run Selected Operation` can run at least one newer domain command, such as
  `nsolve`, `mean`, or `unit`.
- `OT Math: Diagnose Extension` reports the active document and resolved CLI commands.
- Saving a `.tex` file with OT Math requests refreshes the generated include.
- `OT Math: Build LaTeX Document` refreshes generated snippets and compiles the active `.tex` file.
- `OT Math: Refresh and View LaTeX PDF` refreshes generated snippets and opens the compiled PDF.
- `OT Math: Install LaTeX Macros Into Workspace` copies `otmath.sty` to the expected
  local document or workspace folder and asks before overwriting.
- Paths with spaces work when `otmath.otcalcPath` points to the local command.

## Privacy

The extension must work offline and must not include bundled provider keys.
