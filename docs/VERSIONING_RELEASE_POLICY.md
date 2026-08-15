# Versioning And Release Policy

## Purpose

This guide records the Phase 10A versioning and release boundary.

Phase 10 treats the LaTeX classes, packages, examples, and workflow scripts as
maintained software. The first rule is conservative: define the release policy
before changing any class or package version numbers.

## Current Version State

The current source has mixed version maturity:

| Area | Current state |
| --- | --- |
| `physicsquiz.cls` | declares `v0.1` and exposes public capability markers |
| `otboxes.sty`, `otcore.sty`, `ottheme.sty` | declare `v0.2` shared-package versions |
| other active classes and packages | have dated `\Provides...` lines without semantic version numbers |
| `src/legacy/otscience.sty` | preserved historical package, not an active release target |

Phase 10A does not change these values.

## Release Source

The source repository remains the release source of truth.

A release should be based on:

* a committed source state;
* a clean ordinary source status apart from known local-only files;
* passing local checks listed in the release checklist; and
* a GitHub tag or release entry only after the source state is chosen.

Generated PDFs, author kits, and preview zips remain release assets. They should
not be committed as ordinary source files.

## Version Labels

Use simple project release labels for repository-level releases:

```text
v0.1.0
v0.1.1
v0.2.0
```

Recommended meaning:

* patch: documentation, examples, tests, or tooling that does not change public
  author behavior;
* minor: new opt-in public features or compatible public-interface additions;
* major: incompatible public-interface removals or behavior changes.

Class/package semantic versions may lag behind the repository release label
until a checkpoint explicitly updates them.

## Public Interface Rule

Before a public command, environment, option, or package version changes:

1. update or add a focused test;
2. update `docs/PUBLIC_INTERFACES.md`;
3. update `CHANGELOG.md`;
4. update `PROJECT_STATE.md`; and
5. record whether the change is patch, minor, or major.

## Phase 10A Boundary

Phase 10A establishes policy and audit only.

It does not:

* bump class or package versions;
* add a Git tag;
* create release assets;
* add `l3build`; or
* broaden GitHub Actions.

Those are later Phase 10 decisions.
