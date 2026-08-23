# Codex Phase Prompts

Use these prompts to start focused Codex tasks. Each prompt assumes the repository scaffold already exists and asks Codex to inspect the current code before editing.

## Phase 0 Prompt: Verify Scaffold

```text
You are working in the OT Math repository. Inspect the scaffold and verify that it is ready for open-source development. Do not rewrite everything. Check that README.md, PROJECT_PHASES.md, PHASE_PROMPTS.md, pyproject.toml, docs, tests, issue templates, ADRs, VS Code placeholder, LaTeX placeholder, and package folders are present and coherent.

Then make the smallest changes needed so a new contributor can install the package, run tests, and understand the roadmap. Update TREE.md after any structural changes. Run the available tests. Summarize what changed, what passed, and what remains.
```

## Phase 1 Prompt: Deterministic Core Engine

```text
You are implementing Phase 1 from PROJECT_PHASES.md for OT Math. Read README.md, PROJECT_PHASES.md, docs/architecture.md, docs/testing-strategy.md, docs/security-privacy.md, and existing src/otmath files before editing.

Goal:
Build the first reliable deterministic math engine without adding AI or network behavior.

Required work:
- Strengthen request/result models.
- Add solve, simplify, expand, factor, differentiate, and integrate operations.
- Add clear exceptions and validation.
- Add LaTeX rendering.
- Add verification metadata where practical.
- Keep public imports stable through otmath.__init__.
- Prevent arbitrary Python execution.
- Add examples and docs for supported syntax.
- Add or update tests for every operation and failure path.

Acceptance criteria:
- All tests pass offline.
- Every supported operation is documented.
- Invalid input fails clearly.
- No provider keys, network calls, telemetry, or hidden persistence are introduced.
- README quick start remains accurate.

Handoff:
Update PROJECT_PHASES.md only if scope changes. Add a short completion note to docs/roadmap.md or CHANGELOG.md if the repository has adopted that convention.
```

## Phase 2 Prompt: CLI Workflow

```text
You are implementing Phase 2 from PROJECT_PHASES.md for OT Math. Inspect src/otmath, src/otcalc, tests, README.md, docs/architecture.md, and docs/testing-strategy.md.

Goal:
Make otcalc a practical local CLI for the deterministic engine.

Required work:
- Add subcommands for solve, simplify, expand, factor, diff, integrate, and latex where the engine supports them.
- Add --format text|json|latex.
- Add --variable where applicable.
- Add --provider none and --no-ai compatibility flags without implementing AI calls.
- Add predictable exit codes.
- Add friendly errors.
- Add CLI tests for success and failure.
- Add docs/cli.md and examples/cli.
- Update README commands.

Acceptance criteria:
- CLI works without network access.
- JSON output is parseable.
- CLI behavior matches engine behavior.
- Help text is useful.
- Tests cover text, JSON, LaTeX, and error modes.

Handoff:
Document any known shell quoting issues and pass a stable CLI surface to future VS Code and LaTeX phases.
```

## Phase 3 Prompt: Explanation Steps

```text
You are implementing Phase 3 from PROJECT_PHASES.md. Read engine models and docs first.

Goal:
Add deterministic, structured explanation steps for common operations.

Required work:
- Define MathStep data model.
- Add step types and metadata.
- Implement rule-based steps for at least quadratic solving, simplification, and differentiation.
- Add text and LaTeX renderers for steps.
- Ensure final answer verification is separate from explanation generation.
- Add tests for serialization, rendering, and known step sequences.
- Add docs/explanations.md.

Acceptance criteria:
- Step output is structured data, not only prose.
- Unsupported step generation degrades gracefully.
- Final answers still come from the deterministic engine.
- Tests pass offline.
```

## Phase 4 Prompt: AI Adapter Boundary

```text
You are implementing Phase 4 from PROJECT_PHASES.md. Read docs/security-privacy.md and docs/architecture.md carefully before editing.

Goal:
Introduce optional AI adapter interfaces without changing the deterministic authority of the engine.

Required work:
- Define AIProvider protocol.
- Implement NoAIProvider as the default.
- Implement a fake provider for tests.
- Define structured output schema for natural-language-to-MathRequest parsing.
- Validate all provider output before engine execution.
- Add provider selection logic with provider=none as the default.
- Add .env.example and docs/ai-adapters.md.
- Add tests for malformed provider output, fake provider success, redaction, and no-network defaults.

Acceptance criteria:
- OT Math remains fully usable with AI disabled.
- No live provider calls run in default tests.
- No shared API keys are added.
- Cloud provider docs require user-owned keys.
- Local provider path is documented as preferred.
```

## Phase 5 Prompt: VS Code Extension

