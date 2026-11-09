#import "@preview/mitex:0.2.7": mitex, mi

#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"

#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))
#set text(font: ("Liberation Sans", "DejaVu Sans", "Noto Sans"), size: 10pt, lang: "vi")
#set par(justify: true, leading: 0.75em)

#let block-box(title: none, stroke-color: rgb("#3b82f6"), fill-color: rgb("#eff6ff"), body) = block(
  fill: fill-color,
  stroke: 1pt + stroke-color,
  radius: 6pt,
  inset: 11pt,
  width: 100%,
  breakable: true,
  [
    #if title != none [
      #text(weight: "bold", size: 11pt, fill: stroke-color.darken(20%))[#title]
      #v(3pt)
      #line(length: 100%, stroke: 0.5pt + stroke-color.lighten(40%))
      #v(4pt)
    ]
    #body
  ]
)

#let tip-box(body) = block(
  fill: rgb("#fffbeb"),
  stroke: (left: 4pt + rgb("#f59e0b")),
  inset: (x: 10pt, y: 7pt),
  radius: (right: 4pt),
  width: 100%,
  [
    #body
  ]
)

#let example-card(title: none, body) = block(
  fill: rgb("#ffffff"),
  stroke: 1pt + rgb("#cbd5e1"),
  radius: 6pt,
  inset: 10pt,
  width: 100%,
  breakable: true,
  [
    #if title != none [
      #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[#title]
      #v(3pt)
      #line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
      #v(4pt)
    ]
    #body
  ]
)

#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T1]: Nhận biết vectơ cùng phương, cùng hướng, ngược hướng] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Nhận biết - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T1|theory|0
  - Hai vectơ được gọi là **cùng phương** nếu giá của chúng song song hoặc trùng nhau.
// @ANCHOR:T1|theory|1
  - Hai vectơ **cùng hướng** nếu chúng cùng phương và có mũi tên chỉ cùng một chiều.
// @ANCHOR:T1|theory|2
  - Hai vectơ **ngược hướng** nếu chúng cùng phương và có mũi tên chỉ ngược chiều nhau.
// @ANCHOR:T1|theory|3
  - Hai vectơ **bằng nhau** nếu chúng cùng hướng và có cùng độ dài.
// @ANCHOR:T1|cloze
  - *Công thức then chốt:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  (khác  #mi(`\vec{0}`) ) được gọi là cùng phương nếu giá của chúng ... hoặc ...
// @ANCHOR:T1|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] MẸO NHÌN HÌNH: Cứ thấy hai đoạn thẳng song song (hoặc nằm trên một đường thẳng) là cùng phương. Nhìn mũi tên: cùng chiều là cùng hướng, ngược chiều là ngược hướng. Đừng vội quan tâm đến độ dài!
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Đếm số vectơ tạo thành từ các đỉnh]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một hình (tứ diện, hình hộp,...) và hỏi có bao nhiêu vectơ khác  #mi(`\vec{0}`)  mà điểm đầu, điểm cuối là các đỉnh.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|0|step|0
  - Bước 1: Xác định số đỉnh của hình. Ví dụ: Tứ diện có 4 đỉnh, hình hộp có 8 đỉnh.
// @ANCHOR:T1|v|0|step|1
  - Bước 2: Mỗi cặp 2 đỉnh tạo ra 2 vectơ (một vectơ từ A đến B và một vectơ từ B đến A). Số cặp đỉnh là tổ hợp chập 2 của số đỉnh:  #mi(`C_n^2 = \frac{n(n-1)}{2}`) .
// @ANCHOR:T1|v|0|step|2
  - Bước 3: Nhân số cặp đỉnh với 2 để ra số vectơ. Công thức chốt: Số vectơ =  #mi(`n(n-1)`) .
// @ANCHOR:T1|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy hình có  #mi(`n`)  đỉnh, số vectơ khác  #mi(`\vec{0}`)  là  #mi(`n(n-1)`) . Tứ diện (4 đỉnh) →  #mi(`4 \times 3 = 12`) . Hình hộp (8 đỉnh) →  #mi(`8 \times 7 = 56`) .
  ]
]
#v(6pt)

