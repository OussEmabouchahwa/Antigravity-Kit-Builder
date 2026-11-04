---
name: auth-security
description: Implements and reviews authentication and application security for {{PRODUCT}}, including password hashing, {{AUTH_MECHANISM}}, CSRF or token rotation, password reset, rate limiting, owner scoping, safe export or upload, header policy and log redaction. Use when touching login, sessions or tokens, middleware, permissions, export, uploads, headers or anything handling untrusted input.
---

# Auth and security

## Goal
Implement the controls in `docs/SECURITY.md` and prove them with tests.

## Instructions
1. **Register and login.** Validate with Zod, hash with argon2id, identical responses and timing for unknown email and wrong password, throttle per IP and per account.
2. **{{AUTH_MECHANISM}}.** {{AUTH_STEPS}}
3. **Middleware.** `requireAuth` on every route except explicit public ones, plus a CI check that lists routes without it.
4. **Scoping.** Repositories take the owner id first and filter by it. Verify client-supplied foreign keys belong to the owner. Add a two-user test helper.
5. **Password reset.** Single-use random token stored hashed, short expiry, identical response for known and unknown emails, revoke all sessions on reset or change.
6. **Account export and deletion.** Real erase in one transaction, password required.
7. **{{EXPORT_OR_UPLOAD}}**
8. **Headers and limits.** helmet with the CSP from the security document, HSTS in production, body limits, rate limits on auth and write endpoints.
9. **Logging.** Redaction list and a test that proves no sensitive value reaches the logs.
10. **Tests.** Implement every test in `docs/SECURITY.md` section 10.

## Constraints
- Never accept owner ids, roles, timestamps or computed values from the client.
- Never log sensitive data.
- Never weaken a security test to make it pass.
