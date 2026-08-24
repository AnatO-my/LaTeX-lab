"""Safe LaTeX pre-generation workflow for OT Math requests."""

from __future__ import annotations

import re
import shutil
import subprocess
from collections.abc import Sequence
from dataclasses import dataclass, replace
from pathlib import Path

from otmath import MathOperation, MathRequest, MathResult, render_steps_latex, run_request
from otmath.errors import OTMathError
from otmath.latex_input import (
    latex_derivative_to_engine_parts,
    latex_integral_to_engine_parts,
    latex_limit_to_engine_parts,
    latex_matrix_to_engine_expression,
    latex_plus_minus_branches,
    latex_product_to_engine_parts,
    latex_sum_to_engine_parts,
    latex_to_engine_expression_branches,
    latex_to_engine_symbol_spec,
)
from otmath.latex_render import render_compact_plus_minus
from otmath.parser import parse_expression

_REQUEST_ID_PATTERN = re.compile(r"^[A-Za-z][A-Za-z0-9_-]*$")
_GENERATED_INCLUDE_PATTERN = re.compile(
    r"\\(?:input|include|OTMathGeneratedInput)\s*\{([^{}]+)\}"
)
_OPERATION_ALIASES = {
    "diff": MathOperation.DIFFERENTIATE,
    "differentiate": MathOperation.DIFFERENTIATE,
    "system": MathOperation.SOLVE_SYSTEM,
    "solve_system": MathOperation.SOLVE_SYSTEM,
    "summation": MathOperation.SUMMATION,
    "prod": MathOperation.PRODUCT,
    "inequality": MathOperation.INEQUALITY,
    "ineq": MathOperation.INEQUALITY,
    "det": MathOperation.MATRIX_DETERMINANT,
    "matrix_det": MathOperation.MATRIX_DETERMINANT,
    "order": MathOperation.MATRIX_ORDER,
    "shape": MathOperation.MATRIX_ORDER,
    "matrix_order": MathOperation.MATRIX_ORDER,
    "rank": MathOperation.MATRIX_RANK,
    "matrix_rank": MathOperation.MATRIX_RANK,
    "trace": MathOperation.MATRIX_TRACE,
    "matrix_trace": MathOperation.MATRIX_TRACE,
    "inverse": MathOperation.MATRIX_INVERSE,
    "matrix_inverse": MathOperation.MATRIX_INVERSE,
    "mpow": MathOperation.MATRIX_POWER,
    "matrix_power": MathOperation.MATRIX_POWER,
    "transpose": MathOperation.MATRIX_TRANSPOSE,
    "matrix_transpose": MathOperation.MATRIX_TRANSPOSE,
    "conjugate": MathOperation.MATRIX_CONJUGATE,
    "matrix_conjugate": MathOperation.MATRIX_CONJUGATE,
    "adjoint": MathOperation.MATRIX_ADJOINT,
    "matrix_adjoint": MathOperation.MATRIX_ADJOINT,
    "rref": MathOperation.MATRIX_RREF,
    "matrix_rref": MathOperation.MATRIX_RREF,
    "eigenvals": MathOperation.MATRIX_EIGENVALUES,
    "eigenvalues": MathOperation.MATRIX_EIGENVALUES,
    "matrix_eigenvals": MathOperation.MATRIX_EIGENVALUES,
    "diagonalize": MathOperation.MATRIX_DIAGONALIZE,
    "diagonalise": MathOperation.MATRIX_DIAGONALIZE,
    "matrix_diagonalize": MathOperation.MATRIX_DIAGONALIZE,
}


class LatexBuildError(OTMathError):
    """Raised when a LaTeX generation request cannot be completed."""


@dataclass(frozen=True)
class LatexRequest:
    """A math request discovered inside a LaTeX document."""

    request_id: str
    expression: str
    operation: MathOperation
    variable: str
    kind: str
    input_format: str = "engine"


@dataclass(frozen=True)
class LatexBuildResult:
    """Files produced by the safe LaTeX generation workflow."""

    generated_file: Path
    request_count: int
    compiled_pdf: Path | None = None


