# Architecture Audit (docs/architecture/PLAN.md Phase A)

Date: 11 November 2026. Branch: `refactor/architecture-plan`.

This is the Phase A record for the architecture refactor in `docs/architecture/PLAN.md`. It sets
out what the source declares today, where it depends on load order, and the
register of planned moves with their regression targets.

The full per-file listing is generated, not hand-written:

```text
py -3 scripts/audit_interfaces.py          # regenerate docs/INTERFACE_INVENTORY.md
py -3 scripts/audit_interfaces.py --check  # fail if the inventory is stale
```

## Method

* **Inventory.** `scripts/audit_interfaces.py` scans the 29 class and package
  files under `src/` for options, base classes, required and conditional
  packages, file probes, commands, environments, counters, colours and
  load-time side effects. It marks each name as *documented* (present in
  `docs/PUBLIC_INTERFACES.md`), *undocumented*, or *internal* (contains `@`).
  The scan is lexical; names built with `\csname` or in loops are not seen.
* **Rendering baseline.** 22 existing tests, starters and examples were built
  from an untouched snapshot and again after each change. Page count,
  extracted text, rendered page images and warning counts were compared.

## Summary

| Measure | Count |
| --- | --- |
| Files scanned | 29 at Phase A (5 classes, 23 packages, 1 legacy package); 30 after `otcolors` |
| Names marked *undocumented* | 417 |
| Names marked *internal* | 10 |
| `\providecommand`-style definitions | 20 |
| Names defined in more than one active file (legacy excluded) | 4 (was 24 before Phase B) |

The 417 *undocumented* names are mostly companion-package commands
(`otnotation`, `otphysics`, `ottensors`, ...). Classifying each one as stable,
advanced or internal is an owner decision. It is left open here and becomes
part of Phase E, where namespaced canonical names are introduced.

## Dependency findings

1. **Silent feature acquisition (fixed in Phase C).** `otscience` loaded 7
   companions and `otbook` 15 through `\IfFileExists`. These loads are now
   unconditional, with a `minimal` opt-out.
2. **Classes outside the layered model.** `physicsquiz` and `studentnotes` load
   none of `otcore`, `ottheme` or `otboxes`. `otengineering` loads `otcore` and
   `ottheme` but has its own `otbox` primitive. Their position is a Phase D
   decision.
3. **`ottheme` sets the link policy.** It loads `hyperref` and applies
   `\hypersetup{colorlinks=true,...}`. `otboxes`, `otsciboxes`, `otnotation`,
   `otmath`, `otfigures`, `otcode`, `otcircuits`, `otplots`, `otindex`, `otbib`,
   `otforms`, `otaccess`, `otsymbols` and `otreproduce` all require it. This is
   the subject of plan decision 7, completed on 11 November 2026: these
   packages now require `otcolors.sty`, and `ottheme` alone applies the link
   policy.
4. **Remaining file probes.** `otengineering` reads `\jobname.decisions` and
   `\jobname.risks` (its own auxiliary files, by design). `studentnotes`
   probes its dot-grid image with a documented fallback. `otaccess` probes
   `tagpdf.sty` and now reports the outcome. No class discovers OT packages
   from the filesystem any more.

## Hidden load-order dependencies

| Item | Effect | Planned in |
| --- | --- | --- |
| `otcore` loads `geometry` with `margin=1in` at load time | A later class cannot pass other `geometry` options without an option clash; classes adjust with `\geometry{...}` afterwards | Phase D |
| `\otcoresectionstyles` uses `OTDark` and `OTBlue` but `otcore` does not load `ottheme` | Works only because every caller loads `ottheme` first | Phase D |
| `otnotation`: `\providecommand` for `\dd`, `\grad`, `\tr`, `\rank` | `physics` wins under `otscience`/`otbook`; OT's definitions win under a plain class | Phase E |
| `otnotation` and `physicsquiz`: `\providecommand{\unit}` after `siunitx` | Dead code: `siunitx` v3 already defines `\unit` | Phase E |
| `otpractice`: `\providecommand{\marks}` | **Fixed 11 November 2026 with `\otmarks`.** Was a defect: `\marks` is an e-TeX primitive, so OT's definition never takes effect. `\marks{4}` stops with "Missing number, treated as zero". The author manual documents it. A fix needs a new name, because redefining the primitive would break LaTeX's mark mechanism. | Phase E (recommend early) |
| `otpractice`: `\providecommand` for `\blank`, `\bigblank`, `\longblank`, `\componentblank` | Silently yields to any earlier definition | Phase E |
| `otscience` and `studentnotes`: `\providecommand*` for `\definitionautorefname`, `\exampleautorefname` | Intentional defaults; harmless | Keep, document |

