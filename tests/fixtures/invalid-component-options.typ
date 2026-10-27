#import "@local/dorost:0.2.1": badge, note

#let component = sys.inputs.at("component", default: "badge")
#if component == "badge" {
  badge(tone: "unsupported")[Invalid badge tone]
} else {
  note(tone: "unsupported")[Invalid note tone]
}
