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
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T05]: Hệ tọa độ Oxyz: xác định tọa độ điểm và vectơ] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Nhận biết - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T05|theory|0
  - Trong không gian  #mi(`Oxyz`) , mỗi điểm  #mi(`M`)  được xác định bởi bộ ba số  #mi(`(x; y; z)`)  gọi là tọa độ của điểm  #mi(`M`) , kí hiệu  #mi(`M(x; y; z)`) .
// @ANCHOR:T05|theory|1
  - Vectơ  #mi(`\vec{a}`)  có tọa độ  #mi(`(x; y; z)`)  khi và chỉ khi  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`) .
// @ANCHOR:T05|theory|2
  - Cho hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`)  (Lấy tọa độ điểm cuối trừ tọa độ điểm đầu).
// @ANCHOR:T05|cloze
  - *Công thức then chốt:* Cho  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  thì  #mi(`\vec{AB} = (`) ... #mi(`;`) ... #mi(`;`) ... #mi(`)`) 
// @ANCHOR:T05|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Thần chú nhớ nhanh: 'Cuối trừ đầu' (để tính tọa độ vectơ  #mi(`\vec{AB}`) ) và 'Chiếu vuông góc' (để tìm tọa độ điểm trên các trục).
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Tìm tọa độ vectơ khi biết tọa độ hai điểm]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T05|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho tọa độ hai điểm  #mi(`A, B`)  và yêu cầu tìm tọa độ vectơ  #mi(`\vec{AB}`)  (hoặc ngược lại).

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T05|v|0|step|0
  - Bước 1: Xác định tọa độ điểm đầu  #mi(`A(x_A; y_A; z_A)`)  và điểm cuối  #mi(`B(x_B; y_B; z_B)`) .
// @ANCHOR:T05|v|0|step|1
  - Bước 2: Áp dụng quy tắc 'Cuối trừ đầu': Lấy hoành độ của  #mi(`B`)  trừ hoành độ của  #mi(`A`)  được  #mi(`x`) , lấy tung độ của  #mi(`B`)  trừ tung độ của  #mi(`A`)  được  #mi(`y`) , lấy cao độ của  #mi(`B`)  trừ cao độ của  #mi(`A`)  được  #mi(`z`) .
// @ANCHOR:T05|v|0|step|2
  - Bước 3: Viết kết quả  #mi(`\vec{AB} = (x; y; z)`) .
// @ANCHOR:T05|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo Casio: Nhập tọa độ  #mi(`B`)  trừ tọa độ  #mi(`A`)  theo từng hàng (x, y, z) để tránh nhầm dấu.
  ]
]
#v(6pt)

// @ANCHOR:T05|v|0|ex_prob
#example-card(title: "Ví dụ minh họa (Trích Bài 3 SGK trang 40)")[
  Trong không gian  #mi(`Oxyz`) , xác định tọa độ của vectơ  #mi(`\vec{AB}`)  biết  #mi(`A(0;0;0)`)  và  #mi(`B(4;2;-5)`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T05|v|0|ex_sol
    Bước 1: Điểm đầu  #mi(`A(0;0;0)`) , điểm cuối  #mi(`B(4;2;-5)`) .\nBước 2: Áp dụng quy tắc 'Cuối trừ đầu':\nHoành độ:  #mi(`4 - 0 = 4`) .\nTung độ:  #mi(`2 - 0 = 2`) .\nCao độ:  #mi(`-5 - 0 = -5`) .\nBước 3: Vậy  #mi(`\vec{AB} = (4; 2; -5)`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T05|v|0|drill|0|prompt
*Bài Bài 1.1.* Trong không gian  #mi(`Oxyz`) , xác định tọa độ của vectơ  #mi(`\vec{AB}`)  biết  #mi(`A(1;-3;7)`)  và  #mi(`B(1;-3;7)`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T05|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Điểm đầu  #mi(`A(1;-3;7)`) , điểm cuối  #mi(`B(1;-3;7)`) .\nBước 2: Áp dụng quy tắc 'Cuối trừ đầu':\nHoành độ:  #mi(`1 - 1 = 0`) .\nTung độ:  #mi(`-3 - (-3) = 0`) .\nCao độ:  #mi(`7 - 7 = 0`) .\nBước 3: Vậy  #mi(`\vec{AB} = (0; 0; 0)`) .]
    #if "$\vec{AB} = (0; 0; 0)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{AB} = (0; 0; 0)`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T05|v|0|drill|1|prompt
