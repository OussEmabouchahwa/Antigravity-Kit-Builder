# Master prompt for Antigravity: {{PRODUCT}} {{PRODUCT_TYPE}}

How to use: put `.agents/`, `docs/` and `README.md` from this kit into an empty project folder, open it in Antigravity, choose **Planning** mode, and paste everything under the line below into the agent chat.

---

You are a senior full-stack engineer, system architect and product designer working as one team. Build **{{PRODUCT}}**, a production-quality **{{TASK_TITLE}}**, in this workspace. It must read like the work of an experienced team: {{QUALITY_HEADLINE}}. It must not look like a tutorial project or a generic AI-generated template.

## 0. Before writing any code

1. Read, in this order: `.agents/rules/*`, {{DOC_READ_ORDER}}, open and study `docs/design-reference.html`, `README.md`, then every skill in `.agents/skills/`. They are binding. The documents describe the target structure, scripts, API and design, and the finished project must match them.
2. Produce an implementation plan (Plan artifact): modules, data model, API contract, component tree, and the phases below with their checks. Then proceed without waiting unless a decision is genuinely ambiguous. If you must deviate from a document, add an ADR row and say why.

## 1. Product

{{PRODUCT_PARAGRAPH}} Roles: {{ROLES}}.

The key features, each working end to end:

1. **{{FEATURE_1}}:** {{FEATURE_1_DETAIL}}
2. **{{FEATURE_2}}:** {{FEATURE_2_DETAIL}}
3. **{{FEATURE_3}}:** {{FEATURE_3_DETAIL}}
4. **{{FEATURE_4}}:** {{FEATURE_4_DETAIL}}

## 2. Stack (fixed, do not substitute)

{{STACK_BULLETS}}

## 3. Phases (these follow the workflow steps of the task)

After each phase: run its checks, fix failures, update docs, commit with a Conventional Commit.

<!-- GUIDE: keep the order of the task's steps as headings, but sequence phases so dependencies work (foundation first; if auth comes last, scope all data by owner from the start with a dev-only auth stub; end with a quality phase and a deploy and optimize phase). Every phase ends with "Check:" naming a command or visible result. -->

### Step 1: {{STEP_1}}
- **Phase 1, scaffold and foundations:** {{PHASE_1}} Check: {{CHECK_1}}
- **Phase 2, {{PHASE_2_NAME}}:** {{PHASE_2}} Check: {{CHECK_2}}

### Step 2: {{STEP_2}}
- **Phase 3, {{PHASE_3_NAME}}:** {{PHASE_3}} Check: {{CHECK_3}}

### Step 3: {{STEP_3}}
- **Phase 4, {{PHASE_4_NAME}}:** {{PHASE_4}} Check: {{CHECK_4}}

### Step 4: {{STEP_4}}
- **Phase 5, {{PHASE_5_NAME}}:** {{PHASE_5}} Check: {{CHECK_5}}

### Step 5: {{STEP_5}}
- **Phase 6, {{PHASE_6_NAME}}:** {{PHASE_6}} Check: {{CHECK_6}}
- **Phase 7, quality pass:** run `/verify`, `/security-review` and `/review-design`. End-to-end path with axe checks. Fix everything reported.
- **Phase 8, deploy and optimize:** follow `devops-optimization`. Dockerfiles, production compose with Caddy, backups and restore doc, CI and release workflows, caching headers, budgets, load test, query review with before and after numbers. Check: `/perf-audit` meets the budgets and a clean machine can run the stack using only the README.

## 4. Quality bar

- Strict TypeScript, ESLint and Prettier clean with zero warnings. Every rule in `.agents/rules/` respected.
- {{DOMAIN_RULES_BULLET}}
- Interface follows the design system exactly: {{PALETTE_SUMMARY}}, {{TYPE_SUMMARY}}, {{SIGNATURE}} as the signature, no banned patterns.
- Accessible: WCAG 2.2 AA, keyboard operable, visible focus, labelled controls.
- Tests at every level, 85% line coverage on services and domain functions.
- Documentation accurate: README, architecture (with new ADR rows), security, deployment.

## 5. Do not

- Do not substitute the stack or add dependencies beyond those listed without an ADR.
- Do not put business logic in controllers, repositories or components.
- {{DOMAIN_DONOTS}}
- Do not use `any`, raw hex values in components, gradients, {{BANNED_VISUALS}}, emoji, or placeholder content.
- Do not weaken or delete a failing test or check to proceed.
- Do not add Redis, queues or Kubernetes. They are documented as the scaling path only.

## 6. Definition of done

- On a clean machine the commands in the README give a working app and the demo account works.
- `npm run lint`, `npm run typecheck`, `npm run test` and `npm run test:e2e` pass, including the security tests.
- All key features work end to end in the browser with the specified states.
- Production compose runs the stack with health checks, backups and the documented release process.
- Budgets met: {{BUDGETS}}.
- Final message includes a walkthrough: what was built, the architecture in a few lines, test and security results, performance numbers, screenshots at three widths, and every deviation from this brief with the reason.
