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
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T1]: Khái niệm vectơ trong không gian] \
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
  - Vectơ trong không gian là đoạn thẳng có hướng  #mi(`\vec{AB}`)  với điểm đầu và cuối.
// @ANCHOR:T1|theory|1
  - Độ dài của vectơ  #mi(`\vec{AB}`)  là khoảng cách giữa điểm đầu và điểm cuối, kí hiệu  #mi(`|\vec{AB}| = AB`) .
// @ANCHOR:T1|theory|2
  - Hai vectơ được gọi là bằng nhau nếu chúng cùng hướng và cùng độ dài. Vectơ đối của  #mi(`\vec{a}`)  là  #mi(`-\vec{a}`) , có cùng độ dài nhưng ngược hướng.
// @ANCHOR:T1|cloze
  - *Công thức then chốt:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng ... và ... .
// @ANCHOR:T1|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Cùng hướng + Cùng độ dài = BẰNG NHAU. Ngược hướng + Cùng độ dài = ĐỐI NHAU.
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Nhận biết vectơ qua hình vẽ thực tế]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình ảnh thực tế (dây cáp, lực kéo, thang máy...) và hỏi về hướng, độ lớn của các đoạn thẳng có mũi tên.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|0|step|0
  - Bước #1: Chuẩn hoá các vectơ lạ  #mi(`\vec{u}`)  và  #mi(`\vec{BC}`)  về dạng cơ sở.
// @ANCHOR:T1|v|0|step|1
  - Bước 2: Nhìn vào hướng mũi tên để xác định hướng của vectơ (ví dụ: hướng lên trên, hướng xuống dưới).
// @ANCHOR:T1|v|0|step|2
  - Bước 3: Độ dài đoạn thẳng (tỉ lệ với độ lớn thực tế) chính là độ lớn của vectơ. Nếu các đoạn thẳng không cùng nằm trên một mặt phẳng (tạo thành hình khối 3D) thì các vectơ đó không đồng phẳng.
// @ANCHOR:T1|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo phản xạ: Nếu gặp hình hộp  #mi(`ABCD.A'B'C'`)  thì áp dụng quy tắc đường chéo.
  ]
]
#v(6pt)

// @ANCHOR:T1|v|0|ex_prob
#example-card(title: "Ví dụ 1: Nhận biết qua hình vẽ thực tế (Trích HĐ1 trang 46 - SGK)")[
  Trong Hình 2.2, lực căng dây (được tạo ra bởi sức nặng của kiện hàng) được thể hiện bởi các đoạn thẳng có mũi tên màu đỏ. a) Các đoạn thẳng này cho biết gì về hướng và độ lớn của các lực căng dây? b) Các đoạn thẳng này có cùng nằm trong một mặt phẳng không?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|0|ex_sol
    Bước 1: Xác định gốc và ngọn: Các đoạn thẳng có mũi tên xuất phát từ móc cẩu hướng xuống kiện hàng. Bước 2: Hướng của vectơ là hướng mũi tên chỉ (hướng lên trên về phía móc cẩu). Bước 3: Độ dài đoạn thẳng thể hiện độ lớn của lực căng dây. Các đoạn thẳng này tạo thành một hình chóp cụt, không cùng nằm trong một mặt phẳng.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|0|drill|0|prompt
*Bài Bài 1.1.* Một chiếc thang máy di chuyển từ tầng 1 lên tầng 5 của tòa nhà, sau đó di chuyển từ tầng 5 lên tầng 9. Gọi  #mi(`\vec{a}`)  là vectơ biểu diễn độ dịch chuyển của thang máy trong lần di chuyển thứ nhất,  #mi(`\vec{b}`)  là vectơ biểu diễn độ dịch chuyển trong lần thứ hai. Hỏi hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có bằng nhau không? Giải thích vì sao?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Xác định hướng: Cả hai lần di chuyển đều từ tầng thấp lên tầng cao nên hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng hướng. Bước 2: Xác định độ dài: Lần 1 đi 4 tầng, lần 2 đi 4 tầng nên độ dài hai vectơ bằng nhau. Bước 3: Kết luận: Hai vectơ cùng hướng và cùng độ dài nên  #mi(`\vec{a} = \vec{b}`) .]
    #if "Bằng nhau" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Bằng nhau] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Đếm số vectơ tạo thành từ các đỉnh của hình không gian]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình không gian (tứ diện, hình hộp, hình chóp...) và hỏi 'Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu và điểm cuối là các đỉnh của hình đó?'

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|1|step|0
  - Bước 1: Đếm tổng số đỉnh của hình không gian (ví dụ: tứ diện có 4 đỉnh, hình hộp có 8 đỉnh).
// @ANCHOR:T1|v|1|step|1
  - Bước 2: Sử dụng quy tắc nhân: Số vectơ khác  #mi(`\vec{0}`)  bằng số cách chọn điểm đầu nhân với số cách chọn điểm cuối (khác điểm đầu). Công thức:  #mi(`n \times (n - 1)`)  với  #mi(`n`)  là số đỉnh.
// @ANCHOR:T1|v|1|step|2
  - Bước 3: Bấm máy tính Casio để tính kết quả nhanh và khoanh đáp án.
// @ANCHOR:T1|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Số vectơ = Số đỉnh  #mi(`\times`)  (Số đỉnh - 1). Tứ diện 4 đỉnh  #mi(`\rightarrow 4 \times 3 = 12`) .
  ]
]
#v(6pt)

