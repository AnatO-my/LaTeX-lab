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
from otmath.steps import make_step

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


def matrix_solve(expression: str, variable: str = "x") -> MathResult:
    """Solve a linear matrix equation A*x = b from an A; b request."""

    coefficient_matrix, rhs = parse_matrix_pair(expression)
    if coefficient_matrix.rows != rhs.rows:
        raise UnsupportedOperationError(
            "Matrix solve requires A and b to have the same number of rows."
        )

    try:
        solution, parameters = coefficient_matrix.gauss_jordan_solve(rhs)
    except ValueError as exc:
        raise UnsupportedOperationError("Matrix system has no solution.") from exc
    verified = bool((coefficient_matrix * solution - rhs).applyfunc(sp.simplify).is_zero_matrix)

    return _matrix_result(
        MathOperation.MATRIX_SOLVE,
        expression,
        variable,
        solution,
        verification="sympy_matrix_gauss_jordan_solve",
        shape=coefficient_matrix.shape,
        verified=verified,
        warnings=_matrix_warnings(verified),
        solution_rows=solution.rows,
        solution_columns=solution.cols,
        parameter_count=parameters.rows,
    )


def matrix_nullspace(expression: str, variable: str = "x") -> MathResult:
    """Compute a basis for the null space of a matrix."""

    matrix = parse_matrix(expression)
    basis = matrix.nullspace()
    return _matrix_sequence_result(
        MathOperation.MATRIX_NULLSPACE,
        expression,
        variable,
        basis,
        verification="sympy_matrix_nullspace",
        shape=matrix.shape,
        space_dimension=len(basis),
    )


def matrix_columnspace(expression: str, variable: str = "x") -> MathResult:
    """Compute a basis for the column space of a matrix."""

    matrix = parse_matrix(expression)
    basis = matrix.columnspace()
    return _matrix_sequence_result(
        MathOperation.MATRIX_COLUMNSPACE,
        expression,
        variable,
        basis,
        verification="sympy_matrix_columnspace",
        shape=matrix.shape,
        space_dimension=len(basis),
    )


