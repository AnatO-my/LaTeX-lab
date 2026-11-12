# Phase 6 Checkpoint 6D - Marks decimal validation

## Scope

Checkpoint 6D resolves the carried dirty marks-regex question in
`physicsquiz.cls`. It keeps the previously accepted leading-zero decimal form,
such as `0.5`, and also accepts the shorthand leading-dot form, such as `.5`.

This is a narrow validation improvement. It does not change rendering,
selection order, shuffling, class options, question-bank storage, or version
manifests.

## Outcome

Structured question metadata and marks filters now accept these positive marks
forms:

* integers, such as `1`;
* whole-number decimals, such as `1.5`;
* leading-zero fractional decimals, such as `0.5`; and
* leading-dot fractional decimals, such as `.5`.

Zero and zero-equivalent decimals, such as `0`, `0.0`, and `.0`, remain invalid.

## Conservation decision

The conservative choice is to preserve existing documents that already use
`0.5` while allowing the local shorthand `.5` style as an additive convenience.
This avoids turning the pre-existing dirty edit into a breaking change.

## Verification

`tests/physicsquiz_marks_decimal_smoke.tex` declares questions with integer,
standard decimal, leading-zero fractional, and leading-dot fractional marks. It
then filters the same two half-mark questions with both `marks=0.5` and
`marks=.5`.

`tests/run_phase6d_tests.ps1` reruns 6C first, builds the 6D smoke, and checks
the expected bank and selection assertion markers.

Accepted on 12 August 2026:

```text
All Phase 6D tests passed.
```
