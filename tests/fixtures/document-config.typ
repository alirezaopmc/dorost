#import "@local/dorost:0.2.0": document

#show: document.with()
= English defaults

English LTR defaults remain explicit.

#pagebreak()
#show: document.with(lang: "en", direction: "rtl")
= English RTL

Language and direction are independent.

#pagebreak()
#show: document.with(lang: "fa", direction: "ltr", page: (paper: "a5", margin: (x: 18mm, y: 16mm)), fonts: (body: "Vazirmatn", code: "JetBrains Mono"), text: (size: 12pt, paragraph-spacing: 0.8em), colors: (text: rgb("123456")))
= فارسی و English

Custom settings compile while omitted roles preserve their defaults.


#pagebreak()
#show: document.with(lang: "fa", direction: "rtl", fonts: (body: "Vazirmatn"))
= Partial font override

The omitted code role keeps its default font.

#raw("API.get(2)")
