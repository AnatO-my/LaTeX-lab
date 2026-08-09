# Phase 4 Checkpoint 4H — Generated-booklet constants box

## Scope

The Phase 4G visual review found that `PHY104_structured_revision.tex` rendered
no constants box. This checkpoint restores it. No question record, selection
command, output mode, or test expectation changes.

## Cause

`\quizconstants` only stores its text. `\constantsbox` renders it, and
`\makequiztitle` never calls it. The legacy quiz calls `\constantsbox`
explicitly after `\section{Question Booklet}`, but a structured document cannot
reproduce that placement: `\printquizquestions` emits its own section heading and
then opens `multicol`, leaving no author hook in between.

## Change

`src/classes/physicsquiz.cls` — five added lines inside `\printquizquestions`,
immediately after its `\section`:

```latex
\exp_args:No \tl_if_blank:nF { \QuizConstants } { \constantsbox }
```

The box therefore appears only when the author has supplied constants. No
pre-Phase-4 document calls `\printquizquestions`, so no existing quiz can receive
a duplicated box, and manually authored quizzes keep calling `\constantsbox`
themselves.

## Acceptance contract

- The complete structured example remains 25 pages, with the constants box
  between the booklet heading and the two columns, matching the legacy order.
- Its log contains no LaTeX, `xsim`, overfull, or underfull diagnostics.
- The `all`, `foundation`, `ids`, and `random` full-migration drivers are
  unchanged, because none of them set `\quizconstants`.
- The accepted Phase 4G suite still passes end to end.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4g_tests.ps1
```

Expected ending:

```text
All Phase 4G full-migration checks passed.
All Phase 4G tests passed.
```

Then confirm visually that the constants box appears on the first booklet page of
`build/examples/physicsquiz/PHY104_structured_revision.pdf`.
