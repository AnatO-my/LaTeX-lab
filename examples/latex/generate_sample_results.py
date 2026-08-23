"""Generate OT Math include snippets for the sample document."""

from __future__ import annotations

from pathlib import Path

from otcalc.latex_build import find_latex_requests, generate_latex_include, render_latex_include

TEX_FILE = Path(__file__).parent / "sample.tex"


def render_sample_results() -> str:
    """Return deterministic OT Math snippets generated from sample.tex."""

    source = TEX_FILE.read_text(encoding="utf-8")
    return render_latex_include(find_latex_requests(source))


def main() -> int:
    result = generate_latex_include(TEX_FILE)
    print(f"Wrote {result.generated_file}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
