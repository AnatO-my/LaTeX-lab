# OT Math VS Code Extension

This extension connects editor selections to the local `otcalc` CLI.

## Commands

- `OT Math: Solve Selection`
- `OT Math: Explain Selection`
- `OT Math: Insert LaTeX Result`
- `OT Math: Show Result`

## Settings

- `otmath.otcalcPath`: path to the local `otcalc` command, default `otcalc`
- `otmath.provider`: provider mode, currently only `none`
- `otmath.privacyMode`: privacy mode, currently only `localOnly`
- `otmath.variable`: default variable, default `x`

## Development

```bash
npm install
npm test
```

The test script compiles TypeScript and runs command assembly tests. Manual VS Code
extension-host verification is still required before release.

## Privacy

The extension calls only the configured local `otcalc` command. It passes `--no-ai` and
supports only local-only privacy mode in this scaffold.
