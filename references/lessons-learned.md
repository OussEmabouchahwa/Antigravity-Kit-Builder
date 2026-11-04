# Lessons learned from the three source kits

Real defects found while building, and how to avoid them.

## Process
- **Read the design skills first, then write.** Generated suggestions from a design-system search tool were the generic look (glassmorphism, dark neon green, child fonts for an adult LMS). Treat such output as a reference, reject what does not fit the domain, and say why.
- **Be distinct per project.** Kit 1 navy and marker yellow with Crimson Pro and Atkinson. Kit 2 chalk, board teal and pencil amber with IBM Plex. Kit 3 paper, ledger green-black and stamp blue with Source Serif and Source Sans. Keep a list and never repeat.
- **Build the visual reference before writing the design doc.** Seeing the 60/30/10 balance changes decisions.
- **Capture the user's intent once.** If the user says "same as before", reuse the method, not the palette.

## Verification catches
- **Contrast estimates were wrong.** Claimed 3:1 for a translucent border that measured 1.56:1. Claimed 9.3:1 that measured 9.5:1. Always run `scripts/contrast.py` and copy its numbers.
- A success color on its own pale tint measured 4.35:1 and had to be darkened.
- A chart comparison line in a light tint measured 2:1 and had to move to the 400 step.
- **Mermaid diagrams must be parsed**, not eyeballed (`validate_kit.py --mermaid`).
- **Internal links and anchors break silently.** Check them.
- **Mobile defects in the reference page:** horizontal overflow from fixed-width label columns, top-bar avatar wrapping to its own line, chart axis labels clipped by a too small left margin, SVG text rendering at about 7px. Fix with flex-wrap, `min-width: 0`, wider chart margins and larger SVG font sizes under a media query.
- Dead space under a short chart next to a tall panel: make the chart taller instead of stretching the panel.
- Numbers on the reference page must add up (income minus expenses equals net, the stated difference equals the lines' difference).

## Defects the layout checker found after "fixing" by eye
- A delivered reference page overflowed horizontally at **768px** (desktop nav, five links plus button did not fit). The tablet width needs its own check, so the top-bar wrapping breakpoint moved to 900px.
- Chart axis text that looked fixed at mobile still rendered at **9px** because the SVG scales down with the viewBox. Rendered size is `font-size x scale`, so compute it (`shoot.py` does) and raise the size until it is at least 11px at 390px and at 1440px.
- Direct end labels were clipped at the right edge of the viewBox. Reserve room in the viewBox for labels and axis text instead of hoping they fit.
- A flex gap added visible extra space around a `&nbsp;` inside a button label. Wrap the label in one span.
- Lesson: never declare a visual fixed from one screenshot. Run `scripts/shoot.py` at 1440, 768 and 390, then look at the images.

## Environment gotchas
- The shell is `sh`, so brace expansion like `mkdir -p a/{b,c}` creates a literal directory named `{b,c}`. Use explicit paths.
- A background server started in one command can die when the command ends. Start it and test in the same command.
- A script that applies several string replacements and writes at the end loses all of them if one assertion fails. Apply, check, then write, or split the edits.
- Google Fonts are not reachable in the sandbox, so screenshots show fallback fonts. Say so in the final message.

## Communication
- Reply in the user's language and register, keep kit files in English.
- Say plainly what was verified with real checks and what was not (the kit was not run inside the IDE).
- If a previous reply was cut off, recap briefly in the next one.
