#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT
package="$work/packages/local/dorost/0.1.0"
mkdir -p "$package"
cp "$root/typst.toml" "$root/lib.typ" "$package/"
cp -R "$root/template" "$package/"

# Compile from the repository root so fixture paths stay stable.
cd "$root"
typst compile tests/fixtures/smoke.typ "$work/smoke.pdf" --package-path "$work/packages"
