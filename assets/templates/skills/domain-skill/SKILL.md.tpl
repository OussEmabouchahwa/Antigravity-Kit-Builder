---
name: {{DOMAIN_SKILL_NAME}}
description: Implements the {{DOMAIN}} rules of {{PRODUCT}} correctly, including {{DOMAIN_TOPICS}}. Use when touching {{DOMAIN_TRIGGERS}} or anything that computes {{DOMAIN_OUTPUTS}}.
---

# {{DOMAIN_TITLE}}

## Goal
{{DOMAIN_GOAL}} Rules: `docs/ARCHITECTURE.md` section 5.

## Rules
<!-- GUIDE: numbered, testable statements. Example: amounts are integer minor units; deadlines are server-authoritative; boundaries use the user's timezone. -->
{{DOMAIN_RULES}}

## Calculations
{{DOMAIN_FORMULAS}}

## Tests required
Pure functions with table-driven cases, and integration tests whose expected values are **computed by hand and written as literals** in the test, plus an isolation test proving one user's data never appears in another's results.

## Constraints
- {{DOMAIN_CONSTRAINT_1}}
- {{DOMAIN_CONSTRAINT_2}}
