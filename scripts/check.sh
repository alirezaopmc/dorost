#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
package="$work/packages/local/dorost/0.1.0"
mkdir -p "$package"
cp "$root/typst.toml" "$root/lib.typ" "$package/"
cp -R "$root/template" "$root/src" "$package/"

cd "$root"
for fixture in smoke document-config mixed-direction persian-digits; do
  typst compile "tests/fixtures/$fixture.typ" "$work/$fixture.pdf" --package-path "$work/packages"
done
pdftotext "$work/document-config.pdf" "$work/document-config.txt"
grep -Fq 'English LTR defaults remain explicit.' "$work/document-config.txt"
grep -Fq 'API.get(2)' "$work/document-config.txt"
for fixture in mixed-direction persian-digits; do
  pdftotext -layout "$work/$fixture.pdf" "$work/$fixture.txt"
done
grep -Fq 'https://example.com/a?b=2' "$work/mixed-direction.txt"
grep -Fq 'ی' "$work/mixed-direction.txt"
grep -Fq 'ک' "$work/mixed-direction.txt"
grep -Fq '‌' "$work/mixed-direction.txt"
grep -Fq '۲۰۲۶-۱۰-۱۱' "$work/persian-digits.txt"
grep -Fq '2026-10-11' "$work/persian-digits.txt"

for fixture in tests/fixtures/invalid-*.typ; do
  if typst compile "$fixture" "$work/invalid.pdf" --package-path "$work/packages" >"$work/invalid.log" 2>&1; then
    echo "expected configuration failure: $fixture" >&2
    exit 1
  fi
  grep -Fq 'dorost:' "$work/invalid.log"
done

echo "OK: package smoke, configuration, direction, digits, and validation fixtures"
