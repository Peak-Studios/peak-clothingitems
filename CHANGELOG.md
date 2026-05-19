# Changelog

## 1.0.0 - 2026-05-19

- Prepared the resource for open-source release.
- Added 15 transparent 256x256 clothing item icons.
- Added release documentation, contribution guidance, security policy, and troubleshooting notes.
- Added server-side pending wear tracking so forged wear failure confirmations cannot grant clothing items.
- Added stricter server validation for clothing removal payloads.
- Added server-side removal cooldown checks.
- Improved bulk removal so the client only resets slots that the server successfully converted into items.
