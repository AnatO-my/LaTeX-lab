# Phase 4 Checkpoint 4E: seeded reproducible random selection

## Outcome

Checkpoint 4E adds controlled random selection to the accepted Phase 4D
question-bank interface. It does not alter deterministic selection, structured
record declarations, legacy quiz syntax, output modes, or presentation modes.

The representative 60-question quiz and `examples/studentnotes/Optics.tex`
remain unchanged.

## Public author interface

Declare the complete structured bank as before:

```latex
\begin{quizbank}
  \input{banks/phy104-bank.tex}
\end{quizbank}
```

Select a reproducible random subset with an explicit count and seed:

```latex
\quizselectrandom{20}{20260806}
\printquizquestions[2]
```

The command signature is:

```latex
\quizselectrandom[<metadata filters>]{<count>}{<seed>}
```

The optional filters use the same keys and AND semantics as deterministic
`\quizselect`:

```latex
\quizselectrandom[
  topic=optics,
  difficulty=applied,
  marks=2,
  tags={diffraction,grating}
]{5}{104}
```

An empty optional filter means all eligible declared records. The count must be
a positive integer. The seed must be an integer from 1 to 2147483646.

## Reproducibility contract

The same:

- declared bank and declaration order;
- existing selection state;
- metadata filter;
- requested count; and
- seed

produce the same ordered stable IDs.

The implementation uses a class-owned Park-Miller generator, Schrage's
overflow-safe update, rejection sampling, and a Fisher-Yates permutation. It
does not depend on a clock, job name, engine random primitive, or ambient
random state. The algorithm marker is `park-miller-v1`; changing that algorithm
in a future release would be a documented compatibility change.

Different seeds are permitted to produce the same result by chance; they are
not guaranteed to differ. The test bank uses comparison seeds that are known to
produce different selections.

## Append and filtering semantics

- `\quizselectrandom` appends to the current selection.
- Already selected records are excluded from its candidate pool.
- The command adds exactly the requested number of new records.
- Candidate filtering uses topic, difficulty, exact marks, and match-all tags.
- `\quizclearselection` restores all matching records to eligibility.
- The generated booklet, answer key, reports, solutions, and totals use the
  final selection order.

Invalid counts, invalid seeds, insufficient candidate counts, exhausted pools,
and filters with no eligible records produce class errors.

## Local integration

From this checkpoint:

1. replace `src/classes/physicsquiz.cls`;
2. copy the files under `tests` into the repository's `tests` directory; and
3. keep the accepted Phase 3D, 4C, and 4D test sources available.

Do not copy this Markdown file unless you want to retain it as a checkpoint
note. Do not stage generated PDFs, logs, auxiliary files, checkpoint notes, or
the unrelated `Optics.tex` modification.

## One-command verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4e_tests.ps1
```

The runner:

1. reruns the complete accepted Phase 4D suite, which includes 4C and 3D;
2. compiles the same seeded selection in all five output modes;
3. proves same-seed reproducibility and a different-seed comparison;
4. verifies filtered, append, and full-permutation selection;
5. checks selected-only questions, answers, solutions, reports, totals, PDFs,
   SyncTeX files, and clean positive logs; and
6. verifies seven deliberate random-selection failures.

Expected final output:

```text
PASS expected failure: physicsquiz_random_filter_no_match
All Phase 4E tests passed.
```

After the runner passes, inverse-search one selected question in
`physicsquiz_random_default.pdf`. Keep a positive driver as the LaTeX Workshop
root to clear intentional diagnostics from expected-failure tests.

## Verification completed for this handoff

- Ten positive Phase 4E drivers passed their exact semantic matrices.
- The same bank, filter, count, and seed reproduced the same ordered IDs.
- The comparison seed produced a different valid ordered selection.
- Filtered candidate pools and append-without-duplicates behaved correctly.
- All seven malformed random-selection drivers failed for the intended reason.
- The complete Phase 3D, 4C, and 4D regression matrices passed against the 4E
  class.
- Positive logs contain no LaTeX, `xsim`, overfull, or underfull diagnostics.
- Default, one-column, answer-key, and solution PDFs passed visual inspection.

## Deferred work

This checkpoint does not shuffle choices, assign multiple version labels from a
version manifest, balance a random paper to a target mark total, migrate the
60-question representative quiz, or update governance documentation. Those
remain separate review checkpoints.
