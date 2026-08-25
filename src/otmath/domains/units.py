"""Deterministic starter unit conversion."""

from __future__ import annotations

from tokenize import TokenError
from typing import Any

import sympy as sp
from sympy.parsing.sympy_parser import (
    implicit_multiplication_application,
    parse_expr,
    standard_transformations,
)
from sympy.physics import units as u
from sympy.physics.units import convert_to

from otmath.errors import MathParseError, UnsupportedOperationError
from otmath.latex_render import render_latex
from otmath.models import MathOperation, MathResult
from otmath.steps import make_step

ENGINE_VERSION = "0.1.0"
_TRANSFORMATIONS = standard_transformations + (implicit_multiplication_application,)
_GLOBAL_DICT = {
    "__builtins__": {},
    "Integer": sp.Integer,
    "Float": sp.Float,
    "Rational": sp.Rational,
}
_UNIT_DICT = {
    "m": u.meter,
    "meter": u.meter,
    "meters": u.meter,
    "km": u.kilometer,
    "kilometer": u.kilometer,
    "kilometers": u.kilometer,
    "cm": u.centimeter,
    "centimeter": u.centimeter,
    "centimeters": u.centimeter,
    "mm": u.millimeter,
    "millimeter": u.millimeter,
    "millimeters": u.millimeter,
    "s": u.second,
    "second": u.second,
    "seconds": u.second,
    "min": u.minute,
    "minute": u.minute,
    "minutes": u.minute,
    "h": u.hour,
    "hour": u.hour,
    "hours": u.hour,
    "g": u.gram,
    "gram": u.gram,
    "grams": u.gram,
    "kg": u.kilogram,
    "kilogram": u.kilogram,
    "kilograms": u.kilogram,
    "N": u.newton,
    "newton": u.newton,
    "newtons": u.newton,
    "J": u.joule,
    "joule": u.joule,
    "joules": u.joule,
    "W": u.watt,
    "watt": u.watt,
    "watts": u.watt,
}


def convert_units(expression: str, variable: str = "meter") -> MathResult:
    """Convert a unit expression to a target unit expression."""

    parsed = parse_unit_expression(expression)
    target = parse_unit_expression(variable)
    try:
        result = convert_to(parsed, target)
    except (TypeError, ValueError) as exc:
        raise UnsupportedOperationError("Unit conversion failed.") from exc

    return MathResult(
        operation=MathOperation.UNIT_CONVERT,
        input_expression=expression,
        variable=variable,
        answers=[str(result)],
        latex=render_latex(result),
        verified=True,
        warnings=[],
        steps=[
            make_step(
                kind="unit",
                title="Convert to the target unit",
                input_expression=parsed,
                output_expression=result,
                rule="sympy_convert_to",
                verified=True,
                metadata={"target_unit": variable},
            )
        ],
        metadata=_unit_metadata(variable, verification="sympy_convert_to"),
    )


def parse_unit_expression(expression: str) -> sp.Expr:
    """Parse a numeric unit expression with a curated unit dictionary."""

    stripped = expression.strip()
    if not stripped:
        raise MathParseError("Unit expression cannot be empty.")
    if "__" in stripped:
        raise MathParseError("Unit expression contains unsupported private-name syntax.")

    try:
        parsed = parse_expr(
            stripped,
            global_dict=_GLOBAL_DICT,
            local_dict=_UNIT_DICT,
            transformations=_TRANSFORMATIONS,
            evaluate=True,
        )
    except (SyntaxError, TokenError, TypeError, ValueError, NameError) as exc:
        raise MathParseError(f"Could not parse unit expression: {expression}") from exc

    if not isinstance(parsed, sp.Expr):
        raise MathParseError(
            f"Unit expression did not produce a symbolic expression: {expression}"
        )
    return parsed


def _unit_metadata(variable: str, *, verification: str) -> dict[str, Any]:
    return {
        "engine": "otmath",
        "engine_version": ENGINE_VERSION,
        "operation": MathOperation.UNIT_CONVERT.value,
        "variable": variable,
        "assumptions": {},
        "verification": verification,
        "target_unit": variable,
    }
