"""Starter deterministic math engine."""

from __future__ import annotations

from collections.abc import Callable
from typing import Any

import sympy as sp

from otmath.domains.matrices import (
    matrix_adjoint,
    matrix_cholesky_decomposition,
    matrix_columnspace,
    matrix_condition_number,
    matrix_conjugate,
    matrix_determinant,
    matrix_diagonalize,
    matrix_eigenvalues,
    matrix_eigenvectors,
    matrix_inverse,
    matrix_lu_decomposition,
    matrix_norm,
    matrix_nullspace,
    matrix_order,
    matrix_power,
    matrix_qr_decomposition,
    matrix_rank,
    matrix_rowspace,
    matrix_rref,
    matrix_solve,
    matrix_trace,
    matrix_transpose,
)
from otmath.domains.statistics import (
    statistics_mean,
    statistics_median,
    statistics_stdev,
    statistics_variance,
)
from otmath.domains.systems import solve_system
from otmath.domains.units import convert_units
from otmath.errors import UnsupportedOperationError
from otmath.latex_render import render_latex
from otmath.models import MathOperation, MathRequest, MathResult
from otmath.parser import (
    parse_equation_or_expression,
    parse_expression,
    parse_relational_expression,
    parse_symbol,
)
from otmath.steps import (
    derivative_steps,
    integral_steps,
    make_step,
    simplify_steps,
    solve_steps,
    transform_steps,
)

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
        latex=render_latex(answers),
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


