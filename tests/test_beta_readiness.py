import subprocess
import sys
from pathlib import Path

PROJECT_ROOT = Path(__file__).resolve().parents[1]


def run_cli(args: list[str]) -> subprocess.CompletedProcess[str]:
    return subprocess.run(
        [sys.executable, "-m", "otcalc.cli", *args],
        cwd=PROJECT_ROOT,
        text=True,
        capture_output=True,
        check=False,
    )


def test_install_from_source_metadata_exposes_cli_entrypoint() -> None:
    pyproject = (PROJECT_ROOT / "pyproject.toml").read_text(encoding="utf-8")

    assert 'otcalc = "otcalc.cli:main"' in pyproject
    assert 'build>=1.2' in pyproject


def test_beta_docs_are_present_and_linked_from_readme() -> None:
    readme = (PROJECT_ROOT / "README.md").read_text(encoding="utf-8")
    expected_docs = [
        "docs/getting-started.md",
        "docs/community.md",
        "docs/known-limitations.md",
        "docs/example-gallery.md",
    ]

    for doc in expected_docs:
        assert (PROJECT_ROOT / doc).exists()
        assert doc in readme


def test_getting_started_cli_examples_execute() -> None:
    examples = [
        ["solve", "x**2 - 5*x + 6"],
        ["simplify", "(x + 1)**2 - x**2"],
        ["diff", "x**3", "--format", "latex"],
        ["system", "x + y = 5; x - y = 1", "--variable", "x,y"],
    ]

    for args in examples:
        result = run_cli(args)
        assert result.returncode == 0, result.stderr
        assert result.stdout.strip()
