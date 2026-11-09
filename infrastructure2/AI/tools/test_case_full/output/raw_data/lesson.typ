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
    #text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN CHI TIẾT (GIÁO VIÊN)]
  ] else [
    #text(size: 13pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU BÀI TẬP VÀ RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 17pt, weight: "bold", fill: rgb("#b91c1c"))[Hệ thống bài giảng Vectơ trong không gian - Hệ trục tọa độ Oxyz (Lớp 12 - GDPT 2018) dành cho học sinh mất gốc] \
  #v(2pt)
  #text(size: 10pt, style: "italic", fill: rgb("#475569"))[Kế hoạch bài giảng được thiết kế đặc biệt cho học sinh trung bình - yếu, mất gốc. Toàn bộ 190 câu hỏi được phân rã thành 24 dạng toán nhỏ (atomic skills), đi từ nhận biết vectơ, phép toán vectơ, đến hệ tọa độ Oxyz và ứng dụng thực tiễn. Mỗi dạng đều có bước giải cầm tay chỉ việc, mẹo Casio và hệ thống bài tập từ dễ đến khó. Đảm bảo bảo toàn 100% item ID.]
]

#v(10pt)
#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T01]: Nhận biết vectơ trong không gian: định nghĩa, phương, hướng, độ dài] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Nhận biết - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T01|theory|0
  - Vectơ trong không gian là một đoạn thẳng có hướng, kí hiệu  #mi(`\vec{AB}`)  (A là điểm đầu, B là điểm cuối). Độ dài vectơ  #mi(`|\vec{AB}|`)  chính là độ dài đoạn thẳng  #mi(`AB`) .
// @ANCHOR:T01|theory|1
  - Hai vectơ được gọi là cùng phương nếu giá của chúng song song hoặc trùng nhau. Nếu cùng phương, chúng có thể cùng hướng hoặc ngược hướng.
// @ANCHOR:T01|theory|2
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được gọi là bằng nhau (kí hiệu  #mi(`\vec{a} = \vec{b}`) ) nếu chúng cùng hướng và có cùng độ dài.
// @ANCHOR:T01|cloze
  - *Công thức then chốt:* Hai vectơ bằng nhau khi và chỉ khi chúng ... và có ... bằng nhau.
// @ANCHOR:T01|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] MẸO NHÌN HÌNH: Để tìm vectơ bằng vectơ  #mi(`\vec{AB}`) , em hãy tìm một đoạn thẳng khác song song với  #mi(`AB`) , có độ dài bằng  #mi(`AB`)  và phải vẽ mũi tên CÙNG CHIỀU với  #mi(`\vec{AB}`) .
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Đếm số vectơ tạo từ các đỉnh của hình chóp, tứ diện]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T01|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình chóp hoặc tứ diện và yêu cầu đếm số vectơ khác  #mi(`\vec{0}`)  có điểm đầu, điểm cuối là các đỉnh của hình.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T01|v|0|step|0
  - Bước 1: Xác định tổng số đỉnh của hình (ví dụ: tứ diện có 4 đỉnh, hình chóp tứ giác có 5 đỉnh).
// @ANCHOR:T01|v|0|step|1
  - Bước 2: MẸO ĐẾM NHANH: Số vectơ tạo thành từ  #mi(`n`)  đỉnh (khác vectơ  #mi(`\vec{0}`) ) bằng  #mi(`n \times (n - 1)`) . (Vì mỗi đỉnh có thể nối với  #mi(`n-1`)  đỉnh còn lại để tạo thành vectơ).
// @ANCHOR:T01|v|0|step|2
  - Bước 3: Bấm máy tính: Nhập  #mi(`n \times (n - 1)`)  và bấm dấu '=' để ra kết quả.
// @ANCHOR:T01|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy đếm số vectơ từ  #mi(`n`)  đỉnh: Bấm ngay  #mi(`n \times (n - 1)`)  là xong.
  ]
]
#v(6pt)

// @ANCHOR:T01|v|0|ex_prob
#example-card(title: "Ví dụ minh họa (Trích từ Hoạt động SGK)")[
  Cho tứ diện  #mi(`ABCD`) . Hỏi có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  mà mỗi vectơ có điểm đầu, điểm cuối là hai đỉnh của tứ diện  #mi(`ABCD`) ?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T01|v|0|ex_sol
    Bước 1: Tứ diện  #mi(`ABCD`)  có 4 đỉnh là  #mi(`A, B, C, D`)  nên  #mi(`n = 4`) .\nBước 2: Áp dụng mẹo đếm nhanh, số vectơ là  #mi(`4 \times (4 - 1)`) .\nBước 3: Bấm máy tính  #mi(`4 \times 3 = 12`) . Vậy có 12 vectơ thỏa mãn.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T01|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình chóp tứ giác  #mi(`S.ABCD`) . Hỏi có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  mà mỗi vectơ có điểm đầu, điểm cuối là hai đỉnh của hình chóp?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T01|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Hình chóp  #mi(`S.ABCD`)  có 5 đỉnh ( #mi(`S, A, B, C, D`) ). Số vectơ là  #mi(`5 \times (5 - 1) = 5 \times 4 = 20`) .]
    #if "20" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 20] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T01|v|0|drill|1|prompt
*Bài Bài 1.2.* Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Hỏi có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  mà mỗi vectơ có điểm đầu, điểm cuối là hai đỉnh của hình lăng trụ?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T01|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Hình lăng trụ tam giác có 6 đỉnh. Số vectơ là  #mi(`6 \times (6 - 1) = 6 \times 5 = 30`) .]
    #if "30" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 30] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Xác định phương, hướng, vectơ bằng nhau trong hình hộp, lăng trụ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T01|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho hình hộp hoặc lăng trụ và hỏi vectơ nào bằng vectơ đã cho, hoặc nhận xét về phương/hướng của hai vectơ.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T01|v|1|step|0
  - Bước 1: Xác định rõ điểm đầu và điểm cuối của vectơ trong đề bài (ví dụ  #mi(`\vec{AB}`) ).
// @ANCHOR:T01|v|1|step|1
  - Bước 2: Tìm các cạnh của hình song song với đoạn thẳng  #mi(`AB`)  (dựa vào tính chất hình bình hành của các mặt bên).
// @ANCHOR:T01|v|1|step|2
  - Bước 3: MẸO LOẠI TRỪ: Trên các cạnh song song tìm được, chỉ chọn vectơ có mũi tên vẽ CÙNG CHIỀU với vectơ ban đầu. Nếu ngược chiều thì đó là vectơ đối, không phải vectơ bằng.
// @ANCHOR:T01|v|1|step|3
  - Bước 4: Kiểm tra lại độ dài: hai đoạn thẳng đó phải bằng nhau (thường là các cạnh tương ứng của hình hộp/lăng trụ).
// @ANCHOR:T01|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Vectơ bằng nhau phải hội đủ 2 điều kiện: CÙNG HƯỚNG và CÙNG ĐỘ DÀI. Thấy ngược chiều là loại ngay.
  ]
]
#v(6pt)

// @ANCHOR:T01|v|1|ex_prob
#example-card(title: "Ví dụ minh họa (Trích từ Luyện tập SGK)")[
  Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`) . Khi đó, vectơ bằng vectơ  #mi(`\vec{AB}`)  là vectơ nào dưới đây?\nA.  #mi(`\vec{D'C'}`) \nB.  #mi(`\vec{BA}`) \nC.  #mi(`\vec{CD}`) \nD.  #mi(`\vec{B'A'}`) 

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T01|v|1|ex_sol
    Bước 1: Vectơ cần tìm bằng  #mi(`\vec{AB}`) .\nBước 2: Trong hình hộp, cạnh  #mi(`D'C'`)  song song và bằng cạnh  #mi(`AB`) .\nBước 3: Xét chiều mũi tên:  #mi(`\vec{AB}`)  hướng từ trái sang phải.  #mi(`\vec{D'C'}`)  cũng hướng từ trái sang phải. Vậy chúng cùng hướng và cùng độ dài.\nBước 4: Loại B ( #mi(`\vec{BA}`)  ngược chiều), loại C ( #mi(`\vec{CD}`)  ngược chiều), loại D ( #mi(`\vec{B'A'}`)  ngược chiều). Chọn A.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T01|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Trong ba vectơ  #mi(`\vec{BC}, \vec{CC'}`)  và  #mi(`\vec{B'B}`) , vectơ nào bằng vectơ  #mi(`\vec{AA'}`) ?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T01|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Vectơ  #mi(`\vec{AA'}`)  hướng từ dưới lên trên. Trong các vectơ đã cho,  #mi(`\vec{CC'}`)  có cùng độ dài và cùng hướng từ dưới lên trên. Vậy  #mi(`\vec{CC'} = \vec{AA'}`) .]
    #if "$\vec{CC'}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{CC'}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T01|v|1|drill|1|prompt
*Bài Bài 2.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Khẳng định nào sau đây là đúng?\nA.  #mi(`\vec{AB} = \vec{C'D'}`) \nB.  #mi(`\vec{AB} = \vec{D'C'}`) \nC.  #mi(`\vec{AB} = \vec{CD}`) \nD.  #mi(`\vec{AB} = \vec{B'A'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T01|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Trong hình hộp,  #mi(`AB`)  song song và bằng  #mi(`D'C'`) . Chiều của  #mi(`\vec{AB}`)  và  #mi(`\vec{D'C'}`)  cùng hướng. Do đó  #mi(`\vec{AB} = \vec{D'C'}`) . Chọn B.]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] So sánh độ dài các vectơ trong hình lập phương, hình hộp]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T01|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài yêu cầu so sánh độ dài của các vectơ hoặc khẳng định hai vectơ có độ dài bằng nhau, thường trong hình lập phương hoặc hình hộp chữ nhật.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T01|v|2|step|0
  - Bước 1: Nhớ lại định nghĩa: Độ dài vectơ  #mi(`|\vec{AB}|`)  chính là độ dài đoạn thẳng  #mi(`AB`) .
// @ANCHOR:T01|v|2|step|1
  - Bước 2: Xác định đoạn thẳng tương ứng với từng vectơ trong đề bài.
// @ANCHOR:T01|v|2|step|2
  - Bước 3: MẸO SO SÁNH: Nếu hai đoạn thẳng là cạnh của cùng một hình vuông/hình chữ nhật thì bằng nhau. Nếu là đường chéo của các hình vuông/hình chữ nhật có kích thước bằng nhau thì cũng bằng nhau.
// @ANCHOR:T01|v|2|step|3
  - Bước 4: Kết luận đúng/sai dựa trên việc so sánh độ dài các đoạn thẳng vừa xác định.
// @ANCHOR:T01|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Độ dài vectơ chính là độ dài đoạn thẳng nối điểm đầu và điểm cuối. Cứ quy về so sánh các đoạn thẳng hình học thông thường.
  ]
]
#v(6pt)

