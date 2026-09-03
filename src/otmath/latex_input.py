"""Small LaTeX-to-engine input adapter for trusted document requests."""

from __future__ import annotations

import re

from otmath.errors import MathParseError

_COMMAND_REPLACEMENTS = {
    r"\cdot": "*",
    r"\times": "*",
    r"\left": "",
    r"\right": "",
    r"\leq": "<=",
    r"\le": "<=",
    r"\geq": ">=",
    r"\ge": ">=",
    r"\neq": "!=",
    r"\ne": "!=",
}
_FUNCTION_COMMANDS = {
    r"\arccos": "acos",
    r"\arcsin": "asin",
    r"\arctan": "atan",
    r"\cos": "cos",
    r"\exp": "exp",
    r"\ln": "ln",
    r"\log": "log",
    r"\sin": "sin",
    r"\tan": "tan",
}
_MAX_PLUS_MINUS_BRANCHES = 16
_MATRIX_ENVIRONMENTS = ("bmatrix", "pmatrix", "matrix")
_MATRIX_UNARY_PREFIXES = (r"\operatorname{det}", r"\det")
_SYMBOL_COMMANDS = {
    r"\mathrm{i}": "I",
    r"E": "E",
    r"H": "H",
    r"I": "I",
    r"K": "K",
    r"M": "M",
    r"N": "N",
    r"O": "O",
    r"P": "P",
    r"T": "T",
    r"X": "X",
    r"Z": "Z",
    r"\aleph": "aleph",
    r"\alpha": "alpha",
    r"\Beta": "Beta",
    r"\beta": "beta",
    r"\beth": "beth",
    r"\chi": "chi",
    r"\daleth": "daleth",
    r"\Delta": "Delta",
    r"\delta": "delta",
    r"\epsilon": "epsilon",
    r"\eta": "eta",
    r"\Gamma": "Gamma",
    r"\gamma": "gamma",
    r"\gimel": "gimel",
    r"\iota": "iota",
    r"\kappa": "kappa",
    r"\Lambda": "Lambda",
    r"\lambda": "lambda",
    r"\mu": "mu",
    r"\nu": "nu",
    r"\Omega": "Omega",
    r"\omega": "omega",
    r"\Phi": "Phi",
    r"\phi": "phi",
    r"\Pi": "Pi",
    r"\pi": "pi",
    r"\Psi": "Psi",
    r"\psi": "psi",
    r"\rho": "rho",
    r"\Sigma": "Sigma",
    r"\sigma": "sigma",
    r"\tau": "tau",
    r"\Theta": "Theta",
    r"\theta": "theta",
    r"\Upsilon": "Upsilon",
    r"\upsilon": "upsilon",
    r"\varDelta": "varDelta",
    r"\varepsilon": "varepsilon",
    r"\varGamma": "varGamma",
    r"\varphi": "varphi",
    r"\varPi": "varPi",
    r"\varPsi": "varPsi",
    r"\varrho": "varrho",
    r"\varSigma": "varSigma",
    r"\varsigma": "varsigma",
    r"\varTheta": "varTheta",
    r"\varUpsilon": "varUpsilon",
    r"\varpi": "varpi",
    r"\vartheta": "vartheta",
    r"\Xi": "Xi",
    r"\xi": "xi",
    r"\mathcal{A}": "mathcal{A}",
    r"\mathcal{B}": "mathcal{B}",
    r"\mathcal{C}": "mathcal{C}",
    r"\mathcal{D}": "mathcal{D}",
    r"\mathcal{E}": "mathcal{E}",
    r"\mathcal{F}": "mathcal{F}",
    r"\mathcal{G}": "mathcal{G}",
    r"\mathcal{H}": "mathcal{H}",
    r"\mathcal{I}": "mathcal{I}",
    r"\mathcal{J}": "mathcal{J}",
    r"\mathcal{K}": "mathcal{K}",
    r"\mathcal{L}": "mathcal{L}",
    r"\mathcal{M}": "mathcal{M}",
    r"\mathcal{N}": "mathcal{N}",
    r"\mathcal{O}": "mathcal{O}",
    r"\mathcal{P}": "mathcal{P}",
    r"\mathcal{Q}": "mathcal{Q}",
    r"\mathcal{R}": "mathcal{R}",
    r"\mathcal{S}": "mathcal{S}",
    r"\mathcal{T}": "mathcal{T}",
    r"\mathcal{U}": "mathcal{U}",
    r"\mathcal{V}": "mathcal{V}",
    r"\mathcal{W}": "mathcal{W}",
    r"\mathcal{X}": "mathcal{X}",
    r"\mathcal{Y}": "mathcal{Y}",
    r"\mathcal{Z}": "mathcal{Z}",
    r"\mathbb{A}": "mathbb{A}",
    r"\mathbb{B}": "mathbb{B}",
    r"\mathbb{C}": "mathbb{C}",
    r"\mathbb{D}": "mathbb{D}",
    r"\mathbb{E}": "mathbb{E}",
    r"\mathbb{F}": "mathbb{F}",
    r"\mathbb{G}": "mathbb{G}",
    r"\mathbb{H}": "mathbb{H}",
    r"\mathbb{I}": "mathbb{I}",
    r"\mathbb{J}": "mathbb{J}",
    r"\mathbb{K}": "mathbb{K}",
    r"\mathbb{L}": "mathbb{L}",
    r"\mathbb{M}": "mathbb{M}",
    r"\mathbb{N}": "mathbb{N}",
    r"\mathbb{O}": "mathbb{O}",
    r"\mathbb{P}": "mathbb{P}",
    r"\mathbb{Q}": "mathbb{Q}",
    r"\mathbb{R}": "mathbb{R}",
    r"\mathbb{S}": "mathbb{S}",
    r"\mathbb{T}": "mathbb{T}",
    r"\mathbb{U}": "mathbb{U}",
    r"\mathbb{V}": "mathbb{V}",
    r"\mathbb{W}": "mathbb{W}",
    r"\mathbb{X}": "mathbb{X}",
    r"\mathbb{Y}": "mathbb{Y}",
    r"\mathbb{Z}": "mathbb{Z}",
    r"\mathfrak{A}": "mathfrak{A}",
    r"\mathfrak{B}": "mathfrak{B}",
    r"\mathfrak{C}": "mathfrak{C}",
    r"\mathfrak{D}": "mathfrak{D}",
    r"\mathfrak{E}": "mathfrak{E}",
    r"\mathfrak{F}": "mathfrak{F}",
    r"\mathfrak{G}": "mathfrak{G}",
    r"\mathfrak{H}": "mathfrak{H}",
    r"\mathfrak{I}": "mathfrak{I}",
    r"\mathfrak{J}": "mathfrak{J}",
    r"\mathfrak{K}": "mathfrak{K}",
    r"\mathfrak{L}": "mathfrak{L}",
    r"\mathfrak{M}": "mathfrak{M}",
    r"\mathfrak{N}": "mathfrak{N}",
    r"\mathfrak{O}": "mathfrak{O}",
    r"\mathfrak{P}": "mathfrak{P}",
    r"\mathfrak{Q}": "mathfrak{Q}",
    r"\mathfrak{R}": "mathfrak{R}",
    r"\mathfrak{S}": "mathfrak{S}",
    r"\mathfrak{T}": "mathfrak{T}",
    r"\mathfrak{U}": "mathfrak{U}",
    r"\mathfrak{V}": "mathfrak{V}",
    r"\mathfrak{W}": "mathfrak{W}",
    r"\mathfrak{X}": "mathfrak{X}",
    r"\mathfrak{Y}": "mathfrak{Y}",
    r"\mathfrak{Z}": "mathfrak{Z}",
    r"\mathsf{A}": "mathsf{A}",
    r"\mathsf{B}": "mathsf{B}",
    r"\mathsf{C}": "mathsf{C}",
    r"\mathsf{D}": "mathsf{D}",
    r"\mathsf{E}": "mathsf{E}",
    r"\mathsf{F}": "mathsf{F}",
    r"\mathsf{G}": "mathsf{G}",
    r"\mathsf{H}": "mathsf{H}",
    r"\mathsf{I}": "mathsf{I}",
    r"\mathsf{J}": "mathsf{J}",
    r"\mathsf{K}": "mathsf{K}",
    r"\mathsf{L}": "mathsf{L}",
    r"\mathsf{M}": "mathsf{M}",
    r"\mathsf{N}": "mathsf{N}",
    r"\mathsf{O}": "mathsf{O}",
    r"\mathsf{P}": "mathsf{P}",
    r"\mathsf{Q}": "mathsf{Q}",
    r"\mathsf{R}": "mathsf{R}",
    r"\mathsf{S}": "mathsf{S}",
    r"\mathsf{T}": "mathsf{T}",
    r"\mathsf{U}": "mathsf{U}",
    r"\mathsf{V}": "mathsf{V}",
    r"\mathsf{W}": "mathsf{W}",
    r"\mathsf{X}": "mathsf{X}",
    r"\mathsf{Y}": "mathsf{Y}",
    r"\mathsf{Z}": "mathsf{Z}",
    r"\mathbf{A}": "mathbf{A}",
    r"\mathbf{B}": "mathbf{B}",
    r"\mathbf{C}": "mathbf{C}",
    r"\mathbf{D}": "mathbf{D}",
    r"\mathbf{E}": "mathbf{E}",
    r"\mathbf{F}": "mathbf{F}",
    r"\mathbf{G}": "mathbf{G}",
    r"\mathbf{H}": "mathbf{H}",
    r"\mathbf{I}": "mathbf{I}",
    r"\mathbf{J}": "mathbf{J}",
    r"\mathbf{K}": "mathbf{K}",
    r"\mathbf{L}": "mathbf{L}",
    r"\mathbf{M}": "mathbf{M}",
    r"\mathbf{N}": "mathbf{N}",
    r"\mathbf{O}": "mathbf{O}",
    r"\mathbf{P}": "mathbf{P}",
    r"\mathbf{Q}": "mathbf{Q}",
    r"\mathbf{R}": "mathbf{R}",
    r"\mathbf{S}": "mathbf{S}",
    r"\mathbf{T}": "mathbf{T}",
    r"\mathbf{U}": "mathbf{U}",
    r"\mathbf{V}": "mathbf{V}",
    r"\mathbf{W}": "mathbf{W}",
    r"\mathbf{X}": "mathbf{X}",
    r"\mathbf{Y}": "mathbf{Y}",
    r"\mathbf{Z}": "mathbf{Z}",
}
for _style in ("mathcal", "mathbb", "mathfrak", "mathsf", "mathbf"):
    for _letter in "ABCDEFGHIJKLMNOPQRSTUVWXYZ":
        _SYMBOL_COMMANDS[rf"\{_style}{{{_letter}}}"] = f"{_style}_{_letter}"

