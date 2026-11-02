#import "@local/dorost:0.2.1": default-colors, default-fonts, default-page, default-text, document, ltr, persian-digits, rtl

#assert(persian-digits("2026-10-11") == "۲۰۲۶-۱۰-۱۱")
#assert(persian-digits(42) == "۴۲")
#assert(persian-digits("") == "")
#assert(persian-digits("API.get(2)") == "API.get(۲)")

#assert(default-page.paper == "a4")
#assert(default-page.margin == (x: 2cm, y: 2cm))
#assert(default-fonts.code == "JetBrains Mono")
#assert(default-text.size == 11pt)
#assert(default-colors.accent == rgb("235789"))

#assert(type(ltr[LTR]) == content)
#assert(type(rtl[RTL]) == content)
#assert(type(document) == function)
#assert(type(document.with(lang: "en")) == function)

Function assertions passed.
