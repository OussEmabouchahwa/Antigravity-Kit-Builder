#!/usr/bin/env python3
"""WCAG contrast checker.

Usage:
  python contrast.py --pairs "#172016:#FFFFFF:ink on white" "#7E8A79:#FFFFFF:control border:3"
      Each pair is fg:bg:label[:threshold]. Default threshold 4.5 (use 3 for UI borders and graphics).
  python contrast.py --blend "#0F2A2E" 0.22 "#FFFFFF"
      Effective color of a translucent foreground over a background, plus its contrast against it.
Exit code 1 when any pair fails.
"""
import argparse
import sys


def _lin(c):
    return c / 12.92 if c <= 0.03928 else ((c + 0.055) / 1.055) ** 2.4


def luminance(hex_color):
    h = hex_color.lstrip("#")
    if len(h) == 3:
        h = "".join(ch * 2 for ch in h)
    r, g, b = (int(h[i:i + 2], 16) / 255 for i in (0, 2, 4))
    return 0.2126 * _lin(r) + 0.7152 * _lin(g) + 0.0722 * _lin(b)


def ratio(a, b):
    la, lb = sorted((luminance(a), luminance(b)), reverse=True)
    return (la + 0.05) / (lb + 0.05)


def blend(fg, alpha, bg):
    f = [int(fg.lstrip("#")[i:i + 2], 16) for i in (0, 2, 4)]
    b = [int(bg.lstrip("#")[i:i + 2], 16) for i in (0, 2, 4)]
    return "#%02X%02X%02X" % tuple(round(f[i] * alpha + b[i] * (1 - alpha)) for i in range(3))


def main():
    p = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    p.add_argument("--pairs", nargs="+", help="fg:bg:label[:threshold]")
    p.add_argument("--blend", nargs=3, metavar=("FG", "ALPHA", "BG"))
    a = p.parse_args()
    failed = False
    if a.blend:
        fg, alpha, bg = a.blend[0], float(a.blend[1]), a.blend[2]
        eff = blend(fg, alpha, bg)
        print(f"effective {eff}  contrast vs {bg}: {ratio(eff, bg):.2f}")
    for item in a.pairs or []:
        parts = item.split(":")
        if len(parts) < 3:
            print(f"bad pair '{item}' (need fg:bg:label)")
            failed = True
            continue
        fg, bg, label = parts[0], parts[1], parts[2]
        need = float(parts[3]) if len(parts) > 3 else 4.5
        r = ratio(fg, bg)
        ok = r >= need
        failed |= not ok
        print(f"{'PASS' if ok else 'FAIL'}  {r:5.2f}  (need {need:g})  {label}")
    if not a.pairs and not a.blend:
        p.print_help()
    sys.exit(1 if failed else 0)


if __name__ == "__main__":
    main()