_SYMBOL_COMMANDS.update(
    {
        r"\varDelta": "var_Delta",
        r"\varepsilon": "var_epsilon",
        r"\varGamma": "var_Gamma",
        r"\varphi": "var_phi",
        r"\varPi": "var_Pi",
        r"\varPsi": "var_Psi",
        r"\varrho": "var_rho",
        r"\varSigma": "var_Sigma",
        r"\varsigma": "var_sigma",
        r"\varTheta": "var_Theta",
        r"\varUpsilon": "var_Upsilon",
        r"\varpi": "var_pi",
        r"\vartheta": "var_theta",
    }
)

_POWER_PATTERN = re.compile(r"([A-Za-z0-9_)]+)\s*\^\s*\{([^{}]+)\}")
_BRACED_SUBSCRIPT_PATTERN = re.compile(
    r"([A-Za-z][A-Za-z0-9]*)\s*_\s*\{([A-Za-z0-9]+)\}"
)
_PLAIN_SUBSCRIPT_PATTERN = re.compile(r"([A-Za-z][A-Za-z0-9]*)\s*_\s*([A-Za-z0-9]+)")


def latex_to_engine_expression(expression: str) -> str:
    """Convert a small, documented subset of LaTeX math into engine syntax.

    This is intentionally conservative. Unsupported LaTeX should fail at the normal
    parser boundary rather than guessing.
    """

    converted = expression.strip()
    if not converted:
        raise MathParseError("LaTeX expression cannot be empty.")

    for latex, replacement in _COMMAND_REPLACEMENTS.items():
        converted = converted.replace(latex, replacement)
    converted = _replace_symbol_commands(converted)

    converted = _replace_command_with_two_groups(converted, r"\frac", "({0})/({1})")
    converted = _replace_command_with_one_group(converted, r"\sqrt", "sqrt({0})")
    for command, function in sorted(
        _FUNCTION_COMMANDS.items(),
        key=lambda item: len(item[0]),
        reverse=True,
    ):
        converted = _replace_command_with_one_group(
            converted,
            command,
            f"{function}({{0}})",
        )

    converted = re.sub(r"\be\s*(?=\^)", "E", converted)
    converted = _normalize_subscripts(converted)
    converted = _POWER_PATTERN.sub(r"\1**(\2)", converted)
    converted = re.sub(
        r"([A-Za-z0-9_)]+)\s*\^\s*([A-Za-z0-9_(]+)", r"\1**\2", converted
    )
    converted = converted.replace("{", "(").replace("}", ")")
    converted = converted.replace("^", "**")
    converted = re.sub(r"\s+", " ", converted).strip()
    return converted


