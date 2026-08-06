# Phase 4 Checkpoint 4C: production structured-question interface

## Outcome

Checkpoint 4C promotes the accepted Phase 4B `xsim`-backed facade into
`physicsquiz.cls`. Authors use class-owned commands and environments; raw `xsim`
syntax remains an implementation detail.

The representative 60-question quiz and `examples/studentnotes/Optics.tex` are
unchanged.

## Production author interface

```latex
\begin{quizquestionbank}[2]
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
\end{quizquestionbank}
```

Required question keys are `id`, `topic`, `difficulty`, `marks`, `correct`, and
`tags`. `outcome` is optional. Difficulty is one of `foundation`, `applied`, or
`challenge`. Stable IDs use lowercase letters, digits, and single hyphens.

Every question must have exactly one immediately following `quizsolution`.
Duplicate IDs, missing metadata, invalid IDs, invalid marks, invalid correct-option
labels, orphan solutions, duplicate solutions, and non-adjacent solutions produce
class errors.

The generated output commands are:

- `\printquizanswerkey`;
- `\printquiztopicreport`;
- `\printquizsolutions`;
- `\printquizteacherreport`; and
- `\quizbankassert{<question count>}{<marks total>}` for regression fixtures.

Place the generated commands inside the existing Phase 3 semantic gates, as shown
in `tests/physicsquiz_xsim_document.tex`.

## Compatibility

- The no-option `full,colour` default is unchanged.
- Existing manual quizzes do not need to adopt the structured interface.
- `quizquestions`, `choiceoptions`, `\choices`, manual `answerkey`, semantic
  output gates, version metadata, and marks/difficulty hooks remain available.
- `quizquestions` now correctly supports one column as well as its established
  two-column default.
- The complete Phase 3D suite passes against the production class.
- The legacy choices fixture is pixel-identical to its Phase 3D output.
- All 23 pages of the unmigrated representative quiz are pixel-identical to the
  accepted Phase 3D output.

## Local integration

From this checkpoint:

1. replace `src/classes/physicsquiz.cls`;
2. copy the files under `tests` into the repository's `tests` directory;
3. remove the superseded test-only Phase 4B files:

```powershell
Remove-Item tests\physicsquiz_xsim_facade_poc.sty
Remove-Item tests\run_physicsquiz_phase4b_tests.ps1
```

Do not copy this Markdown file unless you want to retain it as a local review
note. Do not stage generated PDFs, logs, auxiliary files, checkpoint notes, or
the unrelated `Optics.tex` modification.

## One-command verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4c_tests.ps1
```

The runner:

1. reruns the complete Phase 3D suite;
2. compiles the five structured output modes;
3. compiles one-column and optional-outcome fixtures;
4. checks record count, total marks, answer and solution association, metadata,
   PDF creation, SyncTeX creation, and clean positive logs; and
5. verifies ten deliberate validation failures.

Expected final output:

```text
PASS expected failure: physicsquiz_xsim_nonadjacent_solution
All Phase 4C tests passed.
```

After the runner passes, rebuild the representative quiz in its default mode and
confirm that it remains 23 pages. Keep a positive driver such as
`tests/physicsquiz_xsim_default.tex` as the LaTeX Workshop root to clear the
intentional diagnostics from expected-failure tests.

## Deferred work

This checkpoint does not migrate the 60-question quiz, select or randomise
questions, shuffle options, assemble versions automatically, or update governance
documentation. Those remain separate review checkpoints after the production
interface is accepted locally.
