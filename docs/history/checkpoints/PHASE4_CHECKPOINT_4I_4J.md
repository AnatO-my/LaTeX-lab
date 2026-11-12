# Phase 4 Checkpoints 4I and 4J — Option shuffling and the version manifest

## Why one note

4I and 4J were designed and verified together because a manifest entry carries
its own shuffle seed. Splitting them would have meant landing a version manifest
whose versions differed only in their question set, then immediately reopening it.

## 4I — seeded option shuffling

```latex
\quizselect[difficulty=foundation]
\quizshuffleoptions{104}
\printquizquestions[2]
```

`\quizshuffleoptions{<seed>}` permutes the five slots of the `\choices`
interface for every currently selected record. It must be called after the
selection is complete and before anything is rendered, because the answer key
has to report the shuffled letter even in `answerkey` output, where no booklet
is typeset.

A record's permutation is derived from the document seed and the record's
**declaration index**, not its position in the selection. The same bank, seed and
record therefore produce the same permutation whatever else is selected. The
generator is the existing `park-miller-v1` implementation with Schrage's update
and a Fisher-Yates permutation.

`\quizcorrectletter` expands to the effective answer letter for the record being
rendered — the shuffled letter when shuffling is active, the declared letter
otherwise. All sixty worked solutions in
`banks/phy104_full_question_bank.tex` now end with
`Hence option \textbf{\quizcorrectletter}.` instead of a hard-coded letter, so
solution prose stays correct under shuffling.

Shuffling supports the five-option `\choices` interface. A record whose options
are authored with `choiceoptions` raises a class error rather than producing a
booklet whose answer key would be wrong.

## 4J — version manifest

```latex
\quizdefineversion{A}{%
  \quizselect[difficulty=foundation]%
  \quizselectrandom[difficulty=applied]{6}{1041}%
  \quizshuffleoptions{10401}%
}
\quizdefineversion{B}{ ... }

\quizuseversion{A}
```

A version names a selection recipe and its own shuffle seed. `\quizuseversion`
clears the selection and any existing shuffle, runs the recipe, records the
active label, and sets the Phase 3 `\quizversion` header metadata — so
`Version A` in the running header now means a genuinely different paper rather
than a label. One compile produces one version, which keeps pagination,
numbering and the answer key unambiguous. The label argument is expanded, so a
build script may pass a macro.

`\quizversionassert{<label>}` supports regression fixtures.

## Files

- `src/classes/physicsquiz.cls`
- `examples/physicsquiz/banks/phy104_full_question_bank.tex` (60 solution letters)
- `examples/physicsquiz/PHY104_versioned_paper.tex`
- `tests/physicsquiz_shuffle_document.tex` and ten positive drivers
- eight expected-failure drivers
- `tests/check_physicsquiz_shuffle_versions.py`
- `tests/check_physicsquiz_full_migration.py` (resolves the new answer-letter macro)
- `tests/run_physicsquiz_phase4ij_tests.ps1`

## Acceptance contract

- Every permutation is a permutation of 1..5, and at least one is not the identity.
- Each shuffled letter equals the display position of the originally correct slot.
- The generated answer key agrees with the shuffled letter for every record.
- `student`, `teacher`, `solutions` and `answerkey` builds reproduce the default
  build's permutations and letters under the same seed, so an answer-key-only
  compile agrees with the paper it belongs to.
- A repeated seed reproduces the permutations exactly; a different seed does not.
- Without `\quizshuffleoptions`, no permutation is recorded and the answer key
  reports the declared letters.
- Versions A and B select different questions and disagree on at least one
  shared question's letter.
- Eight deliberate failures each abort with their intended marker.
- The accepted Phase 4G suite still passes, and the unshuffled full-migration
  drivers remain byte-identical.
- The Phase 4G fidelity checker resolves `\quizcorrectletter` to the declared
  letter before comparing with the legacy source, so the sixty-solution rewrite
  does not weaken it: altered reasoning still fails, and a record whose
  `correct=` disagrees with the legacy answer now fails twice.

## Run

```powershell
powershell -ExecutionPolicy Bypass -File tests\run_physicsquiz_phase4ij_tests.ps1
```

Expected ending:

```text
PASS expected failure: physicsquiz_version_already_active
All Phase 4I/4J tests passed.
```

Then review `build/examples/physicsquiz/PHY104_versioned_paper.pdf`, and build it
again with `\quizuseversion{B}` to confirm the two papers differ.

## Known limitations

- Shuffling is defined for the five-option `\choices` interface only.
- No option can be pinned to a fixed position, so a bank containing "none of the
  above" style options must not be shuffled. The PHY104 bank contains none.
- One compile produces one version; producing a full set means one build per
  version label.
