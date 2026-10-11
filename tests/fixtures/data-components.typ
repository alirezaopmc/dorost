#import "@local/dorost:0.2.0": document, labeled-field, choice-group, data-table, border-frame, section-title

#show: document.with(lang: "en", direction: "ltr")
#section-title[English data components]
#labeled-field([Caller label], [Caller value])
#labeled-field([Muted label], [Muted value], label-style: "muted", row-gutter: 0.4em)
#choice-group(([First choice], [Selected choice], [Last choice]), selected: 1, columns: 2)
#choice-group(([Unselected choice],))
#choice-group(())
#data-table(2, (([Header one], [Header two]), ([Cell one], [Cell two])))
#data-table(2, (([Plain one], [Plain two]),), header: false, align: "center")
#data-table(1, (([Start aligned],),), align: "start")
#data-table(1, (([End aligned],),), align: "end")
#data-table(1, (([Auto aligned],),), align: "auto")
#data-table(2, ())
#border-frame(title: [Single title])[Single frame body]
#border-frame(style: "double", title: [Double title])[Double frame body]
#section-title(rule: false)[No rule title]
#border-frame[Untitled frame]

#pagebreak()
#show: document.with(lang: "fa", direction: "rtl")
#section-title[فارسی]
#labeled-field([نام فارسی], [مقدار فارسی])
#choice-group(([گزینه فارسی], [گزینه دوم]), selected: 0, columns: 2)
#data-table(2, (([عنوان فارسی], [ستون دوم]), ([متن فارسی], [داده دوم])))
#data-table(2, (([بدون عنوان], [ردیف فارسی]),), header: false, align: "start")
#border-frame(title: [عنوان فارسی])[قاب فارسی]
#border-frame(style: "double")[قاب دوم فارسی]
#section-title(rule: false)[عنوان دوم فارسی]
#context assert(text.dir == rtl, message: "data components must preserve RTL direction")
