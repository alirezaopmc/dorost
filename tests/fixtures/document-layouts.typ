#import "@local/dorost:0.2.1": document, cover-page, page-chrome, ltr, rtl, badge, note
#show: document.with()

#cover-page(
  [English cover], subtitle: [Caller subtitle], author: [Ada Example],
  date: [2026-10-11], logo: badge[Caller logo], details: note[Caller details],
)
#pagebreak()
#document(lang: "fa", direction: "rtl")[
  #cover-page([جلد فارسی], subtitle: [زیرعنوان فارسی])
]
#page-chrome(header: [English header #rtl[فارسی]], footer: [Caller footer #rtl[فارسی]])[
  First chrome body.
  #pagebreak()
  Second chrome body.
]
Outside wrapper body.
#document(lang: "fa", direction: "rtl")[
  #page-chrome(numbering: false, rule: false, header: [سرصفحه #ltr[RTL header]], footer: [پاصفحه #ltr[RTL footer]])[
    متن فارسی بدون شماره
  ]
  #page-chrome[#ltr[Default chrome body.]]
]
