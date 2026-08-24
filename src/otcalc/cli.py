"""Starter command-line interface for OT Math."""

from __future__ import annotations

import argparse
import json
import sys
from collections.abc import Sequence
from importlib.metadata import PackageNotFoundError, version
from pathlib import Path

from otcalc.config import ConfigError, config_path_message, load_config
from otcalc.latex_build import LatexBuildError, build_latex_document
from otmath import (
    MathOperation,
    MathRequest,
    render_steps_latex,
    render_steps_text,
    run_request,
)
from otmath.errors import OTMathError
from otmath.models import MathResult

_COMMAND_OPERATIONS = {
    "solve": MathOperation.SOLVE,
    "system": MathOperation.SOLVE_SYSTEM,
    "simplify": MathOperation.SIMPLIFY,
    "diff": MathOperation.DIFFERENTIATE,
    "integrate": MathOperation.INTEGRATE,
    "factor": MathOperation.FACTOR,
    "expand": MathOperation.EXPAND,
    "sum": MathOperation.SUMMATION,
    "product": MathOperation.PRODUCT,
    "limit": MathOperation.LIMIT,
    "inequality": MathOperation.INEQUALITY,
    "det": MathOperation.MATRIX_DETERMINANT,
    "order": MathOperation.MATRIX_ORDER,
    "rank": MathOperation.MATRIX_RANK,
    "trace": MathOperation.MATRIX_TRACE,
    "inverse": MathOperation.MATRIX_INVERSE,
    "mpow": MathOperation.MATRIX_POWER,
    "transpose": MathOperation.MATRIX_TRANSPOSE,
    "conjugate": MathOperation.MATRIX_CONJUGATE,
    "adjoint": MathOperation.MATRIX_ADJOINT,
    "rref": MathOperation.MATRIX_RREF,
    "msolve": MathOperation.MATRIX_SOLVE,
    "nullspace": MathOperation.MATRIX_NULLSPACE,
    "columnspace": MathOperation.MATRIX_COLUMNSPACE,
    "rowspace": MathOperation.MATRIX_ROWSPACE,
    "eigenvals": MathOperation.MATRIX_EIGENVALUES,
    "eigenvectors": MathOperation.MATRIX_EIGENVECTORS,
    "diagonalize": MathOperation.MATRIX_DIAGONALIZE,
    "lu": MathOperation.MATRIX_LU,
    "qr": MathOperation.MATRIX_QR,
    "cholesky": MathOperation.MATRIX_CHOLESKY,
    "latex": MathOperation.SIMPLIFY,
}
_COMMAND_HELP = {
    "solve": "Solve an expression equal to zero or a single equation.",
    "system": "Solve a semicolon-separated system of equations.",
    "simplify": "Simplify a symbolic expression.",
    "diff": "Differentiate an expression.",
    "integrate": "Integrate an expression.",
    "factor": "Factor a symbolic expression.",
    "expand": "Expand a symbolic expression.",
    "sum": "Evaluate a symbolic summation.",
    "product": "Evaluate a symbolic product.",
    "limit": "Evaluate a symbolic limit.",
    "inequality": "Solve a single-variable inequality.",
    "det": "Compute a matrix determinant.",
    "order": "Return a matrix order as rows by columns.",
    "rank": "Compute a matrix rank.",
    "trace": "Compute a matrix trace.",
    "inverse": "Compute a matrix inverse.",
    "mpow": "Raise a matrix to an integer power.",
    "transpose": "Compute a matrix transpose.",
    "conjugate": "Compute an elementwise complex matrix conjugate.",
    "adjoint": "Compute a matrix adjoint, also called conjugate transpose.",
    "rref": "Compute a matrix reduced row echelon form.",
    "msolve": "Solve A*x = b from an A; b matrix pair.",
    "nullspace": "Compute a matrix null-space basis.",
    "columnspace": "Compute a matrix column-space basis.",
    "rowspace": "Compute a matrix row-space basis.",
    "eigenvals": "Compute matrix eigenvalues with multiplicities.",
    "eigenvectors": "Compute matrix eigenvectors.",
    "diagonalize": "Compute a matrix diagonalization when possible.",
    "lu": "Compute a matrix LU decomposition.",
    "qr": "Compute a matrix QR decomposition.",
    "cholesky": "Compute a matrix Cholesky decomposition.",
    "latex": "Render an expression as LaTeX.",
}
_EXPLAIN_OPERATIONS = {
    "solve": MathOperation.SOLVE,
    "system": MathOperation.SOLVE_SYSTEM,
    "simplify": MathOperation.SIMPLIFY,
    "diff": MathOperation.DIFFERENTIATE,
    "integrate": MathOperation.INTEGRATE,
    "factor": MathOperation.FACTOR,
    "expand": MathOperation.EXPAND,
    "sum": MathOperation.SUMMATION,
    "product": MathOperation.PRODUCT,
    "limit": MathOperation.LIMIT,
    "inequality": MathOperation.INEQUALITY,
    "det": MathOperation.MATRIX_DETERMINANT,
    "order": MathOperation.MATRIX_ORDER,
    "rank": MathOperation.MATRIX_RANK,
    "trace": MathOperation.MATRIX_TRACE,
    "inverse": MathOperation.MATRIX_INVERSE,
    "mpow": MathOperation.MATRIX_POWER,
    "transpose": MathOperation.MATRIX_TRANSPOSE,
    "conjugate": MathOperation.MATRIX_CONJUGATE,
    "adjoint": MathOperation.MATRIX_ADJOINT,
    "rref": MathOperation.MATRIX_RREF,
    "msolve": MathOperation.MATRIX_SOLVE,
    "nullspace": MathOperation.MATRIX_NULLSPACE,
    "columnspace": MathOperation.MATRIX_COLUMNSPACE,
    "rowspace": MathOperation.MATRIX_ROWSPACE,
    "eigenvals": MathOperation.MATRIX_EIGENVALUES,
    "eigenvectors": MathOperation.MATRIX_EIGENVECTORS,
    "diagonalize": MathOperation.MATRIX_DIAGONALIZE,
    "lu": MathOperation.MATRIX_LU,
    "qr": MathOperation.MATRIX_QR,
    "cholesky": MathOperation.MATRIX_CHOLESKY,
}
_PACKAGE_NAME = "ot-math"
_VERSION_FALLBACK = "0.1.0"
_DEFAULT_HISTORY_FILE = Path(".otmath_history.jsonl")


