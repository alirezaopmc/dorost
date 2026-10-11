# Dorost composition API design

**Status:** Proposed for implementation planning
**Date:** 2026-10-11
**Package:** `@preview/dorost`

## Goal

Expand Dorost from document defaults and text-direction helpers into a small, use-case-neutral Typst composition library for English, Persian, and mixed-script work. Extract reusable patterns found in `aputir/course-materials` and `research/proposal`, including document covers/page chrome, content components, and slide layouts. Keep each feature optional and caller-controlled so users can compose academic, business, educational, and personal material without inheriting a particular institution or document type.

The main sample and README should show the package's range at first glance, including rendered document and slide previews. Public API names and examples should teach compositional Typst patterns, not imitate React runtime concepts.

## Constraints and decisions

- The sole package slug remains `dorost` (`@preview/dorost`); this is one package, not a family of use-case packages.
- English, Persian, and mixed-script content are first-class. Language, text direction, fonts, numeral conversion, and layout remain independently controlled.
- Slides are in scope alongside document layouts.
- The package stays pure Typst, uses native Typst content/functions and layout primitives, and adds no Rust runtime or external runtime dependency.
- `lib.typ` is the explicit public API boundary. Internal modules can change without exposing implementation details.
- Existing `document()` calls remain source-compatible. New functionality is additive; the planned API expansion targets `0.2.0` while the package remains pre-1.0.
- Consumers provide logos, names, metadata, prose, image assets, and institutional identity. Dorost supplies generic structure and styling only.
- Do not bundle fonts, reference-project artwork, PDFs, or organization-specific assets.

## Reference patterns to extract

From `aputir/course-materials/src/course/theme.typ`:

- Theme tokens and document composition (extract the configurable token and composition patterns, not course defaults or course metadata).
- Reusable badges, resource links, quote frames, prompt/example blocks, notes, and checklists.
- Explicit inline code and math helpers that isolate LTR content within RTL documents.
- Slide cover, section divider, content shell, column, image/text, image, statement, and counter/footer patterns.

From `research/proposal/src/lib`:

- Neutral cover and letter/page shells, centered blocks, and configurable page header/footer patterns.
- Generic labeled fields, choice/radio rows, reference boxes, and data-table/grid patterns.
- Optional borders and section-title frames.
- Explicit digit conversion and narrowly scoped direction helpers.

Do not copy proposal schemas, labels, locale-file loading, course reflection content, university names/logos, proposal-specific form choices, or other workflow-specific policy. The reference repositories are sources of patterns, not runtime dependencies or mandatory defaults.

## Architecture

Keep the package organized by responsibility, with public exports re-exported explicitly by `lib.typ`:

```text
lib.typ                  # stable, documented public exports
src/config.typ           # shared defaults, validation, token resolution
src/document.typ         # existing document() setup; preserve behavior
src/layout/              # generic cover, page shell, header/footer helpers
src/components/          # content-first reusable blocks and inline helpers
src/slides/              # slide geometry, shells, layouts, counters
src/text/                # direction and explicit digit helpers
examples/                # editable end-to-end document and slide samples
```

Module internals should be independently understandable. Shared defaults/tokens belong in configuration, document page behavior belongs in the document module, presentation geometry belongs in slides, and content components should not own global page configuration. Helpers should use native Typst elements and `set`/`show` rules where appropriate rather than create a parallel document model.

Use content-first APIs: a body/content argument represents caller-owned children; named optional parameters represent layout slots, style overrides, or optional metadata. Use dictionaries only for coherent groups of style options or existing configuration areas. Validate public option dictionaries against defaults and report unknown keys with Dorost-prefixed errors, consistent with the current config behavior. Avoid broad `..args` forwarding unless the function is intentionally a thin native Typst adapter and documents the accepted arguments.

Illustrative API shapes (names and exact signatures are subject to review during implementation):

```typ
#show: document.with(lang: "fa", direction: "rtl")
#cover-page(title: [Title], subtitle: none, author: none, logo: none, body: [Optional details])
#page-chrome(header: none, footer: none, numbering: true, rule: true)[document body]
#note(title: none, tone: "neutral")[content]
#data-table(columns: (...), rows: (...), header: true, align: auto)

#show: slides.with(ratio: "16:9", show-counter: true)
#slide-cover(title: [Talk title], subtitle: none, author: none)
#slide-section(title: [Section])
#slide-columns(title: none, left: [...], right: [...], ratio: (1fr, 1fr))
```

These are composable helpers, not required wrappers. A user can use a note or slide layout without opting into a cover, global theme, or document-specific template. Optional metadata must not silently print unless explicitly passed to a component that displays it.

