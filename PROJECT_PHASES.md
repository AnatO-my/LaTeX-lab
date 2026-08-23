# OT Math Project Phases

This document is the operational plan for building OT Math in Codex. Each phase includes purpose, scope, components, dependencies, contribution areas, checkpoints, tests, documentation updates, acceptance criteria, and handoff notes. Whenever the user instructs for guidance on writing the code themselves, do well to await instructions for generating complete files and edits. The user may request to use the agent as a teacher, so as to learn the process of writing and implementing working code and systems.

## Phase 0: Repository Foundation

### Purpose

Create a Codex-ready repository with enough structure that future work can proceed in focused, reviewable increments.

### Components

- Top-level project documentation.
- Python package layout for `otmath` and `otcalc`.
- VS Code extension placeholder.
- LaTeX integration placeholder.
- Examples, tests, and docs folders.
- Governance files and templates.
- Starter architecture records.
- Generated tree file and packaged archive.

### Dependencies

- Python 3.11 or newer.
- SymPy for symbolic mathematics.
- pytest for tests.
- Ruff and mypy for future quality gates.
- Node.js for future VS Code extension work.
- A TeX distribution for future LaTeX integration work.

### Contributions

- Create starter files.
- Define project scope and initial architecture.
- Establish coding standards and test strategy.
- Create issue and pull request templates.
- Create phase prompts for Codex handoffs.

### Checkpoints

- Repository opens cleanly in an editor.
- `pyproject.toml` defines packages, CLI entry point, and dev tools.
- Starter engine imports successfully after editable install.
- Test suite contains at least one engine test and one CLI test.
- Documentation names privacy, security, contribution, and architecture principles.
- VS Code and LaTeX placeholders explain intended integration boundaries.

### Test Requirements

- Unit tests for the minimal deterministic engine.
- CLI smoke test for basic solve output.
- No live AI provider calls.
- No network dependency in the default test path.

### Documentation Updates

- `README.md`
- `PROJECT_PHASES.md`
- `PHASE_PROMPTS.md`
- `docs/architecture.md`
- `docs/testing-strategy.md`
- `docs/coding-standards.md`
- `docs/security-privacy.md`
- `docs/roadmap.md`

### Acceptance Criteria

- A new contributor can understand the project direction in under ten minutes.
- A future Codex task can pick a phase from this document and execute it.
- Every top-level directory has a clear purpose.
- There is no hidden cloud dependency.

### Handoff Point

Hand off to Phase 1 when the scaffold is committed or zipped, and the next contributor can run the starter tests locally.

## Phase 1: Deterministic Core Engine

### Purpose

Build the first reliable version of the `otmath` engine. This phase makes OT Math useful without any AI.

### Components

- Expression parsing boundary.
- Structured request and result models.
- Solve, simplify, differentiate, integrate, expand, factor.
- Step representation.
- LaTeX rendering.
- Error model for invalid input and unsupported operations.
- Verification helper for generated answers.

### Dependencies

- SymPy.
- Python standard library.
- Optional Pydantic if richer validation is introduced.

### Contributions

- Implement `MathRequest` and `MathResult` models.
- Implement parser normalization for explicit operations.
- Add operation dispatching.
- Add a stable public API in `otmath.__init__`.
- Add domain-specific exceptions.
- Add structured metadata for engine version, operation, variable, assumptions, and warnings.
- Add tests for happy paths and failure paths.

### Checkpoints

- `otmath.solve_expression` works for linear and quadratic equations.
- `otmath.simplify_expression` handles common algebraic simplifications.
- Differentiation and integration work for single-variable expressions.
- Results include raw answer, plain text, LaTeX, and verification status where possible.
- Invalid input returns a controlled error at API boundaries.

### Test Requirements

- Unit tests for each operation.
- Property-style tests for simple identities where reasonable.
- Regression tests for parsing edge cases.
- Tests that prove AI is not required.
- Tests for deterministic ordering of answers where possible.

### Documentation Updates

- Engine API reference in `docs/api-engine.md`.
- Examples in `examples/python`.
- Update README quick start with current commands.
- Add limitations and supported syntax notes.

### Acceptance Criteria

- All engine tests pass without network access.
- Public API functions have docstrings.
- Supported operations are documented.
- Unsupported operations fail clearly.
- The engine does not execute arbitrary Python input.

### Handoff Point

Hand off to Phase 2 with an API surface stable enough for the CLI to call without importing private modules.

## Phase 2: CLI And Local User Workflow

### Purpose

Create a practical command-line interface named `otcalc` for day-to-day use and for integration testing.

### Components

