"""Deterministic equation-system solving domain."""

from __future__ import annotations

from collections.abc import Sequence
from dataclasses import dataclass
from typing import cast

import sympy as sp

from otmath.errors import MathRequestError
from otmath.models import MathOperation, MathResult
from otmath.parser import parse_equation_or_expression, parse_symbol

ENGINE_VERSION = "0.1.0"


@dataclass(frozen=True)
class SystemRequest:
    """A validated system-of-equations request."""

    equations: tuple[str, ...]
    variables: tuple[str, ...]

    @classmethod
    def from_values(
        cls,
        equations: Sequence[str] | str,
        variables: Sequence[str] | str,
    ) -> SystemRequest:
        equation_items = _normalize_items(equations, delimiter=";", label="equations")
        variable_items = _normalize_items(variables, delimiter=",", label="variables")

        if not equation_items:
            raise MathRequestError("System request must include at least one equation.")
        if not variable_items:
            raise MathRequestError("System request must include at least one variable.")

        for variable in variable_items:
            parse_symbol(variable)

        return cls(equations=tuple(equation_items), variables=tuple(variable_items))


def solve_system(
    equations: Sequence[str] | str,
    variables: Sequence[str] | str = ("x", "y"),
) -> MathResult:
    """Solve a system of equations for one or more variables."""

    request = SystemRequest.from_values(equations, variables)
    symbols = [parse_symbol(variable) for variable in request.variables]
    parsed_equations = [
        parse_equation_or_expression(equation) for equation in request.equations
    ]
    solutions = cast(
        list[dict[sp.Symbol, sp.Expr]],
        sp.solve(parsed_equations, symbols, dict=True),
    )
    verified = verify_system_solutions(parsed_equations, solutions)
    warnings = _system_warnings(verified)
    if not solutions:
        warnings.append("No system solutions were returned for the selected variables.")

    return MathResult(
        operation=MathOperation.SOLVE_SYSTEM,
        input_expression="; ".join(request.equations),
        variable=",".join(request.variables),
        answers=[_format_solution(solution, symbols) for solution in solutions],
        latex=_format_latex_solutions(solutions, symbols),
        verified=verified,
        warnings=warnings,
        metadata={
            "engine": "otmath",
            "engine_version": ENGINE_VERSION,
            "operation": MathOperation.SOLVE_SYSTEM.value,
            "variable": ",".join(request.variables),
            "variables": list(request.variables),
            "equation_count": len(request.equations),
            "assumptions": {},
            "verification": "system_solution_substitution",
        },
    )


def verify_system_solutions(
    equations: Sequence[sp.Expr],
    solutions: Sequence[dict[sp.Symbol, sp.Expr]],
) -> bool:
    """Verify every returned system solution by substitution."""

    if not solutions:
        return False

    return all(
        all(sp.simplify(equation.subs(solution)) == 0 for equation in equations)
        for solution in solutions
    )


def _normalize_items(
    values: Sequence[str] | str,
    *,
    delimiter: str,
    label: str,
) -> list[str]:
    if isinstance(values, str):
        items = [part.strip() for part in values.split(delimiter)]
    else:
        items = [str(part).strip() for part in values]

    if any(not item for item in items):
        raise MathRequestError(f"System request contains an empty {label} item.")

    return items


def _format_solution(
    solution: dict[sp.Symbol, sp.Expr],
    symbols: Sequence[sp.Symbol],
) -> str:
    parts = []
    for symbol in symbols:
        if symbol in solution:
            parts.append(f"{symbol} = {sp.sstr(solution[symbol])}")
        else:
            parts.append(f"{symbol} is free")
    return ", ".join(parts)


def _format_latex_solutions(
    solutions: Sequence[dict[sp.Symbol, sp.Expr]],
    symbols: Sequence[sp.Symbol],
) -> str:
    if not solutions:
        return r"\varnothing"

    latex_solutions = []
    for solution in solutions:
        parts = []
        for symbol in symbols:
            if symbol in solution:
                parts.append(f"{sp.latex(symbol)} = {sp.latex(solution[symbol])}")
            else:
                parts.append(rf"{sp.latex(symbol)} \text{{ free }}")
        latex_solutions.append(r"\left\{ " + ", ".join(parts) + r" \right\}")

    return r" \\ ".join(latex_solutions)


def _system_warnings(verified: bool) -> list[str]:
    if verified:
        return []
    return ["Result could not be verified by the deterministic engine."]
