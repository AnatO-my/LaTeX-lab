# LaTeX Integration

The LaTeX integration is built around generated snippets. OT Math computes locally, then
you insert the resulting LaTeX into your document.

## Preferred Workflow

Use `\OTMathCompute` and `\OTMathExplain` in a trusted `.tex` document:

```latex
\input{../../integrations/latex/otmath.sty}
\input{generated/otmath-results.tex}

\OTMathCompute[input=latex]{quadratic}{simplify}{x^{2} - 5x + 6}
\OTMathCompute[input=latex; variable=x,y]{system-example}{system}{x + y = 5; x - y = 1}
\OTMathExplain[input=latex; operation=solve]{solve-steps}{x^{2} - 5x + 6 = 0}
```

Then generate the include before compiling:

```bash
otcalc latex-build examples/latex/sample.tex
cd examples/latex
pdflatex -interaction=nonstopmode -halt-on-error sample.tex
```

`otcalc latex-build` writes `generated/otmath-results.tex` next to the source file by
default. Use `--compile` to run the local LaTeX engine after generation:

```bash
otcalc latex-build examples/latex/sample.tex --compile
```

This is pre-generation, not shell escape. The calculator runs before LaTeX compilation.

## Package Helpers

`integrations/latex/otmath.sty` provides small display helpers:

```latex
\OTMathInline{x^{2} - 5 x + 6}
\OTMathResult{x^{2} - 5 x + 6}
\OTMathEquation{x^{2} - 5 x + 6}{0}
\OTMathCompute[input=latex]{id}{simplify}{x^{2} - 5x + 6}
\OTMathExplain[input=latex; operation=solve]{id-steps}{x^{2} - 5x + 6 = 0}

\begin{OTMathSteps}
  \OTMathStep{Differentiate with respect to x}{3 x^{2}}
\end{OTMathSteps}
```

These macros only render already generated content. They do not call `otcalc` during
LaTeX compilation.

`\OTMathCompute` and `\OTMathExplain` are authoring markers. They render generated
results through `\OTMathUse{id}` after `otcalc latex-build` has written the include file.

## Input Syntax

`latex-build` supports two input modes:

- `input=latex`: a starter LaTeX-style adapter for document authoring.
- `input=engine`: SymPy/Python-style syntax, the default for backwards compatibility.

Supported starter LaTeX input includes:

- Powers such as `x^{2}`.
- Implicit multiplication such as `5x`.
- Equations such as `x^{2} - 5x + 6 = 0`.
- `\frac{a}{b}`.
- `\sqrt{x}`.
- `\sin{x}`, `\cos{x}`, `\tan{x}`, `\log{x}`, `\ln{x}`, and `\exp{x}`.
- `e^{...}` as Euler's constant.

Unsupported LaTeX should fail at the parser boundary rather than being guessed.

## Manual Snippets

You can still generate one-off snippets manually:

```bash
otcalc latex "x**2 - 5*x + 6"
otcalc diff "x**3" --format latex
otcalc explain "x**3" --operation diff --format latex
```

## Shell Escape

Shell escape can run commands from LaTeX. Treat it as advanced and optional. Do not enable shell escape for documents you do not trust.

OT Math's recommended workflow does not require shell escape.

## Testing

The Python test suite includes golden checks for generated LaTeX snippets. A TeX compile
test may run when a local TeX distribution is available and should skip gracefully when
TeX is missing.
