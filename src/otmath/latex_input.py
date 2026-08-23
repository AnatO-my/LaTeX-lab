"""Small LaTeX-to-engine input adapter for trusted document requests."""

from __future__ import annotations

import re

from otmath.errors import MathParseError

_COMMAND_REPLACEMENTS = {
    r"\pi": "pi",
    r"\cdot": "*",
    r"\times": "*",
    r"\left": "",
    r"\right": "",
}
_FUNCTIONS = ("sin", "cos", "tan", "log", "ln", "exp")
_POWER_PATTERN = re.compile(r"([A-Za-z0-9_)]+)\s*\^\s*\{([^{}]+)\}")


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

    converted = _replace_command_with_two_groups(converted, r"\frac", "({0})/({1})")
    converted = _replace_command_with_one_group(converted, r"\sqrt", "sqrt({0})")
    for function in _FUNCTIONS:
        converted = _replace_command_with_one_group(
            converted,
            rf"\{function}",
            f"{function}({{0}})",
        )

    converted = re.sub(r"\be\s*(?=\^)", "E", converted)
    converted = _POWER_PATTERN.sub(r"\1**(\2)", converted)
    converted = re.sub(r"([A-Za-z0-9_)]+)\s*\^\s*([A-Za-z0-9_(]+)", r"\1**\2", converted)
    converted = converted.replace("{", "(").replace("}", ")")
    converted = converted.replace("^", "**")
    converted = re.sub(r"\s+", " ", converted).strip()
    return converted


def _replace_command_with_one_group(source: str, command: str, template: str) -> str:
    result = source
    while True:
        index = result.find(command)
        if index == -1:
            return result
        start = index + len(command)
        group, end = _read_required_group(result, start, command)
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


def _skip_spaces(source: str, start: int) -> int:
    index = start
    while index < len(source) and source[index].isspace():
        index += 1
    return index
