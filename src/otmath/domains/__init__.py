"""Advanced deterministic math domains."""

from otmath.domains.matrices import (
    matrix_adjoint,
    matrix_conjugate,
    matrix_determinant,
    matrix_diagonalize,
    matrix_eigenvalues,
    matrix_inverse,
    matrix_order,
    matrix_power,
    matrix_rank,
    matrix_rref,
    matrix_trace,
    matrix_transpose,
    parse_matrix,
)
from otmath.domains.systems import SystemRequest, solve_system

__all__ = [
    "SystemRequest",
    "matrix_adjoint",
    "matrix_conjugate",
    "matrix_diagonalize",
    "matrix_determinant",
    "matrix_eigenvalues",
    "matrix_inverse",
    "matrix_order",
    "matrix_power",
    "matrix_rank",
    "matrix_rref",
    "matrix_trace",
    "matrix_transpose",
    "parse_matrix",
    "solve_system",
]