def find_latex_requests(source: str) -> list[LatexRequest]:
    """Find OT Math generation macros in a LaTeX source string."""

    matches: list[tuple[int, LatexRequest]] = []

    for invocation in _find_macro_invocations(source, "OTMathCompute", argument_count=3):
        options = _parse_options(invocation.options)
        operation = _parse_operation(invocation.arguments[1])
        variable = options.get("variable", _default_variable(operation))
        matches.append(
            (
                invocation.start,
                LatexRequest(
                    request_id=_validate_request_id(invocation.arguments[0]),
                    expression=invocation.arguments[2].strip(),
                    operation=operation,
                    variable=variable,
                    kind="compute",
                    input_format=_parse_input_format(options.get("input", "engine")),
                ),
            )
        )

    for invocation in _find_macro_invocations(source, "OTMathExplain", argument_count=2):
        options = _parse_options(invocation.options)
        operation = _parse_operation(options.get("operation", "simplify"))
        variable = options.get("variable", _default_variable(operation))
        matches.append(
            (
                invocation.start,
                LatexRequest(
                    request_id=_validate_request_id(invocation.arguments[0]),
                    expression=invocation.arguments[1].strip(),
                    operation=operation,
                    variable=variable,
                    kind="explain",
                    input_format=_parse_input_format(options.get("input", "engine")),
                ),
            )
        )

    requests = [request for _, request in sorted(matches, key=lambda item: item[0])]
    _reject_duplicate_ids(requests)
    return requests


def generate_latex_include(
    tex_file: Path,
    *,
    output_file: Path | None = None,
) -> LatexBuildResult:
    """Generate a LaTeX include file from OT Math requests in a document."""

    source = tex_file.read_text(encoding="utf-8")
    requests = find_latex_requests(source)
    if not requests:
        raise LatexBuildError(f"No OT Math generation requests found in {tex_file}.")

    generated_file = (
        output_file
        or detect_generated_include_path(tex_file, source)
        or tex_file.parent / "generated" / "otmath-results.tex"
    )
    generated_file.parent.mkdir(parents=True, exist_ok=True)
    generated_file.write_text(render_latex_include(requests), encoding="utf-8")
    return LatexBuildResult(generated_file=generated_file, request_count=len(requests))


def detect_generated_include_path(tex_file: Path, source: str) -> Path | None:
    """Return a declared generated include path from a LaTeX source, when present."""

    for match in _GENERATED_INCLUDE_PATTERN.finditer(source):
        include_path = match.group(1).strip()
        normalized = include_path.replace("\\", "/")
        if "generated/" not in normalized or not normalized.endswith(".tex"):
            continue

        path = Path(include_path)
        if path.is_absolute():
            return path
        return tex_file.parent / path

    return None


def render_latex_include(requests: Sequence[LatexRequest]) -> str:
    """Render a generated include file for discovered LaTeX requests."""

    lines = [
        "% Generated by otcalc latex-build.",
        "% Do not edit by hand; edit the OT Math requests in the source .tex file.",
    ]
    for request in requests:
        lines.extend(_render_definition(request))
    lines.append("")
    return "\n".join(lines)


def build_latex_document(
    tex_file: Path,
    *,
    output_file: Path | None = None,
    compile_pdf: bool = False,
    engine: str = "pdflatex",
) -> LatexBuildResult:
    """Generate the include file and optionally compile the LaTeX document."""

    result = generate_latex_include(tex_file, output_file=output_file)
    if not compile_pdf:
        return result

    compiled_pdf = compile_latex_document(tex_file, engine=engine)
    return LatexBuildResult(
        generated_file=result.generated_file,
        request_count=result.request_count,
        compiled_pdf=compiled_pdf,
    )


