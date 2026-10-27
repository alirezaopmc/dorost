#import "@local/dorost:0.2.1": document, ltr, persian-digits

#show: document.with(lang: "fa", direction: "rtl")
#set footnote(numbering: "۱")

= تبدیل رقم‌های صریح

تاریخ تبدیل‌شده: #ltr[#persian-digits("2026-10-11")]

عدد صحیح: #ltr[#persian-digits(2026)]

رشتهٔ خالی: #persian-digits("")

شماره‌گذاری چندسطحی بومی Typst: #ltr[#numbering("۱.۱", 1, 2, 3)]

این متن یک پانوشت دارد#footnote[متن پانوشت فارسی.] و این هم پانوشت دوم#footnote[پانوشت دوم فارسی.]

این متن و شناسه API.get(2) و تاریخ #ltr[2026-10-11] بدون درخواست صریح تغییر نمی‌کنند.
