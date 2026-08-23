# ADR 0002: Python Core And TypeScript Extension

## Status

Accepted

## Context

Python has the strongest ecosystem for symbolic and numerical math. VS Code extensions are built in TypeScript.

## Decision

Use Python for `otmath` and `otcalc`. Use TypeScript for the VS Code extension. Communicate through CLI JSON output first, with JSON-RPC as a possible future bridge.

## Consequences

- The engine and extension can evolve independently.
- The CLI becomes a stable integration surface.
- Contributors need clear docs for both Python and TypeScript toolchains.
