# Example Gallery

These examples are copyable smoke tests for beta users.

## Algebra

```bash
otcalc solve "x**2 - 5*x + 6"
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc factor "x**2 - 5*x + 6"
otcalc expand "(x - 2)*(x - 3)"
otcalc simplify "(x + 1)**2 - x**2"
```

## Calculus

```bash
otcalc diff "x**3"
otcalc diff "sin(x)" --format latex
otcalc integrate "2*x"
otcalc integrate "exp(-x**2)"
```

## Systems

```bash
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc system "2*x + y = 7; x - y = 1" --variable "x,y" --format json
```

## Explanations

```bash
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve
otcalc explain "(x + 1)**2 - x**2" --operation simplify
otcalc explain "x**3" --operation diff --format latex
```

## Python

```python
from otmath import solve_expression, solve_system

quadratic = solve_expression("x**2 - 5*x + 6")
system = solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])

print(quadratic.answers)
print(system.answers)
```
