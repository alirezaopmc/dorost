#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
package_version=$(python3 - "$root/typst.toml" <<'PY'
import sys
import tomllib

with open(sys.argv[1], "rb") as manifest_file:
    print(tomllib.load(manifest_file)["package"]["version"])
PY
)
work=$(mktemp -d)
artifact_dir=${DOROST_ARTIFACT_DIR:-}
if [[ -n "$artifact_dir" ]]; then
  mkdir -p "$artifact_dir"
fi
cleanup() {
  if [[ -n "$artifact_dir" ]]; then
    find "$work" -maxdepth 1 -type f \( -name '*.pdf' -o -name '*.svg' \) -exec cp {} "$artifact_dir/" \;
  fi
  rm -rf "$work"
}
trap cleanup EXIT

# Mirror the source into local development and preview namespaces. This also
# verifies that the same source works through both supported import names.
for namespace in local preview; do
  package="$work/packages/$namespace/dorost/$package_version"
  mkdir -p "$package"
  cp "$root/typst.toml" "$root/lib.typ" "$package/"
  cp -R "$root/template" "$root/src" "$package/"
done

require_text() {
  local file=$1
  local expected=$2
  if ! grep -Fq -- "$expected" "$file"; then
    echo "missing expected text '$expected' in $file" >&2
    exit 1
  fi
}

cd "$root"
compile_args=(--package-path "$work/packages" --ignore-system-fonts --font-path "$root/tests/fonts")
python3 - "$root" "$package_version" <<'PY'
import re
import sys
from pathlib import Path

root = Path(sys.argv[1])
version = sys.argv[2]
pattern = re.compile(r"@(preview|local)/dorost:(\d+\.\d+\.\d+)")
files = [root / "README.md", root / "template/main.typ"]
files.extend(sorted((root / "examples").glob("*.typ")))
files.extend(sorted((root / "tests/fixtures").glob("*.typ")))
seen = {"preview": 0, "local": 0}
for path in files:
    text = path.read_text(encoding="utf-8")
    matches = list(pattern.finditer(text))
    if not matches:
        raise SystemExit(f"missing Dorost import in {path.relative_to(root)}")
    expected_namespace = "local" if path.is_relative_to(root / "tests") else "preview"
    for match in matches:
        namespace, found_version = match.groups()
        if namespace != expected_namespace:
            raise SystemExit(f"unexpected @{namespace} import in {path.relative_to(root)}")
        if found_version != version:
            raise SystemExit(
                f"stale Dorost import in {path.relative_to(root)}: "
                f"expected {version}, found {found_version}"
            )
        seen[namespace] += 1
if not all(seen.values()):
    raise SystemExit("expected both preview and local Dorost imports")
PY
python3 "$root/scripts/release-notes.py" "v$package_version" >/dev/null
for fixture in smoke document-config mixed-direction persian-digits colors; do
  typst compile "tests/fixtures/$fixture.typ" "$work/$fixture.pdf" "${compile_args[@]}"
