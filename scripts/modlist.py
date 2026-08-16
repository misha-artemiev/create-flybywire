#!/usr/bin/env python3
"""Generate a markdown mod list from packwiz .pw.toml files.

Usage:
    python3 generate_modlist.py [path/to/mods/dir]

Defaults to "modpack/mods" if no path is given.
"""
import re
import sys
import tomllib
from pathlib import Path

MODS_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("mods")

# Grabs the first version-looking chunk out of a filename, e.g.
# "sodium-fabric-0.6.13+mc1.21.1.jar" -> "0.6.13+mc1.21.1"
VERSION_RE = re.compile(r"(\d+(?:\.\d+){1,3}[a-zA-Z0-9\-\+]*)")


def extract_version(filename: str) -> str:
    stem = filename[:-4] if filename.endswith(".jar") else filename
    match = VERSION_RE.search(stem)
    return match.group(1) if match else "unknown"


def main() -> None:
    if not MODS_DIR.is_dir():
        print(f"error: {MODS_DIR} is not a directory", file=sys.stderr)
        sys.exit(1)

    entries = []
    for toml_path in sorted(MODS_DIR.glob("*.pw.toml")):
        with open(toml_path, "rb") as f:
            data = tomllib.load(f)
        name = data.get("name", toml_path.stem)
        filename = data.get("filename", "")
        version = extract_version(filename)
        entries.append(f"* {name} {version}")

    print("Mod list:")
    print("\n".join(entries))


if __name__ == "__main__":
    main()
