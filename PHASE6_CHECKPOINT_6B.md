# Phase 6 Checkpoint 6B - Physicsquiz capability marker

## Scope

Checkpoint 6B is the first production Phase 6 change. It adds public, expandable
version and capability markers to `physicsquiz.cls` without changing quiz
rendering, selection, shuffling, metadata validation, or class options.

## Added public markers

`physicsquiz.cls` now provides:

```latex
\physicsquizclassversion
\physicsquizstructuredinterfaceversion
\physicsquizstructuredinterfaceid
```

Their current values are:

| Command | Value | Purpose |
| --- | --- | --- |
| `\physicsquizclassversion` | `0.1` | First explicit semantic class version |
| `\physicsquizstructuredinterfaceversion` | `1` | Structured quiz interface capability version |
| `\physicsquizstructuredinterfaceid` | `physicsquiz-structured-v1` | Stable readable capability identifier |

The class declaration now also carries `v0.1`:

```latex
\ProvidesClass{physicsquiz}[2026/08/12 v0.1 Stylish physics quiz class]
```

## Conservation decisions

The following structures are deliberately preserved in 6B:

* traditional `\DeclareOption` class options;
* the existing `\quizversion`, `\quizdefineversion`, and `\quizuseversion`
  syntax;
* five-option-only shuffling through `\choices`;
* the current class error for shuffled `choiceoptions` records; and
* existing question-bank metadata validation behaviour.

These are not being frozen permanently. They are preserved here because the 6B
product is only a public capability marker; changing any of those structures
would require a broader compatibility audit.

## Dirty-working-tree note

Before 6B began, `src/classes/physicsquiz.cls` already had a large unstaged
formatting diff plus a small non-whitespace marks-regex change. Checkpoint 6B
does not resolve or revert that pre-existing change. Stage this checkpoint
carefully if committing.

## Verification

`tests/physicsquiz_capability_marker_smoke.tex` loads `physicsquiz.cls`, prints
the three marker values, declares one structured question, selects it, and runs
the existing bank and selection assertions.

`tests/run_phase6b_tests.ps1` runs the Phase 6A learning scaffold first, then
builds the 6B capability smoke and checks all expected markers.

Accepted on 12 August 2026:

```text
All Phase 6B tests passed.
```

The established Phase 4I/4J regression guard also passed after the 6B production
marker change:

```text
PASS expected failure: physicsquiz_version_already_active
All Phase 4I/4J tests passed.
```
