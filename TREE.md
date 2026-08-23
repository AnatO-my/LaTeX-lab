# File Tree

```text
ot-math/
|-- .github/
|   |-- ISSUE_TEMPLATE/
|   |   |-- bug_report.yml
|   |   \-- feature_request.yml
|   |-- workflows/
|   |   \-- starter-build.yml
|   \-- PULL_REQUEST_TEMPLATE.md
|-- docs/
|   |-- adr/
|   |   |-- 0001-local-first-deterministic-core.md
|   |   \-- 0002-python-core-typescript-extension.md
|   |-- math-domains/
|   |   \-- systems.md
|   |-- ai-adapters.md
|   |-- api-engine.md
|   |-- architecture.md
|   |-- cli.md
|   |-- coding-standards.md
|   |-- community.md
|   |-- configuration.md
|   |-- example-gallery.md
|   |-- explanations.md
|   |-- getting-started.md
|   |-- known-limitations.md
|   |-- latex.md
|   |-- manual-qa.md
|   |-- release.md
|   |-- roadmap.md
|   |-- security-privacy.md
|   |-- testing-strategy.md
|   \-- vscode-extension.md
|-- examples/
|   |-- cli/
|   |   \-- solve.txt
|   |-- latex/
|   |   |-- generated/
|   |   |   \-- otmath-results.tex
|   |   |-- generate_sample_results.py
|   |   \-- sample.tex
|   \-- python/
|       \-- basic_usage.py
|-- extensions/
|   \-- vscode-otmath/
|       |-- src/
|       |   |-- commandBuilder.test.ts
|       |   |-- commandBuilder.ts
|       |   \-- extension.ts
|       |-- package-lock.json
|       |-- package.json
|       |-- README.md
|       \-- tsconfig.json
|-- integrations/
|   \-- latex/
|       |-- otmath.sty
|       \-- README.md
|-- src/
|   |-- otcalc/
|   |   |-- __init__.py
|   |   |-- cli.py
|   |   |-- config.py
|   |   \-- latex_build.py
|   \-- otmath/
|       |-- ai/
|       |   |-- __init__.py
|       |   \-- providers.py
|       |-- domains/
|       |   |-- __init__.py
|       |   \-- systems.py
|       |-- __init__.py
|       |-- engine.py
|       |-- errors.py
|       |-- models.py
|       |-- parser.py
|       \-- steps.py
|-- tests/
|   |-- test_ai_providers.py
|   |-- test_beta_readiness.py
|   |-- test_cli.py
|   |-- test_config.py
|   |-- test_engine.py
|   \-- test_latex.py
|-- .env.example
|-- .gitattributes
|-- .gitignore
|-- CHANGELOG.md
|-- CODE_OF_CONDUCT.md
|-- CONTRIBUTING.md
|-- LICENSE
|-- PHASE_PROMPTS.md
|-- PRIVACY.md
|-- PROJECT_PHASES.md
|-- pyproject.toml
|-- README.md
|-- SECURITY.md
\-- TREE.md
```
