# Phase 4 Checkpoint 4D: deterministic question-bank selection

## Outcome

Checkpoint 4D separates structured-question declaration, deterministic
selection, and rendering while preserving the accepted Phase 4C interface.
Questions remain single authoritative records containing their metadata, stem,
choices, and immediately following solution.

The representative 60-question quiz and `examples/studentnotes/Optics.tex` are
unchanged.

## New author workflow

Declare or input the complete structured bank without rendering it:

```latex
\begin{quizbank}
  \input{banks/phy104-bank.tex}
\end{quizbank}
```

Build a deterministic selection, then render it:

```latex
\quizselectids{phy104-opt-060,phy104-osc-001}
\quizselect[difficulty=applied,marks=2]
\quizselect[tags={travelling-wave,power}]

\printquizquestions[2]
```

The public selection commands are:

- `\quizselectids{<comma-separated stable IDs>}`;
- `\quizselect[topic=...,difficulty=...,marks=...,tags={...}]`;
- `\quizselectall`;
- `\quizclearselection`; and
- `\printquizquestions[<columns>]`, with two columns as the default.

Selection commands append records. A record already selected is not added a
second time. `\quizclearselection` starts a new selection.

## Deterministic semantics

- Explicit ID selection follows the order written by the author.
- Metadata selection follows declaration order in the bank.
- Multiple metadata keys use AND semantics.
- A tag filter requires every requested tag to be present on the record.
- Marks use exact numeric equality, so `2` matches a two-mark record.
- Overlapping selection commands preserve the record's first selected position
  and do not duplicate it.
- Unknown IDs, empty ID lists, empty selections, empty metadata filters,
  invalid difficulty or marks filters, and filters with no matches produce
  class errors.

Controlled randomisation remains deferred. Checkpoint 4D deliberately proves
deterministic assembly before introducing seeded selection or version creation.

## Derived output

The following commands now consume only the selected records, in selection
order:

- `\printquizquestions`;
- `\printquizanswerkey`;
- `\printquiztopicreport`;
- `\printquizsolutions`; and
- `\printquizteacherreport`.

Question numbering, solution numbering, answer-key numbering, topic reports,
and total marks therefore agree even when stable IDs are selected out of bank
order.

`\quizselectionassert{<count>}{<marks>}{<ordered IDs>}` supports regression
fixtures. Ordinary assessment documents do not need to call it.

## Phase 4C compatibility

The existing form remains valid:

```latex
\begin{quizquestionbank}[2]
  % quizquestion and quizsolution records
\end{quizquestionbank}
```

It now acts as a compatibility wrapper that declares, selects, and prints the
enclosed records. Existing Phase 4C documents therefore require no rewrite.
Legacy manual quizzes using `quizquestions`, `choiceoptions`, `\choices`, and
manual answer or solution sections also remain valid.

## Local integration

From this checkpoint:

1. replace `src/classes/physicsquiz.cls`;
2. copy the files under `tests` into the repository's `tests` directory; and
3. keep the existing Phase 3D and Phase 4C test sources available.

The 4D package includes the corrected Phase 4C runner with literal
`Select-String` matching, so the earlier `Overfull \hbox` regular-expression
failure does not recur.

Do not copy this Markdown file unless you want to retain it as a local review
note. Do not stage generated PDFs, logs, auxiliary files, checkpoint notes, or
the unrelated `Optics.tex` modification.

## One-command verification

Run from the repository root:

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4d_tests.ps1
```

The runner:

1. reruns the complete accepted Phase 4C suite, which itself includes Phase 3D;
2. compiles reordered ID selection in all five output modes;
3. verifies topic, difficulty, marks, and match-all tag filters;
4. verifies deterministic append, de-duplication, clearing, and select-all;
5. checks selected-only questions, answers, solutions, reports, numbering,
   totals, PDF creation, SyncTeX creation, and clean positive logs; and
6. verifies seven deliberate selection failures.

Expected final output:

```text
PASS expected failure: physicsquiz_selection_invalid_marks
All Phase 4D tests passed.
```

After the runner passes, inverse-search one selected question in
`physicsquiz_selection_ids_default.pdf`. Keep a positive selection driver as the
LaTeX Workshop root to clear the intentional diagnostics from expected-failure
tests.

## Verification completed for this handoff

- All ten positive 4D selection drivers compiled and passed their semantic
  matrices.
- All seven malformed-selection drivers failed for the intended reason.
- The complete Phase 4C positive and validation matrices passed against the 4D
  class.
- The legacy choices fixture remained pixel-identical.
- All 23 pages of the unmigrated representative quiz remained pixel-identical
  to the accepted Phase 4C build.
- Reordered, metadata-filtered, one-column, answer-key, teacher, and solution
  outputs passed visual inspection.

## Deferred work

This checkpoint does not randomise questions, shuffle choices, generate seeded
versions, migrate all 60 representative questions, or update governance
documentation. Those remain separate review checkpoints.