## Box and theorem overlap map

| Family | Owner(s) after Phase B | Overlaps with | Plan |
| --- | --- | --- | --- |
| Ten semantic science boxes plus `nosplit` variants | `otsciboxes` | `src/legacy/otscience.sty` (frozen) | Done (B) |
| `otscibox`, `otsciboxnosplit` | `otboxes` | `otengineering`'s `otbox` | Phase D |
| `reflectionbox`, `chaptergoals`, `chapteroverview`, `designrule` | `otbook` | `otmath`'s `otplaindesignrule` | Phase E |
| `proofbox`, `identitybox` | `otmath` | presentation inside a notation package | Phase E |
| `drillbox`, `recallbox`, `examquestion`, `workedsolution`, `flashcard` | `otpractice` | none | Keep |
| `idea`, `experiment`, `failure`, `lesson`, `calculation`, ... | `otengineering` | `experiment` vs `experimentbox` (different names, related meaning) | Phase D |
| `quicknote`, `personalnote`, `importantnote`, `namedformula`, `theorem`, `definition`, `example` | `studentnotes` | generic theorem names | Phase D |

## Move register

| Move | New owner | Compatibility status | Representative documents | Regression targets | Phase |
| --- | --- | --- | --- | --- | --- |
| Semantic science boxes out of both classes | `otsciboxes` | Additive; class behaviour identical | `examples/otscience/starter_science_notes.tex`, `examples/otbook/starter_personal_book.tex`, vector workbook | `tests/otscience_boxes_compatibility.tex`, `tests/otbook_class_smoke.tex`, `tests/ot_sciboxes_package_smoke.tex`, `tests/ot_boxes_default_surface.tex` | B (done) |
| Conditional to unconditional bundles, plus `minimal` | `otscience`, `otbook` | Same packages by default; incomplete installs now fail loudly | as above | `tests/otscience_minimal_option.tex`, `tests/otbook_minimal_option.tex`, Phase 5 baseline | C (done) |
| `otaccess` probe messages | `otaccess` | Log-only change | — | `tests/otaccess_tagging_message.tex` | C (done) |
| Colour tokens separated from link policy | `otcolors`; `ottheme` as compatibility wrapper | **Behaviour change** for standalone package users relying on transitive `hyperref` | `tests/ot_theme_package_smoke.tex`, `tests/otpractice_standalone.tex` | palette probes, theme smoke, `tests/ot_link_policy_boundary.tex`, `tests/ot_link_policy_optin.tex` | Decision 7 (done) |
| `otcore` geometry and colour dependency | `otlayout` / `otbase` | Must keep current output | otscience, otbook, otengineering starters | Phase 5 baseline, `tests/ot_core_package_smoke.tex` | D |
| `\marks` defect, `\providecommand` meanings, `proofbox`/`identitybox`, emphasis commands | `otpractice`, `otnotation`, `otmath`, `otemphasis` | Needs aliases and migration notes | vector workbook, author manual | new per-package smoke tests | E |

## Evidence for Phases B and C

All 22 baseline documents were identical before and after: page count,
extracted text, rendered page images at 50 dpi, and warning count. The
documents were:

* the otscience, otbook and otpractice box tests;
* the palette probes and the theme and core smoke tests;
* the otengineering and studentnotes fixtures;
* the otscience, otbook and otengineering starters;
* four otbook examples;
* the combined vector workbook and its two starters; and
* `templates/otbook-project/main.tex`.

The five new fixtures pass.