// @ANCHOR:T01|v|2|ex_prob
#example-card(title: "Ví dụ minh họa (Trích từ Luyện tập SGK)")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Trong các vectơ  #mi(`\vec{AC}, \vec{AD}, \vec{AD'}`) , hai vectơ nào có cùng độ dài?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T01|v|2|ex_sol
    Bước 1: Độ dài  #mi(`|\vec{AC}|`)  là độ dài đoạn  #mi(`AC`)  (đường chéo hình vuông  #mi(`ABCD`) ).\nBước 2: Độ dài  #mi(`|\vec{AD}|`)  là độ dài cạnh  #mi(`AD`) .\nBước 3: Độ dài  #mi(`|\vec{AD'}|`)  là độ dài đoạn  #mi(`AD'`)  (đường chéo hình vuông  #mi(`ADD'A'`) ).\nBước 4: Vì  #mi(`ABCD`)  và  #mi(`ADD'A'`)  là hai hình vuông có cạnh bằng nhau nên hai đường chéo  #mi(`AC`)  và  #mi(`AD'`)  bằng nhau. Vậy  #mi(`|\vec{AC}| = |\vec{AD'}|`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T01|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Khẳng định nào sau đây là đúng?\nA.  #mi(`|\vec{AB}| = |\vec{AC}|`) \nB.  #mi(`|\vec{AB}| = |\vec{CD}|`) \nC.  #mi(`|\vec{AB}| = |\vec{A'C'}|`) \nD.  #mi(`|\vec{AB}| = |\vec{AD'}|`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T01|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[ #mi(`|\vec{AB}|`)  là độ dài cạnh hình lập phương.  #mi(`|\vec{CD}|`)  cũng là độ dài cạnh hình lập phương. Do đó  #mi(`|\vec{AB}| = |\vec{CD}|`) . Các đáp án khác đều so sánh cạnh với đường chéo nên sai. Chọn B.]
    #if "B" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: B] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T01|v|2|drill|1|prompt
*Bài Bài 3.2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB = 2, AD = 3, AA' = 4`) . Tính độ dài của các vectơ  #mi(`\vec{BB'}, \vec{BD}`)  và  #mi(`\vec{BD'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T01|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[ #mi(`|\vec{BB'}| = BB' = AA' = 4`) .
 #mi(`|\vec{BD}|`)  là đường chéo hình chữ nhật  #mi(`ABCD`) :  #mi(`BD = \sqrt{AB^2 + AD^2} = \sqrt{2^2 + 3^2} = \sqrt{13}`) .
 #mi(`|\vec{BD'}|`)  là đường chéo hình hộp:  #mi(`BD' = \sqrt{BD^2 + DD'^2} = \sqrt{13 + 4^2} = \sqrt{29}`) .]
    #if "$|\vec{BB'}| = 4; |\vec{BD}| = \sqrt{13}; |\vec{BD'}| = \sqrt{29}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`|\vec{BB'}| = 4; |\vec{BD}| = \sqrt{13}; |\vec{BD'}| = \sqrt{29}`) ] ]
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
  [Bài 1.1], [Đếm số đỉnh  #mi(`n=5`) , áp dụng công thức  #mi(`n(n-1)`) .], [20],
  [Bài 1.2], [Đếm số đỉnh  #mi(`n=6`) , áp dụng công thức  #mi(`n(n-1)`) .], [30],
  [Bài 2.1], [Tìm vectơ cùng hướng và cùng độ dài với  #mi(`\vec{AA'}`) .], [ #mi(`\vec{CC'}`) ],
  [Bài 2.2], [Xét hình hộp, tìm cạnh song song và cùng chiều với  #mi(`\vec{AB}`) .], [B],
  [Bài 3.1], [So sánh độ dài các đoạn thẳng tương ứng,  #mi(`AB`)  và  #mi(`CD`)  là cạnh hình lập phương.], [B],
  [Bài 3.2], [Áp dụng định lý Pythagore cho các tam giác vuông để tính độ dài đoạn thẳng.], [ #mi(`|\vec{BB'}| = 4; |\vec{BD}| = \sqrt{13}; |\vec{BD'}| = \sqrt{29}`) ],
)

#pagebreak()

#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T02]: Phép cộng, trừ vectơ và quy tắc ba điểm, hình bình hành] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Nhận biết - Thông hiểu - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T02|theory|0
  - Quy tắc ba điểm (nối tiếp): Với ba điểm  #mi(`A, B, C`)  bất kỳ, ta luôn có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
// @ANCHOR:T02|theory|1
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (tổng hai cạnh kề bằng đường chéo).
// @ANCHOR:T02|theory|2
  - Quy tắc hiệu (chung gốc): Với ba điểm  #mi(`O, A, B`)  bất kỳ, ta có  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) .
// @ANCHOR:T02|cloze
  - *Công thức then chốt:* Quy tắc ba điểm:  #mi(`\vec{AB} + \vec{BC} = ...`) 
// @ANCHOR:T02|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Thần chú cộng vectơ: 'Nối đuôi nhau' (điểm cuối vectơ trước trùng điểm đầu vectơ sau). Thần chú trừ vectơ: 'Chung gốc lộn ngược' (lấy điểm cuối của vectơ bị trừ trừ đi điểm cuối của vectơ trừ).
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Tính tổng các vectơ liên tiếp (Quy tắc ba điểm)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T02|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một dãy các vectơ cộng lại với nhau, các điểm cuối và điểm đầu nối tiếp nhau (ví dụ  #mi(`\vec{AB} + \vec{BC} + \vec{CD}`) ).

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T02|v|0|step|0
  - Bước 1: Nhìn vào dãy vectơ, kiểm tra xem điểm cuối của vectơ trước có trùng với điểm đầu của vectơ sau không (ví dụ  #mi(`\vec{AB}`)  kết thúc bằng  #mi(`B`) ,  #mi(`\vec{BC}`)  bắt đầu bằng  #mi(`B`) ).
// @ANCHOR:T02|v|0|step|1
  - Bước 2: Gạch bỏ các điểm ở giữa (điểm  #mi(`B`)  bị gạch), giữ lại điểm đầu tiên và điểm cuối cùng. Kết quả là vectơ nối từ điểm đầu tiên đến điểm cuối cùng ( #mi(`\vec{AD}`) ).
// @ANCHOR:T02|v|0|step|2
  - Bước 3: Nếu dãy vectơ quay về điểm xuất phát ban đầu (ví dụ  #mi(`\vec{AB} + \vec{BC} + \vec{CA}`) ), thì điểm đầu và điểm cuối trùng nhau, kết quả bằng  #mi(`\overrightarrow{0}`) .
// @ANCHOR:T02|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Cứ thấy dãy cộng nối tiếp, gạch hết điểm giữa, chỉ giữ điểm đầu và điểm cuối. Nếu trùng nhau thì bằng  #mi(`\overrightarrow{0}`) .
  ]
]
#v(6pt)

// @ANCHOR:T02|v|0|ex_prob
#example-card(title: "Ví dụ 1 (Trích SGK - Câu hỏi trắc nghiệm)")[
  Cho tứ diện  #mi(`ABCD`) . Kết quả của phép cộng  #mi(`\vec{AB} + \vec{BC} + \vec{CD}`)  bằng vectơ nào dưới đây?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T02|v|0|ex_sol
    Bước 1: Ta thấy  #mi(`\vec{AB}`)  kết thúc bằng  #mi(`B`) ,  #mi(`\vec{BC}`)  bắt đầu bằng  #mi(`B`) ;  #mi(`\vec{BC}`)  kết thúc bằng  #mi(`C`) ,  #mi(`\vec{CD}`)  bắt đầu bằng  #mi(`C`) . Các điểm nối tiếp nhau hoàn hảo. Bước 2: Gạch bỏ các điểm ở giữa là  #mi(`B`)  và  #mi(`C`) . Giữ lại điểm đầu  #mi(`A`)  và điểm cuối  #mi(`D`) . Bước 3: Kết quả là  #mi(`\vec{AD}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T02|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Kết quả của phép cộng  #mi(`\vec{AB} + \vec{BC} + \vec{CC'}`)  bằng vectơ nào sau đây?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Các điểm nối tiếp:  #mi(`\vec{AB}`)  (cuối  #mi(`B`) ) +  #mi(`\vec{BC}`)  (đầu  #mi(`B`) , cuối  #mi(`C`) ) +  #mi(`\vec{CC'}`)  (đầu  #mi(`C`) ). Bước 2: Gạch bỏ  #mi(`B, C`) . Giữ lại điểm đầu  #mi(`A`)  và điểm cuối  #mi(`C'`) . Bước 3: Kết quả là  #mi(`\vec{AC'}`) .]
    #if "$\vec{AC'}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{AC'}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T02|v|0|drill|1|prompt
*Bài Bài 1.2.* Cho hình chóp  #mi(`S.ABCD`) . Kết quả của phép cộng  #mi(`\vec{SA} + \vec{AB} + \vec{BC}`)  bằng vectơ nào sau đây?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Các điểm nối tiếp:  #mi(`\vec{SA}`)  (cuối  #mi(`A`) ) +  #mi(`\vec{AB}`)  (đầu  #mi(`A`) , cuối  #mi(`B`) ) +  #mi(`\vec{BC}`)  (đầu  #mi(`B`) ). Bước 2: Gạch bỏ  #mi(`A, B`) . Giữ lại điểm đầu  #mi(`S`)  và điểm cuối  #mi(`C`) . Bước 3: Kết quả là  #mi(`\vec{SC}`) .]
    #if "$\vec{SC}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{SC}`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Tính tổng hai vectơ chung gốc (Quy tắc hình bình hành)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T02|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho hai vectơ xuất phát từ cùng một điểm (chung gốc) và yêu cầu tính tổng, thường liên quan đến hình bình hành, hình chữ nhật, hình thoi, hình lập phương.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T02|v|1|step|0
  - Bước 1: Xác định hai vectơ cần cộng có chung điểm gốc không (ví dụ  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  chung gốc  #mi(`A`) ).
// @ANCHOR:T02|v|1|step|1
  - Bước 2: Dựng hoặc nhận diện hình bình hành có hai cạnh kề là hai vectơ đó (ví dụ  #mi(`ABCD`)  là hình bình hành).
// @ANCHOR:T02|v|1|step|2
  - Bước 3: Áp dụng quy tắc hình bình hành: Tổng hai vectơ chung gốc bằng vectơ đường chéo xuất phát từ chính gốc đó ( #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) ).
// @ANCHOR:T02|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Hai vectơ chung gốc cộng lại = đường chéo hình bình hành kẻ từ gốc đó.
  ]
]
#v(6pt)

// @ANCHOR:T02|v|1|ex_prob
#example-card(title: "Ví dụ 2 (Trích SGK - Câu hỏi trắc nghiệm)")[
  Cho hình bình hành  #mi(`ABCD`)  trong không gian. Tổng  #mi(`\vec{AB} + \vec{AD}`)  bằng vectơ nào sau đây?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T02|v|1|ex_sol
    Bước 1: Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  có chung điểm gốc  #mi(`A`) . Bước 2:  #mi(`ABCD`)  đã là hình bình hành. Bước 3: Theo quy tắc hình bình hành, tổng  #mi(`\vec{AB} + \vec{AD}`)  chính là vectơ đường chéo xuất phát từ  #mi(`A`) , tức là  #mi(`\vec{AC}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T02|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình chữ nhật  #mi(`ABCD`) . Tổng  #mi(`\vec{AB} + \vec{AD}`)  bằng vectơ nào sau đây?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  chung gốc  #mi(`A`) . Bước 2: Hình chữ nhật là một hình bình hành đặc biệt. Bước 3: Áp dụng quy tắc hình bình hành,  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .]
    #if "$\vec{AC}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{AC}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T02|v|1|drill|1|prompt
*Bài Bài 2.2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tổng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`)  bằng vectơ nào sau đây?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành cho mặt đáy). Bước 2: Cộng tiếp  #mi(`\vec{AA'}`) , ta được  #mi(`\vec{AC} + \vec{AA'}`) . Bước 3: Vì  #mi(`ACC'A'`)  là hình bình hành nên  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`)  (quy tắc hình bình hành cho mặt bên).]
    #if "$\vec{AC'}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{AC'}`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Tính hiệu hai vectơ chung gốc (Quy tắc hiệu)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T02|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho phép trừ hai vectơ có chung điểm gốc (ví dụ  #mi(`\vec{AB} - \vec{AC}`) ) hoặc yêu cầu rút gọn biểu thức có dạng  #mi(`\vec{OA} - \vec{OB}`) .

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T02|v|2|step|0
  - Bước 1: Nhìn vào phép trừ, kiểm tra xem hai vectơ có chung điểm gốc (chữ cái đầu tiên) không.
// @ANCHOR:T02|v|2|step|1
  - Bước 2: Áp dụng quy tắc 'chung gốc lộn ngược':  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`)  (lấy điểm cuối của vectơ bị trừ là  #mi(`B`) , trừ đi điểm cuối của vectơ trừ là  #mi(`C`) ).
// @ANCHOR:T02|v|2|step|2
  - Bước 3: Nếu đề bài cho dạng tổng quát  #mi(`\vec{OA} - \vec{OB}`) , kết quả luôn là  #mi(`\vec{BA}`) .
// @ANCHOR:T02|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Chung gốc lộn ngược:  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`)  (chữ cuối trừ chữ cuối).
  ]
]
#v(6pt)

// @ANCHOR:T02|v|2|ex_prob
#example-card(title: "Ví dụ 3 (Trích SGK - Câu hỏi trắc nghiệm)")[
  Trong không gian, khẳng định nào sau đây là khẳng định SAI? A.  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . B.  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) . C.  #mi(`\vec{AB} - \vec{AC} = \vec{BC}`) . D.  #mi(`\vec{MA} + \vec{MB} = \overrightarrow{0}`)  (với  #mi(`M`)  là trung điểm  #mi(`AB`) ).

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T02|v|2|ex_sol
    Bước 1: Kiểm tra đáp án C, ta thấy  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  chung gốc  #mi(`A`) . Bước 2: Áp dụng quy tắc hiệu,  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) . Bước 3: Đề bài cho kết quả là  #mi(`\vec{BC}`)  nên đáp án C đã bị đảo ngược dấu, do đó C là khẳng định SAI.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T02|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho tứ diện  #mi(`ABCD`) . Mệnh đề nào dưới đây là mệnh đề đúng? A.  #mi(`\vec{BC} + \vec{AB} = \vec{DA} - \vec{DC}`) . B.  #mi(`\vec{AC} - \vec{AD} = \vec{BD} - \vec{BC}`) . C.  #mi(`\vec{AB} - \vec{AC} = \vec{DB} - \vec{DC}`) . D.  #mi(`\vec{AB} - \vec{AD} = \vec{CD} + \vec{BC}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Tính vế trái của C:  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`)  (chung gốc  #mi(`A`) ). Bước 2: Tính vế phải của C:  #mi(`\vec{DB} - \vec{DC} = \vec{CB}`)  (chung gốc  #mi(`D`) ). Bước 3: Hai vế bằng nhau nên C đúng.]
    #if "C" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: C] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T02|v|2|drill|1|prompt
*Bài Bài 3.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`\vec{AC} - \vec{AB}`)  ta được vectơ nào?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{AB}`)  chung gốc  #mi(`A`) . Bước 2: Áp dụng quy tắc hiệu,  #mi(`\vec{AC} - \vec{AB} = \vec{BC}`) . Bước 3: Vậy kết quả là  #mi(`\vec{BC}`) .]
    #if "$\vec{BC}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{BC}`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V4] Chứng minh đẳng thức vectơ (Chèn điểm, biến đổi tương đương)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T02|v|3|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề yêu cầu chứng minh một đẳng thức vectơ (VT = VP) có liên quan đến hình học không gian (tứ diện, hình hộp, hình chóp).

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T02|v|3|step|0
  - Bước 1: Chọn vế phức tạp hơn (thường là Vế trái) để biến đổi. Mục tiêu là biến đổi vế này thành vế kia.
// @ANCHOR:T02|v|3|step|1
  - Bước 2: Sử dụng kỹ thuật 'chèn điểm' (quy tắc ba điểm). Chèn một điểm bất kỳ vào giữa hai chữ cái của vectơ. Ví dụ:  #mi(`\vec{AC} = \vec{AD} + \vec{DC}`)  (chèn  #mi(`D`) ).
// @ANCHOR:T02|v|3|step|2
  - Bước 3: Gom nhóm các vectơ, sử dụng quy tắc hình bình hành hoặc tính chất vectơ đối để triệt tiêu. Nhớ mẹo:  #mi(`\vec{DC} + \vec{CD} = \overrightarrow{0}`) .
// @ANCHOR:T02|v|3|step|3
  - Bước 4: Rút gọn đến khi xuất hiện vế còn lại thì kết luận 'điều phải chứng minh (đpcm)'.
// @ANCHOR:T02|v|3|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Muốn chứng minh đẳng thức, cứ chèn điểm tùy ý vào giữa để tạo ra các vectơ giống vế bên kia, sau đó triệt tiêu các cặp vectơ ngược chiều nhau.
  ]
]
#v(6pt)

