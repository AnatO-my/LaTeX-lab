# Phase 4 Checkpoint 4F — Real-question migration pilot

## Scope

This checkpoint migrates a deliberately small, auditable subset of the real
`PHY104_Exam revision.tex` source into the structured question-bank interface.
It does not modify or replace the 60-question legacy quiz.

## Pilot matrix

The bank contains 12 records: one question from every combination of the four
course topics and the three established difficulty levels.

| Topic | Foundation | Applied | Challenge |
|---|---:|---:|---:|
| Oscillations | 1 | 21 | 41 |
| Normal modes | 6 | 26 | 46 |
| Waves and sound | 11 | 31 | 51 |
| Optics | 16 | 36 | 60 |

The stable ID retains the original question number, for example
`phy104-nm-026`. Marks follow the pilot rule: foundation = 1, applied = 2,
challenge = 3.

## Files

- `examples/physicsquiz/banks/phy104_migration_pilot_bank.tex`
- `examples/physicsquiz/PHY104_migration_pilot.tex`
- `tests/physicsquiz_migration_pilot_document.tex`
- `tests/physicsquiz_migration_pilot_ids.tex`
- `tests/physicsquiz_migration_pilot_metadata.tex`
- `tests/physicsquiz_migration_pilot_random.tex`
- `tests/physicsquiz_migration_pilot_random_repeat.tex`
- `tests/check_physicsquiz_migration_pilot.py`
- `tests/run_physicsquiz_phase4f_tests.ps1`

## Acceptance contract

The checker verifies that all 12 migrated records preserve:

- the original question stem;
- all five choices and their order;
- the correct option;
- the worked-solution reasoning after the legacy topic label is moved into
  structured metadata.

It also verifies:

- explicit ID selection preserves requested order;
- metadata selection preserves declaration order;
- seed 104 reproduces the same five-question selection;
- generated answer keys and solutions remain aligned with each selection;
- the accepted Phase 4E regression suite still passes.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4f_tests.ps1
```

Expected ending:

```text
All Phase 4F migration-pilot checks passed.
All Phase 4F tests passed.
```

Do not migrate the remaining 48 questions until this pilot has passed locally
and its generated PDFs have been reviewed.
