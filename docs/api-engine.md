# Engine API

The starter public API is exported from `otmath`.

```python
from otmath import (
    differentiate_expression,
    expand_expression,
    factor_expression,
    integrate_expression,
    render_steps_latex,
    render_steps_text,
    run_request,
    simplify_expression,
    solve_expression,
    solve_system,
)
```

## Functions

- `solve_expression(expression: str, variable: str = "x")`
- `solve_system(equations: Sequence[str] | str, variables: Sequence[str] | str = ("x", "y"))`
- `simplify_expression(expression: str, variable: str = "x")`
- `differentiate_expression(expression: str, variable: str = "x")`
- `integrate_expression(expression: str, variable: str = "x")`
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
- `solve_system` substitutes each returned solution into every equation.
- `simplify`, `expand`, and `factor` compare expression equivalence.
- `integrate` differentiates the returned integral and compares it with the original expression.
- `differentiate` currently checks consistency against SymPy's deterministic derivative result; this is not yet an independent proof.

## Supported Syntax

The current parser accepts SymPy-style expression syntax, not LaTeX input.

- Use `**` for powers: `x**2`
- Use `*` for explicit multiplication: `5*x`
- Common functions include `sin`, `cos`, `tan`, `log`, `ln`, `exp`, `sqrt`, and `abs`
- Common constants include `pi` and `E`
- Unknown symbols such as `x` and `y` are allowed
- `solve_expression` accepts either an expression treated as equal to zero or a single
  equation with `=`
- `otcalc latex-build` can adapt a starter subset of LaTeX-style document input before
  dispatching to the deterministic engine

Examples:

```python
solve_expression("x**2 - 5*x + 6")
solve_expression("x**2 - 5*x + 6 = 0")
solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])
simplify_expression("(x + 1)**2 - x**2")
differentiate_expression("sin(x)")
integrate_expression("exp(-x**2)")
expand_expression("(x - 2)*(x - 3)")
factor_expression("x**2 - 5*x + 6")
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

- Step generation is partial and not available for every operation yet.
- LaTeX input parsing is not implemented yet.
- Expression parsing is still starter-level and should be expanded carefully.
- Request assumptions are currently metadata only.
- Advanced domain coverage currently starts with systems of equations.
