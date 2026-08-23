# Configuration

OT Math works without a config file. Defaults remain local-first:

- provider: `none`
- privacy mode: `local`
- history: disabled
- quiet mode: disabled

## Discovery

Configuration is optional. The CLI checks paths in this order:

1. `--config PATH`
2. `OTMATH_CONFIG`
3. `.otmath.json` in the current directory
4. the user config path:
   - Windows: `%APPDATA%\otmath\config.json`
   - macOS/Linux: `~/.config/otmath/config.json`

Use:

```bash
otcalc config path
otcalc config show --format json
```

## Schema

```json
{
  "provider": "none",
  "privacy_mode": "local",
  "history": false,
  "history_file": ".otmath_history.jsonl",
  "quiet": false
}
```

Only `provider: "none"` and `privacy_mode: "local"` are supported in this scaffold.

## Environment Overrides

- `OTMATH_CONFIG`
- `OTMATH_PROVIDER`
- `OTMATH_PRIVACY_MODE`
- `OTMATH_HISTORY`
- `OTMATH_HISTORY_FILE`
- `OTMATH_QUIET`

Boolean values accept `true/false`, `yes/no`, `on/off`, or `1/0`.

## Privacy

History remains disabled unless config, environment, or CLI flags opt in. Config output
is redacted before display.
