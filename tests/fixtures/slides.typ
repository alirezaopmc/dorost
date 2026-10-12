#import "@local/dorost:0.2.1": document, slides, slide-cover, slide-section, slide-content, slide-columns, slide-image, slide-image-text, slide-statement, rtl, ltr, badge
#show: document.with(lang: "en", direction: "ltr")

#slides(footer: [Caller slide footer])[
  #context { assert(page.width == 320mm); assert(page.height == 180mm); assert(text.dir == std.ltr) }
  #slide-cover([Slide cover], subtitle: [Caller subtitle], author: [Ada Example], date: [2026-10-11])
  #slide-section([Slide section], subtitle: [Section subtitle])
  #slide-content(title: [Slide content])[
    English body with #rtl[فارسی] and #badge[Composed badge].
  ]
  #slide-columns([Start column], [End column], title: [Slide columns], ratio: (2fr, 1fr))
  #slide-image(path("slide-image.svg"), fit: "cover", background: rgb("e0e8f0"))
  #slide-image-text(path("slide-image.svg"), [Image text body], title: [Slide image text])
  #slide-statement([Caller statement], attribution: [Caller attribution])
]
#context { assert(page.width == 210mm); assert(page.height == 297mm); assert(text.dir == std.ltr) }
Ordinary document after slides.

#document(lang: "fa", direction: "rtl")[
  #slides(ratio: "4:3", show-counter: false)[
    #context { assert(page.width == 320mm); assert(page.height == 240mm); assert(text.dir == std.rtl) }
    #slide-cover([جلد فارسی])
    #slide-section([بخش فارسی])
    #slide-content[#ltr[Untitled content] متن فارسی]
    #slide-columns([ستون آغاز], [ستون پایان])
    #slide-image(path("slide-image.svg"))
    #slide-image-text(path("slide-image.svg"), [متن تصویر], image-side: "start", fit: "cover")
    #slide-statement[#ltr[Unattributed statement] فارسی]
  ]
  #context { assert(page.width == 210mm); assert(page.height == 297mm); assert(text.dir == std.rtl) }
  #ltr[Persian document after slides.] متن فارسی
]
