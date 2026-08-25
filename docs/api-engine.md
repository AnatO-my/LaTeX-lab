# Engine API

The starter public API is exported from `otmath`.

```python
from otmath import (
    differentiate_expression,
    expand_expression,
    factor_expression,
    integrate_expression,
    limit_expression,
    matrix_adjoint,
    matrix_cholesky_decomposition,
    matrix_columnspace,
    matrix_conjugate,
    matrix_diagonalize,
    matrix_determinant,
    matrix_eigenvalues,
    matrix_eigenvectors,
    matrix_inverse,
    matrix_lu_decomposition,
    matrix_nullspace,
    matrix_order,
    matrix_power,
    matrix_qr_decomposition,
    matrix_rank,
    matrix_rref,
    matrix_rowspace,
    matrix_solve,
    matrix_trace,
    matrix_transpose,
    numeric_solve_expression,
    statistics_mean,
    statistics_median,
    statistics_stdev,
    statistics_variance,
    product_expression,
    render_steps_latex,
    render_steps_text,
    run_request,
    simplify_expression,
    solve_inequality_expression,
    solve_expression,
    solve_system,
    summation_expression,
)
```

## Functions

- `solve_expression(expression: str, variable: str = "x")`
- `numeric_solve_expression(expression: str, variable: str = "x,1")`
- `solve_system(equations: Sequence[str] | str, variables: Sequence[str] | str = ("x", "y"))`
- `simplify_expression(expression: str, variable: str = "x")`
- `differentiate_expression(expression: str, variable: str = "x")`
- `integrate_expression(expression: str, variable: str = "x")`
- `summation_expression(expression: str, variable: str = "k,1,n")`
- `product_expression(expression: str, variable: str = "k,1,n")`
- `limit_expression(expression: str, variable: str = "x,0")`
- `solve_inequality_expression(expression: str, variable: str = "x")`
- `statistics_mean(expression: str, variable: str = "x")`
- `statistics_median(expression: str, variable: str = "x")`
- `statistics_variance(expression: str, variable: str = "sample")`
- `statistics_stdev(expression: str, variable: str = "sample")`
- `matrix_determinant(expression: str, variable: str = "x")`
- `matrix_order(expression: str, variable: str = "x")`
- `matrix_rank(expression: str, variable: str = "x")`
- `matrix_trace(expression: str, variable: str = "x")`
- `matrix_inverse(expression: str, variable: str = "x")`
- `matrix_power(expression: str, variable: str = "2")`
- `matrix_transpose(expression: str, variable: str = "x")`
- `matrix_conjugate(expression: str, variable: str = "x")`
- `matrix_adjoint(expression: str, variable: str = "x")`
- `matrix_rref(expression: str, variable: str = "x")`
- `matrix_solve(expression: str, variable: str = "x")`
- `matrix_nullspace(expression: str, variable: str = "x")`
- `matrix_columnspace(expression: str, variable: str = "x")`
- `matrix_rowspace(expression: str, variable: str = "x")`
- `matrix_eigenvalues(expression: str, variable: str = "x")`
- `matrix_eigenvectors(expression: str, variable: str = "x")`
- `matrix_diagonalize(expression: str, variable: str = "x")`
- `matrix_lu_decomposition(expression: str, variable: str = "x")`
- `matrix_qr_decomposition(expression: str, variable: str = "x")`
- `matrix_cholesky_decomposition(expression: str, variable: str = "x")`
- `factor_expression(expression: str, variable: str = "x")`
- `expand_expression(expression: str, variable: str = "x")`
- `run_request(request: MathRequest)`
- `render_steps_text(steps: list[MathStep])`
- `render_steps_latex(steps: list[MathStep])`

Each function returns `MathResult`.

`MathRequest` accepts `MathOperation` values or matching operation strings such as
`"solve"` and `"factor"`. Empty expressions, invalid variable names, non-dictionary
assumptions, and unsupported operations are rejected before dispatch.

## Result Fields

- `operation`
- `input_expression`
- `variable`
- `answers`
- `latex`
- `verified`
- `warnings`
- `steps`
- `metadata`

`steps` is a list of structured `MathStep` objects serialized as dictionaries in
`MathResult.as_dict()`. See [explanations.md](explanations.md).

## Metadata

`metadata` contains machine-readable context for integrations:

- `engine`: engine name, currently `otmath`
- `engine_version`: engine version string
- `operation`: operation name
- `variable`: selected variable
- `assumptions`: request assumptions when supplied through `MathRequest`
- `verification`: verification strategy used for the result

## Verification

`MathResult.verified` records whether the deterministic engine checked the returned result.

