# Systems Of Equations

OT Math supports a starter deterministic systems domain for symbolic systems of equations.

## Python

```python
from otmath import solve_system

result = solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])
print(result.answers)
```

## CLI

```bash
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc system "2*x + y = 7; x - y = 1" --variable "x,y" --format json
```

## Syntax

- Equations may use `=` or plain expressions treated as equal to zero.
- CLI equations are separated with semicolons.
- Variables are comma-separated in CLI usage.
- The same safe SymPy-style parser is used for each equation.

## Verification

Returned solution dictionaries are verified by substituting every solution into every
parsed equation and checking that each equation simplifies to zero.

## Limits

- Explanation steps are generated for normalization, solving, and verification, but they
  are still rule-light.
- The first version focuses on exact symbolic solving through SymPy.
- Underdetermined systems may include free variables and may not verify as fully resolved.
