"""Deterministic starter statistics operations."""

from __future__ import annotations

from collections.abc import Sequence
from typing import Any

import sympy as sp

from otmath.errors import MathParseError, UnsupportedOperationError
from otmath.latex_render import render_latex
from otmath.models import MathOperation, MathResult
from otmath.parser import parse_expression
from otmath.steps import make_step

ENGINE_VERSION = "0.1.0"


def statistics_mean(expression: str, variable: str = "x") -> MathResult:
    """Compute the arithmetic mean of a dataset."""

    values = parse_dataset(expression)
    result = sp.simplify(sum(values, sp.Integer(0)) / len(values))
    return _statistics_result(
        MathOperation.STAT_MEAN,
        expression,
        variable,
        values,
        result,
        verification="sympy_statistics_mean",
    )


def statistics_median(expression: str, variable: str = "x") -> MathResult:
    """Compute the median of a dataset."""

    values = parse_dataset(expression)
    ordered = sorted(values, key=sp.default_sort_key)
    middle = len(ordered) // 2
    if len(ordered) % 2:
        result = ordered[middle]
    else:
        result = sp.simplify((ordered[middle - 1] + ordered[middle]) / 2)

    return _statistics_result(
        MathOperation.STAT_MEDIAN,
        expression,
        variable,
        values,
        result,
        verification="sympy_statistics_median",
    )


def statistics_variance(expression: str, variable: str = "sample") -> MathResult:
    """Compute sample or population variance for a dataset."""

    values = parse_dataset(expression)
    mode = _parse_variance_mode(variable)
    result = _variance(values, mode)
    return _statistics_result(
        MathOperation.STAT_VARIANCE,
        expression,
        variable,
        values,
        result,
        verification=f"sympy_statistics_{mode}_variance",
        mode=mode,
    )


def statistics_stdev(expression: str, variable: str = "sample") -> MathResult:
    """Compute sample or population standard deviation for a dataset."""

    values = parse_dataset(expression)
    mode = _parse_variance_mode(variable)
    result = sp.sqrt(_variance(values, mode))
    return _statistics_result(
        MathOperation.STAT_STDEV,
        expression,
        variable,
        values,
        result,
        verification=f"sympy_statistics_{mode}_stdev",
        mode=mode,
    )


def parse_dataset(expression: str) -> list[sp.Expr]:
    """Parse a comma-separated dataset or a single-level list literal."""

    stripped = expression.strip()
    if not stripped:
        raise MathParseError("Dataset expression cannot be empty.")
    if stripped.startswith("[") and stripped.endswith("]"):
        stripped = stripped[1:-1].strip()
    if not stripped:
        raise MathParseError("Dataset must contain at least one value.")

    return [parse_expression(item) for item in _split_top_level(stripped, delimiter=",")]


def _variance(values: Sequence[sp.Expr], mode: str) -> sp.Expr:
    if mode == "sample" and len(values) < 2:
        raise UnsupportedOperationError("Sample variance requires at least two values.")

    mean = sp.simplify(sum(values, sp.Integer(0)) / len(values))
    divisor = len(values) - 1 if mode == "sample" else len(values)
    return sp.simplify(sum((value - mean) ** 2 for value in values) / divisor)


def _parse_variance_mode(variable: str) -> str:
    mode = variable.strip().lower()
    if mode in {"x", "sample"}:
        return "sample"
    if mode == "population":
        return "population"
    raise UnsupportedOperationError("Statistics mode must be sample or population.")


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
                raise MathParseError("Dataset expression has unbalanced delimiters.")
        elif char == delimiter and depth == 0:
            parts.append(source[start:index].strip())
            start = index + 1

    if depth != 0:
        raise MathParseError("Dataset expression has unbalanced delimiters.")

    parts.append(source[start:].strip())
    if any(not part for part in parts):
        raise MathParseError("Dataset expression contains an empty item.")
    return parts


def _statistics_result(
    operation: MathOperation,
    expression: str,
    variable: str,
    values: Sequence[sp.Expr],
    result: sp.Expr,
    *,
    verification: str,
    mode: str | None = None,
) -> MathResult:
    metadata: dict[str, Any] = {
        "engine": "otmath",
        "engine_version": ENGINE_VERSION,
        "operation": operation.value,
        "variable": variable,
        "assumptions": {},
        "verification": verification,
        "count": len(values),
    }
    if mode is not None:
        metadata["mode"] = mode

    return MathResult(
        operation=operation,
        input_expression=expression,
        variable=variable,
        answers=[str(result)],
        latex=render_latex(result),
        verified=True,
        warnings=[],
        steps=[
            make_step(
                kind=operation.value,
                title=_statistics_step_title(operation, mode),
                input_expression=expression,
                output_expression=result,
                rule=verification,
                verified=True,
                metadata={"count": str(len(values)), **({"mode": mode} if mode else {})},
            )
        ],
        metadata=metadata,
    )


def _statistics_step_title(operation: MathOperation, mode: str | None = None) -> str:
    titles = {
        MathOperation.STAT_MEAN: "Compute the mean",
        MathOperation.STAT_MEDIAN: "Compute the median",
        MathOperation.STAT_VARIANCE: f"Compute the {mode or 'sample'} variance",
        MathOperation.STAT_STDEV: f"Compute the {mode or 'sample'} standard deviation",
    }
    return titles[operation]