def compile_latex_document(tex_file: Path, *, engine: str = "pdflatex") -> Path:
    """Compile a LaTeX document with a local TeX engine."""

    executable = shutil.which(engine)
    if executable is None:
        raise LatexBuildError(f"LaTeX engine not found on PATH: {engine}")

    result = subprocess.run(
        [
            executable,
            "-interaction=nonstopmode",
            "-halt-on-error",
            tex_file.name,
        ],
        cwd=tex_file.parent,
        text=True,
        capture_output=True,
        check=False,
    )
    if result.returncode != 0:
        raise LatexBuildError(result.stdout + result.stderr)

    return tex_file.with_suffix(".pdf")


def _render_definition(request: LatexRequest) -> list[str]:
    content = _render_request_content(request)
    return [
        rf"\expandafter\gdef\csname OTMathGenerated@{request.request_id}\endcsname{{%",
        content,
        "}",
    ]


def _render_request_content(request: LatexRequest) -> str:
    results = [
        run_request(
            MathRequest(
                operation=request.operation,
                expression=expression,
                variable=variable,
            )
        )
        for expression, variable in _normalize_latex_request_branches(request)
    ]
    if request.kind == "explain":
        rendered_steps = [render_steps_latex(result.steps) for result in results]
        return "\n".join([r"\[", _render_branch_latex(rendered_steps), r"\]"])

    compact = _render_compact_branch_answers(results)
    if compact is not None:
        return compact
    return _render_branch_latex([result.latex for result in results])


def _normalize_latex_request_branches(request: LatexRequest) -> list[tuple[str, str]]:
    if request.input_format != "latex":
        return [(request.expression, request.variable)]
    return [
        _normalize_latex_request_parts(replace(request, expression=expression))
        for expression in latex_plus_minus_branches(request.expression)
    ]


def _normalize_latex_request_parts(request: LatexRequest) -> tuple[str, str]:
    if request.input_format != "latex":
        return request.expression, request.variable
    stripped_expression = request.expression.strip()
    if request.operation == MathOperation.SUMMATION and stripped_expression.startswith(r"\sum"):
        return latex_sum_to_engine_parts(request.expression)
    if request.operation == MathOperation.PRODUCT and stripped_expression.startswith(r"\prod"):
        return latex_product_to_engine_parts(request.expression)
    if request.operation == MathOperation.LIMIT and stripped_expression.startswith(r"\lim"):
        return latex_limit_to_engine_parts(request.expression)
    if request.operation == MathOperation.DIFFERENTIATE:
        return latex_derivative_to_engine_parts(request.expression, request.variable)
    if request.operation == MathOperation.INTEGRATE:
        return latex_integral_to_engine_parts(request.expression, request.variable)
    if request.operation in _MATRIX_OPERATIONS:
        return latex_matrix_to_engine_expression(request.expression), request.variable
    expressions = latex_to_engine_expression_branches(request.expression)
    if len(expressions) != 1:
        raise LatexBuildError(r"Internal error: plus-minus branches were not expanded.")
    return (expressions[0], latex_to_engine_symbol_spec(request.variable))


def _render_compact_branch_answers(results: Sequence[MathResult]) -> str | None:
    if len(results) != 2:
        return None

    answers: list[object] = []
    for result in results:
        if len(result.answers) != 1:
            return None
        try:
            answers.append(parse_expression(result.answers[0]))
        except OTMathError:
            return None
    return render_compact_plus_minus(answers)


def _render_branch_latex(items: Sequence[str]) -> str:
    if len(items) == 1:
        return items[0]
    return "\\begin{gathered}\n" + " \\\\\n".join(items) + "\n\\end{gathered}"


def _parse_options(options: str) -> dict[str, str]:
    parsed: dict[str, str] = {}
    for raw_item in options.split(";"):
        item = raw_item.strip()
        if not item:
            continue
        if "=" not in item:
            raise LatexBuildError(f"Invalid OT Math option: {item}")
        key, value = (part.strip() for part in item.split("=", maxsplit=1))
        if not key or not value:
            raise LatexBuildError(f"Invalid OT Math option: {item}")
        parsed[key] = value
    return parsed


@dataclass(frozen=True)
class _MacroInvocation:
    start: int
    options: str
    arguments: tuple[str, ...]