// @ANCHOR:T02|v|3|ex_prob
#example-card(title: "Ví dụ 4 (Trích SGK - Luyện tập)")[
  Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T02|v|3|ex_sol
    Bước 1: Biến đổi vế trái (VT). Bước 2: Chèn điểm  #mi(`A`)  vào vectơ  #mi(`\vec{CD}`) :  #mi(`\vec{CD} = \vec{CA} + \vec{AD}`) . Bước 3: Thay vào VT ta được:  #mi(`\vec{AB} + (\vec{CA} + \vec{AD}) = (\vec{CA} + \vec{AB}) + \vec{AD}`) . Bước 4: Theo quy tắc ba điểm,  #mi(`\vec{CA} + \vec{AB} = \vec{CB}`) . Vậy VT =  #mi(`\vec{CB} + \vec{AD} = \vec{AD} + \vec{CB}`)  = VP (đpcm).
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V4 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T02|v|3|drill|0|prompt
*Bài Bài 4.1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|3|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Biến đổi VT. Bước 2: Trong hình hộp,  #mi(`\vec{DC} = \vec{AB}`)  và  #mi(`\vec{AA'} = \vec{CC'}`) . Bước 3: Thay vào VT ta được  #mi(`\vec{BC} + \vec{AB} + \vec{CC'} = (\vec{AB} + \vec{BC}) + \vec{CC'}`) . Bước 4: Theo quy tắc ba điểm,  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) , suy ra  #mi(`\vec{AC} + \vec{CC'} = \vec{AC'}`)  = VP (đpcm).]
    #if "đpcm" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: đpcm] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T02|v|3|drill|1|prompt
*Bài Bài 4.2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{BB'} + \vec{CD} + \vec{AD} = \vec{BD'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|3|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Biến đổi VT. Bước 2: Trong hình hộp,  #mi(`\vec{CD} = \vec{BA}`)  và  #mi(`\vec{BB'} = \vec{DD'}`) . Bước 3: Thay vào VT ta được  #mi(`\vec{DD'} + \vec{BA} + \vec{AD} = \vec{DD'} + (\vec{BA} + \vec{AD})`) . Bước 4: Theo quy tắc ba điểm,  #mi(`\vec{BA} + \vec{AD} = \vec{BD}`) , suy ra  #mi(`\vec{DD'} + \vec{BD} = \vec{BD} + \vec{DD'} = \vec{BD'}`)  = VP (đpcm).]
    #if "đpcm" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: đpcm] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
#v(8pt)

// ==================== BIẾN THỂ 5 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V5] Biểu diễn một vectơ qua các vectơ khác (Phân tích vectơ)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T02|v|4|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề yêu cầu biểu diễn một vectơ (ví dụ  #mi(`\vec{AG}`) ) theo các vectơ cơ sở cho trước (ví dụ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) ).

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T02|v|4|step|0
  - Bước 1: Xác định vectơ cần biểu diễn và điểm gốc của nó. Tìm cách nối điểm gốc đó với các điểm của vectơ cơ sở.
// @ANCHOR:T02|v|4|step|1
  - Bước 2: Sử dụng quy tắc ba điểm (chèn điểm) để tạo ra các vectơ cơ sở. Ví dụ cần tạo  #mi(`\vec{AB}`)  từ điểm  #mi(`G`) , ta chèn  #mi(`A`) :  #mi(`\vec{GB} = \vec{GA} + \vec{AB}`) .
// @ANCHOR:T02|v|4|step|2
  - Bước 3: Sử dụng tính chất trọng tâm (nếu có). Trọng tâm tam giác  #mi(`ABC`) :  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \overrightarrow{0}`) . Trọng tâm tứ diện  #mi(`ABCD`) :  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \overrightarrow{0}`) .
// @ANCHOR:T02|v|4|step|3
  - Bước 4: Rút gọn biểu thức để tìm ra vectơ cần biểu diễn theo các vectơ cơ sở.
// @ANCHOR:T02|v|4|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Gặp trọng tâm, cứ viết hệ thức vectơ 0 ra, sau đó chèn điểm gốc cần tìm vào tất cả các vectơ, rồi rút gọn.
  ]
]
#v(6pt)

// @ANCHOR:T02|v|4|ex_prob
#example-card(title: "Ví dụ 5 (Trích SGK - Ví dụ mẫu)")[
  Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`BDA'`) . Biểu diễn  #mi(`\vec{AG}`)  theo  #mi(`\vec{AB}, \vec{AD}`)  và  #mi(`\vec{AA'}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T02|v|4|ex_sol
    Bước 1: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`BDA'`)  nên  #mi(`\vec{GB} + \vec{GD} + \vec{GA'} = \overrightarrow{0}`) . Bước 2: Chèn điểm  #mi(`A`)  vào các vectơ:  #mi(`(\vec{GA} + \vec{AB}) + (\vec{GA} + \vec{AD}) + (\vec{GA} + \vec{AA'}) = \overrightarrow{0}`) . Bước 3: Rút gọn ta được  #mi(`3\vec{GA} + \vec{AB} + \vec{AD} + \vec{AA'} = \overrightarrow{0}`) . Bước 4: Suy ra  #mi(`3\vec{AG} = \vec{AB} + \vec{AD} + \vec{AA'}`) , hay  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AD} + \vec{AA'})`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V5 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T02|v|4|drill|0|prompt
