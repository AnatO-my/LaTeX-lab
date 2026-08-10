# Phase 5 Checkpoint 5A — OT-side regression harness

## Why this checkpoint refactors nothing

Phase 5 changes only the `otscience`/`otengineering` side of the ecosystem, and
that side has never had a runner. `PROJECT_STATE.md` records it plainly:

> A regression suite now exists for `physicsquiz` only. The other three classes
> have compatibility fixtures but no runner.

So chaining the accepted 3D → 4C → 4D → 4E → 4G → 4I/4J suites proves nothing
about a Phase 5 change. Those suites exercise a class Phase 5 does not touch, and
they will pass trivially. **That chain is a guard, not a proof.**

Phase 4 produced two late failures that manual LaTeX testing missed. Building the
proof *after* the first extraction would repeat that pattern, because a harness
written alongside a change tends to be shaped to agree with it. 5A therefore
builds the harness first, against unmodified sources, and requires it to be green
before it is ever used to judge anything.

**No file under `src/` changes in this checkpoint.**

## The change

### New: `tests/run_ot_phase5_tests.ps1`

Three stages.

1. **Guard.** Runs `tests\run_physicsquiz_phase4ij_tests.ps1`, which reruns
   4G → 4F → 4E → 4D → 4C → 3D. Confirms the untouched side is untouched.
   `-SkipGuard` omits it for iteration; a checkpoint is not complete without a
   full run.
2. **Build.** Compiles 18 OT-side documents into the mirrored `build/` tree:
   two palette probes, six Phase 2 compatibility fixtures, two representative
   documents, and the workbook's combined root plus all seven standalone modules.
   Asserts `.log`, `.pdf` and `.synctex.gz` exist for each.
3. **Baseline.** Records or verifies page counts, log diagnostics and rendered
   page text.

### New: `tests/check_ot_baseline.py`

Records a manifest and later diffs against it.

The OT side **cannot** assert "zero diagnostics" the way the physicsquiz runners
do. `examples/otengineering/test.tex` carries a known, accepted underfull box —
already on the known-issues list — and the combined workbook loads `silence`. A
blanket zero-diagnostic assertion would fail on day one for a pre-existing,
accepted condition, which is exactly the "fails for a plumbing reason" trap.

So the assertion is **no change from the recorded baseline**:

| Field | Assertion | Why |
| --- | --- | --- |
| page count | hard | catches `\Needspace` and box-geometry regressions |
| diagnostics, per class | hard | a *new* warning fails; an accepted one does not |
| rendered-text SHA-256 | hard, when available | catches content change at equal pagination |
| PDF byte size | **warning only** | weak proxy; moves for benign reasons |

Text extraction uses `pdftotext` when it is on `PATH`. MiKTeX does not ship it —
it arrives with poppler or Xpdf. When it is absent the harness degrades to page
counts and diagnostics **and says so loudly**, rather than silently proving less
than it claims.

### New: `tests/ot_palette_probe_science.tex`, `tests/ot_palette_probe_engineering.tex`

These exist because of a hole I found while testing the harness against itself.

I built a document, recorded its baseline, changed one colour from `2563EB` to
`2563E8`, and rebuilt. **Page count, diagnostic counts and PDF byte size were all
byte-for-byte identical.** Nothing in the suite noticed.

Checkpoint 5B *is* a colour move. A harness blind to colour values is worthless
for the first extraction it is meant to police.

Each probe asks `xcolor` what a name actually resolves to and writes the answer
twice — to the log as an `OT-PALETTE:` marker, so a failure is human-readable,
and into the document body, so the recorded text hash covers every value:

```latex
\extractcolorspec{OTBlue}\otprobe@tmp   % -> {rgb}{0.14511,0.38824,0.92157}
```

The science probe covers all ten OT colours; the engineering probe covers its
eight and pins the documented `OTLight` divergence, so if Checkpoint 5D ever
drops the `#F3F4F6` override the failure names the exact colour instead of the
engineering notebook quietly changing shade.

The runner also asserts each probe emitted the expected marker count (10 and 8).
A probe that silently emitted nothing would otherwise bake an empty baseline into
the manifest and agree with itself forever.

### New: `tests/otpractice_standalone.tex` — the cycle witness

