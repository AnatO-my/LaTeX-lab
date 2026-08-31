# OT Math VS Code Extension

This extension connects editor selections to the local `otcalc` CLI.

## Commands

- `OT Math: Solve Selection`
- `OT Math: Explain Selection`
- `OT Math: Insert LaTeX Result`
- `OT Math: Show Result`
- `OT Math: Run Selected Operation`
- `OT Math: Refresh LaTeX Results`
- `OT Math: Build LaTeX Document`
- `OT Math: Refresh and View LaTeX PDF`
- `OT Math: Install LaTeX Macros Into Workspace`
- `OT Math: Diagnose Extension`

## LaTeX On Save

By default, saving a `.tex` document that contains `\OTMathCompute` or `\OTMathExplain`
refreshes its generated OT Math include file. The save hook does not compile the
document; LaTeX Workshop can keep handling build and view shortcuts.

The document commands detect generated include paths such as
`\OTMathGeneratedInput{generated/otmath-stress-results.tex}` and pass that path to
`otcalc latex-build` as `--output`.

When `otmath.otcalcPath` is left as the default `otcalc`, document commands prefer the
workspace `.venv` Python executable when one exists and run `python -m otcalc.cli`. The
OT Math output panel prints the exact command before the build starts.

If on-save refresh does not run, execute `OT Math: Diagnose Extension` from the Command
Palette with the `.tex` file active. If that command is missing, the local extension is
not installed or the Extension Host is not running the compiled extension.

`OT Math: Run Selected Operation` opens a picker for the supported local CLI operations,
including symbolic, numeric, statistics, unit, system, and matrix commands. It then asks
for the variable, range, mode, exponent, or target unit before running the selection.

The extension bundles `latex/otmath.sty` from the repository's source macro file. Use
`OT Math: Install LaTeX Macros Into Workspace` to copy `otmath.sty` beside the active
`.tex` document, or into the first workspace folder when no `.tex` file is active.

## Settings

- `otmath.otcalcPath`: path to the local `otcalc` command, default `otcalc`
- `otmath.provider`: provider mode, currently only `none`
- `otmath.privacyMode`: privacy mode, currently only `localOnly`
- `otmath.variable`: default variable, default `x`
- `otmath.latexEngine`: LaTeX engine for document builds, default `pdflatex`
- `otmath.refreshLatexOnSave`: refresh generated snippets on `.tex` save, default `true`

## Development

```bash
npm install
npm test
```

The test script syncs the bundled LaTeX macros, compiles TypeScript, and runs command
assembly tests. Record Extension Host smoke checks in `docs/manual-qa-log.md` before
tagging a beta.

## Privacy

The extension calls only the configured local `otcalc` command. It passes `--no-ai` and
supports only local-only privacy mode in this scaffold.