*Bài Bài 5.1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`BDA'`) . Biểu diễn  #mi(`\vec{CG}`)  theo  #mi(`\vec{AB}, \vec{AD}`)  và  #mi(`\vec{AA'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|4|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`G`)  là trọng tâm  #mi(`\Delta BDA'`)  nên  #mi(`\vec{GB} + \vec{GD} + \vec{GA'} = \overrightarrow{0}`) . Bước 2: Chèn điểm  #mi(`C`) :  #mi(`(\vec{GC} + \vec{CB}) + (\vec{GC} + \vec{CD}) + (\vec{GC} + \vec{CA'}) = \overrightarrow{0}`) . Bước 3: Rút gọn:  #mi(`3\vec{GC} + \vec{CB} + \vec{CD} + \vec{CA'} = \overrightarrow{0}`) . Bước 4: Ta có  #mi(`\vec{CB} = -\vec{AD}`) ,  #mi(`\vec{CD} = -\vec{AB}`) ,  #mi(`\vec{CA'} = \vec{CA} + \vec{AA'} = -\vec{AC} + \vec{AA'} = -(\vec{AB} + \vec{AD}) + \vec{AA'}`) . Thay vào:  #mi(`3\vec{GC} - \vec{AD} - \vec{AB} - \vec{AB} - \vec{AD} + \vec{AA'} = \overrightarrow{0} \Leftrightarrow 3\vec{GC} = 2\vec{AB} + 2\vec{AD} - \vec{AA'}`) . Vậy  #mi(`\vec{CG} = \frac{2}{3}\vec{AB} + \frac{2}{3}\vec{AD} - \frac{1}{3}\vec{AA'}`) .]
    #if "$\vec{CG} = \frac{2}{3}\vec{AB} + \frac{2}{3}\vec{AD} - \frac{1}{3}\vec{AA'}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{CG} = \frac{2}{3}\vec{AB} + \frac{2}{3}\vec{AD} - \frac{1}{3}\vec{AA'}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T02|v|4|drill|1|prompt
