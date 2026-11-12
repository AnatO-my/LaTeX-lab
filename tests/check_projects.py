"""Compile and inspect ot-projects examples and authoring error cases."""
from pathlib import Path
import argparse, os, subprocess, re, json, uuid
from pypdf import PdfReader
p=argparse.ArgumentParser()
p.add_argument("--root",type=Path,default=Path(__file__).resolve().parents[1])
p.add_argument("--engine",default="pdflatex")
p.add_argument("--output",type=Path)
p.add_argument("--negative-only",action="store_true",help="Run authoring error cases only")
p.add_argument("--positive-only",action="store_true",help="Run valid-output cases only")
a=p.parse_args()
if a.negative_only and a.positive_only:p.error("Choose at most one focused mode.")
root=a.root.resolve()
out=(a.output or root/"build/tests"/("projects-"+uuid.uuid4().hex)).resolve()
out.mkdir(parents=True,exist_ok=True)
env=os.environ.copy()
env["TEXINPUTS"]=os.pathsep.join([str(root/"src/classes"),str(root/"src/packages"),env.get("TEXINPUTS","")])
results=[]
def build(src,name=None,error=None):
    src=Path(src).resolve();case=out/(name or src.stem);case.mkdir(exist_ok=True)
    print("Checking "+(name or src.stem),flush=True)
    previous=None
    for run in range(1,7):
        proc=subprocess.run([a.engine,"-interaction=nonstopmode","-halt-on-error",
            "-file-line-error","-no-shell-escape","-output-directory="+str(case),str(src)],
            cwd=src.parent,env=env,capture_output=True,text=True,errors="replace",timeout=90)
        stdout=proc.stdout+proc.stderr
        (case/f"pass-{run}.txt").write_text(stdout,encoding="utf-8")
        if error:
            assert proc.returncode!=0,"Invalid input compiled successfully: "+name
            # TeX wraps terminal output at 79 characters, which can split a word
            # ("In" / "valid"); compare with all whitespace removed.
            squash=lambda t: re.sub(r"\s+","",t).lower()
            assert squash(error) in squash(stdout.replace("(ot-projects)", "")),stdout[-4000:]
            results.append({"case":name,"expected_error":error,"passed":True})
            return
        assert proc.returncode==0,stdout[-5500:]
        state=tuple((case/(src.stem+ext)).read_bytes() if (case/(src.stem+ext)).exists() else b""
                    for ext in [".aux",".decisions",".risks",".out"])
        if previous==state:break
        previous=state
    else:raise AssertionError("Build did not converge: "+str(src))
    pdf=case/(src.stem+".pdf");reader=PdfReader(pdf)
    pages=[page.extract_text() or "" for page in reader.pages]
    log=(case/(src.stem+".log")).read_text(errors="replace")
    for problem in ["Overfull", "multiply defined", "destination with the same identifier",
                    "There were undefined references"]:
        assert problem not in log,(name,problem)
    results.append({"case":name or src.stem,"passes":run,"pages":len(pages),"pdf":str(pdf),"passed":True})
    return reader,pages,case
def fixture(name,records="",body="",setup=""):
    directory=out/"sources";directory.mkdir(exist_ok=True)
    path=directory/(name+".tex")
    path.write_text("\\documentclass{otengineering}\n\\usepackage{ot-projects}\n"+
        setup+"\n"+records+"\n\\begin{document}\n"+body+"\n\\end{document}\n",encoding="utf-8")
    return path
def norm(pages):return re.sub(r"\s+"," ","\n".join(pages))

