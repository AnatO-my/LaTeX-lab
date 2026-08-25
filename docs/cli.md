# CLI

`otcalc` is the command-line interface for OT Math.

## Commands

```bash
otcalc solve "x**2 - 5*x + 6"
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc nsolve "cos(x) - x" --variable "x,0.5"
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc simplify "(x + 1)**2 - x**2"
otcalc diff "x**3"
otcalc integrate "2*x"
otcalc sum "k**2" --variable "k,1,n"
otcalc product "k" --variable "k,1,n"
otcalc limit "sin(x)/x" --variable "x,0,+-"
otcalc inequality "x <= 3"
otcalc det "[[1, 2], [3, 4]]"
otcalc order "[[1, 2, 3], [4, 5, 6]]"
otcalc rank "[[1, 2, 3], [2, 4, 6], [1, 0, 1]]"
otcalc trace "[[1, 2], [3, 4]]"
otcalc inverse "[[1, 2], [3, 4]]"
otcalc mpow "[[1, 1], [0, 1]]" --variable 3
otcalc transpose "[[1, 2], [3, 4]]"
otcalc conjugate "[[1 + I, 2], [3, 4 - I]]"
otcalc adjoint "[[1 + I, 2], [3, 4 - I]]"
otcalc rref "[[1, 2], [3, 4]]"
otcalc msolve "[[2, 1], [1, -1]]; [[5], [1]]"
otcalc nullspace "[[1, 2, 3], [2, 4, 6]]"
otcalc columnspace "[[1, 2, 3], [2, 4, 6]]"
otcalc rowspace "[[1, 2, 3], [2, 4, 6]]"
otcalc eigenvals "[[2, 0], [0, 3]]"
otcalc eigenvectors "[[2, 0], [0, 3]]"
otcalc diagonalize "[[2, 0], [0, 3]]"
otcalc lu "[[2, 1], [4, 3]]"
otcalc qr "[[1, 0], [1, 1]]"
otcalc cholesky "[[4, 2], [2, 3]]"
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

The `explain` command accepts the same deterministic operation names as the calculator
commands, including symbolic, system, and matrix operations. When no operation is
supplied, it explains simplification.

The `latex-build` command scans a `.tex` file for `\OTMathCompute` and `\OTMathExplain`
macros, writes a generated include file, and can optionally compile the document with
`--compile`.

If the document declares `\OTMathGeneratedInput{generated/name.tex}`, `latex-build`
writes to that declared include path. Otherwise it writes the default
`generated/otmath-results.tex` next to the source file. Plain LaTeX compilation reads
the generated include but does not recalculate it.

The `nsolve` command uses `--variable variable,initial_guess`; the default is `x,1`.
It returns one numeric solution near the supplied initial guess when SymPy can converge.
The `sum` and `product` commands use `--variable variable,lower,upper`. The `limit`
command uses `--variable variable,point[,direction]`, where direction is `+`, `-`, or
`+-`.

The matrix commands accept engine-style matrix literals such as
`[[1, 2], [3, 4]]`. The `mpow` command uses `--variable` as an integer exponent
until matrix-specific CLI options are introduced. The `msolve` command accepts an
`A; b` pair for linear systems in matrix form.

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
- Supported common functions include `sin`, `cos`, `tan`, `asin`, `acos`,
  `atan`, `log`, `ln`, `exp`, `sqrt`, and `abs`.
- Supported constants include `pi` and `E`.
- Matrix commands accept rectangular literals such as `[[1, 2], [3, 4]]`.
- `solve` accepts either an expression treated as equal to zero or one explicit equation
  with `=`.
- `nsolve` accepts the same expression or equation style and requires a starting guess.
- `system` accepts equations separated by semicolons and variables separated by commas.
- Other commands accept expressions only, not equation input.

LaTeX document input is supported through `otcalc latex-build` with `input=latex`.

## Shell Quoting

Quote expressions so your shell passes them as one argument.

PowerShell:

```powershell
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc nsolve "cos(x) - x" --variable "x,0.5"
otcalc integrate "exp(-x**2)"
```

Bash or zsh:

```bash
otcalc solve 'x**2 - 5*x + 6 = 0'
otcalc nsolve 'cos(x) - x' --variable 'x,0.5'
otcalc integrate 'exp(-x**2)'
```

Use quotes whenever an expression contains spaces, parentheses, `*`, or `=`.

## Privacy

The starter CLI does not call AI providers. It does not write history unless `--history`
is explicitly supplied.
