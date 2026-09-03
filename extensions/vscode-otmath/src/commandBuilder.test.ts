import * as assert from "node:assert/strict";
import * as path from "node:path";

import {
  buildLatexBuildArgs,
  buildOtcalcArgs,
  detectGeneratedLatexOutput,
  hasOtMathLatexRequests,
  SUPPORTED_SELECTION_COMMANDS,
} from "./commandBuilder";

assert.deepEqual(
  buildOtcalcArgs({
    command: "solve",
    expression: "x**2 - 5*x + 6",
    provider: "none",
    noAi: true,
    variable: "x",
    format: "json",
  }),
  [
    "--provider",
    "none",
    "--no-ai",
    "solve",
    "x**2 - 5*x + 6",
    "--variable",
    "x",
    "--format",
    "json",
  ]
);

assert.deepEqual(
  buildOtcalcArgs({
    command: "explain",
    expression: "x**3",
    explainOperation: "diff",
  }),
  ["explain", "x**3", "--operation", "diff"]
);

assert.ok(SUPPORTED_SELECTION_COMMANDS.includes("nsolve"));
assert.ok(SUPPORTED_SELECTION_COMMANDS.includes("mean"));
assert.ok(SUPPORTED_SELECTION_COMMANDS.includes("unit"));
assert.ok(SUPPORTED_SELECTION_COMMANDS.includes("norm"));
assert.ok(SUPPORTED_SELECTION_COMMANDS.includes("cond"));

assert.deepEqual(
  buildOtcalcArgs({
    command: "nsolve",
    expression: "cos(x) - x",
    variable: "x,0.5",
  }),
  ["nsolve", "cos(x) - x", "--variable", "x,0.5"]
);

assert.deepEqual(
  buildLatexBuildArgs({
    sourcePath: "examples/latex/stress.tex",
    outputPath: "examples/latex/generated/otmath-stress-results.tex",
    compile: true,
    engine: "pdflatex",
  }),
  [
    "latex-build",
    "examples/latex/stress.tex",
    "--output",
    "examples/latex/generated/otmath-stress-results.tex",
    "--compile",
    "--engine",
    "pdflatex",
  ]
);

assert.deepEqual(
  buildLatexBuildArgs({
    sourcePath: "examples/latex/stress.tex",
    outputPath: "examples/latex/generated/otmath-stress-results.tex",
  }),
  [
    "latex-build",
    "examples/latex/stress.tex",
    "--output",
    "examples/latex/generated/otmath-stress-results.tex",
  ]
);

{
  const sourcePath = path.resolve("examples", "latex", "stress.tex");
  const detected = detectGeneratedLatexOutput(
    String.raw`\input{../../integrations/latex/otmath.sty}
\OTMathGeneratedInput{generated/otmath-stress-results.tex}`,
    sourcePath
  );

  assert.equal(
    detected,
    path.resolve(path.dirname(sourcePath), "generated", "otmath-stress-results.tex")
  );
}

assert.equal(hasOtMathLatexRequests(String.raw`\OTMathCompute[input=latex]{id}{simplify}{x}`), true);
assert.equal(hasOtMathLatexRequests(String.raw`\OTMathExplain[input=latex]{id}{x}`), true);
assert.equal(hasOtMathLatexRequests(String.raw`\OTMathGeneratedInput{generated/results.tex}`), false);
