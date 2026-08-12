from pathlib import Path
import re
import sys


ROOT = Path(__file__).resolve().parents[1]
CLASS_FILE = ROOT / "src" / "classes" / "physicsquiz.cls"


EXPECTED_COMMANDS = {
    "quizclearselection",
    "quizselectids",
    "quizselect",
    "quizselectall",
    "quizselectrandom",
    "printquizquestions",
    "printquizanswerkey",
    "printquiztopicreport",
    "printquizsolutions",
    "printquizteacherreport",
    "quizbankassert",
    "quizselectionassert",
    "choices",
    "quizshuffleoptions",
    "quizcorrectletter",
    "quizshuffleassert",
    "quizdefineversion",
    "quizuseversion",
    "quizversionassert",
}

EXPECTED_ENVIRONMENTS = {
    "quizquestioncontent",
    "quizanswerkeycontent",
    "quizsolutioncontent",
    "quizteachercontent",
    "quizreferencecontent",
    "quizquestion",
    "quizsolution",
    "quizbank",
    "quizquestionbank",
}

EXPECTED_KEY_FAMILIES = {
    "physicsquiz / question",
    "physicsquiz / selection",
}

EXPECTED_MARKERS = {
    "physicsquizclassversion",
    "physicsquizstructuredinterfaceversion",
    "physicsquizstructuredinterfaceid",
}


def normalize_key_family(value):
    return " ".join(value.split())


def main():
    errors = []
    if not CLASS_FILE.exists():
        print(f"Missing class file: {CLASS_FILE}", file=sys.stderr)
        return 1

    text = CLASS_FILE.read_text(encoding="utf-8")

    expl3_on = [match.start() for match in re.finditer(r"\\ExplSyntaxOn\b", text)]
    expl3_off = [match.start() for match in re.finditer(r"\\ExplSyntaxOff\b", text)]

    if len(expl3_on) != 1:
        errors.append(f"Expected exactly one \\ExplSyntaxOn, found {len(expl3_on)}.")
    if len(expl3_off) != 1:
        errors.append(f"Expected exactly one \\ExplSyntaxOff, found {len(expl3_off)}.")
    if len(expl3_on) == 1 and len(expl3_off) == 1 and expl3_on[0] > expl3_off[0]:
        errors.append("\\ExplSyntaxOn appears after \\ExplSyntaxOff.")

    if errors:
        return report(errors)

    expl3_text = text[expl3_on[0] : expl3_off[0]]

    bad_functions = sorted(
        set(re.findall(r"\\__(?!pq_)[A-Za-z_]+(?::[A-Za-z]*)?", expl3_text))
    )
    bad_variables = sorted(
        set(
            re.findall(
                r"\\[glc]__(?!pq_)[A-Za-z_]+_(?:tl|seq|prop|bool|int|fp|clist)\b",
                expl3_text,
            )
        )
    )
    if bad_functions:
        errors.append(
            "Found internal expl3 functions outside the __pq module: "
            + ", ".join(bad_functions)
        )
    if bad_variables:
        errors.append(
            "Found internal expl3 variables outside the __pq module: "
            + ", ".join(bad_variables)
        )

    command_pattern = re.compile(
        r"\\(?:NewDocumentCommand|RenewDocumentCommand)\s+\\([A-Za-z@]+)"
    )
    environment_pattern = re.compile(
        r"\\NewDocumentEnvironment\s*\{([^}]+)\}"
    )
    found_commands = set(command_pattern.findall(text))
    found_environments = set(environment_pattern.findall(text))

    unexpected_commands = sorted(found_commands - EXPECTED_COMMANDS)
    missing_commands = sorted(EXPECTED_COMMANDS - found_commands)
    unexpected_environments = sorted(found_environments - EXPECTED_ENVIRONMENTS)
    missing_environments = sorted(EXPECTED_ENVIRONMENTS - found_environments)

    if unexpected_commands:
        errors.append(
            "Found unexpected public document commands: "
            + ", ".join(unexpected_commands)
        )
    if missing_commands:
        errors.append(
            "Missing expected public document commands: "
            + ", ".join(missing_commands)
        )
    if unexpected_environments:
        errors.append(
            "Found unexpected public document environments: "
            + ", ".join(unexpected_environments)
        )
    if missing_environments:
        errors.append(
            "Missing expected public document environments: "
            + ", ".join(missing_environments)
        )

    key_families = {
        normalize_key_family(match)
        for match in re.findall(r"\\keys_define:nn\s*\{([^}]+)\}", text)
    }
    if key_families != EXPECTED_KEY_FAMILIES:
        errors.append(
            "Unexpected key families. Expected "
            + ", ".join(sorted(EXPECTED_KEY_FAMILIES))
            + "; found "
            + ", ".join(sorted(key_families))
        )

    bridge_matches = re.findall(
        r"\\cs_set_eq:NN\s+\\pqchoiceoptionsguard\s+\\__pq_choiceoptions_guard:",
        text,
    )
    if len(bridge_matches) != 1:
        errors.append(
            "Expected exactly one legacy choiceoptions bridge "
            r"\pqchoiceoptionsguard -> \__pq_choiceoptions_guard:, found "
            + str(len(bridge_matches))
            + "."
        )

    for marker in EXPECTED_MARKERS:
        if not re.search(r"\\newcommand\s*\{\\" + re.escape(marker) + r"\}", text):
            errors.append(f"Missing capability marker \\{marker}.")

    if errors:
        return report(errors)

    print("PQ6C-NAMESPACE:EXPL3-BOUNDS=OK")
    print("PQ6C-NAMESPACE:INTERNALS=OK")
    print("PQ6C-NAMESPACE:PUBLIC-WRAPPERS=OK")
    print("PQ6C-NAMESPACE:KEYS=OK")
    print("PQ6C-NAMESPACE:LEGACY-BRIDGE=OK")
    print("PQ6C-NAMESPACE:CAPABILITY-MARKERS=OK")
    return 0


def report(errors):
    for error in errors:
        print(f"ERROR: {error}", file=sys.stderr)
    return 1


if __name__ == "__main__":
    raise SystemExit(main())