def latex_to_engine_symbol_spec(symbol_spec: str) -> str:
    """Convert a comma-separated LaTeX variable spec into engine symbol names."""

    symbols = [part.strip() for part in symbol_spec.split(",")]
    if any(not symbol for symbol in symbols):
        raise MathParseError("LaTeX variable spec contains an empty symbol.")
    return ",".join(latex_to_engine_expression(symbol) for symbol in symbols)


def latex_plus_minus_branches(expression: str) -> tuple[str, ...]:
    """Expand LaTeX plus-minus shorthand into explicit plus and minus branches."""

    stripped = expression.strip()
    if not stripped:
        raise MathParseError("LaTeX expression cannot be empty.")

    if r"\pm" in stripped and r"\mp" in stripped:
        return (
            stripped.replace(r"\pm", "+").replace(r"\mp", "-"),
            stripped.replace(r"\pm", "-").replace(r"\mp", "+"),
        )

    branches = [stripped]
    while any(r"\pm" in branch or r"\mp" in branch for branch in branches):
        expanded: list[str] = []
        for branch in branches:
            plus_minus_index = branch.find(r"\pm")
            minus_plus_index = branch.find(r"\mp")
            index = _first_operator_index(plus_minus_index, minus_plus_index)
            if index == -1:
                expanded.append(branch)
                continue

            operator = branch[index : index + len(r"\pm")]
            before = branch[:index]
            after = branch[index + len(operator) :]
            signs = ("+", "-") if operator == r"\pm" else ("-", "+")
            expanded.extend(f"{before}{sign}{after}" for sign in signs)
        branches = expanded
        if len(branches) > _MAX_PLUS_MINUS_BRANCHES:
            raise MathParseError("LaTeX expression contains too many plus-minus branches.")

    return tuple(branches)


