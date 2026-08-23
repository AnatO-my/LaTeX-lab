# Explanations

OT Math explanations are deterministic step records attached to `MathResult.steps`.
They are intended for education and interface rendering, not as a replacement for final
answer verification.

## Step Model

Each step includes:

- `kind`: broad step category, such as `normalize`, `solve`, `simplify`, or `verify`
- `title`: short human-readable label
- `input_expression`: expression before the step
- `output_expression`: expression or result after the step
- `rule`: deterministic rule or engine helper used
- `verified`: whether this step was checked
- `latex`: LaTeX rendering for the step output
- `metadata`: extra machine-readable context

## Current Coverage

The first explanation layer supports:

- solving: normalize target, solve, verify returned solutions
- simplification: before/after simplification
- differentiation: deterministic derivative output and selected variable

Other operations degrade gracefully with an empty step list.

## CLI

Use `otcalc explain` to render steps:

```bash
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve
otcalc explain "(x + 1)**2 - x**2" --operation simplify --format json
otcalc explain "x**3" --operation diff --format latex
```

The `--operation` option accepts `solve`, `simplify`, `diff`, `integrate`, `factor`, and
`expand`. JSON output contains the full `MathResult`, including `steps`.

## Limitations

Derivative verification currently checks consistency against SymPy's deterministic
derivative result. Step generation is still rule-light and should become more detailed
in future phases.
