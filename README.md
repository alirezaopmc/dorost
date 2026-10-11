# Dorost

**Dorost** (`درست`) is a use-case-neutral Typst package for English, Persian, and mixed-script documents. It provides shared page and typography defaults while leaving document content, structure, and identity to the author.

> Early development: API and defaults may change before the first release.

## Development

Requires Typst 0.15.1 or later. Compile the smoke fixture with `./scripts/check.sh`.

The package source is MIT licensed. The copied starter in `template/` is MIT-0. Bundled fonts, if present in a release, retain their upstream OFL-1.1 license and provenance. See [LICENSE](LICENSE), [LICENSE-MIT-0](LICENSE-MIT-0), and `assets/fonts/`.

## Scope

Dorost is a reusable core, not a university, course, proposal, thesis, or report format. Use Typst's native document features and compose your own content and visual identity around the public API.

## Document defaults

The package entry point is `lib.typ`; import its documented names explicitly:

```typ
#import "@preview/dorost:0.1.0": document
#show: document.with(lang: "en", direction: ltr)

= Your title

Write with native Typst headings, paragraphs, lists, tables, links, code, and math.
```

`document` accepts independent `lang` (`"en"` by default), `direction` (`ltr` by default), `fonts`, `page`, `text`, and `colors` dictionaries. Language must be a non-empty language tag; direction is `ltr` or `rtl`. Partial dictionaries override only the supplied fields; unknown keys fail with a Dorost error.

| Export | Defaults |
| --- | --- |
| `default-fonts` | `body: ("Lora", "Vazirmatn")`, `code: "JetBrains Mono"` |
| `default-page` | A4, 2 cm horizontal and vertical margins |
| `default-text` | 11 pt, 0.65 em leading, 1 em paragraph spacing, 0.6 em list indent and spacing |
| `default-colors` | `text`, `muted`, `accent`, `rule` neutral color tokens |

The document wrapper sets page geometry, text language/direction/font/size/color, paragraph leading/spacing, list indentation/spacing, and LTR code styling. It does not add titles, headers, metadata, or sections. Override font roles through `fonts`; omitted roles retain their defaults.