def latex_to_engine_expression_branches(expression: str) -> tuple[str, ...]:
    """Convert a LaTeX expression, expanding plus-minus notation first."""

    return tuple(
        latex_to_engine_expression(branch)
        for branch in latex_plus_minus_branches(expression)
    )


def _first_operator_index(first: int, second: int) -> int:
    indexes = [index for index in (first, second) if index != -1]
    if not indexes:
        return -1
    return min(indexes)


def latex_sum_to_engine_parts(expression: str) -> tuple[str, str]:
    """Convert a LaTeX summation into an engine expression and range spec."""

    return _latex_range_command_to_engine_parts(expression, r"\sum")


def latex_product_to_engine_parts(expression: str) -> tuple[str, str]:
    """Convert a LaTeX product into an engine expression and range spec."""

    return _latex_range_command_to_engine_parts(expression, r"\prod")


def latex_limit_to_engine_parts(expression: str) -> tuple[str, str]:
    """Convert a LaTeX limit into an engine expression and limit spec."""

    converted = expression.strip()
    if not converted.startswith(r"\lim"):
        return latex_to_engine_expression(expression), "x,0,+-"

    index = _skip_spaces(converted, len(r"\lim"))
    if index >= len(converted) or converted[index] != "_":
        raise MathParseError(r"LaTeX \lim requires a subscript such as _{x \to 0}.")

    target, index = _read_script_group(converted, index + 1, r"\lim")
    body = converted[index:].strip()
    if not body:
        raise MathParseError(r"LaTeX \lim requires an expression body.")

    if r"\to" in target:
        variable_text, point_text = target.split(r"\to", maxsplit=1)
    elif r"\rightarrow" in target:
        variable_text, point_text = target.split(r"\rightarrow", maxsplit=1)
    else:
        raise MathParseError(r"LaTeX \lim subscript must use \to.")

    point_text, direction = _extract_limit_direction(point_text.strip())
    variable = latex_to_engine_expression(variable_text.strip())
    point = latex_to_engine_expression(point_text)
    expression_body = latex_to_engine_expression(body)
    return expression_body, f"{variable},{point},{direction}"


