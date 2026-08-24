"""Safe expression parsing boundary for SymPy-backed operations."""

from __future__ import annotations

import keyword
import re
from tokenize import TokenError

import sympy as sp
from sympy.core.function import AppliedUndef
from sympy.parsing.sympy_parser import (
    implicit_multiplication_application,
    parse_expr,
    standard_transformations,
)

from otmath.errors import MathParseError

_TRANSFORMATIONS = standard_transformations + (implicit_multiplication_application,)
_CALL_PATTERN = re.compile(r"\b([A-Za-z_]\w*)\s*\(")
_RELATIONAL_OPERATORS = ("<=", ">=", "!=", "<", ">")
_ALLOWED_CALL_NAMES = {
    "abs",
    "acos",
    "asin",
    "atan",
    "cos",
    "exp",
    "Float",
    "Integer",
    "ln",
    "log",
    "Rational",
    "sin",
    "sqrt",
    "Symbol",
    "tan",
}
_GLOBAL_DICT = {
    "__builtins__": {},
    "Symbol": sp.Symbol,
    "Integer": sp.Integer,
    "Float": sp.Float,
    "Rational": sp.Rational,
}
_LOCAL_DICT = {
    "abs": sp.Abs,
    "acos": sp.acos,
    "asin": sp.asin,
    "atan": sp.atan,
    "cos": sp.cos,
    "E": sp.E,
    "exp": sp.exp,
    "I": sp.I,
    "ln": sp.log,
    "log": sp.log,
    "pi": sp.pi,
    "sin": sp.sin,
    "sqrt": sp.sqrt,
    "tan": sp.tan,
}


def parse_expression(expression: str) -> sp.Expr:
    """Parse a math expression without evaluating arbitrary Python code."""

    if not expression.strip():
        raise MathParseError("Expression cannot be empty.")
    if "__" in expression:
        raise MathParseError("Expression contains unsupported private-name syntax.")
    _reject_unsupported_calls(expression)

    try:
        parsed = parse_expr(
            expression,
            global_dict=_GLOBAL_DICT,
            local_dict=_LOCAL_DICT,
            transformations=_TRANSFORMATIONS,
            evaluate=True,
        )
    except (SyntaxError, TokenError, TypeError, ValueError, NameError) as exc:
        raise MathParseError(f"Could not parse expression: {expression}") from exc

    if not isinstance(parsed, sp.Expr):
        raise MathParseError(f"Expression did not produce a symbolic expression: {expression}")
    if parsed.atoms(AppliedUndef):
        raise MathParseError(f"Expression contains unsupported functions: {expression}")

    return parsed


def parse_equation_or_expression(expression: str) -> sp.Expr:
    """Parse an equation as lhs - rhs, or parse a plain expression."""

    if "=" not in expression:
        return parse_expression(expression)

    parts = expression.split("=")
    if len(parts) != 2:
        raise MathParseError(f"Equation must contain exactly one equals sign: {expression}")

    left, right = (part.strip() for part in parts)
    if not left or not right:
        raise MathParseError(f"Equation sides cannot be empty: {expression}")

    return parse_expression(left) - parse_expression(right)


def parse_relational_expression(expression: str) -> sp.Relational:
    """Parse a single symbolic inequality or disequality."""

    for operator in _RELATIONAL_OPERATORS:
        if operator not in expression:
            continue
        left, right = _split_single_relational_operator(expression, operator)
        parsed_left = parse_expression(left)
        parsed_right = parse_expression(right)
        if operator == "<=":
            return sp.Le(parsed_left, parsed_right)
        if operator == ">=":
            return sp.Ge(parsed_left, parsed_right)
        if operator == "!=":
            return sp.Ne(parsed_left, parsed_right)
        if operator == "<":
            return sp.Lt(parsed_left, parsed_right)
        return sp.Gt(parsed_left, parsed_right)

    raise MathParseError(f"Inequality must contain one relational operator: {expression}")


def _split_single_relational_operator(expression: str, operator: str) -> tuple[str, str]:
    parts = expression.split(operator)
    if len(parts) != 2:
        raise MathParseError(
            f"Inequality must contain exactly one relational operator: {expression}"
        )

    left, right = (part.strip() for part in parts)
    if not left or not right:
        raise MathParseError(f"Inequality sides cannot be empty: {expression}")
    return left, right


def _reject_unsupported_calls(expression: str) -> None:
    unsupported = {
        match.group(1)
        for match in _CALL_PATTERN.finditer(expression)
        if match.group(1) not in _ALLOWED_CALL_NAMES
    }
    if unsupported:
        names = ", ".join(sorted(unsupported))
        raise MathParseError(f"Expression contains unsupported function calls: {names}")


def parse_symbol(name: str) -> sp.Symbol:
    """Create a single symbolic variable."""

    if not name.isidentifier() or keyword.iskeyword(name):
        raise MathParseError(f"Invalid variable name: {name}")
    return sp.Symbol(name)