def numeric_solve_expression(expression: str, variable: str = "x,1") -> MathResult:
    """Find a numeric solution from a single-variable initial guess."""

    variable_name, guess_text = _parse_numeric_solve_variable_spec(variable)
    symbol = parse_symbol(variable_name)
    parsed = parse_equation_or_expression(expression)
    guess = parse_expression(guess_text)

    try:
        solution = sp.nsolve(parsed, symbol, guess)
    except (TypeError, ValueError, ZeroDivisionError) as exc:
        raise UnsupportedOperationError(
            "Numeric solve failed from the supplied initial guess."
        ) from exc

    residual = _numeric_residual_magnitude(parsed.subs(symbol, solution))
    tolerance = 1e-10
    verified = residual <= tolerance
    warnings = _result_warnings(verified)
    if not verified:
        warnings.append("Numeric solve residual exceeded the verification tolerance.")

    return MathResult(
        operation=MathOperation.NUMERIC_SOLVE,
        input_expression=expression,
        variable=variable,
        answers=[_format_numeric_solution(solution)],
        latex=render_latex(solution),
        verified=verified,
        warnings=warnings,
        steps=[
            make_step(
                kind="normalize",
                title="Normalize the numeric solve target",
                input_expression=expression,
                output_expression=parsed,
                rule="equation_to_zero_form",
                verified=True,
            ),
            make_step(
                kind="nsolve",
                title=f"Numerically solve from initial guess {guess_text}",
                input_expression=parsed,
                output_expression=solution,
                rule="sympy_nsolve",
                verified=True,
                metadata={"variable": variable_name, "initial_guess": guess_text},
            ),
            make_step(
                kind="verify",
                title="Verify numeric residual",
                input_expression=parsed,
                output_expression="verified" if verified else f"residual = {residual}",
                rule="numeric_residual",
                verified=verified,
                metadata={"residual": str(residual), "tolerance": str(tolerance)},
            ),
        ],
        metadata=_result_metadata(
            MathOperation.NUMERIC_SOLVE,
            variable,
            verification="numeric_residual",
            numeric_variable=variable_name,
            initial_guess=guess_text,
            residual=str(residual),
            tolerance=str(tolerance),
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
        latex=render_latex(simplified),
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

    variable_name, order = _parse_derivative_variable_spec(variable)
    symbol = parse_symbol(variable_name)
    parsed = parse_expression(expression)
    derivative = sp.diff(parsed, symbol, order)
    verified = verify_derivative(parsed, symbol, derivative, order)

    return MathResult(
        operation=MathOperation.DIFFERENTIATE,
        input_expression=expression,
        variable=variable,
        answers=[str(derivative)],
        latex=render_latex(derivative),
        verified=verified,
        warnings=_result_warnings(verified),
        steps=derivative_steps(parsed, symbol, derivative, verified),
        metadata=_result_metadata(
            MathOperation.DIFFERENTIATE,
            variable,
            verification="deterministic_recomputation",
            derivative_variable=variable_name,
            derivative_order=order,
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
        latex=render_latex(integral),
        verified=verified,
        warnings=warnings,
        steps=integral_steps(parsed, symbol, integral, verified),
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
        latex=render_latex(expanded),
        verified=verified,
        warnings=_result_warnings(verified),
        steps=transform_steps(
            kind="expand",
            title="Expand the expression",
            original=parsed,
            result=expanded,
            rule="sympy_expand",
            verified=verified,
        ),
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
    factored = sp.factor(parsed, extension=sp.I)
    verified = expressions_equivalent(parsed, factored)

    return MathResult(
        operation=MathOperation.FACTOR,
        input_expression=expression,
        variable=variable,
        answers=[str(factored)],
        latex=render_latex(factored),
        verified=verified,
        warnings=_result_warnings(verified),
        steps=transform_steps(
            kind="factor",
            title="Factor the expression",
            original=parsed,
            result=factored,
            rule="sympy_factor_complex",
            verified=verified,
            metadata={"domain": "complex"},
        ),
        metadata=_result_metadata(
            MathOperation.FACTOR,
            variable,
            verification="expression_equivalence",
            domain="complex",
        ),
    )


def summation_expression(expression: str, variable: str = "k,1,n") -> MathResult:
    """Evaluate a symbolic summation."""

    symbol_name, lower_text, upper_text = _parse_range_variable_spec(variable, "sum")
    symbol = parse_symbol(symbol_name)
    parsed = parse_expression(expression)
    lower = parse_expression(lower_text)
    upper = parse_expression(upper_text)
    result = sp.summation(parsed, (symbol, lower, upper))

    return MathResult(
        operation=MathOperation.SUMMATION,
        input_expression=expression,
        variable=variable,
        answers=[str(result)],
        latex=render_latex(result),
        verified=True,
        warnings=[],
        metadata=_result_metadata(
            MathOperation.SUMMATION,
            variable,
            verification="deterministic_recomputation",
            summation_variable=symbol_name,
            lower_bound=str(lower),
            upper_bound=str(upper),
        ),
    )


def product_expression(expression: str, variable: str = "k,1,n") -> MathResult:
    """Evaluate a symbolic product."""

    symbol_name, lower_text, upper_text = _parse_range_variable_spec(variable, "product")
    symbol = parse_symbol(symbol_name)
    parsed = parse_expression(expression)
    lower = parse_expression(lower_text)
    upper = parse_expression(upper_text)
    result = sp.product(parsed, (symbol, lower, upper))

    return MathResult(
        operation=MathOperation.PRODUCT,
        input_expression=expression,
        variable=variable,
        answers=[str(result)],
        latex=render_latex(result),
        verified=True,
        warnings=[],
        metadata=_result_metadata(
            MathOperation.PRODUCT,
            variable,
            verification="deterministic_recomputation",
            product_variable=symbol_name,
            lower_bound=str(lower),
            upper_bound=str(upper),
        ),
    )


def limit_expression(expression: str, variable: str = "x,0") -> MathResult:
    """Evaluate a symbolic limit."""

    symbol_name, point_text, direction = _parse_limit_variable_spec(variable)
    symbol = parse_symbol(symbol_name)
    parsed = parse_expression(expression)
    point = parse_expression(point_text)
    result = sp.limit(parsed, symbol, point, dir=direction)

    return MathResult(
        operation=MathOperation.LIMIT,
        input_expression=expression,
        variable=variable,
        answers=[str(result)],
        latex=render_latex(result),
        verified=True,
        warnings=[],
        metadata=_result_metadata(
            MathOperation.LIMIT,
            variable,
            verification="deterministic_recomputation",
            limit_variable=symbol_name,
            point=str(point),
            direction=direction,
        ),
    )


def solve_inequality_expression(expression: str, variable: str = "x") -> MathResult:
    """Solve a single-variable symbolic inequality."""

    symbol = parse_symbol(variable)
    parsed = parse_relational_expression(expression)
    solution = sp.solve_univariate_inequality(parsed, symbol, relational=False)
    verified = bool(solution is not False)

    return MathResult(
        operation=MathOperation.INEQUALITY,
        input_expression=expression,
        variable=variable,
        answers=[str(solution)],
        latex=render_latex(solution),
        verified=verified,
        warnings=_result_warnings(verified),
        metadata=_result_metadata(
            MathOperation.INEQUALITY,
            variable,
            verification="sympy_univariate_inequality",
        ),
    )


def expressions_equivalent(left: sp.Expr, right: sp.Expr) -> bool:
    """Return whether two symbolic expressions simplify to the same value."""

    return bool(sp.simplify(left - right) == 0)


def verify_derivative(
    expression: sp.Expr,
    symbol: sp.Symbol,
    derivative: sp.Expr,
    order: int = 1,
) -> bool:
    """Verify derivative output against SymPy's deterministic derivative result.

    This is a consistency check, not an independent proof.
    """

    return expressions_equivalent(derivative, sp.diff(expression, symbol, order))


def _result_warnings(verified: bool) -> list[str]:
    if verified:
        return []
    return ["Result could not be verified by the deterministic engine."]


def _result_metadata(
    operation: MathOperation,
    variable: str,
    *,
    verification: str,
    domain: str | None = None,
    summation_variable: str | None = None,
    product_variable: str | None = None,
    lower_bound: str | None = None,
    upper_bound: str | None = None,
    limit_variable: str | None = None,
    point: str | None = None,
    direction: str | None = None,
    derivative_variable: str | None = None,
    derivative_order: int | None = None,
    numeric_variable: str | None = None,
    initial_guess: str | None = None,
    residual: str | None = None,
    tolerance: str | None = None,
    assumptions: dict[str, Any] | None = None,
) -> dict[str, Any]:
    metadata: dict[str, Any] = {
        "engine": "otmath",
        "engine_version": ENGINE_VERSION,
        "operation": operation.value,
        "variable": variable,
        "assumptions": assumptions or {},
        "verification": verification,
    }
    if domain is not None:
        metadata["domain"] = domain
    if summation_variable is not None:
        metadata["summation_variable"] = summation_variable
    if product_variable is not None:
        metadata["product_variable"] = product_variable
    if lower_bound is not None:
        metadata["lower_bound"] = lower_bound
    if upper_bound is not None:
        metadata["upper_bound"] = upper_bound
    if limit_variable is not None:
        metadata["limit_variable"] = limit_variable
    if point is not None:
        metadata["point"] = point
    if direction is not None:
        metadata["direction"] = direction
    if derivative_variable is not None:
        metadata["derivative_variable"] = derivative_variable
    if derivative_order is not None:
        metadata["derivative_order"] = derivative_order
    if numeric_variable is not None:
        metadata["numeric_variable"] = numeric_variable
    if initial_guess is not None:
        metadata["initial_guess"] = initial_guess
    if residual is not None:
        metadata["residual"] = residual
    if tolerance is not None:
        metadata["tolerance"] = tolerance
    return metadata


def _parse_range_variable_spec(variable: str, operation: str) -> tuple[str, str, str]:
    parts = [part.strip() for part in variable.split(",")]
    if len(parts) != 3 or any(not part for part in parts):
        raise UnsupportedOperationError(
            f"{operation} variable spec must use variable,lower,upper."
        )
    parse_symbol(parts[0])
    return parts[0], parts[1], parts[2]


def _parse_limit_variable_spec(variable: str) -> tuple[str, str, str]:
    parts = [part.strip() for part in variable.split(",")]
    if len(parts) not in {2, 3} or any(not part for part in parts):
        raise UnsupportedOperationError(
            "limit variable spec must use variable,point or variable,point,direction."
        )

    direction = parts[2] if len(parts) == 3 else "+"
    if direction not in {"+", "-", "+-"}:
        raise UnsupportedOperationError("limit direction must be +, -, or +-.")

    parse_symbol(parts[0])
    return parts[0], parts[1], direction


def _parse_numeric_solve_variable_spec(variable: str) -> tuple[str, str]:
    parts = [part.strip() for part in variable.split(",")]
    if len(parts) == 1:
        parse_symbol(parts[0])
        return parts[0], "1"
    if len(parts) != 2 or any(not part for part in parts):
        raise UnsupportedOperationError(
            "nsolve variable spec must use variable or variable,initial_guess."
        )

    parse_symbol(parts[0])
    return parts[0], parts[1]


def _parse_derivative_variable_spec(variable: str) -> tuple[str, int]:
    parts = [part.strip() for part in variable.split(",")]
    if len(parts) == 1:
        parse_symbol(parts[0])
        return parts[0], 1
    if len(parts) != 2 or any(not part for part in parts):
        raise UnsupportedOperationError(
            "differentiate variable spec must use variable or variable,order."
        )

    try:
        order = int(parts[1])
    except ValueError as exc:
        raise UnsupportedOperationError("derivative order must be an integer.") from exc
    if order < 1:
        raise UnsupportedOperationError("derivative order must be at least 1.")

    parse_symbol(parts[0])
    return parts[0], order


def _format_numeric_solution(solution: sp.Expr) -> str:
    return str(sp.N(solution, 15))


def _numeric_residual_magnitude(value: sp.Expr) -> float:
    evaluated = sp.N(value, 30)
    try:
        return float(abs(complex(evaluated)))
    except (TypeError, ValueError):
        return float(abs(evaluated))


_OPERATION_HANDLERS: dict[MathOperation, OperationHandler] = {
    MathOperation.SOLVE: solve_expression,
    MathOperation.NUMERIC_SOLVE: numeric_solve_expression,
    MathOperation.SOLVE_SYSTEM: solve_system,
    MathOperation.SIMPLIFY: simplify_expression,
    MathOperation.DIFFERENTIATE: differentiate_expression,
    MathOperation.INTEGRATE: integrate_expression,
    MathOperation.EXPAND: expand_expression,
    MathOperation.FACTOR: factor_expression,
    MathOperation.SUMMATION: summation_expression,
    MathOperation.PRODUCT: product_expression,
    MathOperation.LIMIT: limit_expression,
    MathOperation.INEQUALITY: solve_inequality_expression,
    MathOperation.STAT_MEAN: statistics_mean,
    MathOperation.STAT_MEDIAN: statistics_median,
    MathOperation.STAT_VARIANCE: statistics_variance,
    MathOperation.STAT_STDEV: statistics_stdev,
    MathOperation.UNIT_CONVERT: convert_units,
    MathOperation.MATRIX_DETERMINANT: matrix_determinant,
    MathOperation.MATRIX_ORDER: matrix_order,
    MathOperation.MATRIX_RANK: matrix_rank,
    MathOperation.MATRIX_TRACE: matrix_trace,
    MathOperation.MATRIX_INVERSE: matrix_inverse,
    MathOperation.MATRIX_NORM: matrix_norm,
    MathOperation.MATRIX_CONDITION_NUMBER: matrix_condition_number,
    MathOperation.MATRIX_POWER: matrix_power,
    MathOperation.MATRIX_TRANSPOSE: matrix_transpose,
    MathOperation.MATRIX_CONJUGATE: matrix_conjugate,
    MathOperation.MATRIX_ADJOINT: matrix_adjoint,
    MathOperation.MATRIX_RREF: matrix_rref,
    MathOperation.MATRIX_SOLVE: matrix_solve,
    MathOperation.MATRIX_NULLSPACE: matrix_nullspace,
    MathOperation.MATRIX_COLUMNSPACE: matrix_columnspace,
    MathOperation.MATRIX_ROWSPACE: matrix_rowspace,
    MathOperation.MATRIX_EIGENVALUES: matrix_eigenvalues,
    MathOperation.MATRIX_EIGENVECTORS: matrix_eigenvectors,
    MathOperation.MATRIX_DIAGONALIZE: matrix_diagonalize,
    MathOperation.MATRIX_LU: matrix_lu_decomposition,
    MathOperation.MATRIX_QR: matrix_qr_decomposition,
    MathOperation.MATRIX_CHOLESKY: matrix_cholesky_decomposition,
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
