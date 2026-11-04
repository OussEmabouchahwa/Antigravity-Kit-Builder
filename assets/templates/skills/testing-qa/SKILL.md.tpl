---
name: testing-qa
description: Writes and runs unit, integration, security, component and end-to-end tests for {{PRODUCT}} using Vitest, Supertest, Testing Library, Playwright with axe and k6, including hand-computed domain tests. Use when adding or changing behavior, fixing bugs, validating a phase or checking coverage.
---

# Testing and QA

## Goal
Every behavior that matters has a test that fails when it breaks.

## Instructions
1. **Pyramid:** exhaustive table-driven tests for pure domain functions, integration tests against a real database, focused component tests, one end-to-end path per role.
2. **Domain tests:** {{DOMAIN_TESTS}} Write expected values as literals computed by hand.
3. **API integration:** every endpoint and status code, idempotency, pagination continuity, soft delete and restore where applicable.
4. **Security tests:** every test in `docs/SECURITY.md` section 10 in `security.test.ts`.
5. **Component tests:** query by role and accessible name. Cover states, keyboard paths and text alternatives of charts.
6. **End to end:** the main user journeys with axe checks (zero serious or critical), screenshots at 1440 and 390.
7. **Clock control:** inject `now`, use fake timers in the web tests.
8. **Naming:** behavior, not implementation.
9. **Coverage:** 85% lines on services and domain functions.
10. **Report:** passed and failed, coverage, untested behavior and why.

## Constraints
- Never edit a test to make it pass without explaining the behavior change.
- Never mock what can run for real.
- No arbitrary sleeps.
