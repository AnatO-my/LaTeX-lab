# OT Math LaTeX Integration

This folder contains the optional LaTeX helper package for inserting OT Math generated
snippets into documents.

## Package

Use the helpers from a document that can resolve the local path:

```latex
\input{../../integrations/latex/otmath.sty}
```

Available helpers:

- `\OTMathGeneratedInput{...}` for optional generated include files.
- `\OTMathInline{...}` for inline math.
- `\OTMathResult{...}` for display math.
- `\OTMathEquation{lhs}{rhs}` for numbered equations.
- `OTMathSteps` plus `\OTMathStep{label}{math}` for aligned step displays.

## Workflow

Write requests directly in a `.tex` file:

```latex
\OTMathGeneratedInput{generated/otmath-results.tex}
\OTMathCompute[input=latex]{quadratic}{simplify}{x^{2} - 5x + 6}
\OTMathCompute[input=latex; variable=x,y]{system-example}{system}{x + y = 5; x - y = 1}
\OTMathExplain[input=latex; operation=solve]{solve-steps}{x^{2} - 5x + 6 = 0}
```

Then generate the include file:

```bash
otcalc latex-build examples/latex/sample.tex
```

LaTeX compilation reads the generated include file but does not update it. Run
`otcalc latex-build` before compiling, or use the VS Code OT Math build shortcuts.
If a generated include is missing, `\OTMathGeneratedInput{...}` lets the document compile
with missing-result placeholders until the include is regenerated.

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
