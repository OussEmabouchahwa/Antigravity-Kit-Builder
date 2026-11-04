# Security method

Security is a feature with acceptance criteria. Every control gets a test.

## SECURITY.md structure
1. Assets and actors
2. Threat model table (STRIDE condensed): threat, concrete example in this product, control
3. Authentication, sessions or tokens, CSRF, password reset
4. Authorization and scoping
5. Input, output, files, export
6. Transport, headers, browser
7. Privacy and logging
8. Secrets and supply chain
9. OWASP Top 10 mapping
10. **Required security tests** (numbered list the agent must implement)

## Controls to include by default
- argon2id; uniform auth responses and timing; throttling per IP and per account; no permanent lockout
- Opaque hashed session ids or rotating hashed refresh tokens with reuse detection; new id at login; revoke all on password change
- CSRF token header plus Origin check (cookie auth), SameSite=Lax or Strict, `__Host-` cookie prefix in production
- Default-deny routes with a CI check; owner column filter in every repository query; foreign keys from the client verified to belong to the owner; 404 not 403 for others' data
- Strict Zod schemas that reject unknown keys, caps on lengths, ranges and page sizes
- helmet and a strict CSP, HSTS, body size limits, no `X-Powered-By`
- Log redaction by key list and a test that proves it (never log amounts, notes, emails, tokens, answers)
- Uploads: allow-list by extension and magic bytes, size cap, random names, outside the web root, authorized download with `nosniff`
- CSV export injection guard: prefix cells starting with `=`, `+`, `-`, `@`, tab or carriage return
- Account export and real account deletion
- `npm audit`, Dependabot, pinned images, non-root containers

## Required tests (adapt to the product, aim for 10 to 12)
1. Cross-user read, update, delete are 404
2. Foreign keys from another user rejected
3. Unknown or privileged body fields ignored or rejected
4. CSRF and Origin enforced
5. Uniform login and reset responses
6. Sessions or tokens revoked after logout everywhere and password change
7. Expiry enforced
8. Rate limit returns 429
9. Export injection neutralized
10. Logs contain no sensitive values
11. Security headers present
12. Account deletion removes only that user's data

Add product-specific ones (quiz answer leakage, deadline enforcement, upload type mismatch, Markdown XSS).
