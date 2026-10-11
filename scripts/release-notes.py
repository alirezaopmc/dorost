#!/usr/bin/env python3
"""Validate a release tag against the package manifest and extract its notes."""

from __future__ import annotations

import re
import sys
import tomllib
from pathlib import Path


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit("usage: release-notes.py vMAJOR.MINOR.PATCH")

    tag = sys.argv[1]
    match = re.fullmatch(r"v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)", tag)
    if match is None:
        raise SystemExit(f"invalid release tag: {tag!r}; expected vMAJOR.MINOR.PATCH")

    version = ".".join(match.groups())
    root = Path(__file__).resolve().parent.parent
    manifest = tomllib.loads((root / "typst.toml").read_text(encoding="utf-8"))
    if manifest["package"]["version"] != version:
        raise SystemExit(
            f"tag version {version} does not match typst.toml version "
            f"{manifest['package']['version']}"
        )

    changelog = (root / "CHANGELOG.md").read_text(encoding="utf-8")
    lines = changelog.splitlines()
    heading = f"## [{version}] - "
    start = next((i for i, line in enumerate(lines) if line.startswith(heading)), None)
    if start is None:
        raise SystemExit(f"CHANGELOG.md has no dated release section for {version}")

    end = next(
        (i for i in range(start + 1, len(lines)) if lines[i].startswith("## ")),
        len(lines),
    )
    notes = "\n".join(lines[start + 1 : end]).strip()
    if not notes:
        raise SystemExit(f"CHANGELOG.md release section for {version} is empty")

    print(notes)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
