#import "@preview/dorost:0.1.1": document, ltr, rtl, persian-digits

#let ink = rgb("202124")
#let accent = rgb("235789")
#let muted = rgb("62666d")
#let tint = rgb("edf4fa")

#show: document.with(
  lang: "en",
  direction: "ltr",
  page: (margin: (x: 20mm, y: 17mm)),
  fonts: (body: ("Lora", "Vazirmatn"), code: "JetBrains Mono"),
  text: (size: 10pt, paragraph-spacing: 0.7em),
  colors: (text: ink, muted: muted, accent: accent),
)

#align(right)[
  #text(size: 8pt, weight: "bold", fill: accent)[DOROST  /  TYPOGRAPHY FOUNDATION]
]

#v(5pt)
#text(size: 25pt, weight: "bold", fill: ink)[One foundation.]
#line(length: 100%, stroke: 1.5pt + accent)

#grid(
  columns: (1fr, 1fr),
  gutter: 20pt,
  align: (left + top, right + top),
  [
    #v(5pt)
    #text(size: 18pt, weight: "bold", fill: accent)[Many voices.]

    A small, use-case-neutral core for documents that move between English, Persian, and both at once.
  ],
  [
    #v(5pt)
    #rtl[
      #text(size: 15pt, weight: "bold", fill: ink)[یک پایه، چند زبان]

      فارسی و English در کنار هم، با انتخاب نویسنده.
    ]
  ],
)

#v(8pt)
#block(
  fill: tint,
  inset: 10pt,
  radius: 3pt,
)[
  #text(size: 8pt, weight: "bold", fill: accent)[THE IDEA]
  #h(8pt)
  Page and typography defaults are shared; the author chooses the document's structure, language, direction, and identity.
]

#v(10pt)
#grid(
  columns: (1fr, 1fr),
  gutter: 22pt,
  align: (left + top, left + top),
  [
    #text(size: 11pt, weight: "bold", fill: accent)[Compose with native Typst]
    #v(4pt)

    Dorost leaves familiar building blocks in your hands:
    - headings and paragraphs
    - lists and tables
    - links, code, and math

    #table(
      columns: (1fr, 1fr),
      inset: 5pt,
      stroke: 0.5pt + rgb("d8dce2"),
      [*Role*], [*Choice*],
      [Body], [Lora + Vazirmatn],
      [Code], [JetBrains Mono],
      [Structure], [Your own],
    )

    #v(5pt)
    A link stays a link: #link("https://typst.app")[typst.app].
  ],
  [
    #text(size: 11pt, weight: "bold", fill: accent)[Keep language controls separate]
    #v(4pt)

    #rtl[
      فارسی را راست‌چین بنویسید و بخش‌های لاتین را محلی چپ‌چین کنید: #ltr[`API.get(2)`].
    ]

    #v(5pt)
    Persian digits are opt-in: #ltr[#persian-digits("2026-10-11")] (or #ltr[#persian-digits(42)]). ASCII digits remain available: #ltr[2026-10-11].

    #v(5pt)
    #raw(
      "#show: document.with(lang: \"fa\", direction: \"rtl\")\n#rtl[شناسه: #ltr[API.get(2)]]",
      block: true,
      lang: "typ",
    )

    #v(3pt)
    #align(center)[$f(x) = x^2 + 1$]
  ],
)

#v(6pt)
#line(length: 100%, stroke: 0.5pt + rgb("d8dce2"))
#grid(
  columns: (1fr, 1fr),
  [#text(size: 8pt, fill: muted)[MIT-licensed · Pure Typst · No bundled fonts]],
  [#align(right)[#text(size: 8pt, fill: muted)[#raw("@preview/dorost:0.1.1")]]],
)
