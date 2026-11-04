# {{PRODUCT}}

{{ONE_PARAGRAPH_DESCRIPTION}}

{{NAME_ORIGIN_LINE}}

## Features

{{FEATURES_BULLETS}}

## Tech stack

| Layer | Technology |
|---|---|
| Web | {{STACK_WEB}} |
| API | {{STACK_API}} |
| Data | {{STACK_DATA}} |
| Shared | `packages/contracts`: Zod schemas and shared functions |
| Tests | {{STACK_TESTS}} |
| Delivery | Docker, Docker Compose, Caddy, GitHub Actions |

## Documentation

| Document | Contents |
|---|---|
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | {{ARCH_CONTENTS}} |
| [docs/SECURITY.md](docs/SECURITY.md) | Threat model, controls, OWASP mapping, required security tests |
| [docs/DESIGN_SYSTEM.md](docs/DESIGN_SYSTEM.md) | {{DESIGN_CONTENTS}} |
| [docs/design-reference.html](docs/design-reference.html) | Visual reference. Open in a browser |

## Getting started

Requirements: Node.js 20+, Docker.

```bash
npm install
cp apps/api/.env.example apps/api/.env
docker compose up -d db mailpit
npm run db:migrate
npm run db:seed
npm run dev
```

Demo account (development seed only, never created in production): `{{DEMO_EMAIL}}` / `{{DEMO_PASSWORD}}`.

## Scripts

| Command | Purpose |
|---|---|
| `npm run dev` | Web and API with hot reload |
| `npm run build` | Production build of every workspace |
| `npm run lint` | ESLint, zero warnings allowed |
| `npm run typecheck` | `tsc --noEmit` everywhere |
| `npm run format` | Prettier |
| `npm run test` | Unit and integration tests |
| `npm run test:e2e` | Playwright |
| `npm run db:migrate` | Apply Prisma migrations |
| `npm run db:seed` | Seed demo data |
| `npm run perf:load` | k6 load test against a running API |

## Configuration (`apps/api/.env`)

| Variable | Purpose |
|---|---|
{{ENV_TABLE_ROWS}}

The API refuses to start when a required variable is missing or invalid.

## Conventions you must know

{{CONVENTIONS_BULLETS}}

## API

Base path `/api/v1`, interactive docs at `/api/docs` in development. Endpoint catalog: [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md#9-api-conventions-and-catalog).

## Testing

{{TESTING_BULLETS}}

## Deployment

Containers behind Caddy (automatic HTTPS): `web`, `api`, `db` and a nightly encrypted `backup` job.

```bash
cp deploy/.env.production.example deploy/.env.production
docker compose -f deploy/docker-compose.prod.yml --env-file deploy/.env.production up -d --build
docker compose -f deploy/docker-compose.prod.yml exec api npx prisma migrate deploy
```

Health: `GET /health`, `GET /ready`. Restore steps: `deploy/RESTORE.md`.

## Performance budgets

{{BUDGET_LINE}}

## Project structure

See [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md#14-repository-structure).

## Contributing

Conventional Commits. Before a pull request: `npm run lint && npm run typecheck && npm run test`. Architectural changes need an ADR row in `docs/ARCHITECTURE.md`.
