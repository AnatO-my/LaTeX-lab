# Phase 4 Checkpoint 4G — Complete PHY104 structured migration

## Scope

This checkpoint migrates all 60 records from the representative
`examples/physicsquiz/PHY104_Exam revision.tex` source into the accepted
structured question-bank interface. The legacy source remains in place as the
fidelity baseline; this checkpoint adds a structured counterpart and does not
replace the canonical file during local acceptance.

## Migration contract

Every record preserves:

- the original question stem;
- all five choices and their order;
- the correct answer;
- the complete worked-solution reasoning after moving the legacy topic label
  into metadata;
- the original declaration order from Question 1 through Question 60.

Stable IDs retain original question numbers. Examples are `phy104-osc-001`,
`phy104-nm-026`, `phy104-wave-053`, and `phy104-opt-060`.

The established metadata scheme is applied consistently:

| Original range | Difficulty | Marks per question |
|---|---|---:|
| 1--20 | foundation | 1 |
| 21--40 | applied | 2 |
| 41--60 | challenge | 3 |

Each repeated five-question block maps to oscillations, normal modes, waves and
sound, or optics. Every question also has question-specific tags and a learning
outcome. The complete bank therefore contains 60 records and 120 marks.

## Files

- `examples/physicsquiz/banks/phy104_full_question_bank.tex`
- `examples/physicsquiz/PHY104_structured_revision.tex`
- `tests/physicsquiz_full_migration_document.tex`
- `tests/physicsquiz_full_migration_all.tex`
- `tests/physicsquiz_full_migration_foundation.tex`
- `tests/physicsquiz_full_migration_applied.tex`
- `tests/physicsquiz_full_migration_challenge.tex`
- `tests/physicsquiz_full_migration_ids.tex`
- `tests/physicsquiz_full_migration_metadata.tex`
- `tests/physicsquiz_full_migration_tags.tex`
- `tests/physicsquiz_full_migration_random.tex`
- `tests/physicsquiz_full_migration_random_repeat.tex`
- `tests/check_physicsquiz_full_migration.py`
- `tests/run_physicsquiz_phase4g_tests.ps1`

## Acceptance contract

The automated checker verifies all 60 stems, all 300 choices, all 60 answers,
all 60 worked solutions, record order, stable IDs, topic/difficulty/mark
metadata, tags, and outcomes against the legacy source. It also checks:

- complete declaration-order selection;
- complete generated answer and solution coverage in three 20-question bands;
- deliberately reordered ID selection;
- combined topic-and-difficulty filtering;
- tag filtering across difficulty bands;
- reproducible 12-question random selection with seed 104;
- selected answer-key and solution alignment;
- the 60-record, 120-mark bank totals;
- the accepted Phase 4F regression suite;
- clean compilation of the complete structured example.

The complete example divides its generated answer key into the three established
20-question difficulty bands, because one 60-entry answer-key box is taller than
a page. Its worked solutions remain one ordered 60-question selection. The
optional per-question topic report is intended for selected subsets and is
exercised by the ID, metadata, tag, and random drivers.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4g_tests.ps1
```

Expected ending:

```text
All Phase 4G full-migration checks passed.
All Phase 4G tests passed.
```

Do not replace or delete the legacy `PHY104_Exam revision.tex` until this suite
passes locally and the complete, filtered, reordered, and random PDFs have been
reviewed visually. Keep generated PDFs and logs out of the source commit.
