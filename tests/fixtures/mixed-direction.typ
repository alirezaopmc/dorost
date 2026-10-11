#import "@local/dorost:0.2.0": document, ltr, rtl

#show: document.with(lang: "fa", direction: "rtl")

= متن فارسی و English

متن فارسی با ی فارسی، ک فارسی و نیم‌فاصله: می‌روم.

شناسه #ltr[API.get(2)] و نشانی #ltr[https://example.com/a?b=2] کنار پرانتز (2026) و ریاضی $x = 2$ قرار می‌گیرند.

#rtl[پرانتز (فارسی) و نشانه‌ها: English, فارسی.]

#raw("API.get(2)")
