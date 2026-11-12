# Release Notes Draft: Architecture Refactor

Draft prepared from `docs/release/templates/RELEASE_NOTES_TEMPLATE.md`. Local MiKTeX validation
was completed on 12 November 2026. Do not publish until the source commit below
is selected after pull-request integration and the hosted checks have passed.

## Release

```text
Label: proposed v0.2.0 (no tag created)
Date: YYYY-MM-DD
Source branch: refactor/architecture-plan
Source commit: (select after pull-request integration)
Release type: minor
```

## Summary

LaTeX-lab is now a layered toolkit. Classes compose shared foundations
(`otcolors`, `otlayout`, `otcore`, `ottheme`), a named preset
(`otscience-theme`) and box families (`otboxes`, `otsciboxes`). Notation
packages can be loaded without OT styling, and every shared rule has a single
owner. Documents using the OT classes compile unchanged. The visible changes
are a unified `OTLight` background and the end of automatic `hyperref` when
OT packages are used in a standard class.

## Highlights

* One owner for the ten semantic science boxes (`otsciboxes`), usable in any
  class.
* `minimal` option for `otscience` and `otbook`. Companion packages now load
  deterministically, never "if found".
* Canonical `\ot...` command names with compatible short aliases, and a
  documented load-order contract for names that `physics` or `xsim` also
  define.
* `\otmarks` fixes the exam-marks helper, which never worked.
* A generated interface inventory (`scripts/audit_interfaces.py`) and a
  package-author checklist.

## Public Interface Changes

| Area | Change | Compatibility |
| --- | --- | --- |
| `otsciboxes.sty` | new owner of `definitionbox` … `experimentbox` | compatible |
| `otscience`, `otbook` | `minimal` option; bundles load unconditionally | compatible (incomplete installs now fail loudly) |
| `otcolors.sty`, `ottheme.sty` | palette separated from link policy | **breaking** for standard-class documents relying on transitive `hyperref` |
| `OTLight` | `#F3F4F6` for all classes | visible change (science backgrounds) |
| `otlayout.sty`, `otcore.sty` | layout extracted; `otcore` is a facade; `geometry` precedence | compatible |
| `otscience-theme.sty` | first named preset | compatible |
| `otemphasis.sty`, `otmathboxes.sty` | presentation split out; `noemphasis`/`noboxes` options | compatible |
| canonical `\ot...` names | `\otmean`, `\otdiff`, `\otgrad`, `\ottrace`, `\otrank`, `\otinverse`, `\otforce`, `\otgiven`, `\otblank`…, `\otimportant`… | compatible (aliases kept) |
| `\otmarks` | replaces non-working `\marks` | fix |
| `otaccess` | `\otenabletagging` reports engine and `tagpdf` fallbacks | compatible |

## Verification

| Check | Result |
| --- | --- |
| 22 representative tests, starters and examples (pdfLaTeX, TeX Live 2023) | identical page counts, text and page images after each phase. The exception is the intended `OTLight` change, which alters pixels only. |
| Author manual | builds; differs only in edited rows |
| Refactor fixtures (15) | pass |
| `scripts/audit_interfaces.py --check` | pass |
| `tests\run_ot_contract_tests.ps1` under MiKTeX | completed locally on 12 November 2026 |
| Phase 5 baseline re-record (`-Record`) for `OTLight` | completed locally on 12 November 2026 |
| `run_manual_author_reference_guard.ps1` | completed locally on 12 November 2026 |

## Release Assets

```text
No release assets.
```

## Upgrade Notes

See `docs/MIGRATION_GUIDE.md`. Actions are needed only for:

* standard-class documents that used OT link styling: add
  `\usepackage{ottheme}`;
* uses of `\marks{n}`: change them to `\otmarks{n}`; and
* documents that need the old science `OTLight`: redefine it to `#F9FAFB`.