```text
You are implementing Phase 5 from PROJECT_PHASES.md. Inspect extensions/vscode-otmath, src/otcalc, README.md, and docs/security-privacy.md.

Goal:
Create a working VS Code extension shell that calls the local OT Math CLI.

Required work:
- Set up TypeScript build and test scripts.
- Register commands for solving selected expression, inserting LaTeX, and showing output.
- Add settings for Python path, otcalc path, provider mode, and privacy mode.
- Call the local CLI using JSON output.
- Handle paths with spaces.
- Add extension tests or command assembly tests.
- Update extension README and docs/vscode-extension.md.

Acceptance criteria:
- Extension activates.
- Commands are discoverable.
- Selected text can be sent to the local CLI.
- No bundled keys or hidden network behavior exist.
- Offline mode is first-class.
```

## Phase 6 Prompt: LaTeX Integration

```text
You are implementing Phase 6 from PROJECT_PHASES.md. Inspect integrations/latex, src/otmath renderers, src/otcalc, and docs/security-privacy.md.

Goal:
Make LaTeX output and placeholder package useful for local documents.

Required work:
- Implement or refine LaTeX output mode.
- Add aligned-step rendering if steps exist.
- Update integrations/latex/otmath.sty with documented macros.
- Add examples/latex/sample.tex.
- Add docs/latex.md with shell escape security notes.
- Add golden tests for generated LaTeX snippets.
- Optional TeX compile test must skip gracefully when TeX is unavailable.

Acceptance criteria:
- Supported LaTeX snippets are compilable.
- LaTeX integration is optional.
- Security risks of shell escape are documented.
- Tests pass without requiring a TeX install.
```

## Phase 7 Prompt: Configuration And Privacy

```text
You are implementing Phase 7 from PROJECT_PHASES.md. Read docs/security-privacy.md, current config code, and CLI code.

Goal:
Add durable configuration while keeping local-first defaults.

Required work:
- Define config file locations and precedence.
- Add typed config model.
- Add otcalc config commands.
- Add opt-in local history.
- Add secret redaction utilities.
- Add privacy mode presets.
- Add tests for config loading, environment variables, malformed config, redaction, and no-secret logging.
- Update .env.example and docs/configuration.md.

Acceptance criteria:
- No config file is required.
- No telemetry is introduced.
- Cloud provider use is explicit.
- Sensitive values are redacted.
- Defaults remain offline.
```

## Phase 8 Prompt: Packaging, CI, And Release

```text
You are implementing Phase 8 from PROJECT_PHASES.md. Inspect pyproject.toml, package layout, extension layout, tests, docs, and .github workflows.

Goal:
Make builds, checks, and releases repeatable.

Required work:
- Add or refine GitHub Actions CI.
- Run Python tests, lint, type checks, and package build.
- Add extension build checks once the extension has implementation.
- Add docs/release.md.
- Add or update CHANGELOG.md.
- Add versioning policy.
- Add release checklist.
- Ensure optional toolchains skip gracefully or are clearly separated.

Acceptance criteria:
- Contributors can run local checks before a pull request.
- CI does not require secrets for normal pull requests.
- Package metadata is valid.
- Release steps are documented.
```

## Phase 9 Prompt: Advanced Math Domains

```text
You are implementing Phase 9 from PROJECT_PHASES.md. Inspect current engine modules, tests, and domain docs.

Goal:
Add one advanced math domain in a focused, tested way.

Required work:
- Choose exactly one domain for this task: linear algebra, statistics, systems, numeric solving, discrete math, or units.
- Add domain models and operations.
- Add public API exports.
- Add CLI coverage if appropriate.
- Add tests, examples, and docs.
- Add precision or assumptions metadata where relevant.

Acceptance criteria:
- Existing engine and CLI behavior does not regress.
- New domain is documented.
- Tests cover normal, edge, and failure cases.
- Numeric behavior states tolerances clearly.
```

## Phase 10 Prompt: Beta Readiness

```text
You are implementing Phase 10 from PROJECT_PHASES.md. Inspect docs, examples, issue templates, README.md, tests, and current release notes.

Goal:
Prepare OT Math for beta users and outside contributors.

Required work:
- Add getting-started docs.
- Add known limitations.
- Add example gallery.
- Add contributor onboarding tasks.
- Add triage labels documentation.
- Verify install-from-source instructions.
- Verify end-to-end CLI examples.
- Update roadmap and changelog.

Acceptance criteria:
- A new user can install and solve a problem.
- A new contributor can run tests and find a small task.
- Privacy posture is clear.
- Known limitations are visible.
```

## General Maintenance Prompt

```text
You are maintaining OT Math. Before editing, inspect the files relevant to the requested change and read PROJECT_PHASES.md to understand project boundaries.

Rules:
- Keep deterministic math authoritative.
- Preserve provider=none behavior.
- Do not add secrets.
- Do not add network behavior to default tests.
- Update tests and docs with behavior changes.
- Keep changes scoped.
- Run the relevant checks.

When finished, summarize files changed, tests run, and any handoff notes.
```
