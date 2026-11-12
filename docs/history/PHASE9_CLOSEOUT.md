# Phase 9 Closeout

## Outcome

Phase 9 is complete.

The phase established automation and performance evidence before changing
behavior. It measured build time, checked generated-file hygiene, audited build
recipes, split starter timing, audited TikZ/dot-grid usage, and modernized the
StudentNotes dot-grid path conservatively.

## Delivered

Phase 9 delivered:

* baseline build measurement;
* generated-file hygiene reporting;
* build-recipe reliability checks;
* per-starter timing;
* TikZ and dot-grid source audit;
* an opt-in StudentNotes image/PDF dot-grid background path;
* idempotent `\usedotgrid`; and
* a final source-level closeout guard.

## Preserved

Phase 9 preserved:

* the existing TikZ dot grid as the default fallback;
* existing `\usedotgrid` documents;
* source-only commits as the ordinary collaboration unit;
* ignored generated reports under `build/`; and
* protected-`main` collaboration expectations from Phase 8.

## Verification

The accepted Phase 9 verification points are:

| Checkpoint | Result |
| --- | --- |
| 9A measurement | passed in 15.75 seconds |
| 9B generated hygiene | 0 visible generated-looking files after ignore update |
| 9C build reliability | passed |
| 9D starter timing | passed in 13.64 seconds |
| 9E TikZ/dot-grid audit | passed with 0 warnings and 0 failures |
| 9F dot-grid modernization | passed in normal MiKTeX PowerShell |
| 9G closeout | passed; 21 files and 11 markers checked |

The final Phase 9C reliability rerun parsed 23 of 23 PowerShell runners and
reported 0 findings and 0 failures.

## Carried Forward

Phase 10 should treat the project as maintained software.

Ready next options:

* create the first release/version policy;
* decide whether to add a small `l3build` regression suite;
* broaden GitHub Actions beyond starter documents;
* create a measured, packaged dot-grid image/PDF asset; and
* trial the first protected pull request before increasing branch-protection
  strictness.
