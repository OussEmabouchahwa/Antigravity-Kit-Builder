# Security rules (always on)

Authoritative detail is in `docs/SECURITY.md`.

1. Default deny: every route requires authentication unless explicitly public with a reason.
2. Never trust the client for owner ids, roles, timestamps, scores or prices.
3. Scope every query by the authenticated owner. Return 404 for other users' resources.
4. Validate at the edge with strict Zod schemas. Reject unknown keys.
5. {{AUTH_RULE}}
6. Passwords use argon2id. Auth responses never reveal whether an account exists.
7. Never log {{NEVER_LOG}}.
8. Never use `dangerouslySetInnerHTML` with user input.
9. helmet with a strict CSP, HSTS in production, rate limits on auth and write endpoints.
10. Any change touching auth, scoping, export or logging needs a matching security test.
