#import "@local/dorost:0.2.0": document

#show: document.with()

= Default document

Default document remains available.

#pagebreak()
#show: document.with(
  lang: "fa",
  direction: "rtl",
  fonts: (body: "Vazirmatn"),
  colors: (accent: rgb("345678")),
)

= فارسی

متن فارسی پیش از کد.

#raw("API.get(2)", block: true)
