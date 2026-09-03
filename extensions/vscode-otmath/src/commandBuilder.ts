import * as path from "node:path";

export type OtMathCliCommand =
  | "solve"
  | "nsolve"
  | "system"
  | "simplify"
  | "diff"
  | "integrate"
  | "factor"
  | "expand"
  | "sum"
  | "product"
  | "limit"
  | "inequality"
  | "mean"
  | "median"
  | "variance"
  | "stdev"
  | "unit"
  | "det"
  | "order"
  | "rank"
  | "trace"
  | "inverse"
  | "norm"
  | "cond"
  | "mpow"
  | "transpose"
  | "conjugate"
  | "adjoint"
  | "rref"
  | "msolve"
  | "nullspace"
  | "columnspace"
  | "rowspace"
  | "eigenvals"
  | "eigenvectors"
  | "diagonalize"
  | "lu"
  | "qr"
  | "cholesky"
  | "latex"
  | "explain";

export const SUPPORTED_SELECTION_COMMANDS: readonly Exclude<
  OtMathCliCommand,
  "latex" | "explain"
>[] = [
  "solve",
  "nsolve",
  "system",
  "simplify",
  "diff",
  "integrate",
  "factor",
  "expand",
  "sum",
  "product",
  "limit",
  "inequality",
  "mean",
  "median",
  "variance",
  "stdev",
  "unit",
  "det",
  "order",
  "rank",
  "trace",
  "inverse",
  "norm",
  "cond",
  "mpow",
  "transpose",
  "conjugate",
  "adjoint",
  "rref",
  "msolve",
  "nullspace",
  "columnspace",
  "rowspace",
  "eigenvals",
  "eigenvectors",
  "diagonalize",
  "lu",
  "qr",
  "cholesky",
];

export type OtMathOutputFormat = "text" | "json" | "latex";

export interface OtMathCommandOptions {
  command: OtMathCliCommand;
  expression: string;
  variable?: string;
  format?: OtMathOutputFormat;
  provider?: "none";
  noAi?: boolean;
  explainOperation?: Exclude<OtMathCliCommand, "latex" | "explain">;
}

export interface OtMathLatexBuildOptions {
  sourcePath: string;
  outputPath?: string;
  compile?: boolean;
  engine?: string;
}

export function buildOtcalcArgs(options: OtMathCommandOptions): string[] {
  const args: string[] = [];

  if (options.provider) {
    args.push("--provider", options.provider);
  }
  if (options.noAi) {
    args.push("--no-ai");
  }

  args.push(options.command, options.expression);

  if (options.command === "explain" && options.explainOperation) {
    args.push("--operation", options.explainOperation);
  }
  if (options.variable) {
    args.push("--variable", options.variable);
  }
  if (options.format) {
    args.push("--format", options.format);
  }

  return args;
}

export function buildLatexBuildArgs(options: OtMathLatexBuildOptions): string[] {
  const args = ["latex-build", options.sourcePath];

  if (options.outputPath) {
    args.push("--output", options.outputPath);
  }
  if (options.compile) {
    args.push("--compile");
  }
  if (options.engine) {
    args.push("--engine", options.engine);
  }

  return args;
}

export function detectGeneratedLatexOutput(
  sourceText: string,
  sourcePath: string
): string | undefined {
  const sourceDirectory = path.dirname(sourcePath);
  const inputPattern = /\\(?:input|include|OTMathGeneratedInput)\s*\{([^{}]+)\}/g;
  let match: RegExpExecArray | null;

  while ((match = inputPattern.exec(sourceText)) !== null) {
    const includePath = match[1].trim();
    const normalized = includePath.replace(/\\/g, "/");
    if (!normalized.includes("generated/") || !normalized.endsWith(".tex")) {
      continue;
    }
    return path.resolve(sourceDirectory, includePath);
  }

  return undefined;
}

export function hasOtMathLatexRequests(sourceText: string): boolean {
  return /\\OTMath(?:Compute|Explain)\b/u.test(sourceText);
}
