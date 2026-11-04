# Design method

Distilled from the front-end design skills used on the three source kits. Use the original skills when they are available, otherwise this file is enough.

## Contents
1. Mode and intent
2. Domain exploration
3. Palette: the 60/30/10 rule
4. Typography
5. Space, depth, radius
6. Signature element
7. Motion
8. Data visualization
9. Component rules
10. Bans
11. Reference page and review loop

## 1. Mode and intent

Decide the mode first, it changes everything.

| Mode | Examples | Rules |
|---|---|---|
| **Operate** | Dashboards, admin, trackers, LMS, tools | Scanability and consistency win. Fixed rem type scale. One focal element per view. Brand lives in details. |
| **Read** | Lessons, reports, articles | Serif prose 18px at 68ch, generous leading. |
| **Persuade** | Landing pages | Not covered here. |

Write one paragraph of intent: who is the person, what is the task, what should it feel like. If you cannot answer "feel" with something more specific than "clean and modern", you are defaulting.

## 2. Domain exploration

Before choosing a color, produce all four:

1. **Domain:** 5 or more concepts, metaphors and objects from the product's world (classroom: chalk, board, pencil, syllabus, gradebook. Accounting: ledger, receipt, stamp, passbook).
2. **Color world:** 5 or more colors that exist naturally in that world.
3. **Signature:** one element that could only exist in this product, tied to its core question (a Lesson Trail for "where am I in this course", a Pace Marker for "am I on track").
4. **Rejected defaults:** 3 obvious choices you will not make, and what replaces each (indigo SaaS accent, four KPI tiles with icons, donut chart, "Welcome back").

Name the product from its world (Dars, Masrouf). Name tokens from the world as well (`--chalk-50`, `--stamp-500`), not `--gray-700`.

## 3. Palette: the 60/30/10 rule

| Share | Role | Typical content |
|---|---|---|
| 60% | Dominant neutral | Page ground, panels, table rows, inputs |
| 30% | Secondary structure | Nav surface, rules, tracks, secondary text, ink, completed progress |
| 10% | Accent | The one primary action, the current position, the main data series, selection |
| outside | Status | Success, danger, warning. Marks and tags only, never large fills |

Measure by screen area. If the accent shows on more than a few elements of a screen, it is over-used. Color goes on data and the one action, not on chrome.

Build steps:
1. Pick the 60% neutral with a slight tint toward the world (not pure grey, not cream paired with terracotta).
2. Pick the 30% as a second neutral family with a distinct hue (green-grey, blue-grey). Make 6 to 7 steps: 100, 200, 300, 400, 500, 700, 900.
3. Pick one accent hue far from the 30% hue on the wheel. Avoid violet and indigo. Make steps 100, 300, 500, 600, 700.
4. Add status colors with a pale 100 tint and a dark 600 or 700 text color each.
5. Compute contrast with `scripts/contrast.py` for every pair used in the doc.

Hard contrast rules (these caught real errors):
- Text on its surface: 4.5:1. Text on a **tinted** fill (tags, tinted rows) is a separate pair, test it.
- **Control borders (inputs, secondary buttons): 3:1 against every surface they sit on.** A translucent `rgb(.. / .12)` rule is about 1.5:1 and fails, so it is for dividers only. Use a solid mid-tone token (the 400 step).
- Tertiary text token (500 step) usually fails on the 30% tinted surface. Document where it may be used.
- Text on the accent fill: test white and ink, use the one that passes, and keep it consistent.
- Quiet decorative marks (progress track, upcoming segments) may be below 3:1 only if the same information is also carried by text.

Color semantics: color encodes meaning (good, late, current, over), never up or down alone. Zero and unknown are neutral. In money products, income amounts may use the success color, expenses stay plain ink.

## 4. Typography

- **One designed pair or superfamily.** Fonts designed together agree without tuning. Examples used: IBM Plex Serif, Sans and Mono (technical, education); Source Serif 4 and Source Sans 3 (finance, strong tabular figures); Crimson Pro and Atkinson Hyperlegible (editorial register). Choose a pair not used in the user's earlier kits.
- Serif for titles, names, large figures and lesson prose. Sans for the interface. Mono only for code and identifiers. Serif never in buttons, inputs, tabs, tags or table cells.
- **Fixed rem scale at ratio 1.2 from 16px** in Operate mode: 12, 14, 16, 19, 23, 28, 33, 40. Add a 15px table size when density needs it. No fluid type in the app shell.
- Hierarchy through weight and color first, size second. Four text levels: primary, secondary, tertiary, disabled.
- `font-variant-numeric: tabular-nums` on every number, numeric columns right-aligned. `text-wrap: balance` on headings, `pretty` on prose.
- Sentence case. No ALL-CAPS tracked labels. Minimum 12px.
- `font-display: swap`, real fallbacks, Latin subset. Say how to add Arabic (for example IBM Plex Sans Arabic) and use logical CSS properties for RTL.

