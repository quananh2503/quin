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
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T2]: Tổng và hiệu của hai vectơ trong không gian] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Thông hiểu - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T2|theory|0
  - Quy tắc ba điểm (nối tiếp): Với ba điểm  #mi(`A, B, C`)  bất kì, ta luôn có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
// @ANCHOR:T2|theory|1
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (tổng 2 cạnh kề bằng đường chéo).
// @ANCHOR:T2|theory|2
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (tổng 3 cạnh kề bằng đường chéo chính).
// @ANCHOR:T2|theory|3
  - Quy tắc hiệu (chung gốc):  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) .
// @ANCHOR:T2|cloze
  - *Công thức then chốt:* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \overrightarrow{...}`) 
// @ANCHOR:T2|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Thần chú nhớ nhanh: 'Ba điểm nối đuôi - Hình bình hành chéo đáy - Hình hộp chéo khối - Hiệu thì chung gốc lộn ngược'.
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Tính tổng, hiệu các vectơ bằng quy tắc ba điểm, hình bình hành, hình hộp]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T2|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho các vectơ nối tiếp nhau hoặc xuất phát từ cùng một đỉnh của hình bình hành/hình hộp và yêu cầu rút gọn tổng/hiệu.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T2|v|0|step|0
  - Bước 1: Nhìn vào các vectơ trong biểu thức. Nếu thấy đuôi của vectơ này trùng với đầu của vectơ kia (ví dụ  #mi(`\vec{AB}`)  và  #mi(`\vec{BC}`) ) thì gộp luôn theo quy tắc ba điểm:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
// @ANCHOR:T2|v|0|step|1
  - Bước 2: Nếu thấy 2 vectơ cùng xuất phát từ 1 đỉnh của hình bình hành (ví dụ  #mi(`\vec{AB} + \vec{AD}`) ) thì thay bằng đường chéo hình bình hành:  #mi(`\vec{AC}`) .
// @ANCHOR:T2|v|0|step|2
  - Bước 3: Nếu thấy 3 vectơ cùng xuất phát từ 1 đỉnh của hình hộp (ví dụ  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) ) thì thay bằng đường chéo chính của hình hộp:  #mi(`\vec{AC'}`) .
// @ANCHOR:T2|v|0|step|3
  - Bước 4: Nếu có phép trừ, hãy biến đổi thành phép cộng với vectơ đối (ví dụ  #mi(`-\vec{CD} = \vec{DC}`) ) hoặc dùng quy tắc chung gốc  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`)  để rút gọn.
// @ANCHOR:T2|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo loại trừ trắc nghiệm: Kết quả của tổng các vectơ luôn có điểm đầu là điểm đầu tiên và điểm cuối là điểm cuối cùng của chuỗi nối tiếp.
  ]
]
#v(6pt)

// @ANCHOR:T2|v|0|ex_prob
#example-card(title: "Ví dụ minh họa (Trích Ví dụ 3 SGK trang 49)")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng 1. Tính độ dài của vectơ  #mi(`\vec{BC} + \vec{DD'}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T2|v|0|ex_sol
    Bước 1: Nhìn vào 2 vectơ  #mi(`\vec{BC}`)  và  #mi(`\vec{DD'}`) , chúng chưa nối tiếp nhau. Ta tìm cách thay thế vectơ bằng nhau. Vì  #mi(`DD'C'C`)  là hình bình hành nên  #mi(`\vec{DD'} = \vec{CC'}`) .\nBước 2: Thay vào biểu thức ta được:  #mi(`\vec{BC} + \vec{DD'} = \vec{BC} + \vec{CC'}`) .\nBước 3: Áp dụng quy tắc ba điểm nối tiếp:  #mi(`\vec{BC} + \vec{CC'} = \vec{BC'}`) .\nBước 4: Tính độ dài  #mi(`\vec{BC'}`) . Xét tam giác vuông  #mi(`BCC'`)  vuông tại  #mi(`C`) , ta có  #mi(`BC = 1, CC' = 1`) . Theo Pitago:  #mi(`BC' = \sqrt{1^2 + 1^2} = \sqrt{2}`) . Vậy  #mi(`|\vec{BC} + \vec{DD'}| = \sqrt{2}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T2|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng 2. Tính độ dài của vectơ  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Nhận diện 3 vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  cùng xuất phát từ đỉnh  #mi(`A`)  của hình hộp.\nBước 2: Áp dụng quy tắc hình hộp, ta có ngay:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nBước 3: Tính độ dài đường chéo chính  #mi(`AC'`)  của hình lập phương cạnh  #mi(`a=2`) . Công thức nhanh:  #mi(`AC' = a\sqrt{3} = 2\sqrt{3}`) .\nVậy độ dài vectơ cần tìm là  #mi(`2\sqrt{3}`) .]
    #if "$2\sqrt{3}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`2\sqrt{3}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T2|v|0|drill|1|prompt
