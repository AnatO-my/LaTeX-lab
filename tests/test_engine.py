import pytest

from otmath import (
    differentiate_expression,
    expand_expression,
    factor_expression,
    integrate_expression,
    limit_expression,
    matrix_adjoint,
    matrix_cholesky_decomposition,
    matrix_columnspace,
    matrix_conjugate,
    matrix_determinant,
    matrix_diagonalize,
    matrix_eigenvalues,
    matrix_eigenvectors,
    matrix_inverse,
    matrix_lu_decomposition,
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
    product_expression,
    render_steps_latex,
    render_steps_text,
    run_request,
    simplify_expression,
    solve_expression,
    solve_inequality_expression,
    solve_system,
    summation_expression,
)
from otmath.domains import SystemRequest
from otmath.domains.matrices import parse_matrix, parse_matrix_pair
from otmath.engine import (
    expressions_equivalent,
)
from otmath.errors import MathParseError, MathRequestError, UnsupportedOperationError
from otmath.models import MathOperation, MathRequest
from otmath.parser import parse_expression


def test_solve_quadratic() -> None:
    result = solve_expression("x**2 - 5*x + 6")

    assert result.answers == ["2", "3"]
    assert result.verified is True
    assert result.metadata["engine"] == "otmath"
    assert result.metadata["operation"] == "solve"
    assert result.metadata["verification"] == "solution_substitution"
    assert [step.kind for step in result.steps] == ["normalize", "solve", "verify"]
    assert result.as_dict()["steps"][0]["kind"] == "normalize"


def test_solve_quadratic_equation() -> None:
    result = solve_expression("x**2 - 5*x + 6 = 0")

    assert result.answers == ["2", "3"]
    assert result.verified is True


def test_solve_equation_with_expression_on_both_sides() -> None:
    result = solve_expression("2*x + 1 = 7")

    assert result.answers == ["3"]
    assert result.verified is True


def test_solve_system_linear_equations() -> None:
    result = solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])

    assert result.answers == ["x = 3, y = 2"]
    assert result.verified is True
    assert result.operation is MathOperation.SOLVE_SYSTEM
    assert result.metadata["verification"] == "system_solution_substitution"
    assert result.metadata["variables"] == ["x", "y"]
    assert [step.kind for step in result.steps] == ["normalize", "solve", "verify"]


def test_solve_system_accepts_cli_style_strings() -> None:
    result = solve_system("x + y = 5; x - y = 1", variables="x,y")

    assert result.answers == ["x = 3, y = 2"]
    assert result.verified is True


def test_system_request_rejects_empty_items() -> None:
    with pytest.raises(MathRequestError):
        SystemRequest.from_values("x + y = 5; ", "x,y")


def test_simplify_expression() -> None:
    result = simplify_expression("(x + 1)**2 - x**2")

    assert result.answers == ["2*x + 1"]
    assert result.verified is True
    assert result.steps[0].kind == "simplify"
    assert result.steps[0].rule == "sympy_simplify"


def test_differentiate_expression() -> None:
    result = differentiate_expression("x**3")

    assert result.answers == ["3*x**2"]
    assert result.verified is True
    assert result.steps[0].kind == "differentiate"
    assert result.steps[0].rule == "sympy_diff"


def test_differentiate_expression_accepts_ordered_variable_spec() -> None:
    result = differentiate_expression("sin(x)", variable="x,2")

    assert result.answers == ["-sin(x)"]
    assert result.verified is True
    assert result.metadata["derivative_order"] == 2


def test_integrate_expression() -> None:
    result = integrate_expression("2*x")

    assert result.answers == ["x**2"]
    assert result.verified is True
    assert [step.kind for step in result.steps] == ["integrate", "verify"]


def test_parse_matrix_accepts_symbolic_entries() -> None:
    matrix = parse_matrix("[[x, 1], [2, x + 1]]")

    assert matrix.shape == (2, 2)
    assert str(matrix[1, 1]) == "x + 1"


def test_parse_matrix_pair_accepts_linear_system_input() -> None:
    matrix, rhs = parse_matrix_pair("[[2, 1], [1, -1]]; [[5], [1]]")

    assert matrix.shape == (2, 2)
    assert rhs.shape == (2, 1)


def test_matrix_determinant() -> None:
    result = matrix_determinant("[[1, 2], [3, 4]]")

    assert result.answers == ["-2"]
    assert result.verified is True
    assert result.metadata["rows"] == 2
    assert result.metadata["columns"] == 2
    assert result.steps[0].kind == "matrix_det"
    assert result.steps[0].title == "Compute the matrix determinant"


def test_matrix_order() -> None:
    result = matrix_order("[[1, 2, 3], [4, 5, 6]]")

    assert result.answers == ["2x3"]
    assert result.latex == r"2 \times 3"
    assert result.metadata["rows"] == 2
    assert result.metadata["columns"] == 3


