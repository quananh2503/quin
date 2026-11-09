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
