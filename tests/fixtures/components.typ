#import "@local/dorost:0.2.0": document, code-inline, math-inline, badge, note, quote-frame, prompt-example, checklist, resource-link, resource-links

// A standalone first page catches native raw's fallback font overriding code-inline.
#code-inline("Standalone code font")
#pagebreak()

#show: document.with()
= Reusable components

Inline code: #code-inline("API.get(2)") and inline math: #math-inline[$x + 2$].

#badge[Accent badge]
#badge(tone: "neutral")[Neutral badge]
#badge(tone: "muted")[Muted badge]

#note[Default note body]
#note(title: [Note title], tone: "accent")[Titled note body]
#note(tone: "muted")[Muted note body]

#quote-frame[Default quotation]
#quote-frame(attribution: [Quoted author])[Attributed quotation]
#prompt-example([Prompt label])[Prompt body]
#checklist(([First checklist item], [Second checklist item]))
#checklist(())

#resource-link("https://example.com/one", [Single resource])
#resource-link("https://example.com/two", [Detailed resource], detail: [Resource detail])
#resource-links(
  resource-link("https://example.com/three", [Grouped resource one]),
  resource-link("https://example.com/four", [Grouped resource two], detail: [Grouped detail]),
)
#resource-links()

#pagebreak()
#show: document.with(lang: "fa", direction: "rtl")
= فارسی

متن فارسی #code-inline("API.get(2)") ادامه فارسی.

#math-inline[
  #context assert(text.dir == ltr, message: "math body must use LTR")
  $x + 2$
]
#context {
  assert(text.dir == rtl, message: "inline helpers must preserve surrounding RTL")
  assert(text.font == ("lora", "vazirmatn"), message: "inline helpers must preserve surrounding body font")
}

#badge[نشان فارسی]
#note(title: [عنوان فارسی])[یادداشت فارسی]
#quote-frame(attribution: [نویسنده])[گفتار فارسی]
#prompt-example([پرسش فارسی])[پاسخ فارسی]
#checklist(([گزینه فارسی], [گزینه دوم]))
#resource-links(resource-link("https://example.com/fa", [پیوند فارسی], detail: [توضیح فارسی]))
