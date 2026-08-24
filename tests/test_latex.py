import shutil
import subprocess
import sys
from pathlib import Path

import pytest
from examples.latex.generate_sample_results import render_sample_results
from examples.latex.generate_stress_results import render_stress_results

from otcalc.cli import main
from otcalc.latex_build import (
    LatexBuildError,
    detect_generated_include_path,
    find_latex_requests,
    generate_latex_include,
)


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

    assert "\\RequirePackage{amssymb}" in package
    assert "\\newcommand{\\OTMathInline}" in package
    assert "\\newcommand{\\OTMathResult}" in package
    assert "\\newcommand{\\OTMathEquation}" in package
    assert "\\newenvironment{OTMathSteps}" in package
    assert "\\newcommand{\\OTMathCompute}" in package
    assert "\\newcommand{\\OTMathExplain}" in package
    assert "\\newcommand{\\OTMathUse}" in package
    assert "\\newcommand{\\OTMathGeneratedInput}" in package


def test_latex_request_scanner_finds_compute_and_explain_macros() -> None:
    source = (
        r"\OTMathCompute[input=latex]{quad}{simplify}{x^{2} - 5x + 6}"
        "\n"
        r"\OTMathCompute[variable=x,y]{sys}{system}{x + y = 5; x - y = 1}"
        "\n"
        r"\OTMathExplain[operation=solve]{steps}{x**2 - 5*x + 6 = 0}"
    )

    requests = find_latex_requests(source)

    assert [request.request_id for request in requests] == ["quad", "sys", "steps"]
    assert [request.kind for request in requests] == ["compute", "compute", "explain"]
    assert requests[0].expression == "x^{2} - 5x + 6"
    assert requests[0].input_format == "latex"
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
    assert "\\OTMathGeneratedInput{generated/otmath-results.tex}" in sample
    assert "\\OTMathCompute[input=latex]{sample-quadratic}" in sample
    assert "\\OTMathCompute[input=latex; variable=x,y]{sample-system}" in sample
    assert "\\OTMathExplain[input=latex; operation=solve]{sample-solve-steps}" in sample


def test_latex_build_detects_declared_generated_include_path() -> None:
    stress = Path("examples/latex/stress.tex")
    source = stress.read_text(encoding="utf-8")

    assert detect_generated_include_path(stress, source) == (
        stress.parent / "generated" / "otmath-stress-results.tex"
    )


