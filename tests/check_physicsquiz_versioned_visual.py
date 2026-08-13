"""Phase 6F versioned-paper log checker.

The runner builds generated A and B copies of the representative versioned
paper. This checker verifies the class-level evidence that the papers really
activate different recipes, select different question sets, shuffle options,
and keep the answer key aligned with the generated solutions.
"""

import re
import sys
from pathlib import Path


FAILURES = []


def check(condition, message):
    if not condition:
        FAILURES.append(message)


def read(path):
    try:
        return Path(path).read_text(encoding="utf-8", errors="replace")
    except FileNotFoundError:
        FAILURES.append(f"missing log: {path}")
        return ""


def markers(log, prefix):
    return dict(re.findall(rf"^{prefix}:([A-Za-z0-9-]+)=(\S*)$", log, re.M))


def selected(log):
    return re.findall(r"^PQ4D-SELECT:(\S+)$", log, re.M)


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 2

    logs = {"A": read(sys.argv[1]), "B": read(sys.argv[2])}

    selections = {}
    answers = {}
    permutations = {}
    solution_answers = {}

    for label, log in logs.items():
        check(f"PQ4J-VERSION:{label}" in log, f"version {label}: not activated")
        check("PQ4C-CONTENT:QUESTIONS" in log, f"version {label}: questions missing")
        check("PQ4C-CONTENT:ANSWERKEY" in log, f"version {label}: answer key missing")
        check("PQ4C-CONTENT:SOLUTIONS" in log, f"version {label}: solutions missing")

        selections[label] = selected(log)
        answers[label] = markers(log, "PQ4C-ANSWER")
        permutations[label] = markers(log, "PQ4I-PERM")
        solution_answers[label] = markers(log, "PQ6F-SOLUTION-ANSWER")

        check(len(selections[label]) == 30,
              f"version {label}: expected 30 selected records, found {len(selections[label])}")
        check(permutations[label], f"version {label}: no shuffle permutations")
        check(answers[label], f"version {label}: no answer-key markers")
        check(solution_answers[label], f"version {label}: no solution-answer markers")
        check(answers[label] == solution_answers[label],
              f"version {label}: answer key and solution answers differ")

    check(set(selections["A"]) != set(selections["B"]),
          "versions A and B selected the same question set")
    check(permutations["A"] != permutations["B"],
          "versions A and B produced identical option permutations")

    shared = set(answers["A"]) & set(answers["B"])
    check(shared, "versions A and B share no records to compare")
    check(any(answers["A"][rid] != answers["B"][rid] for rid in shared),
          "shared records kept the same answer letters in both versions")

    if FAILURES:
        for failure in FAILURES:
            print(f"FAIL {failure}")
        print(f"{len(FAILURES)} Phase 6F versioned-paper check(s) failed.")
        return 1

    print("All Phase 6F versioned-paper checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
