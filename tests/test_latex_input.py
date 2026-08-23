import pytest

from otmath.engine import expressions_equivalent
from otmath.errors import MathParseError
from otmath.latex_input import latex_to_engine_expression, latex_to_engine_symbol_spec
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


def test_latex_input_converts_subscripted_variables() -> None:
    assert_latex_equivalent(r"x_{0}^{2} - 2x_{0}", "x_0**2 - 2*x_0")


def test_latex_input_converts_greek_variables() -> None:
    assert_latex_equivalent(r"\alpha^{2} + \beta", "alpha**2 + beta")


def test_latex_input_converts_greek_subscript_variables() -> None:
    assert_latex_equivalent(r"\theta_{1}^{2} + \Delta", "theta_1**2 + Delta")


def test_latex_input_converts_variable_specs() -> None:
    assert latex_to_engine_symbol_spec(r"x_{0}, \alpha, \theta_{1}") == "x_0,alpha,theta_1"


def test_latex_input_rejects_empty_expression() -> None:
    with pytest.raises(MathParseError, match="LaTeX expression cannot be empty"):
        latex_to_engine_expression(" ")
