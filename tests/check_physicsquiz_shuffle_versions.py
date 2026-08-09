"""Phase 4I/4J acceptance checker.

Verifies seeded option shuffling and the version manifest against the declared
question bank and the generated build logs.

Usage:
    check_physicsquiz_shuffle_versions.py <bank.tex> <build directory>
"""

import re
import sys
from pathlib import Path

FAILURES = []


def check(condition, message):
    if not condition:
        FAILURES.append(message)


def read_log(build, stem):
    path = Path(build) / f"{stem}.log"
    if not path.is_file():
        FAILURES.append(f"missing log: {path}")
        return ""
    return path.read_text(encoding="utf-8", errors="replace")


def markers(log, prefix):
    out = {}
    for key, value in re.findall(rf"^{prefix}:([A-Za-z0-9-]+)=(\S*)$", log, re.M):
        out[key] = value
    return out


def bank_answers(bank):
    text = Path(bank).read_text(encoding="utf-8", errors="replace")
    records = re.findall(
        r"\\begin\{quizquestion\}\[(.*?)\]", text, re.S)
    answers = {}
    for keys in records:
        rid = re.search(r"id=([\w-]+)", keys).group(1)
        answers[rid] = re.search(r"correct=([A-Za-z])", keys).group(1).upper()
    return answers


def letter_to_index(letter):
    return "ABCDE".index(letter) + 1


def check_shuffled(name, log, answers, expect_booklet=True, expect_key=True):
    perms = markers(log, "PQ4I-PERM")
    shuffled = markers(log, "PQ4I-ANSWER")
    keys = markers(log, "PQ4C-ANSWER")

    check(perms, f"{name}: no permutations were recorded")
    check(len(perms) == len(shuffled),
          f"{name}: {len(perms)} permutations but {len(shuffled)} shuffled answers")

    non_identity = 0
    for rid, raw in perms.items():
        order = [int(p) for p in raw.split(",")]
        check(sorted(order) == [1, 2, 3, 4, 5],
              f"{name}/{rid}: {raw} is not a permutation of 1..5")
        if order != [1, 2, 3, 4, 5]:
            non_identity += 1
        original = answers.get(rid)
        check(original is not None, f"{name}/{rid}: not declared in the bank")
        if original is None or sorted(order) != [1, 2, 3, 4, 5]:
            continue
        expected = "ABCDE"[order.index(letter_to_index(original))]
        check(shuffled.get(rid) == expected,
              f"{name}/{rid}: shuffled answer {shuffled.get(rid)} "
              f"but permutation {raw} of original {original} gives {expected}")

    check(non_identity > 0,
          f"{name}: every permutation was the identity, which is not a shuffle")

    if expect_key:
        check(keys, f"{name}: no answer key was generated")
        for rid, letter in shuffled.items():
            check(keys.get(rid) == letter,
                  f"{name}/{rid}: answer key reports {keys.get(rid)} "
                  f"but the shuffled answer is {letter}")
    else:
        check(not keys, f"{name}: an answer key was generated in a mode that hides it")

    booklet = re.findall(r"^PQ4D-QUESTION:(\S+)$", log, re.M)
    if expect_booklet:
        check(booklet, f"{name}: no question booklet was rendered")
    else:
        check(not booklet,
              f"{name}: a booklet was rendered in an answer-key-only build")
    return perms, shuffled


def main():
    if len(sys.argv) != 3:
        print(__doc__)
        return 2
    bank, build = sys.argv[1], sys.argv[2]
    answers = bank_answers(bank)
    check(len(answers) == 60, f"expected 60 declared records, found {len(answers)}")

    logs = {name: read_log(build, f"physicsquiz_shuffle_{name}")
            for name in ("default", "student", "teacher", "answerkey",
                         "solutions", "repeat", "other_seed", "unshuffled")}
    logs["version_a"] = read_log(build, "physicsquiz_version_a")
    logs["version_b"] = read_log(build, "physicsquiz_version_b")

    for log in logs.values():
        check("PQ4I-SHUFFLE:ALGORITHM=park-miller-v1" in log
              or "PQ4I-PERM" not in log,
              "a shuffled build did not record the park-miller-v1 algorithm marker")

    base_perms, base_answers = check_shuffled("default", logs["default"], answers)

    modes = {"student": (True, False), "teacher": (True, True),
             "solutions": (False, False)}
    for name, (booklet, key) in modes.items():
        perms, shuffled = check_shuffled(name, logs[name], answers,
                                         expect_booklet=booklet, expect_key=key)
        check(perms == base_perms,
              f"{name}: permutations differ from the default build under the same seed")
        check(shuffled == base_answers,
              f"{name}: shuffled answers differ from the default build")

    perms, shuffled = check_shuffled("answerkey", logs["answerkey"], answers,
                                     expect_booklet=False, expect_key=True)
    check(shuffled == base_answers,
          "answerkey: shuffled answers differ from the default build, so an "
          "answer-key-only compile does not agree with the paper")

    perms, shuffled = check_shuffled("repeat", logs["repeat"], answers)
    check(perms == base_perms, "repeat: the same seed did not reproduce the permutations")
    check(shuffled == base_answers, "repeat: the same seed did not reproduce the answers")

    perms, _ = check_shuffled("other_seed", logs["other_seed"], answers)
    check(perms != base_perms, "other_seed: a different seed produced identical permutations")

    unshuffled = logs["unshuffled"]
    check("PQ4I-PERM" not in unshuffled,
          "unshuffled: permutations were recorded without \\quizshuffleoptions")
    for rid, letter in markers(unshuffled, "PQ4C-ANSWER").items():
        check(letter == answers.get(rid),
              f"unshuffled/{rid}: answer key reports {letter} "
              f"but the record declares {answers.get(rid)}")

    for label in ("A", "B"):
        log = logs[f"version_{label.lower()}"]
        check(f"PQ4J-VERSION:{label}" in log,
              f"version {label}: the manifest entry was not activated")
        check(f"PQ4J-ACTIVE:{label}" in log,
              f"version {label}: the active-version assertion did not run")
        check_shuffled(f"version_{label}", log, answers)

    sel_a = re.findall(r"^PQ4D-SELECT:(\S+)$", logs["version_a"], re.M)
    sel_b = re.findall(r"^PQ4D-SELECT:(\S+)$", logs["version_b"], re.M)
    check(sel_a and sel_b, "a version produced an empty selection")
    check(set(sel_a) != set(sel_b),
          "versions A and B selected exactly the same questions")
    ans_a = markers(logs["version_a"], "PQ4I-ANSWER")
    ans_b = markers(logs["version_b"], "PQ4I-ANSWER")
    shared = set(ans_a) & set(ans_b)
    check(shared, "versions A and B share no questions to compare")
    check(any(ans_a[r] != ans_b[r] for r in shared),
          "versions A and B gave every shared question the same answer letter")

    if FAILURES:
        for failure in FAILURES:
            if failure:
                print(f"FAIL {failure}")
        print(f"{len([f for f in FAILURES if f])} Phase 4I/4J check(s) failed.")
        return 1
    print("All Phase 4I/4J shuffle and version checks passed.")
    return 0


if __name__ == "__main__":
    sys.exit(main())
