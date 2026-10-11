# Contributing

Issues and pull requests are welcome. Keep changes focused, explain the user-facing behavior, and preserve Dorost's use-case-neutral scope.

## Before opening a pull request

- Keep the public API small and document every public option or helper.
- Preserve independent language, direction, font, and numeral settings.
- Add or update a focused Typst fixture for behavior changes.
- Run `./scripts/check.sh` and `git diff --check`.
- Inspect at least one rendered English and Persian/mixed-script example when changing layout or typography.
- Do not add unlicensed fonts, logos, or generated PDFs.

## Releases

The maintainer updates `typst.toml`, the changelog, and examples together, runs the full local check, then tags a semantic version. The corresponding release is reviewed before publishing the package to Typst Universe. Never publish an unreviewed API or font/license change.

See [AGENTS.md](AGENTS.md) for repository-specific implementation guidance.