*Bài Bài 5.2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`SAB`) . Biểu diễn  #mi(`\vec{DG}`)  theo  #mi(`\vec{DA}, \vec{DC}`)  và  #mi(`\vec{DS}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T02|v|4|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`G`)  là trọng tâm  #mi(`\Delta SAB`)  nên  #mi(`\vec{GS} + \vec{GA} + \vec{GB} = \overrightarrow{0}`) . Bước 2: Chèn điểm  #mi(`D`) :  #mi(`(\vec{GD} + \vec{DS}) + (\vec{GD} + \vec{DA}) + (\vec{GD} + \vec{DB}) = \overrightarrow{0}`) . Bước 3: Rút gọn:  #mi(`3\vec{GD} + \vec{DS} + \vec{DA} + \vec{DB} = \overrightarrow{0}`) . Bước 4: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{DB} = \vec{DA} + \vec{DC}`) . Thay vào:  #mi(`3\vec{GD} + \vec{DS} + 2\vec{DA} + \vec{DC} = \overrightarrow{0} \Leftrightarrow 3\vec{DG} = \vec{DS} + 2\vec{DA} + \vec{DC}`) . Vậy  #mi(`\vec{DG} = \frac{2}{3}\vec{DA} + \frac{1}{3}\vec{DC} + \frac{1}{3}\vec{DS}`) .]
    #if "$\vec{DG} = \frac{2}{3}\vec{DA} + \frac{1}{3}\vec{DC} + \frac{1}{3}\vec{DS}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{DG} = \frac{2}{3}\vec{DA} + \frac{1}{3}\vec{DC} + \frac{1}{3}\vec{DS}`) ] ]
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
  [Bài 1.1], [Áp dụng quy tắc ba điểm nối tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) , sau đó cộng tiếp  #mi(`\vec{CC'}`) .], [ #mi(`\vec{AC'}`) ],
  [Bài 1.2], [Áp dụng quy tắc ba điểm nối tiếp:  #mi(`\vec{SA} + \vec{AB} = \vec{SB}`) , sau đó cộng tiếp  #mi(`\vec{BC}`) .], [ #mi(`\vec{SC}`) ],
  [Bài 2.1], [Áp dụng quy tắc hình bình hành cho hình chữ nhật  #mi(`ABCD`)  với hai cạnh kề  #mi(`AB, AD`) .], [ #mi(`\vec{AC}`) ],
  [Bài 2.2], [Áp dụng quy tắc hình bình hành 2 lần:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) , sau đó  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) .], [ #mi(`\vec{AC'}`) ],
  [Bài 3.1], [Sử dụng quy tắc hiệu chung gốc:  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`)  và  #mi(`\vec{DB} - \vec{DC} = \vec{CB}`) .], [C],
  [Bài 3.2], [Sử dụng quy tắc hiệu chung gốc:  #mi(`\vec{AC} - \vec{AB} = \vec{BC}`) .], [ #mi(`\vec{BC}`) ],
  [Bài 4.1], [Thay  #mi(`\vec{DC} = \vec{AB}`)  và  #mi(`\vec{AA'} = \vec{CC'}`) , sau đó nhóm  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và cộng  #mi(`\vec{CC'}`) .], [đpcm],
  [Bài 4.2], [Thay  #mi(`\vec{CD} = \vec{BA}`)  và  #mi(`\vec{BB'} = \vec{DD'}`) , sau đó nhóm  #mi(`\vec{BA} + \vec{AD} = \vec{BD}`)  và cộng  #mi(`\vec{DD'}`) .], [đpcm],
  [Bài 5.1], [Viết hệ thức trọng tâm  #mi(`\vec{GB} + \vec{GD} + \vec{GA'} = \overrightarrow{0}`) , chèn điểm  #mi(`C`)  vào các vectơ, rút gọn và thay các vectơ bằng các cạnh của hình hộp.], [ #mi(`\vec{CG} = \frac{2}{3}\vec{AB} + \frac{2}{3}\vec{AD} - \frac{1}{3}\vec{AA'}`) ],
  [Bài 5.2], [Viết hệ thức trọng tâm  #mi(`\vec{GS} + \vec{GA} + \vec{GB} = \overrightarrow{0}`) , chèn điểm  #mi(`D`)  vào các vectơ, rút gọn và thay  #mi(`\vec{DB} = \vec{DA} + \vec{DC}`) .], [ #mi(`\vec{DG} = \frac{2}{3}\vec{DA} + \frac{1}{3}\vec{DC} + \frac{1}{3}\vec{DS}`) ],
)

#pagebreak()

#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T03]: Phép nhân vectơ với một số và ứng dụng] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Thông hiểu - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T03|theory|0
  - Tích của vectơ  #mi(`\vec{a}`)  với số thực  #mi(`k`)  là một vectơ, kí hiệu  #mi(`k\vec{a}`) . Nếu  #mi(`k > 0`)  thì  #mi(`k\vec{a}`)  cùng hướng với  #mi(`\vec{a}`) ; nếu  #mi(`k < 0`)  thì  #mi(`k\vec{a}`)  ngược hướng với  #mi(`\vec{a}`) .
// @ANCHOR:T03|theory|1
  - Độ dài của vectơ  #mi(`k\vec{a}`)  bằng  #mi(`|k| \cdot |\vec{a}|`) .
// @ANCHOR:T03|theory|2
  - Điều kiện cần và đủ để hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  (với  #mi(`\vec{b} \neq \vec{0}`) ) cùng phương là có một số thực  #mi(`k`)  sao cho  #mi(`\vec{a} = k\vec{b}`) .
// @ANCHOR:T03|cloze
  - *Công thức then chốt:* Nếu  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng phương ( #mi(`\vec{b} \neq \vec{0}`) ) thì tồn tại số  #mi(`k`)  sao cho  #mi(`\vec{a} = ...`) 
// @ANCHOR:T03|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Cùng hướng thì  #mi(`k > 0`) , ngược hướng thì  #mi(`k < 0`) . Độ dài nhân với trị tuyệt đối của  #mi(`k`) .
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Chứng minh hai vectơ cùng phương, cùng hướng và tính độ dài]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T03|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho hình học (lăng trụ, chóp, tứ diện) và yêu cầu nhận xét tính cùng phương, cùng hướng hoặc chứng minh một đẳng thức vectơ có dạng  #mi(`\vec{u} = k\vec{v}`) .

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T03|v|0|step|0
  - Bước 1: Xác định mối quan hệ hình học của hai đoạn thẳng chứa hai vectơ (song song, bằng nhau, trung điểm, trọng tâm...).
// @ANCHOR:T03|v|0|step|1
  - Bước 2: Dùng tính chất đường trung bình hoặc tính chất hình bình hành để suy ra tỉ lệ độ dài và sự cùng phương. Mẹo: Đường trung bình thì song song và bằng một nửa cạnh đáy.
// @ANCHOR:T03|v|0|step|2
  - Bước 3: Xác định hướng (cùng hướng hay ngược hướng) bằng cách vẽ hình hoặc nhìn vào thứ tự các đỉnh. Nếu cùng hướng thì hệ số  #mi(`k > 0`) , ngược hướng thì  #mi(`k < 0`) .
// @ANCHOR:T03|v|0|step|3
  - Bước 4: Kết hợp tỉ lệ độ dài và dấu của  #mi(`k`)  để viết ra đẳng thức vectơ.
// @ANCHOR:T03|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy trung điểm, trung bình là nghĩ ngay đến hệ số  #mi(`1/2`)  hoặc  #mi(`2`) . Cùng chiều dương, ngược chiều âm.
  ]
]
#v(6pt)

// @ANCHOR:T03|v|0|ex_prob
#example-card(title: "Ví dụ 1 (Trích HĐ6 SGK trang 52)")[
  Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB, AC`) . a) Hai vectơ  #mi(`\vec{MN}`)  và  #mi(`\vec{B'C'}`)  có cùng phương không? Có cùng hướng không? b) Giải thích vì sao  #mi(`|\vec{MN}| = \frac{1}{2}|\vec{B'C'}|`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T03|v|0|ex_sol
    a) Vì  #mi(`MN`)  là đường trung bình của tam giác  #mi(`ABC`)  nên  #mi(`MN // BC`) . Vì  #mi(`BCC'B'`)  là hình bình hành nên  #mi(`BC // B'C'`) . Suy ra  #mi(`MN // B'C'`) . Do đó hai vectơ  #mi(`\vec{MN}`)  và  #mi(`\vec{B'C'}`)  có cùng phương. Hơn nữa, từ hình vẽ ta thấy chúng cùng hướng.\nb) Vì  #mi(`BCC'B'`)  là hình bình hành nên  #mi(`BC = B'C'`) . Vì  #mi(`MN`)  là đường trung bình của tam giác  #mi(`ABC`)  nên  #mi(`MN = \frac{1}{2}BC`) . Suy ra  #mi(`|\vec{MN}| = \frac{1}{2}|\vec{B'C'}|`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T03|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Gọi  #mi(`P, Q`)  lần lượt là trung điểm của  #mi(`BC, B'C'`) . Chứng minh rằng  #mi(`\vec{PQ} = \vec{AA'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T03|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Vì  #mi(`P`)  là trung điểm  #mi(`BC`) ,  #mi(`Q`)  là trung điểm  #mi(`B'C'`)  nên  #mi(`PQ`)  là đường trung bình của hình bình hành  #mi(`BCC'B'`) . Suy ra  #mi(`PQ // BB'`)  và  #mi(`PQ = BB'`) . Mà  #mi(`BB' // AA'`)  và  #mi(`BB' = AA'`)  (tính chất lăng trụ). Do đó  #mi(`PQ // AA'`)  và  #mi(`PQ = AA'`) . Vì hai vectơ  #mi(`\vec{PQ}`)  và  #mi(`\vec{AA'}`)  cùng hướng và cùng độ dài nên  #mi(`\vec{PQ} = \vec{AA'}`) .]
    #if "$\vec{PQ} = \vec{AA'}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{PQ} = \vec{AA'}`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Biểu diễn vectơ qua hai vectơ không cùng phương]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T03|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một hình (hình bình hành, tứ diện, hình chóp) và yêu cầu biểu diễn một vectơ (thường là vectơ nối trung điểm hoặc trọng tâm) theo hai hoặc ba vectơ cơ sở cho trước.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T03|v|1|step|0
  - Bước 1: Chọn điểm gốc (thường là điểm chung của các vectơ cơ sở) và chèn điểm theo quy tắc 3 điểm:  #mi(`\vec{AB} = \vec{AC} + \vec{CB}`) .
// @ANCHOR:T03|v|1|step|1
  - Bước 2: Đưa các vectơ trung gian về vectơ cơ sở bằng cách sử dụng tính chất trung điểm (nếu có  #mi(`M`)  là trung điểm  #mi(`AB`)  thì  #mi(`\vec{AM} = \frac{1}{2}\vec{AB}`) ) hoặc tính chất hình bình hành.
// @ANCHOR:T03|v|1|step|2
  - Bước 3: Nhóm các hệ số của từng vectơ cơ sở lại với nhau để ra biểu thức cuối cùng.
// @ANCHOR:T03|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Trung điểm thì hệ số  #mi(`1/2`) , trọng tâm tam giác thì hệ số  #mi(`1/3`) . Cứ chèn điểm thích hợp rồi thay thế.
  ]
]
#v(6pt)

// @ANCHOR:T03|v|1|ex_prob
#example-card(title: "Ví dụ 2 (Trích Ví dụ 2 SGK trang 53)")[
  Cho tứ diện  #mi(`ABCD`)  có  #mi(`G`)  là trọng tâm của tam giác  #mi(`BCD`) . Đặt  #mi(`\vec{x} = \vec{AB}, \vec{y} = \vec{AC}, \vec{z} = \vec{AD}`) . Hãy phân tích vectơ  #mi(`\vec{AG}`)  theo ba vectơ  #mi(`\vec{x}, \vec{y}, \vec{z}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T03|v|1|ex_sol
    Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`)  nên  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) . Chèn điểm  #mi(`A`)  vào ta được:  #mi(`(\vec{AB} - \vec{AG}) + (\vec{AC} - \vec{AG}) + (\vec{AD} - \vec{AG}) = \vec{0}`) . Suy ra  #mi(`\vec{AB} + \vec{AC} + \vec{AD} - 3\vec{AG} = \vec{0} \Leftrightarrow 3\vec{AG} = \vec{AB} + \vec{AC} + \vec{AD}`) . Do đó  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC} + \vec{AD}) = \frac{1}{3}(\vec{x} + \vec{y} + \vec{z})`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T03|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình chóp  #mi(`S.ABC`)  có  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) . Đặt  #mi(`\vec{a} = \vec{SA}, \vec{b} = \vec{SB}, \vec{c} = \vec{SC}`) . Biểu diễn vectơ  #mi(`\vec{SG}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T03|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Chèn điểm  #mi(`S`) :  #mi(`(\vec{SA} - \vec{SG}) + (\vec{SB} - \vec{SG}) + (\vec{SC} - \vec{SG}) = \vec{0} \Leftrightarrow \vec{SA} + \vec{SB} + \vec{SC} = 3\vec{SG}`) . Vậy  #mi(`\vec{SG} = \frac{1}{3}(\vec{a} + \vec{b} + \vec{c})`) .]
    #if "$\vec{SG} = \frac{1}{3}(\vec{a} + \vec{b} + \vec{c})$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{SG} = \frac{1}{3}(\vec{a} + \vec{b} + \vec{c})`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Tìm điểm thỏa mãn đẳng thức vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T03|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho một đẳng thức vectơ chứa điểm cần tìm (ví dụ  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) ) và yêu cầu xác định vị trí điểm đó.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T03|v|2|step|0
  - Bước 1: Chèn điểm gốc  #mi(`O`)  (thường là điểm đặc biệt của hình như trọng tâm, trung điểm) vào tất cả các vectơ trong đẳng thức.
// @ANCHOR:T03|v|2|step|1
  - Bước 2: Rút gọn đẳng thức để đưa về dạng  #mi(`k\vec{OM} = \vec{v}`)  (với  #mi(`k \neq 0`) ).
// @ANCHOR:T03|v|2|step|2
  - Bước 3: Suy ra  #mi(`\vec{OM} = \frac{1}{k}\vec{v}`) , từ đó kết luận vị trí điểm  #mi(`M`)  dựa vào vectơ  #mi(`\vec{v}`) .
// @ANCHOR:T03|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Hệ số  #mi(`k`)  chính là số lượng điểm trong tổng. Ví dụ tổng 2 điểm thì  #mi(`k=2`) , tổng 3 điểm thì  #mi(`k=3`) .
  ]
]
#v(6pt)

// @ANCHOR:T03|v|2|ex_prob
#example-card(title: "Ví dụ 3 (Trích Luyện tập 8 SGK trang 54)")[
  Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Gọi  #mi(`I`)  là điểm thuộc đoạn thẳng  #mi(`AG`)  sao cho  #mi(`AI = 3IG`) . Chứng minh rằng  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T03|v|2|ex_sol
    Theo ví dụ trước ta có  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) . Chèn điểm  #mi(`I`)  vào ta được:  #mi(`(\vec{IB} - \vec{IA}) + (\vec{IC} - \vec{IA}) + (\vec{ID} - \vec{IA}) = 3\vec{AG} \Leftrightarrow \vec{IB} + \vec{IC} + \vec{ID} - 3\vec{IA} = 3\vec{AG}`) . Vì  #mi(`AI = 3IG`)  và  #mi(`I`)  nằm giữa  #mi(`A, G`)  nên  #mi(`\vec{IA} = -3\vec{IG} \Rightarrow \vec{AG} = \vec{AI} + \vec{IG} = -\vec{IA} - \frac{1}{3}\vec{IA} = -\frac{4}{3}\vec{IA}`) . Thay vào ta được:  #mi(`\vec{IB} + \vec{IC} + \vec{ID} - 3\vec{IA} = 3(-\frac{4}{3}\vec{IA}) = -4\vec{IA} \Leftrightarrow \vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T03|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tìm điểm  #mi(`M`)  thỏa mãn  #mi(`\vec{MS} + \vec{MA} + \vec{MB} + \vec{MC} + \vec{MD} = \vec{0}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T03|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Chèn điểm  #mi(`O`) :  #mi(`(\vec{OS} - \vec{OM}) + (\vec{OA} - \vec{OM}) + (\vec{OB} - \vec{OM}) + (\vec{OC} - \vec{OM}) + (\vec{OD} - \vec{OM}) = \vec{0}`) . Vì  #mi(`O`)  là trung điểm  #mi(`AC, BD`)  nên  #mi(`\vec{OA} + \vec{OC} = \vec{0}`)  và  #mi(`\vec{OB} + \vec{OD} = \vec{0}`) . Suy ra  #mi(`\vec{OS} - 5\vec{OM} = \vec{0} \Leftrightarrow \vec{OM} = \frac{1}{5}\vec{OS}`) . Vậy  #mi(`M`)  nằm trên đoạn  #mi(`OS`)  sao cho  #mi(`OM = \frac{1}{5}OS`) .]
    #if "$\vec{OM} = \frac{1}{5}\vec{OS}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`\vec{OM} = \frac{1}{5}\vec{OS}`) ] ]
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
  [Bài 1.1], [Chứng minh  #mi(`PQ // AA'`)  và  #mi(`PQ = AA'`)  nhờ tính chất đường trung bình trong hình bình hành.], [ #mi(`\vec{PQ} = \vec{AA'}`) ],
  [Bài 2.1], [Sử dụng tính chất trọng tâm tam giác  #mi(`ABC`) :  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) , sau đó chèn điểm  #mi(`S`) .], [ #mi(`\vec{SG} = \frac{1}{3}(\vec{a} + \vec{b} + \vec{c})`) ],
  [Bài 3.1], [Chèn điểm  #mi(`O`)  là tâm hình bình hành, rút gọn các cặp vectơ đối nhau, suy ra  #mi(`\vec{OM} = \frac{1}{5}\vec{OS}`) .], [ #mi(`\vec{OM} = \frac{1}{5}\vec{OS}`) ],
)

#pagebreak()

#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T04]: Tích vô hướng của hai vectơ và ứng dụng] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Thông hiểu - Vận dụng - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T04|theory|0
  - Định nghĩa: Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là một số, kí hiệu  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) .
// @ANCHOR:T04|theory|1
  - Hệ quả: Bình phương vô hướng  #mi(`\vec{a}^2 = |\vec{a}|^2`) . Góc giữa hai vectơ:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
// @ANCHOR:T04|theory|2
  - Điều kiện vuông góc: Hai vectơ vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng 0:  #mi(`\vec{a} \perp \vec{b} \Leftrightarrow \vec{a} \cdot \vec{b} = 0`) .
// @ANCHOR:T04|cloze
  - *Công thức then chốt:* Tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) . Hai vectơ vuông góc khi  #mi(`\vec{a} \cdot \vec{b} = ...`) 
