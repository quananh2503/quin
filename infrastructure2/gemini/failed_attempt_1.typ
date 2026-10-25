#import "@preview/mitex:0.2.7": mitex, mi

#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"

#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")
#set par(justify: true, leading: 0.72em)

#let card(title: none, body) = block(fill: rgb("#f8fafc"), stroke: 1pt + rgb("#cbd5e1"), radius: 6pt, inset: 10pt, width: 100%, [
  #if title != none [ #text(weight: "bold", size: 11.5pt, fill: rgb("#0f766e"))[#title] \ #v(2pt) ]
  #body
])

#align(center)[
  #if IS_TEACHER [
    #text(size: 17pt, weight: "bold", fill: rgb("#1e3a8a"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 17pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU BÀI TẬP HỌC SINH]
  ]
  \ #v(2pt)
  #text(size: 13pt, weight: "bold")[Bài kiểm tra Self-Healing] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Tổng quan]
]
#v(6pt)

// ==================== DẠNG 1: Dạng 1 ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Dạng 1]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Lý thuyết  #mi(`x > 0`) 
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1.*] else [*Bài 1.*] Tính giá trị  #mi(`x + y có thiếu đô la`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`x + y = 10`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
