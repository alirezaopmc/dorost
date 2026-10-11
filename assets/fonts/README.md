# Bundled fonts and provenance

These files are included so CI, examples, and local builds can render with system fonts disabled. Each font remains under its upstream SIL Open Font License 1.1; its license text is stored beside the font files.

| Family | Version | Source | Included files |
| --- | --- | --- | --- |
| Vazirmatn | 33.003 | [upstream release](https://github.com/rastikerdar/vazirmatn/releases/tag/v33.003) | `Vazirmatn-Regular.ttf`, `Vazirmatn-Bold.ttf` |
| Lora | 3.021 | [upstream release](https://github.com/cyrealtype/Lora-Cyrillic/releases/tag/v3.021) | Regular, Bold, Italic, and BoldItalic TTFs |
| JetBrains Mono | 2.304 | [upstream release](https://github.com/JetBrains/JetBrainsMono/releases/tag/v2.304) | Regular and Bold TTFs |

Dorost does not modify the fonts. The body role tries Lora first and Vazirmatn as fallback for Persian glyphs. Vazirmatn provides regular and bold files; Typst may synthesize other faces for this family. The code role uses JetBrains Mono. Consumers can replace either role.
