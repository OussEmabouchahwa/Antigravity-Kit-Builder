# Design guardrails (always on for any UI work)

Full specification: `docs/DESIGN_SYSTEM.md`. Visual truth: `docs/design-reference.html`.

## Must
- 60/30/10: {{FAMILY_60}} about 60%, {{FAMILY_30}} about 30%, {{FAMILY_10}} 10% or less. Status colors on status marks only.
- Colors, radii, shadows, fonts and durations come from tokens. A raw hex value in a component is a bug.
- {{SERIF}} for titles and big figures, {{SANS}} for the interface. Fixed rem scale at ratio 1.2. No serif in controls.
- Tabular numerals, right-aligned numeric columns.
- One focal element and one primary button per view.
- Hover (gated by `hover: hover`), focus-visible, active, disabled on every control. Loading, empty (teaches), error (retry), populated on every data view.
- Touch targets 44px. Text contrast 4.5:1. Control borders use the 400 step (3:1).
- Motion: transform and opacity, under 300ms, never `transition: all`, keyboard-initiated actions instant, respect reduced motion.
- {{PRODUCT_SPECIFIC_MUST}}

## Must not
- Gradients, glass, glow, hard offset shadows, colored border-left stripes, violet or indigo, a second accent hue.
- Progress rings, sparklines on KPIs, pie and donut charts, rainbow charts.
- Eyebrows, ALL-CAPS tracked labels, "Welcome back" heroes, emoji.
- Nested cards, identical card grids as structure, a modal where a drawer or page works.
- Placeholder content.

## Before declaring a screen finished
Run `design-review` at 1440, 768 and 390, and apply the squint, swap and signature tests.
