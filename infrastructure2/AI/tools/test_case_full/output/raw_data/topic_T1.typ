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
  - Vectơ trong không gian là một đoạn thẳng có hướng, được xác định bởi điểm đầu và điểm cuối. Kí hiệu:  #mi(`\vec{AB}`)  (điểm đầu  #mi(`A`) , điểm cuối  #mi(`B`) ).
// @ANCHOR:T1|theory|1
  - Độ dài của vectơ  #mi(`\vec{AB}`)  là khoảng cách giữa điểm đầu và điểm cuối, kí hiệu  #mi(`|\vec{AB}| = AB`) .
// @ANCHOR:T1|theory|2
  - Hai vectơ được gọi là bằng nhau nếu chúng cùng hướng và cùng độ dài. Vectơ đối của  #mi(`\vec{a}`)  là  #mi(`-\vec{a}`) , có cùng độ dài nhưng ngược hướng.
// @ANCHOR:T1|cloze
  - *Công thức then chốt:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng cùng ... và cùng ... .
// @ANCHOR:T1|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] MẸO NHANH: Đếm số vectơ tạo từ  #mi(`n`)  đỉnh phân biệt: lấy  #mi(`n \times (n-1)`) . Tìm vectơ bằng nhau: nhìn hình bình hành, các cạnh đối diện song song và bằng nhau thì tạo ra các vectơ bằng nhau (cùng chiều).
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Đếm số vectơ tạo thành từ các đỉnh của hình]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình không gian (tứ diện, hình hộp, hình chóp...) và hỏi có bao nhiêu vectơ (khác  #mi(`\vec{0}`) ) tạo thành từ các đỉnh.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|0|step|0
  - Bước 1: Đếm tổng số đỉnh của hình đã cho (ví dụ: tứ diện có 4 đỉnh, hình hộp có 8 đỉnh).
// @ANCHOR:T1|v|0|step|1
  - Bước 2: MẸO BẤM MÁY: Nhập số đỉnh  #mi(`n`)  vào máy tính, bấm phím  #mi(`\times`) , bấm  #mi(`(n-1)`) , bấm  #mi(`=`) . Kết quả chính là số vectơ cần tìm.
// @ANCHOR:T1|v|0|step|2
  - Bước 3: Nếu đề hỏi 'có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`) ', ta chỉ cần đếm số đỉnh còn lại (không tính  #mi(`A`) ).
// @ANCHOR:T1|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Có  #mi(`n`)  đỉnh thì có  #mi(`n(n-1)`)  vectơ khác  #mi(`\vec{0}`) . Riêng số vectơ có điểm đầu cố định là  #mi(`A`)  thì bằng  #mi(`n-1`) .
  ]
]
#v(6pt)

// @ANCHOR:T1|v|0|ex_prob
#example-card(title: "Ví dụ 1 (SGK - Trang 46)")[
  Cho tứ diện  #mi(`ABCD`)  có độ dài mỗi cạnh bằng 1. a) Có bao nhiêu vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|0|ex_sol
    Bước 1: Tứ diện có 4 đỉnh  #mi(`A, B, C, D`) .\nBước 2: Vectơ có điểm đầu là  #mi(`A`) , điểm cuối là các đỉnh còn lại. Ta đếm số đỉnh còn lại:  #mi(`B, C, D`)  là 3 đỉnh.\nBước 3: Vậy có 3 vectơ là  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V1 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|0|drill|0|prompt
*Bài Bài 1.1.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu và điểm cuối là các đỉnh của hình chóp?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|0|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Hình chóp  #mi(`S.ABCD`)  có 5 đỉnh ( #mi(`S, A, B, C, D`) ).\nBước 2: Bấm máy tính  #mi(`5 \times (5-1) = 20`) .\nBước 3: Vậy có 20 vectơ.]
    #if "20" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 20] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T1|v|0|drill|1|prompt
