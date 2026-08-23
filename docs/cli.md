# CLI

`otcalc` is the command-line interface for OT Math.

## Commands

```bash
otcalc solve "x**2 - 5*x + 6"
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc simplify "(x + 1)**2 - x**2"
otcalc diff "x**3"
otcalc integrate "2*x"
otcalc expand "(x - 2)*(x - 3)"
otcalc factor "x**2 - 5*x + 6"
otcalc latex "x**2 - 5*x + 6"
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve
otcalc latex-build examples/latex/sample.tex
```

## Options

- `--variable`, `-v`: variable name, default `x`. For `system`, pass comma-separated
  variables such as `x,y`; the default is `x,y`.
- `--format text|json|latex`: output format.
- `--provider none`: explicit AI-disabled provider mode.
- `--no-ai`: compatibility flag for explicitly local deterministic execution.
- `--config PATH`: optional JSON config file path.
- `--quiet`: suppress non-fatal warnings in text and LaTeX output modes.
- `--version`: print the installed `otcalc` version.
- `--history`: append successful results to a local JSON Lines history file.
- `--history-file PATH`: choose the history file path used with `--history`.

The `explain` command also accepts `--operation solve|system|simplify|diff|integrate|factor|expand`.
When no operation is supplied, it explains simplification.

The `latex-build` command scans a `.tex` file for `\OTMathCompute` and `\OTMathExplain`
macros, writes a generated include file, and can optionally compile the document with
`--compile`.

Text and LaTeX output print non-fatal warnings to stderr. JSON output keeps warnings in
the `warnings` field and does not print separate warning text.

Text output prints `No answers returned.` when an operation succeeds but returns no
answers.

JSON output includes the complete `MathResult` payload, including `answers`, `latex`,
`verified`, `warnings`, `steps`, and `metadata`.

## Exit Codes

- `0`: command completed.
- `1`: OT Math rejected the request or could not parse/process the expression.
- `2`: command-line usage error, such as an unknown command or invalid option.

## Local History

History is disabled by default. When `--history` is supplied, successful results are
appended as JSON Lines to `.otmath_history.jsonl` in the current directory unless
`--history-file PATH` is provided.

History entries include the full `MathResult` payload, including the input expression,
answers, LaTeX, verification status, warnings, and metadata. Failed requests are not
written.

## Configuration

Use `otcalc config show` to inspect resolved configuration and `otcalc config path` to
see the active or default config path. See [configuration.md](configuration.md) for the
schema, discovery order, and environment overrides.

## Input Syntax

The starter CLI accepts SymPy-style expressions:

- Powers use `**`, as in `x**2`.
- Multiplication should be explicit, as in `5*x`.
- Supported common functions include `sin`, `cos`, `tan`, `log`, `ln`, `exp`, `sqrt`, and `abs`.
- Supported constants include `pi` and `E`.
- `solve` accepts either an expression treated as equal to zero or one explicit equation
  with `=`.
- `system` accepts equations separated by semicolons and variables separated by commas.
- Other commands accept expressions only, not equation input.

LaTeX input such as `e^{-x^{2}}` or `\int e^{-x^{2}}\,dx` is planned for a later adapter and is not accepted by the default parser yet.

## Shell Quoting

Quote expressions so your shell passes them as one argument.

PowerShell:

```powershell
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc integrate "exp(-x**2)"
```

Bash or zsh:

```bash
otcalc solve 'x**2 - 5*x + 6 = 0'
otcalc integrate 'exp(-x**2)'
```

Use quotes whenever an expression contains spaces, parentheses, `*`, or `=`.

## Privacy

The starter CLI does not call AI providers. It does not write history unless `--history`
is explicitly supplied.
