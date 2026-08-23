import pytest

from otmath.engine import expressions_equivalent
from otmath.errors import MathParseError
from otmath.latex_input import (
    latex_integral_to_engine_parts,
    latex_limit_to_engine_parts,
    latex_product_to_engine_parts,
    latex_sum_to_engine_parts,
    latex_to_engine_expression,
    latex_to_engine_expression_branches,
    latex_to_engine_symbol_spec,
)
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


def test_latex_input_converts_variant_greek_variables() -> None:
    assert latex_to_engine_expression(r"\varrho^{2} + \vartheta") == (
        "var_rho**(2) + var_theta"
    )
    assert_latex_equivalent(
        r"\varrho^{2} + \vartheta",
        "var_rho**2 + var_theta",
    )


def test_latex_input_converts_styled_variables() -> None:
    assert_latex_equivalent(
        r"\mathcal{A}^{2} + \mathbb{R}",
        "mathcal_A**2 + mathbb_R",
    )


def test_latex_input_converts_variable_specs() -> None:
    assert latex_to_engine_symbol_spec(r"x_{0}, \alpha, \theta_{1}") == "x_0,alpha,theta_1"


def test_latex_input_converts_styled_variable_specs() -> None:
    assert latex_to_engine_symbol_spec(r"\mathcal{A}, \mathbf{X}") == "mathcal_A,mathbf_X"


def test_latex_input_converts_variant_greek_variable_specs() -> None:
    assert latex_to_engine_symbol_spec(r"\varrho,\vartheta") == "var_rho,var_theta"


def test_latex_input_extracts_sum_parts() -> None:
    assert latex_sum_to_engine_parts(r"\sum_{k=1}^{n} k^{2}") == ("k**(2)", "k,1,n")


def test_latex_input_extracts_product_parts() -> None:
    assert latex_product_to_engine_parts(r"\prod_{k=1}^{n} k") == ("k", "k,1,n")


def test_latex_input_extracts_limit_parts() -> None:
    assert latex_limit_to_engine_parts(r"\lim_{x \to 0} \frac{\sin{x}}{x}") == (
        "(sin(x))/(x)",
        "x,0,+-",
    )


def test_latex_input_extracts_integral_parts() -> None:
    assert latex_integral_to_engine_parts(r"\int 2x \, dx") == ("2x", "x")


def test_latex_input_converts_inequality_operators() -> None:
    assert latex_to_engine_expression(r"x \leq 3") == "x <= 3"


def test_latex_input_expands_plus_minus_branches() -> None:
    assert latex_to_engine_expression_branches(r"x = \pm 2") == (
        "x = + 2",
        "x = - 2",
    )
    assert latex_to_engine_expression_branches(r"(x \pm 1)^{2}") == (
        "(x + 1)**(2)",
        "(x - 1)**(2)",
    )


def test_latex_input_expands_minus_plus_branches() -> None:
    assert latex_to_engine_expression_branches(r"x = \mp 2") == (
        "x = - 2",
        "x = + 2",
    )
    assert latex_to_engine_expression_branches(r"a \pm b \mp c") == (
        "a + b - c",
        "a - b + c",
    )


def test_latex_input_rejects_empty_expression() -> None:
    with pytest.raises(MathParseError, match="LaTeX expression cannot be empty"):
        latex_to_engine_expression(" ")
