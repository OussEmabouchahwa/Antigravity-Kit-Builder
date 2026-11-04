---
name: frontend-ui
description: Builds the React, TypeScript and Tailwind interface for {{PRODUCT}} following docs/DESIGN_SYSTEM.md with the 60/30/10 palette, {{TYPE_PAIR}} typography and the {{SIGNATURE_NAME}} signature. Use when creating or changing screens, components, forms, tables, drawers, loading, empty and error states, keyboard shortcuts or client data fetching.
---

# Frontend UI

## Goal
Accessible, fast screens that are unmistakably {{PRODUCT}}, built from tokens and primitives. Open `docs/design-reference.html` before starting.

## Before each component, state briefly
Intent (who, task, feel), focal element, palette share, depth, typography levers, spacing. If you cannot say why, you are defaulting.

## Folder layout
```
apps/web/src/
  app/ components/ui/ components/charts/ features/<name>/{api,components,hooks,pages,copy.ts} lib/ styles/
```

## Instructions
1. **Foundation first:** tokens, Tailwind mapping, fonts, global styles, `components/ui` primitives on Radix, then charts. A temporary `/__kit` route shows every primitive in every state and is removed before release.
2. **Fixtures first (when the brief starts with design):** build screens against typed fixtures from `packages/contracts`, then swap to real hooks.
3. **Data:** one typed `http.ts`, feature hooks, precise invalidation, URL state for filters and scope.
4. **Forms:** React Hook Form with the shared Zod schema, map server `fields` errors, focus the first invalid field.
5. **States:** skeleton, empty (teaches), error with retry. Never a blank screen.
6. {{PRODUCT_SCREEN_NOTES}}
7. **Performance:** route-level splitting, lazy heavy components, reserve space to avoid layout shift, bundle analyzer before release.
8. **Accessibility:** skip link, landmarks, labels, focus return from dialogs, live regions, full keyboard operation.

## Constraints
- No raw colors, no arbitrary Tailwind color values.
- No `useEffect` for data fetching, no copying query data to local state.
- No scattered hard-coded copy: use each feature's `copy.ts`.
- No component over 150 lines.
