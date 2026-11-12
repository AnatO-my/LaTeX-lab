# Package and Class Author Checklist

Use this checklist when adding or changing a class or package in `src/`. It
turns the rules in `docs/architecture/PLAN.md` ("Rules for every new class or package") into
checks. A change is ready for review when every applicable box is ticked in
the pull request.

## 1. Is it the right kind of file?

- [ ] **A new class** only for a distinct document genre, base-class model or
      author workflow, not a visual variation. A visual variation is a
      preset; see `otscience-theme.sty`.
- [ ] **A new package** only for a reusable capability that could serve more
      than one class or a standard LaTeX class.
- [ ] **Presentation stays separate from semantics.** Colours, boxes and
      emphasis go in a presentation package (for example `otemphasis`,
      `otmathboxes`, `otsciboxes`), not in a notation or domain package.

## 2. Names and ownership

- [ ] Every public command or environment has **one owner**. Search
      `docs/INTERFACE_INVENTORY.md` for the name first.
- [ ] New public names use the lowercase **`\ot...` prefix** (for example
      `\otmean`, `\otmarks`). A short name is added only as an alias, with a
      collision check against common packages (`physics`, `siunitx`,
      `mathtools`, `xsim`, `amsthm`, `hyperref`, …).
- [ ] **No `\providecommand` for a public name** whose meaning could differ if
      another package defined it first. If deferring to an earlier
      definition is intended, define the `\ot...` name with `\newcommand`, add
      the alias with `\@ifundefined{x}{\NewCommandCopy{\x}{\otx}}{}`, and
      document the deferral.
- [ ] **Never redefine a TeX or LaTeX primitive or kernel command**; the
      `\marks` defect is the cautionary example.
- [ ] **Moves and renames are atomic.** The new owner gains the definition and
      the old owner loses it in the same commit.
- [ ] **Common names added to a widely loaded package are opt-in** (a
      companion package or an option), so existing documents do not collide.

## 3. Loading behaviour

- [ ] **Options use `l3keys`**, defined with `\keys_define:nn`. Use two
      families:
      - *Package options* (`\usepackage[...]{otfoo}`) go in the family named
        exactly after the package, `{otfoo}`, and are processed with a plain
        `\ProcessKeyOptions` (LaTeX 2022-06-01 or later). Without an
        argument it reads only that family; keys defined elsewhere (for
        example `{otfoo/setup}`) are not seen unless you pass the family
        explicitly, `\ProcessKeyOptions[otfoo/setup]`. No current OT package
        processes package options this way yet, so there is no in-repo
        example to copy.
      - *Setup commands* use a separate `{otfoo/setup}` family and apply it
        with `\keys_set:nn`, as `ot-projects` does in `\OTProjectSetup`.

      Do not add new `kvoptions` or `pgfkeys` option interfaces. Existing packages keep
      theirs until there is a reason to migrate. This convention comes before
      any shared `otbase` code; see `docs/architecture/OTBASE_ROADMAP.md`.
- [ ] Before writing a "shared helper", check the roadmap's decision gate.
      Engine checks use `iftex`, and messages use `\PackageInfo`,
      `\PackageWarning` and `\PackageError`.

- [ ] Required dependencies are loaded with `\RequirePackage`. **Never use
      `\IfFileExists` to acquire OT packages.**
- [ ] A probe for a third-party engine capability writes a `\PackageWarning`
      or `\PackageInfo` describing the fallback.
- [ ] A package that only needs colours requires **`otcolors`, not
      `ottheme`**. Only a class or a deliberately themed document loads the
      link policy.
- [ ] An optional capability package does not change global layout,
      geometry, colours, link behaviour, counters or third-party
      configuration.
- [ ] Page geometry: never `\RequirePackage[...]{geometry}` after `otlayout`
      or `otcore`. Load it before them, or use `\geometry{...}` afterwards.
- [ ] Inside a `.cls`/`.sty`, any `@` code after an inner `\makeatother` is
      preceded by `\makeatletter`. This bug occurred twice during the
      refactor.
- [ ] Third-party dependencies and load-order constraints are written in the
      file header and in `docs/PUBLIC_INTERFACES.md`.

## 4. Tests

- [ ] A **standalone smoke test** in a standard class (`tests/<name>_smoke.tex`)
      emits a `\typeout` marker.
- [ ] For each guarded contract, a test **fails loudly** if it breaks: use
      `\PackageError` in an `\AtBeginDocument` check, as in
      `tests/ot_boxes_default_surface.tex` and
      `tests/ot_notation_neutral_loading.tex`.
- [ ] The fixture is added to the relevant runner, for example
      `tests/run_ot_contract_tests.ps1`.
- [ ] If output may change, rebuild the representative documents and compare
      page counts, text and page images. Record the result in the changelog.
      Re-record the Phase 5 baseline only for an intended visual change.

## 5. Documentation, in the same change

- [ ] `docs/PUBLIC_INTERFACES.md`: contract, owner and stability level.
- [ ] `docs/INTERFACE_INVENTORY.md`: regenerate with
      `py -3 scripts/audit_interfaces.py` (`--check` must pass).
- [ ] `CHANGELOG.md`: change level (patch, minor or major), versions bumped in
      `\Provides...`, and verification.
- [ ] `docs/MIGRATION_GUIDE.md`: a row for any renamed, moved or changed
      author-facing interface.
- [ ] `PROJECT_STATE.md` and, if catalogued, the author manual
      (`examples/manual/ot_author_workbook_manual.tex`, including `\src` line
      references).