if not a.negative_only:
    report=build(root/"examples/otengineering/projects/report.tex")
    notebook=build(root/"examples/otengineering/projects/notebook.tex")
    rt=norm(report[1]);nt=norm(notebook[1])
    assert "Project Report and Analysis" in rt
    assert "Engineering Notebook" in nt
    assert "Sign-off" in rt and "Sign-off" not in nt
    assert "Organisations" not in rt and "Organisations" not in nt
    assert "Individuals" not in rt and "Individuals" not in nt # no individual records declared
    for text in [rt,nt]:
        for token in ["REQ-A01","REQ-B01","REQ-I01","NGN TBD","USD TBD","TEST-01","Not run"]:
            assert token in text,(token,text)
        assert "no NGN conversion" in text
    assert not report[0].get_fields() # sign-off lines are printable, not interactive/digital signatures
    
    records=r"""
    \OTWorkstream{WS-A}{Stream Alpha}{Alpha body.}
    \OTWorkstream{WS-B}{Stream Beta}{Beta body.}
    \OTRequirement[workstream=WS-A,related={TEST-1},status=Draft]{REQ-1}{Requirement Alpha}{Alpha detail sentinel.}
    \OTRequirement[workstream=WS-B,status=Draft]{REQ-2}{Requirement Beta}{Beta detail sentinel.}
    \OTTest[workstream=WS-A,related={REQ-1},result={Not run}]{TEST-1}{Test Alpha}{Test sentinel.}
    \OTPerson[category=role]{ROLE-1}{Unassigned Role}{Role sentinel.}
    \OTPerson[category=individual,organisation={Hidden Organisation Sentinel}]{PER-1}{Person Sentinel}{Individual sentinel.}
    \OTPerson[category=organisation]{ORG-1}{Hidden Organisation Sentinel}{Organisation body.}
    \OTSignatory[title={Lead Engineer},capacity={Reviewed by}]{SIG-1}{Ada Example}
    \OTSignatory{SIG-2}{}
    \OTCost[planned={120,000},actual={TBD}]{COST-1}{Native cost}{Native amount is manually entered.}
    \OTCost[currency=USD,planned={100},actual={80},rate=1500,rate-date={2026-09-28},
     rate-source={Synthetic test rate},native-planned={150,000},native-actual={120,000}]
     {COST-2}{Foreign cost}{All figures are synthetic test data.}
    """
    src=fixture("preferences",records,r"""
    \OTPrintRecords{person}\OTPrintRecords{cost}\OTPrintSignoffs
    \OTPrintRegister[workstream=WS-A]{requirement}
    \OTPrintRecords[workstream=WS-A]{requirement}
    \OTPrintRegister[workstream=WS-A]{requirement}
    """,r"\OTProjectSetup{show-organisations=false,show-signoff=true}")
    reader,pages,case=build(src)
    text=norm(pages)
    for token in ["Roles","Individuals","Person Sentinel","NGN 120,000","USD 100",
                  "USD 80","NGN 1500 per 1 USD","2026-09-28","Synthetic test rate",
                  "150,000","Ada Example","Lead Engineer","Reviewed by"]:
        assert token in text,(token,text)
    assert "Hidden Organisation Sentinel" not in text
    assert "Requirement Beta" not in text
    assert "Requirement Alpha" in text
    assert any(annot.get_object().get("/Subtype")=="/Link"
               for page in reader.pages for annot in page.get("/Annots",[]))
    # Name and title are independent, and omitting both still produces a usable blank block.
    assert text.count("Name:")==2 and text.count("Title:")==2
    
    src=fixture("people_toggle",records,r"\OTPrintRecords{person}\OTPrintSignoffs",
        r"\OTProjectSetup{show-roles=false,show-individuals=false,show-organisations=true}")
    reader,pages,case=build(src)
    text=norm(pages)
    assert "Organisations" in text and "Hidden Organisation Sentinel" in text
    assert "Unassigned Role" not in text and "Person Sentinel" not in text and "Sign-off" not in text
    
    src=fixture("empty_views","",r"\OTPrintRegister{requirement}\OTPrintRecords{person}\OTPrintSignoffs Empty sentinel.")
    reader,pages,case=build(src)
    assert "register" not in norm(pages).lower() and "Sign-off" not in norm(pages)
    
    # A long summary must repeat its header, retain every record and break across pages.
    many="\n".join(r"\OTRequirement[status=Draft]{REQ-"+str(i)+r"}{Pagination entry "+str(i)+r"}{Body.}" for i in range(1,71))
    src=fixture("long_register",many,r"\OTPrintRegister{requirement}")
    reader,pages,case=build(src)
    assert len(pages)>1
    text=norm(pages)
    for i in range(1,71):
        assert text.count("Pagination entry "+str(i)+" ")==1,(i,text)
    assert sum("Workstream" in re.sub(r"\s+", "", page) for page in pages)>=2
    
    # Clear long-form body must span pages in both styles; math/formatting survive storage.
    longbody=r"\OTRequirement[status={\textbf{Draft}},acceptance={Preserve \(V=IR\).}]{REQ-L}{Long record}{"+\
        "\n".join("Continuation sentinel "+str(i)+r". A record remains readable when its body continues across pages.\par" for i in range(1,76))+"}"
    for mode in ["report","notebook"]:
        src=fixture("long_"+mode,longbody,r"\OTPrintRecords{requirement}",
                    r"\OTProjectSetup{style="+mode+"}")
        reader,pages,case=build(src)
        assert len(pages)>1 and "Continuation sentinel 75" in norm(pages)
    
