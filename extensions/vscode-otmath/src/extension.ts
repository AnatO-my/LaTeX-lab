import { execFile } from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import * as vscode from "vscode";

import {
  buildLatexBuildArgs,
  buildOtcalcArgs,
  detectGeneratedLatexOutput,
  hasOtMathLatexRequests,
  OtMathCliCommand,
  SUPPORTED_SELECTION_COMMANDS,
} from "./commandBuilder";

interface ExtensionSettings {
  otcalcPath: string;
  provider: "none";
  privacyMode: "localOnly";
  variable: string;
  latexEngine: string;
  refreshLatexOnSave: boolean;
}

interface OtcalcInvocation {
  executable: string;
  args: string[];
  cwd?: string;
}

const latexRefreshesInFlight = new Set<string>();
type SelectionOperation = Exclude<OtMathCliCommand, "latex" | "explain">;
const RANGE_OPERATIONS = new Set<SelectionOperation>(["sum", "product"]);
const STAT_SAMPLE_OPERATIONS = new Set<SelectionOperation>(["variance", "stdev"]);

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
    vscode.commands.registerCommand("otmath.showResult", () =>
      runSelectionCommand("simplify", output)
    ),
    vscode.commands.registerCommand("otmath.runSelectedOperation", () =>
      runSelectedOperation(output)
    ),
    vscode.commands.registerCommand("otmath.refreshLatexResults", () =>
      runLatexBuildCommand(output)
    ),
    vscode.commands.registerCommand("otmath.buildLatexDocument", () =>
      runLatexBuildCommand(output, { compile: true })
    ),
    vscode.commands.registerCommand("otmath.refreshAndViewLatexDocument", () =>
      runLatexBuildCommand(output, { compile: true, viewPdf: true })
    ),
    vscode.commands.registerCommand("otmath.installLatexMacros", () =>
      installLatexMacros(context, output)
    ),
    vscode.commands.registerCommand("otmath.diagnose", () =>
      diagnoseExtension(context, output)
    ),
    vscode.workspace.onDidSaveTextDocument((document) =>
      refreshLatexResultsOnSave(document, output)
    )
  );

  output.appendLine("OT Math extension activated.");
}

function readSettings(): ExtensionSettings {
  const config = vscode.workspace.getConfiguration("otmath");
  return {
    otcalcPath: config.get("otcalcPath", "otcalc"),
    provider: config.get("provider", "none"),
    privacyMode: config.get("privacyMode", "localOnly"),
    variable: config.get("variable", "x"),
    latexEngine: config.get("latexEngine", "pdflatex"),
    refreshLatexOnSave: config.get("refreshLatexOnSave", true),
  };
}

async function runSelectionCommand(
  command: OtMathCliCommand,
  output: vscode.OutputChannel,
  options: {
    insertResult?: boolean;
    explainOperation?: SelectionOperation;
    variableOverride?: string;
  } = {}
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
      variable: options.variableOverride ?? settings.variable,
      provider: settings.provider,
      noAi: true,
      format: command === "explain" ? "text" : undefined,
      explainOperation: options.explainOperation,
    });
    const invocation = resolveOtcalcInvocation(settings, args, editor?.document.uri.fsPath);
    const result = await runOtcalc(invocation);

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

async function runSelectedOperation(output: vscode.OutputChannel): Promise<void> {
  const operation = await vscode.window.showQuickPick(
    SUPPORTED_SELECTION_COMMANDS.map((command) => ({
      label: operationLabel(command),
      description: command,
      command,
    })),
    { placeHolder: "Choose an OT Math operation for the selected expression." }
  );
  if (!operation) {
    return;
  }

  const settings = readSettings();
  const defaultVariable = defaultVariableForOperation(operation.command, settings.variable);
  const variable = await vscode.window.showInputBox({
    prompt: "Variable, mode, range, exponent, or target unit.",
    value: defaultVariable,
  });
  if (variable === undefined) {
    return;
  }

  await runSelectionCommand(operation.command, output, {
    variableOverride: variable.trim() || defaultVariable,
  });
}

