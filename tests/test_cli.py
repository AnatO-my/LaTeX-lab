import json
import subprocess
import sys
from pathlib import Path

import pytest

from otcalc.cli import main


def run_cli(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, "-m", "otcalc.cli", *args],
        text=True,
        capture_output=True,
        check=False,
    )


def test_cli_solve_text(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["solve", "x**2 - 5*x + 6"])

    output = capsys.readouterr().out

    assert exit_code == 0
    assert "2" in output
    assert "3" in output


def test_cli_solve_equation_text(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["solve", "x**2 - 5*x + 6 = 0"])

    output = capsys.readouterr().out

    assert exit_code == 0
    assert "2" in output
    assert "3" in output


def test_cli_no_ai_flag(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["--no-ai", "solve", "x**2 - 5*x + 6"])

    output = capsys.readouterr().out

    assert exit_code == 0
    assert "2" in output
    assert "3" in output


def test_cli_command_help() -> None:
    result = run_cli(["solve", "--help"])

    assert result.returncode == 0
    assert "Solve an expression equal to zero" in result.stdout
    assert "--format" in result.stdout


def test_cli_version() -> None:
    result = run_cli(["--version"])

    assert result.returncode == 0
    assert "otcalc 0.1.0" in result.stdout


def test_cli_json(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["simplify", "(x + 1)**2 - x**2", "--format", "json"])

    output = capsys.readouterr().out
    data = json.loads(output)

    assert exit_code == 0
    assert data["operation"] == "simplify"
    assert data["answers"] == ["2*x + 1"]
    assert data["metadata"]["engine"] == "otmath"
    assert data["metadata"]["verification"] == "expression_equivalence"


@pytest.mark.parametrize(
    ("command", "expression", "operation"),
    [
        ("solve", "x**2 - 5*x + 6", "solve"),
        ("nsolve", "cos(x) - x", "nsolve"),
        ("system", "x + y = 5; x - y = 1", "solve_system"),
        ("simplify", "(x + 1)**2 - x**2", "simplify"),
        ("diff", "x**3", "differentiate"),
        ("integrate", "2*x", "integrate"),
        ("factor", "x**2 - 5*x + 6", "factor"),
        ("expand", "(x - 2)*(x - 3)", "expand"),
        ("latex", "x**2 - 5*x + 6", "simplify"),
    ],
)
def test_cli_json_output_for_each_command(
    command: str,
    expression: str,
    operation: str,
    capsys: pytest.CaptureFixture[str],
) -> None:
    exit_code = main([command, expression, "--format", "json"])

    output = capsys.readouterr().out
    data = json.loads(output)

    assert exit_code == 0
    assert data["operation"] == operation
    assert data["answers"]
    assert data["metadata"]["operation"] == operation


def test_cli_solve_equation_json(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["solve", "x**2 - 5*x + 6 = 0", "--format", "json"])

    output = capsys.readouterr().out
    data = json.loads(output)

    assert exit_code == 0
    assert data["operation"] == "solve"
    assert data["answers"] == ["2", "3"]
    assert data["verified"] is True
    assert data["metadata"]["verification"] == "solution_substitution"


