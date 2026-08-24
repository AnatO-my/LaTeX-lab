"""Public API for the OT Math deterministic engine."""

from otmath.domains import (
    SystemRequest,
    matrix_determinant,
    matrix_inverse,
    matrix_rref,
    matrix_transpose,
    parse_matrix,
    solve_system,
)
from otmath.engine import (
    differentiate_expression,
    expand_expression,
    factor_expression,
    integrate_expression,
    limit_expression,
    product_expression,
    run_request,
    simplify_expression,
    solve_expression,
    solve_inequality_expression,
    summation_expression,
)
from otmath.models import MathOperation, MathRequest, MathResult, MathStep
from otmath.steps import render_steps_latex, render_steps_text

__all__ = [
    "MathOperation",
    "MathRequest",
    "MathResult",
    "MathStep",
    "SystemRequest",
    "differentiate_expression",
    "expand_expression",
    "factor_expression",
    "integrate_expression",
    "limit_expression",
    "matrix_determinant",
    "matrix_inverse",
    "matrix_rref",
    "matrix_transpose",
    "parse_matrix",
    "product_expression",
    "render_steps_latex",
    "render_steps_text",
    "run_request",
    "simplify_expression",
    "solve_inequality_expression",
    "solve_expression",
    "solve_system",
    "summation_expression",
]