invalid=[
 ("duplicate",r"\OTRequirement{REQ-1}{One}{Body}\OTRequirement{REQ-1}{Two}{Body}","", "Duplicate record ID"),
 ("bad_id",r"\OTRequirement{1_bad}{One}{Body}","", "Invalid record ID"),
 ("bad_currency",r"\OTCost[currency=usd]{COST-1}{One}{Body}","", "currency must be"),
 ("negative_rate",r"\OTCost[currency=USD,rate=-1]{COST-1}{One}{Body}","", "manual rate must"),
 ("zero_rate",r"\OTCost[currency=USD,rate=0]{COST-1}{One}{Body}","", "manual rate must"),
 ("missing_rate_date",r"\OTCost[currency=USD,rate=1500]{COST-1}{One}{Body}","", "requires rate-date"),
 ("missing_rate_source",r"\OTCost[currency=USD,rate=1500,rate-date=2026-09-28]{COST-1}{One}{Body}","", "requires rate-source"),
 ("missing_rate",r"\OTCost[currency=USD,native-planned=150000]{COST-1}{One}{Body}","", "requires rate"),
 ("native_rate",r"\OTCost[rate=1500]{COST-1}{One}{Body}","", "only for foreign"),
 ("bad_category",r"\OTPerson[category=company]{PER-1}{One}{Body}","", "category must"),
 ("unknown_related",r"\OTRequirement[related={REQ-2}]{REQ-1}{One}{Body}","", "references unknown ID"),
 ("bad_workstream",r"\OTRequirement[workstream=WS-X]{REQ-1}{One}{Body}","", "unknown workstream"),
 ("wrong_workstream_type",r"\OTRequirement{REQ-1}{One}{Body}\OTTest[workstream=REQ-1]{TEST-1}{Two}{Body}","", "must reference a workstream"),
 ("self_dependency",r"\OTMilestone[depends-on={STAGE-1}]{STAGE-1}{One}{Body}","", "cannot depend on itself"),
 ("unknown_reference","",r"\OTRecordRef{REQ-X}", "Unknown record reference"),
 ("unknown_filter","",r"\OTPrintRecords[workstream=WS-X]{requirement}", "Unknown workstream print filter"),
 ("unknown_type","",r"\OTPrintRecords{unknown}", "Unknown record type"),
 ("late_declaration","",r"\OTRequirement{REQ-1}{One}{Body}", "Can be used only in preamble"),
]
if not a.positive_only:
    for name,rec,body,error in invalid:
        build(fixture(name,rec,body),name,error)
(out/"results.json").write_text(json.dumps(results,indent=2),encoding="utf-8")
print(json.dumps({"status":"PASS","cases":len(results),"output":str(out)},indent=2))

