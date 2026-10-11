# Dorost

**Dorost** (`درست`) is a use-case-neutral Typst package for English, Persian, and mixed-script documents. It provides shared page and typography defaults while leaving content, structure, and visual identity to each author.

> Pre-release: the package is not published yet. Its planned package name is `@preview/dorost`; the API may still change before version 0.1.0.

## Quick start

After publication, create an editable starter with:

```sh
typst init @preview/dorost:0.1.0
```

Or use the package in an existing `.typ` file:

```typ
#import "@preview/dorost:0.1.0": document
#show: document.with(lang: "en", direction: "ltr")

= Your title

Write with native Typst headings, paragraphs, lists, tables, links, code, and math.
```

The package is not tied to a university, course, proposal, thesis, report, or other document type. Consumers compose their own content and identity around the small core API.

## Configuration

`document` sets page geometry, text language/direction/font/size/color, paragraph leading/spacing, list indentation/spacing, and LTR code styling. It does not add titles, headers, metadata, or sections.

```typ
#show: document.with(
  lang: "fa",
  direction: "rtl",
  page: (paper: "a4", margin: (x: 24mm, y: 22mm)),
  fonts: (body: ("Lora", "Vazirmatn"), code: "JetBrains Mono"),
  text: (size: 11pt, paragraph-spacing: 0.8em),
  colors: (accent: rgb("235789")),
)
```

Language, direction, font roles, and digit formatting are independent. `lang` is a non-empty language tag; `direction` accepts the string `"ltr"` or `"rtl"`. Partial option dictionaries override only supplied fields. Unknown keys and invalid language/direction values produce clear errors.

| Export | Default |
| --- | --- |
| `default-fonts` | Body: Lora with Vazirmatn fallback; code: JetBrains Mono |
| `default-page` | A4 with 2 cm horizontal and vertical margins |
| `default-text` | 11 pt; 0.65 em leading; 1 em paragraph spacing; 0.6 em list indent and spacing |
| `default-colors` | Body text; muted footnotes; accent headings and links; rule lines |

Override either font role with a string or a Typst font fallback array. Fonts are bundled under their own licenses and loaded explicitly for local checks; see [`assets/fonts/README.md`](assets/fonts/README.md). Lora covers Latin; Vazirmatn supplies Persian glyphs. Vazirmatn includes regular and bold faces; Typst may synthesize other faces. Math uses Typst's embedded math font.

## Mixed direction and Persian digits

`ltr[content]` and `rtl[content]` apply only local text direction. Use them around Latin identifiers, URLs, or RTL phrases when needed. They do not select language or font. Raw code is automatically LTR and uses the code font role.

`persian-digits(value)` explicitly maps ASCII digits `0`–`9` to Persian digits in strings and integers. It preserves punctuation and other string characters. It does not inspect or modify arbitrary Typst content, code, URLs, or math.

```typ
#import "@preview/dorost:0.1.0": document, ltr, persian-digits
#show: document.with(lang: "fa", direction: "rtl")

شناسه #ltr[API.get(2)] و تاریخ #ltr[#persian-digits("2026-10-11")]
```

See [`examples/`](examples/) for English, Persian, mixed-direction, and custom-theme sources.

## Development and verification

Requires Typst 0.15.1 or later, `pdftotext`, and Python 3 for the standard-library PNG check. The minimum supported and current stable Typst version are both 0.15.1 at this pre-release stage.

```sh
./scripts/check.sh
```

The check compiles all fixtures and examples with system fonts disabled, tests configuration failures, verifies extracted Persian/Latin content, checks manifest rejection, and initializes and compiles the starter in a temporary directory. Generated PDFs are removed after the run. GitHub Actions runs the same command with Typst 0.15.1.

## License

Package code is MIT licensed. The copied starter in `template/` is MIT-0. The three bundled typefaces retain their upstream OFL-1.1 licenses and provenance. The manifest's SPDX expression is `MIT AND MIT-0 AND OFL-1.1`; the file-to-license mapping is documented here and beside the font assets. See [LICENSE](LICENSE), [LICENSE-MIT-0](LICENSE-MIT-0), and each font directory's `OFL.txt`.

## Contributing and releases

See [CONTRIBUTING.md](CONTRIBUTING.md) for pull-request checks, scope, and the reviewed release process. Repository-specific implementation guidance is in [AGENTS.md](AGENTS.md).
