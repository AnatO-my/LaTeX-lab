import shutil
import subprocess
import sys
from pathlib import Path

import pytest
from examples.latex.generate_sample_results import render_sample_results

from otcalc.cli import main
from otcalc.latex_build import LatexBuildError, find_latex_requests, generate_latex_include


def test_cli_latex_golden_derivative(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["diff", "x**3", "--format", "latex"])

    output = capsys.readouterr().out.strip()

    assert exit_code == 0
    assert output == "3 x^{2}"


def test_cli_latex_alias_golden(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["latex", "x**2 - 5*x + 6"])

    output = capsys.readouterr().out.strip()

    assert exit_code == 0
    assert output == "x^{2} - 5 x + 6"


def test_cli_explain_latex_golden_contains_aligned_block(
    capsys: pytest.CaptureFixture[str],
) -> None:
    exit_code = main(["explain", "x**3", "--operation", "diff", "--format", "latex"])

    output = capsys.readouterr().out

    assert exit_code == 0
    assert "\\begin{aligned}" in output
    assert "\\end{aligned}" in output
    assert "3 x^{2}" in output


def test_latex_package_defines_rendering_helpers() -> None:
    package = Path("integrations/latex/otmath.sty").read_text(encoding="utf-8")

    assert "\\newcommand{\\OTMathInline}" in package
    assert "\\newcommand{\\OTMathResult}" in package
    assert "\\newcommand{\\OTMathEquation}" in package
    assert "\\newenvironment{OTMathSteps}" in package
    assert "\\newcommand{\\OTMathCompute}" in package
    assert "\\newcommand{\\OTMathExplain}" in package
    assert "\\newcommand{\\OTMathUse}" in package


def test_latex_request_scanner_finds_compute_and_explain_macros() -> None:
    source = (
        r"\OTMathCompute{quad}{simplify}{x**2 - 5*x + 6}"
        "\n"
        r"\OTMathCompute[variable=x,y]{sys}{system}{x + y = 5; x - y = 1}"
        "\n"
        r"\OTMathExplain[operation=solve]{steps}{x**2 - 5*x + 6 = 0}"
    )

    requests = find_latex_requests(source)

    assert [request.request_id for request in requests] == ["quad", "sys", "steps"]
    assert [request.kind for request in requests] == ["compute", "compute", "explain"]
    assert requests[1].variable == "x,y"


def test_latex_request_scanner_rejects_duplicate_ids() -> None:
    source = (
        r"\OTMathCompute{same}{simplify}{x + 1}"
        "\n"
        r"\OTMathCompute{same}{factor}{x**2 - 1}"
    )

    with pytest.raises(LatexBuildError, match="Duplicate OT Math request ids"):
        find_latex_requests(source)


def test_latex_request_scanner_rejects_unsupported_operations() -> None:
    source = r"\OTMathCompute{bad}{matrix}{[1, 2]}"

    with pytest.raises(LatexBuildError, match="Unsupported OT Math operation"):
        find_latex_requests(source)


def test_sample_latex_uses_otmath_package() -> None:
    sample = Path("examples/latex/sample.tex").read_text(encoding="utf-8")

    assert "\\input{../../integrations/latex/otmath.sty}" in sample
    assert "\\input{generated/otmath-results.tex}" in sample
    assert "\\OTMathCompute{sample-quadratic}" in sample
    assert "\\OTMathCompute[variable=x,y]{sample-system}" in sample
    assert "\\OTMathExplain[operation=solve]{sample-solve-steps}" in sample


def test_sample_latex_generated_results_are_deterministic() -> None:
    generated = render_sample_results()

    assert r"\csname OTMathGenerated@sample-quadratic\endcsname{%" in generated
    assert "x^{2} - 5 x + 6" in generated
    assert r"\csname OTMathGenerated@sample-system\endcsname{%" in generated
    assert r"\left\{ x = 3, y = 2 \right\}" in generated
    assert "\\text{Verify returned solutions}" in generated


def test_sample_latex_generation_script_writes_include() -> None:
    script = Path("examples/latex/generate_sample_results.py")
    result = subprocess.run(
        [sys.executable, str(script)],
        text=True,
        capture_output=True,
        check=False,
    )

    generated = Path("examples/latex/generated/otmath-results.tex")

    assert result.returncode == 0, result.stdout + result.stderr
    assert generated.exists()
    assert "OTMathGenerated@sample-system" in generated.read_text(encoding="utf-8")


def test_latex_build_command_generates_include(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute{quad}{simplify}{x**2 - 5*x + 6}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)

    assert result.request_count == 1
    assert result.generated_file == output_file
    assert "x^{2} - 5 x + 6" in output_file.read_text(encoding="utf-8")


def test_latex_build_rejects_documents_without_requests(tmp_path: Path) -> None:
    tex_file = tmp_path / "empty.tex"
    tex_file.write_text(r"\documentclass{article}", encoding="utf-8")

    with pytest.raises(LatexBuildError, match="No OT Math generation requests"):
        generate_latex_include(tex_file)


def test_cli_latex_build(capsys: pytest.CaptureFixture[str]) -> None:
    exit_code = main(["latex-build", "examples/latex/sample.tex"])

    output = capsys.readouterr().out

    assert exit_code == 0
    assert "generated:" in output
    assert "requests: 3" in output


def test_sample_latex_compiles_when_pdflatex_is_available(tmp_path: Path) -> None:
    pdflatex = shutil.which("pdflatex")
    if pdflatex is None:
        pytest.skip("pdflatex is not installed")

    sample = Path("examples/latex/sample.tex").resolve()
    subprocess.run(
        [sys.executable, "-m", "otcalc.cli", "latex-build", sample.name],
        cwd=sample.parent,
        text=True,
        capture_output=True,
        check=True,
    )
    result = subprocess.run(
        [
            pdflatex,
            "-interaction=nonstopmode",
            "-halt-on-error",
            f"-output-directory={tmp_path}",
            sample.name,
        ],
        cwd=sample.parent,
        text=True,
        capture_output=True,
        check=False,
    )

    assert result.returncode == 0, result.stdout + result.stderr