done
for example in examples/*.typ; do
  name=$(basename "$example" .typ)
  typst compile "$example" "$work/example-$name.pdf" "${compile_args[@]}"
  pdftotext -layout "$work/example-$name.pdf" "$work/example-$name.txt"
done

pdftotext "$work/document-config.pdf" "$work/document-config.txt"
require_text "$work/document-config.txt" 'English LTR defaults remain explicit.'
require_text "$work/document-config.txt" 'API.get(2)'
typst compile -f svg tests/fixtures/colors.typ "$work/colors.svg" "${compile_args[@]}"
tr '[:upper:]' '[:lower:]' < "$work/colors.svg" > "$work/colors-lower.svg"
for color in 102030 405060 708090 a0b0c0; do
  require_text "$work/colors-lower.svg" "#$color"
done
for fixture in mixed-direction persian-digits; do
  pdftotext -layout "$work/$fixture.pdf" "$work/$fixture.txt"
done
require_text "$work/mixed-direction.txt" 'شناسه'
require_text "$work/mixed-direction.txt" 'فارسی'
require_text "$work/mixed-direction.txt" 'English'
require_text "$work/mixed-direction.txt" 'API.get(2'
require_text "$work/mixed-direction.txt" 'https://example.com/a?b=2'
require_text "$work/mixed-direction.txt" 'ی'
require_text "$work/mixed-direction.txt" 'ک'
require_text "$work/mixed-direction.txt" '‌'
require_text "$work/persian-digits.txt" '۲۰۲۶-۱۰-۱۱'
require_text "$work/persian-digits.txt" '2026-10-11'
require_text "$work/example-persian.txt" 'سند فارسی'
require_text "$work/example-english.txt" 'English document'
require_text "$work/example-mixed-direction.txt" 'شناسه'

# Validate authored Persian words exactly. Poppler can reorder characters and
# punctuation within RTL PDF spans, so extraction is not a reliable source check.
require_text "$root/tests/fixtures/mixed-direction.typ" 'می‌روم'
require_text "$root/tests/fixtures/mixed-direction.typ" 'نیم‌فاصله'
require_text "$root/tests/fixtures/mixed-direction.typ" 'API.get(2)'

# The compiler must reject a malformed package manifest.
malformed_package="$work/malformed-packages/local/dorost/$package_version"
mkdir -p "$malformed_package"
cp -R "$work/packages/local/dorost/$package_version/." "$malformed_package/"
printf '\nnot-valid = [\n' >> "$malformed_package/typst.toml"
if typst init "@local/dorost:$package_version" "$work/malformed-project" \
  --package-path "$work/malformed-packages" \
  --package-cache-path "$work/malformed-cache" >"$work/malformed.log" 2>&1; then
  echo "expected Typst to reject malformed manifest" >&2
  exit 1
fi

# Generate and compile the user-facing starter against the published import path.
typst init "@local/dorost:$package_version" "$work/generated" \
  --package-path "$work/packages" \
  --package-cache-path "$work/cache"
mkdir -p "$work/generated/fonts"
cp -R "$root/tests/fonts/." "$work/generated/fonts/"
starter_args=(--package-path "$work/packages" --ignore-system-fonts --font-path "$work/generated/fonts")
typst compile "$work/generated/main.typ" "$work/generated.pdf" "${starter_args[@]}"
pdftotext "$work/generated.pdf" "$work/generated.txt"
require_text "$work/generated.txt" 'Start with Dorost'
require_text "$work/generated.txt" 'Replace this sample with your own content.'

for fixture in tests/fixtures/invalid-*.typ; do
  if typst compile "$fixture" "$work/invalid.pdf" "${compile_args[@]}" >"$work/invalid.log" 2>&1; then
    echo "expected configuration failure: $fixture" >&2
    exit 1
  fi
  grep -Fq 'dorost:' "$work/invalid.log"
done

# Keep the registry preview within Typst's documented image size limit.
python3 - "$root" <<'PY'
import struct
import sys
import tomllib
from pathlib import Path

root = Path(sys.argv[1])
manifest = tomllib.loads((root / "typst.toml").read_text(encoding="utf-8"))
path = root / manifest["template"]["thumbnail"]
if not path.is_file():
    raise SystemExit(f"template thumbnail does not exist: {path}")
data = path.read_bytes()
if data[:8] != b"\x89PNG\r\n\x1a\n":
    raise SystemExit("template thumbnail must be a PNG")
width, height = struct.unpack(">II", data[16:24])
if max(width, height) < 1080:
    raise SystemExit(f"template thumbnail is too small: {width}x{height}")
if len(data) > 3 * 1024 * 1024:
    raise SystemExit(f"template thumbnail exceeds 3 MiB: {len(data)} bytes")
PY

echo "OK: manifest, package, examples, bilingual text, starter init, and validation fixtures"
