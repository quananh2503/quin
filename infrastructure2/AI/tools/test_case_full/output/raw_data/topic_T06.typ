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
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T06]: Biểu thức tọa độ của các phép toán vectơ] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Thông hiểu - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T06|theory|0
  - Cho hai vectơ  #mi(`\vec{a}=(x;y;z)`)  và  #mi(`\vec{b}=(x';y';z')`) . Phép cộng, trừ, nhân với số:  #mi(`\vec{a} \pm \vec{b} = (x \pm x'; y \pm y'; z \pm z')`)  và  #mi(`k\vec{a} = (kx; ky; kz)`) .
// @ANCHOR:T06|theory|1
  - Độ dài của vectơ  #mi(`\vec{a}=(x;y;z)`)  là  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
// @ANCHOR:T06|theory|2
  - Tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  là trung bình cộng tọa độ hai đầu mút:  #mi(`M\left(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\right)`) .
// @ANCHOR:T06|cloze
  - *Công thức then chốt:* Cho  #mi(`\vec{a}=(x;y;z)`)  và  #mi(`\vec{b}=(x';y';z')`) . Khi đó  #mi(`\vec{a} - \vec{b} = (...; ...; ...)`)  và  #mi(`|\vec{a}| = ...`) 
// @ANCHOR:T06|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Thần chú: 'Cộng trừ nhân số thì làm từng ô một, độ dài thì bình phương cộng lại rồi khai căn'.
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Tính tọa độ vectơ tổng, hiệu, nhân số]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T06|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho tọa độ các vectơ  #mi(`\vec{a}, \vec{b}`)  và yêu cầu tìm tọa độ của biểu thức vectơ như  #mi(`\vec{a}+\vec{b}`) ,  #mi(`\vec{a}-\vec{b}`) ,  #mi(`2\vec{a}-3\vec{b}`) ...

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T06|v|0|step|0
  - Bước 1: Xác định tọa độ các vectơ đã cho, viết rõ ra nháp dạng  #mi(`(x; y; z)`) .
// @ANCHOR:T06|v|0|step|1
  - Bước 2: Tính từng thành phần (hoành độ, tung độ, cao độ) riêng biệt. Mẹo: 'Cộng trừ theo cột dọc', lấy hệ số nhân vào từng số trong ngoặc trước rồi mới cộng trừ.
// @ANCHOR:T06|v|0|step|2
  - Bước 3: Ghép các kết quả lại theo đúng thứ tự  #mi(`(x; y; z)`)  để được tọa độ vectơ cuối cùng.
// @ANCHOR:T06|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Nhân số vào vectơ thì nhân hết cả 3 ô, đừng bỏ sót ô nào. Trừ vectơ thì trừ từng ô tương ứng.
  ]
]
#v(6pt)

// @ANCHOR:T06|v|0|ex_prob
#example-card(title: "Ví dụ 1 (SGK trang 68)")[
  Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (2;1;5)`)  và  #mi(`\vec{b} = (2;2;1)`) . Tìm tọa độ của mỗi vectơ sau: a)  #mi(`\vec{a}-\vec{b}`) ; b)  #mi(`3\vec{a}+2\vec{b}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T06|v|0|ex_sol
    a)  #mi(`\vec{a}-\vec{b} = (2-2; 1-2; 5-1) = (0; -1; 4)`) .\nb) Ta có  #mi(`3\vec{a} = (3.2; 3.1; 3.5) = (6; 3; 15)`)  và  #mi(`2\vec{b} = (2.2; 2.2; 2.1) = (4; 4; 2)`) . Suy ra  #mi(`3\vec{a}+2\vec{b} = (6+4; 3+4; 15+2) = (10; 7; 17)`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T06|v|0|drill|0|prompt
*Bài Bài 1.1.* Trong không gian  #mi(`Oxyz`) , cho ba vectơ  #mi(`\vec{u} = (1;8;6)`) ,  #mi(`\vec{v} = (-1;3;-2)`)  và  #mi(`\vec{w} = (0;5;4)`) . Tìm tọa độ của vectơ  #mi(`\vec{u} - 2\vec{v} + \vec{w}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T06|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Ta có  #mi(`2\vec{v} = (-2; 6; -4)`) . Khi đó  #mi(`\vec{u} - 2\vec{v} + \vec{w} = (1 - (-2) + 0; 8 - 6 + 5; 6 - (-4) + 4) = (3; 7; 14)`) .]
    #if "$(3; 7; 14)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`(3; 7; 14)`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T06|v|0|drill|1|prompt