*Bài Bài 1.2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB = 3, AD = 4, AA' = 12`) . Tính độ dài của vectơ  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Nhận diện 3 vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  cùng xuất phát từ đỉnh  #mi(`A`) .\nBước 2: Áp dụng quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nBước 3: Tính độ dài  #mi(`AC'`) . Xét tam giác vuông  #mi(`ABC`)  có  #mi(`AC = \sqrt{AB^2 + AD^2} = \sqrt{3^2 + 4^2} = 5`) . Xét tam giác vuông  #mi(`ACC'`)  có  #mi(`AC' = \sqrt{AC^2 + CC'^2} = \sqrt{5^2 + 12^2} = 13`) .\nVậy độ dài vectơ là  #mi(`13`) .]
    #if "$13$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`13`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Chứng minh đẳng thức vectơ (Biến đổi tương đương hoặc chèn điểm)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T2|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề yêu cầu chứng minh một đẳng thức vectơ (VT = VP). Các vectơ thường không nối tiếp sẵn mà cần biến đổi.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T2|v|1|step|0
  - Bước 1: Chọn vế phức tạp hơn (thường là Vế trái) để biến đổi thành vế đơn giản hơn (Vế phải).
// @ANCHOR:T2|v|1|step|1
  - Bước 2: Sử dụng kỹ thuật 'Chèn điểm'. Nhìn vào điểm đầu và điểm cuối của vectơ cần biến đổi, chèn một điểm bất kỳ (thường là điểm xuất hiện ở vế phải) vào giữa. Ví dụ:  #mi(`\vec{AC} = \vec{AD} + \vec{DC}`) .
// @ANCHOR:T2|v|1|step|2
  - Bước 3: Gom nhóm các vectơ và áp dụng quy tắc ba điểm để thu gọn. Nhớ quy tắc:  #mi(`\vec{AB} + \vec{BA} = \overrightarrow{0}`)  (hai vectơ đối nhau triệt tiêu).
// @ANCHOR:T2|v|1|step|3
  - Bước 4: Rút gọn đến khi xuất hiện đúng biểu thức của Vế phải thì kết luận 'Điều phải chứng minh (đpcm)'.
// @ANCHOR:T2|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo chèn điểm: Muốn chèn điểm  #mi(`O`)  vào  #mi(`\vec{AB}`) , ta viết  #mi(`\vec{AB} = \vec{AO} + \vec{OB}`) . Cứ đọc là 'Đi từ A đến O rồi từ O đến B'.
  ]
]
#v(6pt)