async function diagnoseExtension(
  context: vscode.ExtensionContext,
  output: vscode.OutputChannel
): Promise<void> {
  const settings = readSettings();
  const editor = vscode.window.activeTextEditor;
  const document = editor?.document;
  const sourceText = document?.getText() ?? "";
  const sourcePath = document?.uri.fsPath;
  const outputPath =
    document && sourcePath ? detectGeneratedLatexOutput(sourceText, sourcePath) : undefined;
  const refreshInvocation =
    sourcePath && document
      ? resolveOtcalcInvocation(
          settings,
          buildLatexBuildArgs({
            sourcePath,
            outputPath,
          }),
          sourcePath
        )
      : undefined;
  const buildInvocation =
    sourcePath && document
      ? resolveOtcalcInvocation(
          settings,
          buildLatexBuildArgs({
            sourcePath,
            outputPath,
            compile: true,
            engine: settings.latexEngine,
          }),
          sourcePath
        )
      : undefined;

  output.clear();
  output.appendLine("OT Math Extension Diagnostics");
  output.appendLine("");
  output.appendLine(`Extension mode: ${context.extensionMode}`);
  output.appendLine(`Extension path: ${context.extensionUri.fsPath}`);
  output.appendLine(`Workspace folders: ${formatWorkspaceFolders()}`);
  output.appendLine("");
  output.appendLine("Bundled LaTeX Macros");
  const bundledMacrosPath = context.asAbsolutePath(path.join("latex", "otmath.sty"));
  output.appendLine(`  path: ${bundledMacrosPath}`);
  output.appendLine(`  exists: ${fs.existsSync(bundledMacrosPath)}`);
  output.appendLine("");
  output.appendLine("Settings");
  output.appendLine(`  otcalcPath: ${settings.otcalcPath}`);
  output.appendLine(`  provider: ${settings.provider}`);
  output.appendLine(`  privacyMode: ${settings.privacyMode}`);
  output.appendLine(`  variable: ${settings.variable}`);
  output.appendLine(`  latexEngine: ${settings.latexEngine}`);
  output.appendLine(`  refreshLatexOnSave: ${settings.refreshLatexOnSave}`);
  output.appendLine("");
  output.appendLine("Active Document");
  output.appendLine(`  uri: ${document?.uri.toString() ?? "(none)"}`);
  output.appendLine(`  fsPath: ${sourcePath ?? "(none)"}`);
  output.appendLine(`  languageId: ${document?.languageId ?? "(none)"}`);
  output.appendLine(`  isLocalTexDocument: ${document ? isLocalTexDocument(document) : false}`);
  output.appendLine(`  contains OT Math requests: ${hasOtMathLatexRequests(sourceText)}`);
  output.appendLine(`  detected generated include: ${outputPath ?? "(default)"}`);
  output.appendLine("");
  output.appendLine("Resolved Commands");
  output.appendLine(`  refresh: ${refreshInvocation ? formatInvocation(refreshInvocation) : "(none)"}`);
  if (refreshInvocation?.cwd) {
    output.appendLine(`  refresh cwd: ${refreshInvocation.cwd}`);
  }
  output.appendLine(`  build: ${buildInvocation ? formatInvocation(buildInvocation) : "(none)"}`);
  if (buildInvocation?.cwd) {
    output.appendLine(`  build cwd: ${buildInvocation.cwd}`);
  }
  output.appendLine("");
  output.appendLine("CLI Probe");
  const probeInvocation = resolveOtcalcInvocation(settings, ["--version"], sourcePath);
  output.appendLine(`  version command: ${formatInvocation(probeInvocation)}`);
  try {
    const probe = await runOtcalc(probeInvocation);
    output.appendLine(`  version output: ${probe.stdout.trim() || "(empty)"}`);
    if (probe.stderr) {
      output.appendLine(`  version stderr: ${probe.stderr.trim()}`);
    }
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    output.appendLine(`  version failed: ${message}`);
  }
  output.show(true);
}

function operationLabel(command: SelectionOperation): string {
  return command
    .split("_")
    .flatMap((part) => part.split(/(?=[A-Z])/u))
    .join(" ")
    .replace(/\b\w/gu, (letter) => letter.toUpperCase());
}

function defaultVariableForOperation(command: SelectionOperation, configuredVariable: string): string {
  if (command === "system") {
    return "x,y";
  }
  if (command === "nsolve") {
    return "x,1";
  }
  if (RANGE_OPERATIONS.has(command)) {
    return "k,1,n";
  }
  if (command === "limit") {
    return "x,0,+-";
  }
  if (command === "mpow") {
    return "2";
  }
  if (STAT_SAMPLE_OPERATIONS.has(command)) {
    return "sample";
  }
  if (command === "unit") {
    return "meter";
  }
  return configuredVariable;
}

