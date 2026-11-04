#!/usr/bin/env python3
"""Validate an AI-IDE project kit.

Usage: python validate_kit.py <kit-dir> [--level easy|medium|advanced] [--mermaid]

Checks: required files, skill/workflow frontmatter, leftover placeholders,
internal links and anchors, skills and workflows referenced by PROMPT.md exist,
and (with --mermaid) that every Mermaid diagram parses.
Exit code 1 when any error is found.
"""
import argparse
import os
import re
import shutil
import subprocess
import sys
import tempfile

BASE_REQUIRED = ["PROMPT.md", "README.md", "docs/DESIGN_SYSTEM.md", "docs/design-reference.html",
                 ".agents/rules/project-standards.md", ".agents/rules/design-guardrails.md",
                 ".agents/workflows/verify.md"]
MEDIUM_EXTRA = ["docs/ARCHITECTURE.md", "docs/SECURITY.md", ".agents/rules/security-rules.md",
                ".agents/workflows/security-review.md", ".agents/workflows/review-design.md"]
ADVANCED_EXTRA = [".agents/workflows/perf-audit.md"]
MIN_SKILLS = {"easy": 3, "medium": 6, "advanced": 8}

errors, warnings = [], []


def err(msg):
    errors.append(msg)


def warn(msg):
    warnings.append(msg)


def read(path):
    with open(path, encoding="utf-8") as f:
        return f.read()


def frontmatter(text):
    m = re.match(r"---\n(.*?)\n---\n", text, re.S)
    if not m:
        return None
    data = {}
    for line in m.group(1).splitlines():
        if ":" in line:
            k, v = line.split(":", 1)
            data[k.strip()] = v.strip()
    return data


def github_anchor(heading):
    a = re.sub(r"[^\w\s-]", "", heading.lower()).strip()
    return re.sub(r"\s", "-", a)


def anchors_of(path):
    out = set()
    in_code = False
    for line in read(path).splitlines():
        if line.startswith("```"):
            in_code = not in_code
        if in_code:
            continue
        m = re.match(r"#{1,6}\s+(.*)", line)
        if m:
            out.add(github_anchor(m.group(1)))
    return out


def check_required(kit, level):
    req = list(BASE_REQUIRED)
    if level in ("medium", "advanced"):
        req += MEDIUM_EXTRA
    if level == "advanced":
        req += ADVANCED_EXTRA
    for rel in req:
        if not os.path.isfile(os.path.join(kit, rel)):
            err(f"missing required file: {rel}")


def check_skills_and_workflows(kit, level):
    skills_dir = os.path.join(kit, ".agents", "skills")
    names = []
    if os.path.isdir(skills_dir):
        for d in sorted(os.listdir(skills_dir)):
            f = os.path.join(skills_dir, d, "SKILL.md")
            if not os.path.isfile(f):
                err(f"skill folder without SKILL.md: {d}")
                continue
            names.append(d)
            fm = frontmatter(read(f))
            if not fm:
                err(f"{d}/SKILL.md: missing frontmatter")
                continue
            if fm.get("name") != d:
                err(f"{d}/SKILL.md: name '{fm.get('name')}' does not match folder")
            desc = fm.get("description", "")
            if len(desc) < 80:
                err(f"{d}/SKILL.md: description too short to trigger reliably")
    if len(names) < MIN_SKILLS[level]:
        err(f"only {len(names)} skills, expected at least {MIN_SKILLS[level]} for level {level}")
    wf_dir = os.path.join(kit, ".agents", "workflows")
    wfs = []
    if os.path.isdir(wf_dir):
        for f in sorted(os.listdir(wf_dir)):
            if f.endswith(".md"):
                wfs.append(f[:-3])
                fm = frontmatter(read(os.path.join(wf_dir, f)))
                if not fm or not fm.get("description"):
                    err(f"workflow {f}: missing description frontmatter")
    return names, wfs


def check_placeholders(kit):
    hard = re.compile(r"\{\{[^}]+\}\}|<!--\s*GUIDE")
    soft = re.compile(r"\bTODO\b|\bTBD\b|lorem ipsum", re.I)
    quoted = re.compile(r'"[^"]*(TODO|TBD|lorem ipsum)[^"]*"', re.I)
    rule_context = re.compile(r"\b(never|no|not|ban|bans|without|forbid|must not|don't)\b", re.I)
    for root, _, files in os.walk(kit):
        for f in files:
            if f.endswith((".md", ".html")):
                p = os.path.join(root, f)
                for i, line in enumerate(read(p).splitlines(), 1):
                    rel = os.path.relpath(p, kit)
                    if hard.search(line):
                        err(f"leftover placeholder in {rel}:{i}: {line.strip()[:80]}")
                    elif soft.search(line) and not rule_context.search(line) and not quoted.search(line):
                        warn(f"possible leftover in {rel}:{i}: {line.strip()[:80]}")


