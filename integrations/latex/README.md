# OT Math LaTeX Integration

This folder contains the optional LaTeX helper package for inserting OT Math generated
snippets into documents.

## Package

Use the helpers from a document that can resolve the local path:

```latex
\input{../../integrations/latex/otmath.sty}
```

Available helpers:

- `\OTMathInline{...}` for inline math.
- `\OTMathResult{...}` for display math.
- `\OTMathEquation{lhs}{rhs}` for numbered equations.
- `OTMathSteps` plus `\OTMathStep{label}{math}` for aligned step displays.

## Workflow

Write requests directly in a `.tex` file:

```latex
\OTMathCompute{quadratic}{simplify}{x**2 - 5*x + 6}
\OTMathCompute[variable=x,y]{system-example}{system}{x + y = 5; x - y = 1}
\OTMathExplain[operation=solve]{solve-steps}{x**2 - 5*x + 6 = 0}
```

Then generate the include file:

```bash
otcalc latex-build examples/latex/sample.tex
```

The sample document demonstrates the same pre-generation workflow:

```bash
python examples/latex/generate_sample_results.py
```

You can also generate snippets manually and paste or preprocess them into `.tex` files:

```bash
otcalc latex "x**2 - 5*x + 6"
otcalc explain "x**3" --operation diff --format latex
```

The package does not execute shell commands. Shell escape workflows should remain
advanced and opt-in.
