---
name: antigravity-kit-builder
description: Builds a complete, verified project kit for an AI coding IDE (Antigravity, Cursor, Claude Code) from a project brief or course task, with a master prompt, README, design system with 60/30/10 color and harmonious typography, system architecture with ADRs, security model, always-on rules, skills, workflows and a verified visual design reference. Use whenever the user shares a project task or brief and asks for a prompt for Antigravity or another AI IDE, a professional design system, a README, skills or rules for the project, or says things like "give me a prompt to build this project", "make it look pro, not beginner", "same work as before for this task", or "make the design beautiful", even if they never say the word kit. Also use to adapt an existing kit to a new task.
---

# Antigravity kit builder

Turns a project brief into a folder an AI IDE agent can build from with professional results: clean architecture, secure code, tested, documented, and a distinctive interface that does not look AI-generated.

The method comes from three real kits (a student register, a learning management system, an expense tracker). Their lessons are in `references/lessons-learned.md`. Read it before starting.

## What you produce

```
<project>-kit/
├── PROMPT.md                    master prompt to paste into the IDE agent
├── README.md                    the project's real README (matches target structure)
├── docs/
│   ├── DESIGN_SYSTEM.md         palette (60/30/10), type scale, components, motion, bans
│   ├── design-reference.html    visual proof of the design, screenshot-verified
│   ├── ARCHITECTURE.md          style, diagrams, data model, API catalog, ADRs   (medium and up)
│   └── SECURITY.md              threat model, controls, required tests            (medium and up)
└── .agents/
    ├── rules/                   always-on: project-standards, design-guardrails, security-rules
    ├── skills/<name>/SKILL.md   task-specific playbooks (6 to 10)
    └── workflows/               verify, review-design, security-review, perf-audit
```

Use `.agents/` for Antigravity (older versions read `.agent/`). Confirm the current folder names for the target IDE with a quick web search when search is available. Templates for every file are in `assets/templates/` (`.tpl` suffix, `{{PLACEHOLDERS}}` and `<!-- GUIDE -->` comments).

## Procedure

Follow the steps in order. Do not skip verification (step 7), it is where real errors were found.

### 1. Capture the brief

Extract: task title, level (Easy, Medium, Advanced), description, the 5 workflow steps, key features, skills to learn. The user's message usually contains all of it. Ask **at most one** question, only if the domain or stack is truly ambiguous. Otherwise state assumptions in one line and proceed.

Reply in the user's language and register (the kit files themselves stay in English because IDE agents follow English instructions best).

### 2. Decide scale and architecture

Read `references/architecture-method.md`. Match the level: Easy gets a simple layered app, Medium adds shared contracts, PostgreSQL and real auth, Advanced gets a modular monolith with RBAC, events, deployment and performance work. Pick the boring option and record decisions as ADRs. If the domain has correctness traps (money, time, grades, quiz timing), name them as explicit rules.

### 3. Design direction (the part that makes it not look generic)

Read `references/design-method.md` and use any front-end design skills available in the environment (impeccable, interface-design, design-taste-frontend, emil-design-eng, ui-ux-pro-max, web-design-guidelines, frontend-design). If they are not available the reference file already distills their rules.

1. **Explore the domain.** Write the product's world: 5 concepts, 5 colors that live there, one signature element, 3 defaults you reject. Name the product from its world.
2. **Palette by 60/30/10.** 60% dominant neutral, 30% secondary structure, 10% accent. Status colors sit outside the ratio. Name tokens after the world (chalk, board, pencil; paper, ledger, stamp), not `gray-700`.
3. **Typography.** One designed superfamily or a pair drawn together, a fixed scale at ratio 1.2, tabular numbers, serif only for titles and figures.
4. **Be different from earlier kits.** Never reuse a palette or font pairing already used in this conversation or by the user's other kits.
5. **Verify contrast with the script**, never by estimate: `python scripts/contrast.py --pairs "#172016:#FFFFFF:ink on white" ...`. Control borders need 3:1, text 4.5:1.

### 4. Build the visual reference

Create `docs/design-reference.html` from `assets/templates/design-reference.template.html`: the product's main screen with realistic data (numbers that add up), the 60/30/10 bar, swatches and the type scale. Render it with `python scripts/shoot.py docs/design-reference.html` at 1440, 768 and 390 widths, look at the images, fix hierarchy, overflow and tiny text, and repeat until clean.

### 5. Write the documents

Read `references/kit-anatomy.md` (what each file must contain, how to map the task's five steps to phases) and `references/security-method.md` before writing. Create the structure first: `python scripts/scaffold_kit.py <product>-kit --level medium --set PRODUCT=<Name>`. Then fill the files in this order (each informs the next): `DESIGN_SYSTEM.md`, `ARCHITECTURE.md`, `SECURITY.md`, `README.md`, `PROMPT.md`. Replace every placeholder, delete guidance comments, and replace the reference scaffold with the product's real main screen. At easy level, edit `PROMPT.md` to drop phases that need files the level omits. Keep numbers consistent across files (ports, script names, endpoints, budgets). Map the task's five workflow steps to phases in `PROMPT.md`, each phase ending with a concrete check.

### 6. Write rules, skills, workflows

- Rules (always on): `project-standards`, `security-rules`, `design-guardrails`. Short and testable, no prose.
- Skills: read `references/skill-outlines.md` and pick 6 to 10. Each skill has a pushy `description` saying when to use it, numbered instructions, tests required, and constraints. Add one **domain skill** for the product's correctness traps.
- Workflows: `/verify`, `/review-design`, `/security-review`, `/perf-audit`.

### 7. Verify (mandatory)

```bash
python scripts/validate_kit.py <kit-dir> --level medium --mermaid
python scripts/contrast.py --pairs "<fg>:<bg>:<label>" ...
python scripts/shoot.py <kit-dir>/docs/design-reference.html
```

`validate_kit.py` checks required files, skill and workflow frontmatter, leftover placeholders, internal links and anchors, and (with `--mermaid`) that every Mermaid diagram really parses. Fix everything it reports. Then compare each contrast claim in `DESIGN_SYSTEM.md` against the script output and correct the document, not the script.

### 8. Package and present

Run `python scripts/package_kit.py <kit-dir>` (zips without junk and copies to `/mnt/user-data/outputs/` when present), then present the zip and a screenshot of the reference.

The final message, in the user's language, is short and has: what is in the kit, what is different about this project's design (palette shares, type pair, signature), how to use it in the IDE (4 steps), what you verified with real checks, and honest caveats (fonts fall back in the sandbox, the kit was not run inside the IDE, any deviation from the brief).

## Quality bar

- The design system names one signature element tied to the domain, and the prompt forbids a second showpiece.
- Every claim of contrast, performance budget or test count is either measured or stated as a target.
- No file contains placeholders, TODOs or contradictory numbers.
- The kit is self-sufficient: an agent that reads only the kit can build the project.

## Constraints

- Do not copy another kit's palette, fonts or signature.
- Do not use gradients, glass, violet or indigo accents, progress rings, donut charts, emoji icons or "Welcome back" heroes in any design this skill produces.
- Do not claim the kit works in the IDE unless it was run there.
- Do not leave the verification step out to save time.
