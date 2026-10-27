#import "../config.typ": default-fonts, default-colors

// Shared by the tone-bearing inline and block helpers.
#let tone-color(tone) = {
  if tone == "neutral" { default-colors.text }
  else if tone == "accent" { default-colors.accent }
  else if tone == "muted" { default-colors.muted }
  else { panic("dorost: tone must be \"neutral\", \"accent\", or \"muted\"") }
}

#let code-inline(value, font: default-fonts.code, size: none) = box({
  set text(dir: ltr, lang: "en", font: font, ligatures: false, features: (calt: 0, liga: 0))
  show raw: set text(dir: ltr, lang: "en", font: font, ligatures: false, features: (calt: 0, liga: 0))
  if size != none { set text(size: size) }
  raw(value, block: false)
})

#let math-inline(body) = box({
  set text(dir: ltr)
  body
})

#let badge(body, tone: "accent") = {
  let color = tone-color(tone)
  box(inset: (x: 0.45em, y: 0.15em), radius: 0.25em, stroke: 0.5pt + color)[
    #text(fill: color, size: 0.85em, body)
  ]
}
