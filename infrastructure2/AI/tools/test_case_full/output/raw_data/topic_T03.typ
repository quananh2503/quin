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
