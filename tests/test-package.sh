#!/usr/bin/env bash
# Compile every example and the starter, assert exported helpers, and require non-empty PDFs.
set -euo pipefail

root="$(realpath "$(dirname "${BASH_SOURCE[0]}")/..")"
cd "$root"

read_manifest() {
  python3 - "$root/typst.toml" "$1" <<'PY'
import sys
import tomllib

with open(sys.argv[1], "rb") as manifest_file:
    value = tomllib.load(manifest_file)["package"][sys.argv[2]]
print(value)
PY
}

package_version="$(read_manifest version)"
pinned_version="$(read_manifest compiler)"

version_at_least() {
  local required="$1"
  local found="$2"
  local IFS=.
  local required_parts found_parts
  read -r -a required_parts <<<"$required"
  read -r -a found_parts <<<"$found"
  local index
  for index in 0 1 2; do
    if ((found_parts[index] > required_parts[index])); then
      return 0
    fi
    if ((found_parts[index] < required_parts[index])); then
      return 1
    fi
  done
  return 0
}

fetch_typst() {
  local requested="$1"
  local checksum
  case "$requested" in
    0.15.0) checksum=59b207df01be2dab9f13e80f73d04d7ff8273ffd46b3dd1b9eef5c60f3eeabea ;;
    0.15.1) checksum=a6d077d0a95eed5a2eba715b2dae06be954f624ccbf85758a03f389ded33118c ;;
    *)
      echo "unsupported Typst version: $requested (use 0.15.0 or 0.15.1)" >&2
      exit 1
      ;;
  esac

  local cache="${XDG_CACHE_HOME:-$HOME/.cache}/dorost/typst/$requested"
  local binary="$cache/typst"
  if [[ -x "$binary" ]]; then
    printf '%s\n' "$binary"
    return
  fi

  for tool in curl sha256sum tar xz; do
    command -v "$tool" >/dev/null 2>&1 ||
      { echo "missing tool to fetch Typst $requested: $tool" >&2; exit 127; }
  done

  local archive="$cache/typst.tar.xz"
  local extract="$cache/extract"
  mkdir -p "$cache" "$extract"
  echo "==> fetching Typst $requested" >&2
  curl --fail --location --silent --show-error \
    "https://github.com/typst/typst/releases/download/v${requested}/typst-x86_64-unknown-linux-musl.tar.xz" \
    --output "$archive"
  printf '%s  %s\n' "$checksum" "$archive" | sha256sum --check --strict >/dev/null
  tar -xJf "$archive" -C "$extract" --strip-components=1
  mv "$extract/typst" "$binary"
  chmod +x "$binary"
  rm -f -- "$archive"
  printf '%s\n' "$binary"
}

work="$(mktemp -d)"
trap 'rm -rf -- "$work"' EXIT

fonts="${DOROST_TEST_FONTS:-}"
if [[ -z "$fonts" ]]; then
  fonts="$work/fonts"
  python3 "$root/scripts/fetch-test-fonts.py" "$fonts"
fi

package_path="${DOROST_TEST_PACKAGE_PATH:-}"
if [[ -z "$package_path" ]]; then
  package_path="$work/packages"
  for namespace in local preview; do
    package="$package_path/$namespace/dorost/$package_version"
    mkdir -p "$package"
    cp "$root/typst.toml" "$root/lib.typ" "$package/"
    cp -R "$root/template" "$root/src" "$package/"
  done
fi

typst_bin="${TYPST_BIN:-}"
if [[ -n "$typst_bin" ]]; then
  typst_bin="$(realpath "$typst_bin")"
elif command -v typst >/dev/null 2>&1; then
  typst_bin="$(command -v typst)"
fi

if [[ -n "$typst_bin" ]] &&
  ! version_at_least "$pinned_version" "$("$typst_bin" --version | awk '{print $2}')"; then
  echo "typst at $typst_bin is older than the package's compiler version $pinned_version" >&2
  if [[ -n "${TYPST_BIN:-}" ]]; then
    exit 1
  fi
  typst_bin=""
fi

if [[ -z "$typst_bin" ]]; then
  typst_bin="$(fetch_typst "${DOROST_TYPST_VERSION:-$pinned_version}")"
fi

compile_pdf() {
  local source="$1"
  local output="$2"
  "$typst_bin" compile "$source" "$output" \
    --package-path "$package_path" \
    --ignore-system-fonts \
    --font-path "$fonts" >/dev/null
  [[ -s "$output" ]] || { echo "expected a non-empty PDF from $source" >&2; exit 1; }
}

compile_pdf "tests/fixtures/assert-api.typ" "$work/assert-api.pdf"
compile_pdf "template/main.typ" "$work/template.pdf"

shopt -s nullglob
examples=(examples/*.typ)
shopt -u nullglob
[[ ${#examples[@]} -gt 0 ]] || { echo "no examples found in examples/" >&2; exit 1; }

for example in "${examples[@]}"; do
  name="$(basename "$example" .typ)"
  compile_pdf "$example" "$work/example-$name.pdf"
done

echo "test-package: function assertions, the template, and ${#examples[@]} example PDFs verified"
