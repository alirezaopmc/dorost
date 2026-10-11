# Dorost

**Dorost** (`درست`) is a use-case-neutral Typst package for English, Persian, and mixed-script documents. It provides shared page and typography defaults while leaving document content, structure, and identity to the author.

> Early development: API and defaults may change before the first release.

## Development

Requires Typst 0.15.1 or later. Compile the smoke fixture with `./scripts/check.sh`.

The package source is MIT licensed. The copied starter in `template/` is MIT-0. Bundled fonts, if present in a release, retain their upstream OFL-1.1 license and provenance. See [LICENSE](LICENSE), [LICENSE-MIT-0](LICENSE-MIT-0), and `assets/fonts/`.

## Scope

Dorost is a reusable core, not a university, course, proposal, thesis, or report format. Use Typst's native document features and compose your own content and visual identity around the public API.