// @ANCHOR:T1|v|0|ex_prob
#example-card(title: "Ví dụ minh họa (Câu 1 - SGK)")[
  Cho tứ diện  #mi(`ABCD`) . Hỏi có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  mà mỗi vectơ có điểm đầu, điểm cuối là hai đỉnh của tứ diện  #mi(`ABCD`) ?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|0|ex_sol
    Bước 1: Tứ diện có 4 đỉnh  #mi(`A, B, C, D`) . Bước 2: Số cặp đỉnh là  #mi(`C_4^2 = 6`)  cặp. Bước 3: Mỗi cặp đỉnh tạo ra 2 vectơ (ví dụ cặp  #mi(`A, B`)  tạo ra  #mi(`\vec{AB}`)  và  #mi(`\vec{BA}`) ). Vậy có  #mi(`6 \times 2 = 12`)  vectơ. Chọn A.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Hỏi có bao nhiêu vectơ khác  #mi(`\vec{0}`)  mà điểm đầu, điểm cuối là các đỉnh của hình chóp?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Hình chóp  #mi(`S.ABCD`)  có 5 đỉnh ( #mi(`S, A, B, C, D`) ). Số vectơ là  #mi(`5 \times (5-1) = 5 \times 4 = 20`)  vectơ.]
    #if "20" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 20] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
#v(8pt)

// ==================== BIẾN THỂ 2 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Nhận diện vectơ cùng phương, cùng hướng, ngược hướng, bằng nhau]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một hình không gian (lập phương, hộp chữ nhật, lăng trụ) và yêu cầu tìm vectơ cùng phương, cùng hướng, ngược hướng hoặc bằng với một vectơ cho trước.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|1|step|0
  - Bước 1: Xác định vectơ gốc cần so sánh (ví dụ  #mi(`\vec{AB}`) ).
// @ANCHOR:T1|v|1|step|1
  - Bước 2: Tìm các đoạn thẳng song song hoặc trùng với đoạn thẳng  #mi(`AB`)  trong hình. Đó là các vectơ cùng phương.
// @ANCHOR:T1|v|1|step|2
  - Bước 3: Nhìn mũi tên để phân biệt: Nếu mũi tên cùng chiều với  #mi(`\vec{AB}`)  thì cùng hướng; ngược chiều thì ngược hướng.
// @ANCHOR:T1|v|1|step|3
  - Bước 4: Để tìm vectơ bằng nhau, ta cần cả cùng hướng và cùng độ dài (thường là các cạnh của hình hộp/lập phương bằng nhau).
// @ANCHOR:T1|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] MẸO LOẠI TRỪ: Trong hình lập phương/hộp chữ nhật, các cạnh song song với nhau từng đôi một. Hãy nhìn vào các cạnh của hình, vectơ bằng với  #mi(`\vec{AB}`)  thường là vectơ nối hai đỉnh còn lại của một hình bình hành (ví dụ  #mi(`\vec{DC}, \vec{A'B'}, \vec{D'C'}`) ).
  ]
]
#v(6pt)

