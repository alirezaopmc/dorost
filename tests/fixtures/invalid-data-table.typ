#import "@local/dorost:0.2.0": data-table, border-frame, choice-group, labeled-field, section-title

#let option = sys.inputs.at("option", default: "columns-zero")
#if option == "columns-zero" {
  data-table(0, ())
} else if option == "columns-fraction" {
  data-table(1.5, ())
} else if option == "columns-type" {
  data-table("2", ())
} else if option == "rows-type" {
  data-table(2, (a: [Cell]))
} else if option == "row-type" {
  data-table(2, ([Not an array],))
} else if option == "row-width" {
  data-table(2, (([Only cell],),))
} else if option == "align" {
  data-table(1, (([Cell],),), align: "left")
} else if option == "header" {
  data-table(1, (([Cell],),), header: "yes")
} else if option == "frame-style" {
  border-frame(style: "dotted")[Invalid frame]
} else if option == "choice-columns-zero" {
  choice-group(([Choice],), columns: 0)
} else if option == "choice-columns-fraction" {
  choice-group(([Choice],), columns: 1.5)
} else if option == "choice-items" {
  choice-group([Not an array])
} else if option == "choice-content" {
  choice-group((1,))
} else if option == "selected-negative" {
  choice-group(([Choice],), selected: -1)
} else if option == "selected-outside" {
  choice-group(([Choice],), selected: 1)
} else if option == "selected-type" {
  choice-group(([Choice],), selected: "0")
} else if option == "selected-empty" {
  choice-group((), selected: 0)
} else if option == "label-style" {
  labeled-field([Label], [Value], label-style: "italic")
} else if option == "section-rule" {
  section-title([Title], rule: "yes")
} else {
  panic("fixture: unknown test option")
}
