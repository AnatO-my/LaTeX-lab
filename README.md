# OT Math

OT Math is a local-first, open-source mathematics assistant scaffold. The project is designed around a deterministic math engine first, with optional AI providers used only for interpretation, explanation, and workflow help.

The long-term goal is a private, offline-capable toolchain for solving, explaining, documenting, and integrating mathematics across a CLI, VS Code, LaTeX, and future interfaces.

## Core Principle

AI may help understand user intent, but mathematics must remain deterministic, inspectable, testable, and reproducible.

```text
User request
    |
    v
Optional AI adapter
    |
    v
Structured math request
    |
    v
OT Math deterministic engine
    |
    v
Verified result, steps, LaTeX, metadata
```

The project must also work with AI disabled.

## Repository Layout

See [TREE.md](TREE.md) for the generated file tree.

Important starting points:

- [PROJECT_PHASES.md](PROJECT_PHASES.md): extensive phase-by-phase project plan, checkpoints, acceptance criteria, and handoffs.
- [PHASE_PROMPTS.md](PHASE_PROMPTS.md): Codex-ready prompts for implementing each phase.
- [docs/getting-started.md](docs/getting-started.md): install-from-source and first commands.
- [docs/architecture.md](docs/architecture.md): system architecture and component boundaries.
- [docs/testing-strategy.md](docs/testing-strategy.md): testing expectations from unit tests through extension tests.
- [docs/explanations.md](docs/explanations.md): deterministic explanation step model and CLI usage.
- [docs/latex.md](docs/latex.md): generated-snippet LaTeX workflow and package helpers.
- [docs/configuration.md](docs/configuration.md): optional config files, environment overrides, and privacy defaults.
- [docs/example-gallery.md](docs/example-gallery.md): copyable beta examples.
- [docs/known-limitations.md](docs/known-limitations.md): current parser, domain, verification, and integration limits.
- [docs/manual-qa.md](docs/manual-qa.md): human verification checklist for editor and document workflows.
- [docs/manual-qa-log.md](docs/manual-qa-log.md): recorded manual QA results for beta readiness.
- [docs/community.md](docs/community.md): contributor onboarding and triage process.
- [docs/math-domains/systems.md](docs/math-domains/systems.md): systems-of-equations domain syntax and examples.
- [CONTRIBUTING.md](CONTRIBUTING.md): contribution workflow and review standards.
- [src/otmath](src/otmath): deterministic math engine package.
- [src/otcalc](src/otcalc): CLI package.
- [extensions/vscode-otmath](extensions/vscode-otmath): VS Code extension command bridge.
- [integrations/latex](integrations/latex): LaTeX package and safe document generation helpers.

## Current Status

This is a starter scaffold. It includes:

- A SymPy-backed solve/simplify/differentiate/integrate/expand/factor engine.
- A starter systems-of-equations domain.
- A CLI for text, JSON, and LaTeX output.
- A safe LaTeX pre-generation workflow with document-native `\OTMathCompute` requests.
- Typed request/result models with verification status, warnings, steps, and metadata.
- Optional AI adapter interfaces with `provider=none` by default and no network calls.
- Documentation and governance files.
- Starter tests and examples.
- VS Code command assembly and local CLI bridge.
- LaTeX generated-snippet helpers and safe document pre-generation.

## Quick Start

```powershell
cd ot-math
python -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install -e ".[dev]"
pytest
otcalc solve "x**2 - 5*x + 6"
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc simplify "(x + 1)**2 - x**2" --format json
otcalc diff "x**3" --format latex
otcalc expand "(x - 2)*(x - 3)"
otcalc factor "x**2 - 5*x + 6"
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve
otcalc latex-build examples/latex/sample.tex
```

On macOS or Linux:

```bash
cd ot-math
python -m venv .venv
source .venv/bin/activate
python -m pip install -e ".[dev]"
pytest
otcalc solve "x**2 - 5*x + 6"
otcalc solve "x**2 - 5*x + 6 = 0"
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc simplify "(x + 1)**2 - x**2" --format json
otcalc diff "x**3" --format latex
otcalc expand "(x - 2)*(x - 3)"
otcalc factor "x**2 - 5*x + 6"
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve
otcalc latex-build examples/latex/sample.tex
```

## Design Goals

- Local-first by default.
- No required cloud service.
- No shared project API key.
- Deterministic engine remains authoritative.
- Clear separation between parsing, solving, explanation, rendering, and integrations.
- Friendly for beginners, strict enough for serious mathematical work.
- Extensible provider boundary for Ollama, Gemini, Groq, Hugging Face, or future adapters.

## AI Disabled By Default

OT Math does not require AI. The default provider is `none`, and cloud providers are not
called by the deterministic engine or default tests. Future cloud integrations must use
user-owned keys and validate provider output before engine execution.

Configuration is optional. History is disabled by default and only written when explicitly
enabled by CLI flag, config, or environment variable.

## Non-Goals For The First Milestone

- Replacing SymPy.
- Building a full computer algebra system from scratch.
- Shipping hosted AI infrastructure.
- Requiring users to disclose private math notes or source files to a remote service.
- Supporting every mathematical domain on day one.

## Example

```python
from otmath import MathOperation, MathRequest, run_request, solve_expression, solve_system

solution = solve_expression("x**2 - 5*x + 6", variable="x")
print(solution.answers)
print(solution.latex)
print(solution.verified)
print(solution.metadata)

request = MathRequest(
    operation=MathOperation.FACTOR,
    expression="x**2 - 5*x + 6",
)
factored = run_request(request)
print(factored.answers)

system = solve_system(["x + y = 5", "x - y = 1"], variables=["x", "y"])
print(system.answers)
```

## License

This scaffold is prepared for an open-source project under the MIT License. See [LICENSE](LICENSE).
