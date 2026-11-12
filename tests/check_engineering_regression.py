"""Regression checks for engineering compatibility, registers and PDF forms."""
from pathlib import Path
import argparse, os, re, subprocess, tempfile, json
from pypdf import PdfReader

parser=argparse.ArgumentParser()
parser.add_argument("--engine", default="pdflatex")
parser.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[1])
parser.add_argument("--output", type=Path)
parser.add_argument("--forms-only", action="store_true")
args=parser.parse_args()
root=args.root.resolve()
out=(args.output or root/"build/tests/engineering-regression").resolve()
out.mkdir(parents=True, exist_ok=True)
env=os.environ.copy()
env["TEXINPUTS"]=os.pathsep.join([str(root/"src/classes"),str(root/"src/packages"),env.get("TEXINPUTS","")])
results=[]
def build(source, name=None):
    source=Path(source).resolve()
    case=out/(name or source.stem)
    case.mkdir(exist_ok=True)
    print("Checking "+(name or source.stem), flush=True)
    # Each suite invocation has a fresh directory; repeated passes intentionally share files.
    previous=None
    for run in range(1,7):
        proc=subprocess.run([args.engine,"-interaction=nonstopmode","-halt-on-error",
             "-file-line-error","-no-shell-escape","-output-directory="+str(case),str(source)],
             cwd=case,env=env,capture_output=True,text=True,errors="replace",timeout=90)
        (case/f"pass-{run}.txt").write_text(proc.stdout+proc.stderr,encoding="utf-8")
        if proc.returncode:
            raise AssertionError(f"{source.name}: pass {run} failed\n{proc.stdout[-3500:]}\n{proc.stderr[-1000:]}")
        state=tuple((case/(source.stem+ext)).read_bytes() if (case/(source.stem+ext)).exists() else b""
                    for ext in [".decisions",".risks",".aux"])
        if previous==state: break
        previous=state
    else: raise AssertionError(f"{source.name}: registers/references did not settle in six passes")
    pdf=case/(source.stem+".pdf")
    reader=PdfReader(pdf)
    pages=[p.extract_text() or "" for p in reader.pages]
    results.append({"case":name or source.stem,"passes":run,"pages":len(pages),"pdf":str(pdf)})
    return case,reader,pages
def fixture(name, body, preamble=""):
    p=out/(name+".tex")
    p.write_text("\\documentclass{otengineering}\n"+preamble+"\n\\begin{document}\n"+body+"\n\\end{document}\n",encoding="utf-8")
    return p
def entries(case,stem,extension):
    text=(case/(stem+extension)).read_text()
    # Test titles/statuses use plain text, with separate coverage for robust formatting.
    return re.findall(r"\\otlogentry\s*\{([^{}]*)\}\{([^{}]*)\}\{([^{}]*)\}",text)
def body_page(pages,token):
    found=[i+1 for i,p in enumerate(pages) if token in p]
    assert len(found)==1,(token,found)
    return str(found[0])

