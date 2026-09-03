"""Core data models for deterministic math requests and results."""

from __future__ import annotations

import keyword
from dataclasses import dataclass, field
from enum import StrEnum
from typing import Any

from otmath.errors import MathRequestError, UnsupportedOperationError


class MathOperation(StrEnum):
    """Supported starter operations."""

    SOLVE = "solve"
    NUMERIC_SOLVE = "nsolve"
    SOLVE_SYSTEM = "solve_system"
    SIMPLIFY = "simplify"
    DIFFERENTIATE = "differentiate"
    INTEGRATE = "integrate"
    EXPAND = "expand"
    FACTOR = "factor"
    SUMMATION = "sum"
    PRODUCT = "product"
    LIMIT = "limit"
    INEQUALITY = "inequality"
    STAT_MEAN = "mean"
    STAT_MEDIAN = "median"
    STAT_VARIANCE = "variance"
    STAT_STDEV = "stdev"
    UNIT_CONVERT = "unit"
    MATRIX_DETERMINANT = "matrix_det"
    MATRIX_ORDER = "matrix_order"
    MATRIX_RANK = "matrix_rank"
    MATRIX_TRACE = "matrix_trace"
    MATRIX_INVERSE = "matrix_inverse"
    MATRIX_NORM = "matrix_norm"
    MATRIX_CONDITION_NUMBER = "matrix_condition_number"
    MATRIX_POWER = "matrix_power"
    MATRIX_TRANSPOSE = "matrix_transpose"
    MATRIX_CONJUGATE = "matrix_conjugate"
    MATRIX_ADJOINT = "matrix_adjoint"
    MATRIX_RREF = "matrix_rref"
    MATRIX_SOLVE = "matrix_solve"
    MATRIX_NULLSPACE = "matrix_nullspace"
    MATRIX_COLUMNSPACE = "matrix_columnspace"
    MATRIX_ROWSPACE = "matrix_rowspace"
    MATRIX_EIGENVALUES = "matrix_eigenvals"
    MATRIX_EIGENVECTORS = "matrix_eigenvectors"
    MATRIX_DIAGONALIZE = "matrix_diagonalize"
    MATRIX_LU = "matrix_lu"
    MATRIX_QR = "matrix_qr"
    MATRIX_CHOLESKY = "matrix_cholesky"


@dataclass(frozen=True)
class MathRequest:
    """A structured request accepted by the deterministic engine."""

    operation: MathOperation | str
    expression: str
    variable: str = "x"
    assumptions: dict[str, Any] = field(default_factory=dict)

    def __post_init__(self) -> None:
        """Validate and normalize request fields."""

        if isinstance(self.operation, str):
            try:
                object.__setattr__(self, "operation", MathOperation(self.operation))
            except ValueError as exc:
                raise UnsupportedOperationError(
                    f"Unsupported operation: {self.operation}"
                ) from exc

        if not isinstance(self.expression, str) or not self.expression.strip():
            raise MathRequestError("Request expression cannot be empty.")

        if not isinstance(self.variable, str) or not _is_valid_variable_spec(
            self.variable,
            self.operation,
        ):
            raise MathRequestError(f"Invalid variable name: {self.variable}")

        if not isinstance(self.assumptions, dict):
            raise MathRequestError("Request assumptions must be a dictionary.")


@dataclass(frozen=True)
class MathStep:
    """A structured deterministic explanation step."""

    kind: str
    title: str
    input_expression: str
    output_expression: str
    rule: str
    verified: bool
    latex: str = ""
    metadata: dict[str, Any] = field(default_factory=dict)

    def as_dict(self) -> dict[str, Any]:
        """Return a JSON-serializable representation."""

        return {
            "kind": self.kind,
            "title": self.title,
            "input_expression": self.input_expression,
            "output_expression": self.output_expression,
            "rule": self.rule,
            "verified": self.verified,
            "latex": self.latex,
            "metadata": self.metadata,
        }


@dataclass(frozen=True)
class MathResult:
    """A structured result returned by the deterministic engine."""

    operation: MathOperation
    input_expression: str
    variable: str
    answers: list[str]
    latex: str
    verified: bool
    warnings: list[str] = field(default_factory=list)
    steps: list[MathStep] = field(default_factory=list)
    metadata: dict[str, Any] = field(default_factory=dict)

    def as_dict(self) -> dict[str, Any]:
        """Return a JSON-serializable representation."""

        return {
            "operation": self.operation.value,
            "input_expression": self.input_expression,
            "variable": self.variable,
            "answers": self.answers,
            "latex": self.latex,
            "verified": self.verified,
            "warnings": self.warnings,
            "steps": [step.as_dict() for step in self.steps],
            "metadata": self.metadata,
        }


def _is_valid_symbol_name(name: str) -> bool:
    return name.isidentifier() and not keyword.iskeyword(name)


def _is_valid_variable_spec(name: str, operation: MathOperation | str) -> bool:
    if operation == MathOperation.SOLVE_SYSTEM:
        names = [part.strip() for part in name.split(",")]
        return bool(names) and all(_is_valid_symbol_name(part) for part in names)
    if operation == MathOperation.NUMERIC_SOLVE:
        parts = [part.strip() for part in name.split(",")]
        if len(parts) == 1:
            return _is_valid_symbol_name(parts[0])
        return len(parts) == 2 and _is_valid_symbol_name(parts[0]) and bool(parts[1])
    if operation in {MathOperation.SUMMATION, MathOperation.PRODUCT}:
        parts = [part.strip() for part in name.split(",")]
        return len(parts) == 3 and bool(parts[0]) and _is_valid_symbol_name(parts[0])
    if operation == MathOperation.LIMIT:
        parts = [part.strip() for part in name.split(",")]
        return len(parts) in {2, 3} and bool(parts[0]) and _is_valid_symbol_name(parts[0])
    if operation == MathOperation.DIFFERENTIATE:
        parts = [part.strip() for part in name.split(",")]
        if len(parts) == 1:
            return _is_valid_symbol_name(parts[0])
        return (
            len(parts) == 2
            and _is_valid_symbol_name(parts[0])
            and parts[1].isdigit()
            and int(parts[1]) >= 1
        )
    if operation == MathOperation.MATRIX_POWER:
        return _is_valid_integer(name)
    if operation == MathOperation.MATRIX_NORM:
        return _is_valid_matrix_norm_order(name)
    if operation == MathOperation.UNIT_CONVERT:
        return bool(name.strip()) and "__" not in name
    return _is_valid_symbol_name(name)


def _is_valid_integer(value: str) -> bool:
    stripped = value.strip()
    if stripped.startswith("-"):
        stripped = stripped[1:]
    return bool(stripped) and stripped.isdigit()


def _is_valid_matrix_norm_order(value: str) -> bool:
    stripped = value.strip().lower()
    if stripped in {"fro", "frob", "frobenius", "oo", "inf", "infinity", "-oo"}:
        return True
    return _is_valid_integer(stripped)
