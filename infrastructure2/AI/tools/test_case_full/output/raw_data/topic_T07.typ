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
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T07]: Ứng dụng vectơ và tọa độ giải bài toán thực tế] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Vận dụng - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T07|theory|0
  - Độ lớn của vectơ  #mi(`\vec{a}=(x;y;z)`)  là  #mi(`|\vec{a}|=\sqrt{x^2+y^2+z^2}`) .
// @ANCHOR:T07|theory|1
  - Khoảng cách giữa hai điểm  #mi(`A(x_A;y_A;z_A)`)  và  #mi(`B(x_B;y_B;z_B)`)  là  #mi(`AB=|\vec{AB}|=\sqrt{(x_B-x_A)^2+(y_B-y_A)^2+(z_B-z_A)^2}`) .
// @ANCHOR:T07|theory|2
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}=(x;y;z)`)  và  #mi(`\vec{b}=(x';y';z')`)  là  #mi(`\vec{a}\cdot\vec{b}=xx'+yy'+zz'`) .
// @ANCHOR:T07|cloze
  - *Công thức then chốt:* Độ lớn của vectơ  #mi(`\vec{a}=(x;y;z)`)  được tính bằng công thức  #mi(`|\vec{a}| = \sqrt{...}`) 
// @ANCHOR:T07|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Gặp bài toán thực tế: Bước 1 - Chọn hệ trục tọa độ (thường gắn với mặt đất hoặc góc phòng). Bước 2 - Chuyển các dữ kiện thành tọa độ điểm/vectơ. Bước 3 - Dùng công thức độ lớn hoặc khoảng cách để tính.
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Bài toán cân bằng lực và hợp lực]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T07|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho các lực tác dụng vào vật, yêu cầu tính độ lớn hợp lực hoặc tìm lực cân bằng.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T07|v|0|step|0
  - Bước 1: Xác định các vectơ lực thành phần. Nếu lực có phương vuông góc với mặt phẳng, ta gán cho nó tọa độ theo trục  #mi(`z`) . Nếu lực nằm trong mặt phẳng, ta gán tọa độ theo trục  #mi(`x, y`) .
// @ANCHOR:T07|v|0|step|1
  - Bước 2: Tính tổng các vectơ lực (hợp lực) bằng cách cộng từng tọa độ tương ứng:  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + ...`) 
// @ANCHOR:T07|v|0|step|2
  - Bước 3: Tính độ lớn hợp lực bằng công thức  #mi(`|\vec{F}| = \sqrt{x^2+y^2+z^2}`) . Bấm máy tính Casio: Nhập biểu thức căn bậc hai của tổng bình phương các tọa độ, nhấn '=' để ra kết quả.
// @ANCHOR:T07|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Nếu các lực đôi một vuông góc, độ lớn hợp lực là  #mi(`\sqrt{F_1^2 + F_2^2 + F_3^2}`) . Bấm máy tính liên tục để tránh sai số.
  ]
]
#v(6pt)

// @ANCHOR:T07|v|0|ex_prob
#example-card(title: "Ví dụ: Ba lực vuông góc")[
  Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  cùng tác động vào một vật có phương đôi một vuông góc và có độ lớn lần lượt là  #mi(`2N; 3N; 4N`) . Tính độ lớn hợp lực của ba lực đã cho.

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T07|v|0|ex_sol
    Bước 1: Chọn hệ trục tọa độ Oxyz sao cho các lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  lần lượt nằm trên các trục Ox, Oy, Oz. Khi đó:  #mi(`\vec{F_1}=(2;0;0)`) ,  #mi(`\vec{F_2}=(0;3;0)`) ,  #mi(`\vec{F_3}=(0;0;4)`) . Bước 2: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3} = (2;3;4)`) . Bước 3: Độ lớn hợp lực  #mi(`|\vec{F}| = \sqrt{2^2+3^2+4^2} = \sqrt{4+9+16} = \sqrt{29} \approx 5.39N`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T07|v|0|drill|0|prompt
*Bài Bài 1.1.* Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  cùng tác động vào một vật có phương đôi một vuông góc và có độ lớn lần lượt là  #mi(`1N; 2N; 2N`) . Tính độ lớn hợp lực của ba lực đã cho.
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T07|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Gán tọa độ  #mi(`\vec{F_1}=(1;0;0)`) ,  #mi(`\vec{F_2}=(0;2;0)`) ,  #mi(`\vec{F_3}=(0;0;2)`) . Bước 2: Hợp lực  #mi(`\vec{F} = (1;2;2)`) . Bước 3: Độ lớn  #mi(`|\vec{F}| = \sqrt{1^2+2^2+2^2} = \sqrt{9} = 3N`) .]
    #if "3N" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 3N] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Bài toán chuyển động trong không gian]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T07|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho vận tốc, quãng đường, thời gian hoặc yêu cầu xác định vị trí của vật thể chuyển động.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T07|v|1|step|0
  - Bước 1: Xác định vectơ vận tốc hoặc vectơ dịch chuyển. Nếu vật chuyển động thẳng đều, vectơ dịch chuyển  #mi(`\vec{d} = \vec{v} \cdot t`) .
// @ANCHOR:T07|v|1|step|1
  - Bước 2: Xác định tọa độ điểm đầu và điểm cuối. Nếu biết điểm đầu  #mi(`A`)  và vectơ dịch chuyển  #mi(`\vec{d}`) , tọa độ điểm cuối  #mi(`B = A + \vec{d}`) .
// @ANCHOR:T07|v|1|step|2
  - Bước 3: Tính quãng đường hoặc khoảng cách cần tìm bằng công thức độ lớn vectơ.