*Bài Bài 1.2.* Trong không gian  #mi(`Oxyz`) , xác định tọa độ của vectơ  #mi(`\vec{MN}`)  biết  #mi(`M(5;4;9)`)  và  #mi(`N(-5;7;2)`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T05|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Điểm đầu  #mi(`M(5;4;9)`) , điểm cuối  #mi(`N(-5;7;2)`) .\nBước 2: Áp dụng quy tắc 'Cuối trừ đầu':\nHoành độ:  #mi(`-5 - 5 = -10`) .\nTung độ:  #mi(`7 - 4 = 3`) .\nCao độ:  #mi(`2 - 9 = -7`) .\nBước 3: Vậy  #mi(`\vec{MN} = (-10; 3; -7)`) .]
    #if "$\vec{MN} = (-10; 3; -7)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{MN} = (-10; 3; -7)`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Tìm tọa độ điểm trên các trục tọa độ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T05|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho điểm nằm trên tia, tia đối hoặc trục tọa độ và cho biết khoảng cách đến gốc  #mi(`O`) .

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T05|v|1|step|0
  - Bước 1: Xác định điểm nằm trên trục nào. Nếu nằm trên trục  #mi(`Ox`)  thì tung độ  #mi(`y=0`) , cao độ  #mi(`z=0`) ; trên trục  #mi(`Oy`)  thì  #mi(`x=0, z=0`) ; trên trục  #mi(`Oz`)  thì  #mi(`x=0, y=0`) .
// @ANCHOR:T05|v|1|step|1
  - Bước 2: Xác định dấu của tọa độ. Nếu nằm trên tia dương (cùng hướng với vectơ đơn vị) thì tọa độ dương; nếu nằm trên tia đối thì tọa độ âm.
// @ANCHOR:T05|v|1|step|2
  - Bước 3: Gán độ dài khoảng cách đã cho vào tọa độ tương ứng và kết luận.
// @ANCHOR:T05|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo nhớ: 'Trục nào giữ trục đó, hai trục còn lại bằng 0'. Tia dương thì dấu  #mi(`+`) , tia đối thì dấu  #mi(`-`) .
  ]
]
#v(6pt)

// @ANCHOR:T05|v|1|ex_prob
#example-card(title: "Ví dụ minh họa (Trích Bài 4 SGK trang 40)")[
  Trong không gian  #mi(`Oxyz`) , xác định tọa độ của điểm  #mi(`A`)  biết  #mi(`A`)  nằm trên tia  #mi(`Ox`)  và  #mi(`OA = 2`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T05|v|1|ex_sol
    Bước 1:  #mi(`A`)  nằm trên trục  #mi(`Ox`)  nên tung độ  #mi(`y = 0`)  và cao độ  #mi(`z = 0`) .\nBước 2:  #mi(`A`)  nằm trên tia  #mi(`Ox`)  (tia dương) nên hoành độ  #mi(`x > 0`) .\nBước 3: Độ dài  #mi(`OA = 2`)  nên  #mi(`x = 2`) . Vậy  #mi(`A(2; 0; 0)`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T05|v|1|drill|0|prompt
*Bài Bài 2.1.* Trong không gian  #mi(`Oxyz`) , xác định tọa độ của điểm  #mi(`A`)  biết  #mi(`A`)  trùng với gốc tọa độ.
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T05|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`A`)  trùng với gốc tọa độ  #mi(`O`) .\nBước 2: Mọi tọa độ đều bằng 0.\nBước 3: Vậy  #mi(`A(0; 0; 0)`) .]
    #if "$A(0; 0; 0)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`A(0; 0; 0)`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T05|v|1|drill|1|prompt
*Bài Bài 2.2.* Trong không gian  #mi(`Oxyz`) , xác định tọa độ của điểm  #mi(`A`)  biết  #mi(`A`)  nằm trên tia đối của tia  #mi(`Oy`)  và  #mi(`OA = 3`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T05|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`A`)  nằm trên trục  #mi(`Oy`)  nên hoành độ  #mi(`x = 0`)  và cao độ  #mi(`z = 0`) .\nBước 2:  #mi(`A`)  nằm trên tia đối của tia  #mi(`Oy`)  (tia âm) nên tung độ  #mi(`y < 0`) .\nBước 3: Độ dài  #mi(`OA = 3`)  nên  #mi(`y = -3`) . Vậy  #mi(`A(0; -3; 0)`) .]
    #if "$A(0; -3; 0)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`A(0; -3; 0)`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Xác định tọa độ các đỉnh của hình hộp chữ nhật]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T05|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình hộp chữ nhật có một đỉnh trùng với gốc  #mi(`O`)  và các cạnh nằm trên các trục tọa độ, yêu cầu tìm tọa độ các đỉnh còn lại.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T05|v|2|step|0
  - Bước 1: Vẽ hình hộp chữ nhật, xác định đỉnh nào trùng gốc  #mi(`O`) , các cạnh nào nằm trên trục  #mi(`Ox, Oy, Oz`) .
