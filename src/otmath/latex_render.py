"""LaTeX rendering helpers for OT Math symbolic output."""

from __future__ import annotations

from collections.abc import Iterable
from typing import Any

import sympy as sp

_STYLED_SYMBOL_PREFIXES = ("mathcal", "mathbb", "mathfrak", "mathsf", "mathbf")
_VARIANT_GREEK_SYMBOLS = {
    "var_Delta": r"\varDelta",
    "var_epsilon": r"\varepsilon",
    "var_Gamma": r"\varGamma",
    "var_phi": r"\varphi",
    "var_Pi": r"\varPi",
    "var_Psi": r"\varPsi",
    "var_rho": r"\varrho",
    "var_Sigma": r"\varSigma",
    "var_sigma": r"\varsigma",
    "var_Theta": r"\varTheta",
    "var_Upsilon": r"\varUpsilon",
    "var_pi": r"\varpi",
    "var_theta": r"\vartheta",
}


def render_latex(value: Any) -> str:
    """Render a SymPy value, restoring OT Math's internal styled symbol names."""

    compact = render_compact_plus_minus(value)
    if compact is not None:
        return compact
    return str(sp.latex(value, symbol_names=_symbol_names(value)))


def render_compact_plus_minus(value: Any) -> str | None:
    """Render a two-item symmetric value list as plus-minus notation."""

    items = _sequence_items(value)
    if items is None or len(items) != 2:
        return None

    left, right = items
    if not isinstance(left, sp.Basic) or not isinstance(right, sp.Basic):
        return None
    if sp.simplify(left + right) != 0:
        return None

    magnitude = _positive_magnitude(left, right)
    return rf"\pm {sp.latex(magnitude, symbol_names=_symbol_names(magnitude))}"


def _symbol_names(value: Any) -> dict[sp.Symbol, str]:
    symbol_names: dict[sp.Symbol, str] = {}
    for symbol in _collect_symbols(value):
        rendered = _render_styled_symbol(symbol.name)
        if rendered is not None:
            symbol_names[symbol] = rendered
    return symbol_names


def _collect_symbols(value: Any) -> set[sp.Symbol]:
    if isinstance(value, sp.Basic):
        return set(value.atoms(sp.Symbol))
    if isinstance(value, dict):
        return _collect_symbols(value.keys()) | _collect_symbols(value.values())
    if isinstance(value, Iterable) and not isinstance(value, str):
        symbols: set[sp.Symbol] = set()
        for item in value:
            symbols.update(_collect_symbols(item))
        return symbols
    return set()


def _sequence_items(value: Any) -> list[Any] | None:
    if isinstance(value, (list, tuple, sp.Tuple)):
        return list(value)
    return None


def _positive_magnitude(left: sp.Basic, right: sp.Basic) -> sp.Basic:
    if str(left).startswith("-"):
        return -left
    if str(right).startswith("-"):
        return -right
    return right


def _render_styled_symbol(name: str) -> str | None:
    if name in _VARIANT_GREEK_SYMBOLS:
        return _VARIANT_GREEK_SYMBOLS[name]

    for prefix in _STYLED_SYMBOL_PREFIXES:
        marker = f"{prefix}_"
        if name.startswith(marker) and len(name) == len(marker) + 1:
            letter = name[-1]
            if letter.isalpha() and letter.isupper():
                return rf"\{prefix}{{{letter}}}"
    return None