// @ANCHOR:T1|v|1|ex_prob
#example-card(title: "Ví dụ minh họa (Câu 15 - SGK)")[
  Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`) . Khi đó, vectơ bằng vectơ  #mi(`\vec{AB}`)  là vectơ nào dưới đây? A.  #mi(`\vec{D'C'}`)  B.  #mi(`\vec{BA}`)  C.  #mi(`\vec{CD}`)  D.  #mi(`\vec{B'A'}`) 

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|1|ex_sol
    Bước 1: Vectơ gốc là  #mi(`\vec{AB}`)  (hướng từ trái sang phải). Bước 2: Các cạnh song song với  #mi(`AB`)  là  #mi(`DC, A'B', D'C'`) . Bước 3: Xét chiều:  #mi(`\vec{DC}`)  cùng chiều với  #mi(`\vec{AB}`)  (vì  #mi(`D`)  tương ứng  #mi(`A`) ,  #mi(`C`)  tương ứng  #mi(`B`) ).  #mi(`\vec{D'C'}`)  cũng cùng chiều. Bước 4: Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp chữ nhật nên  #mi(`AB = DC = D'C'`) . Vậy  #mi(`\vec{AB} = \vec{D'C'}`) . Chọn A.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Vectơ nào sau đây bằng vectơ  #mi(`\vec{BC}`) ? A.  #mi(`\vec{C'B'}`)  B.  #mi(`\vec{AD}`)  C.  #mi(`\vec{A'D'}`)  D.  #mi(`\vec{B'C'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Vectơ  #mi(`\vec{BC}`)  có hướng từ  #mi(`B`)  đến  #mi(`C`) . Trong hình lập phương,  #mi(`AD`)  song song và cùng chiều với  #mi(`BC`) , và  #mi(`AD = BC`) . Vậy  #mi(`\vec{BC} = \vec{AD}`) . Chọn B.]
    #if "B" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: B] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
#v(8pt)

// ==================== BIẾN THỂ 3 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Xác định vectơ chỉ phương của đường thẳng]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một hình lăng trụ hoặc hình hộp và hỏi vectơ nào là vectơ chỉ phương của một đường thẳng cho trước.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|2|step|0
  - Bước 1: Vectơ chỉ phương của đường thẳng  #mi(`d`)  là vectơ có giá song song hoặc trùng với  #mi(`d`) .
// @ANCHOR:T1|v|2|step|1
  - Bước 2: Tìm các đường thẳng trong hình song song hoặc trùng với đường thẳng đã cho.
// @ANCHOR:T1|v|2|step|2
  - Bước 3: Chọn vectơ nối hai điểm trên đường thẳng đó hoặc trên đường thẳng song song với nó (có thể là vectơ ngược chiều vẫn là chỉ phương).
// @ANCHOR:T1|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] MẸO: Vectơ chỉ phương không cần cùng chiều, chỉ cần song song hoặc trùng giá. Hãy quét các đáp án, đáp án nào có giá song song với đường thẳng đề cho là đúng.
  ]
]
#v(6pt)

// @ANCHOR:T1|v|2|ex_prob
#example-card(title: "Ví dụ minh họa (Câu 10 - SGK)")[
  Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Vectơ nào sau đây là vectơ chỉ phương của đường thẳng  #mi(`AB`) ? A.  #mi(`\vec{A'B'}`)  B.  #mi(`\vec{A'C'}`)  C.  #mi(`\vec{A'C}`)  D.  #mi(`\vec{A'B}`) 

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|2|ex_sol
    Bước 1: Đường thẳng  #mi(`AB`)  có giá là cạnh  #mi(`AB`) . Bước 2: Trong hình lăng trụ,  #mi(`A'B'`)  song song với  #mi(`AB`) . Bước 3: Vectơ  #mi(`\vec{A'B'}`)  có giá trùng với  #mi(`A'B'`) , mà  #mi(`A'B' \parallel AB`) , nên  #mi(`\vec{A'B'}`)  là vectơ chỉ phương của  #mi(`AB`) . Chọn A.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Vectơ nào sau đây là vectơ chỉ phương của đường thẳng  #mi(`AC`) ? A.  #mi(`\vec{A'C'}`)  B.  #mi(`\vec{A'B}`)  C.  #mi(`\vec{B'D'}`)  D.  #mi(`\vec{A'D}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Đường thẳng  #mi(`AC`)  song song với  #mi(`A'C'`)  (vì  #mi(`AA'C'C`)  là hình bình hành). Do đó  #mi(`\vec{A'C'}`)  là vectơ chỉ phương của  #mi(`AC`) . Chọn A.]
    #if "A" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: A] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
#v(8pt)

// ==================== BIẾN THỂ 4 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V4] Xét tính đúng sai của các mệnh đề vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|3|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một hình không gian và liệt kê các mệnh đề về vectơ, yêu cầu xác định đúng/sai.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|3|step|0
  - Bước 1: Đọc kỹ từng mệnh đề, xác định các vectơ được nhắc đến.
// @ANCHOR:T1|v|3|step|1
  - Bước 2: Vẽ hình hoặc tưởng tượng hình để kiểm tra tính cùng phương, cùng hướng, độ dài.
// @ANCHOR:T1|v|3|step|2
  - Bước 3: Với mệnh đề đẳng thức vectơ, kiểm tra cả hướng và độ dài. Nếu một trong hai sai thì mệnh đề sai.
