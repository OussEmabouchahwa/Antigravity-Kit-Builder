# Design System: {{PRODUCT}}

Single source of truth for look and behavior. A live visual reference is in [`design-reference.html`](design-reference.html). Open it in a browser first. Components consume **tokens**, never raw values.

## 1. Direction

**Who:** {{WHO_AND_TASK}}

**Mode:** {{MODE}} (Operate, with Read surfaces where relevant).

**Feel:** {{FEEL_SPECIFIC}}

**World (where tokens come from):** {{WORLD_THREE_WORDS}}. Token names use those words.

**Signature, {{SIGNATURE_NAME}}:** {{SIGNATURE_DESCRIPTION}} It appears in at least five places: {{SIGNATURE_PLACES}}.

**Rejected defaults:** {{REJECTED_DEFAULTS}}

## 2. Color: the 60 / 30 / 10 rule

| Share | Role | Family | Where it appears |
|---|---|---|---|
| **60%** | Dominant neutral | **{{FAMILY_60}}** | {{USE_60}} |
| **30%** | Secondary structure | **{{FAMILY_30}}** | {{USE_30}} |
| **10%** | Accent | **{{FAMILY_10}}** | {{USE_10}} |
| outside | Status | {{STATUS_FAMILIES}} | Marks and tags only, never decoration |

Measured by screen area. If the accent is on more than a few elements of a screen, something is over-accented.

### Tokens

<!-- GUIDE: every contrast value below must be copied from scripts/contrast.py output. Include a control-border token at 3:1 (400 step), never a translucent line. -->

| Token | Hex | Use | Contrast (measured) |
|---|---|---|---|
| `--{{F60}}-0` | `{{HEX}}` | Panels, inputs | n/a |
| `--{{F60}}-50` | `{{HEX}}` | Page ground | n/a |
| `--{{F30}}-100` | `{{HEX}}` | Nav surface, tag fill | n/a |
| `--{{F30}}-400` | `{{HEX}}` | **Control borders** | {{N}}:1 on white |
| `--{{F30}}-700` | `{{HEX}}` | Secondary text | {{N}}:1 on white |
| `--{{F30}}-900` | `{{HEX}}` | Primary text (ink) | {{N}}:1 on white |
| `--{{F10}}-500` | `{{HEX}}` | Primary action | {{N}}:1 |
| `--line` | `rgb({{R}} {{G}} {{B}} / .12)` | Resting borders, row rules | decorative |

Rules: text on its surface 4.5:1, control borders 3:1, text on tinted fills tested as its own pair, color encodes meaning (good, late, over), zero and unknown are neutral, no gradients, no second accent hue.

## 3. Typography

{{TYPE_PAIR_RATIONALE}}

| Role | Face | Where |
|---|---|---|
| Titles and big figures | {{SERIF}} 600 | Page titles, figures |
| Interface | {{SANS}} 400, 500, 600 | Navigation, labels, buttons, tables, forms, body |

### Scale (fixed rem, ratio 1.2, base 16px)

| Step | Size / line-height | Face and weight | Use |
|---|---|---|---|
| H1 | 1.75rem (28) / 1.2 | Serif 600 | Page title |
| H2 | 1.4375rem (23) / 1.25 | Serif 600 | Panel and section titles |
| H3 | 1.1875rem (19) / 1.3 | Serif 600 | Panel headings |
| Body | 1rem (16) / 1.5 | Sans 400 | Default text |
| Small | 0.875rem (14) / 1.43 | Sans 400/500 | Secondary text, tags |
| Caption | 0.75rem (12) / 1.33 | Sans 500 | Axis labels. Nothing smaller |

Hierarchy by weight and color first. Tabular numerals on every number, right-aligned numeric columns. Sentence case, no ALL-CAPS labels. Serif never in controls.

## 4. Space, depth, layout

4px base. Controls 44px. Borders only at rest, shadows only on floating elements. Radius scale 4, 8, 12. One focal element per view. Lists and tables beat card grids. Breakpoints: {{BREAKPOINTS}}.

## 5. Motion

Hover and press 120 to 150ms, menus 150 to 200ms, drawer and dialog 200 to 240ms. Transform and opacity only, never `transition: all`. Keyboard-initiated actions are instant. No page-load sequences, no chart animation. Respect `prefers-reduced-motion`.

## 6. Components

Every component ships default, hover, focus-visible, active, disabled, plus loading and error where relevant.

| Component | Spec |
|---|---|
{{COMPONENT_ROWS}}

## 7. Voice and copy

{{VOICE}} Realistic sample data. Never placeholder content.

## 8. Accessibility and internationalization

WCAG 2.2 AA, full keyboard use, visible focus, labels everywhere, errors linked and announced, 44px targets, no color-only meaning. Use CSS logical properties so right-to-left can be added and `Intl` for numbers and dates.

## 9. Never do this

Gradients, glass or blur as decoration, glow, hard offset shadows, colored border-left stripes, violet or indigo, a second accent hue, icon-in-circle KPIs, sparklines on KPIs, progress rings, pie and donut charts, rainbow charts, eyebrows, ALL-CAPS tracked labels, emoji, "Welcome back" heroes, nested cards, modal where a drawer or page works, placeholder content, serif in controls.

## 10. Token implementation

`apps/web/src/styles/tokens.css` with every token above as a CSS variable, motion tokens, `prefers-reduced-motion` override, themed `::selection`, caret and `accent-color`. Expose every token through `tailwind.config.ts` so utilities are the only way color reaches a component.