// @ANCHOR:T04|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] MẸO NHANH: Muốn tính góc hoặc tích vô hướng, hãy đưa hai vectơ về CHUNG GỐC (bằng cách chèn điểm hoặc thay thế vectơ bằng nhau). Nếu thấy hình vuông, hình lập phương, tứ diện đều -> nghĩ ngay đến các góc đặc biệt  #mi(`0^\circ, 60^\circ, 90^\circ, 120^\circ`) .
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Tính tích vô hướng và góc giữa hai vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T04|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho hình chóp, lăng trụ, tứ diện... yêu cầu tính tích vô hướng  #mi(`\vec{u} \cdot \vec{v}`)  hoặc tính góc  #mi(`(\vec{u}, \vec{v})`) .

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T04|v|0|step|0
  - Bước 1 - Đưa về chung gốc: Nhìn xem 2 vectơ đã chung gốc chưa. Nếu chưa, dùng quy tắc chèn điểm hoặc thay thế bằng vectơ bằng nhau (ví dụ:  #mi(`\vec{BC} = \vec{AD}`)  trong hình bình hành) để đưa chúng về cùng một đỉnh.
// @ANCHOR:T04|v|0|step|1
  - Bước 2 - Xác định góc: Dựa vào hình vẽ, xác định góc giữa 2 vectơ. MẸO: Nếu là hình vuông/lập phương, góc thường là  #mi(`90^\circ`) ; nếu là tam giác đều, góc là  #mi(`60^\circ`)  hoặc  #mi(`120^\circ`)  (nếu ngược hướng).
// @ANCHOR:T04|v|0|step|2
  - Bước 3 - Bấm máy tính: Nhập phép tính  #mi(`|\vec{a}| \times |\vec{b}| \times \cos(\text{góc})`)  vào máy tính Casio (chú ý chuyển máy sang chế độ Degree nếu góc có đơn vị độ).
// @ANCHOR:T04|v|0|step|3
  - Bước 4 - Kết luận: Ghi kết quả. Nếu đề hỏi góc, dùng chức năng  #mi(`\cos^{-1}`)  (SHIFT + cos) để tìm góc từ giá trị cosin vừa tính.
// @ANCHOR:T04|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy hình vuông/lập phương -> Góc  #mi(`90^\circ`)  -> Tích vô hướng bằng 0. Thấy tam giác đều -> Góc  #mi(`60^\circ`)  -> Tích vô hướng bằng nửa tích độ dài.
  ]
]
#v(6pt)

// @ANCHOR:T04|v|0|ex_prob
#example-card(title: "Ví dụ 1 (SGK - Ví dụ 10): Cho hình chóp tứ giác đều  #mi(`S.ABCD`)  có độ dài tất cả các cạnh bằng  #mi(`a`) . Tính  #mi(`\vec{AS} \cdot \vec{BC}`) .")[
  Cho hình chóp tứ giác đều  #mi(`S.ABCD`)  có độ dài tất cả các cạnh bằng  #mi(`a`) . Tính  #mi(`\vec{AS} \cdot \vec{BC}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T04|v|0|ex_sol
    Bước 1: Đưa về chung gốc. Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`\vec{BC} = \vec{AD}`) . Do đó  #mi(`\vec{AS} \cdot \vec{BC} = \vec{AS} \cdot \vec{AD}`) .\nBước 2: Xác định góc. Góc giữa  #mi(`\vec{AS}`)  và  #mi(`\vec{AD}`)  là góc  #mi(`\widehat{SAD}`) . Vì  #mi(`S.ABCD`)  là hình chóp đều và  #mi(`SA = AD = SD = a`)  nên tam giác  #mi(`SAD`)  là tam giác đều. Suy ra  #mi(`\widehat{SAD} = 60^\circ`) .\nBước 3: Bấm máy.  #mi(`\vec{AS} \cdot \vec{AD} = |\vec{AS}| \cdot |\vec{AD}| \cdot \cos 60^\circ = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .\nBước 4: Kết luận. Vậy  #mi(`\vec{AS} \cdot \vec{BC} = \frac{a^2}{2}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T04|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình chóp tứ giác đều  #mi(`S.ABCD`)  có độ dài tất cả các cạnh bằng  #mi(`a`) . Tính  #mi(`\vec{AS} \cdot \vec{CD}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T04|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`\vec{CD} = \vec{BA}`) . Suy ra  #mi(`\vec{AS} \cdot \vec{CD} = \vec{AS} \cdot \vec{BA} = -\vec{AS} \cdot \vec{AB}`) .\nBước 2: Góc giữa  #mi(`\vec{AS}`)  và  #mi(`\vec{AB}`)  là góc  #mi(`\widehat{SAB} = 60^\circ`)  (do tam giác  #mi(`SAB`)  đều).\nBước 3:  #mi(`\vec{AS} \cdot \vec{AB} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) . Vậy  #mi(`\vec{AS} \cdot \vec{CD} = -\frac{a^2}{2}`) .]
    #if "$-\frac{a^2}{2}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`-\frac{a^2}{2}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T04|v|0|drill|1|prompt
*Bài Bài 1.2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\vec{AB} \cdot \vec{AD}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T04|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  chung gốc  #mi(`A`) .\nBước 2: Vì  #mi(`ABCD`)  là hình vuông nên góc giữa chúng là  #mi(`90^\circ`) .\nBước 3:  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 90^\circ = 0`) .]
    #if "$0$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`0`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Chứng minh hai đường thẳng vuông góc]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T04|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề yêu cầu chứng minh hai đường thẳng vuông góc, hoặc chứng minh một đẳng thức vectơ có chứa tích vô hướng bằng 0.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T04|v|1|step|0
  - Bước 1 - Chọn hệ vectơ cơ sở: Chọn 3 vectơ không đồng phẳng (thường là 3 cạnh xuất phát từ một đỉnh) làm hệ cơ sở. Biểu diễn các vectơ cần chứng minh vuông góc theo hệ cơ sở này.
// @ANCHOR:T04|v|1|step|1
  - Bước 2 - Tính tích vô hướng: Thực hiện phép nhân phân phối để tính tích vô hướng của hai vectơ vừa biểu diễn. MẸO: Các cặp vectơ cơ sở thường có góc đặc biệt ( #mi(`60^\circ, 90^\circ`) ) nên tích vô hướng của chúng rất dễ tính.
// @ANCHOR:T04|v|1|step|2
  - Bước 3 - Kết luận: Nếu kết quả tích vô hướng bằng 0, ta kết luận hai đường thẳng vuông góc.
// @ANCHOR:T04|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Muốn chứng minh vuông góc, hãy biểu diễn 2 vectơ theo 3 cạnh cơ sở. Thấy tích vô hướng ra 0 là xong!
  ]
]
#v(6pt)

// @ANCHOR:T04|v|1|ex_prob
#example-card(title: "Ví dụ 2 (SGK - Ví dụ 11): Cho tứ diện  #mi(`ABCD`)  có  #mi(`AC`)  và  #mi(`BD`)  cùng vuông góc với  #mi(`AB`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB, CD`) . Chứng minh rằng  #mi(`\vec{MN} \cdot \vec{AB} = 0`) .")[
  Cho tứ diện  #mi(`ABCD`)  có  #mi(`AC`)  và  #mi(`BD`)  cùng vuông góc với  #mi(`AB`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB, CD`) . Chứng minh rằng  #mi(`\vec{MN} \cdot \vec{AB} = 0`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T04|v|1|ex_sol
    Bước 1: Chọn hệ cơ sở là  #mi(`\vec{AB}, \vec{AC}, \vec{BD}`) . Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN} = -\frac{1}{2}\vec{AB} + \vec{AC} + \frac{1}{2}\vec{CD}`) .\nMà  #mi(`\vec{CD} = \vec{CB} + \vec{BD} = (\vec{CA} + \vec{AB}) + \vec{BD} = -\vec{AC} + \vec{AB} + \vec{BD}`) .\nSuy ra  #mi(`\vec{MN} = -\frac{1}{2}\vec{AB} + \vec{AC} + \frac{1}{2}(-\vec{AC} + \vec{AB} + \vec{BD}) = \frac{1}{2}\vec{AC} + \frac{1}{2}\vec{BD}`) .\nBước 2: Tính tích vô hướng:  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(\vec{AC} + \vec{BD}) \cdot \vec{AB} = \frac{1}{2}(\vec{AC} \cdot \vec{AB} + \vec{BD} \cdot \vec{AB})`) .\nTheo giả thiết  #mi(`AC \perp AB`)  và  #mi(`BD \perp AB`)  nên  #mi(`\vec{AC} \cdot \vec{AB} = 0`)  và  #mi(`\vec{BD} \cdot \vec{AB} = 0`) .\nBước 3: Vậy  #mi(`\vec{MN} \cdot \vec{AB} = 0`)  (đpcm).
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T04|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{A'C} \cdot \vec{B'D'} = 0`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T04|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chọn hệ cơ sở  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) . Ta có  #mi(`\vec{A'C} = \vec{A'B'} + \vec{B'C'} + \vec{C'C} = \vec{AB} + \vec{AD} - \vec{AA'}`) .\nVà  #mi(`\vec{B'D'} = \vec{B'A'} + \vec{A'D'} = -\vec{AB} + \vec{AD}`) .\nBước 2: Tính tích vô hướng:  #mi(`\vec{A'C} \cdot \vec{B'D'} = (\vec{AB} + \vec{AD} - \vec{AA'}) \cdot (-\vec{AB} + \vec{AD}) = -\vec{AB}^2 + \vec{AD}^2 = -a^2 + a^2 = 0`)  (vì  #mi(`\vec{AB} \perp \vec{AD}`) ,  #mi(`\vec{AB} \perp \vec{AA'}`) ,  #mi(`\vec{AD} \perp \vec{AA'}`) ).\nBước 3: Vậy  #mi(`\vec{A'C} \cdot \vec{B'D'} = 0`)  (đpcm).]
    #if "Chứng minh $\vec{A'C} \cdot \vec{B'D'} = 0$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Chứng minh  #mi(`\vec{A'C} \cdot \vec{B'D'} = 0`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T04|v|1|drill|1|prompt
*Bài Bài 2.2.* Cho tứ diện đều  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Chứng minh rằng  #mi(`\vec{AB} \cdot \vec{DM} = 0`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T04|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chọn hệ cơ sở  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) . Ta có  #mi(`\vec{DM} = \vec{DA} + \vec{AM} = -\vec{AD} + \frac{1}{2}(\vec{AB} + \vec{AC})`) .\nBước 2: Tính tích vô hướng:  #mi(`\vec{AB} \cdot \vec{DM} = \vec{AB} \cdot (-\vec{AD} + \frac{1}{2}\vec{AB} + \frac{1}{2}\vec{AC}) = -\vec{AB} \cdot \vec{AD} + \frac{1}{2}\vec{AB}^2 + \frac{1}{2}\vec{AB} \cdot \vec{AC}`) .\nVì  #mi(`ABCD`)  là tứ diện đều cạnh  #mi(`a`)  nên  #mi(`\vec{AB} \cdot \vec{AD} = a^2 \cos 60^\circ = \frac{a^2}{2}`) ;  #mi(`\vec{AB} \cdot \vec{AC} = \frac{a^2}{2}`) .\nSuy ra  #mi(`\vec{AB} \cdot \vec{DM} = -\frac{a^2}{2} + \frac{a^2}{2} + \frac{a^2}{4} = \frac{a^2}{4} \neq 0`) .\nBước 3: Vậy  #mi(`\vec{AB} \cdot \vec{DM} \neq 0`)  (đề bài yêu cầu chứng minh vuông góc nhưng thực tế không vuông góc, học sinh cần kiểm tra lại đề hoặc tính toán cẩn thận).]
    #if "Tính toán cho thấy $\vec{AB} \cdot \vec{DM} = \frac{a^2}{4} \neq 0$." != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Tính toán cho thấy  #mi(`\vec{AB} \cdot \vec{DM} = \frac{a^2}{4} \neq 0`) .] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Tính góc giữa hai đường thẳng (Vận dụng)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T04|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho hình chóp, lăng trụ có các yếu tố vuông góc, yêu cầu tính góc giữa hai đường thẳng chéo nhau.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T04|v|2|step|0
  - Bước 1 - Chọn hệ trục tọa độ: Chọn gốc tọa độ tại một đỉnh có sẵn 3 đường vuông góc (thường là đỉnh có cạnh bên vuông góc với đáy, hoặc tâm hình vuông). Xác định tọa độ các đỉnh liên quan.
// @ANCHOR:T04|v|2|step|1
  - Bước 2 - Tìm tọa độ vectơ: Xác định tọa độ 2 vectơ chỉ phương của 2 đường thẳng cần tính góc.
// @ANCHOR:T04|v|2|step|2
  - Bước 3 - Bấm máy tính: Dùng công thức  #mi(`\cos\alpha = \frac{|\vec{u} \cdot \vec{v}|}{|\vec{u}| \cdot |\vec{v}|}`) . Bấm máy tính Casio: Nhập tử số (tổng các tích tọa độ), mẫu số (căn tổng bình phương nhân căn tổng bình phương). Dùng SHIFT + cos để ra góc.
// @ANCHOR:T04|v|2|step|3
  - Bước 4 - Kết luận: Góc giữa hai đường thẳng luôn là góc nhọn (từ  #mi(`0^\circ`)  đến  #mi(`90^\circ`) ).
// @ANCHOR:T04|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Góc giữa hai đường thẳng chéo nhau: Dùng phương pháp tọa độ hóa là nhanh nhất. Chọn hệ trục tại đỉnh có 3 cạnh vuông góc, bấm máy tính là ra.
  ]
]
#v(6pt)

