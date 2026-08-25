# LaTeX Integration

The LaTeX integration is built around generated snippets. OT Math computes locally, then
you insert the resulting LaTeX into your document.

## Preferred Workflow

Use `\OTMathCompute` and `\OTMathExplain` in a trusted `.tex` document:

```latex
\input{../../integrations/latex/otmath.sty}
\OTMathGeneratedInput{generated/otmath-results.tex}

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

If a document declares a generated include with `\OTMathGeneratedInput{generated/name.tex}`,
`latex-build` writes to that declared path by default. Plain LaTeX compilation only reads
the generated file; it does not run the calculator. Use `otcalc latex-build --compile`,
the VS Code command palette, or the VS Code on-save refresh when you want edited requests
to recalculate.

`\OTMathGeneratedInput{...}` keeps the document compilable when the generated include is
missing. In that case, request markers render placeholder warnings until the include is
regenerated.

## Package Helpers

`integrations/latex/otmath.sty` provides small display helpers:

```latex
\OTMathGeneratedInput{generated/otmath-results.tex}
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
- Simple subscript variables such as `x_{0}` and `\theta_{1}`.
- Equations such as `x^{2} - 5x + 6 = 0`.
- `\frac{a}{b}`.
- `\sqrt{x}`.
- `\sin{x}`, `\cos{x}`, `\tan{x}`, `\log{x}`, `\ln{x}`, and `\exp{x}`.
- Standard inverse trig commands `\arcsin{x}`, `\arccos{x}`, and `\arctan{x}`.
- `e^{...}` as Euler's constant.
- Inequalities such as `x \leq 3` and `x \geq 0` for `inequality` requests.
- Derivative notation such as `\frac{d}{dx}\left(\sin{x}\right)` for
  `differentiate` requests. Higher-order derivative notation such as
  `\frac{d^{2}}{dx^{2}}\left(\sin{x}\right)` is supported when the orders match.
- Indefinite integral notation such as `\int 2x \, dx` for `integrate` requests.
- Summation notation such as `\sum_{k=1}^{n} k^{2}` for `sum` requests.
- Product notation such as `\prod_{k=1}^{n} k` for `product` requests.
- Limit notation such as `\lim_{x \to 0} \frac{\sin{x}}{x}` for `limit` requests.
- Matrix environments such as `bmatrix` and `pmatrix` for `det`, `order`, `rank`,
  `trace`, `inverse`, `mpow`, `transpose`, `conjugate`, `adjoint`, `rref`,
  `msolve`, `nullspace`, `columnspace`, `rowspace`, `eigenvals`, `eigenvectors`,
  `diagonalize`, `lu`, `qr`, and `cholesky` requests. Matrix solving accepts an
  `A; b` pair, where both sides may be LaTeX matrix environments.
- Direct determinant notation such as
  `\det\begin{bmatrix}1 & 2 \\ 3 & 4\end{bmatrix}` inside a `det` request.
- Plus-minus and minus-plus notation such as `x = \pm 2`, `x = \mp 2`,
  `(x \pm 1)^{2}`, `a \pm b \mp c`, or `a \pm b \pm c`. The LaTeX builder
  expands this into explicit sign branches before calling the engine.
- Common Greek variables such as `\alpha`, `\beta`, `\gamma`, `\theta`,
  `\lambda`, `\mu`, `\sigma`, `\phi`, `\omega`, and uppercase forms
  such as `\Delta`, `\Gamma`, `\Omega`, and `\Sigma`.
- Variant Greek variables such as `\varrho`, `\vartheta`, `\varepsilon`,
  `\varphi`, `\varsigma`, and `\varpi`.
- Styled uppercase variables such as `\mathcal{A}`, `\mathbb{R}`,
  `\mathfrak{M}`, `\mathsf{Q}`, and `\mathbf{X}`.
- `\pi` as the mathematical constant.

Unsupported LaTeX should fail at the parser boundary rather than being guessed.

Variables in options are normalized too. For example:

```latex
\OTMathCompute[input=latex; variable=x_{0}]{roots}{solve}{x_{0}^{2} - 1 = 0}
\OTMathCompute[input=latex; variable=x_{0},y_{0}]{system}{system}{x_{0} + y_{0} = 5; x_{0} - y_{0} = 1}
\OTMathCompute[input=latex]{greek}{simplify}{\alpha^{2} + \alpha}
\OTMathCompute[input=latex]{variant-greek}{expand}{(\varrho + \vartheta)^{2}}
\OTMathCompute[input=latex]{styled}{expand}{(\mathcal{A} + \mathbb{R})^{2}}
\OTMathCompute[input=latex; variable=x]{plus-minus}{solve}{x = \pm 2}
\OTMathCompute[input=latex]{minus-plus}{expand}{a \pm b \mp c}
\OTMathCompute[input=latex]{independent-signs}{expand}{a \pm b \pm c}
\OTMathCompute[input=latex]{derivative-notation}{differentiate}{\frac{d}{dx}\left(\sin{x}\right)}
\OTMathCompute[input=latex]{second-derivative}{differentiate}{\frac{d^{2}}{dx^{2}}\left(\sin{x}\right)}
\OTMathCompute[input=latex]{tan-integral}{integrate}{\int \tan{x} \, dx}
\OTMathCompute[input=latex]{theta-integral}{integrate}{\int \theta^{2} \, d\theta}
\OTMathCompute[input=latex]{matrix-det}{det}{\begin{bmatrix}1 & 2 \\ 3 & 4\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-direct-det}{det}{\det\begin{bmatrix}1 & 2 \\ 3 & 4\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-rank}{rank}{\begin{bmatrix}1 & 2 & 3 \\ 2 & 4 & 6 \\ 1 & 0 & 1\end{bmatrix}}
\OTMathCompute[input=latex; variable=3]{matrix-power}{mpow}{\begin{bmatrix}1 & 1 \\ 0 & 1\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-transpose}{transpose}{\begin{bmatrix}1 & 2 \\ 3 & 4\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-adjoint}{adjoint}{\begin{bmatrix}1 + \mathrm{i} & 2 \\ 3 & 4 - \mathrm{i}\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-solve}{msolve}{\begin{bmatrix}2 & 1 \\ 1 & -1\end{bmatrix}; \begin{bmatrix}5 \\ 1\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-nullspace}{nullspace}{\begin{bmatrix}1 & 2 & 3 \\ 2 & 4 & 6\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-eigenvectors}{eigenvectors}{\begin{bmatrix}2 & 0 \\ 0 & 3\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-diagonalize}{diagonalize}{\begin{bmatrix}2 & 0 \\ 0 & 3\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-lu}{lu}{\begin{bmatrix}2 & 1 \\ 4 & 3\end{bmatrix}}
\OTMathCompute[input=latex]{matrix-cholesky}{cholesky}{\begin{bmatrix}4 & 2 \\ 2 & 3\end{bmatrix}}
\OTMathCompute[input=latex]{sum-squares}{sum}{\sum_{k=1}^{n} k^{2}}
\OTMathCompute[input=latex]{limit-sine}{limit}{\lim_{x \to 0} \frac{\sin{x}}{x}}
```

Internally, names such as `x_{0}` and `\alpha` are normalized to engine-safe symbols
such as `x_0` and `alpha`; styled names such as `\mathcal{A}` are normalized to
names such as `mathcal_A`; variant Greek names such as `\varrho` are normalized to
names such as `var_rho`. SymPy then renders them back to LaTeX in generated output.
When two solve outputs are exact opposites, generated LaTeX may compact them back to
`\pm`, such as `\pm 2`. Paired `\pm` and `\mp` inputs are correlated: the first
branch uses plus/minus, and the second uses minus/plus.
Repeated `\pm` inputs without `\mp` are treated as independent choices.

Complex symbol declarations and aliases are not implemented yet. For now, use
`\mathrm{i}` for the imaginary unit in LaTeX matrix input, and keep variable subscripts
simple: letters or digits inside the subscript braces.

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

`examples/latex/stress.tex` is a broader document bench for current hard cases:
subscripted variables, Greek variables, fractions, roots, solving, systems,
differentiation, integration, matrix operations, and explanation rendering.

```bash
otcalc latex-build examples/latex/stress.tex --compile
cd examples/latex
pdflatex -interaction=nonstopmode -halt-on-error stress.tex
```

You can also regenerate the include file with:

```bash
python examples/latex/generate_stress_results.py
```

The stress document also lists and exercises current parser targets, including direct
determinant notation applied to a matrix.
