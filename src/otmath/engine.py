"""Starter deterministic math engine."""

from __future__ import annotations

from collections.abc import Callable
from typing import Any

import sympy as sp

from otmath.domains.systems import solve_system
from otmath.errors import UnsupportedOperationError
from otmath.models import MathOperation, MathRequest, MathResult
from otmath.parser import parse_equation_or_expression, parse_expression, parse_symbol
from otmath.steps import derivative_steps, simplify_steps, solve_steps

OperationHandler = Callable[[str, str], MathResult]
ENGINE_VERSION = "0.1.0"


def solve_expression(expression: str, variable: str = "x") -> MathResult:
    """Solve an equation or expression for a variable."""

    symbol = parse_symbol(variable)
    parsed = parse_equation_or_expression(expression)
    answers = sp.solve(parsed, symbol)
    verified = verify_solutions(parsed, symbol, answers)
    warnings = _result_warnings(verified)
    if not answers:
        warnings.append("No solutions were returned for the selected variable.")

    return MathResult(
        operation=MathOperation.SOLVE,
        input_expression=expression,
        variable=variable,
        answers=[str(answer) for answer in answers],
        latex=sp.latex(answers),
        verified=verified,
        warnings=warnings,
        steps=solve_steps(
            original_expression=expression,
            normalized_expression=parsed,
            answers=answers,
            verified=verified,
        ),
        metadata=_result_metadata(
            MathOperation.SOLVE,
            variable,
            verification="solution_substitution",
        ),
    )


def verify_solutions(
    expression: sp.Expr,
    symbol: sp.Symbol,
    answers: list[sp.Expr],
) -> bool:
    """Verify that each returned solution satisfies the expression."""

    if not answers:
        return False
    return all(sp.simplify(expression.subs(symbol, answer)) == 0 for answer in answers)


def simplify_expression(expression: str, variable: str = "x") -> MathResult:
    """Simplify an expression."""

    parse_symbol(variable)
    parsed = parse_expression(expression)
    simplified = sp.simplify(parsed)
    verified = expressions_equivalent(parsed, simplified)

    return MathResult(
        operation=MathOperation.SIMPLIFY,
        input_expression=expression,
        variable=variable,
        answers=[str(simplified)],
        latex=sp.latex(simplified),
        verified=verified,
        warnings=_result_warnings(verified),
        steps=simplify_steps(parsed, simplified, verified),
        metadata=_result_metadata(
            MathOperation.SIMPLIFY,
            variable,
            verification="expression_equivalence",
        ),
    )


def differentiate_expression(expression: str, variable: str = "x") -> MathResult:
    """Differentiate an expression with respect to a variable."""

    symbol = parse_symbol(variable)
    parsed = parse_expression(expression)
    derivative = sp.diff(parsed, symbol)
    verified = verify_derivative(parsed, symbol, derivative)

    return MathResult(
        operation=MathOperation.DIFFERENTIATE,
        input_expression=expression,
        variable=variable,
        answers=[str(derivative)],
        latex=sp.latex(derivative),
        verified=verified,
        warnings=_result_warnings(verified),
        steps=derivative_steps(parsed, symbol, derivative, verified),
        metadata=_result_metadata(
            MathOperation.DIFFERENTIATE,
            variable,
            verification="deterministic_recomputation",
        ),
    )


def integrate_expression(expression: str, variable: str = "x") -> MathResult:
    """Integrate an expression with respect to a variable."""

    symbol = parse_symbol(variable)
    parsed = parse_expression(expression)
    integral = sp.integrate(parsed, symbol)
    verified = expressions_equivalent(sp.diff(integral, symbol), parsed)
    warnings = _result_warnings(verified)
    if integral.has(sp.Integral):
        warnings.append(
            "Integral could not be fully evaluated by the deterministic engine."
        )

    return MathResult(
        operation=MathOperation.INTEGRATE,
        input_expression=expression,
        variable=variable,
        answers=[str(integral)],
        latex=sp.latex(integral),
        verified=verified,
        warnings=warnings,
        metadata=_result_metadata(
            MathOperation.INTEGRATE,
            variable,
            verification="differentiate_integral",
        ),
    )


