# Security: {{PRODUCT}}

{{SENSITIVITY_SENTENCE}} Every control below has a test or a check in the Definition of Done.

## 1. Assets and actors

**Assets:** {{ASSETS}}

**Actors:** {{ACTORS}}

## 2. Threat model (condensed STRIDE)

| Threat | Example | Control |
|---|---|---|
{{THREAT_ROWS}}

## 3. Authentication and sessions

{{AUTH_CONTROLS}}

## 4. Authorization

Default deny. Every repository function filters by the owner. Foreign keys from the client are verified to belong to the user. Cross-user resources return 404.

## 5. Input, output, files, export

Strict Zod schemas with length and range caps. Prisma parameterizes queries, raw SQL uses bound parameters only. {{EXPORT_OR_UPLOAD_RULES}}

## 6. Transport, headers, browser

HTTPS only, HSTS in production, helmet with a strict CSP, single origin so no CORS surface, body limits, no `X-Powered-By`.

## 7. Privacy and logging

Logs never contain {{NEVER_LOG}}. Users can export and delete their data. Backups are encrypted and restore-tested. Seed accounts exist in development only.

## 8. Secrets and supply chain

Secrets only from environment variables. Lockfile committed, `npm audit` and Dependabot in CI, pinned images, non-root containers.

## 9. OWASP Top 10 (2021) mapping

| Risk | Handled by |
|---|---|
{{OWASP_ROWS}}

## 10. Required security tests

{{SECURITY_TESTS_NUMBERED}}
