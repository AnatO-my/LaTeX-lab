# Architecture

OT Math is organized around a deterministic core and optional adapters.

## System Overview

```text
Interfaces
  CLI, VS Code, LaTeX, future UI
      |
      v
Application layer
  otcalc commands, formatting, config, privacy controls
      |
      v
Optional AI adapter
  none, local, user-configured cloud providers
      |
      v
Structured request
  operation, expression, variable, assumptions
      |
      v
Deterministic engine
  parse, solve, simplify, render, verify
```

## Package Boundaries

### `otmath`

The deterministic math package. It owns:

- Request and result models.
- Parsing boundary.
- Engine operations.
- Step generation.
- LaTeX rendering.
- Verification helpers.
- AI adapter interfaces, but not provider-specific secrets.

### `otcalc`

The CLI package. It owns:

- Command parsing.
- Output formatting.
- Exit codes.
- Config commands.
- Local workflow conveniences.

The CLI should call public `otmath` APIs only.

### `extensions/vscode-otmath`

The VS Code extension. It should call local OT Math through the CLI or a future local JSON-RPC bridge.

The extension must not contain API keys, hard-coded cloud endpoints for private data, or hidden telemetry.

### `integrations/latex`

The LaTeX integration. It should prefer generated snippets over shell execution. Any shell escape workflow must be optional and clearly documented.

## Deterministic Authority

The deterministic engine is the source of truth for mathematical answers. AI providers may:

- Convert natural language into structured requests.
- Draft explanations.
- Suggest next steps.

AI providers may not:

- Execute arbitrary code.
- Bypass validation.
- Become required for core math.
- Store secrets in the repository.

## Data Flow

1. User enters a structured command or natural-language prompt.
2. If AI is disabled, the CLI/editor sends a structured request directly.
3. If AI is enabled, the provider returns a structured request candidate.
4. OT Math validates the request.
5. The deterministic engine runs the operation.
6. Result renderers produce text, JSON, and LaTeX.
7. Interfaces display or insert the result.

## Privacy Boundary

Any feature that can send data outside the user's machine must be explicit, documented, and opt-in. Local-first behavior is the default.