def expand_expression(expression: str, variable: str = "x") -> MathResult:
    """Expand an expression."""

    parse_symbol(variable)
    parsed = parse_expression(expression)
    expanded = sp.expand(parsed)
    verified = expressions_equivalent(parsed, expanded)

    return MathResult(
        operation=MathOperation.EXPAND,
        input_expression=expression,
        variable=variable,
        answers=[str(expanded)],
        latex=sp.latex(expanded),
        verified=verified,
        warnings=_result_warnings(verified),
        metadata=_result_metadata(
            MathOperation.EXPAND,
            variable,
            verification="expression_equivalence",
        ),
    )


def factor_expression(expression: str, variable: str = "x") -> MathResult:
    """Factor an expression."""

    parse_symbol(variable)
    parsed = parse_expression(expression)
    factored = sp.factor(parsed)
    verified = expressions_equivalent(parsed, factored)

    return MathResult(
        operation=MathOperation.FACTOR,
        input_expression=expression,
        variable=variable,
        answers=[str(factored)],
        latex=sp.latex(factored),
        verified=verified,
        warnings=_result_warnings(verified),
        metadata=_result_metadata(
            MathOperation.FACTOR,
            variable,
            verification="expression_equivalence",
        ),
    )


def expressions_equivalent(left: sp.Expr, right: sp.Expr) -> bool:
    """Return whether two symbolic expressions simplify to the same value."""

    return bool(sp.simplify(left - right) == 0)


def verify_derivative(
    expression: sp.Expr,
    symbol: sp.Symbol,
    derivative: sp.Expr,
) -> bool:
    """Verify derivative output against SymPy's deterministic derivative result.

    This is a consistency check, not an independent proof.
    """

    return expressions_equivalent(derivative, sp.diff(expression, symbol))


def _result_warnings(verified: bool) -> list[str]:
    if verified:
        return []
    return ["Result could not be verified by the deterministic engine."]


def _result_metadata(
    operation: MathOperation,
    variable: str,
    *,
    verification: str,
    assumptions: dict[str, Any] | None = None,
) -> dict[str, Any]:
    return {
        "engine": "otmath",
        "engine_version": ENGINE_VERSION,
        "operation": operation.value,
        "variable": variable,
        "assumptions": assumptions or {},
        "verification": verification,
    }


_OPERATION_HANDLERS: dict[MathOperation, OperationHandler] = {
    MathOperation.SOLVE: solve_expression,
    MathOperation.SOLVE_SYSTEM: solve_system,
    MathOperation.SIMPLIFY: simplify_expression,
    MathOperation.DIFFERENTIATE: differentiate_expression,
    MathOperation.INTEGRATE: integrate_expression,
    MathOperation.EXPAND: expand_expression,
    MathOperation.FACTOR: factor_expression,
}


def run_request(request: MathRequest) -> MathResult:
    """Run a math request and return the result."""

    try:
        operation = MathOperation(request.operation)
        handler = _OPERATION_HANDLERS[operation]
    except (KeyError, ValueError) as exc:
        raise UnsupportedOperationError(
            f"Unsupported operation: {request.operation}"
        ) from exc

    result = handler(request.expression, request.variable)
    return _with_request_metadata(result, request)


def _with_request_metadata(result: MathResult, request: MathRequest) -> MathResult:
    metadata = {
        **result.metadata,
        "assumptions": request.assumptions,
    }
    return MathResult(
        operation=result.operation,
        input_expression=result.input_expression,
        variable=result.variable,
        answers=result.answers,
        latex=result.latex,
        verified=result.verified,
        warnings=result.warnings,
        steps=result.steps,
        metadata=metadata,
    )