*Bài Bài 1.2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`) . Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một đỉnh của hình hộp?
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Hình hộp có 8 đỉnh.\nBước 2: Điểm đầu cố định là  #mi(`A`) , số đỉnh còn lại là  #mi(`8 - 1 = 7`) .\nBước 3: Vậy có 7 vectơ thỏa mãn.]
    #if "7" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: 7] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Nhận diện vectơ bằng nhau, vectơ đối qua hình vẽ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài cho một hình không gian có các cạnh song song và bằng nhau (hình hộp, lăng trụ, hình bình hành) và hỏi vectơ nào bằng vectơ đã cho.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|1|step|0
  - Bước 1: Xác định hướng của vectơ gốc (mũi tên chỉ từ đâu đến đâu).
// @ANCHOR:T1|v|1|step|1
  - Bước 2: Tìm các đoạn thẳng song song với vectơ gốc. MẸO: Trong hình hộp/lăng trụ, các cạnh bên song song và bằng nhau.
// @ANCHOR:T1|v|1|step|2
  - Bước 3: Chọn đoạn thẳng có cùng độ dài và mũi tên phải chỉ CÙNG CHIỀU với vectơ gốc. Nếu ngược chiều thì đó là vectơ đối (loại).
// @ANCHOR:T1|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Cùng hướng + cùng độ dài = Bằng nhau. Ngược hướng + cùng độ dài = Đối nhau. Chỉ cần liếc mắt xem mũi tên cùng chiều hay ngược chiều.
  ]
]
#v(6pt)

// @ANCHOR:T1|v|1|ex_prob
#example-card(title: "Ví dụ 2 (SGK - Trang 47)")[
  Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Trong ba vectơ  #mi(`\vec{BC}, \vec{CC'}`)  và  #mi(`\vec{B'B}`) , vectơ nào bằng vectơ  #mi(`\vec{AA'}`) ?

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|1|ex_sol
    Bước 1: Vectơ  #mi(`\vec{AA'}`)  hướng từ mặt đáy lên mặt trên.\nBước 2: Xét  #mi(`\vec{BC}`)  (nằm ở đáy, không cùng phương, loại). Xét  #mi(`\vec{CC'}`)  (hướng từ đáy lên, cùng phương, cùng chiều, độ dài bằng  #mi(`AA'`)  do  #mi(`ACC'A'`)  là hình bình hành). Xét  #mi(`\vec{B'B}`)  (hướng từ trên xuống, ngược chiều, loại).\nBước 3: Vậy  #mi(`\vec{CC'} = \vec{AA'}`) .
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V2 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|1|drill|0|prompt
*Bài Bài 2.1.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`) . Trong các vectơ sau, vectơ nào bằng vectơ  #mi(`\vec{AB}`) ?\nA.  #mi(`\vec{D'C'}`) \nB.  #mi(`\vec{BA}`) \nC.  #mi(`\vec{CD}`) \nD.  #mi(`\vec{B'A'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|1|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Vectơ  #mi(`\vec{AB}`)  hướng từ trái sang phải (trên mặt đáy).\nBước 2: Xét các đáp án:  #mi(`\vec{BA}`)  ngược chiều (loại).  #mi(`\vec{CD}`)  ngược chiều (loại).  #mi(`\vec{B'A'}`)  ngược chiều (loại).  #mi(`\vec{D'C'}`)  cùng phương, cùng chiều và  #mi(`D'C' = AB`)  (do  #mi(`ABCD.A'B'C'D'`)  là hình hộp).\nBước 3: Chọn A.]
    #if "A" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: A] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T1|v|1|drill|1|prompt
*Bài Bài 2.2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Vectơ đối của vectơ  #mi(`\vec{AB}`)  là vectơ nào?\nA.  #mi(`\vec{CD}`) \nB.  #mi(`\vec{BA}`) \nC.  #mi(`\vec{A'B'}`) \nD.  #mi(`\vec{D'C'}`) 
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|1|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Vectơ đối phải ngược hướng và cùng độ dài với  #mi(`\vec{AB}`) .\nBước 2:  #mi(`\vec{BA}`)  có cùng độ dài nhưng ngược hướng với  #mi(`\vec{AB}`) .\nBước 3: Chọn B.]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Xác định tính đúng/sai của các mệnh đề vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T1|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề bài đưa ra các đẳng thức vectơ và yêu cầu kiểm tra Đúng/Sai.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T1|v|2|step|0
  - Bước 1: Kiểm tra độ dài hai vế (nếu độ dài khác nhau  #mi(`\Rightarrow`)  Sai ngay).
// @ANCHOR:T1|v|2|step|1
  - Bước 2: Kiểm tra hướng (nếu ngược hướng  #mi(`\Rightarrow`)  Sai ngay).
// @ANCHOR:T1|v|2|step|2
  - Bước 3: Nếu cùng hướng và cùng độ dài  #mi(`\Rightarrow`)  Đúng.
// @ANCHOR:T1|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy dấu trừ hoặc hai vectơ ngược chiều mà không có dấu âm  #mi(`\Rightarrow`)  Sai. Thấy hai vectơ chéo nhau (không cùng phương) mà bằng nhau  #mi(`\Rightarrow`)  Sai.
  ]
]
#v(6pt)

// @ANCHOR:T1|v|2|ex_prob
#example-card(title: "Ví dụ 3 (Trích SGK - Trang 47)")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} = \vec{CD}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T1|v|2|ex_sol
    Bước 1: Độ dài  #mi(`|\vec{AB}| = |\vec{CD}|`)  (đều là cạnh hình vuông).\nBước 2: Xét hướng:  #mi(`\vec{AB}`)  hướng từ trái sang phải,  #mi(`\vec{CD}`)  hướng từ phải sang trái. Hai vectơ ngược hướng.\nBước 3: Do ngược hướng nên  #mi(`\vec{AB} \neq \vec{CD}`) . Mệnh đề Sai.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T1|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề:  #mi(`|\vec{AB}| = |\vec{C'D'}|`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`AB`)  là cạnh hình vuông,  #mi(`C'D'`)  là cạnh hình vuông.\nBước 2: Độ dài  #mi(`|\vec{AB}| = AB`) ,  #mi(`|\vec{C'D'}| = C'D'`) .\nBước 3: Vì  #mi(`AB = C'D'`)  nên mệnh đề Đúng.]
    #if "Đúng" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đúng] ]
    #v(4pt)
  ] else [
    #v(3pt)
    #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 42pt, width: 100%)[
      #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm / Đáp số:]
    ]
    #v(3pt)
  ]
