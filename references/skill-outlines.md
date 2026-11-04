# Skill outlines

Pick the skills that fit the product. Each is a `SKILL.md` with a pushy `description`, numbered instructions, tests required, constraints. Templates for the generic ones are in `assets/templates/skills/`.

| Skill | Use for | Core content |
|---|---|---|
| `system-architect` | Always | Place the change in a module, model data first, define the contract, think in flows, non-functional checklist, ADR rows, prefer boring |
| `backend-api` | Always | Module template, contracts first, controller/service/repository, pagination, error shape, seed, constraints |
| `frontend-ui` | Always | Folder layout, foundation before screens, fixtures-first option, data hooks, URL state, forms, states, performance, accessibility, constraints |
| `design-review` | Always | Screenshots at 1440/768/390, balance check, craft tests, typography and states checks, web interface guidelines, report as Before/After/Why table |
| `testing-qa` | Always | Pyramid, domain table tests, integration against a real database, security tests, component tests, one end-to-end path with axe, naming, coverage |
| `auth-security` | Medium and up | Chosen auth design in implementation steps, scoping, CSRF, reset, uploads or export safety, headers, logging redaction, the required tests |
| `devops-optimization` | Medium and up | Dockerfiles, compose, Caddy, CI/CD, backups and restore doc, budgets, EXPLAIN, k6, Lighthouse, report before and after |
| `data-viz` | Products with charts | Finding sentence, chart forms allowed, scales, one hue, direct labels, accessibility, table alternative, states, tests |
| `domain skill` | Products with correctness traps | Finance (`finance-domain`): money, dates, pace, reports. Assessment (`assessment-engine`): quiz timing, grading, late penalty, progress. Others: inventory, booking, scheduling |

## Domain skill pattern

1. Goal in one sentence and the doc section that holds the rules.
2. The rules as numbered, testable statements.
3. The calculations as exact formulas.
4. "Tests required" with hand-computed expectations (write the expected numbers as literals in the test).
5. Constraints that forbid the common mistake (floats for money, client time, unscoped queries).

## Adding workflows

`/verify` (all gates), `/review-design`, `/security-review`, `/perf-audit`. Each ends with a short report.
