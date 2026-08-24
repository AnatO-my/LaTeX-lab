"""Deterministic matrix operations."""

from __future__ import annotations

from collections.abc import Sequence
from typing import Any

import sympy as sp
from sympy.matrices.exceptions import MatrixError, NonInvertibleMatrixError, NonSquareMatrixError

from otmath.errors import MathParseError, UnsupportedOperationError
from otmath.latex_render import render_latex
from otmath.models import MathOperation, MathResult
from otmath.parser import parse_expression

ENGINE_VERSION = "0.1.0"


def matrix_determinant(expression: str, variable: str = "x") -> MathResult:
    """Compute the determinant of a square matrix."""

    matrix = parse_matrix(expression)
    try:
        result = matrix.det()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Matrix determinant requires a square matrix.") from exc

    return _matrix_result(
        MathOperation.MATRIX_DETERMINANT,
        expression,
        variable,
        result,
        verification="sympy_matrix_determinant",
        shape=matrix.shape,
    )


def matrix_order(expression: str, variable: str = "x") -> MathResult:
    """Return the row-by-column order of a matrix."""

    matrix = parse_matrix(expression)
    rows, columns = matrix.shape
    result = f"{rows}x{columns}"

    return _matrix_result(
        MathOperation.MATRIX_ORDER,
        expression,
        variable,
        result,
        verification="sympy_matrix_shape",
        shape=matrix.shape,
        latex=rf"{rows} \times {columns}",
    )


def matrix_rank(expression: str, variable: str = "x") -> MathResult:
    """Compute the rank of a matrix."""

    matrix = parse_matrix(expression)
    result = matrix.rank()
    return _matrix_result(
        MathOperation.MATRIX_RANK,
        expression,
        variable,
        result,
        verification="sympy_matrix_rank",
        shape=matrix.shape,
    )


def matrix_trace(expression: str, variable: str = "x") -> MathResult:
    """Compute the trace of a square matrix."""

    matrix = parse_matrix(expression)
    try:
        result = matrix.trace()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Matrix trace requires a square matrix.") from exc

    return _matrix_result(
        MathOperation.MATRIX_TRACE,
        expression,
        variable,
        result,
        verification="sympy_matrix_trace",
        shape=matrix.shape,
    )


def matrix_inverse(expression: str, variable: str = "x") -> MathResult:
    """Compute the inverse of a square matrix."""

    matrix = parse_matrix(expression)
    try:
        result = matrix.inv()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Matrix inverse requires a square matrix.") from exc
    except NonInvertibleMatrixError as exc:
        raise UnsupportedOperationError("Matrix is not invertible.") from exc

    return _matrix_result(
        MathOperation.MATRIX_INVERSE,
        expression,
        variable,
        result,
        verification="sympy_matrix_inverse",
        shape=matrix.shape,
    )


def matrix_power(expression: str, variable: str = "2") -> MathResult:
    """Raise a square matrix to an integer power."""

    matrix = parse_matrix(expression)
    exponent = _parse_matrix_power_exponent(variable)
    try:
        result = matrix**exponent
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Matrix powers require a square matrix.") from exc
    except NonInvertibleMatrixError as exc:
        raise UnsupportedOperationError(
            "Negative matrix powers require an invertible matrix."
        ) from exc

    return _matrix_result(
        MathOperation.MATRIX_POWER,
        expression,
        variable,
        result,
        verification="sympy_matrix_power",
        shape=matrix.shape,
        exponent=exponent,
    )


def matrix_transpose(expression: str, variable: str = "x") -> MathResult:
    """Compute the transpose of a matrix."""

    matrix = parse_matrix(expression)
    result = matrix.T
    return _matrix_result(
        MathOperation.MATRIX_TRANSPOSE,
        expression,
        variable,
        result,
        verification="sympy_matrix_transpose",
        shape=matrix.shape,
    )


def matrix_conjugate(expression: str, variable: str = "x") -> MathResult:
    """Compute the elementwise complex conjugate of a matrix."""

    matrix = parse_matrix(expression)
    result = matrix.conjugate()
    return _matrix_result(
        MathOperation.MATRIX_CONJUGATE,
        expression,
        variable,
        result,
        verification="sympy_matrix_conjugate",
        shape=matrix.shape,
    )


def matrix_adjoint(expression: str, variable: str = "x") -> MathResult:
    """Compute the conjugate transpose of a matrix."""

    matrix = parse_matrix(expression)
    result = matrix.adjoint()
    return _matrix_result(
        MathOperation.MATRIX_ADJOINT,
        expression,
        variable,
        result,
        verification="sympy_matrix_adjoint",
        shape=matrix.shape,
    )


def matrix_rref(expression: str, variable: str = "x") -> MathResult:
    """Compute the reduced row echelon form of a matrix."""

    matrix = parse_matrix(expression)
    result, pivots = matrix.rref()
    return _matrix_result(
        MathOperation.MATRIX_RREF,
        expression,
        variable,
        result,
        verification="sympy_matrix_rref",
        shape=matrix.shape,
        pivots=list(pivots),
    )


