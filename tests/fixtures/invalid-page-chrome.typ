#import "@local/dorost:0.2.1": page-chrome
#let option = sys.inputs.at("option", default: "numbering")
#if option == "numbering" {
  page-chrome(numbering: "1")[Invalid numbering]
} else {
  page-chrome(rule: "yes")[Invalid rule]
}
