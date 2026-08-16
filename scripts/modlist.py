import re
import sys
import tomllib
from pathlib import Path

MODS_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else Path("mods")
PACK_TOML = MODS_DIR.parent / "pack.toml"

SPLIT_RE = re.compile(r"[-_+]")
MC_PREFIX_RE = re.compile(r"^mc\.?", re.IGNORECASE)
V_PREFIX_RE = re.compile(r"^[vV](?=\d)")
VERSION_SEGMENT_RE = re.compile(r"^\d+(?:\.\d+)*[a-zA-Z0-9]*$")


def get_mc_version() -> str | None:
    if PACK_TOML.is_file():
        try:
            with open(PACK_TOML, "rb") as f:
                data = tomllib.load(f)
            return data.get("versions", {}).get("minecraft")
        except Exception:
            return None
    return None


def extract_version(filename: str, mc_version: str | None) -> str:
    stem = filename[:-4] if filename.endswith(".jar") else filename
    segments = SPLIT_RE.split(stem)

    candidates = []
    for seg in segments:
        cleaned = MC_PREFIX_RE.sub("", seg, count=1) if MC_PREFIX_RE.match(seg) else seg
        cleaned = V_PREFIX_RE.sub("", cleaned, count=1)

        if not VERSION_SEGMENT_RE.match(cleaned):
            continue
        if MC_PREFIX_RE.match(seg):
            continue
        if mc_version and cleaned == mc_version:
            continue
        candidates.append(cleaned)

    return candidates[-1] if candidates else "unknown"


def main() -> None:
    if not MODS_DIR.is_dir():
        print(f"error: {MODS_DIR} is not a directory", file=sys.stderr)
        sys.exit(1)

    mc_version = get_mc_version()
    if mc_version is None:
        print(
            f"warning: could not read Minecraft version from {PACK_TOML}; "
            "version extraction may be less accurate for mods where the "
            "MC version trails the mod version in the filename",
            file=sys.stderr,
        )

    entries = []
    for toml_path in sorted(MODS_DIR.glob("*.pw.toml")):
        with open(toml_path, "rb") as f:
            data = tomllib.load(f)
        name = data.get("name", toml_path.stem)
        filename = data.get("filename", "")
        version = extract_version(filename, mc_version)
        entries.append(f"* {name} {version}")

    print("Mod list:")
    print("\n".join(entries))


if __name__ == "__main__":
    main()