def _find_macro_invocations(
    source: str,
    macro_name: str,
    *,
    argument_count: int,
) -> list[_MacroInvocation]:
    invocations: list[_MacroInvocation] = []
    needle = f"\\{macro_name}"
    search_from = 0
    while True:
        start = source.find(needle, search_from)
        if start == -1:
            return invocations

        index = _skip_spaces(source, start + len(needle))
        options, index = _read_optional_options(source, index)
        arguments: list[str] = []
        for _ in range(argument_count):
            argument, index = _read_latex_group(source, index, macro_name)
            arguments.append(argument)

        invocations.append(
            _MacroInvocation(
                start=start,
                options=options,
                arguments=tuple(arguments),
            )
        )
        search_from = index


def _read_optional_options(source: str, start: int) -> tuple[str, int]:
    index = _skip_spaces(source, start)
    if index >= len(source) or source[index] != "[":
        return "", index

    end = source.find("]", index + 1)
    if end == -1:
        raise LatexBuildError("Unclosed OT Math option block.")
    return source[index + 1 : end], end + 1


def _read_latex_group(source: str, start: int, macro_name: str) -> tuple[str, int]:
    index = _skip_spaces(source, start)
    if index >= len(source) or source[index] != "{":
        raise LatexBuildError(f"Expected braced argument for \\{macro_name}.")

    depth = 0
    for position in range(index, len(source)):
        char = source[position]
        if char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return source[index + 1 : position], position + 1

    raise LatexBuildError(f"Unclosed braced argument for \\{macro_name}.")


def _skip_spaces(source: str, start: int) -> int:
    index = start
    while index < len(source) and source[index].isspace():
        index += 1
    return index


def _parse_operation(operation: str) -> MathOperation:
    normalized = operation.strip()
    if normalized in _OPERATION_ALIASES:
        return _OPERATION_ALIASES[normalized]
    try:
        return MathOperation(normalized)
    except ValueError as exc:
        raise LatexBuildError(f"Unsupported OT Math operation in LaTeX: {operation}") from exc


def _parse_input_format(input_format: str) -> str:
    normalized = input_format.strip()
    if normalized not in {"engine", "latex"}:
        raise LatexBuildError(f"Unsupported OT Math input format: {input_format}")
    return normalized


_MATRIX_OPERATIONS = {
    MathOperation.MATRIX_DETERMINANT,
    MathOperation.MATRIX_ORDER,
    MathOperation.MATRIX_RANK,
    MathOperation.MATRIX_TRACE,
    MathOperation.MATRIX_INVERSE,
    MathOperation.MATRIX_POWER,
    MathOperation.MATRIX_TRANSPOSE,
    MathOperation.MATRIX_CONJUGATE,
    MathOperation.MATRIX_ADJOINT,
    MathOperation.MATRIX_RREF,
    MathOperation.MATRIX_EIGENVALUES,
    MathOperation.MATRIX_DIAGONALIZE,
}


def _default_variable(operation: MathOperation) -> str:
    if operation == MathOperation.SOLVE_SYSTEM:
        return "x,y"
    if operation in {MathOperation.SUMMATION, MathOperation.PRODUCT}:
        return "k,1,n"
    if operation == MathOperation.LIMIT:
        return "x,0,+-"
    if operation == MathOperation.MATRIX_POWER:
        return "2"
    return "x"


def _validate_request_id(request_id: str) -> str:
    stripped = request_id.strip()
    if not _REQUEST_ID_PATTERN.fullmatch(stripped):
        raise LatexBuildError(f"Invalid OT Math request id: {request_id}")
    return stripped


def _reject_duplicate_ids(requests: Sequence[LatexRequest]) -> None:
    seen: set[str] = set()
    duplicates = set()
    for request in requests:
        if request.request_id in seen:
            duplicates.add(request.request_id)
        seen.add(request.request_id)
    if duplicates:
        names = ", ".join(sorted(duplicates))
        raise LatexBuildError(f"Duplicate OT Math request ids: {names}")
