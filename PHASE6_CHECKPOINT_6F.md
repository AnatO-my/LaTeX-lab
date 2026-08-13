# Phase 6 Checkpoint 6F - Versioned-paper review guard

## Scope

Checkpoint 6F closes the Phase 4 carry-forward item for the representative
versioned PHY104 paper.

The checkpoint does not change author syntax. It builds generated Version A and
Version B copies from `examples/physicsquiz/PHY104_versioned_paper.tex` so the
example file itself does not need to be edited during verification.

## Outcome

The new runner proves that:

* Version A and Version B both compile from the same authored paper structure.
* Each build activates the intended `\quizuseversion` recipe.
* The two versions select different question sets.
* The two versions produce different option permutations.
* The answer key agrees with the generated worked-solution headings.
* The generated PDF byte sizes differ, which is a weak but useful output signal.

The runner still records that automated logs cannot replace a human visual
inspection of the final shuffled booklet.

## Files

* `tests/run_phase6f_tests.ps1`
* `tests/check_physicsquiz_versioned_visual.py`

## Production change

`physicsquiz.cls` now emits `PQ6F-SOLUTION-ANSWER:<id>=<letter>` while rendering
worked solutions. This mirrors the answer already printed in the solution box
heading and gives regression tests a log-level way to compare solution headings
with answer-key entries.

No PDF text, layout, author command, selection rule, or shuffle rule is changed.

## Verification

Run:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_phase6f_tests.ps1
```

Expected final line:

```text
All Phase 6F tests passed.
```