def _package_version() -> str:
    try:
        return version(_PACKAGE_NAME)
    except PackageNotFoundError:
        return _VERSION_FALLBACK


def _print_result(result: MathResult, output_format: str, *, quiet: bool = False) -> None:
    if output_format == "json":
        print(json.dumps(result.as_dict(), indent=2, sort_keys=True))
        return

    if output_format == "latex":
        print(result.latex)
    else:
        print("\n".join(result.answers) if result.answers else "No answers returned.")

    if not quiet:
        for warning in result.warnings:
            print(f"warning: {warning}", file=sys.stderr)


def _print_explanation(result: MathResult, output_format: str, *, quiet: bool = False) -> None:
    if output_format == "json":
        print(json.dumps(result.as_dict(), indent=2, sort_keys=True))
        return

    if output_format == "latex":
        print(render_steps_latex(result.steps))
    else:
        print(render_steps_text(result.steps))

    if not quiet:
        for warning in result.warnings:
            print(f"warning: {warning}", file=sys.stderr)


def _write_history(result: MathResult, history_file: Path) -> None:
    history_file.parent.mkdir(parents=True, exist_ok=True)
    with history_file.open("a", encoding="utf-8") as file:
        file.write(json.dumps(result.as_dict(), sort_keys=True))
        file.write("\n")


def _default_variable(command: str) -> str:
    if command == "system":
        return "x,y"
    if command in {"sum", "product"}:
        return "k,1,n"
    if command == "limit":
        return "x,0"
    if command == "mpow":
        return "2"
    return "x"


