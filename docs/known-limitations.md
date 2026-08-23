# Known Limitations

OT Math is a beta-track local-first calculator, not a complete computer algebra system.

## Input Syntax

- The core parser accepts SymPy-style input.
- `otcalc latex-build` has a starter `input=latex` adapter for common document syntax.
- Use `**` for powers and explicit multiplication such as `5*x`.
- LaTeX variable normalization supports common Greek symbols and simple subscripts such
  as `x_{0}`; complex symbol aliases are not implemented yet.
- Unknown function calls are rejected unless the parser explicitly allows them.
- Most commands accept expressions only; `solve` and `system` accept equation syntax.
- Factorization currently prefers complex factors when available.
- `sum`, `product`, `limit`, and `inequality` are starter symbolic operations backed by
  SymPy and support single-variable cases first.

## Verification

- `differentiate` verification is a deterministic consistency check against SymPy, not an
  independent proof.
- Systems of equations are verified by substitution into every equation.
- Some symbolic outputs can be mathematically correct but formatted differently from a
  user's expected string.

## Explanations

- Structured steps are available for selected solve, simplify, and derivative paths.
- Factor, expand, integrate, and systems currently fall back to no detailed steps.

## Domains

- Supported advanced domain coverage currently starts with systems of equations.
- Numeric solving, statistics, units, matrices, and richer assumptions are planned but
  not complete.
- Underdetermined systems may contain free variables and should be reviewed carefully.

## Integrations

- The VS Code extension has automated command-builder tests, but command-palette and
  editor replacement flows still need manual Extension Host QA before release.
- The LaTeX integration currently favors generated snippets. Shell escape workflows are
  advanced and should only be used with trusted documents.

## Privacy And AI

- The default provider is `none`.
- No cloud provider is called by default tests or deterministic engine operations.
- Future AI providers must use user-owned keys and validate output before engine use.
