#!/usr/bin/env python3
"""Zip a kit folder (without junk) and copy it to /mnt/user-data/outputs when that folder exists.

Usage: python package_kit.py <kit-dir> [--out <dir>]
"""
import argparse
import os
import shutil
import sys
import zipfile

SKIP_DIRS = {"node_modules", "__pycache__", ".git", "shots"}
SKIP_FILES = {".DS_Store"}


def main():
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("kit")
    ap.add_argument("--out")
    a = ap.parse_args()
    kit = os.path.abspath(a.kit)
    if not os.path.isdir(kit):
        print(f"not a directory: {kit}")
        sys.exit(2)
    name = os.path.basename(kit.rstrip("/"))
    out_dir = a.out or ("/mnt/user-data/outputs" if os.path.isdir("/mnt/user-data/outputs") else os.getcwd())
    os.makedirs(out_dir, exist_ok=True)
    zip_path = os.path.join(out_dir, f"{name}.zip")
    count = 0
    with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
        for root, dirs, files in os.walk(kit):
            dirs[:] = [d for d in dirs if d not in SKIP_DIRS]
            for f in files:
                if f in SKIP_FILES:
                    continue
                full = os.path.join(root, f)
                z.write(full, os.path.join(name, os.path.relpath(full, kit)))
                count += 1
    print(f"{zip_path}  ({count} files, {os.path.getsize(zip_path) // 1024} KB)")


if __name__ == "__main__":
    main()
