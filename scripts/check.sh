#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
for namespace in local preview; do
  package="$work/packages/$namespace/dorost/0.1.0"
  mkdir -p "$package"
  cp "$root/typst.toml" "$root/lib.typ" "$package/"
  cp -R "$root/template" "$root/src" "$root/assets" "$package/"
done

cd "$root"
compile_args=(--package-path "$work/packages" --ignore-system-fonts --font-path "$root/assets/fonts")
for fixture in smoke document-config mixed-direction persian-digits; do
  typst compile "tests/fixtures/$fixture.typ" "$work/$fixture.pdf" "${compile_args[@]}"
done
for example in examples/*.typ; do
  name=$(basename "$example" .typ)
  typst compile "$example" "$work/example-$name.pdf" "${compile_args[@]}"
  pdftotext -layout "$work/example-$name.pdf" "$work/example-$name.txt"
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

typst init @local/dorost:0.1.0 "$work/generated" --package-path "$work/packages" --package-cache-path "$work/cache"
typst compile "$work/generated/main.typ" "$work/generated.pdf" "${compile_args[@]}"
pdftotext "$work/generated.pdf" "$work/generated.txt"
grep -Fq 'Start with Dorost' "$work/generated.txt"
grep -Fq 'Replace this sample with your own content.' "$work/generated.txt"

for fixture in tests/fixtures/invalid-*.typ; do
  if typst compile "$fixture" "$work/invalid.pdf" "${compile_args[@]}" >"$work/invalid.log" 2>&1; then
    echo "expected configuration failure: $fixture" >&2
    exit 1
  fi
  grep -Fq 'dorost:' "$work/invalid.log"
done

echo "OK: package, examples, configuration, bilingual text, starter init, and validation fixtures"