// @ANCHOR:T04|v|2|ex_prob
#example-card(title: "Ví dụ 3 (SGK - Ví dụ 9): Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'D'}`) .")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'D'}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T04|v|2|ex_sol
    Bước 1: Chọn hệ trục tọa độ  #mi(`Oxyz`)  với  #mi(`A(0;0;0)`) ,  #mi(`B(a;0;0)`) ,  #mi(`D(0;a;0)`) ,  #mi(`A'(0;0;a)`) . Khi đó  #mi(`C(a;a;0)`) ,  #mi(`D'(0;a;a)`) .\nBước 2: Tọa độ vectơ:  #mi(`\vec{AC} = (a;a;0)`) ,  #mi(`\vec{A'D'} = (0;a;a)`) .\nBước 3: Bấm máy:  #mi(`\cos(\vec{AC}, \vec{A'D'}) = \frac{|a \cdot 0 + a \cdot a + 0 \cdot a|}{\sqrt{a^2+a^2} \cdot \sqrt{a^2+a^2}} = \frac{a^2}{a\sqrt{2} \cdot a\sqrt{2}} = \frac{1}{2}`) . Suy ra góc là  #mi(`60^\circ`) .\nBước 4: Vậy góc giữa  #mi(`\vec{AC}`)  và  #mi(`\vec{A'D'}`)  là  #mi(`60^\circ`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T04|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính  #mi(`\cos(\vec{BD}, \vec{A'C'})`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T04|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chọn hệ trục tọa độ với  #mi(`A(0;0;0)`) ,  #mi(`B(a;0;0)`) ,  #mi(`D(0;a;0)`) ,  #mi(`A'(0;0;a)`) . Khi đó  #mi(`C(a;a;0)`) ,  #mi(`B'(a;0;a)`) ,  #mi(`D'(0;a;a)`) ,  #mi(`C'(a;a;a)`) .\nBước 2:  #mi(`\vec{BD} = (-a;a;0)`) ,  #mi(`\vec{A'C'} = (a;a;0)`) .\nBước 3:  #mi(`\cos(\vec{BD}, \vec{A'C'}) = \frac{|-a \cdot a + a \cdot a + 0|}{\sqrt{a^2+a^2} \cdot \sqrt{a^2+a^2}} = 0`) .]
    #if "$0$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`0`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T04|v|2|drill|1|prompt
*Bài Bài 3.2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy là hình vuông cạnh  #mi(`a`) ,  #mi(`SA`)  vuông góc với đáy,  #mi(`SA = a`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`SB`) . Tính góc giữa  #mi(`AM`)  và  #mi(`BD`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T04|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chọn hệ trục tọa độ với  #mi(`A(0;0;0)`) ,  #mi(`B(a;0;0)`) ,  #mi(`D(0;a;0)`) ,  #mi(`S(0;0;a)`) . Khi đó  #mi(`C(a;a;0)`) ,  #mi(`M(\frac{a}{2};0;\frac{a}{2})`) .\nBước 2:  #mi(`\vec{AM} = (\frac{a}{2};0;\frac{a}{2})`) ,  #mi(`\vec{BD} = (-a;a;0)`) .\nBước 3:  #mi(`\cos(\vec{AM}, \vec{BD}) = \frac{|\frac{a}{2} \cdot (-a) + 0 \cdot a + \frac{a}{2} \cdot 0|}{\sqrt{\frac{a^2}{4}+\frac{a^2}{4}} \cdot \sqrt{a^2+a^2}} = \frac{|-\frac{a^2}{2}|}{\frac{a\sqrt{2}}{2} \cdot a\sqrt{2}} = \frac{1}{2}`) . Suy ra góc là  #mi(`60^\circ`) .]
    #if "$60^\circ$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`60^\circ`) ] ]
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
  [Bài 1.1], [Thay  #mi(`\vec{CD} = \vec{BA}`) , tính tích vô hướng  #mi(`\vec{AS} \cdot \vec{BA}`)  với góc  #mi(`120^\circ`) .], [ #mi(`-\frac{a^2}{2}`) ],
  [Bài 1.2], [Góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  là  #mi(`90^\circ`) , tích vô hướng bằng 0.], [ #mi(`0`) ],
  [Bài 2.1], [Chọn hệ cơ sở, biểu diễn  #mi(`\vec{A'C}`)  và  #mi(`\vec{B'D'}`) , tính tích vô hướng triệt tiêu.], [Chứng minh  #mi(`\vec{A'C} \cdot \vec{B'D'} = 0`) ],
  [Bài 2.2], [Chọn hệ cơ sở, biểu diễn  #mi(`\vec{DM}`) , tính tích vô hướng ra  #mi(`\frac{a^2}{4} \neq 0`) .], [Tính toán cho thấy  #mi(`\vec{AB} \cdot \vec{DM} = \frac{a^2}{4} \neq 0`) .],
  [Bài 3.1], [Tọa độ hóa, tính tích vô hướng của  #mi(`\vec{BD}`)  và  #mi(`\vec{A'C'}`)  bằng 0.], [ #mi(`0`) ],
  [Bài 3.2], [Tọa độ hóa, tính cosin góc giữa  #mi(`\vec{AM}`)  và  #mi(`\vec{BD}`)  bằng  #mi(`\frac{1}{2}`) .], [ #mi(`60^\circ`) ],
)

#pagebreak()

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

#pagebreak()

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

#pagebreak()

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

#pagebreak()

#align(center)[
  #if IS_TEACHER [
    #text(size: 11pt, weight: "bold", fill: rgb("#1e3a8a"))[TÀI LIỆU GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU HỌC TẬP & RÈN LUYỆN (HỌC SINH)]
  ]
  \ #v(2pt)
  #text(size: 16pt, weight: "bold", fill: rgb("#b91c1c"))[DẠNG TOÁN [T08]: Chứng minh đẳng thức vectơ và tính độ dài vectơ tổng] \
  #v(2pt)
  #text(size: 10.5pt, style: "italic", fill: rgb("#475569"))[(Mức độ: Thông hiểu - Vận dụng - Thiết kế sư phạm cho học sinh mất gốc)]
]

#v(8pt)
#block-box(
  title: "I. LÝ THUYẾT NỀN TẢNG CỐT LÕI (Dành cho học sinh mất gốc)",
  stroke-color: rgb("#2563eb"),
  fill-color: rgb("#eff6ff")
)[
// @ANCHOR:T08|theory|0
  - Quy tắc ba điểm (chèn điểm): Với ba điểm  #mi(`A, B, C`)  bất kỳ, ta luôn có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và quy tắc hiệu  #mi(`\vec{OB} - \vec{OA} = \vec{AB}`) .
// @ANCHOR:T08|theory|1
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
// @ANCHOR:T08|theory|2
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
// @ANCHOR:T08|cloze
  - *Công thức then chốt:* Để chứng minh đẳng thức vectơ, ta thường dùng quy tắc ba điểm để chèn điểm:  #mi(`\vec{AB} = \vec{AM} + \overrightarrow{...}`) 
// @ANCHOR:T08|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Thần chú chèn điểm: 'Biến đổi vế phức tạp thành vế đơn giản' bằng cách chèn điểm nối tiếp (điểm cuối vectơ trước trùng điểm đầu vectơ sau) hoặc chèn điểm chung gốc.
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Chứng minh đẳng thức vectơ bằng quy tắc ba điểm và quy tắc hình bình hành]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T08|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một đẳng thức vectơ (có thể chứa các điểm đặc biệt như trung điểm, trọng tâm) và yêu cầu chứng minh.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T08|v|0|step|0
  - Bước 1: Chọn vế phức tạp hơn (thường là vế trái) để biến đổi. Mẹo: Nhìn vào các vectơ ở vế phải để biết cần chèn điểm nào. Nếu vế phải có điểm  #mi(`A`) , ta chèn điểm  #mi(`A`)  vào các vectơ ở vế trái.
// @ANCHOR:T08|v|0|step|1
  - Bước 2: Sử dụng quy tắc ba điểm (chèn điểm) để tách các vectơ ở vế trái thành tổng hai vectơ có chứa điểm cần chèn. Ví dụ:  #mi(`\vec{MB} = \vec{MA} + \vec{AB}`) .
// @ANCHOR:T08|v|0|step|2
  - Bước 3: Nhóm các vectơ lại, sử dụng giả thiết (ví dụ:  #mi(`M`)  là trung điểm thì  #mi(`\vec{MA} + \vec{MB} = \overrightarrow{0}`) ) để triệt tiêu các vectơ đối nhau.
// @ANCHOR:T08|v|0|step|3
  - Bước 4: Thu gọn biểu thức và kết luận bằng vế phải.
// @ANCHOR:T08|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy trung điểm  #mi(`M`)  của  #mi(`AB`) : Cứ thấy  #mi(`\vec{MA}`)  và  #mi(`\vec{MB}`)  là gộp lại thành  #mi(`\overrightarrow{0}`) .
  ]
]
#v(6pt)

// @ANCHOR:T08|v|0|ex_prob
#example-card(title: "Ví dụ 1 (SGK - Trang 50)")[
  Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T08|v|0|ex_sol
    Bước 1: Chọn biến đổi vế trái  #mi(`VT = \vec{AC} + \vec{BD}`) . Ta thấy vế phải có các điểm  #mi(`A, D, B, C`)  nên ta chèn điểm  #mi(`D`)  vào  #mi(`\vec{AC}`)  và chèn điểm  #mi(`C`)  vào  #mi(`\vec{BD}`) .\nBước 2: Theo quy tắc ba điểm, ta có:  #mi(`\vec{AC} = \vec{AD} + \vec{DC}`)  và  #mi(`\vec{BD} = \vec{BC} + \vec{CD}`) .\nBước 3: Thay vào vế trái:  #mi(`VT = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD}) = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) .\nBước 4: Vì  #mi(`\vec{DC}`)  và  #mi(`\vec{CD}`)  là hai vectơ đối nhau nên  #mi(`\vec{DC} + \vec{CD} = \overrightarrow{0}`) . Do đó  #mi(`VT = \vec{AD} + \vec{BC} = VP`)  (đpcm).
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T08|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Chứng minh rằng  #mi(`\vec{SA} + \vec{SC} = \vec{SB} + \vec{SD}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T08|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chọn biến đổi vế trái  #mi(`VT = \vec{SA} + \vec{SC}`) . Chèn điểm  #mi(`B`)  vào  #mi(`\vec{SA}`)  và chèn điểm  #mi(`D`)  vào  #mi(`\vec{SC}`) .\nBước 2: Ta có  #mi(`\vec{SA} = \vec{SB} + \vec{BA}`)  và  #mi(`\vec{SC} = \vec{SD} + \vec{DC}`) .\nBước 3: Thay vào:  #mi(`VT = \vec{SB} + \vec{BA} + \vec{SD} + \vec{DC} = \vec{SB} + \vec{SD} + (\vec{BA} + \vec{DC})`) .\nBước 4: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{BA} = \vec{CD} = -\vec{DC}`) , suy ra  #mi(`\vec{BA} + \vec{DC} = \overrightarrow{0}`) . Vậy  #mi(`VT = \vec{SB} + \vec{SD} = VP`)  (đpcm).]
    #if "Đã chứng minh xong." != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh xong.] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T08|v|0|drill|1|prompt
*Bài Bài 1.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{DD'} + \vec{C'D'} = \vec{CC'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T08|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Biến đổi vế trái  #mi(`VT = \vec{AB} + \vec{DD'} + \vec{C'D'}`) .\nBước 2: Nhận thấy  #mi(`\vec{DD'} = \vec{CC'}`)  (vì  #mi(`DD'C'C`)  là hình bình hành) và  #mi(`\vec{C'D'} = \vec{CD}`)  (vì  #mi(`CDD'C'`)  là hình bình hành).\nBước 3: Thay vào:  #mi(`VT = \vec{AB} + \vec{CC'} + \vec{CD}`) .\nBước 4: Ta có  #mi(`\vec{AB} + \vec{CD} = \vec{AB} + \vec{BA} = \overrightarrow{0}`)  (vì  #mi(`ABCD`)  là hình bình hành). Vậy  #mi(`VT = \overrightarrow{0} + \vec{CC'} = \vec{CC'} = VP`)  (đpcm).]
    #if "Đã chứng minh xong." != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh xong.] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Tính độ dài vectơ tổng]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T08|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài yêu cầu tính độ dài của một vectơ tổng (ví dụ:  #mi(`|\overrightarrow{u} + \overrightarrow{v}|`)  hoặc  #mi(`|\vec{AB} + \vec{AD}|`) ).

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T08|v|1|step|0
  - Bước 1: Dùng quy tắc ba điểm hoặc quy tắc hình bình hành để thu gọn vectơ tổng thành một vectơ duy nhất có hai đầu mút cụ thể (ví dụ:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) ).
// @ANCHOR:T08|v|1|step|1
  - Bước 2: Độ dài của vectơ tổng chính là độ dài đoạn thẳng nối hai đầu mút đó (ví dụ:  #mi(`|\vec{AC}| = AC`) ).
// @ANCHOR:T08|v|1|step|2
  - Bước 3: Sử dụng định lý Pythagore trong tam giác vuông hoặc hệ thức lượng để tính độ dài đoạn thẳng đó. Mẹo: Nếu là hình lập phương cạnh  #mi(`a`) , đường chéo mặt là  #mi(`a\sqrt{2}`) , đường chéo không gian là  #mi(`a\sqrt{3}`) .
// @ANCHOR:T08|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Tổng hai cạnh kề hình chữ nhật = đường chéo. Tổng ba cạnh kề hình hộp = đường chéo không gian.
  ]
]
#v(6pt)

