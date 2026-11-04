# Project standards (always on)

Binding for every file written in this workspace. If a task seems to require breaking a rule, stop and explain why instead of breaking it silently.

## Code quality
- TypeScript `strict: true` everywhere. No `any`, no `@ts-ignore`, no non-null assertion without a comment.
- One responsibility per function and file. Functions under 40 lines, files under 250 lines (React components under 150).
- Names reveal intent. Early returns over nesting. No boolean flag parameters.
- No magic numbers or strings. No commented-out code, no stray `console.log`, no `TODO` without an issue reference.
- Never swallow errors. Throw typed errors with a stable `code`.

## Architecture
- `controller -> service -> repository`, pure functions in `domain/`. Only repositories touch the database.
- Every request and response shape is a Zod schema in `packages/contracts`. Types are inferred.
- Web is organized by feature. Server state in TanStack Query, form state in React Hook Form, filters in the URL.
- {{DOMAIN_RULE_1}}
- {{DOMAIN_RULE_2}}

## Database
- Every schema change is a migration. Never edit an applied migration. Explicit `select`. Bound parameters only. Indexes from the architecture document.

## Configuration, git, gates
- Configuration from environment variables validated at startup.
- Conventional Commits. A phase is finished only when lint, typecheck and tests pass with zero warnings.
- Docs stay true: update README, architecture or security in the same change. ADR row for architectural decisions.
