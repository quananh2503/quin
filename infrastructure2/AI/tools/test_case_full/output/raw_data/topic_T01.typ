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