## Capability scope

### Document composition

- A generic cover/page shell with optional title, subtitle, author, date, logo/image, and caller-supplied details; omitted slots collapse cleanly.
- Opt-in page chrome for headers, footers, rules, and page numbering, with content/function slots where Typst context permits.
- Reusable neutral content components: notes/callouts with semantic tone, badges, resource links, quote frames, prompt/example pairs, checklists, labeled fields, choice groups, data tables, and optional border/section-title frames.
- Inline helpers for code and math that set appropriate LTR context without changing surrounding language or converting arbitrary content.

### Slides

- An opt-in slide setup with configurable page ratio, margins, background/theme tokens, and optional counter/footer behavior.
- Generic cover, section divider, content shell, columns, image, image/text, and statement layouts.
- Layout functions accept caller-owned body content and optional title/source/attribution fields. Image paths and all wording remain caller supplied.
- Slide APIs must be validated against Typst's page/show-rule behavior so per-slide composition does not leak state into document pages or other slides.

### Shared configuration

- Preserve current default configuration exports and current language/direction/font/digit behavior.
- Extend tokens only where shared visual consistency needs them; avoid a large theme framework or mandatory global theme object.
- Keep package-level typography defaults sensible for Latin and Persian; do not assume every consumer has the preferred families installed. Continue documenting font installation and fallback behavior.

## README and sample

Place a compact preview gallery immediately after the introductory description and before the quick-start details. At minimum include rendered cover/document-body and slide images with meaningful alt text and relative repository paths that GitHub renders. Keep source `.typ` examples editable under `examples/`; generated PDFs and screenshots belong in a deliberate showcase/artifact location and must not be required package inputs.

The showcase should exercise optionality and mixed direction: English, Persian, inline LTR identifiers, digits, representative reusable blocks, configurable cover/page chrome, and several slide layouts. Keep sample copy and identity clearly fictional and generic. Compile the examples and inspect page output, including RTL rendering, before updating previews.

## Compatibility and errors

- Existing `document()` semantics and exported names continue to work unchanged.
- New helpers are opt-in and additive. Avoid aliases whose only purpose is preserving draft API names before release.
- Public inputs should fail with clear, localized-to-the-API errors for invalid enumerations, ratios, or option keys rather than opaque layout errors when validation is practical.
- Invalid input must not cause unrelated global state or direction changes. Direction and digit conversion stay explicit and scoped.
- Exports are documented with purpose, parameter defaults, accepted values, an English example, and a Persian/mixed-script example where the behavior affects direction or typography.

## Verification and acceptance

Use the repository's existing `./scripts/check.sh` workflow and extend it with focused fixtures for newly public behavior. Acceptance requires:

1. Existing fixtures and starter continue compiling against the supported minimum Typst compiler.
2. Each public component has at least one fixture or included showcase use; invalid public configuration has a clear failure fixture where applicable.
3. At least one document and one slide example compile with English, Persian, and mixed-direction content.
4. A human visual inspection checks the cover, body page, and slide previews, including RTL alignment, clipping, page breaks, and counter behavior.
5. README embeds preview images near its opening; links and image paths resolve in the repository.
6. No use-case-specific names, logos, defaults, dependency on source repositories, or unlicensed assets enter the published package.
7. `typst.toml`, examples, documentation, and release notes agree on the package version; the expanded API is released as an additive `0.2.0` pre-1.0 change, following the existing OSS release process.

## Out of scope

- A university, course, proposal, thesis, paper, report, or business-specific template.
- Content/data loaders, YAML schemas, localization catalogs, or automatic inference of a document's language, direction, or digits.
- Custom page-building/rendering engines, runtime state, automatic theme switching, or React-like component lifecycle/prop spreading.
- Bundled font binaries, logos, reference artwork, or committing release PDFs as package dependencies.
- A Rust implementation or a separate Rust package.

## Risks to resolve during implementation planning

- Typst context, page breaks, and `show` rules can make a universal cover/page-chrome function overly magical. Prefer explicit composition and create separate layout helpers if behavior cannot stay predictable.
- A reusable slide system can accidentally entangle slide-specific geometry with document defaults. Keep slide setup isolated and verify state boundaries with mixed document/slide fixtures.
- Optional fields can create unwieldy signatures. Group only related styling options and keep content slots named and explicit; split helpers when responsibilities diverge.
- `data-table`, choice groups, and checklist APIs can be over-designed without stable generic contracts. Implement only the simplest source-backed patterns that remain broadly reusable and demonstrate each with clear examples.
- README screenshots can drift from source. Generate them from committed examples in a reproducible workflow or clearly document the maintainer update steps.