`\documentclass{article}` + `\usepackage{otpractice}` + a `practice` environment.
It fails today, because `otpractice.sty` borrows `otscibox` and the OT palette
from `otscience.cls`. 5A records it as an **expected failure** with the marker
`Environment otscibox undefined`.

Checkpoint 5C moves this entry from `$expectedFailures` into `$documents`. That
move is the machine-checkable moment the circular dependency is broken — the
phase's central claim, expressed as a test that flips.

The expected-failure loop is the accepted form from
`run_physicsquiz_phase4e_tests.ps1`, reproduced unchanged: the
`$LASTEXITCODE -eq 0 → throw` inversion, and `Select-String -SimpleMatch … -Quiet`
for the marker. `$ErrorActionPreference` stays `"Stop"` and no native command's
stderr is redirected anywhere in the file.

## Where it belongs

```
tests/run_ot_phase5_tests.ps1              new
tests/check_ot_baseline.py                 new
tests/ot_palette_probe_science.tex         new
tests/ot_palette_probe_engineering.tex     new
tests/otpractice_standalone.tex            new
tests/ot_baseline_manifest.json            generated by -Record, committed
```

The manifest is committed deliberately. It is small, textual, LF-normalised by
`.gitattributes`, and it is the evidence later checkpoints are judged against —
an uncommitted baseline could not survive between sessions.

Everything else stays under `build/` and remains git-ignored.

## How to test it

```powershell
# once, against unmodified sources
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1 -Record

# immediately again, changing nothing
powershell -ExecutionPolicy Bypass -File tests\run_ot_phase5_tests.ps1
```

The second run is the real acceptance test for 5A: **a baseline that does not
reproduce itself is not a baseline.**

## Expected output

Recording ends with:

```text
Palette probe ot_palette_probe_science reported 10 colours.
Palette probe ot_palette_probe_engineering reported 8 colours.
Recorded 18 documents into ...\tests\ot_baseline_manifest.json.
Total pages baselined: <N>.
Rendered text hashed for all 18 documents via pdftotext.
PASS expected failure: otpractice_standalone
OT Phase 5 baseline recorded.
```

Verifying ends with:

```text
All 18 documents match the recorded baseline (18 verified by rendered text, 0 by
page count and diagnostics only).
PASS expected failure: otpractice_standalone
All OT Phase 5 tests passed.
```

If `pdftotext` is absent, the counts shift to `0 verified by rendered text, 18 by
page count and diagnostics only`, preceded by the WARNING block. That is a valid
but weaker baseline; installing poppler or Xpdf and re-recording is worth the
five minutes, because it is what makes 5B provable.

## Likely errors

| Symptom | Cause | Fix |
| --- | --- | --- |
| `… is not digitally signed. You cannot run this script on the current system.` | OneDrive stamps a mark-of-the-web on files it re-hydrates, and under a `RemoteSigned` policy PowerShell refuses to load a marked script. It hits the older chained runners first, so it reads like a physicsquiz regression when it is an environment problem | `Get-ChildItem .\tests\*.ps1 \| Unblock-File`. The runner now pre-checks all seven chained runners and names this remedy before building anything. Expect it to recur whenever OneDrive re-hydrates the folder |
| `xsim.sty was not found` | guard needs `xsim` | install via MiKTeX Console, or use `-SkipGuard` while iterating |
| `Required Phase 5 baseline source is missing: examples\vector-workbook\0N_…tex` | document list disagrees with the tree | correct the list; all seven modules were confirmed to carry the `\ifdefined\OTCOMBINED` standalone guard |
| `LaTeX compilation failed for tests\otscience_boxes_compatibility.tex` | that fixture `\input`s `../examples/vector-workbook/00_common_setup.tex` by relative path, which needs `$do_cd = 1` and an **absolute** `-outdir` | run from the repository root so the repository `.latexmkrc` is loaded |
| `no 'Output written on …' line` | build produced no PDF | read the named log; the build failed earlier than the baseline stage. **Fixed in the first revision:** TeX hard-wraps log lines at `max_print_line` (79) with no continuation marker, and a repository path is long enough that this line always wraps — sometimes inside the filename, a number, or the word `bytes`. The checker now strips wrapping before matching. If this reappears, the build genuinely failed |
| `emitted 0 OT-PALETTE markers` | `\extractcolorspec` unavailable or probe broken | check the `xcolor` version; do **not** re-record around it |
| `built but absent from the baseline` | a document was added to the list | re-record deliberately, and say so in the checkpoint note |
| MiKTeX offers to install packages mid-run | on-the-fly installation prompts | pre-install, or set MiKTeX to install automatically, so the run is unattended |

