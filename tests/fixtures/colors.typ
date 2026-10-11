#import "@local/dorost:0.1.1": document

#show: document.with(colors: (
  text: rgb("102030"),
  muted: rgb("405060"),
  accent: rgb("708090"),
  rule: rgb("A0B0C0"),
))

= Accent heading

#link("https://example.com")[Accent link]

A note.#footnote[Muted footnote]

#line(length: 100%)
