# Changelog

## [Unreleased]

## [0.2.1] - 2026-10-12

### Changed

- Allow `code-inline` callers to set a font and size, defaulting to the configured code font and inherited size.
- Disable ligatures and contextual substitutions in inline code so operators retain their source characters.

## [0.2.0] - 2026-10-11

### Added

- Add optional reusable document components, cover and page chrome layouts, and slide layouts.
- Add an editable bilingual showcase with README preview images and release PDF artifacts.

## [0.1.1] - 2026-10-11

### Changed

- Declare Typst 0.15.0 as the minimum supported compiler version.

## [0.1.0] - 2026-10-11

### Added

- Add a use-case-neutral document wrapper with independent language, direction, font, page, text, and color settings.
- Add explicit LTR/RTL spans and opt-in Persian digit formatting.
- Add an editable starter and English, Persian, and mixed-script examples.
- Add bilingual CI fixtures with checksum-pinned upstream test fonts fetched outside the repository.
- Add package, template initialization, bilingual rendering, and configuration checks.
