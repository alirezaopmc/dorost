# Dorost composition API Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Expand Dorost into a use-case-neutral English/Persian Typst composition package with document layout, reusable content components, slide layouts, and a prominent visual showcase.

**Architecture:** Preserve the existing `document()` and config API while adding focused internal modules for document layout, components, and slides. Re-export the supported API explicitly from `lib.typ`; keep helpers content-first, optional, and built on native Typst layout primitives. Add fixtures and examples alongside each module, then update the showcase and prepare the additive 0.2.0 release.

**Tech Stack:** Typst 0.15.0+, Bash, Python 3.11+, Poppler (`pdftotext` and `pdftoppm`), GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-10-11-dorost-composition-api-design.md`

## Global Constraints

- The sole package slug remains `dorost` (`@preview/dorost`); this is one package, not a family of use-case packages.
- English, Persian, and mixed-script content are first-class. Language, text direction, fonts, numeral conversion, and layout remain independently controlled.
- Slides are in scope alongside document layouts.
- The package stays pure Typst, uses native Typst content/functions and layout primitives, and adds no Rust runtime or external runtime dependency.
- `lib.typ` is the explicit public API boundary. Internal modules can change without exposing implementation details.
- Existing `document()` calls remain source-compatible. New functionality is additive; the planned API expansion targets `0.2.0` while the package remains pre-1.0.
- Consumers provide logos, names, metadata, prose, image assets, and institutional identity. Dorost supplies generic structure and styling only.
- Do not bundle fonts, reference-project artwork, PDFs, or organization-specific assets.
- Keep the test/compiler floor at Typst 0.15.0 and use the existing checksum-pinned font fixture workflow.

## Review Focus

- **RTL page chrome and counters:** header/footer alignment and page numbering must follow page direction without corrupting LTR spans; cover in Task 3 fixtures.
- **Slide/document state leakage:** slide page settings and show rules must not alter following document pages; cover in Task 5 mixed-output fixture.
- **Optional content collapse:** omitted cover, note, field, and slide slots must not leave empty boxes or unintended spacing; cover in Tasks 2–4 fixtures.
- **Font fallback and code isolation:** missing preferred families and RTL surrounding raw code must preserve current fallback and LTR code behavior; cover in Task 2 fixtures.
- **Invalid options:** unsupported component tone/ratio/fit values must fail with `dorost:` errors in Tasks 2–5; existing unknown shared-config key fixtures must continue passing through Task 1.

---

## File map

- `lib.typ` — explicit public re-exports only.
- `src/config.typ` — existing validated shared defaults; add shared tokens only where the new APIs need them.
- `src/document.typ` — preserve the current wrapper and delegate only shared defaults/validation.
- `src/layout/cover.typ` — generic cover composition.
- `src/layout/page-chrome.typ` — opt-in header, footer, page rule, and numbering configuration.
- `src/components/blocks.typ` — note/callout, badge, quote, prompt/example, and checklist.
- `src/components/resources.typ` — resource-link and resource-list patterns.
- `src/components/forms.typ` — labeled fields and choice groups.
- `src/components/tables.typ` — generic data-table/grid primitive.
- `src/components/frames.typ` — optional border and section-title frames.
- `src/components/inline.typ` — explicit inline code and math helpers.
- `src/slides/setup.typ` — isolated slide page setup, ratio validation, and counter/footer behavior.
- `src/slides/layouts.typ` — cover, section, content, columns, image, image/text, and statement layouts.
- `tests/fixtures/` — focused compile/failure fixtures, following current naming conventions.
- `examples/` — editable end-to-end English, Persian, mixed-script, document, and slide sources.
- `scripts/render-showcase.sh` — reproducibly render showcase PDFs and first-page PNG previews for README/release use.
- `assets/` — committed small preview PNGs used directly in README; no font binaries or reference-project art.
- `README.md`, `CHANGELOG.md`, `typst.toml`, `template/main.typ` — user-facing API, version, starter references, and package exclusions for repository-only preview/docs assets.
- `scripts/check.sh` — compile new fixtures/examples and validate generated showcase files and repository links.

## Tasks

### Task 1: Lock existing compatibility and shared token contracts

**Files:**
- Create: `tests/fixtures/document-compatibility.typ`
- Modify: `scripts/check.sh`

**Interfaces:**
- Consumes: current `document(body, lang:, direction:, fonts:, page:, text:, colors:)` and exported defaults.
- Produces: a regression fixture for the existing API. The current `default-fonts`, `default-page`, `default-text`, and `default-colors` exports are the shared token contract; do not add aliases or new token layers. Later components can import the existing defaults internally and own their options locally.

- [ ] **Step 1: Add a compatibility fixture** that compiles the current default `document()` call, a partial font/color override, and a raw code block inside Persian RTL text. Assert that extracted PDF text contains both Persian and `API.get(2)`.
- [ ] **Step 2: Run the fixture through `./scripts/check.sh`** and confirm it passes before changing the configuration modules.
- [ ] **Step 3: Keep the current config and `lib.typ` exports unchanged** unless the compatibility fixture exposes a regression; do not introduce duplicate token aliases or course/proposal-specific defaults.
- [ ] **Step 4: Run `./scripts/check.sh`** and confirm the compatibility fixture and all existing fixtures pass.
- [ ] **Step 5: Commit** as `test: lock existing Dorost API compatibility`.

### Task 2: Add neutral inline and reusable content components

**Files:**
- Create: `src/components/inline.typ`
- Create: `src/components/blocks.typ`
- Create: `src/components/resources.typ`
- Create: `tests/fixtures/components.typ`
- Create: `tests/fixtures/invalid-component-options.typ`
- Modify: `lib.typ`
- Modify: `scripts/check.sh`

**Interfaces:**
- Consumes: shared tokens from Task 1; native Typst content.
- Produces: `code-inline(value)`, `math-inline(body)`, `badge(body, tone: "accent")`, `note(body, title: none, tone: "neutral")`, `quote-frame(body, attribution: none)`, `prompt-example(label, body)`, `checklist(items)`, `resource-link(url, label, detail: none)`, and `resource-links(..items)`.
- Enumerations: `tone` accepts `"neutral"`, `"accent"`, and `"muted"`; unknown values produce `dorost:` errors.
- `checklist(items)` accepts an array of content items. `resource-links(..items)` accepts resource-link content as positional items.

- [ ] **Step 1: Write the component fixture** with each helper, omitted optional fields, and English/Persian content. Assert the rendered PDF contains visible authored labels and Persian text.
- [ ] **Step 2: Write the invalid-options fixture** and assert an unsupported tone fails with `dorost:` in compiler output.
- [ ] **Step 3: Register both fixtures in `scripts/check.sh`** using the existing fixture compile/error loops; run the script and confirm the new fixtures fail before implementations exist.
- [ ] **Step 4: Implement the helpers in their owning modules** using content-first arguments and optional slots. `code-inline` must set LTR direction and the code font without changing surrounding text; `math-inline` must scope LTR only to its body.
- [ ] **Step 5: Export the public helpers from `lib.typ`** and run `./scripts/check.sh`; confirm positive and invalid-option fixtures behave as expected.
- [ ] **Step 6: Commit** as `feat: add reusable content components`.

### Task 3: Add generic cover and page chrome

**Files:**
- Create: `src/layout/cover.typ`
- Create: `src/layout/page-chrome.typ`
- Create: `tests/fixtures/document-layouts.typ`
- Create: `tests/fixtures/invalid-page-chrome.typ`
- Modify: `lib.typ`
- Modify: `scripts/check.sh`

**Interfaces:**
- Consumes: shared tokens from Task 1 and content helpers from Task 2.
- Produces: `cover-page(title, subtitle: none, author: none, date: none, logo: none, details: none)` as an opt-in cover block; `page-chrome(body, header: none, footer: none, numbering: true, rule: true)` as an opt-in page-layout wrapper.
- Caller owns the content, labels, logo, and identity. Omitted slots create no placeholder labels.

- [ ] **Step 1: Add a document-layout fixture** with an English cover, a Persian cover omitting author/date/logo, a two-page body with page chrome, and mixed-direction header/footer text. Check extracted text for supplied content and absence of placeholder labels.
- [ ] **Step 2: Add an invalid page-chrome fixture** with an unsupported numbering value and require a `dorost:` diagnostic.
- [ ] **Step 3: Register the fixtures in `scripts/check.sh`** and confirm expected failures before implementation.
- [ ] **Step 4: Implement `cover-page`** as explicit composition of caller-provided slots; omitted slots collapse without reserving space.
- [ ] **Step 5: Implement `page-chrome`** with native Typst page settings and direction-aware alignment. Keep page setup local to the wrapper and avoid mutating package-wide defaults.
- [ ] **Step 6: Export and document both functions**, run `./scripts/check.sh`, then visually inspect the generated English and RTL PDFs for overflow, spacing, and page numbering.
- [ ] **Step 7: Commit** as `feat: add configurable document layouts`.

### Task 4: Add generic forms, tables, and frames

**Files:**
- Create: `src/components/forms.typ`
- Create: `src/components/tables.typ`
- Create: `src/components/frames.typ`
- Create: `tests/fixtures/data-components.typ`
- Create: `tests/fixtures/invalid-data-table.typ`
- Modify: `lib.typ`
- Modify: `scripts/check.sh`

**Interfaces:**
- Consumes: shared tokens from Task 1; native content and caller-provided rows/options.
- Produces: `labeled-field(label, value, label-style: "strong", row-gutter: 0em)`, `choice-group(items, selected: none, columns: 1)`, `data-table(columns, rows, header: true, align: auto)`, `border-frame(body, style: "single", title: none)`, and `section-title(title, rule: true)`.
- Data schemas, labels, choice wording, and table contents remain caller-owned. Validate supported `style` and `columns` values with `dorost:` errors.
- `label-style` accepts `"strong"` or `"muted"`; `items` is an array of content; `selected` is an optional zero-based item index; `columns` in `choice-group` is a positive integer. For `data-table`, `columns` is a positive integer, every row contains exactly that many cells, `header: true` styles the first row, and `align` accepts `"auto"`, `"start"`, `"center"`, or `"end"`. `border-frame.style` accepts `"single"` or `"double"`.

- [ ] **Step 1: Write a fixture** covering a labeled field, selected/unselected choices, a two-column table with a header, a table without a header, and both frame styles in Persian/English. Assert caller text and selected marker text appear in the extracted PDF.
- [ ] **Step 2: Add invalid data/frame option fixtures** for an invalid column count and unsupported frame style; require `dorost:` diagnostics.
- [ ] **Step 3: Register these fixtures** and confirm new invalid cases fail before implementations exist.
- [ ] **Step 4: Implement the five generic components** with explicit inputs and native Typst table/box/stack composition; reject arbitrary proposal/course schemas and implicit YAML input.
- [ ] **Step 5: Export/document the functions** and run `./scripts/check.sh`; inspect the resulting table and choice layout at A4 width in LTR and RTL.
- [ ] **Step 6: Commit** as `feat: add generic form and table components`.

### Task 5: Add isolated slide setup and layout functions

**Files:**
- Create: `src/slides/setup.typ`
- Create: `src/slides/layouts.typ`
- Create: `tests/fixtures/slides.typ`
- Create: `tests/fixtures/invalid-slide-options.typ`
- Modify: `lib.typ`
- Modify: `scripts/check.sh`

**Interfaces:**
- Consumes: shared tokens from Task 1 and generic content helpers from Task 2.
- Produces: `slides(body, ratio: "16:9", show-counter: true, footer: none)` plus `slide-cover(title, subtitle: none, author: none, date: none)`, `slide-section(title, subtitle: none)`, `slide-content(body, title: none)`, `slide-columns(left, right, title: none, ratio: (1fr, 1fr))`, `slide-image(path, fit: "contain", background: none)`, `slide-image-text(path, body, title: none, fit: "contain", image-side: "end")`, and `slide-statement(body, attribution: none)`.
- Supported ratio values: `"16:9"` and `"4:3"`. Supported image fit values: `"contain"` and `"cover"`. Supported image sides: `"start"` and `"end"`.

- [ ] **Step 1: Write a slide fixture** with each layout, both supported ratios, English and Persian text, and `slides(...)` followed by an ordinary document page. Assert slide copy appears and the following page retains document geometry/direction.
- [ ] **Step 2: Add invalid slide option fixtures** for unsupported ratio, fit, and image side; require `dorost:` diagnostics.
- [ ] **Step 3: Register slide fixtures** and confirm invalid inputs fail before slide implementations exist.
- [ ] **Step 4: Implement the slide setup wrapper** with native page settings, optional counter/footer, and validation. Do not alter `document()` defaults or direction/digit APIs.
- [ ] **Step 5: Implement the slide layouts** with caller-provided content and metadata slots; keep image assets external and use Typst image fitting.
- [ ] **Step 6: Export/document the slide API**, run `./scripts/check.sh`, and visually inspect cover, section, columns, image/text, statement, and post-slide document output.
- [ ] **Step 7: Commit** as `feat: add reusable slide layouts`.

### Task 6: Build showcase, README previews, and reproducible rendering

**Files:**
- Create or update: `examples/showcase.typ`
- Create: `scripts/render-showcase.sh`
- Create: `assets/showcase-cover.png`
- Create: `assets/showcase-body.png`
- Create: `assets/showcase-slides.png`
- Modify: `README.md`
- Modify: `scripts/check.sh`
- Reconcile with: open showcase/release work associated with PR #1 before replacing any preview or PDF assets.

**Interfaces:**
- Consumes: public APIs from Tasks 1–5 and the current release/showcase flow.
- Produces: a single editable, generic showcase source; reproducible PDFs and representative first-page PNGs; a README gallery immediately after the introduction.

- [ ] **Step 1: Create the showcase source** with a generic fictional identity, English and Persian sections, mixed-direction identifiers, digit conversion, document cover/chrome, reusable content components, a table, and representative slide layouts.
- [ ] **Step 2: Implement `scripts/render-showcase.sh`** to compile the source using the repo-local package path and the checksum-pinned test fonts fetched by the existing helper under CI; write PDFs and first-page PNGs to a caller-selected output directory.
- [ ] **Step 3: Render locally with the pinned test fonts** and visually inspect cover, body, and slides for clipping, RTL alignment, spacing, and page breaks. Correct source/layout issues before committing screenshots.
- [ ] **Step 4: Commit the three optimized preview PNGs under `assets/`** and verify each is a valid, suitably sized image with a repository-relative README path.
- [ ] **Step 5: Move the README gallery directly under the opening description** with meaningful alt text, then link the editable source and showcase PDFs attached to the GitHub release. Keep generated PDFs out of git and the Typst package.
- [ ] **Step 6: Extend `scripts/check.sh`** to compile the showcase and verify preview files and README references exist; run `./scripts/check.sh` and `git diff --check`.
- [ ] **Step 7: Commit** as `docs: showcase Dorost layouts and slides`.

### Task 7: Prepare the additive 0.2.0 package release

**Files:**
- Modify: `typst.toml`
- Modify: `template/main.typ`
- Modify: `README.md`
- Modify: `CHANGELOG.md`
- Modify: all pinned Dorost imports under `examples/` and `tests/fixtures/`
- Modify: `.github/workflows/` only if the existing release job does not already attach the generated showcase PDFs

**Interfaces:**
- Consumes: merged API and showcase from Tasks 1–6.
- Produces: repository content consistently pinned to `0.2.0`, a dated changelog entry, passing release validation, and a reviewable release-ready commit/PR. Creating a tag, GitHub release, or Typst Universe submission remains a separate maintainer release action.

- [ ] **Step 1: Add an `[Unreleased]` changelog summary** for document components, slide layouts, and README previews.
- [ ] **Step 2: Update `typst.toml` to `0.2.0`** and update all pinned package imports/template references in the same change.
- [ ] **Step 3: Move the completed notes to `## [0.2.0] - YYYY-MM-DD`** using the actual release preparation date and keep `[Unreleased]` empty.
- [ ] **Step 4: Exclude repository-only `/assets/` and `/docs/` from the Typst package in `typst.toml`** while leaving source modules, consumer examples, and the starter available.
- [ ] **Step 5: Run `./scripts/check.sh`, `git diff --check`, and `python3 scripts/release-notes.py v0.2.0`**; confirm imports use the manifest version, release notes validate, and the release workflow attaches showcase PDFs.
- [ ] **Step 6: Review `git diff --stat` and package contents** to confirm no fonts, reference art, preview images, docs, or generated PDFs enter the package; commit as `chore: prepare Dorost 0.2.0`.

## Completion review

- [ ] Read each public export in `lib.typ` against its documentation and fixture.
- [ ] Compile all examples under Typst 0.15.0 and current supported CI version.
- [ ] Visually inspect English, Persian/mixed-direction, page-chrome, and slide output.
- [ ] Verify the README gallery is directly below the introduction and visible in GitHub's renderer.
- [ ] Confirm no course/proposal/university naming, reference assets, font binaries, Rust runtime, or external code dependency was introduced.
- [ ] Confirm package version, changelog, examples, template imports, and release workflow agree on `0.2.0`.