// @ANCHOR:T1|v|2|drill|1|prompt
*Bài Bài 3.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} = \vec{A'B'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T1|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1:  #mi(`AB`)  và  #mi(`A'B'`)  là hai cạnh đáy của hình hộp.\nBước 2: Chúng song song, cùng chiều và có độ dài bằng nhau.\nBước 3: Vậy  #mi(`\vec{AB} = \vec{A'B'}`) . Mệnh đề Đúng.]
    #if "Đúng" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đúng] ]
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
  [Bài 1.1], [Đếm số đỉnh  #mi(`n=5`) , số vectơ là  #mi(`5 \times 4 = 20`) .], [20],
  [Bài 1.2], [Điểm đầu cố định  #mi(`A`) , số đỉnh còn lại là  #mi(`8-1=7`) .], [7],
  [Bài 2.1], [Tìm vectơ cùng hướng, cùng độ dài với  #mi(`\vec{AB}`) .], [A],
  [Bài 2.2], [Vectơ đối là vectơ ngược hướng, cùng độ dài.], [B],
  [Bài 3.1], [So sánh độ dài hai cạnh hình vuông.], [Đúng],
  [Bài 3.2], [Hai cạnh đáy hình hộp song song, cùng chiều, cùng độ dài.], [Đúng],
)