// @ANCHOR:T2|v|1|ex_prob
#example-card(title: "Ví dụ minh họa (Trích Ví dụ 4 SGK trang 49)")[
  Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T2|v|1|ex_sol
    Bước 1: Biến đổi Vế trái:  #mi(`VT = \vec{AC} + \vec{BD}`) .\nBước 2: Chèn điểm  #mi(`D`)  vào vectơ  #mi(`\vec{AC}`) :  #mi(`\vec{AC} = \vec{AD} + \vec{DC}`) . Chèn điểm  #mi(`C`)  vào vectơ  #mi(`\vec{BD}`) :  #mi(`\vec{BD} = \vec{BC} + \vec{CD}`) .\nBước 3: Thay vào VT ta được:  #mi(`VT = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD})`) .\nBước 4: Gom nhóm:  #mi(`VT = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) . Vì  #mi(`\vec{DC}`)  và  #mi(`\vec{CD}`)  là hai vectơ đối nhau nên  #mi(`\vec{DC} + \vec{CD} = \overrightarrow{0}`) .\nSuy ra  #mi(`VT = \vec{AD} + \vec{BC} = VP`) . Vậy đẳng thức được chứng minh.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T2|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Biến đổi Vế trái:  #mi(`VT = \vec{AB} + \vec{CD}`) .\nBước 2: Chèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`) :  #mi(`\vec{AB} = \vec{AD} + \vec{DB}`) .\nBước 3: Thay vào VT:  #mi(`VT = \vec{AD} + \vec{DB} + \vec{CD}`) .\nBước 4: Đổi vị trí:  #mi(`VT = \vec{AD} + (\vec{CD} + \vec{DB})`) . Theo quy tắc ba điểm,  #mi(`\vec{CD} + \vec{DB} = \vec{CB}`) .\nSuy ra  #mi(`VT = \vec{AD} + \vec{CB} = VP`) . Vậy đẳng thức được chứng minh.]
    #if "Đã chứng minh $VT = VP$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh  #mi(`VT = VP`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T2|v|1|drill|1|prompt
*Bài Bài 2.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Biến đổi Vế trái:  #mi(`VT = \vec{BC} + \vec{DC} + \vec{AA'}`) .\nBước 2: Thay thế các vectơ bằng nhau trong hình hộp:  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`) . Đồng thời  #mi(`\vec{AA'} = \vec{CC'}`) .\nBước 3: Thay vào VT:  #mi(`VT = \vec{AD} + \vec{AB} + \vec{AA'}`) .\nBước 4: Áp dụng quy tắc hình hộp cho 3 cạnh kề xuất phát từ  #mi(`A`) :  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nVậy  #mi(`VT = \vec{AC'} = VP`)  (đpcm).]
    #if "Đã chứng minh $VT = VP$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh  #mi(`VT = VP`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Trắc nghiệm lý thuyết tổng/hiệu vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T2|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho các đẳng thức vectơ và yêu cầu tìm mệnh đề ĐÚNG hoặc SAI. Không cần tính toán số liệu phức tạp.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T2|v|2|step|0
  - Bước 1: Đọc kỹ yêu cầu (Tìm ĐÚNG hay SAI).
// @ANCHOR:T2|v|2|step|1
  - Bước 2: Kiểm tra từng đáp án bằng cách nhẩm nhanh quy tắc. Nếu thấy đuôi nọ nối đầu kia thì dùng quy tắc 3 điểm. Nếu thấy 2 vectơ cùng gốc thì dùng quy tắc hình bình hành hoặc quy tắc hiệu.
// @ANCHOR:T2|v|2|step|2
  - Bước 3: Loại trừ các đáp án sai. Ví dụ:  #mi(`\vec{AB} - \vec{AC}`)  phải bằng  #mi(`\vec{CB}`)  (chung gốc lộn ngược), nếu đề cho bằng  #mi(`\vec{BC}`)  là SAI.
// @ANCHOR:T2|v|2|step|3
  - Bước 4: Chốt đáp án đúng nhất.
// @ANCHOR:T2|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo 5 giây: Thấy  #mi(`\vec{AB} + \vec{BC}`)  mà đề cho kết quả khác  #mi(`\vec{AC}`)  là SAI. Thấy  #mi(`\vec{AB} - \vec{AC}`)  mà đề cho kết quả khác  #mi(`\vec{CB}`)  là SAI.
  ]
]
#v(6pt)

