# Phase 6 Checkpoint 6A - Conservative modernization opening

## Scope

Checkpoint 6A opens Phase 6 without changing production class or package
behaviour.

The purpose is to establish the conservative modernization model in repository
terms, add a small isolated learning scaffold, and identify the first production
decisions that require user approval before implementation.

## Conservative modernization model

Phase 6 preserves existing author-facing structures unless a modern LaTeX change
improves safety, maintainability, validation, or local usability.

Modernization is appropriate when it:

* makes an existing interface easier to validate;
* makes errors more local and descriptive;
* clarifies which commands are public and which are internal;
* removes fragile internal state handling; or
* adds a capability marker that documents an already-supported feature.

Modernization is not appropriate when it only rewrites stable code into newer
syntax for style.

## User check-in rule

Any meaningful decision to preserve an old structure must be checked with the
user unless changing it would require a broad breakage audit for little practical
gain.

For Phase 6, this means user approval is required before deciding to preserve or
change:

* the traditional `physicsquiz.cls` class-option layer;
* the five-option-only shuffling contract for `\choices`;
* the current rejection of shuffled `choiceoptions` records;
* the current version-manifest syntax;
* the legacy PHY104 source's role after the structured bank is accepted; and
* whether `physicsquiz.cls` should expose a public structured-interface version
  or capability marker.

## Added learning scaffold

`tests/phase6_modern_interface_examples.tex` is an isolated compile-only
learning document. It demonstrates:

* `\NewDocumentCommand`;
* modern optional arguments;
* an `expl3` key-value configuration family;
* token-list and boolean storage; and
* a named `expl3` error message.

It deliberately does not load `physicsquiz.cls` and does not define a public
project interface. It exists so Phase 6 concepts can be tested before production
code changes are proposed.

`tests/run_phase6a_tests.ps1` builds the learning document and checks its marker
lines.

## First production candidates

The first production candidates for later Phase 6 checkpoints are:

1. add a public structured-interface version or capability marker to
   `physicsquiz.cls`;
2. audit existing `expl3` names in `physicsquiz.cls` for namespace consistency;
3. improve selected class errors without changing failure conditions;
4. decide whether class options should stay traditional or move to a modern key
   layer; and
5. decide the legacy PHY104 source's long-term role.

Checkpoint 6A makes no production-class decision on those items.

## Verification

Checkpoint 6A is accepted when:

1. the isolated learning document compiles;
2. its expected marker lines appear in the log;
3. the Phase 6A runner parses in PowerShell; and
4. no production class or package source is changed.

Accepted on 12 August 2026:

```text
All Phase 6A tests passed.
```