function formatWorkspaceFolders(): string {
  const folders = vscode.workspace.workspaceFolders ?? [];
  if (folders.length === 0) {
    return "(none)";
  }
  return folders.map((folder) => folder.uri.fsPath).join("; ");
}

async function runLatexBuildCommand(
  output: vscode.OutputChannel,
  options: { compile?: boolean; viewPdf?: boolean } = {}
): Promise<void> {
  const settings = readSettings();
  if (settings.privacyMode !== "localOnly") {
    vscode.window.showErrorMessage("OT Math currently supports only local-only privacy mode.");
    return;
  }

  const editor = vscode.window.activeTextEditor;
  if (
    !editor ||
    editor.document.uri.scheme !== "file" ||
    !editor.document.uri.fsPath.toLowerCase().endsWith(".tex")
  ) {
    vscode.window.showInformationMessage("Open a .tex document first.");
    return;
  }

  if (editor.document.isDirty && !(await editor.document.save())) {
    vscode.window.showErrorMessage("OT Math could not save the current .tex document.");
    return;
  }

  const sourcePath = editor.document.uri.fsPath;
  await runLatexBuildForDocument(editor.document, output, settings, options, { reveal: true });
}

async function installLatexMacros(
  context: vscode.ExtensionContext,
  output: vscode.OutputChannel
): Promise<void> {
  const sourcePath = context.asAbsolutePath(path.join("latex", "otmath.sty"));
  if (!fs.existsSync(sourcePath)) {
    vscode.window.showErrorMessage("OT Math bundled LaTeX macros are missing from this extension.");
    return;
  }

  const targetDirectory = resolveLatexMacroInstallDirectory();
  if (!targetDirectory) {
    vscode.window.showInformationMessage("Open a .tex document or workspace first.");
    return;
  }

  const targetPath = path.join(targetDirectory, "otmath.sty");
  if (fs.existsSync(targetPath)) {
    const choice = await vscode.window.showWarningMessage(
      `otmath.sty already exists in ${targetDirectory}. Replace it with the bundled copy?`,
      { modal: true },
      "Replace"
    );
    if (choice !== "Replace") {
      return;
    }
  }

  await fs.promises.copyFile(sourcePath, targetPath);
  output.appendLine(`Installed bundled LaTeX macros: ${targetPath}`);
  output.show(true);
  vscode.window.showInformationMessage(`Installed OT Math LaTeX macros to ${targetPath}`);
}

function resolveLatexMacroInstallDirectory(): string | undefined {
  const editor = vscode.window.activeTextEditor;
  const activeDocument = editor?.document;
  if (activeDocument && isLocalTexDocument(activeDocument)) {
    return path.dirname(activeDocument.uri.fsPath);
  }
  return vscode.workspace.workspaceFolders?.[0]?.uri.fsPath;
}

async function refreshLatexResultsOnSave(
  document: vscode.TextDocument,
  output: vscode.OutputChannel
): Promise<void> {
  const settings = readSettings();
  const timestamp = new Date().toLocaleTimeString();
  if (isLocalTexDocument(document)) {
    output.appendLine(`[${timestamp}] save detected: ${document.uri.fsPath}`);
  }

  if (!settings.refreshLatexOnSave || settings.privacyMode !== "localOnly") {
    if (isLocalTexDocument(document)) {
      output.appendLine(
        `[${timestamp}] save skipped: refreshLatexOnSave=${settings.refreshLatexOnSave}, privacyMode=${settings.privacyMode}`
      );
    }
    return;
  }
  if (!isLocalTexDocument(document)) {
    return;
  }
  if (!hasOtMathLatexRequests(document.getText())) {
    output.appendLine(`[${timestamp}] save skipped: no OT Math requests found.`);
    return;
  }

  const sourcePath = document.uri.fsPath;
  if (latexRefreshesInFlight.has(sourcePath)) {
    output.appendLine(`[${timestamp}] save skipped: refresh already in flight.`);
    return;
  }

  latexRefreshesInFlight.add(sourcePath);
  try {
    output.appendLine(`[${timestamp}] save refresh started.`);
    void vscode.window.setStatusBarMessage(
      `OT Math refreshing ${path.basename(sourcePath)}...`,
      3000
    );
    await runLatexBuildForDocument(document, output, settings, {}, { reveal: false });
  } catch (error) {
    const message = error instanceof Error ? error.message : String(error);
    output.appendLine(`[${timestamp}] save refresh failed: ${message}`);
    vscode.window.showWarningMessage(`OT Math LaTeX refresh on save failed: ${message}`);
  } finally {
    latexRefreshesInFlight.delete(sourcePath);
  }
}

