"""Deterministic explanation step helpers."""

from __future__ import annotations

from collections.abc import Sequence

import sympy as sp

from otmath.latex_render import render_latex
from otmath.models import MathStep


def make_step(
    *,
    kind: str,
    title: str,
    input_expression: object,
    output_expression: object,
    rule: str,
    verified: bool,
    metadata: dict[str, str] | None = None,
) -> MathStep:
    """Build a serializable math step from symbolic or string expressions."""

    output_text = str(output_expression)
    latex = (
        rf"\text{{{output_text}}}"
        if isinstance(output_expression, str)
        else render_latex(output_expression)
    )
    return MathStep(
        kind=kind,
        title=title,
        input_expression=str(input_expression),
        output_expression=output_text,
        rule=rule,
        verified=verified,
        latex=latex,
        metadata=metadata or {},
    )


def solve_steps(
    *,
    original_expression: str,
    normalized_expression: sp.Expr,
    answers: list[sp.Expr],
    verified: bool,
) -> list[MathStep]:
    """Generate deterministic solve steps."""

    steps = [
        make_step(
            kind="normalize",
            title="Normalize the solve target",
            input_expression=original_expression,
            output_expression=normalized_expression,
            rule="equation_to_zero_form",
            verified=True,
        ),
        make_step(
            kind="solve",
            title="Solve for the selected variable",
            input_expression=normalized_expression,
            output_expression=sp.Tuple(*answers),
            rule="sympy_solve",
            verified=bool(answers),
        ),
    ]
    steps.append(
        make_step(
            kind="verify",
            title="Verify returned solutions",
            input_expression=normalized_expression,
            output_expression="verified" if verified else "not verified",
            rule="solution_substitution",
            verified=verified,
        )
    )
    return steps


def simplify_steps(original: sp.Expr, simplified: sp.Expr, verified: bool) -> list[MathStep]:
    """Generate deterministic simplification steps."""

    return [
        make_step(
            kind="simplify",
            title="Simplify the expression",
            input_expression=original,
            output_expression=simplified,
            rule="sympy_simplify",
            verified=verified,
        )
    ]


def transform_steps(
    *,
    kind: str,
    title: str,
    original: object,
    result: object,
    rule: str,
    verified: bool,
    metadata: dict[str, str] | None = None,
) -> list[MathStep]:
    """Generate a one-step deterministic transformation explanation."""

    return [
        make_step(
            kind=kind,
            title=title,
            input_expression=original,
            output_expression=result,
            rule=rule,
            verified=verified,
            metadata=metadata,
        )
    ]


def derivative_steps(
    original: sp.Expr,
    symbol: sp.Symbol,
    derivative: sp.Expr,
    verified: bool,
) -> list[MathStep]:
    """Generate deterministic derivative steps."""

    return [
        make_step(
            kind="differentiate",
            title=f"Differentiate with respect to {symbol}",
            input_expression=original,
            output_expression=derivative,
            rule="sympy_diff",
            verified=verified,
            metadata={"variable": str(symbol)},
        )
    ]


def integral_steps(
    original: sp.Expr,
    symbol: sp.Symbol,
    integral: sp.Expr,
    verified: bool,
) -> list[MathStep]:
    """Generate deterministic integral steps."""

    return [
        make_step(
            kind="integrate",
            title=f"Integrate with respect to {symbol}",
            input_expression=original,
            output_expression=integral,
            rule="sympy_integrate",
            verified=True,
            metadata={"variable": str(symbol)},
        ),
        make_step(
            kind="verify",
            title="Verify by differentiating the result",
            input_expression=integral,
            output_expression="verified" if verified else "not verified",
            rule="differentiate_integral",
            verified=verified,
        ),
    ]


def system_steps(
    *,
    original_equations: Sequence[str],
    normalized_equations: Sequence[sp.Expr],
    solution_text: Sequence[str],
    verified: bool,
) -> list[MathStep]:
    """Generate deterministic system-solving steps."""

    normalized = sp.Tuple(*normalized_equations)
    return [
        make_step(
            kind="normalize",
            title="Normalize each system equation",
            input_expression="; ".join(original_equations),
            output_expression=normalized,
            rule="equations_to_zero_form",
            verified=True,
        ),
        make_step(
            kind="solve",
            title="Solve the system for selected variables",
            input_expression=normalized,
            output_expression="; ".join(solution_text) if solution_text else "no solutions",
            rule="sympy_solve_system",
            verified=bool(solution_text),
        ),
        make_step(
            kind="verify",
            title="Verify returned system solutions",
            input_expression=normalized,
            output_expression="verified" if verified else "not verified",
            rule="system_solution_substitution",
            verified=verified,
        ),
    ]


def render_steps_text(steps: list[MathStep]) -> str:
    """Render steps as readable plain text."""

    if not steps:
        return "No explanation steps are available."
    return "\n".join(
        f"{index}. {step.title}: {step.output_expression} [{step.rule}]"
        for index, step in enumerate(steps, start=1)
    )


def render_steps_latex(steps: list[MathStep]) -> str:
    """Render steps as a simple LaTeX aligned block."""

    if not steps:
        return r"\text{No explanation steps are available.}"
    lines = [rf"\text{{{step.title}}} &: \quad {step.latex}" for step in steps]
    return "\\begin{aligned}\n" + " \\\\\n".join(lines) + "\n\\end{aligned}"