def check_links(kit):
    for root, _, files in os.walk(kit):
        for f in files:
            if not f.endswith(".md"):
                continue
            p = os.path.join(root, f)
            text = re.sub(r"```.*?```", "", read(p), flags=re.S)
            for link in re.findall(r"\]\(([^)\s]+)\)", text):
                if re.match(r"[a-z]+://|mailto:", link):
                    continue
                path, _, anc = link.partition("#")
                target = os.path.normpath(os.path.join(os.path.dirname(p), path)) if path else p
                rel = os.path.relpath(p, kit)
                if not os.path.exists(target):
                    err(f"{rel}: broken link {link}")
                elif anc and target.endswith(".md") and anc not in anchors_of(target):
                    err(f"{rel}: broken anchor {link}")


def check_prompt_refs(kit, skills, wfs):
    p = os.path.join(kit, "PROMPT.md")
    if not os.path.isfile(p):
        return
    text = read(p)
    api_line = re.compile(r"\b(GET|POST|PUT|PATCH|DELETE|endpoint|API)\b")
    api_tokens = {"health", "ready", "metrics", "docs"}
    for line in text.splitlines():
        if api_line.search(line):
            continue
        for w in re.findall(r"`/([a-z][a-z-]*)`", line):
            if w not in wfs and w not in api_tokens:
                err(f"PROMPT.md references workflow /{w} that does not exist")
    for s_ in set(re.findall(r"`([a-z][a-z-]*)` skill", text)):
        if s_ not in skills:
            err(f"PROMPT.md references skill `{s_}` that does not exist")


def mermaid_blocks(kit):
    out = []
    for root, _, files in os.walk(kit):
        for f in files:
            if f.endswith(".md"):
                p = os.path.join(root, f)
                for code in re.findall(r"```mermaid\n(.*?)```", read(p), re.S):
                    out.append((os.path.relpath(p, kit), code))
    return out


def check_mermaid(kit):
    blocks = mermaid_blocks(kit)
    if not blocks:
        warn("no mermaid diagrams found")
        return
    cache = os.path.join(tempfile.gettempdir(), "kitb-mermaid")
    lib = os.path.join(cache, "node_modules", "mermaid", "dist", "mermaid.min.js")
    if not os.path.exists(lib):
        if not shutil.which("npm"):
            warn("npm not found, cannot parse mermaid diagrams")
            return
        os.makedirs(cache, exist_ok=True)
        subprocess.run(["npm", "init", "-y"], cwd=cache, capture_output=True)
        r = subprocess.run(["npm", "install", "mermaid@10"], cwd=cache, capture_output=True, text=True)
        if r.returncode != 0 or not os.path.exists(lib):
            warn("could not install mermaid, diagrams not parsed")
            return
    try:
        from playwright.sync_api import sync_playwright
    except ImportError:
        warn("playwright not installed, diagrams not parsed")
        return
    with sync_playwright() as pw:
        b = pw.chromium.launch()
        page = b.new_page()
        page.set_content("<html><body></body></html>")
        page.add_script_tag(path=lib)
        page.evaluate("mermaid.initialize({startOnLoad:false})")
        for rel, code in blocks:
            res = page.evaluate(
                "async (c) => { try { await mermaid.parse(c); return 'ok'; } catch (e) { return String(e.message || e).slice(0, 200); } }",
                code)
            if res != "ok":
                err(f"{rel}: mermaid diagram '{code.splitlines()[0]}' does not parse: {res}")
        b.close()
    print(f"mermaid: parsed {len(blocks)} diagram(s)")


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("kit")
    ap.add_argument("--level", choices=["easy", "medium", "advanced"], default="medium")
    ap.add_argument("--mermaid", action="store_true")
    a = ap.parse_args()
    kit = os.path.abspath(a.kit)
    if not os.path.isdir(kit):
        print(f"not a directory: {kit}")
        sys.exit(2)
    check_required(kit, a.level)
    skills, wfs = check_skills_and_workflows(kit, a.level)
    check_placeholders(kit)
    check_links(kit)
    check_prompt_refs(kit, skills, wfs)
    if a.mermaid:
        check_mermaid(kit)
    for w in warnings:
        print("WARN ", w)
    for e in errors:
        print("ERROR", e)
    print(f"{len(skills)} skills, {len(wfs)} workflows, {len(errors)} error(s), {len(warnings)} warning(s)")
    sys.exit(1 if errors else 0)


if __name__ == "__main__":
    main()