// @ANCHOR:T1|v|1|ex_prob
#example-card(title: "Ví dụ 2: Đếm số vectơ (Trích Ví dụ 1 trang 46 - SGK)")[
  Cho tứ diện  #mi(`ABCD`)  có độ dài mỗi cạnh bằng 1. a) Có bao nhiêu vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|1|ex_sol
    Bước 1: Tứ diện có 4 đỉnh là  #mi(`A, B, C, D`) . Bước 2: Điểm đầu cố định là  #mi(`A`) , điểm cuối là một trong 3 đỉnh còn lại  #mi(`B, C, D`) . Bước 3: Các vectơ tìm được là  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) . Vậy có 3 vectơ.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho tứ diện  #mi(`ABCD`) . Hỏi có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  mà mỗi vectơ có điểm đầu, điểm cuối là hai đỉnh của tứ diện  #mi(`ABCD`) ?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Tứ diện có 4 đỉnh. Bước 2: Số vectơ khác  #mi(`\vec{0}`)  là  #mi(`4 \times (4 - 1) = 12`) . Bước 3: Kết luận có 12 vectơ.]
    #if "12" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 12] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Xác định vectơ bằng nhau, vectơ đối]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình không gian (hình hộp, lăng trụ, chóp) và yêu cầu tìm vectơ bằng vectơ cho trước hoặc so sánh độ dài, phương, hướng của hai vectơ.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|2|step|0
  - Bước 1: Xác định rõ điểm đầu và điểm cuối của vectơ đã cho.
// @ANCHOR:T1|v|2|step|1
  - Bước 2: Tìm một đoạn thẳng khác trong hình có cùng phương (song song) và cùng chiều dài. Mẹo: Trong hình hộp/lăng trụ, các cạnh bên song song và bằng nhau tạo ra các vectơ bằng nhau.
// @ANCHOR:T1|v|2|step|2
  - Bước 3: Kiểm tra hướng mũi tên. Nếu cùng hướng thì kết luận bằng nhau, nếu ngược hướng thì kết luận là vectơ đối.
// @ANCHOR:T1|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Hình hộp/lăng trụ: Các cạnh bên song song và bằng nhau  #mi(`\rightarrow`)  vectơ bằng nhau. Cẩn thận bẫy ngược hướng (ví dụ  #mi(`\vec{AB}`)  và  #mi(`\vec{BA}`) ).
  ]
]
#v(6pt)

// @ANCHOR:T1|v|2|ex_prob
#example-card(title: "Ví dụ 3: Xác định vectơ bằng nhau (Trích HĐ2 trang 47 - SGK)")[
  Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . a) So sánh độ dài hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{D'C'}`) . b) Nhận xét về giá của hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{D'C'}`) . c) Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{D'C'}`)  có cùng phương không? Có cùng hướng không?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|2|ex_sol
    Bước 1: Xác định điểm đầu, điểm cuối:  #mi(`\vec{AB}`)  (gốc  #mi(`A`) , ngọn  #mi(`B`) ),  #mi(`\vec{D'C'}`)  (gốc  #mi(`D'`) , ngọn  #mi(`C'`) ). Bước 2: Vì  #mi(`ABCD`)  và  #mi(`DCC'D'`)  là hình bình hành nên  #mi(`AB = DC = D'C'`) . Do đó  #mi(`|\vec{AB}| = |\vec{D'C'}|`) . Bước 3: Giá của hai vectơ song song với nhau. Hai vectơ cùng phương và cùng hướng (mũi tên đều chỉ sang phải).
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`) . Khi đó, vectơ bằng vectơ  #mi(`\vec{AB}`)  là vectơ nào dưới đây? A.  #mi(`\vec{D'C'}`)  B.  #mi(`\vec{BA}`)  C.  #mi(`\vec{CD}`)  D.  #mi(`\vec{B'A'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Vectơ  #mi(`\vec{AB}`)  có hướng từ trái sang phải. Bước 2: Trong hình hộp chữ nhật, cạnh  #mi(`D'C'`)  song song và bằng cạnh  #mi(`AB`) , hướng từ trái sang phải. Bước 3: Vậy  #mi(`\vec{AB} = \vec{D'C'}`) . Chọn A.]
    #if "A" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: A] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T1|v|2|drill|1|prompt
*Bài Bài 3.2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Các mệnh đề sau đúng hay sai? a)  #mi(`\vec{DC'} = \vec{DC} + \vec{DD'}`) . b)  #mi(`|\vec{AB}| = |\vec{C'D'}|`) . c)  #mi(`\vec{A'B'} = \vec{CD}`) . d)  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Kiểm tra a) Theo quy tắc hình hộp,  #mi(`\vec{DC'} = \vec{DC} + \vec{DD'}`)  là Đúng. Bước 2: Kiểm tra b)  #mi(`|\vec{AB}|`)  và  #mi(`|\vec{C'D'}|`)  đều là cạnh hình lập phương nên bằng nhau  #mi(`\rightarrow`)  Đúng. Bước 3: Kiểm tra c)  #mi(`\vec{A'B'}`)  và  #mi(`\vec{CD}`)  ngược hướng nhau nên Sai. Bước 4: Kiểm tra d) Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  là Đúng.]
    #if "a) Đ, b) Đ, c) S, d) Đ" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: a) Đ, b) Đ, c) S, d) Đ] ]
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
  [Bài 1.1], [Cùng hướng (đều đi lên), cùng độ dài (đều 4 tầng) nên bằng nhau.], [Bằng nhau],
  [Bài 2.1], [Số vectơ =  #mi(`4 \times 3 = 12`) .], [12],
  [Bài 3.1], [Hình hộp chữ nhật có  #mi(`\vec{AB} = \vec{D'C'}`) .], [A],
  [Bài 3.2], [Áp dụng quy tắc hình hộp và tính chất hình lập phương.], [a) Đ, b) Đ, c) S, d) Đ],
)