// @ANCHOR:T1|v|3|step|3
  - Bước 4: Kết luận Đúng/Sai cho từng ý.
// @ANCHOR:T1|v|3|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] MẸO: Với hình lập phương, các vectơ bằng nhau thường là các cạnh tương ứng của các hình bình hành. Hãy nhớ các cặp vectơ bằng nhau:  #mi(`\vec{AB} = \vec{DC} = \vec{A'B'} = \vec{D'C'}`) , v.v.
  ]
]
#v(6pt)

// @ANCHOR:T1|v|3|ex_prob
#example-card(title: "Ví dụ minh họa (Câu 3 - Phần D)")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Các mệnh đề sau đúng hay sai? a)  #mi(`\vec{DC'} = \vec{DC} + \vec{DD'}`)  b)  #mi(`|\vec{AB}| = |\vec{C'D'}|`)  c)  #mi(`\vec{A'B'} = \vec{CD}`)  d)  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) 

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|3|ex_sol
    a) Theo quy tắc hình hộp,  #mi(`\vec{DC'} = \vec{DC} + \vec{DD'}`)  (vì  #mi(`DC'`)  là đường chéo hình bình hành  #mi(`DCC'D'`) ). Đúng. b)  #mi(`|\vec{AB}| = AB`) ,  #mi(`|\vec{C'D'}| = C'D'`) . Vì  #mi(`AB = C'D'`)  (cạnh hình lập phương) nên đúng. c)  #mi(`\vec{A'B'}`)  và  #mi(`\vec{CD}`)  là hai vectơ ngược hướng (vì  #mi(`A'B' \parallel CD`)  nhưng ngược chiều). Sai. d) Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Đúng.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V4 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|3|drill|0|prompt
*Bài Bài 4.1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Các mệnh đề sau đúng hay sai? a)  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  b)  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  c)  #mi(`\vec{AB} = \vec{C'D'}`)  d)  #mi(`\vec{AB} + \vec{BC} + \vec{CC'} = \vec{AC'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|3|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[a) Theo quy tắc hình bình hành  #mi(`ABCD`) ,  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Đúng. b) Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Đúng. c)  #mi(`\vec{AB}`)  và  #mi(`\vec{C'D'}`)  là hai vectơ ngược hướng (vì  #mi(`AB \parallel C'D'`)  nhưng ngược chiều). Sai. d) Theo quy tắc tam giác,  #mi(`\vec{AB} + \vec{BC} + \vec{CC'} = \vec{AC} + \vec{CC'} = \vec{AC'}`) . Đúng.]
    #if "a) Đúng; b) Đúng; c) Sai; d) Đúng" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: a) Đúng; b) Đúng; c) Sai; d) Đúng] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
#v(8pt)

#text(size: 11pt, weight: "bold", fill: rgb("#b91c1c"))[III. BẢNG ĐÁP ÁN VÀ HƯỚNG DẪN VẮN TẮT]
#v(4pt)

#table(
  columns: (50pt, 1fr, 80pt),
  align: (center + horizon, left + horizon, center + horizon),
  fill: (col, row) => if row == 0 { rgb("#e0f2fe") } else if calc.even(row) { rgb("#f8fafc") } else { none },
  stroke: 0.5pt + rgb("#cbd5e1"),
  table.header(
    [*Bài*], [*Hướng dẫn giải vắn tắt*], [*Đáp án*]
  ),
  [Bài 1.1], [Đếm số đỉnh của hình chóp là 5, áp dụng công thức  #mi(`n(n-1)`) .], [20],
  [Bài 2.1], [Xác định vectơ cùng hướng và cùng độ dài với  #mi(`\vec{BC}`) .], [B],
  [Bài 3.1], [Tìm đường thẳng song song với  #mi(`AC`) , đó là  #mi(`A'C'`) , suy ra vectơ chỉ phương.], [A],
  [Bài 4.1], [Kiểm tra từng mệnh đề dựa vào quy tắc hình bình hành, hình hộp và tính chất vectơ.], [a) Đúng; b) Đúng; c) Sai; d) Đúng],
)
