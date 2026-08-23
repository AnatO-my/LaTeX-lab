# Getting Started

This guide takes OT Math from a fresh checkout to a working local calculator.

## Install From Source

```bash
git clone https://github.com/otmath/ot-math.git
cd ot-math
python -m venv .venv
python -m pip install -e ".[dev]"
```

On Windows PowerShell, activate the virtual environment with:

```powershell
.\.venv\Scripts\Activate.ps1
```

On macOS or Linux, activate it with:

```bash
source .venv/bin/activate
```

## Verify The Install

```bash
python -m pytest
otcalc --version
otcalc solve "x**2 - 5*x + 6"
```

Expected solve output includes `2` and `3`.

## Try Common Workflows

```bash
otcalc simplify "(x + 1)**2 - x**2"
otcalc diff "x**3" --format latex
otcalc integrate "2*x"
otcalc factor "x**2 - 5*x + 6"
otcalc expand "(x - 2)*(x - 3)"
otcalc system "x + y = 5; x - y = 1" --variable "x,y"
otcalc explain "x**2 - 5*x + 6 = 0" --operation solve
```

## Privacy Defaults

OT Math runs locally by default. The deterministic engine and default CLI do not call
cloud AI providers, do not require API keys, and do not write command history unless
history is explicitly enabled.

## Next Steps

- Read [cli.md](cli.md) for command syntax.
- Read [api-engine.md](api-engine.md) for Python usage.
- Read [example-gallery.md](example-gallery.md) for copyable examples.
- Read [known-limitations.md](known-limitations.md) before relying on beta behavior.
