import { execFile } from "node:child_process";
import * as vscode from "vscode";

import { buildOtcalcArgs, OtMathCliCommand } from "./commandBuilder";

interface ExtensionSettings {
  otcalcPath: string;
  provider: "none";
  privacyMode: "localOnly";
  variable: string;
}

export function activate(context: vscode.ExtensionContext) {
  const output = vscode.window.createOutputChannel("OT Math");

  context.subscriptions.push(
    output,
    vscode.commands.registerCommand("otmath.solveSelection", () =>
      runSelectionCommand("solve", output)
    ),
    vscode.commands.registerCommand("otmath.explainSelection", () =>
      runSelectionCommand("explain", output, { explainOperation: "solve" })
    ),
    vscode.commands.registerCommand("otmath.insertLatexResult", () =>
      runSelectionCommand("latex", output, { insertResult: true })
    ),
    vscode.commands.registerCommand("otmath.showResult", () => runSelectionCommand("simplify", output))
  );
}

function readSettings(): ExtensionSettings {
  const config = vscode.workspace.getConfiguration("otmath");
  return {
    otcalcPath: config.get("otcalcPath", "otcalc"),
    provider: config.get("provider", "none"),
    privacyMode: config.get("privacyMode", "localOnly"),
    variable: config.get("variable", "x"),
  };
}

async function runSelectionCommand(
  command: OtMathCliCommand,
  output: vscode.OutputChannel,
  options: { insertResult?: boolean; explainOperation?: "solve" } = {}
): Promise<void> {
  const settings = readSettings();
  if (settings.privacyMode !== "localOnly") {
    vscode.window.showErrorMessage("OT Math currently supports only local-only privacy mode.");
    return;
  }

  const editor = vscode.window.activeTextEditor;
  const selection = editor?.document.getText(editor.selection);

  if (!selection) {
    vscode.window.showInformationMessage("Select a math expression first.");
    return;
  }

  try {
    const args = buildOtcalcArgs({
      command,
      expression: selection,
      variable: settings.variable,
      provider: settings.provider,
      noAi: true,
      format: command === "explain" ? "text" : undefined,
      explainOperation: options.explainOperation,
    });
    const result = await runOtcalc(settings.otcalcPath, args);

    if (options.insertResult && editor) {
      await editor.edit((edit) => edit.replace(editor.selection, result.stdout.trim()));
      return;
    }

    output.clear();
    output.append(result.stdout);
    if (result.stderr) {
      output.appendLine("");
      output.append(result.stderr);
    }
    output.show(true);
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    vscode.window.showErrorMessage(`OT Math failed: ${message}`);
  }
}

function runOtcalc(
  executable: string,
  args: string[]
): Promise<{ stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    execFile(executable, args, { windowsHide: true }, (error, stdout, stderr) => {
      if (error) {
        reject(new Error(stderr || error.message));
        return;
      }
      resolve({ stdout, stderr });
    });
  });
}

export function deactivate() {}
