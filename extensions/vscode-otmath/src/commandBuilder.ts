export type OtMathCliCommand =
  | "solve"
  | "simplify"
  | "diff"
  | "integrate"
  | "factor"
  | "expand"
  | "latex"
  | "explain";

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