## 5. Space, depth, radius

- 4px base, scale 4, 8, 12, 16, 20, 24, 32, 40, 56, 72. Controls 44px high.
- Rhythm is uneven on purpose: tight inside groups, generous between them.
- **Depth strategy: borders only at rest.** 1px translucent line. Shadows only on what floats (menu, popover, dialog, drawer, toast). Never both on a resting element.
- Radius scale of 3 steps (4, 8, 12), concentric when nested.
- Layout: one focal element per view that wins by position and space. Lists and tables beat card grids.

## 6. Signature element

It must answer the product's core question, appear in at least five places, and be cheap to build (CSS and SVG). Test: can you point to five places it shows up? If not, either it is not central or it is decoration.

## 7. Motion

Motion explains a state change, nothing else.

| Use | Duration | Easing |
|---|---|---|
| Hover color, press (`scale(.97)`) | 120 to 150ms | ease |
| Menus, popovers | 150 to 200ms | `cubic-bezier(.23,1,.32,1)` |
| Drawer, dialog | 200 to 240ms | `cubic-bezier(.32,.72,0,1)` |
| Toast | 200ms in, 150ms out | ease-out |

- Transform and opacity only. Never `transition: all`. Never from `scale(0)`.
- **Keyboard-initiated actions are instant.** No animation on shortcuts.
- Gate hover with `@media (hover: hover) and (pointer: fine)`. Respect `prefers-reduced-motion`.
- No page-load sequences, no scroll reveals, no chart entrance animation. One rare celebratory moment at most (for example course completion).

## 8. Data visualization

- One question per chart, stated as a finding sentence above it, with the comparison window.
- One hue per chart. No hue per category. No pie, donut, gauge, 3D, dual axis, stacked area, gradient fill. Bars start at zero.
- Chrome nearly absent: 3 to 5 faint grid lines, no axis lines, direct labels instead of legends, round ticks.
- Accessible: `role="img"` with a label stating the finding, a "View as table" toggle, no focus trap in the SVG.
- Honest empties: draw the zero line and one sentence. Missing data is a gap, not a zero.
- Custom SVG with d3-scale and d3-shape gives full control over chrome and bundle size.
- Increase SVG text size at narrow widths so rendered text stays at least 11px.

## 9. Component rules

Every component ships default, hover, focus-visible, active, disabled, plus loading and error where relevant. Every data view has skeleton, empty (teaches, with one action), error (with retry) and populated states. Status tags use a pale tint with dark text. Dialogs only for confirmation or short decisions, otherwise a drawer or page. Destructive actions are undoable (Undo toast) or confirmed by a dialog that names the target.

## 10. Bans (the "looks AI-made" list)

Gradients and gradient text, glass or blur as decoration, glow, hard offset shadows, colored border-left stripes, dark or saturated sidebar on a light screen, violet or indigo accents, a second accent hue, icon-in-tinted-circle KPIs, sparklines on KPIs, progress rings and donut charts, rainbow charts, eyebrows above headings, section numbers, ALL-CAPS tracked labels, emoji as icons or in copy, "Welcome back" heroes, hero banners in apps, identical card grids as structure, nested cards, modal where a page or drawer works, `Lorem ipsum`, `John Doe`, `Item 1`.

## 11. Reference page and review loop

`docs/design-reference.html` is a static, self-contained page of the main screen with realistic numbers that add up, plus the 60/30/10 bar, swatches and the type scale. Render at 1440, 768, 390 with `scripts/shoot.py`. Look at the images. Typical defects found: dead space under a small chart, horizontal overflow from fixed-width labels, avatars wrapping onto their own line in a mobile top bar, chart axis labels clipped at mobile, tiny SVG text.

Review tests: **squint** (hierarchy survives blur), **swap** (would swapping the font or layout for defaults change the feel?), **signature** (five places), **token** (no raw values).