def latex_integral_to_engine_parts(
    expression: str,
    default_variable: str = "x",
) -> tuple[str, str]:
    """Convert a LaTeX indefinite integral into an integrand and variable."""

    converted = expression.strip()
    if not converted.startswith(r"\int"):
        return latex_to_engine_expression(expression), latex_to_engine_symbol_spec(
            default_variable
        )

    body = converted[len(r"\int") :].strip()
    if not body:
        raise MathParseError(r"LaTeX \int requires an integrand.")

    integrand, variable = _split_integral_differential(body, default_variable)
    return latex_to_engine_expression(integrand), latex_to_engine_expression(variable)


def latex_derivative_to_engine_parts(
    expression: str,
    default_variable: str = "x",
) -> tuple[str, str]:
    """Convert simple Leibniz derivative notation into an expression and variable."""

    converted = expression.strip()
    if not converted.startswith(r"\frac"):
        return latex_to_engine_expression(expression), latex_to_engine_symbol_spec(
            default_variable
        )

    numerator, first_end = _read_required_group(converted, len(r"\frac"), r"\frac")
    denominator, second_end = _read_required_group(converted, first_end, r"\frac")
    variable = _derivative_variable_from_fraction(numerator, denominator)
    body = converted[second_end:].strip()
    if not body:
        raise MathParseError(r"LaTeX derivative notation requires an expression body.")

    return (
        latex_to_engine_expression(_strip_wrapping_group(body)),
        latex_to_engine_expression(variable),
    )


def latex_matrix_to_engine_expression(expression: str) -> str:
    """Convert a simple LaTeX matrix environment into an engine matrix literal."""

    converted = expression.strip()
    replaced = _replace_latex_matrix_environments(converted)
    if replaced != converted:
        return _strip_matrix_unary_prefix(replaced)

    return latex_to_engine_expression(expression)


def _replace_latex_matrix_environments(source: str) -> str:
    result = source
    search_from = 0
    while True:
        match = _find_next_matrix_environment(result, search_from)
        if match is None:
            return result

        start, body_start, end, environment = match
        matrix_literal = _convert_latex_matrix_body(result[body_start:end])
        full_end = end + len(rf"\end{{{environment}}}")
        result = result[:start] + matrix_literal + result[full_end:]
        search_from = start + len(matrix_literal)


def _find_next_matrix_environment(
    source: str,
    search_from: int,
) -> tuple[int, int, int, str] | None:
    best: tuple[int, int, int, str] | None = None
    for environment in _MATRIX_ENVIRONMENTS:
        begin = rf"\begin{{{environment}}}"
        end = rf"\end{{{environment}}}"
        start = source.find(begin, search_from)
        if start == -1:
            continue
        body_start = start + len(begin)
        body_end = source.find(end, body_start)
        if body_end == -1:
            raise MathParseError(f"Unclosed LaTeX matrix environment: {environment}")
        candidate = (start, body_start, body_end, environment)
        if best is None or start < best[0]:
            best = candidate
    return best


def _convert_latex_matrix_body(body: str) -> str:
    rows = [row.strip() for row in re.split(r"\\\\", body.strip()) if row.strip()]
    if not rows:
        raise MathParseError("LaTeX matrix must contain at least one row.")
    converted_rows = []
    for row in rows:
        cells = [cell.strip() for cell in row.split("&")]
        if any(not cell for cell in cells):
            raise MathParseError("LaTeX matrix contains an empty cell.")
        converted_rows.append(
            "[" + ", ".join(latex_to_engine_expression(cell) for cell in cells) + "]"
        )
    return "[" + ", ".join(converted_rows) + "]"


def _strip_matrix_unary_prefix(source: str) -> str:
    stripped = source.strip()
    for prefix in _MATRIX_UNARY_PREFIXES:
        if not stripped.startswith(prefix):
            continue
        body = stripped[len(prefix) :].strip()
        if body.startswith("["):
            return body
    return stripped


