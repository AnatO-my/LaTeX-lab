import * as assert from "node:assert/strict";

import { buildOtcalcArgs } from "./commandBuilder";

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
