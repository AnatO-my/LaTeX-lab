# Phase 6 Checkpoint 6E - Physicsquiz author usability pass

## Scope

Checkpoint 6E combines the planned error-message cleanup and structured
interface usability pass. It improves what a local author sees when creating or
debugging a quiz bank, without changing the public quiz syntax.

## User-facing improvements

The class now gives more concrete help for common metadata mistakes:

* missing required question metadata;
* malformed stable IDs;
* duplicate stable IDs;
* invalid marks values;
* invalid correct-option labels;
* invalid difficulty filters;
* invalid marks filters;
* empty metadata filters;
* filters that match no questions; and
* invalid random count or seed values.

The messages now include examples such as `id=waves-001`, `marks=0.5`,
`marks=.5`, `\quizselectall`, and `\quizselect[topic=waves]`. The same failure
paths also emit `PQ6E-HINT:*` log markers so nonstop local builds still leave a
plain diagnostic trail.

## Copyable starter document

`examples/physicsquiz/starter_quiz_bank.tex` is a minimal structured quiz-bank
document that local authors can copy. It demonstrates:

* the standard class declaration;
* title metadata;
* two `quizquestion` records;
* adjacent `quizsolution` records;
* integer and fractional marks;
* tags and an optional outcome; and
* generated questions, answer key, and solutions from one stored bank.

## Conservation decision

6E preserves the existing author syntax. No options, commands, environments,
selection behaviour, shuffling behaviour, record storage, or rendering defaults
are changed.

## Verification

`tests/run_phase6e_tests.ps1` reruns the 6D checkpoint first, builds the starter
document, and then runs expected-failure fixtures that check both the established
validation markers and the new `PQ6E-HINT:*` author hints.

Accepted on 12 August 2026:

```text
All Phase 6E tests passed.
```
