# Test font fixtures

These upstream font files exist only to make CI rendering deterministic. The package manifest excludes `tests/`, so these fonts are not included in the Typst package. Dorost does not modify the fonts; each family retains its SIL Open Font License 1.1 text beside the files.

| Family | Version | Source | Included files |
| --- | --- | --- | --- |
| Vazirmatn | 33.003 | [upstream release](https://github.com/rastikerdar/vazirmatn/releases/tag/v33.003) | Regular and Bold TTFs |
| Lora | 3.021 | [upstream release](https://github.com/cyrealtype/Lora-Cyrillic/releases/tag/v3.021) | Regular, Bold, Italic, and BoldItalic TTFs |
| JetBrains Mono | 2.304 | [upstream release](https://github.com/JetBrains/JetBrainsMono/releases/tag/v2.304) | Regular and Bold TTFs |

Users should download fonts from the upstream releases and keep them in their own project or install them system-wide. Lora covers Latin; Vazirmatn supplies Persian glyphs. Math uses Typst's embedded math font.