// @ANCHOR:T2|v|2|ex_prob
#example-card(title: "Ví dụ minh họa (Trích Câu 2 - Trắc nghiệm)")[
  Trong không gian, khẳng định nào sau đây là khẳng định SAI?\nA.  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) \nB.  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) \nC.  #mi(`\vec{AB} - \vec{AC} = \vec{BC}`) \nD.  #mi(`\vec{MA} + \vec{MB} = \overrightarrow{0}`)  (với  #mi(`M`)  là trung điểm  #mi(`AB`) )

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T2|v|2|ex_sol
    Bước 1: Yêu cầu tìm mệnh đề SAI.\nBước 2: Kiểm tra A: Đúng theo quy tắc ba điểm.\nBước 3: Kiểm tra B: Đúng theo quy tắc hiệu chung gốc  #mi(`O`) .\nBước 4: Kiểm tra C: Theo quy tắc hiệu chung gốc  #mi(`A`) , ta có  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) . Đề cho bằng  #mi(`\vec{BC}`)  là sai (ngược hướng).\nBước 5: Kiểm tra D:  #mi(`M`)  là trung điểm  #mi(`AB`)  thì  #mi(`\vec{MA}`)  và  #mi(`\vec{MB}`)  là hai vectơ đối nhau nên tổng bằng  #mi(`\overrightarrow{0}`) . Đúng.\nVậy đáp án SAI là C.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T2|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình bình hành  #mi(`ABCD`)  trong không gian. Tổng  #mi(`\vec{AB} + \vec{AD}`)  bằng vectơ nào sau đây?\nA.  #mi(`\vec{AC}`) \nB.  #mi(`\vec{CA}`) \nC.  #mi(`\vec{BD}`) \nD.  #mi(`\vec{DB}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Nhận diện  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  là hai vectơ cùng xuất phát từ đỉnh  #mi(`A`)  của hình bình hành  #mi(`ABCD`) .\nBước 2: Áp dụng quy tắc hình bình hành, tổng hai cạnh kề bằng đường chéo xuất phát từ đỉnh đó:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .\nBước 3: Đối chiếu đáp án, chọn A.]
    #if "A" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: A] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T2|v|2|drill|1|prompt
*Bài Bài 3.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Tổng ba vectơ  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`)  bằng vectơ nào?\nA.  #mi(`\vec{A'C}`) \nB.  #mi(`\vec{BD'}`) \nC.  #mi(`\vec{CA'}`) \nD.  #mi(`\vec{AC'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Nhận diện 3 vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  cùng xuất phát từ đỉnh  #mi(`A`)  của hình hộp.\nBước 2: Áp dụng quy tắc hình hộp, tổng 3 cạnh kề bằng đường chéo chính xuất phát từ đỉnh đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nBước 3: Đối chiếu đáp án, chọn D.]
    #if "D" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: D] ]
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
  [Bài 1.1], [Dùng quy tắc hình hộp đưa về  #mi(`\vec{AC'}`)  rồi tính đường chéo hình lập phương cạnh 2.], [ #mi(`2\sqrt{3}`) ],
  [Bài 1.2], [Dùng quy tắc hình hộp đưa về  #mi(`\vec{AC'}`)  rồi tính đường chéo hình hộp chữ nhật bằng Pitago 2 lần.], [ #mi(`13`) ],
  [Bài 2.1], [Chèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`)  rồi gom nhóm  #mi(`\vec{CD} + \vec{DB} = \vec{CB}`) .], [Đã chứng minh  #mi(`VT = VP`) ],
  [Bài 2.2], [Thay  #mi(`\vec{BC} = \vec{AD}`) ,  #mi(`\vec{DC} = \vec{AB}`)  rồi dùng quy tắc hình hộp.], [Đã chứng minh  #mi(`VT = VP`) ],
  [Bài 3.1], [Quy tắc hình bình hành: Tổng 2 cạnh kề bằng đường chéo.], [A],
  [Bài 3.2], [Quy tắc hình hộp: Tổng 3 cạnh kề bằng đường chéo chính.], [D],
)