async function runLatexBuildForDocument(
  document: vscode.TextDocument,
  output: vscode.OutputChannel,
  settings: ExtensionSettings,
  options: { compile?: boolean; viewPdf?: boolean } = {},
  display: { reveal: boolean } = { reveal: true }
): Promise<void> {
  const sourcePath = document.uri.fsPath;
  const outputPath = detectGeneratedLatexOutput(document.getText(), sourcePath);
  const args = buildLatexBuildArgs({
    sourcePath,
    outputPath,
    compile: options.compile,
    engine: options.compile ? settings.latexEngine : undefined,
  });
  const invocation = resolveOtcalcInvocation(settings, args, sourcePath);

  if (display.reveal) {
    output.clear();
  } else {
    output.appendLine("");
  }
  output.appendLine(`Running: ${formatInvocation(invocation)}`);
  if (invocation.cwd) {
    output.appendLine(`Working directory: ${invocation.cwd}`);
  }
  output.appendLine("");
  if (display.reveal) {
    output.show(true);
  }

  const result = await runOtcalc(invocation);
  output.append(result.stdout);
  if (result.stderr) {
    output.appendLine("");
    output.append(result.stderr);
  }

  const generatedTarget = outputPath ? ` using ${outputPath}` : "";
  const action = options.compile ? "built" : "refreshed";
  void vscode.window.setStatusBarMessage(
    `OT Math ${action} ${path.basename(sourcePath)}${generatedTarget}.`,
    5000
  );

  if (options.viewPdf) {
    await openCompiledPdf(sourcePath);
  } else if (display.reveal) {
    output.show(true);
  }
}

function isLocalTexDocument(document: vscode.TextDocument): boolean {
  return document.uri.scheme === "file" && document.uri.fsPath.toLowerCase().endsWith(".tex");
}

async function openCompiledPdf(sourcePath: string): Promise<void> {
  const pdfPath = sourcePath.replace(/\.tex$/i, ".pdf");
  try {
    await vscode.commands.executeCommand("latex-workshop.view");
    return;
  } catch {
    await vscode.commands.executeCommand(
      "vscode.open",
      vscode.Uri.file(pdfPath),
      vscode.ViewColumn.Beside
    );
  }
}

function resolveOtcalcInvocation(
  settings: ExtensionSettings,
  args: string[],
  contextPath?: string
): OtcalcInvocation {
  const configuredPath = settings.otcalcPath.trim();
  const cwd = contextPath ? path.dirname(contextPath) : undefined;
  if (configuredPath && configuredPath !== "otcalc") {
    return { executable: configuredPath, args, cwd };
  }

  const workspaceFolder = contextPath
    ? vscode.workspace.getWorkspaceFolder(vscode.Uri.file(contextPath))
    : vscode.workspace.workspaceFolders?.[0];
  const workspaceRoot = workspaceFolder?.uri.fsPath;
  if (workspaceRoot) {
    const pythonExecutable =
      process.platform === "win32"
        ? path.join(workspaceRoot, ".venv", "Scripts", "python.exe")
        : path.join(workspaceRoot, ".venv", "bin", "python");
    if (fs.existsSync(pythonExecutable)) {
      return {
        executable: pythonExecutable,
        args: ["-m", "otcalc.cli", ...args],
        cwd: cwd ?? workspaceRoot,
      };
    }
  }

  return { executable: configuredPath || "otcalc", args, cwd };
}

function formatInvocation(invocation: OtcalcInvocation): string {
  return [invocation.executable, ...invocation.args].map(quoteForDisplay).join(" ");
}

function quoteForDisplay(value: string): string {
  if (!/[\s"]/u.test(value)) {
    return value;
  }
  return `"${value.replace(/"/g, '\\"')}"`;
}

function runOtcalc(invocation: OtcalcInvocation): Promise<{ stdout: string; stderr: string }> {
  return new Promise((resolve, reject) => {
    execFile(
      invocation.executable,
      invocation.args,
      { cwd: invocation.cwd, windowsHide: true },
      (error, stdout, stderr) => {
        if (error) {
          reject(new Error(stderr || error.message));
          return;
        }
        resolve({ stdout, stderr });
      }
    );
  });
}

export function deactivate() {}