def _variable_help(command: str) -> str:
    if command == "system":
        return "Comma-separated variable names, default x,y."
    if command in {"sum", "product"}:
        return "Range spec variable,lower,upper. Default: k,1,n."
    if command == "limit":
        return "Limit spec variable,point[,direction]. Default: x,0."
    if command == "mpow":
        return "Integer exponent, default 2."
    return "Variable name, default x."


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="otcalc",
        description="Local-first deterministic math assistant.",
    )
    parser.add_argument(
        "--config",
        type=Path,
        default=None,
        help="Optional JSON config file path.",
    )
    parser.add_argument(
        "--provider",
        default=None,
        choices=["none"],
        help="AI provider mode. Only 'none' is available in the starter scaffold.",
    )
    parser.add_argument(
        "--no-ai",
        action="store_true",
        help="Compatibility flag that forces local deterministic execution.",
    )
    parser.add_argument(
        "--quiet",
        action="store_true",
        default=None,
        help="Suppress non-fatal warnings in text and LaTeX output modes.",
    )
    parser.add_argument(
        "--version",
        action="version",
        version=f"%(prog)s {_package_version()}",
    )
    parser.add_argument(
        "--history",
        action="store_true",
        default=None,
        help="Append successful results to a local JSON Lines history file.",
    )
    parser.add_argument(
        "--history-file",
        type=Path,
        default=None,
        help="History file path used with --history.",
    )

    subparsers = parser.add_subparsers(dest="command", required=True)

    config_parser = subparsers.add_parser(
        "config",
        help="Inspect resolved OT Math CLI configuration.",
        description="Inspect resolved OT Math CLI configuration.",
    )
    config_parser.add_argument("action", choices=["show", "path"])
    config_parser.add_argument("--format", choices=["text", "json"], default="text")

    for command in _COMMAND_OPERATIONS:
        command_parser = subparsers.add_parser(
            command,
            help=_COMMAND_HELP[command],
            description=_COMMAND_HELP[command],
        )
        command_parser.add_argument("expression")
        default_variable = _default_variable(command)
        variable_help = _variable_help(command)
        command_parser.add_argument(
            "--variable",
            "-v",
            default=default_variable,
            help=variable_help,
        )
        default_format = "latex" if command == "latex" else "text"
        command_parser.add_argument(
            "--format",
            choices=["text", "json", "latex"],
            default=default_format,
        )

    explain_parser = subparsers.add_parser(
        "explain",
        help="Explain a supported deterministic operation.",
        description="Explain a supported deterministic operation.",
    )
    explain_parser.add_argument("expression")
    explain_parser.add_argument(
        "--operation",
        choices=list(_EXPLAIN_OPERATIONS),
        default="simplify",
    )
    explain_parser.add_argument("--variable", "-v", default="x")
    explain_parser.add_argument("--format", choices=["text", "json", "latex"], default="text")

    latex_build_parser = subparsers.add_parser(
        "latex-build",
        help="Generate OT Math LaTeX includes from document requests.",
        description="Scan a .tex document for OT Math requests and generate a local include file.",
    )
    latex_build_parser.add_argument("source", type=Path)
    latex_build_parser.add_argument(
        "--output",
        type=Path,
        default=None,
        help="Generated include path. Defaults to generated/otmath-results.tex next to the source.",
    )
    latex_build_parser.add_argument(
        "--compile",
        action="store_true",
        help="Compile the document after generating the include file.",
    )
    latex_build_parser.add_argument(
        "--engine",
        default="pdflatex",
        help="LaTeX engine used with --compile. Default: pdflatex.",
    )

    return parser


def main(argv: Sequence[str] | None = None) -> int:
    parser = build_parser()
    args = parser.parse_args(argv)

    try:
        if args.command == "config" and args.action == "path":
            print(config_path_message(args.config))
            return 0

        config = load_config(args.config)
        provider = args.provider or config.provider
        quiet = args.quiet if args.quiet is not None else config.quiet
        history = args.history if args.history is not None else config.history
        history_file = args.history_file or config.history_file

        if args.command == "config":
            if args.format == "json":
                print(json.dumps(config.redacted_dict(), indent=2, sort_keys=True))
            else:
                for key, value in config.redacted_dict().items():
                    print(f"{key}: {value}")
            return 0

        if args.command == "latex-build":
            latex_result = build_latex_document(
                args.source,
                output_file=args.output,
                compile_pdf=args.compile,
                engine=args.engine,
            )
            print(f"generated: {latex_result.generated_file}")
            print(f"requests: {latex_result.request_count}")
            if latex_result.compiled_pdf is not None:
                print(f"compiled: {latex_result.compiled_pdf}")
            return 0

        operation = (
            _EXPLAIN_OPERATIONS[args.operation]
            if args.command == "explain"
            else _COMMAND_OPERATIONS[args.command]
        )
        request = MathRequest(
            operation=operation,
            expression=args.expression,
            variable=args.variable,
        )
        result = run_request(request)

        if provider != "none":
            parser.exit(1, f"otcalc: unsupported provider: {provider}\n")

        if history:
            _write_history(result, history_file)

        if args.command == "explain":
            _print_explanation(result, args.format, quiet=quiet)
        else:
            _print_result(result, args.format, quiet=quiet)
        return 0
    except (OTMathError, ConfigError, LatexBuildError) as exc:
        parser.exit(1, f"otcalc: {exc}\n")
    except OSError as exc:
        parser.exit(1, f"otcalc: could not write history: {exc}\n")


if __name__ == "__main__":
    raise SystemExit(main())
