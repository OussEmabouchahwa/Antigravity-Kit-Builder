---
name: backend-api
description: Builds the {{API_STACK}} REST API for {{PRODUCT}} with layered modules, Zod contracts, owner-scoped repositories, pagination, error handling, OpenAPI and seed data. Use when creating or changing modules, endpoints, migrations or server-side business rules.
---

# Backend API

## Goal
A typed, layered, secure API that matches `docs/ARCHITECTURE.md` and passes review without comments.

## Module template
```
modules/<name>/
  <name>.routes.ts, <name>.controller.ts, <name>.service.ts, <name>.repository.ts, <name>.test.ts
```

## Instructions
1. **Contracts first:** strict Zod objects, trimmed strings with length caps, coerced query numbers, validated ids and dates.
2. **Controllers** parse, call one service function, return `{ data, meta? }` with the right status.
3. **Services** hold rules, throw `AppError(code, status, message, fields?)`, verify ownership of foreign keys.
4. **Repositories** return plain objects, take the owner id first, use explicit `select`.
5. **Pagination and filters:** caps, allow-listed sorting, {{PAGINATION_STYLE}}.
6. **Global pieces:** request id, pino-http, error handler with the standard shape, graceful shutdown, OpenAPI generation.
7. **Seed:** development only, idempotent, realistic and diverse data, dates relative to today. {{SEED_DETAILS}}
8. {{DOMAIN_ENDPOINT_NOTES}}

## Constraints
- No business logic in controllers or repositories.
- No unscoped query, no `any`, no unbounded list.
- No cross-module repository imports.