## What I verified, and what I did not

Verified here, with real `pdflatex` builds:

- `check_ot_baseline.py` records, reproduces itself, and detects every drift
  class — page count, added diagnostic, changed rendered text, document missing
  from a run, document absent from the baseline, missing manifest, and a log with
  no output line.
- The text hash catches a one-word change at unchanged page count.
- **The palette probe catches a single mistyped hex digit that page count,
  diagnostics and byte size all miss.** That result is why the probes exist.
- The checker compiles clean and reports only the diagnostic classes that moved.
- After the first live run, the summary-line parser was re-verified against a
  **real MiKTeX log from this repository** and against eight synthetic wrap
  positions, including breaks inside the filename, inside the page count, inside
  the byte count, inside the word `bytes`, inside the word `pages`, and across
  CRLF.

Two defects were found by running it, not by writing it:

1. **The runner did not announce its mode.** It silently verified when recording
   was intended, then failed several stages later with a message about a missing
   manifest rather than a wrong invocation. It now prints `Mode: RECORD` or
   `Mode: VERIFY` before doing anything, and warns when verifying with no
   manifest present.
2. **The summary-line parser could not read a real log.** My synthetic fixtures
   used short paths like `a.pdf`, which never reach TeX's 79-character wrap; a
   real repository path always does. The fixture was unrepresentative of
   production — the precise failure mode this harness exists to prevent, found
   in the harness itself before it was trusted with a source change.

**Not** verified, and requiring your machine:

- `run_ot_phase5_tests.ps1` has never been executed. There is no PowerShell in
  my environment, so its syntax is unchecked. Smoke-test it before trusting it.
- No document was compiled against the real classes here; this container lacks
  `tracklang`, `physics` and `siunitx`. Page counts and hashes in the manifest
  will be established by *your* first `-Record` run.

## Known limitations

- **Box geometry is only partly covered.** A changed `\Needspace` moves a page
  break and fails on page count; a changed `arc` or `boxrule` moves neither
  glyphs nor pages, so it would pass. `tests/otscience_boxes_compatibility.tex`
  covers box appearance by regression, but that coverage is visual. Checkpoint 5C
  should include a deliberate visual comparison of one rendered box, as 4G's
  review did — a machine cannot fully judge this one.
- The byte-size warning is noisy across MiKTeX updates. It is informational.
- `examples/studentnotes/Optics.tex` is baselined with its independent
  uncommitted modification in place. That is correct for detecting drift within
  Phase 5, but the recorded numbers describe the modified file, not `HEAD`. The
  file is read for building only; it stays unstaged.
- The guard roughly doubles the wall-clock time of a full run.

## Pre-flight, before any later checkpoint edits a source file

1. Confirm the working tree is clean apart from the expected
   `examples/studentnotes/Optics.tex` modification.
2. Run `git ls-files --eol` on the four classes and seven packages.
   `.gitattributes` declares `* text=auto eol=lf`, but `otengineering.cls`
   (295 lines), `studentnotes.cls` (250) and `legacy/otscience.sty` (194) are
   still wholly CRLF on disk, and `physicsquiz.cls` is still mixed — 328 CRLF
   among 1,617 lines. Establish whether git will renormalise on the next write
   *before* the first edit, or a one-line change becomes a whole-file diff — the
   exact hazard `.gitattributes` was added in Session 15 to prevent.

## Governance updates for this checkpoint

- `CHANGELOG.md` — open a Phase 5 section with an `### Added` entry for the
  harness. No `### Changed` entry: nothing under `src/` moved.
- `PROJECT_STATE.md` — set the current phase to Phase 5, record 5A, and replace
  the "Next action" block. Also correct the companion-package note: the cycle
  affects **four** of the seven packages; `ottensors`, `otphysics` and
  `otcoordinates` are already independently loadable.
- `docs/PUBLIC_INTERFACES.md` — **no change.** 5A introduces no public interface.
  The ownership table changes at 5B–5D, when the palette and base boxes move from
  a class to a package.