def test_latex_build_uses_declared_generated_include_by_default(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    tex_file.write_text(
        r"\input{../../integrations/latex/otmath.sty}"
        "\n"
        r"\OTMathGeneratedInput{generated/custom-results.tex}"
        "\n"
        r"\OTMathCompute[input=latex]{quad}{simplify}{x^{2} - 5x + 6}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file)

    assert result.generated_file == tmp_path / "generated" / "custom-results.tex"
    assert result.generated_file.exists()


def test_stress_latex_document_generates_current_hard_cases(tmp_path: Path) -> None:
    stress = Path("examples/latex/stress.tex")
    output_file = tmp_path / "generated" / "otmath-stress-results.tex"

    result = generate_latex_include(stress, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 35
    assert r"\csname OTMathGenerated@stress-factor-subscript\endcsname{%" in generated
    assert r"x_{0}" in generated
    assert r"\csname OTMathGenerated@stress-factor-complex\endcsname{%" in generated
    assert "i" in generated
    assert r"\csname OTMathGenerated@stress-expand-greek\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-expand-variant-greek\endcsname{%" in generated
    assert r"\varrho^{2}" in generated
    assert r"\vartheta^{2}" in generated
    assert r"\csname OTMathGenerated@stress-expand-styled\endcsname{%" in generated
    assert r"\mathcal{A}^{2}" in generated
    assert r"\mathbb{R}^{2}" in generated
    assert r"\csname OTMathGenerated@stress-simplify-roots\endcsname{%" in generated
    assert "7" in generated
    assert r"\csname OTMathGenerated@stress-expand-plus-minus\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-solve-plus-minus\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-expand-minus-plus\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-expand-paired-signs\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-expand-independent-signs\endcsname{%" in generated
    assert r"\pm 2" in generated
    assert r"\csname OTMathGenerated@stress-solve-quadratic-formula\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-diff-arctan\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-diff-notation\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-diff-theta-notation\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-diff-second-notation\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-diff-third-notation\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-integrate-tan\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-integrate-theta\endcsname{%" in generated
    assert r"\operatorname{erf}" in generated
    assert r"\csname OTMathGenerated@stress-sum-squares\endcsname{%" in generated
    assert r"\frac{n^{3}}{3}" in generated
    assert r"\csname OTMathGenerated@stress-product-factorial\endcsname{%" in generated
    assert r"n!" in generated
    assert r"\csname OTMathGenerated@stress-limit-sine\endcsname{%" in generated
    assert r"\csname OTMathGenerated@stress-inequality\endcsname{%" in generated
    assert r"\left\{ x_{0} = 3, y_{0} = 2 \right\}" in generated
    assert "\\text{Verify returned solutions}" in generated


def test_stress_latex_generated_results_are_deterministic() -> None:
    generated = render_stress_results()

    assert r"\csname OTMathGenerated@stress-integrate-gaussian\endcsname{%" in generated
    assert r"\frac{\sqrt{\pi} \operatorname{erf}{\left(x \right)}}{2}" in generated
    assert r"\csname OTMathGenerated@stress-system-subscript\endcsname{%" in generated
    assert r"\left\{ x_{0} = 3, y_{0} = 2 \right\}" in generated


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


def test_latex_build_command_generates_include_from_latex_input(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{quad}{simplify}{x^{2} - 5x + 6}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)

    assert result.request_count == 1
    assert "x^{2} - 5 x + 6" in output_file.read_text(encoding="utf-8")


def test_latex_build_generates_include_with_latex_variable_spec(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex; variable=x_{0}]{roots}{solve}{x_{0}^{2} - 1 = 0}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 1
    assert r"\pm 1" in generated


def test_latex_build_generates_include_with_greek_variables(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{greek}{simplify}{\alpha^{2} + \alpha}",
        encoding="utf-8",
    )

    generate_latex_include(tex_file, output_file=output_file)

    generated = output_file.read_text(encoding="utf-8")

    assert r"\alpha \left(\alpha + 1\right)" in generated


def test_latex_build_restores_variant_greek_variables_in_generated_latex(
    tmp_path: Path,
) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{variant}{expand}{(\varrho + \vartheta)^{2}}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 1
    assert r"\varrho^{2}" in generated
    assert r"\vartheta^{2}" in generated


def test_latex_build_restores_styled_variables_in_generated_latex(
    tmp_path: Path,
) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{styled}{expand}{(\mathcal{A} + \mathbb{R})^{2}}"
        "\n"
        r"\OTMathCompute[input=latex; variable=\mathbf{X}]{styled-solve}{solve}"
        r"{\mathbf{X}^{2} - 1 = 0}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 2
    assert r"\mathcal{A}^{2}" in generated
    assert r"\mathbb{R}^{2}" in generated
    assert r"\pm 1" in generated


def test_latex_build_expands_plus_minus_input_branches(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{pm-expand}{expand}{(x \pm 1)^{2}}"
        "\n"
        r"\OTMathCompute[input=latex; variable=x]{pm-solve}{solve}{x = \pm 2}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 2
    assert r"\begin{gathered}" in generated
    assert r"x^{2} - 2 x + 1" in generated
    assert r"x^{2} + 2 x + 1" in generated
    assert r"\pm 2" in generated


def test_latex_build_expands_minus_plus_input_branches(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{mp-expand}{expand}{(x \mp 1)^{2}}"
        "\n"
        r"\OTMathCompute[input=latex]{paired}{expand}{a \pm b \mp c}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 2
    assert r"x^{2} - 2 x + 1" in generated
    assert r"x^{2} + 2 x + 1" in generated
    assert "a + b - c" in generated
    assert "a - b + c" in generated


def test_latex_build_expands_independent_plus_minus_input_branches(
    tmp_path: Path,
) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex]{independent}{expand}{a \pm b \pm c}",
        encoding="utf-8",
    )

    result = generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert result.request_count == 1
    assert "a + b + c" in generated
    assert "a + b - c" in generated
    assert "a - b + c" in generated
    assert "a - b - c" in generated


def test_latex_build_generates_system_with_subscript_variables(tmp_path: Path) -> None:
    tex_file = tmp_path / "scratch.tex"
    output_file = tmp_path / "generated" / "otmath-results.tex"
    tex_file.write_text(
        r"\OTMathCompute[input=latex; variable=x_{0},y_{0}]{system}{system}"
        r"{x_{0} + y_{0} = 5; x_{0} - y_{0} = 1}",
        encoding="utf-8",
    )

    generate_latex_include(tex_file, output_file=output_file)
    generated = output_file.read_text(encoding="utf-8")

    assert r"x_{0} = 3" in generated
    assert r"y_{0} = 2" in generated


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


def test_latex_document_compiles_with_missing_generated_include(
    tmp_path: Path,
) -> None:
    pdflatex = shutil.which("pdflatex")
    if pdflatex is None:
        pytest.skip("pdflatex is not installed")

    package = Path("integrations/latex/otmath.sty").resolve().as_posix()
    tex_file = tmp_path / "missing-generated.tex"
    tex_file.write_text(
        "\n".join(
            [
                r"\documentclass{article}",
                r"\usepackage{amsmath}",
                rf"\input{{{package}}}",
                r"\OTMathGeneratedInput{generated/missing-results.tex}",
                r"\begin{document}",
                r"\OTMathCompute[input=latex]{missing}{simplify}{x^{2} - 1}",
                r"\end{document}",
            ]
        ),
        encoding="utf-8",
    )

    result = subprocess.run(
        [
            pdflatex,
            "-interaction=nonstopmode",
            "-halt-on-error",
            f"-output-directory={tmp_path}",
            tex_file.name,
        ],
        cwd=tex_file.parent,
        text=True,
        capture_output=True,
        check=False,
    )

    assert result.returncode == 0, result.stdout + result.stderr