def _replace_symbol_commands(source: str) -> str:
    converted = source
    for latex in sorted(_SYMBOL_COMMANDS, key=len, reverse=True):
        converted = converted.replace(latex, _SYMBOL_COMMANDS[latex])
    return converted


def _normalize_subscripts(source: str) -> str:
    converted = _BRACED_SUBSCRIPT_PATTERN.sub(r"\1_\2", source)
    return _PLAIN_SUBSCRIPT_PATTERN.sub(r"\1_\2", converted)


def _latex_range_command_to_engine_parts(
    expression: str, command: str
) -> tuple[str, str]:
    converted = expression.strip()
    if not converted.startswith(command):
        return latex_to_engine_expression(expression), "k,1,n"

    index = _skip_spaces(converted, len(command))
    if index >= len(converted) or converted[index] != "_":
        raise MathParseError(f"LaTeX {command} requires a lower bound subscript.")

    lower_spec, index = _read_script_group(converted, index + 1, command)
    index = _skip_spaces(converted, index)
    if index >= len(converted) or converted[index] != "^":
        raise MathParseError(f"LaTeX {command} requires an upper bound.")

    upper_spec, index = _read_script_group(converted, index + 1, command)
    body = converted[index:].strip()
    if not body:
        raise MathParseError(f"LaTeX {command} requires an expression body.")

    if "=" not in lower_spec:
        raise MathParseError(f"LaTeX {command} lower bound must use variable=value.")
    variable_text, lower_text = (
        part.strip() for part in lower_spec.split("=", maxsplit=1)
    )
    variable = latex_to_engine_expression(variable_text)
    lower = latex_to_engine_expression(lower_text)
    upper = latex_to_engine_expression(upper_spec)
    expression_body = latex_to_engine_expression(body)
    return expression_body, f"{variable},{lower},{upper}"


def _read_script_group(source: str, start: int, command: str) -> tuple[str, int]:
    index = _skip_spaces(source, start)
    if index < len(source) and source[index] == "{":
        return _read_required_group(source, index, command)
    if index >= len(source):
        raise MathParseError(f"LaTeX command has an empty script: {command}")

    end = index + 1
    while end < len(source) and not source[end].isspace() and source[end] not in "_^{}":
        end += 1
    return source[index:end], end


def _extract_limit_direction(point_text: str) -> tuple[str, str]:
    stripped = point_text.strip()
    for marker, direction in (("^{+}", "+"), ("^+", "+"), ("^{-}", "-"), ("^-", "-")):
        if stripped.endswith(marker):
            return stripped[: -len(marker)].strip(), direction
    return stripped, "+-"


def _split_integral_differential(body: str, default_variable: str) -> tuple[str, str]:
    compact = _normalize_latex_spacing(body)
    variable_pattern = r"(\\[A-Za-z]+(?:_\{[A-Za-z0-9]+\})?|[A-Za-z](?:_\{[A-Za-z0-9]+\})?)"
    match = re.fullmatch(rf"(.+?)\s*d\s*{variable_pattern}", compact)
    if match is None:
        return body, default_variable
    return match.group(1).strip(), match.group(2).strip()


def _derivative_variable_from_fraction(numerator: str, denominator: str) -> str:
    order = _derivative_order_from_numerator(numerator)
    variable, denominator_order = _derivative_variable_and_order_from_denominator(
        denominator
    )
    if denominator_order != order:
        raise MathParseError("LaTeX derivative orders must match.")
    if order == 1:
        return variable
    return f"{variable},{order}"


def _derivative_order_from_numerator(numerator: str) -> int:
    stripped = numerator.strip()
    if stripped == "d":
        return 1
    if not stripped.startswith("d^"):
        raise MathParseError(r"LaTeX derivative numerator must be d.")
    return _parse_positive_integer_script(stripped[2:])


def _derivative_variable_and_order_from_denominator(denominator: str) -> tuple[str, int]:
    stripped = denominator.strip()
    if not stripped.startswith("d"):
        raise MathParseError(r"LaTeX derivative denominator must start with d.")

    body = stripped[1:].strip()
    variable, order_text = _split_derivative_denominator_body(body)
    if not variable:
        raise MathParseError(r"LaTeX derivative denominator must include a variable.")
    order = _parse_positive_integer_script(order_text) if order_text is not None else 1
    return variable, order


