---
name: devops-optimization
description: Containerizes, deploys and optimizes {{PRODUCT}} using multi-stage Docker builds, Docker Compose, Caddy HTTPS, nightly encrypted backups, GitHub Actions CI/CD, health checks, query tuning, caching headers, bundle budgets and k6 load tests. Use when working on Dockerfiles, compose files, pipelines, environment configuration, performance, observability or release steps.
---

# DevOps and optimization

## Goal
One command to run locally, a repeatable path to production, performance measured against stated budgets.

## Deployment assets (`deploy/`)
1. Multi-stage Dockerfiles, pinned base images, non-root, `.dockerignore`: `api.Dockerfile`, `web.Dockerfile`.
2. Root `docker-compose.yml` for development services (`db`, `mailpit`).
3. `deploy/docker-compose.prod.yml`: `caddy`, `web`, `api`, `db`, `backup`, healthchecks, restart policy, resource limits, only 80 and 443 published, single origin.
4. `Caddyfile` (automatic HTTPS, HSTS, compression, `/api` proxy) and `nginx.conf` (SPA fallback, immutable cache for hashed assets).
5. Nightly encrypted `pg_dump` with retention, and `RESTORE.md` with steps that were actually tested.
6. `.env.production.example` with every variable. Migrations as an explicit step before the new API takes traffic.

## CI/CD
- `ci.yml` on pull requests: install with cache, lint, typecheck, tests with a database service, build, `npm audit --omit=dev`, Playwright on main.
- `release.yml` on tags: build and push images, deploy over SSH, migrate, health check, automatic rollback if `/ready` fails.

## Optimization
1. Confirm the architecture indexes, run `EXPLAIN (ANALYZE, BUFFERS)` on list and report queries with realistic volume, record before and after.
2. API: compression, `ETag` on reads, pagination caps, timeouts, pool size.
3. Web: route-level splitting, lazy charts, font preload, reserved space, budgets ({{WEB_BUDGETS}}).
4. `perf/k6/main.js` with thresholds ({{API_BUDGETS}}), exposed as `npm run perf:load`. Lighthouse CI on the main screen.
5. Observability: JSON logs with `requestId` and no sensitive data, `/health`, `/ready`, documented alerts.

## Constraints
- No secrets in images or git, no `latest` tags, no root containers.
- No Redis, queue or Kubernetes without a measured need and an ADR.
