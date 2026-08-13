# Phase 7 Checkpoint 7C - Copyable Starter Set

## Scope

Checkpoint 7C turns the starter inventory into small, copyable source files and
a fast verification runner. It does not change any class or package behaviour.

## Added

* `examples/physicsquiz/starter_versioned_quiz.tex`
* `examples/studentnotes/starter_notes.tex`
* `examples/otengineering/starter_engineering_notes.tex`
* `examples/otscience/starter_science_notes.tex`
* `examples/vector-workbook/starter_module.tex`
* `tests/run_phase7c_starter_tests.ps1`

The existing `examples/physicsquiz/starter_quiz_bank.tex` remains the structured
quiz-bank starter and now emits a Phase 7C starter marker for the runner.

## Outcome

The repository now has a small starter for each major author outcome:

* a structured quiz bank;
* a versioned quiz paper;
* a personal study-notes handout;
* an engineering project notebook;
* a science notes document; and
* a standalone workbook module.

## Verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase7c_starter_tests.ps1
```

The runner builds only the starter documents and checks their log markers, so it
is intentionally faster and smaller than the historical regression suites.