The comparison was run with pdfLaTeX from TeX Live 2023, not MiKTeX. That
installation lacks `biblatex` and `tracklang`, so both were replaced by
minimal local stand-ins. The same stand-ins were used for the before and
after builds, so the comparison stays valid, but bibliography output itself
was not exercised. Confirm under MiKTeX with:

```text
powershell -ExecutionPolicy Bypass -File tests\run_architecture_refactor_tests.ps1
```

## Phase D decisions (12 November 2026)

* **`otlayout` created.** It now owns the geometry default, list spacing,
  running heads and section styles. All three OT classes use it, so it has
  real consumers. It applies `margin=1in` only when `geometry` is not already
  loaded, so loading `geometry` with options first no longer raises the
  option clash that the old `otcore` caused. Both behaviours are tested.
* **`otcore` is now a facade.** It loads `otcolors`, `otlayout`, `tabularx`,
  `array` and `datetime2`, which also makes the colour dependency explicit.
* **`otbase` is contract-only.** It would own dependency-light helpers with no
  visual or layout effect, such as shared message, option or kernel-version
  helpers. No such helper exists today: everything in `otcore` was layout,
  colour, or plain package loads. Create `otbase` when a second package needs
  a shared helper, not before.
* **First preset: `otscience-theme`.** It replaces the settings that
  `otscience` and `otbook` duplicated. `otengineering` keeps its styling and its
  own `otbox` family in the class for now; a dedicated preset would have one
  consumer.
* **`studentnotes` and `physicsquiz` stay self-contained.** The reasons are in
  the "Class composition" section of `docs/PUBLIC_INTERFACES.md`.
* **Evidence.** The 22 baseline documents are identical after Phase D, in a
  same-day rebuild (dated documents change across midnight). The author
  manual is unchanged.

### Finding outside the refactor: `otengineering`'s `OTLight` (resolved)

Resolved on 12 November 2026 at the owner's request. `otcolors` v0.2 sets
`OTLight` to `#F3F4F6` for every OT class, so science and engineering now
match, and no class override is needed. Original finding:

`docs/PUBLIC_INTERFACES.md` says that `otengineering.cls` deliberately
overrides `OTLight` to `#F3F4F6`. The committed class (`HEAD`) does so, but the
uncommitted working copy no longer has that `\definecolor` line. The
engineering palette probe now reports the science value `#F9FAFB`. This
predates the refactor and was not changed by it. Either restore the line or
update the documented contract.

## Phase E decisions (12 November 2026)

* **Presentation split out.** Prose emphasis moved to `otemphasis`, and
  `proofbox`/`identitybox` moved to `otmathboxes`. `otnotation` and `otmath`
  load them by default, so existing documents are unchanged. The `noemphasis`
  and `noboxes` options give neutral loading. Making neutral loading the
  default would be a major change and is not proposed.
* **Collision scan.** Every command in `otnotation`, `otmath`, `otphysics`,
  `otcoordinates`, `ottensors` and `otpractice` was checked against 19 common
  packages. Hits:
  * `physics` defines `\dd`, `\grad`, `\tr` and `\rank`;
  * `siunitx` defines `\unit`;
  * `xsim` defines `\blank`.

  `siunitx` also installs placeholder `\N` and `\C` at `\begin{document}`, but
  only if they are still undefined, so OT's definitions win. Each hit, plus the
  plan's named examples, gained a canonical `\ot...` name.
* **Naming convention.** Canonical names are lowercase `\ot...`, matching the
  existing OT commands; `docs/architecture/PLAN.md` decision 5 is updated.
* **Evidence.** With `OTLight` held at its old value, the 22 baseline
  documents and the manual are identical after the Phase E refactor. The
  separate `OTLight` change alters pixels in 19 documents (box backgrounds)
  but not their page counts or text. Only the two palette probes, which
  print colour values, change their text. The Phase 5 baseline manifest
  (`tests/ot_baseline_manifest.json`) must therefore be re-recorded:
  `tests\run_ot_phase5_tests.ps1 -Record`.

## Open items from Phase A

* Write the companion-package contracts in `docs/PUBLIC_INTERFACES.md`. The
  inventory lists the names but not their contracts.
* Classify the 417 *undocumented* names (Phase E).
* ~~Fix the `\marks` defect.~~ Done: `\otmarks`.