def matrix_rowspace(expression: str, variable: str = "x") -> MathResult:
    """Compute a basis for the row space of a matrix."""

    matrix = parse_matrix(expression)
    basis = matrix.rowspace()
    return _matrix_sequence_result(
        MathOperation.MATRIX_ROWSPACE,
        expression,
        variable,
        basis,
        verification="sympy_matrix_rowspace",
        shape=matrix.shape,
        space_dimension=len(basis),
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


def matrix_eigenvectors(expression: str, variable: str = "x") -> MathResult:
    """Compute eigenvalues, multiplicities, and eigenvector bases."""

    matrix = parse_matrix(expression)
    try:
        eigenvectors = matrix.eigenvects()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Eigenvectors require a square matrix.") from exc

    ordered = sorted(eigenvectors, key=lambda item: sp.default_sort_key(item[0]))
    answers = [
        _format_eigenvector_answer(value, multiplicity, vectors)
        for value, multiplicity, vectors in ordered
    ]
    latex = _joined_latex(
        [
            rf"\lambda = {render_latex(value)}"
            rf"\ \left(m={multiplicity}\right): "
            + _joined_latex([render_latex(vector) for vector in vectors])
            for value, multiplicity, vectors in ordered
        ]
    )

    return _matrix_result(
        MathOperation.MATRIX_EIGENVECTORS,
        expression,
        variable,
        eigenvectors,
        verification="sympy_matrix_eigenvects",
        shape=matrix.shape,
        answers=answers,
        latex=latex,
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
        step_output=f"P = {modal_matrix}; D = {diagonal_matrix}",
    )


def matrix_lu_decomposition(expression: str, variable: str = "x") -> MathResult:
    """Compute an LU decomposition."""

    matrix = parse_matrix(expression)
    try:
        lower, upper, swaps = matrix.LUdecomposition()
    except ValueError as exc:
        raise UnsupportedOperationError("Matrix LU decomposition failed.") from exc

    latex = (
        r"L = "
        + render_latex(lower)
        + r",\quad U = "
        + render_latex(upper)
        + rf",\quad swaps = {swaps}"
    )
    return _matrix_result(
        MathOperation.MATRIX_LU,
        expression,
        variable,
        upper,
        verification="sympy_matrix_lu_decomposition",
        shape=matrix.shape,
        answers=[f"L = {lower}", f"U = {upper}", f"swaps = {swaps}"],
        latex=latex,
        step_output=f"L = {lower}; U = {upper}; swaps = {swaps}",
    )


def matrix_qr_decomposition(expression: str, variable: str = "x") -> MathResult:
    """Compute a QR decomposition."""

    matrix = parse_matrix(expression)
    try:
        orthogonal, upper = matrix.QRdecomposition()
    except ValueError as exc:
        raise UnsupportedOperationError("Matrix QR decomposition failed.") from exc

    latex = r"Q = " + render_latex(orthogonal) + r",\quad R = " + render_latex(upper)
    return _matrix_result(
        MathOperation.MATRIX_QR,
        expression,
        variable,
        upper,
        verification="sympy_matrix_qr_decomposition",
        shape=matrix.shape,
        answers=[f"Q = {orthogonal}", f"R = {upper}"],
        latex=latex,
        step_output=f"Q = {orthogonal}; R = {upper}",
    )


def matrix_cholesky_decomposition(expression: str, variable: str = "x") -> MathResult:
    """Compute a Cholesky decomposition."""

    matrix = parse_matrix(expression)
    try:
        lower = matrix.cholesky()
    except NonSquareMatrixError as exc:
        raise UnsupportedOperationError("Cholesky decomposition requires a square matrix.") from exc
    except (MatrixError, ValueError) as exc:
        raise UnsupportedOperationError(
            "Cholesky decomposition requires a positive-definite matrix."
        ) from exc

    return _matrix_result(
        MathOperation.MATRIX_CHOLESKY,
        expression,
        variable,
        lower,
        verification="sympy_matrix_cholesky",
        shape=matrix.shape,
        answers=[f"L = {lower}"],
        latex=r"L = " + render_latex(lower),
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


def parse_matrix_pair(expression: str) -> tuple[sp.Matrix, sp.Matrix]:
    """Parse a pair of matrix literals separated by a top-level semicolon."""

    parts = _split_top_level(expression, delimiter=";")
    if len(parts) != 2:
        raise MathParseError("Matrix pair expression must use A; b syntax.")
    return parse_matrix(parts[0]), parse_matrix(parts[1])


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


def _format_eigenvector_answer(
    value: sp.Expr,
    multiplicity: int,
    vectors: Sequence[sp.Matrix],
) -> str:
    vector_text = ", ".join(str(vector) for vector in vectors)
    return f"lambda = {sp.sstr(value)} (multiplicity {multiplicity}): {vector_text}"


def _matrix_sequence_result(
    operation: MathOperation,
    expression: str,
    variable: str,
    items: Sequence[object],
    *,
    verification: str,
    shape: tuple[int, int],
    space_dimension: int | None = None,
) -> MathResult:
    answers = [str(item) for item in items]
    if not answers:
        answers = ["[]"]
    metadata_extra: dict[str, Any] = {}
    if space_dimension is not None:
        metadata_extra["space_dimension"] = space_dimension

    return _matrix_result(
        operation,
        expression,
        variable,
        list(items),
        verification=verification,
        shape=shape,
        answers=answers,
        latex=_joined_latex([render_latex(item) for item in items]),
        metadata_extra=metadata_extra,
    )


def _joined_latex(items: Sequence[str]) -> str:
    if not items:
        return r"\left\{ \right\}"
    if len(items) == 1:
        return items[0]
    return "\\begin{gathered}\n" + " \\\\\n".join(items) + "\n\\end{gathered}"


def _matrix_warnings(verified: bool) -> list[str]:
    if verified:
        return []
    return ["Result could not be verified by the deterministic engine."]


def _matrix_step_title(operation: MathOperation) -> str:
    titles = {
        MathOperation.MATRIX_DETERMINANT: "Compute the matrix determinant",
        MathOperation.MATRIX_ORDER: "Read the matrix order",
        MathOperation.MATRIX_RANK: "Compute the matrix rank",
        MathOperation.MATRIX_TRACE: "Compute the matrix trace",
        MathOperation.MATRIX_INVERSE: "Compute the matrix inverse",
        MathOperation.MATRIX_POWER: "Raise the matrix to the selected power",
        MathOperation.MATRIX_TRANSPOSE: "Transpose the matrix",
        MathOperation.MATRIX_CONJUGATE: "Conjugate each matrix entry",
        MathOperation.MATRIX_ADJOINT: "Compute the conjugate transpose",
        MathOperation.MATRIX_RREF: "Reduce the matrix to RREF",
        MathOperation.MATRIX_SOLVE: "Solve the matrix equation",
        MathOperation.MATRIX_NULLSPACE: "Compute a null-space basis",
        MathOperation.MATRIX_COLUMNSPACE: "Compute a column-space basis",
        MathOperation.MATRIX_ROWSPACE: "Compute a row-space basis",
        MathOperation.MATRIX_EIGENVALUES: "Compute matrix eigenvalues",
        MathOperation.MATRIX_EIGENVECTORS: "Compute matrix eigenvectors",
        MathOperation.MATRIX_DIAGONALIZE: "Diagonalize the matrix",
        MathOperation.MATRIX_LU: "Compute an LU decomposition",
        MathOperation.MATRIX_QR: "Compute a QR decomposition",
        MathOperation.MATRIX_CHOLESKY: "Compute a Cholesky decomposition",
    }
    return titles.get(operation, "Run the matrix operation")


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
    verified: bool = True,
    warnings: list[str] | None = None,
    solution_rows: int | None = None,
    solution_columns: int | None = None,
    parameter_count: int | None = None,
    metadata_extra: dict[str, Any] | None = None,
    step_output: object | None = None,
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
    if solution_rows is not None:
        metadata["solution_rows"] = solution_rows
    if solution_columns is not None:
        metadata["solution_columns"] = solution_columns
    if parameter_count is not None:
        metadata["parameter_count"] = parameter_count
    if metadata_extra is not None:
        metadata.update(metadata_extra)

    return MathResult(
        operation=operation,
        input_expression=expression,
        variable=variable,
        answers=answers or [str(result)],
        latex=latex or render_latex(result),
        verified=verified,
        warnings=warnings or [],
        steps=[
            make_step(
                kind=operation.value,
                title=_matrix_step_title(operation),
                input_expression=expression,
                output_expression=result if step_output is None else step_output,
                rule=verification,
                verified=verified,
            )
        ],
        metadata=metadata,
    )