def test_matrix_rank() -> None:
    result = matrix_rank("[[1, 2, 3], [2, 4, 6], [1, 0, 1]]")

    assert result.answers == ["2"]
    assert result.verified is True


def test_matrix_trace() -> None:
    result = matrix_trace("[[1, 2], [3, 4]]")

    assert result.answers == ["5"]
    assert result.metadata["verification"] == "sympy_matrix_trace"


def test_matrix_inverse() -> None:
    result = matrix_inverse("[[1, 2], [3, 4]]")

    assert "Matrix([[-2, 1], [3/2, -1/2]])" in result.answers
    assert result.verified is True


def test_matrix_power() -> None:
    result = matrix_power("[[1, 1], [0, 1]]", variable="3")

    assert result.answers == ["Matrix([[1, 3], [0, 1]])"]
    assert result.metadata["exponent"] == 3


def test_matrix_transpose() -> None:
    result = matrix_transpose("[[1, 2], [3, 4]]")

    assert result.answers == ["Matrix([[1, 3], [2, 4]])"]
    assert result.verified is True


def test_matrix_conjugate() -> None:
    result = matrix_conjugate("[[1 + I, 2], [3, 4 - I]]")

    assert result.answers == ["Matrix([[1 - I, 2], [3, 4 + I]])"]
    assert result.verified is True


def test_matrix_adjoint() -> None:
    result = matrix_adjoint("[[1 + I, 2], [3, 4 - I]]")

    assert result.answers == ["Matrix([[1 - I, 3], [2, 4 + I]])"]
    assert result.verified is True


def test_matrix_rref() -> None:
    result = matrix_rref("[[1, 2], [3, 4]]")

    assert result.answers == ["Matrix([[1, 0], [0, 1]])"]
    assert result.metadata["pivots"] == [0, 1]


def test_matrix_solve() -> None:
    result = matrix_solve("[[2, 1], [1, -1]]; [[5], [1]]")

    assert result.answers == ["Matrix([[2], [1]])"]
    assert result.verified is True
    assert result.metadata["solution_rows"] == 2
    assert result.metadata["solution_columns"] == 1


def test_matrix_nullspace() -> None:
    result = matrix_nullspace("[[1, 2, 3], [2, 4, 6]]")

    assert result.answers == [
        "Matrix([[-2], [1], [0]])",
        "Matrix([[-3], [0], [1]])",
    ]
    assert result.metadata["space_dimension"] == 2


def test_matrix_columnspace() -> None:
    result = matrix_columnspace("[[1, 2, 3], [2, 4, 6]]")

    assert result.answers == ["Matrix([[1], [2]])"]
    assert result.metadata["space_dimension"] == 1


def test_matrix_rowspace() -> None:
    result = matrix_rowspace("[[1, 2, 3], [2, 4, 6]]")

    assert result.answers == ["Matrix([[1, 2, 3]])"]
    assert result.metadata["space_dimension"] == 1


def test_matrix_eigenvalues() -> None:
    result = matrix_eigenvalues("[[2, 0], [0, 3]]")

    assert result.answers == ["2 (multiplicity 1)", "3 (multiplicity 1)"]
    assert result.verified is True


def test_matrix_eigenvectors() -> None:
    result = matrix_eigenvectors("[[2, 0], [0, 3]]")

    assert result.answers == [
        "lambda = 2 (multiplicity 1): Matrix([[1], [0]])",
        "lambda = 3 (multiplicity 1): Matrix([[0], [1]])",
    ]
    assert result.verified is True


def test_matrix_diagonalize() -> None:
    result = matrix_diagonalize("[[2, 0], [0, 3]]")

    assert result.answers == [
        "P = Matrix([[1, 0], [0, 1]])",
        "D = Matrix([[2, 0], [0, 3]])",
    ]
    assert "D =" in result.latex
    assert result.verified is True


def test_matrix_lu_decomposition() -> None:
    result = matrix_lu_decomposition("[[2, 1], [4, 3]]")

    assert result.answers == [
        "L = Matrix([[1, 0], [2, 1]])",
        "U = Matrix([[2, 1], [0, 1]])",
        "swaps = []",
    ]
    assert result.verified is True


def test_matrix_qr_decomposition() -> None:
    result = matrix_qr_decomposition("[[1, 0], [1, 1]]")

    assert result.answers[0].startswith("Q = Matrix(")
    assert result.answers[1].startswith("R = Matrix(")
    assert result.verified is True


def test_matrix_cholesky_decomposition() -> None:
    result = matrix_cholesky_decomposition("[[4, 2], [2, 3]]")

    assert result.answers == ["L = Matrix([[2, 0], [1, sqrt(2)]])"]
    assert result.verified is True


def test_summation_expression() -> None:
    result = summation_expression("k**2", variable="k,1,n")

    assert result.answers == ["n**3/3 + n**2/2 + n/6"]
    assert result.verified is True
    assert result.metadata["summation_variable"] == "k"


def test_product_expression() -> None:
    result = product_expression("k", variable="k,1,n")

    assert result.answers == ["factorial(n)"]
    assert result.verified is True
    assert result.metadata["product_variable"] == "k"


