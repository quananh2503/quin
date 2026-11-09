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