*Bài Bài 1.2.* Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1;-2;2)`) ,  #mi(`\vec{b} = (-2;0;3)`) . Tìm tọa độ của vectơ  #mi(`2\vec{a} + \vec{b}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T06|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Ta có  #mi(`2\vec{a} = (2; -4; 4)`) . Suy ra  #mi(`2\vec{a} + \vec{b} = (2 + (-2); -4 + 0; 4 + 3) = (0; -4; 7)`) .]
    #if "$(0; -4; 7)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`(0; -4; 7)`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Tính độ dài vectơ và khoảng cách hai điểm]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T06|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho tọa độ điểm hoặc tọa độ vectơ và yêu cầu tính độ dài đoạn thẳng, khoảng cách, hoặc chu vi tam giác.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T06|v|1|step|0
  - Bước 1: Nếu đề cho 2 điểm  #mi(`A, B`) , phải đi tìm tọa độ vectơ  #mi(`\vec{AB} = (x_B-x_A; y_B-y_A; z_B-z_A)`)  trước. (Lấy tọa độ điểm cuối trừ điểm đầu).
// @ANCHOR:T06|v|1|step|1
  - Bước 2: Bấm máy tính Casio: Nhập biểu thức  #mi(`\sqrt{x^2 + y^2 + z^2}`)  với  #mi(`x, y, z`)  là các thành phần của vectơ vừa tìm được.
// @ANCHOR:T06|v|1|step|2
  - Bước 3: Đọc kết quả trên màn hình (có thể làm tròn nếu đề yêu cầu).
// @ANCHOR:T06|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Khoảng cách  #mi(`AB`)  chính là độ dài vectơ  #mi(`\vec{AB}`) . Bấm máy: Bình phương từng tọa độ, cộng lại, lấy căn bậc 2.
  ]
]
#v(6pt)

// @ANCHOR:T06|v|1|ex_prob
#example-card(title: "Ví dụ 2 (SGK trang 69)")[
  Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1;4;2)`)  và  #mi(`\vec{b} = (-4;1;0)`) . Tính độ dài của vectơ  #mi(`\vec{a}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T06|v|1|ex_sol
    Độ dài của vectơ  #mi(`\vec{a}`)  là  #mi(`|\vec{a}| = \sqrt{1^2 + 4^2 + 2^2} = \sqrt{1 + 16 + 4} = \sqrt{21}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T06|v|1|drill|0|prompt
*Bài Bài 2.1.* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(4;2;-1)`)  và  #mi(`B(1;-1;2)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T06|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Ta có  #mi(`\vec{AB} = (1-4; -1-2; 2-(-1)) = (-3; -3; 3)`) . Độ dài  #mi(`AB = |\vec{AB}| = \sqrt{(-3)^2 + (-3)^2 + 3^2} = \sqrt{9+9+9} = \sqrt{27} = 3\sqrt{3}`) .]
    #if "$3\sqrt{3}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`3\sqrt{3}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T06|v|1|drill|1|prompt
*Bài Bài 2.2.* Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (-2;1;2)`) ,  #mi(`\vec{b} = (1;1;-1)`) . Xác định tọa độ của vectơ  #mi(`\vec{u} = \vec{a} - 2\vec{b}`)  và tính độ dài vectơ  #mi(`\vec{u}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T06|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Ta có  #mi(`2\vec{b} = (2;2;-2)`) . Khi đó  #mi(`\vec{u} = (-2-2; 1-2; 2-(-2)) = (-4; -1; 4)`) . Độ dài  #mi(`|\vec{u}| = \sqrt{(-4)^2 + (-1)^2 + 4^2} = \sqrt{16+1+16} = \sqrt{33}`) .]
    #if "$\vec{u}=(-4;-1;4)$ và $|\vec{u}|=\sqrt{33}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{u}=(-4;-1;4)`)  và  #mi(`|\vec{u}|=\sqrt{33}`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Tìm tọa độ điểm thỏa mãn điều kiện vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T06|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho tọa độ các điểm và yêu cầu tìm tọa độ điểm  #mi(`M`)  sao cho một đẳng thức vectơ xảy ra (ví dụ  #mi(`\vec{AB} + \vec{CM} = \vec{0}`) ).

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T06|v|2|step|0
  - Bước 1: Gọi tọa độ điểm cần tìm là  #mi(`M(x; y; z)`) .
// @ANCHOR:T06|v|2|step|1
  - Bước 2: Tính tọa độ các vectơ có trong đẳng thức theo  #mi(`x, y, z`)  (ví dụ  #mi(`\vec{CM} = (x - x_C; y - y_C; z - z_C)`) ).
// @ANCHOR:T06|v|2|step|2
  - Bước 3: Cho hoành độ bằng nhau, tung độ bằng nhau, cao độ bằng nhau để lập hệ phương trình 3 ẩn.
// @ANCHOR:T06|v|2|step|3
  - Bước 4: Giải hệ phương trình (bấm máy EQN) tìm ra  #mi(`x, y, z`)  và kết luận.
