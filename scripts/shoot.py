#!/usr/bin/env python3
"""Screenshot an HTML file or URL at 1440, 768 and 390 and report layout defects.

Usage: python shoot.py <file-or-url> [--out shots] [--full]
Reports: horizontal overflow per width, and rendered text smaller than 11px
(including SVG text after scaling), listing the first offenders.
Look at the PNGs yourself afterwards, the numbers do not replace judgment.
"""
import argparse
import os
import sys

WIDTHS = [(1440, 900), (768, 1024), (390, 844)]

SMALL_TEXT_JS = """
() => {
  const bad = [];
  const walker = document.createTreeWalker(document.body, NodeFilter.SHOW_TEXT);
  while (walker.nextNode()) {
    const n = walker.currentNode;
    if (!n.textContent.trim()) continue;
    const el = n.parentElement;
    if (!el || getComputedStyle(el).visibility === 'hidden' || el.offsetParent === null && !(el instanceof SVGElement)) continue;
    let size = parseFloat(getComputedStyle(el).fontSize);
    if (el instanceof SVGElement && el.getScreenCTM) { const m = el.getScreenCTM(); if (m) size *= m.a; }
    if (size < 11) bad.push(size.toFixed(1) + 'px: ' + n.textContent.trim().slice(0, 30));
  }
  return bad.slice(0, 6);
}
"""


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("target")
    ap.add_argument("--out", default="shots")
    ap.add_argument("--full", action="store_true", help="full-page screenshots")
    a = ap.parse_args()
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        print("playwright is not installed (pip install playwright && playwright install chromium)")
        sys.exit(2)
    url = a.target if "://" in a.target else "file://" + os.path.abspath(a.target)
    os.makedirs(a.out, exist_ok=True)
    problems = 0
    with sync_playwright() as pw:
        b = pw.chromium.launch()
        for w, h in WIDTHS:
            page = b.new_page(viewport={"width": w, "height": h})
            page.goto(url, wait_until="domcontentloaded")
            page.wait_for_timeout(400)
            path = os.path.join(a.out, f"w{w}.png")
            page.screenshot(path=path, full_page=a.full)
            overflow = page.evaluate("document.documentElement.scrollWidth > innerWidth")
            small = page.evaluate(SMALL_TEXT_JS)
            problems += int(overflow) + len(small)
            print(f"{w}px  overflow={'YES' if overflow else 'no'}  small-text={small or 'none'}  -> {path}")
            page.close()
        b.close()
    sys.exit(1 if problems else 0)


if __name__ == "__main__":
    main()