def matrix_eigenvalues(expression: str, variable: str = "x") -> MathResult:
    """Compute eigenvalues and algebraic multiplicities for a square matrix."""

    matrix = parse_matrix(expression)
    try:
        eigenvalues = matrix.eigenvals()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Eigenvalues require a square matrix.") from exc

    ordered = sorted(eigenvalues.items(), key=lambda item: sp.default_sort_key(item[0]))
    answers = [
        f"{sp.sstr(value)} (multiplicity {multiplicity})"
        for value, multiplicity in ordered
    ]

    return _matrix_result(
        MathOperation.MATRIX_EIGENVALUES,
        expression,
        variable,
        eigenvalues,
        verification="sympy_matrix_eigenvals",
        shape=matrix.shape,
        answers=answers,
    )


def matrix_diagonalize(expression: str, variable: str = "x") -> MathResult:
    """Compute P and D such that A = P*D*P**-1 when possible."""

    matrix = parse_matrix(expression)
    try:
        modal_matrix, diagonal_matrix = matrix.diagonalize()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Diagonalization requires a square matrix.") from exc
    except (MatrixError, ValueError) as exc:
        raise UnsupportedOperationError("Matrix is not diagonalizable.") from exc

    latex = (
        r"P = "
        + render_latex(modal_matrix)
        + r",\quad D = "
        + render_latex(diagonal_matrix)
    )
    return _matrix_result(
        MathOperation.MATRIX_DIAGONALIZE,
        expression,
        variable,
        diagonal_matrix,
        verification="sympy_matrix_diagonalize",
        shape=matrix.shape,
        answers=[f"P = {modal_matrix}", f"D = {diagonal_matrix}"],
        latex=latex,
    )


def parse_matrix(expression: str) -> sp.Matrix:
    """Parse an engine-style matrix literal such as [[1, 2], [3, 4]]."""

    stripped = expression.strip()
    if not stripped:
        raise MathParseError("Matrix expression cannot be empty.")
    if not stripped.startswith("[") or not stripped.endswith("]"):
        raise MathParseError("Matrix expression must use [[row], [row]] syntax.")

    row_texts = _split_matrix_rows(stripped[1:-1])
    if not row_texts:
        raise MathParseError("Matrix must contain at least one row.")

    rows = [_parse_matrix_row(row_text) for row_text in row_texts]
    width = len(rows[0])
    if width == 0:
        raise MathParseError("Matrix rows cannot be empty.")
    if any(len(row) != width for row in rows):
        raise MathParseError("Matrix rows must all have the same number of columns.")

    return sp.Matrix(rows)


def _parse_matrix_row(row_text: str) -> list[sp.Expr]:
    stripped = row_text.strip()
    if not stripped.startswith("[") or not stripped.endswith("]"):
        raise MathParseError("Matrix rows must use [a, b] syntax.")
    cells = _split_top_level(stripped[1:-1], delimiter=",")
    return [parse_expression(cell) for cell in cells]


def _split_matrix_rows(source: str) -> list[str]:
    rows = _split_top_level(source, delimiter=",")
    return [row for row in rows if row.strip()]


def _split_top_level(source: str, *, delimiter: str) -> list[str]:
    parts: list[str] = []
    start = 0
    depth = 0
    for index, char in enumerate(source):
        if char in "([{":
            depth += 1
        elif char in ")]}":
            depth -= 1
            if depth < 0:
                raise MathParseError("Matrix expression has unbalanced delimiters.")
        elif char == delimiter and depth == 0:
            parts.append(source[start:index].strip())
            start = index + 1

    if depth != 0:
        raise MathParseError("Matrix expression has unbalanced delimiters.")

    parts.append(source[start:].strip())
    if any(not part for part in parts):
        raise MathParseError("Matrix expression contains an empty item.")
    return parts


def _parse_matrix_power_exponent(exponent_text: str) -> int:
    stripped = exponent_text.strip()
    try:
        return int(stripped)
    except ValueError as exc:
        raise UnsupportedOperationError("Matrix power exponent must be an integer.") from exc


def _matrix_result(
    operation: MathOperation,
    expression: str,
    variable: str,
    result: object,
    *,
    verification: str,
    shape: tuple[int, int],
    pivots: Sequence[int] | None = None,
    exponent: int | None = None,
    answers: list[str] | None = None,
    latex: str | None = None,
) -> MathResult:
    metadata: dict[str, Any] = {
        "engine": "otmath",
        "engine_version": ENGINE_VERSION,
        "operation": operation.value,
        "variable": variable,
        "assumptions": {},
        "verification": verification,
        "rows": shape[0],
        "columns": shape[1],
    }
    if pivots is not None:
        metadata["pivots"] = list(pivots)
    if exponent is not None:
        metadata["exponent"] = exponent

    return MathResult(
        operation=operation,
        input_expression=expression,
        variable=variable,
        answers=answers or [str(result)],
        latex=latex or render_latex(result),
        verified=True,
        warnings=[],
        metadata=metadata,
    )
