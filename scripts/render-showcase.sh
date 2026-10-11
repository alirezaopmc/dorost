#!/usr/bin/env bash
# Render the editable showcase with checksum-pinned fonts and no global packages.
set -euo pipefail
if [[ $# -ne 1 ]]; then
  echo "usage: $0 OUTPUT_DIRECTORY" >&2
  exit 2
fi
root=$(cd "$(dirname "$0")/.." && pwd)
mkdir -p "$1"
output=$(cd "$1" && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
python3 "$root/scripts/fetch-test-fonts.py" "$work/fonts"
version=$(python3 - "$root/typst.toml" <<'PY'
import sys, tomllib
with open(sys.argv[1], "rb") as source:
    print(tomllib.load(source)["package"]["version"])
PY
)
package="$work/packages/preview/dorost/$version"
mkdir -p "$package"
cp "$root/typst.toml" "$root/lib.typ" "$package/"
cp -R "$root/src" "$root/template" "$package/"
args=(--package-path "$work/packages" --package-cache-path "$work/cache" --ignore-system-fonts --font-path "$work/fonts" --creation-timestamp 0)
for mode in document slides; do
  typst compile "$root/examples/showcase.typ" "$output/showcase-$mode.pdf" --input "showcase=$mode" "${args[@]}"
done
# Rasterize representative pages at a fixed width. Poppler PNG compression is
# lossless and optimized; no image/font dependencies beyond the check toolchain.
pdftoppm -f 1 -l 1 -singlefile -scale-to-x 1200 -scale-to-y -1 -png "$output/showcase-document.pdf" "$output/showcase-cover"
pdftoppm -f 2 -l 2 -singlefile -scale-to-x 1200 -scale-to-y -1 -png "$output/showcase-document.pdf" "$output/showcase-body"
pdftoppm -f 2 -l 2 -singlefile -scale-to-x 1440 -scale-to-y -1 -png "$output/showcase-slides.pdf" "$output/showcase-slides"
echo "Showcase PDFs and PNGs: $output"
