"""Advanced deterministic math domains."""

from otmath.domains.matrices import (
    matrix_determinant,
    matrix_inverse,
    matrix_rref,
    matrix_transpose,
    parse_matrix,
)
from otmath.domains.systems import SystemRequest, solve_system

__all__ = [
    "SystemRequest",
    "matrix_determinant",
    "matrix_inverse",
    "matrix_rref",
    "matrix_transpose",
    "parse_matrix",
    "solve_system",
]
