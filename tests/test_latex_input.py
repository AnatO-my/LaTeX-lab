import pytest

from otmath.engine import expressions_equivalent
from otmath.errors import MathParseError
from otmath.latex_input import (
    latex_derivative_to_engine_parts,
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


def test_latex_input_converts_grouped_function_arguments() -> None:
    assert_latex_equivalent(r"\tan{x^{-1}}", "tan(x**-1)")
    assert_latex_equivalent(r"\tan{x^2 + 1}", "tan(x**2 + 1)")
    assert_latex_equivalent(r"\tan{\frac{1}{x}}", "tan(1/x)")


def test_latex_input_converts_standard_inverse_trig_functions() -> None:
    assert_latex_equivalent(r"\arctan{x}", "atan(x)")
    assert_latex_equivalent(r"\arcsin{x}", "asin(x)")
    assert_latex_equivalent(r"\arccos{x}", "acos(x)")


def test_latex_input_does_not_accept_inverse_trig_aliases() -> None:
    with pytest.raises(MathParseError):
        parse_expression(latex_to_engine_expression(r"\atan{x}"))


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


def test_latex_input_extracts_integral_parts_with_grouped_integrands() -> None:
    assert latex_integral_to_engine_parts(r"\int \tan{x^{-1}} \, dx") == (
        "tan(x**(-1))",
        "x",
    )
    assert latex_integral_to_engine_parts(r"\int{\sin{x+\pi}} \, dx") == (
        "(sin(x+pi))",
        "x",
    )


def test_latex_input_extracts_integral_parts_with_latex_differentials() -> None:
    assert latex_integral_to_engine_parts(r"\int \theta^{2} \, d\theta") == (
        "theta**(2)",
        "theta",
    )
    assert latex_integral_to_engine_parts(r"\int t^{2} \, dt") == ("t**(2)", "t")


def test_latex_input_extracts_derivative_parts() -> None:
    assert latex_derivative_to_engine_parts(
        r"\frac{d}{dx}\left(\sin{x}\right)"
    ) == ("sin(x)", "x")
    assert latex_derivative_to_engine_parts(r"\frac{d}{d\theta}\theta^{2}") == (
        "theta**(2)",
        "theta",
    )


def test_latex_input_extracts_higher_order_derivative_parts() -> None:
    assert latex_derivative_to_engine_parts(
        r"\frac{d^{2}}{dx^{2}}\left(\sin{x}\right)"
    ) == ("sin(x)", "x,2")
    assert latex_derivative_to_engine_parts(r"\frac{d^3}{dt^3}t^{5}") == (
        "t**(5)",
        "t,3",
    )


def test_latex_input_rejects_mismatched_derivative_orders() -> None:
    with pytest.raises(MathParseError, match="orders must match"):
        latex_derivative_to_engine_parts(r"\frac{d^{2}}{dx^{3}}\sin{x}")


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


def test_latex_input_expands_independent_plus_minus_branches() -> None:
    assert latex_to_engine_expression_branches(r"a \pm b \pm c") == (
        "a + b + c",
        "a + b - c",
        "a - b + c",
        "a - b - c",
    )


def test_latex_input_rejects_empty_expression() -> None:
    with pytest.raises(MathParseError, match="LaTeX expression cannot be empty"):
        latex_to_engine_expression(" ")