def _split_derivative_denominator_body(body: str) -> tuple[str, str | None]:
    if "^" not in body:
        return body.strip(), None
    variable, order_text = body.split("^", maxsplit=1)
    return variable.strip(), order_text.strip()


def _parse_positive_integer_script(script: str) -> int:
    stripped = script.strip()
    if stripped.startswith("{") and stripped.endswith("}"):
        stripped = stripped[1:-1].strip()
    if not stripped.isdigit():
        raise MathParseError("LaTeX derivative order must be a positive integer.")
    order = int(stripped)
    if order < 1:
        raise MathParseError("LaTeX derivative order must be at least 1.")
    return order


def _strip_wrapping_group(source: str) -> str:
    stripped = source.replace(r"\left", "").replace(r"\right", "").strip()
    while (
        (stripped.startswith("(") and stripped.endswith(")"))
        or (stripped.startswith("{") and stripped.endswith("}"))
    ):
        stripped = stripped[1:-1].strip()
    return stripped


def _normalize_latex_spacing(source: str) -> str:
    converted = source
    for command in (r"\,", r"\;", r"\:", r"\!", r"\quad", r"\qquad"):
        converted = converted.replace(command, " ")
    return re.sub(r"\s+", " ", converted).strip()


def _replace_command_with_one_group(source: str, command: str, template: str) -> str:
    result = source
    while True:
        index = result.find(command)
        if index == -1:
            return result
        start = index + len(command)
        group, end = _read_command_argument(result, start, command)
        result = result[:index] + template.format(group) + result[end:]


def _replace_command_with_two_groups(source: str, command: str, template: str) -> str:
    result = source
    while True:
        index = result.find(command)
        if index == -1:
            return result
        start = index + len(command)
        first, first_end = _read_required_group(result, start, command)
        second, second_end = _read_required_group(result, first_end, command)
        result = result[:index] + template.format(first, second) + result[second_end:]


def _read_required_group(source: str, start: int, command: str) -> tuple[str, int]:
    index = _skip_spaces(source, start)
    if index >= len(source) or source[index] != "{":
        raise MathParseError(f"LaTeX command requires a braced argument: {command}")

    depth = 0
    for position in range(index, len(source)):
        char = source[position]
        if char == "{":
            depth += 1
        elif char == "}":
            depth -= 1
            if depth == 0:
                return source[index + 1 : position], position + 1

    raise MathParseError(f"Unclosed LaTeX group for command: {command}")


def _read_command_argument(source: str, start: int, command: str) -> tuple[str, int]:
    index = _skip_spaces(source, start)
    if index >= len(source):
        raise MathParseError(f"LaTeX command requires an argument: {command}")
    if source[index] == "{":
        return _read_required_group(source, index, command)
    if source[index] == "(":
        return _read_parenthesized_group(source, index, command)
    return _read_simple_command_argument(source, index, command)


def _read_parenthesized_group(source: str, start: int, command: str) -> tuple[str, int]:
    depth = 0
    for position in range(start, len(source)):
        char = source[position]
        if char == "(":
            depth += 1
        elif char == ")":
            depth -= 1
            if depth == 0:
                return source[start + 1 : position], position + 1

    raise MathParseError(f"Unclosed LaTeX parenthesized argument for command: {command}")


def _read_simple_command_argument(source: str, start: int, command: str) -> tuple[str, int]:
    end = start
    if source[end] == "\\":
        end += 1
        while end < len(source) and source[end].isalpha():
            end += 1
    else:
        while end < len(source) and (source[end].isalnum() or source[end] == "_"):
            end += 1

    if end == start:
        raise MathParseError(f"LaTeX command requires an argument: {command}")

    end = _consume_simple_scripts(source, end)
    return source[start:end], end


def _consume_simple_scripts(source: str, start: int) -> int:
    index = start
    while index < len(source) and source[index] in "_^":
        index += 1
        if index < len(source) and source[index] == "{":
            _, index = _read_required_group(source, index, "script")
            continue
        while index < len(source) and (source[index].isalnum() or source[index] in "_\\"):
            index += 1
    return index


def _skip_spaces(source: str, start: int) -> int:
    index = start
    while index < len(source) and source[index].isspace():
        index += 1
    return index
