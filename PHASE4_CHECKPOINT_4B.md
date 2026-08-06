# Phase 4 Checkpoint 4B: `xsim`-backed facade proof of concept

## Outcome

Checkpoint 4B is an isolated, test-only proof of concept. It demonstrates that
`xsim` can provide the storage engine for a `physicsquiz`-owned question syntax
without changing `src/classes/physicsquiz.cls` or migrating the 60-question
representative quiz.

The proof of concept uses four questions drawn from the representative quiz:

- oscillations: foundation;
- normal modes: applied;
- waves and sound: applied;
- optics: challenge.

Their marks sum to 8 and their generated answer sequence is C, B, B, E.

## Author-facing experiment

```latex
\begin{quizquestion}[
  id=phy104-osc-001,
  topic=oscillations,
  difficulty=foundation,
  marks=1,
  correct=C,
  tags={shm,restoring-force},
  outcome={Identify the direction of a restoring force}
]
  Question stem.
  \choices{A}{B}{C}{D}{E}
\end{quizquestion}
\begin{quizsolution}
  Worked solution.
\end{quizsolution}
```

The facade maps these keys into `xsim` properties and tagging facilities. The
question and solution bodies are stored by `xsim`; generated answer, topic,
teacher, marks, and solution outputs read the stored record rather than a second
manually maintained list.

## Scope boundary

This checkpoint does not:

- change the production class;
- define the final Phase 4 public interface;
- migrate the complete 60-question quiz;
- add selection, randomisation, shuffling, or version assembly;
- update governance documentation;
- stage or commit files;
- touch `examples/studentnotes/Optics.tex`.

The file `tests/physicsquiz_xsim_facade_poc.sty` is deliberately test-only. If
the proof of concept is accepted, its design can be refined before the facade is
moved into an appropriate production layer.

## Integration

Copy every file from the checkpoint `tests` directory into the repository's
existing `tests` directory. Do not copy this Markdown review note unless you
want to retain it locally.

No existing repository file should be replaced at Checkpoint 4B.

`xsim` must be installed in MiKTeX. Confirm with:

```powershell
kpsewhich xsim.sty
```

## One-command verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4b_tests.ps1
```

The runner:

1. reruns the complete Phase 3D suite;
2. compiles all five Phase 4B output modes;
3. rejects LaTeX, `xsim`, overfull, and underfull diagnostics;
4. checks the exact semantic-output matrix;
5. verifies four IDs, answer associations, solution associations, metadata,
   record count, total marks, PDF creation, and SyncTeX creation;
6. runs four expected-failure tests.

Expected final lines include:

```text
All Phase 4B xsim-facade checks passed.
PASS expected failure: physicsquiz_xsim_missing_id
PASS expected failure: physicsquiz_xsim_duplicate_id
PASS expected failure: physicsquiz_xsim_missing_metadata
PASS expected failure: physicsquiz_xsim_missing_solution
All Phase 4B tests passed.
```

The expected-failure documents intentionally produce editor diagnostics. Keep a
positive driver such as `tests/physicsquiz_xsim_default.tex` as the LaTeX
Workshop root after testing.

## Visual and SyncTeX review

Inspect these PDFs in `build/tests`:

- `physicsquiz_xsim_default.pdf`;
- `physicsquiz_xsim_student.pdf`;
- `physicsquiz_xsim_teacher.pdf`;
- `physicsquiz_xsim_solutions.pdf`;
- `physicsquiz_xsim_answerkey.pdf`.

Confirm that:

- every displayed question has the expected marks label;
- difficulty is visible only where Phase 3 permits it;
- the answer key shows four derived answers and 8 total marks;
- topic and teacher reports use the stored metadata;
- the four solution headings retain the matching question number and answer;
- no question, answer, solution, or teacher-only section leaks into another
  output mode.

For SyncTeX, open `physicsquiz_xsim_default.pdf` and inverse-search a question
stem. Because `xsim` replays stored bodies, navigation may resolve to either the
shared bank line or the insertion call depending on the engine and viewer.
Record whether navigation remains practical before promoting the facade.

## Review decision after local verification

Checkpoint 4B should be reviewed before production integration. The Phase 4C
decision should address:

- whether the public record names are clear;
- whether a solution must immediately follow its question;
- whether metadata validation belongs in the class or a companion package;
- whether one-column rendering needs a separate non-`multicol` path;
- whether SyncTeX behaviour is acceptable;
- whether the four-record fixture is sufficient to begin a limited migration.