- `solve` substitutes each returned solution into the original expression.
- `nsolve` checks the numeric residual against a small tolerance.
- `solve_system` substitutes each returned solution into every equation.
- `simplify`, `expand`, and `factor` compare expression equivalence.
- `integrate` differentiates the returned integral and compares it with the original expression.
- `sum`, `product`, and `limit` use deterministic SymPy recomputation.
- `inequality` returns SymPy's single-variable solution set.
- Statistics operations use deterministic SymPy arithmetic over the parsed dataset.
- Matrix operations are deterministic SymPy matrix operations.
- `differentiate` currently checks consistency against SymPy's deterministic derivative result; this is not yet an independent proof.

## Supported Syntax

The current parser accepts SymPy-style expression syntax, not LaTeX input.

- Use `**` for powers: `x**2`
- Use `*` for explicit multiplication: `5*x`
- Common functions include `sin`, `cos`, `tan`, `asin`, `acos`, `atan`, `log`,
  `ln`, `exp`, `sqrt`, and `abs`
- Common constants include `pi`, `E`, and `I`
- Unknown symbols such as `x` and `y` are allowed
- Statistics operations accept comma-separated datasets such as `1, 2, 3` or list
  literals such as `[1, 2, 3]`. `variance` and `stdev` use `variable="sample"` by
  default and also accept `variable="population"`.
- Matrix operations accept matrix literals such as `[[1, 2], [3, 4]]`
- Matrix solving accepts an `A; b` pair such as
  `[[2, 1], [1, -1]]; [[5], [1]]`
- `solve_expression` accepts either an expression treated as equal to zero or a single
  equation with `=`
- `numeric_solve_expression` accepts the same solve target style and uses
  `variable,initial_guess`, such as `x,0.5`
- `otcalc latex-build` can adapt a starter subset of LaTeX-style document input before
  dispatching to the deterministic engine
- `factor_expression` factors over the complex extension, so expressions such as
  `x**4 - 1` can include factors with `I`

Examples:

```python
solve_expression("x**2 - 5*x + 6")
solve_expression("x**2 - 5*x + 6 = 0")
numeric_solve_expression("cos(x) - x", variable="x,0.5")
solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])
simplify_expression("(x + 1)**2 - x**2")
differentiate_expression("sin(x)")
integrate_expression("exp(-x**2)")
summation_expression("k**2", variable="k,1,n")
product_expression("k", variable="k,1,n")
limit_expression("sin(x)/x", variable="x,0,+-")
solve_inequality_expression("x <= 3")
statistics_mean("1, 2, 3, 4")
statistics_median("[1, 10, 2, 20]")
statistics_variance("1, 2, 3")
statistics_variance("1, 2, 3", variable="population")
statistics_stdev("1, 2, 3")
matrix_determinant("[[1, 2], [3, 4]]")
matrix_order("[[1, 2, 3], [4, 5, 6]]")
matrix_rank("[[1, 2, 3], [2, 4, 6], [1, 0, 1]]")
matrix_trace("[[1, 2], [3, 4]]")
matrix_inverse("[[1, 2], [3, 4]]")
matrix_power("[[1, 1], [0, 1]]", variable="3")
matrix_transpose("[[1, 2], [3, 4]]")
matrix_conjugate("[[1 + I, 2], [3, 4 - I]]")
matrix_adjoint("[[1 + I, 2], [3, 4 - I]]")
matrix_rref("[[1, 2], [3, 4]]")
matrix_solve("[[2, 1], [1, -1]]; [[5], [1]]")
matrix_nullspace("[[1, 2, 3], [2, 4, 6]]")
matrix_columnspace("[[1, 2, 3], [2, 4, 6]]")
matrix_rowspace("[[1, 2, 3], [2, 4, 6]]")
matrix_eigenvalues("[[2, 0], [0, 3]]")
matrix_eigenvectors("[[2, 0], [0, 3]]")
matrix_diagonalize("[[2, 0], [0, 3]]")
matrix_lu_decomposition("[[2, 1], [4, 3]]")
matrix_qr_decomposition("[[1, 0], [1, 1]]")
matrix_cholesky_decomposition("[[4, 2], [2, 3]]")
expand_expression("(x - 2)*(x - 3)")
factor_expression("x**2 - 5*x + 6")
factor_expression("x**4 - 1")
```

Unsupported examples:

```python
simplify_expression("")
simplify_expression("__import__('os').system('dir')")
simplify_expression("madeup(x)")
simplify_expression("x + 1 = 2")
solve_expression("x = = 2")
```

## Current Limitations

- Step generation is available for the main symbolic and matrix operations, but remains
  rule-light for several advanced cases.
- LaTeX input parsing is available through the generated-document workflow, not the
  default scalar expression parser.
- Expression parsing is still starter-level and should be expanded carefully.
- Request assumptions are currently metadata only.
- Advanced domain coverage currently starts with systems of equations and matrix
  operations, plus starter single-variable numeric solving and descriptive statistics.
- Numeric solving is initial-guess sensitive and currently returns one solution.
- Statistics support currently focuses on finite descriptive datasets.