// @ANCHOR:T05|v|2|step|1
  - Bước 2: Đọc tọa độ các đỉnh đã cho, xác định độ dài các cạnh tương ứng (chính là tọa độ của các đỉnh trên trục).
// @ANCHOR:T05|v|2|step|2
  - Bước 3: Sử dụng quy tắc hình hộp: Nếu  #mi(`OABC.O'A'B'C'`)  là hình hộp thì  #mi(`\vec{OC} = \vec{OA} + \vec{OB} + \vec{OO'}`)  (hoặc dùng tính chất hình bình hành) để suy ra tọa độ các đỉnh còn lại.
// @ANCHOR:T05|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo: Tọa độ điểm  #mi(`C`)  đối diện với gốc  #mi(`O`)  trong hình hộp chữ nhật bằng tổng tọa độ các đỉnh kề với  #mi(`O`) .
  ]
]
#v(6pt)

// @ANCHOR:T05|v|2|ex_prob
#example-card(title: "Ví dụ minh họa (Trích Bài 5 SGK trang 41)")[
  Trong không gian  #mi(`Oxyz`) , cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có đỉnh  #mi(`A`)  trùng với gốc  #mi(`O`)  và các đỉnh  #mi(`D, B, A'`)  có tọa độ lần lượt là  #mi(`(2;0;0), (0;4;0), (0;0;3)`) . Xác định tọa độ của các đỉnh còn lại của hình hộp chữ nhật.

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T05|v|2|ex_sol
    Bước 1:  #mi(`A`)  trùng  #mi(`O(0;0;0)`) . Các đỉnh  #mi(`D, B, A'`)  lần lượt nằm trên các trục  #mi(`Ox, Oy, Oz`) .\nBước 2: Ta có  #mi(`\vec{AD} = (2;0;0)`) ,  #mi(`\vec{AB} = (0;4;0)`) ,  #mi(`\vec{AA'} = (0;0;3)`) .\nBước 3: Áp dụng quy tắc hình hộp:
-  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = (2;4;0) \Rightarrow C(2;4;0)`) .
-  #mi(`\vec{AB'} = \vec{AB} + \vec{AA'} = (0;4;3) \Rightarrow B'(0;4;3)`) .
-  #mi(`\vec{AD'} = \vec{AD} + \vec{AA'} = (2;0;3) \Rightarrow D'(2;0;3)`) .
-  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = (2;4;3) \Rightarrow C'(2;4;3)`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T05|v|2|drill|0|prompt
*Bài Bài 3.1.* Trong không gian  #mi(`Oxyz`) , cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có đỉnh  #mi(`A`)  trùng với gốc  #mi(`O`)  và các đỉnh  #mi(`D, B, A'`)  có tọa độ lần lượt là  #mi(`(1;0;0), (0;2;0), (0;0;4)`) . Xác định tọa độ của đỉnh  #mi(`C'`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T05|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`A(0;0;0)`) .  #mi(`\vec{AD} = (1;0;0)`) ,  #mi(`\vec{AB} = (0;2;0)`) ,  #mi(`\vec{AA'} = (0;0;4)`) .\nBước 2: Áp dụng quy tắc hình hộp:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = (1;2;4)`) .\nBước 3: Vậy  #mi(`C'(1;2;4)`) .]
    #if "$C'(1;2;4)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`C'(1;2;4)`) ] ]
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
  [Bài 1.1], [Lấy tọa độ B trừ tọa độ A theo từng vị trí.], [ #mi(`\vec{AB} = (0; 0; 0)`) ],
  [Bài 1.2], [Lấy tọa độ N trừ tọa độ M theo từng vị trí.], [ #mi(`\vec{MN} = (-10; 3; -7)`) ],
  [Bài 2.1], [Gốc tọa độ có tất cả các tọa độ bằng 0.], [ #mi(`A(0; 0; 0)`) ],
  [Bài 2.2], [Trên trục Oy, x=0, z=0. Tia đối Oy thì y âm.], [ #mi(`A(0; -3; 0)`) ],
  [Bài 3.1], [Dùng quy tắc hình hộp:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .], [ #mi(`C'(1;2;4)`) ],
)
