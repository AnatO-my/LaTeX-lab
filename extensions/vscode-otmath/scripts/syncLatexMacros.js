const fs = require("node:fs");
const path = require("node:path");

const extensionRoot = path.resolve(__dirname, "..");
const repositoryRoot = path.resolve(extensionRoot, "..", "..");
const sourcePath = path.join(repositoryRoot, "integrations", "latex", "otmath.sty");
const targetDirectory = path.join(extensionRoot, "latex");
const targetPath = path.join(targetDirectory, "otmath.sty");

if (!fs.existsSync(sourcePath)) {
  throw new Error(`Missing OT Math LaTeX macro source: ${sourcePath}`);
}

fs.mkdirSync(targetDirectory, { recursive: true });
fs.copyFileSync(sourcePath, targetPath);
console.log(`Synced ${path.relative(repositoryRoot, sourcePath)} -> ${path.relative(repositoryRoot, targetPath)}`);