- `otcalc` command.
- Subcommands for solve, simplify, diff, integrate, latex, and explain placeholder.
- Output modes: text, JSON, and LaTeX.
- Exit codes.
- Config discovery.
- Optional local history file, disabled by default.

### Dependencies

- `otmath` public API.
- Python standard library.
- Optional Rich for improved formatting.

### Contributions

- Implement CLI argument parsing.
- Add JSON serialization for result models.
- Add `--no-ai` and `--provider none` flags early, even before AI providers exist.
- Add `--format text|json|latex`.
- Add friendly error messages.
- Add CLI examples.
- Add shell-friendly behavior for scripts.

### Checkpoints

- `otcalc solve "x**2 - 5*x + 6" --variable x` prints answers.
- `otcalc simplify "(x + 1)**2 - x**2"` prints simplified output.
- JSON mode emits machine-readable result data.
- CLI exits nonzero for invalid input.
- CLI does not write history unless the user opts in.

### Test Requirements

- CLI unit tests using subprocess or runner helpers.
- Snapshot-style tests for text output.
- JSON schema consistency checks.
- Error exit tests.
- No network use in CLI tests.

### Documentation Updates

- `docs/cli.md`
- README quick start.
- `examples/cli`
- Troubleshooting section for quoting expressions in shells.

### Acceptance Criteria

- CLI works on Windows, macOS, and Linux.
- Every supported command has a help message.
- CLI results match engine results.
- The CLI remains usable with AI disabled.

### Handoff Point

Hand off to Phase 3 when the CLI is stable enough to become the first integration surface for editor and LaTeX workflows.

## Phase 3: Explanation And Step System

### Purpose

Add a structured, inspectable explanation layer that can produce educational steps without giving authority to an AI model.

### Components

- `MathStep` model.
- Step generator interfaces.
- Rule-based steps for common algebra operations.
- Verification hooks for each step where practical.
- LaTeX step rendering.
- Plain-English explanation rendering.

### Dependencies

- `otmath` engine.
- SymPy transformation and simplification utilities.

### Contributions

- Define step types such as normalize, factor, expand, isolate, substitute, differentiate, integrate, verify.
- Add step metadata with input expression, output expression, rule name, and confidence.
- Implement initial step generators for quadratic solving, simplification, and derivatives.
- Add renderer functions for text and LaTeX.
- Add docs explaining that steps are generated explanations, not independent proof unless verified.

### Checkpoints

- Quadratic solve can return answer and step list.
- Simplify can show before and after transformations.
- Derivative output includes the operation rule where known.
- Each step has a stable serialized format.
- Unavailable steps degrade gracefully.

### Test Requirements

- Unit tests for step serialization.
- Tests for known step sequences.
- Tests that final answers match engine results.
- Regression tests for step rendering.
- Tests for graceful fallback when no step generator is available.

### Documentation Updates

- `docs/explanations.md`
- README example with steps.
- Update API docs.
- Add contribution notes for new step generators.

### Acceptance Criteria

- Steps are structured data, not only formatted strings.
- Final answer verification is separate from explanation generation.
- At least three common workflows produce meaningful steps.
- Output remains deterministic.

### Handoff Point

Hand off to Phase 4 when explanations can be consumed by the CLI and future UI surfaces.

## Phase 4: AI Adapter Boundary

### Purpose

Introduce optional AI support for natural-language interpretation and explanation drafting while preserving the deterministic engine as the authority.

### Components

- Provider-neutral AI adapter interface.
- Provider configuration model.
- `none` provider.
- Local provider placeholder, likely Ollama-compatible.
- Cloud provider placeholders for user-supplied keys.
- Prompt templates for converting natural language into structured requests.
- Safety filter for provider outputs.

### Dependencies

- `otmath` request models.
- Optional local runtime such as Ollama in later work.
- Optional provider SDKs only behind extras.

### Contributions

- Implement `AIProvider` protocol.
- Implement `NoAIProvider`.
- Implement structured parse output schema.
- Add provider selection logic.
- Add configuration file format.
- Add redaction rules for logs.
- Add tests using fake providers.

### Checkpoints

- `provider=none` remains default and valid.
- Fake provider can turn a natural-language prompt into a `MathRequest`.
- Provider output is validated before engine execution.
- Invalid provider output is rejected.
- No provider key is committed or required.

### Test Requirements

- Unit tests for provider selection.
- Fake-provider tests.
- Validation tests for malformed AI output.
- Privacy tests confirming prompts are not logged by default.
- No live provider tests in default CI.

### Documentation Updates

