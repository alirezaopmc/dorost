#import "@local/dorost:0.1.1": document, ltr, persian-digits

#show: document.with(lang: "fa", direction: "rtl")

= تبدیل رقم‌های صریح

تاریخ تبدیل‌شده: #ltr[#persian-digits("2026-10-11")]

عدد صحیح: #ltr[#persian-digits(2026)]

رشتهٔ خالی: #persian-digits("")

این متن و شناسه API.get(2) و تاریخ #ltr[2026-10-11] بدون درخواست صریح تغییر نمی‌کنند.
