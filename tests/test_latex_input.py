import pytest

from otmath.engine import expressions_equivalent
from otmath.errors import MathParseError
from otmath.latex_input import latex_to_engine_expression
from otmath.parser import parse_expression


def assert_latex_equivalent(latex: str, engine: str) -> None:
    assert expressions_equivalent(
        parse_expression(latex_to_engine_expression(latex)),
        parse_expression(engine),
    )


def test_latex_input_converts_basic_polynomial() -> None:
    assert_latex_equivalent(r"x^{2} - 5x + 6", "x**2 - 5*x + 6")


def test_latex_input_converts_fraction_and_square_root() -> None:
    assert_latex_equivalent(r"\frac{x^{2} - 1}{x - 1} + \sqrt{x}", "(x**2 - 1)/(x - 1) + sqrt(x)")


def test_latex_input_converts_common_functions_and_e_constant() -> None:
    assert_latex_equivalent(r"\sin{x} + e^{-x^{2}}", "sin(x) + E**(-x**2)")


def test_latex_input_rejects_empty_expression() -> None:
    with pytest.raises(MathParseError, match="LaTeX expression cannot be empty"):
        latex_to_engine_expression(" ")