def test_limit_expression() -> None:
    result = limit_expression("sin(x)/x", variable="x,0,+-")

    assert result.answers == ["1"]
    assert result.verified is True
    assert result.metadata["direction"] == "+-"


def test_solve_inequality_expression() -> None:
    result = solve_inequality_expression("x <= 3")

    assert result.answers == ["Interval(-oo, 3)"]
    assert result.verified is True
    assert result.latex == r"\left(-\infty, 3\right]"


def test_factor_expression() -> None:
    result = factor_expression("x**2 - 5*x + 6")

    assert expressions_equivalent(
        parse_expression(result.answers[0]), parse_expression("x**2 - 5*x + 6")
    )
    assert result.verified is True


def test_factor_expression_over_complex_numbers() -> None:
    result = factor_expression("x**4 - 1")

    assert "(x - I)" in result.answers[0]
    assert "(x + I)" in result.answers[0]
    assert expressions_equivalent(parse_expression(result.answers[0]), parse_expression("x**4 - 1"))
    assert result.verified is True
    assert result.metadata["domain"] == "complex"


def test_expand_expression() -> None:
    result = expand_expression("(x - 2)*(x - 3)")

    assert result.answers == ["x**2 - 5*x + 6"]
    assert result.verified is True
    assert result.steps[0].kind == "expand"
    assert result.steps[0].rule == "sympy_expand"


def test_rejects_invalid_expression() -> None:
    with pytest.raises(MathParseError):
        simplify_expression("__import__('os').system('dir')")


def test_rejects_unknown_function_call() -> None:
    with pytest.raises(MathParseError):
        simplify_expression("madeup(x)")


def test_rejects_empty_expression() -> None:
    with pytest.raises(MathParseError):
        simplify_expression("   ")


def test_rejects_invalid_variable_name() -> None:
    with pytest.raises(MathParseError):
        solve_expression("x**2 - 1", variable="class")


def test_rejects_malformed_equation() -> None:
    with pytest.raises(MathParseError):
        solve_expression("x = = 2")


def test_non_solve_operations_reject_equation_input() -> None:
    with pytest.raises(MathParseError):
        simplify_expression("x + 1 = 2")


def test_math_request_accepts_operation_strings() -> None:
    request = MathRequest(operation="factor", expression="x**2 - 1")

    assert request.operation is MathOperation.FACTOR


def test_math_request_accepts_system_variable_spec() -> None:
    request = MathRequest(
        operation=MathOperation.SOLVE_SYSTEM,
        expression="x + y = 5; x - y = 1",
        variable="x,y",
    )

    assert request.variable == "x,y"


def test_math_request_rejects_empty_expression() -> None:
    with pytest.raises(MathRequestError):
        MathRequest(operation=MathOperation.SIMPLIFY, expression="")


def test_math_request_rejects_invalid_variable_name() -> None:
    with pytest.raises(MathRequestError):
        MathRequest(operation=MathOperation.SOLVE, expression="x**2 - 1", variable="for")


def test_run_request_dispatches_factor() -> None:
    request = MathRequest(
        operation=MathOperation.FACTOR,
        expression="x**2 - 5*x + 6",
        assumptions={"domain": "real"},
    )

    result = run_request(request)

    assert expressions_equivalent(
        parse_expression(result.answers[0]),
        parse_expression("x**2 - 5*x + 6"),
    )
    assert result.verified is True
    assert result.metadata["assumptions"] == {"domain": "real"}


def test_run_request_dispatches_system() -> None:
    request = MathRequest(
        operation=MathOperation.SOLVE_SYSTEM,
        expression="x + y = 5; x - y = 1",
        variable="x,y",
    )

    result = run_request(request)

    assert result.answers == ["x = 3, y = 2"]
    assert result.verified is True


def test_run_request_rejects_unsupported_operation() -> None:
    with pytest.raises(UnsupportedOperationError):
        MathRequest(
            operation="unknown",
            expression="x",
        )


def test_solve_warns_when_no_solutions_are_returned() -> None:
    result = solve_expression("x - x - 1")

    assert result.answers == []
    assert result.verified is False
    assert result.warnings == [
        "Result could not be verified by the deterministic engine.",
        "No solutions were returned for the selected variable.",
    ]


def test_step_renderers() -> None:
    result = simplify_expression("(x + 1)**2 - x**2")

    assert "Simplify the expression" in render_steps_text(result.steps)
    assert "\\begin{aligned}" in render_steps_latex(result.steps)


def test_step_renderers_handle_empty_steps() -> None:
    assert render_steps_text([]) == "No explanation steps are available."


def test_factor_expression_has_steps() -> None:
    result = factor_expression("x**2 - 5*x + 6")

    assert result.steps[0].kind == "factor"
    assert result.steps[0].rule == "sympy_factor_complex"
    assert "Factor the expression" in render_steps_text(result.steps)
