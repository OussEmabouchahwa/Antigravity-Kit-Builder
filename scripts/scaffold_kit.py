#!/usr/bin/env python3
"""Create a kit folder from the templates, ready to fill in.

Usage:
  python scaffold_kit.py <out-dir> [--level easy|medium|advanced] [--set KEY=VALUE ...]

Copies assets/templates into <out-dir>, dropping the .tpl suffix, and replaces
{{KEY}} for every --set. Remaining {{...}} placeholders and <!-- GUIDE --> comments
must be filled or removed by hand; validate_kit.py reports every one that is left.
Level easy omits ARCHITECTURE, SECURITY, security rules, security-review, perf-audit
and the auth-security, devops-optimization skills. Medium and advanced get everything.
"""
import argparse
import os
import shutil
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
TEMPLATES = os.path.join(HERE, "..", "assets", "templates")

EASY_SKIP = {
    "docs/ARCHITECTURE.md", "docs/SECURITY.md", "rules/security-rules.md",
    "workflows/security-review.md", "workflows/perf-audit.md",
    "skills/auth-security/SKILL.md", "skills/devops-optimization/SKILL.md",
}


def destination(rel):
    """Map a template path to its place inside the kit."""
    rel = rel[:-4] if rel.endswith(".tpl") else rel
    if rel == "design-reference.template.html":
        return "docs/design-reference.html", rel
    if rel.startswith("docs/"):
        return rel, rel
    if rel in ("PROMPT.md", "README.md"):
        return rel, rel
    return ".agents/" + rel, rel


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("out")
    ap.add_argument("--level", choices=["easy", "medium", "advanced"], default="medium")
    ap.add_argument("--set", action="append", default=[], metavar="KEY=VALUE")
    a = ap.parse_args()
    values = {}
    for item in a.set:
        if "=" not in item:
            print(f"bad --set '{item}'")
            sys.exit(2)
        k, v = item.split("=", 1)
        values[k] = v
    skip = EASY_SKIP if a.level == "easy" else set()
    count = 0
    for root, _, files in os.walk(TEMPLATES):
        for f in files:
            src = os.path.join(root, f)
            rel = os.path.relpath(src, TEMPLATES).replace(os.sep, "/")
            dest_rel, skip_key = destination(rel)
            if skip_key in skip:
                continue
            dest = os.path.join(a.out, dest_rel)
            os.makedirs(os.path.dirname(dest), exist_ok=True)
            with open(src, encoding="utf-8") as fh:
                text = fh.read()
            for k, v in values.items():
                text = text.replace("{{" + k + "}}", v)
            with open(dest, "w", encoding="utf-8") as fh:
                fh.write(text)
            count += 1
    print(f"scaffolded {count} files into {os.path.abspath(a.out)} (level {a.level})")
    print("next: fill every {{PLACEHOLDER}}, delete GUIDE comments, then run validate_kit.py")
    if a.level == "easy":
        print("easy level: edit PROMPT.md to drop phases and references that need skipped files "
              "(security-review, perf-audit, devops-optimization, ARCHITECTURE, SECURITY)")


if __name__ == "__main__":
    main()
