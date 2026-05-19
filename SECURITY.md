# Security Policy

## Supported Versions

Only the latest public release is supported for security fixes.

## Reporting A Vulnerability

Open a private security advisory on GitHub or contact the maintainers privately. Do not publish exploit steps in a public issue before a fix is available.

Please include:

- Affected version or commit.
- Server stack, including framework and inventory resource.
- Reproduction steps.
- Expected and actual behavior.
- Any relevant server/client logs.

## Security Model

Inventory changes are server-side. The server validates clothing slot payloads, rate-limits conversion callbacks, and tracks pending wear confirmations so clients cannot mint refund items by calling the confirmation event directly.

The client still reads current ped clothing values before requesting conversion. Treat client-originated state as untrusted when adding new features, and keep all item grants behind server-side validation.
