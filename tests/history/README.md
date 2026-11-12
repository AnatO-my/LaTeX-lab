# Retired Test Runners

These runners verified that a specific project checkpoint had been recorded
(documents, changelog and project-state entries at the paths of that time).
Their job is done, and they are kept unchanged for reference. They are not
expected to pass against the current layout and are not run by CI or
`tests/run_all_tests.ps1`.

| Runner | Replaced by |
| --- | --- |
| `run_phase10a_release_policy.ps1` … `run_phase10gh_release_source_checks.ps1` | `tests/run_release_policy_guard.ps1` |
| `run_phase10ij_release_candidate.ps1` | the release-candidate section of `docs/release/RELEASE_PROCESS.md` |
| `run_phase9g_phase_closeout.ps1` | nothing; Phase 9 closed on 14 August 2026 |
