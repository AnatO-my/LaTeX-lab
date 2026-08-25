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
- `nsolve` is a starter single-variable numeric solve operation and depends on the
  supplied initial guess.
- Matrix support covers order, determinant, rank, trace, inverse, powers, transpose,
  conjugate, adjoint, RREF, matrix solving, null space, column space, row space,
  eigenvalues, eigenvectors, diagonalization, LU, QR, and Cholesky decomposition for
  SymPy-supported cases.

## Verification

- `differentiate` verification is a deterministic consistency check against SymPy, not an
  independent proof.
- Numeric solving is verified by checking the residual against a fixed tolerance.
- Systems of equations are verified by substitution into every equation.
- Some symbolic outputs can be mathematically correct but formatted differently from a
  user's expected string.

## Explanations

- Structured steps are available for solve, systems, simplify, differentiate,
  integrate, factor, expand, and matrix operations.
- Current steps are deterministic and rule-light; they are not yet full textbook-style
  derivations for every operation.

## Domains

- Supported advanced domain coverage currently starts with systems of equations,
  matrices, and starter numeric solving.
- Statistics, units, broader numerical methods, and richer assumptions are planned but
  not complete.
- Larger linear algebra workflows such as norms, condition numbers, singular value
  decomposition, least-squares solving, and matrix equation families are not implemented
  yet.
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