// @ANCHOR:T08|v|1|ex_prob
#example-card(title: "Ví dụ 2 (SGK - Trang 50)")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{BC} + \vec{DD'}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T08|v|1|ex_sol
    Bước 1: Thu gọn vectơ tổng. Ta có  #mi(`\vec{DD'} = \vec{CC'}`)  (vì  #mi(`DD'C'C`)  là hình bình hành). Suy ra  #mi(`\vec{BC} + \vec{DD'} = \vec{BC} + \vec{CC'} = \vec{BC'}`)  (quy tắc ba điểm).\nBước 2: Độ dài cần tính là  #mi(`|\vec{BC'}| = BC'`) .\nBước 3: Xét tam giác  #mi(`BCC'`)  vuông tại  #mi(`C`)  có  #mi(`BC = 1, CC' = 1`) . Theo định lý Pythagore:  #mi(`BC' = \sqrt{BC^2 + CC'^2} = \sqrt{1^2 + 1^2} = \sqrt{2}`) . Vậy  #mi(`|\vec{BC} + \vec{DD'}| = \sqrt{2}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T08|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T08|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Theo quy tắc hình hộp, ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nBước 2: Độ dài cần tính là  #mi(`|\vec{AC'}| = AC'`) .\nBước 3:  #mi(`AC'`)  là đường chéo của hình lập phương cạnh  #mi(`2`)  nên  #mi(`AC' = 2\sqrt{3}`) . Vậy độ dài là  #mi(`2\sqrt{3}`) .]
    #if "$2\sqrt{3}$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`2\sqrt{3}`) ] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T08|v|1|drill|1|prompt
*Bài Bài 2.2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB = 3, AD = 4, AA' = 12`) . Tính độ dài của vectơ  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T08|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nBước 2: Độ dài là  #mi(`AC'`) .\nBước 3: Áp dụng công thức đường chéo hình hộp chữ nhật:  #mi(`AC' = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .]
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

// ==================== BIẾN THỂ 3 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Chứng minh ba điểm thẳng hàng, đồng phẳng]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T08|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài yêu cầu chứng minh ba điểm  #mi(`A, B, C`)  thẳng hàng hoặc bốn điểm đồng phẳng.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T08|v|2|step|0
  - Bước 1: Để chứng minh  #mi(`A, B, C`)  thẳng hàng, ta cần chứng minh  #mi(`\vec{AB} = k\vec{AC}`)  (hoặc  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  cùng phương).
// @ANCHOR:T08|v|2|step|1
  - Bước 2: Sử dụng giả thiết và các quy tắc vectơ để biểu diễn  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  theo các vectơ cơ sở (thường là các cạnh của hình hộp/chóp).
// @ANCHOR:T08|v|2|step|2
  - Bước 3: So sánh hệ số của các vectơ cơ sở ở hai vế. Nếu tìm được một số  #mi(`k`)  thỏa mãn thì kết luận thẳng hàng.
// @ANCHOR:T08|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thẳng hàng: Vectơ này gấp  #mi(`k`)  lần vectơ kia. Đồng phẳng: Biểu diễn vectơ thứ 4 theo 3 vectơ không đồng phẳng còn lại.
  ]
]
#v(6pt)

// @ANCHOR:T08|v|2|ex_prob
#example-card(title: "Ví dụ 3 (SGK - Trang 59)")[
  Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`BDA'`) . Chứng minh rằng ba điểm  #mi(`A, G`)  và  #mi(`C'`)  thẳng hàng.

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T08|v|2|ex_sol
    Bước 1: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`BDA'`)  nên  #mi(`\vec{GB} + \vec{GD} + \vec{GA'} = \overrightarrow{0}`) .\nBước 2: Chèn điểm  #mi(`A`)  vào các vectơ:  #mi(`(\vec{AB} - \vec{AG}) + (\vec{AD} - \vec{AG}) + (\vec{AA'} - \vec{AG}) = \overrightarrow{0} \Leftrightarrow \vec{AB} + \vec{AD} + \vec{AA'} = 3\vec{AG}`) .\nBước 3: Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Do đó  #mi(`3\vec{AG} = \vec{AC'} \Leftrightarrow \vec{AG} = \frac{1}{3}\vec{AC'}`) .\nBước 4: Vì  #mi(`\vec{AG} = \frac{1}{3}\vec{AC'}`)  nên  #mi(`\vec{AG}`)  và  #mi(`\vec{AC'}`)  cùng phương, suy ra  #mi(`A, G, C'`)  thẳng hàng (đpcm).
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T08|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`I`)  là trung điểm của  #mi(`AB'`) . Chứng minh rằng ba điểm  #mi(`I, C, D'`)  thẳng hàng.
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T08|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Ta có  #mi(`\vec{IC} = \vec{IB'} + \vec{B'C}`)  (chèn điểm  #mi(`B'`) ).\nBước 2: Vì  #mi(`I`)  là trung điểm  #mi(`AB'`)  nên  #mi(`\vec{IB'} = \frac{1}{2}\vec{AB'}`) . Mà  #mi(`\vec{AB'} = \vec{AB} + \vec{BB'} = \vec{AB} + \vec{AA'}`) . Và  #mi(`\vec{B'C} = \vec{BC} = \vec{AD}`) .\nBước 3: Suy ra  #mi(`\vec{IC} = \frac{1}{2}(\vec{AB} + \vec{AA'}) + \vec{AD}`) .\nBước 4: Mặt khác,  #mi(`\vec{D'C} = \vec{D'A'} + \vec{A'B'} + \vec{B'C} = -\vec{AD} + \vec{AB} + \vec{AA'}`) .\nBước 5: Ta thấy  #mi(`\vec{D'C} = 2\vec{IC}`) . Vậy  #mi(`I, C, D'`)  thẳng hàng.]
    #if "Đã chứng minh xong." != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh xong.] ]
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
  [Bài 1.1], [Chèn điểm  #mi(`B`)  vào  #mi(`\vec{SA}`) , chèn điểm  #mi(`D`)  vào  #mi(`\vec{SC}`) , nhóm và triệt tiêu  #mi(`\vec{BA} + \vec{DC} = \overrightarrow{0}`) .], [Đã chứng minh xong.],
  [Bài 1.2], [Thay  #mi(`\vec{DD'} = \vec{CC'}`)  và  #mi(`\vec{C'D'} = \vec{CD}`) , nhóm  #mi(`\vec{AB} + \vec{CD} = \overrightarrow{0}`) .], [Đã chứng minh xong.],
  [Bài 2.1], [Dùng quy tắc hình hộp thu gọn thành  #mi(`\vec{AC'}`) , tính đường chéo hình lập phương cạnh  #mi(`2`) .], [ #mi(`2\sqrt{3}`) ],
  [Bài 2.2], [Dùng quy tắc hình hộp thu gọn thành  #mi(`\vec{AC'}`) , tính đường chéo hình hộp chữ nhật bằng Pythagore.], [ #mi(`13`) ],
  [Bài 3.1], [Biểu diễn  #mi(`\vec{IC}`)  và  #mi(`\vec{D'C}`)  theo các vectơ cơ sở  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) , chỉ ra  #mi(`\vec{D'C} = 2\vec{IC}`) .], [Đã chứng minh xong.],
)