// @ANCHOR:T07|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Vật chuyển động trên mặt phẳng (Oxy) thì tọa độ  #mi(`z=0`) . Vật chuyển động thẳng đứng thì tọa độ  #mi(`x, y`)  không đổi.
  ]
]
#v(6pt)

// @ANCHOR:T07|v|1|ex_prob
#example-card(title: "Ví dụ: Máy bay chuyển động")[
  Một chiếc máy bay bay với vận tốc  #mi(`800 km/h`)  theo hướng Nam trong 2 giờ. Xác định tọa độ vectơ dịch chuyển của máy bay.

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T07|v|1|ex_sol
    Bước 1: Vectơ vận tốc  #mi(`\vec{v} = (0; -800; 0)`)  (vì hướng Nam là chiều âm trục Oy). Bước 2: Thời gian  #mi(`t=2`)  giờ. Vectơ dịch chuyển  #mi(`\vec{d} = \vec{v} \cdot t = (0; -1600; 0)`) . Bước 3: Độ lớn quãng đường là  #mi(`1600 km`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T07|v|1|drill|0|prompt
*Bài Bài 2.1.* Một chiếc xe chuyển động với vận tốc  #mi(`60 km/h`)  theo hướng Đông trong 3 giờ. Xác định tọa độ vectơ dịch chuyển của xe.
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T07|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Vectơ vận tốc  #mi(`\vec{v} = (60; 0; 0)`)  (hướng Đông là chiều dương trục Ox). Bước 2: Thời gian  #mi(`t=3`)  giờ. Vectơ dịch chuyển  #mi(`\vec{d} = (180; 0; 0)`) . Bước 3: Quãng đường là  #mi(`180 km`) .]
    #if "(180; 0; 0)" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: (180; 0; 0)] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Bài toán xác định khoảng cách, vị trí trong thực tế]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T07|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài yêu cầu tính khoảng cách giữa hai địa điểm, chiều cao, hoặc xác định vị trí của vật thể trong không gian thực.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T07|v|2|step|0
  - Bước 1: Chọn hệ trục tọa độ Oxyz phù hợp (gốc O tại một điểm mốc, các trục hướng theo các phương đã biết).
// @ANCHOR:T07|v|2|step|1
  - Bước 2: Xác định tọa độ các điểm liên quan dựa trên dữ kiện đề bài (chiều dài, chiều rộng, chiều cao).
// @ANCHOR:T07|v|2|step|2
  - Bước 3: Sử dụng công thức khoảng cách giữa hai điểm để tính toán. Bấm máy tính Casio: Nhập tọa độ vào công thức  #mi(`\sqrt{(x_2-x_1)^2+(y_2-y_1)^2+(z_2-z_1)^2}`) .
// @ANCHOR:T07|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Nếu vật nằm trên mặt đất, tọa độ  #mi(`z=0`) . Nếu vật nằm trên trần nhà, tọa độ  #mi(`z`)  bằng chiều cao.
  ]
]
#v(6pt)

// @ANCHOR:T07|v|2|ex_prob
#example-card(title: "Ví dụ: Khoảng cách giữa hai điểm")[
  Trong một căn phòng hình hộp chữ nhật có chiều dài  #mi(`5m`) , chiều rộng  #mi(`4m`) , chiều cao  #mi(`3m`) . Chọn hệ trục tọa độ Oxyz với gốc O tại một góc phòng, các trục Ox, Oy, Oz lần lượt dọc theo chiều dài, chiều rộng và chiều cao. Tính khoảng cách từ góc phòng đối diện trên trần nhà đến gốc tọa độ.

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T07|v|2|ex_sol
    Bước 1: Chọn hệ trục tọa độ Oxyz như đề bài. Bước 2: Góc phòng đối diện trên trần nhà có tọa độ  #mi(`A(5;4;3)`) . Bước 3: Khoảng cách  #mi(`OA = \sqrt{5^2+4^2+3^2} = \sqrt{25+16+9} = \sqrt{50} = 5\sqrt{2} \approx 7.07m`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T07|v|2|drill|0|prompt
*Bài Bài 3.1.* Trong một căn phòng hình hộp chữ nhật có chiều dài  #mi(`6m`) , chiều rộng  #mi(`3m`) , chiều cao  #mi(`2.5m`) . Chọn hệ trục tọa độ Oxyz với gốc O tại một góc phòng, các trục Ox, Oy, Oz lần lượt dọc theo chiều dài, chiều rộng và chiều cao. Tính khoảng cách từ góc phòng đối diện trên trần nhà đến gốc tọa độ.
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T07|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chọn hệ trục tọa độ Oxyz. Bước 2: Góc phòng đối diện trên trần nhà có tọa độ  #mi(`A(6;3;2.5)`) . Bước 3: Khoảng cách  #mi(`OA = \sqrt{6^2+3^2+2.5^2} = \sqrt{36+9+6.25} = \sqrt{51.25} \approx 7.16m`) .]
    #if "\sqrt{51.25} \approx 7.16m" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: \sqrt{51.25} \approx 7.16m] ]
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
  [Bài 1.1], [Gán tọa độ các lực, tính tổng vectơ, tính độ lớn.], [3N],
  [Bài 2.1], [Xác định vectơ vận tốc, nhân với thời gian, suy ra tọa độ dịch chuyển.], [(180; 0; 0)],
  [Bài 3.1], [Xác định tọa độ điểm, dùng công thức khoảng cách.], [\sqrt{51.25} \approx 7.16m],
)