if not args.forms_only:
    # Legacy syntax must preserve a first command, first word and grouped first paragraph.
    source=fixture("legacy_syntax",r"""
    \begin{decision}\textbf{LegacyCommandSentinel} follows a command.\end{decision}
    \begin{risk}[Legacy risk]LegacyWordSentinel follows a word.\end{risk}
    \begin{decision}[Grouped body]{\bfseries LegacyGroupSentinel} remains body text.\end{decision}
    """)
    case,reader,pages=build(source)
    alltext="\n".join(pages)
    for token in ["LegacyCommandSentinel","LegacyWordSentinel","LegacyGroupSentinel"]:
        assert token in alltext,token
    assert [x[1] for x in entries(case,source.stem,".decisions")]==["",""]
    assert [x[1] for x in entries(case,source.stem,".risks")]==[""]

    # Registers in front AND back must print identical completed data without duplicate writes.
    source=fixture("registry_lifecycle",r"""
    \printprojectdecisionlog[Front Decisions]
    \printprojectriskregister[Front Risks]
    \clearpage
    \begin{decision}[Choice A][Accepted]
    DecisionBodySentinel. A short decision.
    \end{decision}
    \clearpage
    \null\vspace*{0.94\textheight}
    \begin{risk}[Boundary risk][Open]
    BoundaryBodySentinel. This box must move to the next page.
    \end{risk}
    \clearpage
    \begin{decision}[Long choice][Review]
    LongBodySentinel.
    """ + "\n".join("Long continuation paragraph "+str(i)+r". The complete record remains readable across page boundaries.\par" for i in range(1,56)) + r"""
    \end{decision}
    \clearpage
    \printprojectdecisionlog[Back Decisions]
    \printprojectriskregister[Back Risks]
    """)
    case,reader,pages=build(source)
    ds=entries(case,source.stem,".decisions")
    rs=entries(case,source.stem,".risks")
    assert ds==[("Choice A","Accepted",body_page(pages,"DecisionBodySentinel")),("Long choice","Review",body_page(pages,"LongBodySentinel"))],ds
    assert rs==[("Boundary risk","Open",body_page(pages,"BoundaryBodySentinel"))],rs
    assert int(rs[0][2])>=int(ds[0][2])+2,rs
    text="\n".join(pages)
    for token in ["Front Decisions","Back Decisions","Front Risks","Back Risks","Long continuation paragraph 55"]:
        assert token in text,token
    assert text.count("Choice A")==3,text.count("Choice A") # body title plus both registers
    assert text.count("Boundary risk")==3,text.count("Boundary risk")

    import shutil
    shutil.copyfile(case/(source.stem+".pdf"), out/"registry-populated.pdf")
    results[-1]["pdf"]=str(out/"registry-populated.pdf")

    # Deleted entries must disappear after rebuild, including on previously nonempty output.
    source.write_text(r"\documentclass{otengineering}\begin{document}\printprojectdecisionlog\printprojectriskregister\end{document}")
    case,reader,pages=build(source,"registry_lifecycle")
    assert not entries(case,source.stem,".decisions")
    assert not entries(case,source.stem,".risks")
    text="\n".join(pages)
    assert "No Decisions Recorded" in text and "No Risks Recorded" in text
    assert "Choice A" not in text and "Boundary risk" not in text

    # Robust formatting in titles/status and empty status survive output serialization.
    source=fixture("formatted_registry",r"""
    \begin{decision}[A \textbf{bold} choice][\textit{Accepted}]FormattedBodySentinel.\end{decision}
    \begin{risk}[Empty status][]EmptyStatusSentinel.\end{risk}
    \clearpage\printprojectdecisionlog\printprojectriskregister
    """)
    case,reader,pages=build(source)
    text="\n".join(pages)
    assert text.count("bold")>=2 and "Not specified" in text

    for rel in ["examples/otengineering/starter_engineering_notes.tex",
                "tests/otengineering_boxes_compatibility.tex",
                "tests/otengineering_helpers_smoke.tex",
                "examples/otengineering/engineering_superpower_example.tex"]:
        build(root/rel)

    # Companion packages must be explicitly requested; class output must not auto-load them.
    source=fixture("explicit_dependencies",r"Dependencies are explicit.",r"""
    \makeatletter
    \@ifpackageloaded{otprofiles}{\errmessage{Profiles auto-loaded}}{}
    \@ifpackageloaded{otforms}{\errmessage{Forms auto-loaded}}{}
    \makeatother
    """)
    build(source)

    source=fixture("explicit_profile",r"Explicit profile remains usable.",r"\usepackage[mode=draft,print=true]{otprofiles}")
    build(source)

case,reader,pages=build(root/"examples/otengineering/forms_example.tex")
fields=reader.get_fields() or {}
expected={"site_loc","inspector","site_choice","chk_batt","chk_phys","chk_firm","notes_field"}
assert expected==set(fields),(expected,set(fields))
choice=fields["site_choice"]
assert choice["/FT"]=="/Ch",choice
assert list(choice["/Opt"])==["Site A","Site B","Site C"],choice
assert "Assigned Site:" in "\n".join(pages)
assert all(field.get("/FT") for field in fields.values())

widgets=[a.get_object() for page in reader.pages for a in page.get("/Annots",[]) if a.get_object().get("/Subtype")=="/Widget"]
assert len(widgets)==len(expected)
assert {str(w.get("/T")) for w in widgets}==expected

(out/"results.json").write_text(json.dumps(results,indent=2),encoding="utf-8")
print(json.dumps({"status":"PASS","cases":len(results),"output":str(out)},indent=2))

