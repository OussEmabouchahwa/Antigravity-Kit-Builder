---
description: Measure performance against the stated budgets
---

1. Build production artifacts and report initial JavaScript size (gzipped) against the budget ({{JS_BUDGET}}).
2. Run Lighthouse on the main screen (target 90+, LCP under 2.5s, CLS under 0.1).
3. Seed realistic volume ({{SEED_VOLUME}}), run `npm run perf:load`, report p95 per endpoint (budget {{P95_BUDGET}}) and error rate.
4. For any slow query run `EXPLAIN (ANALYZE, BUFFERS)`, name the cause, apply the fix, re-measure.
5. Report before and after numbers.
