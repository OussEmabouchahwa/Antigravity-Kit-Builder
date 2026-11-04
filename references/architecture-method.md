# Architecture method

## Contents
1. Match the level
2. Stack choices
3. Layers and boundaries
4. Data model checklist
5. Auth options
6. Domain correctness rules
7. API conventions
8. Non-functional checklist
9. Deployment
10. ADRs and scalability path
11. Diagrams

## 1. Match the level

| Level | Style | Typical stack | Docs |
|---|---|---|---|
| Easy (CRUD) | Simple layered app, one repo | Node, Express, SQLite or PostgreSQL, plain or React frontend | README, DESIGN_SYSTEM, PROMPT, 2 rules, 3 to 4 skills |
| Medium (auth, reports, charts) | Layered monolith with a shared contracts package | React and Vite, Express, Prisma, PostgreSQL, Zod, custom SVG charts | + ARCHITECTURE, SECURITY, 8 to 9 skills |
| Advanced (roles, assessments, deploy) | Modular monolith with policies and domain events | React and Vite, NestJS, Prisma, PostgreSQL, Docker, CI/CD | + deployment and performance skills, 10 ADRs |

Do not use microservices, Kubernetes, Redis or queues unless the brief demands them. Document them as the scaling path.

## 2. Stack choices

- Monorepo with npm workspaces: `apps/web`, `apps/api`, `packages/contracts` (Zod schemas shared by both sides).
- TypeScript strict everywhere. Zod at the edge, types inferred.
- PostgreSQL with Prisma. Raw parameterized SQL only for aggregates and reports.
- Tailwind with tokens mapped from CSS variables. Radix for accessible primitives.
- Tests: Vitest, Supertest, Testing Library, Playwright with axe, k6.
- Delivery: Docker, Compose, Caddy (automatic HTTPS), GitHub Actions.

## 3. Layers and boundaries

`controller (HTTP only) -> service (rules, transactions) -> repository (only data access)`, plus pure `policy` and `domain` functions with no I/O. Modules call each other through service interfaces or domain events, never through another module's repository. Enforce with lint rules (`eslint-plugin-boundaries` or `dependency-cruiser`).

## 4. Data model checklist

For every entity: purpose, owner module, fields and types, owner column (`userId`), unique constraints, check constraints, indexes for the queries it serves, `onDelete` behavior, soft delete or not. Include an ERD (Mermaid) and a list of required indexes. Use `date` for calendar days, `timestamptz` for instants, integer minor units for money, `Decimal` for scores.

## 5. Auth options

| Option | Use when | Notes |
|---|---|---|
| **DB-backed cookie sessions** + CSRF token | First-party SPA, single origin | Simple revocation, no token in JavaScript. Medium level default |
| **Short JWT in memory + rotating refresh cookie** with reuse detection | Roles, many clients, Advanced | Refresh stored hashed, family revocation |
| Long-lived JWT in localStorage | Never | XSS exposure |

Always: argon2id, uniform responses for unknown accounts, rate limit and backoff, password reset with single-use hashed tokens, revoke sessions on password change.

Authorization is two layers: role guard on the route and ownership or membership policy in the service, with every query scoped by owner. Return 404 for other users' resources.

## 6. Domain correctness rules

State them as numbered rules in ARCHITECTURE and again in a domain skill:
- **Money:** integer minor units, currency exponent table (TND 3, EUR 2, USD 2), parsing by string operations, never floats.
- **Time:** calendar days as `date`, boundaries in the user's timezone, `now` injected for tests, half-open ranges.
- **Assessment:** server-authoritative deadlines, no answer leakage before submission, idempotent submit, shuffled options by stored seed.
- **Progress and grades:** one defined formula, recomputed transactionally, repairable by a command.

## 7. API conventions

Versioned base path, `{ data, meta }` and `{ error: { code, message, fields?, requestId } }`, cursor pagination for large feeds and page pagination for small lists, sort by allow-list, idempotent creates through client ids or idempotent state transitions, soft delete with restore for user mistakes, OpenAPI generated from the Zod contracts, an endpoint catalog table by module.

## 8. Non-functional checklist

Performance budgets stated as numbers (API p95, LCP, bundle size, Lighthouse), observability (structured logs with request id and no personal or financial data, `/health` and `/ready`), resilience (timeouts, body limits, graceful shutdown), data protection (export, delete, encrypted backups with a tested restore).

## 9. Deployment

Single host with Docker Compose behind Caddy: `caddy`, `web` (Nginx), `api`, `db`, `backup`. Same images in every environment, configuration through environment variables only, migrations as an explicit step, health checks and rollback in the release workflow. Single origin avoids CORS and keeps cookies first-party.

## 10. ADRs and scalability path

Each non-obvious decision gets a row: decision, why, alternatives rejected. Provide a table "pressure -> change" for what happens at 10x (Redis for shared rate limits, queue for slow work, read replica or rollups for reports, object storage for files, extract the busiest module).

## 11. Diagrams

Use Mermaid in fenced blocks: a context or container flowchart, an ERD, an auth sequence diagram, a state diagram for stateful flows, a deployment flowchart. Validate them with `scripts/validate_kit.py --mermaid` because a syntax error prevents rendering.
