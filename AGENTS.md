# Repository guidance

- Keep Dorost independent of document use cases and institutions.
- Treat `lib.typ` as the public API boundary; export names explicitly.
- Prefer native Typst features over parallel component systems.
- Keep language, direction, fonts, and numeral formatting independently configurable.
- Persian digit conversion must be explicit; never mutate code, URLs, math, or arbitrary content.
- Add a focused fixture before changing behavior; run `./scripts/check.sh`.
- Preserve upstream licenses and provenance for bundled assets.