// @ANCHOR:T06|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Đẳng thức vectơ  #mi(`\vec{u} = \vec{v}`)  tương đương với 3 phương trình tọa độ. Chuyển vế đổi dấu cẩn thận.
  ]
]
#v(6pt)

// @ANCHOR:T06|v|2|ex_prob
#example-card(title: "Ví dụ 3 (SGK trang 69)")[
  Trong không gian  #mi(`Oxyz`) , cho ba điểm  #mi(`A(2;9;-1)`) ,  #mi(`B(9;4;5)`)  và  #mi(`G(3;0;4)`) . Tìm tọa độ điểm  #mi(`C`)  sao cho tam giác  #mi(`ABC`)  nhận  #mi(`G`)  là trọng tâm.

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T06|v|2|ex_sol
    Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên ta có hệ thức tọa độ:
 #mi(`x_G = \frac{x_A+x_B+x_C}{3} \Rightarrow x_C = 3x_G - x_A - x_B = 3.3 - 2 - 9 = -2`) .
 #mi(`y_G = \frac{y_A+y_B+y_C}{3} \Rightarrow y_C = 3y_G - y_A - y_B = 3.0 - 9 - 4 = -13`) .
 #mi(`z_G = \frac{z_A+z_B+z_C}{3} \Rightarrow z_C = 3z_G - z_A - z_B = 3.4 - (-1) - 5 = 8`) .\nVậy  #mi(`C(-2; -13; 8)`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T06|v|2|drill|0|prompt
*Bài Bài 3.1.* Trong không gian  #mi(`Oxyz`) , cho các điểm  #mi(`A(4;2;-1)`) ,  #mi(`B(1;-1;2)`)  và  #mi(`C(0;-2;3)`) . Tìm tọa độ điểm  #mi(`M`)  sao cho  #mi(`\vec{AB} + \vec{CM} = \vec{0}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T06|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Ta có  #mi(`\vec{AB} = (-3; -3; 3)`) . Gọi  #mi(`M(x;y;z)`) , suy ra  #mi(`\vec{CM} = (x; y+2; z-3)`) .\nTừ  #mi(`\vec{AB} + \vec{CM} = \vec{0} \Rightarrow \vec{CM} = -\vec{AB} = (3; 3; -3)`) .\nDo đó:  #mi(`x = 3`) ;  #mi(`y+2 = 3 \Rightarrow y=1`) ;  #mi(`z-3 = -3 \Rightarrow z=0`) . Vậy  #mi(`M(3;1;0)`) .]
    #if "$M(3;1;0)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`M(3;1;0)`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T06|v|2|drill|1|prompt
*Bài Bài 3.2.* Trong không gian  #mi(`Oxyz`) , cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(-1;0;3)`) ,  #mi(`B(2;1;-1)`)  và  #mi(`C(3;2;1)`) . Tìm tọa độ điểm  #mi(`D`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T06|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Gọi  #mi(`D(x;y;z)`) . Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) .\nTa có  #mi(`\vec{AB} = (3;1;-4)`)  và  #mi(`\vec{DC} = (3-x; 2-y; 1-z)`) .\nSuy ra  #mi(`3-x=3 \Rightarrow x=0`) ;  #mi(`2-y=1 \Rightarrow y=1`) ;  #mi(`1-z=-4 \Rightarrow z=5`) . Vậy  #mi(`D(0;1;5)`) .]
    #if "$D(0;1;5)$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`D(0;1;5)`) ] ]
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
  [Bài 1.1], [Tính  #mi(`2\vec{v}`)  rồi lấy  #mi(`\vec{u} - 2\vec{v} + \vec{w}`)  theo từng tọa độ.], [ #mi(`(3; 7; 14)`) ],
  [Bài 1.2], [Tính  #mi(`2\vec{a}`)  rồi cộng với  #mi(`\vec{b}`)  theo từng tọa độ.], [ #mi(`(0; -4; 7)`) ],
  [Bài 2.1], [Tìm  #mi(`\vec{AB}`)  rồi tính  #mi(`\sqrt{x^2+y^2+z^2}`) .], [ #mi(`3\sqrt{3}`) ],
  [Bài 2.2], [Tính  #mi(`\vec{u} = \vec{a} - 2\vec{b}`)  rồi tính độ dài  #mi(`\sqrt{x^2+y^2+z^2}`) .], [ #mi(`\vec{u}=(-4;-1;4)`)  và  #mi(`|\vec{u}|=\sqrt{33}`) ],
  [Bài 3.1], [Chuyển vế  #mi(`\vec{CM} = -\vec{AB}`)  rồi đồng nhất tọa độ.], [ #mi(`M(3;1;0)`) ],
  [Bài 3.2], [Dùng quy tắc hình bình hành  #mi(`\vec{AB} = \vec{DC}`)  để lập hệ phương trình.], [ #mi(`D(0;1;5)`) ],
)
