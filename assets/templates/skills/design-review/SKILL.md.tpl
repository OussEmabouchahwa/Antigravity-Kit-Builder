---
name: design-review
description: Reviews the running {{PRODUCT}} interface against docs/DESIGN_SYSTEM.md using browser screenshots at 1440, 768 and 390 pixels, checking 60/30/10 balance, typography, states, accessibility and web interface guidelines, then fixes the differences. Use after any UI change, before declaring a screen finished, or when the interface looks generic.
---

# Design review

## Goal
Find the problems code review cannot see and fix them in a short loop.

## Instructions
1. Start the app, sign in with the demo account, open `docs/design-reference.html` beside it.
2. Capture 1440, 768 and 390px screenshots of every main screen, including loading, empty and error states and a screen with very long text and a very large number.
3. **Balance check (60/30/10):** squint. The dominant neutral wins, the secondary reads as structure, the accent is a few small marks. Status colors only on status marks.
4. **Craft checks:** squint test, swap test, signature test (five places), token test (no raw values).
5. **Typography:** only the two faces and the scale, serif absent from controls, numbers tabular and right-aligned, no rendered text under 11px at any width.
6. **States:** hover, focus-visible, active, disabled, loading, empty, error.
7. **Web interface guidelines:** labeled icon buttons, labeled inputs with correct `type`, `autocomplete` and `inputmode`, no `transition: all`, reduced motion honored, long text handled with `min-w-0`, links are `<a>` and actions are `<button>`, zoom not disabled, focus never removed without replacement, `Intl` for numbers and dates.
8. **Accessibility:** keyboard-only pass through the main journey, contrast spot-check, reduced motion on.
9. **Report as a table** (Before, After, Why) ranked by severity. Fix in tokens or components, re-capture, stop after three iterations or when clean.

## Constraints
- Match the design system, do not reinvent it.
- Do not add decoration to make a screen feel designed. Fix hierarchy, spacing and copy first.