def test_cli_system_json(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(
        [
            "system",
            "x + y = 5; x - y = 1",
            "--variable",
            "x,y",
            "--format",
            "json",
        ]
    )

    output = capsys.readouterr().out
    data = json.loads(output)

    assert exit_code == 0
    assert data["operation"] == "solve_system"
    assert data["answers"] == ["x = 3, y = 2"]
    assert data["verified"] is True
    assert data["metadata"]["variables"] == ["x", "y"]


def test_cli_json_keeps_warnings_in_output(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["solve", "x - x - 1", "--format", "json"])

    captured = capsys.readouterr()
    data = json.loads(captured.out)

    assert exit_code == 0
    assert data["warnings"] == [
        "Result could not be verified by the deterministic engine.",
        "No solutions were returned for the selected variable.",
    ]
    assert captured.err == ""


def test_cli_factor() -> None:
    result = run_cli(["factor", "x**2 - 5*x + 6"])

    assert result.returncode == 0
    assert "(x - 3)*(x - 2)" in result.stdout


def test_cli_factor_complex() -> None:
    result = run_cli(["factor", "x**4 - 1"])

    assert result.returncode == 0
    assert "(x - I)" in result.stdout
    assert "(x + I)" in result.stdout


@pytest.mark.parametrize(
    ("args", "expected"),
    [
        (["sum", "k**2", "--variable", "k,1,n"], "n**3/3 + n**2/2 + n/6"),
        (["product", "k", "--variable", "k,1,n"], "factorial(n)"),
        (["limit", "sin(x)/x", "--variable", "x,0,+-"], "1"),
        (["inequality", "x <= 3"], "Interval(-oo, 3)"),
        (["nsolve", "cos(x) - x", "--variable", "x,0.5"], "0.739085133215161"),
        (["det", "[[1, 2], [3, 4]]"], "-2"),
        (["order", "[[1, 2, 3], [4, 5, 6]]"], "2x3"),
        (["rank", "[[1, 2, 3], [2, 4, 6], [1, 0, 1]]"], "2"),
        (["trace", "[[1, 2], [3, 4]]"], "5"),
        (["mpow", "[[1, 1], [0, 1]]", "--variable", "3"], "Matrix([[1, 3], [0, 1]])"),
        (["transpose", "[[1, 2], [3, 4]]"], "Matrix([[1, 3], [2, 4]])"),
        (["conjugate", "[[1 + I, 2], [3, 4 - I]]"], "Matrix([[1 - I, 2], [3, 4 + I]])"),
        (["adjoint", "[[1 + I, 2], [3, 4 - I]]"], "Matrix([[1 - I, 3], [2, 4 + I]])"),
        (["msolve", "[[2, 1], [1, -1]]; [[5], [1]]"], "Matrix([[2], [1]])"),
        (["nullspace", "[[1, 2, 3], [2, 4, 6]]"], "Matrix([[-2], [1], [0]])"),
        (["columnspace", "[[1, 2, 3], [2, 4, 6]]"], "Matrix([[1], [2]])"),
        (["rowspace", "[[1, 2, 3], [2, 4, 6]]"], "Matrix([[1, 2, 3]])"),
        (["eigenvals", "[[2, 0], [0, 3]]"], "2 (multiplicity 1)"),
        (["eigenvectors", "[[2, 0], [0, 3]]"], "lambda = 2"),
        (["diagonalize", "[[2, 0], [0, 3]]"], "D = Matrix([[2, 0], [0, 3]])"),
        (["lu", "[[2, 1], [4, 3]]"], "L = Matrix([[1, 0], [2, 1]])"),
        (["qr", "[[1, 0], [1, 1]]"], "Q = Matrix("),
        (["cholesky", "[[4, 2], [2, 3]]"], "L = Matrix([[2, 0], [1, sqrt(2)]])"),
    ],
)
def test_cli_sympy_relative_operations(args: list[str], expected: str) -> None:
    result = run_cli(args)

    assert result.returncode == 0
    assert expected in result.stdout


def test_cli_matrix_inverse() -> None:
    result = run_cli(["inverse", "[[1, 2], [3, 4]]"])

    assert result.returncode == 0
    assert "Matrix([[-2, 1], [3/2, -1/2]])" in result.stdout


def test_cli_matrix_rref() -> None:
    result = run_cli(["rref", "[[1, 2], [3, 4]]"])

    assert result.returncode == 0
    assert "Matrix([[1, 0], [0, 1]])" in result.stdout


@pytest.mark.parametrize(
    ("command", "expression", "expected"),
    [
        ("solve", "x**2 - 5*x + 6", "2"),
        ("nsolve", "cos(x) - x", "0.739085133215161"),
        ("system", "x + y = 5; x - y = 1", "x = 3, y = 2"),
        ("simplify", "(x + 1)**2 - x**2", "2*x + 1"),
        ("diff", "x**3", "3*x**2"),
        ("integrate", "2*x", "x**2"),
        ("factor", "x**2 - 5*x + 6", "(x - 3)*(x - 2)"),
        ("expand", "(x - 2)*(x - 3)", "x**2 - 5*x + 6"),
    ],
)
def test_cli_text_output_for_each_command(
    command: str,
    expression: str,
    expected: str,
) -> None:
    result = run_cli([command, expression])

    assert result.returncode == 0
    assert expected in result.stdout


def test_cli_latex_output(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["diff", "x**3", "--format", "latex"])

    captured = capsys.readouterr()

    assert exit_code == 0
    assert "3 x^{2}" in captured.out
    assert captured.err == ""


def test_cli_latex_alias() -> None:
    result = run_cli(["latex", "x**2 - 5*x + 6"])

    assert result.returncode == 0
    assert "x^{2}" in result.stdout
    assert result.stderr == ""


def test_cli_explain_text() -> None:
    result = run_cli(["explain", "x**2 - 5*x + 6 = 0", "--operation", "solve"])

    assert result.returncode == 0
    assert "Normalize the solve target" in result.stdout
    assert "Verify returned solutions" in result.stdout


def test_cli_explain_json(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["explain", "(x + 1)**2 - x**2", "--format", "json"])

    output = capsys.readouterr().out
    data = json.loads(output)

    assert exit_code == 0
    assert data["operation"] == "simplify"
    assert data["steps"][0]["kind"] == "simplify"


def test_cli_explain_latex() -> None:
    result = run_cli(["explain", "x**3", "--operation", "diff", "--format", "latex"])

    assert result.returncode == 0
    assert "\\begin{aligned}" in result.stdout
    assert "3 x^{2}" in result.stdout


def test_cli_explain_factor() -> None:
    result = run_cli(["explain", "x**2 - 5*x + 6", "--operation", "factor"])

    assert result.returncode == 0
    assert "Factor the expression" in result.stdout
    assert "sympy_factor_complex" in result.stdout


def test_cli_expand() -> None:
    result = run_cli(["expand", "(x - 2)*(x - 3)"])

    assert result.returncode == 0
    assert "x**2 - 5*x + 6" in result.stdout


def test_cli_rejects_invalid_variable() -> None:
    result = run_cli(["solve", "x**2 - 1", "--variable", "class"])

    assert result.returncode == 1
    assert "Invalid variable name" in result.stderr


def test_cli_rejects_non_solve_equation_input() -> None:
    result = run_cli(["simplify", "x + 1 = 2"])

    assert result.returncode == 1
    assert "Could not parse expression" in result.stderr


def test_cli_usage_errors_return_two() -> None:
    result = run_cli(["unknown"])

    assert result.returncode == 2
    assert "invalid choice" in result.stderr


def test_cli_prints_text_warnings_to_stderr() -> None:
    result = run_cli(["solve", "x - x - 1"])

    assert result.returncode == 0
    assert result.stdout == "No answers returned.\n"
    assert "warning: Result could not be verified" in result.stderr
    assert "warning: No solutions were returned" in result.stderr


def test_cli_quiet_suppresses_text_warnings() -> None:
    result = run_cli(["--quiet", "solve", "x - x - 1"])

    assert result.returncode == 0
    assert result.stdout == "No answers returned.\n"
    assert result.stderr == ""


def test_cli_does_not_write_history_by_default(
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    history_file = tmp_path / "history.jsonl"

    exit_code = main(
        [
            "--history-file",
            str(history_file),
            "solve",
            "x**2 - 5*x + 6",
        ]
    )

    capsys.readouterr()

    assert exit_code == 0
    assert not history_file.exists()


def test_cli_writes_opt_in_history(
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    history_file = tmp_path / "history.jsonl"

    exit_code = main(
        [
            "--history",
            "--history-file",
            str(history_file),
            "solve",
            "x**2 - 5*x + 6",
        ]
    )

    capsys.readouterr()
    history = [json.loads(line) for line in history_file.read_text(encoding="utf-8").splitlines()]

    assert exit_code == 0
    assert len(history) == 1
    assert history[0]["operation"] == "solve"
    assert history[0]["answers"] == ["2", "3"]


def test_cli_does_not_write_history_for_failed_request(tmp_path: Path) -> None:
    history_file = tmp_path / "history.jsonl"

    with pytest.raises(SystemExit) as exc:
        main(
            [
                "--history",
                "--history-file",
                str(history_file),
                "solve",
                "x**2 - 1",
                "--variable",
                "class",
            ]
        )

    assert exc.value.code == 1
    assert not history_file.exists()


def test_cli_config_show_json(tmp_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    config_file = tmp_path / "config.json"
    config_file.write_text(json.dumps({"quiet": True}), encoding="utf-8")

    exit_code = main(["--config", str(config_file), "config", "show", "--format", "json"])

    output = capsys.readouterr().out
    data = json.loads(output)

    assert exit_code == 0
    assert data["provider"] == "none"
    assert data["quiet"] is True


def test_cli_config_path(tmp_path: Path, capsys: pytest.CaptureFixture[str]) -> None:
    config_file = tmp_path / "config.json"

    exit_code = main(["--config", str(config_file), "config", "path"])

    output = capsys.readouterr().out

    assert exit_code == 0
    assert str(config_file) in output


def test_cli_uses_history_from_config(
    tmp_path: Path,
    capsys: pytest.CaptureFixture[str],
) -> None:
    history_file = tmp_path / "history.jsonl"
    config_file = tmp_path / "config.json"
    config_file.write_text(
        json.dumps(
            {
                "history": True,
                "history_file": str(history_file),
            }
        ),
        encoding="utf-8",
    )

    exit_code = main(["--config", str(config_file), "solve", "x**2 - 5*x + 6"])

    capsys.readouterr()
    history = [json.loads(line) for line in history_file.read_text(encoding="utf-8").splitlines()]

    assert exit_code == 0
    assert history[0]["operation"] == "solve"
