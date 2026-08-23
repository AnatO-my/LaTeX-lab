# Security Policy

OT Math is local-first. Security work should protect users from accidental data disclosure, unsafe execution, malicious input, and dependency risk.

## Supported Versions

This scaffold is pre-alpha. Until the first release, security fixes should target the main development branch.

## Reporting Security Issues

Do not open a public issue for a vulnerability that could expose user data or enable code execution. Contact the maintainers privately once a security contact exists. Until then, mark the issue title as needing maintainer contact without publishing exploit details.

## Security Principles

- Never execute raw user math input as Python code.
- Validate AI provider output before using it.
- Keep provider keys user-owned and locally configured.
- Do not commit secrets.
- Avoid telemetry by default.
- Keep default tests offline.
- Document any feature that can send data outside the user's machine.
