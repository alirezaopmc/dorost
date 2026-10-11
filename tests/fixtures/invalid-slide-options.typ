#import "@local/dorost:0.2.0": slides, slide-image, slide-image-text
#let option = sys.inputs.at("option", default: "ratio")
#if option == "ratio" { slides(ratio: "1:1")[Invalid] }
#if option == "counter" { slides(show-counter: "yes")[Invalid] }
#if option == "fit" { slide-image(path("slide-image.svg"), fit: "stretch") }
#if option == "text-fit" { slide-image-text(path("slide-image.svg"), [Invalid], fit: "stretch") }
#if option == "side" { slide-image-text(path("slide-image.svg"), [Invalid], image-side: "left") }