- `docs/ai-adapters.md`
- `docs/security-privacy.md`
- `.env.example`
- README section for AI-disabled mode.

### Acceptance Criteria

- OT Math still works fully without AI.
- AI cannot directly execute code.
- AI cannot bypass deterministic validation.
- Provider docs clearly state users must supply their own keys for cloud providers.
- Local provider path is documented as preferred long-term default.

### Handoff Point

Hand off to Phase 5 when natural-language parsing can be added without changing engine internals.

## Phase 5: VS Code Extension

### Purpose

Create a VS Code extension that connects editor workflows to the local `otcalc` or `otmath` engine.

### Components

- TypeScript extension package.
- Commands for solve selection, explain selection, render LaTeX, and insert result.
- Local process bridge to CLI or JSON-RPC server.
- Settings for Python path, provider mode, and privacy behavior.
- Output channel.
- Error reporting.

### Dependencies

- Node.js.
- VS Code extension API.
- OT Math CLI.
- TypeScript test tooling.

### Contributions

- Implement extension activation.
- Register commands.
- Add local CLI bridge.
- Add workspace settings.
- Add basic command tests.
- Add docs for extension development.

### Checkpoints

- Extension activates without errors.
- A selected expression can be sent to `otcalc`.
- Result can be inserted or shown in a panel.
- User can force `provider=none`.
- Errors guide the user to install or configure the Python package.

### Test Requirements

- TypeScript unit tests for command assembly.
- Extension smoke test.
- Tests for paths with spaces.
- Tests for provider mode setting.
- Manual QA checklist in docs.

### Documentation Updates

- `extensions/vscode-otmath/README.md`
- `docs/vscode-extension.md`
- README roadmap status.

### Acceptance Criteria

- Extension has no bundled API keys.
- Extension only sends data to configured local/remote providers with user consent.
- Extension can work entirely offline.
- Commands are discoverable in the command palette.

### Handoff Point

Hand off to Phase 6 when editor workflows can call the local engine reliably.

## Phase 6: LaTeX Integration

### Purpose

Make OT Math useful in `.tex` workflows without locking users into a specific editor.

### Components

- LaTeX package placeholder.
- CLI commands for generating LaTeX snippets.
- Documentation for shell escape risks.
- Optional build helper script.
- Examples showing equations and solutions.

### Dependencies

- OT Math CLI.
- TeX distribution for integration testing.

### Contributions

- Define `otmath.sty` macros.
- Add examples under `examples/latex`.
- Add CLI output mode for aligned steps.
- Document safe usage patterns.
- Add optional local-only helper scripts.

### Checkpoints

- `otcalc latex` returns compilable equation snippets.
- Example `.tex` document compiles manually.
- Docs warn clearly about shell escape.
- LaTeX integration remains optional.

### Test Requirements

- Unit tests for LaTeX rendering.
- Golden-file tests for snippets.
- Optional compile test if TeX is available.
- CI must skip TeX compile gracefully when TeX is missing.

### Documentation Updates

- `integrations/latex/README.md`
- `docs/latex.md`
- README integration section.

### Acceptance Criteria

- Generated LaTeX is syntactically valid for supported cases.
- The integration does not require remote services.
- Users understand any security tradeoffs.

### Handoff Point

Hand off to Phase 7 when LaTeX output is stable enough for examples and editor workflows.

## Phase 7: Configuration, Privacy, And Persistence

### Purpose

Add durable configuration while preserving local-first privacy guarantees.

### Components

- Config file discovery.
- Provider settings.
- Local history option.
- Redaction utilities.
- Telemetry disabled by default.
- Privacy mode presets.

### Dependencies

- Python standard library.
- Optional platform-specific config directory helper.

### Contributions

- Define config schema.
- Add `otcalc config` commands.
- Add `.env.example`.
- Add privacy mode docs.
- Add tests for config loading and precedence.
- Add migration strategy for config changes.

### Checkpoints

- Defaults require no config file.
- Users can opt into local history.
- Users can opt into cloud provider use.
- Sensitive values do not appear in ordinary logs.
- Config precedence is documented.

### Test Requirements

- Config loading tests.
- Environment variable precedence tests.
- Redaction tests.
- Tests for missing and malformed config.
- No tests depend on actual secrets.

### Documentation Updates

- `docs/configuration.md`
- `docs/security-privacy.md`
- README privacy section.

### Acceptance Criteria

- Local-first remains the default behavior.
- No telemetry is introduced without explicit opt-in.
- Secrets are never committed.
- Provider keys are always user-owned.

### Handoff Point

Hand off to Phase 8 when persistence and provider configuration are clear and tested.

