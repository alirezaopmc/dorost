#!/usr/bin/env python3
"""Fetch checksum-pinned upstream fonts into a temporary test directory."""

from __future__ import annotations

import hashlib
import os
import sys
import tempfile
import urllib.request
import zipfile
from pathlib import Path


ARCHIVES = (
    (
        "vazirmatn-v33.003.zip",
        "https://github.com/rastikerdar/vazirmatn/releases/download/v33.003/vazirmatn-v33.003.zip",
        "0a9afd41967e6f57096a56a181a23f81a2b999b62f1f2a4e4b26736580854fdb",
        {
            "fonts/ttf/Vazirmatn-Regular.ttf": "vazirmatn/Vazirmatn-Regular.ttf",
            "fonts/ttf/Vazirmatn-Bold.ttf": "vazirmatn/Vazirmatn-Bold.ttf",
        },
    ),
    (
        "Lora.zip",
        "https://github.com/cyrealtype/Lora-Cyrillic/releases/download/v3.021/Lora.zip",
        "19061972d1124d258dffd41f3ad12ce2db513f9b31fb98ece7afe7b538e8647f",
        {
            "ttf/Lora-Regular.ttf": "lora/Lora-Regular.ttf",
            "ttf/Lora-Bold.ttf": "lora/Lora-Bold.ttf",
            "ttf/Lora-Italic.ttf": "lora/Lora-Italic.ttf",
            "ttf/Lora-BoldItalic.ttf": "lora/Lora-BoldItalic.ttf",
        },
    ),
    (
        "JetBrainsMono-2.304.zip",
        "https://github.com/JetBrains/JetBrainsMono/releases/download/v2.304/JetBrainsMono-2.304.zip",
        "6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf",
        {
            "fonts/ttf/JetBrainsMono-Regular.ttf": "jetbrains-mono/JetBrainsMono-Regular.ttf",
            "fonts/ttf/JetBrainsMono-Bold.ttf": "jetbrains-mono/JetBrainsMono-Bold.ttf",
        },
    ),
)


def fetch_archive(name: str, url: str, expected_sha256: str, cache: Path) -> Path:
    cache.mkdir(parents=True, exist_ok=True)
    archive = cache / name
    if not archive.exists():
        with tempfile.NamedTemporaryFile(dir=cache, delete=False) as temporary:
            temporary_path = Path(temporary.name)
        try:
            urllib.request.urlretrieve(url, temporary_path)
            temporary_path.replace(archive)
        finally:
            temporary_path.unlink(missing_ok=True)

    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    if digest != expected_sha256:
        archive.unlink(missing_ok=True)
        raise SystemExit(f"SHA-256 mismatch for {name}: got {digest}")
    return archive


def main() -> int:
    if len(sys.argv) != 2:
        raise SystemExit("usage: fetch-test-fonts.py DESTINATION")

    destination = Path(sys.argv[1])
    cache_root = Path(os.environ.get("XDG_CACHE_HOME", Path.home() / ".cache"))
    cache = cache_root / "dorost" / "test-font-archives"
    destination.mkdir(parents=True, exist_ok=True)

    for name, url, checksum, files in ARCHIVES:
        archive = fetch_archive(name, url, checksum, cache)
        with zipfile.ZipFile(archive) as bundle:
            for source, relative_target in files.items():
                target = destination / relative_target
                target.parent.mkdir(parents=True, exist_ok=True)
                target.write_bytes(bundle.read(source))

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
