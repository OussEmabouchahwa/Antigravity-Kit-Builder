# Kit anatomy

## Contents
1. File inventory and contents
2. Antigravity format
3. Mapping the five task steps to phases
4. PROMPT.md structure
5. Rules, skills and workflows: how to write them
6. Consistency checklist

## 1. File inventory and contents

| File | Must contain |
|---|---|
| `PROMPT.md` | Usage line, role, section 0 "read everything first and plan", product, fixed stack, phases with checks, quality bar, do-not list, definition of done |
| `README.md` | Features, stack table, doc links, getting started, scripts table, env variables, conventions, API summary, testing, deployment, budgets, structure, contributing. Written as the project's final README |
| `docs/DESIGN_SYSTEM.md` | Direction (who, mode, feel, world, signature, rejected defaults), 60/30/10 table, token table with measured contrast, typography and scale, spacing and depth, layout, motion, components, voice, accessibility, bans, token CSS |
| `docs/design-reference.html` | Self-contained main screen with numbers that add up, ratio bar, swatches, type scale |
| `docs/ARCHITECTURE.md` | Goals, style, diagrams, data model and constraints, domain rules, auth flow, authorization, key flows, API catalog, non-functional design, deployment, scalability, ADRs, repo structure |
| `docs/SECURITY.md` | See `security-method.md` |
| `.agents/rules/*.md` | Always-on, short, checkable |
| `.agents/skills/<name>/SKILL.md` | Frontmatter `name` and `description`, then Goal, Instructions (numbered), Tests, Constraints |
| `.agents/workflows/*.md` | Frontmatter `description`, numbered steps ending in a report |

Easy level may omit ARCHITECTURE and SECURITY and fold a short architecture section into README.

## 2. Antigravity format

- Workspace skills: `.agents/skills/<skill-name>/SKILL.md` (older `.agent/skills/`). YAML frontmatter with `name` and `description`. The agent decides to load a skill from its description, so write descriptions that name concrete triggers.
- Rules: markdown files in `.agents/rules/`, always applied.
- Workflows: markdown files in `.agents/workflows/` with a `description`, invoked as `/name`.
- Planning mode produces a plan artifact, so the master prompt asks for one first.
- Verify folder names against the current Antigravity documentation when search is available, since the product evolves.

## 3. Mapping the five task steps to phases

Task briefs list five workflow steps (for example design screens, build APIs, store data, show reports, add auth). Keep the **order the brief gives** in PROMPT.md headings, but sequence the phases so dependencies work:

- Foundation phase first (scaffold, tooling, contracts, domain functions with tests).
- If the brief puts design before data, build screens against typed fixtures, then wire APIs.
- If the brief puts auth last, scope all data access by owner from the start using a dev-only auth stub, so real auth replaces the stub without touching repositories.
- End with a quality phase (verify, security review, design review) and a deploy and optimize phase with budgets.

Every phase ends with "Check:" naming a command or a visible result.

## 4. PROMPT.md structure

```
# Master prompt for Antigravity: <Product>
How to use (4 lines)
---
Role sentence (senior engineer, architect and designer as one team) + "must not look like a tutorial or generic AI template"
0. Before writing code: read order of files, produce a Plan artifact, ADR if deviating
1. Product (roles, the key features each "working end to end")
2. Stack (fixed, do not substitute)
3. Phases (mapped to the task steps, each with a Check)
4. Quality bar
5. Do not
6. Definition of done (clean-machine run, all tests, budgets, final walkthrough contents)
```

## 5. Writing rules, skills and workflows

- **Rules:** imperative bullets that can be checked by lint, test or review. No explanations longer than a clause. Three files: standards, security, design guardrails.
- **Skills:** `description` is the trigger. Include the artifacts and verbs the user will mention. Body is numbered steps, the tests required, and constraints. One domain skill captures correctness traps.
- **Workflows:** a repeatable procedure ending in a report (what passed, what failed, next action).
- Keep each file under about 120 lines.

## 6. Consistency checklist

Same product name, ports, script names, env variable names, endpoint paths, budgets and demo credentials in README, ARCHITECTURE, PROMPT and skills. Every link and anchor resolves. Every skill named in PROMPT exists. Every workflow named in PROMPT exists. Every contrast number in DESIGN_SYSTEM was measured.
