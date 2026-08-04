# Recommended Chat Structure and Roadmap

## Will the current long chat necessarily become less precise?

No. A long conversation does not automatically make every later response worse.

However, a fresh dedicated chat is sensible here because:

- the current conversation contains many unrelated historical topics;
- several versions of similarly named files have appeared;
- future work will involve code changes where source precedence matters;
- a dedicated project chat makes testing decisions and change history easier to track.

A new chat creates a different risk: it loses unstated decisions. The solution is not to rely on chat memory. Use `PROJECT_STATE.md` and `CHANGELOG.md` as explicit handover documents.

## Best structure

Do not create a new chat for every tiny lesson.

Use:

1. one dedicated chat for Phases 0–2;
2. a new chat when beginning the substantial `physicsquiz` output/question-bank work in Phases 3–4;
3. a new chat for shared package architecture and modern programming in Phases 5–6;
4. a new chat for the modular workbook and publishing ecosystem in Phases 7–8;
5. a final engineering chat for performance, testing, and release work in Phases 9–10.

Start a fresh chat earlier whenever:

- the attached files have changed substantially;
- the assistant begins referring to superseded code;
- the conversation becomes dominated by troubleshooting unrelated to the phase;
- you need to compare two alternative architectures cleanly.

## Working rule

At the end of every session:

1. save the updated source files locally;
2. compile and verify locally;
3. update `CHANGELOG.md`;
4. update `PROJECT_STATE.md`;
5. attach those two files at the beginning of the next chat.

## Versioning rule

Never overwrite the only known-good version.

Suggested structure:

```text
latex-lab/
├── baseline/
│   ├── studentnotes.cls
│   ├── physicsquiz.cls
│   └── representative-pdfs/
├── src/
│   ├── classes/
│   ├── packages/
│   ├── examples/
│   └── workbooks/
├── tests/
├── docs/
├── PROJECT_STATE.md
├── CHANGELOG.md
└── README.md
```

Prefer Git commits over creating many files such as `physicsquiz_final_final2.cls`.

## First session

The first new chat should contain:

- `MASTER_PROMPT.md`
- `PROJECT_STATE.md`
- `studentnotes.cls`
- `physicsquiz.cls`
- one representative `.tex` and PDF for each class
- the complete workbook source tree
- `project-tree.txt`

Then instruct the assistant to perform Phase 0 only.
