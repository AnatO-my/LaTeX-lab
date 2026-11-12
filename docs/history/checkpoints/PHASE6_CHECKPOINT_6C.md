# Phase 6 Checkpoint 6C - Physicsquiz namespace discipline

## Scope

Checkpoint 6C audits the existing `physicsquiz.cls` modern-code boundary before
any larger production refactor. It adds a source checker and runner, but makes no
intentional rendering, selection, shuffling, validation, or class-option changes.

## Namespace rules checked

The checker verifies that:

* `physicsquiz.cls` has a single bounded `expl3` region;
* project-local internal functions and variables use the `__pq` module;
* the public wrappers declared with `\NewDocumentCommand`,
  `\RenewDocumentCommand`, and `\NewDocumentEnvironment` match the known
  documented surface;
* internal key families remain limited to `physicsquiz / question` and
  `physicsquiz / selection`;
* the legacy `\pqchoiceoptionsguard` bridge is present exactly once; and
* the Phase 6B capability markers remain declared.

## Conservation decisions

6C deliberately preserves the existing author syntax. The modern `expl3` layer
stays behind stable commands and environments such as `quizbank`,
`quizquestion`, `\quizselect`, `\printquizquestions`, `\choices`, and the
version-manifest commands.

The `\pqchoiceoptionsguard` bridge is allowed as an internal compatibility
bridge for the older `choiceoptions` path. It is not promoted to ordinary author
syntax.

6C does not resolve the pre-existing dirty working-tree change in
`src/classes/physicsquiz.cls`: the large formatting diff plus the small
non-whitespace marks-regex change remain outside this checkpoint.

## Verification

`tests/check_physicsquiz_namespace.py` performs the source audit and prints
`PQ6C-NAMESPACE:*` markers.

`tests/run_phase6c_tests.ps1` reruns the 6B checkpoint first, then runs the 6C
namespace checker and verifies all expected markers.

Accepted on 12 August 2026:

```text
All Phase 6C tests passed.
```
