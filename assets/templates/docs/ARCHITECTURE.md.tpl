# Architecture: {{PRODUCT}}

## 1. Goals and quality attributes

| Attribute | Target |
|---|---|
| Correctness | {{CORRECTNESS_TARGET}} |
| Security | {{SECURITY_TARGET}} |
| Clarity | A new developer understands the layers in an hour |
| Performance | {{PERF_TARGET}} |
| Testability | Business rules are pure functions testable without HTTP or a database |
| Operability | One command locally, health checks, structured logs, repeatable deploys |

Scale: {{SCALE}}. The scaling path is in section 12.

## 2. Style

{{STYLE_PARAGRAPH}}

```
controller   HTTP only: parse with Zod, call service, shape response
  -> service     use cases and business rules
    -> repository  the only code that touches the database
domain/      pure functions (no I/O)
```

Modules: {{MODULES}}. Modules call each other only through service interfaces or domain events.

## 3. System context

```mermaid
flowchart TB
  U([User]) -->|HTTPS| C[Caddy]
  C -->|static| W[Web: React SPA]
  C -->|/api| A[API]
  A --> D[(PostgreSQL)]
```

## 4. Data model

```mermaid
erDiagram
  USER ||--o{ ENTITY : owns
  USER {
    uuid id PK
    string email UK
  }
  ENTITY {
    uuid id PK
    uuid userId FK
  }
```

<!-- GUIDE: replace the ERD with the real entities. Then list constraints and indexes: unique, check, owner column, indexes for each query, onDelete, soft delete. -->

**Constraints and indexes (required):** {{CONSTRAINTS_AND_INDEXES}}

## 5. Domain rules

{{DOMAIN_RULES_NUMBERED}}

## 6. Authentication and session design

```mermaid
sequenceDiagram
  participant B as Browser
  participant A as API
  participant D as Database
  B->>A: POST /auth/login
  A->>D: verify credentials, create session
  A-->>B: 200 and Set-Cookie
```

{{AUTH_DETAILS}} Details and threats are in [SECURITY.md](SECURITY.md).

## 7. Authorization

{{AUTHZ_DETAILS}}

## 8. Key flows

{{KEY_FLOWS}}

## 9. API conventions and catalog

- Base path `/api/v1`. Success `{ data, meta? }`. Error `{ error: { code, message, fields?, requestId } }`.
- Statuses: 200, 201, 204, 400, 401, 403, 404, 409, 422, 429, 500.
- {{PAGINATION_AND_IDEMPOTENCY}}

| Module | Endpoints |
|---|---|
{{ENDPOINT_ROWS}}

## 10. Non-functional design

**Performance:** {{PERF_DESIGN}}

**Observability:** structured JSON logs with `requestId`, never any personal or sensitive data. `/health` and `/ready`.

**Resilience:** timeouts, body limits, graceful shutdown, migrations as an explicit deploy step.

**Data protection:** export, real deletion, encrypted backups with a tested restore.

## 11. Deployment architecture

```mermaid
flowchart LR
  GH[GitHub Actions] -->|build, test, push| R[(Registry)]
  R -->|pull on deploy| S
  subgraph S[Single host with Docker Compose]
    C[Caddy] --> N[Nginx web]
    C --> A[API]
    A --> P[(PostgreSQL)]
  end
```

## 12. Scalability path

| Pressure | Change |
|---|---|
{{SCALE_ROWS}}

## 13. Architecture decision records

| ADR | Decision | Why | Alternatives rejected |
|---|---|---|---|
{{ADR_ROWS}}

New decisions get a new row in the same change that introduces them.

## 14. Repository structure

```
{{REPO_TREE}}
```