## Phase 8: Packaging, CI, And Releases

### Purpose

Prepare the project for open-source collaboration and repeatable releases.

### Components

- GitHub Actions CI.
- Package metadata.
- Build checks.
- Release checklist.
- Changelog.
- Versioning policy.
- Optional package publishing workflow.

### Dependencies

- GitHub Actions.
- Python packaging tools.
- Node build tooling for extension package.

### Contributions

- Add CI matrix.
- Add lint, type, and test jobs.
- Add package build job.
- Add release notes template.
- Add changelog conventions.
- Add dependency update policy.

### Checkpoints

- CI runs on pull requests.
- Python package builds locally.
- Extension placeholder has a build path.
- Release checklist is documented.
- Version source is clear.

### Test Requirements

- CI runs Python tests.
- CI runs lint and type checks.
- Extension tests are included once implementation exists.
- Optional jobs skip gracefully when optional toolchains are absent.

### Documentation Updates

- `docs/release.md`
- `CHANGELOG.md`
- README badge placeholders.

### Acceptance Criteria

- Contributors can verify changes before opening a pull request.
- Maintainers can cut a release from documented steps.
- The project does not publish broken packages accidentally.

### Handoff Point

Hand off to Phase 9 when packaging and release process are repeatable.

## Phase 9: Advanced Math Domains

### Purpose

Expand OT Math beyond starter algebra and calculus while maintaining deterministic, tested behavior.

### Components

- Linear algebra.
- Statistics.
- Discrete math.
- Equation systems.
- Numeric solving.
- Units and dimensional analysis.
- Assumptions and domains.

### Dependencies

- SymPy.
- NumPy.
- SciPy.
- Optional Pint for units.

### Contributions

- Add domain modules.
- Add domain-specific request models.
- Add examples and docs for each domain.
- Add benchmarks for larger calculations.
- Add validation and warnings for numeric precision.

### Checkpoints

- Each new domain has tests and docs.
- Domain operations expose stable public APIs.
- Numeric answers include precision metadata.
- Unsupported domains fail clearly.

### Test Requirements

- Unit tests per domain.
- Regression tests for known tricky cases.
- Numeric tolerance tests.
- Performance smoke tests.
- Cross-checks against known results.

### Documentation Updates

- Domain-specific docs under `docs/math-domains`.
- Examples under `examples`.
- README capability matrix.

### Acceptance Criteria

- New domains do not destabilize existing workflows.
- Every operation has documented input syntax.
- Results remain reproducible.

### Handoff Point

Hand off to Phase 10 when core domains are broad enough for external beta users.

## Phase 10: Beta Readiness And Community

### Purpose

Make OT Math approachable for real users and sustainable for contributors.

### Components

- Beta documentation.
- Contributor onboarding.
- Issue triage process.
- Community guidelines.
- Example gallery.
- Feedback collection.

### Dependencies

- Stable CLI.
- Useful engine coverage.
- Minimal editor or LaTeX integration.

### Contributions

- Write getting-started tutorials.
- Add beginner issues.
- Add maintainer triage labels.
- Add contribution examples.
- Add roadmap review process.
- Add privacy-first beta guidance.

### Checkpoints

- A new user can install and solve a problem.
- A new contributor can run tests and make a small change.
- Maintainers can triage issues consistently.
- Known limitations are visible.

### Test Requirements

- End-to-end smoke tests.
- Install-from-source test.
- Documentation command verification.
- Extension and LaTeX manual QA where relevant.

### Documentation Updates

- `docs/getting-started.md`
- `docs/community.md`
- `docs/known-limitations.md`
- Example gallery.

### Acceptance Criteria

- The project is usable without maintainer guidance.
- Privacy posture is understandable to non-experts.
- Contribution path is clear.
- Release and support expectations are public.

### Handoff Point

Hand off to ongoing maintenance after beta feedback is captured and prioritized.

## Cross-Phase Definition Of Done

Every phase should satisfy these before completion:

- Code is scoped to the phase.
- Tests are added or updated for changed behavior.
- Documentation is updated in the same change.
- Public APIs are named intentionally.
- Privacy impact is reviewed.
- Security risks are documented or mitigated.
- No secrets are committed.
- No network behavior is added to default tests.
- The next handoff point is clear.

## Contribution Categories

All work should fit one of these categories:

- Engine behavior.
- CLI behavior.
- AI adapter behavior.
- Editor integration.
- LaTeX integration.
- Documentation.
- Tests and quality.
- Security and privacy.
- Packaging and release.
- Examples and education.
- Community and governance.

If a contribution does not fit a category, update this document before implementing it.
