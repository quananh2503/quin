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
  - Quy tắc ba điểm (nối tiếp): Với ba điểm  #mi(`A, B, C`)  bất kỳ, ta luôn có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
// @ANCHOR:T2|theory|1
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
// @ANCHOR:T2|theory|2
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
// @ANCHOR:T2|theory|3
  - Quy tắc hiệu (chung gốc lộn ngược): Với ba điểm  #mi(`O, A, B`)  bất kỳ, ta có  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) .
// @ANCHOR:T2|cloze
  - *Công thức then chốt:* Điền vào chỗ trống:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = ...`)  (với  #mi(`ABCD.A'B'C'D'`)  là hình hộp).
// @ANCHOR:T2|callout
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Khẩu quyết cốt lõi:] Thần chú: 'Chèn điểm liên tục, chung gốc lộn ngược, hình hộp chéo chính'.
  ]
]

#v(10pt)

#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[II. CÁC BIẾN THỂ BÀI TOÁN THỰC CHIẾN (Bộ khung hành động & Rèn luyện)]
#v(6pt)

// ==================== BIẾN THỂ 1 ====================
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V1] Tính độ dài tổng, hiệu vectơ bằng quy tắc hình hộp và hình bình hành]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T2|v|0|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho hình lập phương/hình hộp, yêu cầu tính độ dài của một tổng hoặc hiệu các vectơ.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T2|v|0|step|0
  - Bước 1: Nhìn vào biểu thức vectơ cần tính, dùng quy tắc hình hộp hoặc hình bình hành để thu gọn tổng/hiệu đó về một vectơ duy nhất có điểm đầu và điểm cuối là các đỉnh của hình.
// @ANCHOR:T2|v|0|step|1
  - Bước 2: Xác định độ dài vectơ vừa thu gọn bằng cách tìm độ dài đoạn thẳng tương ứng. Nếu là đường chéo hình vuông cạnh  #mi(`a`) , độ dài là  #mi(`a\sqrt{2}`) ; nếu là đường chéo hình lập phương cạnh  #mi(`a`) , độ dài là  #mi(`a\sqrt{3}`) .
// @ANCHOR:T2|v|0|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy hình lập phương cạnh  #mi(`a`) : Tổng 3 cạnh xuất phát từ 1 đỉnh bằng đường chéo chính  #mi(`a\sqrt{3}`) ; tổng 2 cạnh kề bằng đường chéo mặt  #mi(`a\sqrt{2}`) .
  ]
]
#v(6pt)

// @ANCHOR:T2|v|0|ex_prob
#example-card(title: "Ví dụ 1 (SGK - Ví dụ 3): Tính độ dài vectơ")[
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng 1. Tính độ dài của vectơ  #mi(`\vec{BC} + \vec{DD'}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T2|v|0|ex_sol
    Bước 1: Ta có  #mi(`\vec{DD'} = \vec{CC'}`)  (vì  #mi(`DD'C'C`)  là hình bình hành). Suy ra  #mi(`\vec{BC} + \vec{DD'} = \vec{BC} + \vec{CC'} = \vec{BC'}`)  (quy tắc ba điểm). Bước 2: Độ dài vectơ  #mi(`\vec{BC'}`)  chính là độ dài đường chéo mặt bên  #mi(`BCC'B'`)  của hình lập phương cạnh 1. Do đó  #mi(`|\vec{BC} + \vec{DD'}| = BC' = \sqrt{1^2 + 1^2} = \sqrt{2}`) .
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
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Áp dụng quy tắc hình hộp cho ba cạnh xuất phát từ đỉnh  #mi(`A`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Bước 2: Độ dài vectơ  #mi(`\vec{AC'}`)  là đường chéo chính của hình lập phương cạnh 2, nên  #mi(`|\vec{AC'}| = 2\sqrt{3}`) .]
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
*Bài Bài 1.2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng 3. Tính độ dài của vectơ  #mi(`\vec{AC} + \vec{C'D'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|0|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Ta có  #mi(`\vec{C'D'} = \vec{CD}`)  (vì  #mi(`CDD'C'`)  là hình bình hành). Suy ra  #mi(`\vec{AC} + \vec{C'D'} = \vec{AC} + \vec{CD} = \vec{AD}`)  (quy tắc ba điểm). Bước 2: Độ dài vectơ  #mi(`\vec{AD}`)  chính là cạnh của hình lập phương, nên  #mi(`|\vec{AC} + \vec{C'D'}| = AD = 3`) .]
    #if "$3$" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án:  #mi(`3`) ] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V2] Chứng minh đẳng thức vectơ bằng quy tắc ba điểm (chèn điểm)]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T2|v|1|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề yêu cầu chứng minh một đẳng thức vectơ (VT = VP) trong tứ diện hoặc hình hộp.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T2|v|1|step|0
  - Bước 1: Chọn vế phức tạp hơn (thường là Vế trái), chèn điểm (thường là điểm xuất hiện ở vế phải) vào giữa các vectơ theo quy tắc ba điểm:  #mi(`\vec{AB} = \vec{AX} + \vec{XB}`) .
// @ANCHOR:T2|v|1|step|1
  - Bước 2: Nhóm các vectơ lại với nhau, sử dụng tính chất giao hoán, kết hợp để làm xuất hiện các cặp vectơ đối nhau (tổng bằng  #mi(`\overrightarrow{0}`) ).
// @ANCHOR:T2|v|1|step|2
  - Bước 3: Thu gọn biểu thức và kết luận bằng vế phải.
// @ANCHOR:T2|v|1|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Mẹo: 'Nhìn đích để chèn điểm'. Vế phải có điểm  #mi(`D`)  thì chèn  #mi(`D`)  vào vế trái, có  #mi(`C`)  thì chèn  #mi(`C`) .
  ]
]
#v(6pt)

// @ANCHOR:T2|v|1|ex_prob
#example-card(title: "Ví dụ 2 (SGK - Ví dụ 4): Chứng minh đẳng thức vectơ")[
  Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T2|v|1|ex_sol
    Bước 1: Chèn điểm  #mi(`D`)  vào vectơ  #mi(`\vec{AC}`)  và chèn điểm  #mi(`C`)  vào vectơ  #mi(`\vec{BD}`) , ta được:  #mi(`VT = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD})`) . Bước 2: Nhóm lại:  #mi(`VT = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) . Bước 3: Vì  #mi(`\vec{DC}`)  và  #mi(`\vec{CD}`)  là hai vectơ đối nhau nên  #mi(`\vec{DC} + \vec{CD} = \overrightarrow{0}`) . Do đó  #mi(`VT = \vec{AD} + \vec{BC} = VP`)  (đpcm).
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
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Chèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`)  và chèn điểm  #mi(`B`)  vào  #mi(`\vec{CD}`) , ta có:  #mi(`VT = (\vec{AD} + \vec{DB}) + (\vec{CB} + \vec{BD})`) . Bước 2: Nhóm lại:  #mi(`VT = \vec{AD} + \vec{CB} + (\vec{DB} + \vec{BD})`) . Bước 3: Vì  #mi(`\vec{DB} + \vec{BD} = \overrightarrow{0}`)  nên  #mi(`VT = \vec{AD} + \vec{CB} = VP`)  (đpcm).]
    #if "Đã chứng minh" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh] ]
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
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Ta có  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`)  (tính chất hình bình hành). Bước 2: Thay vào vế trái:  #mi(`VT = \vec{AD} + \vec{AB} + \vec{AA'}`) . Bước 3: Áp dụng quy tắc hình hộp cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta được  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'} = VP`)  (đpcm).]
    #if "Đã chứng minh" != "" [ \ #text(weight: "bold", fill: rgb("#b91c1c"))[Đáp án: Đã chứng minh] ]
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
#text(size: 11.5pt, weight: "bold", fill: rgb("#0f766e"))[[V3] Trắc nghiệm lý thuyết tổng, hiệu vectơ]
#v(3pt)
#block-box(
  title: "BỘ KHUNG HÀNH ĐỘNG THỰC CHIẾN (Cầm tay chỉ việc)",
  stroke-color: rgb("#0f766e"),
  fill-color: rgb("#f0fdfa")
)[
// @ANCHOR:T2|v|2|rec
  *1. Dấu hiệu nhận diện (Nhìn cấu trúc đề/hình vẽ):*
  Đề cho các đẳng thức vectơ và hỏi đẳng thức nào đúng/sai.

  *2. Các bước hành động tuần tự (Tích hợp mẹo & Casio):*
// @ANCHOR:T2|v|2|step|0
  - Bước 1: Nhớ lại các quy tắc cơ bản: Quy tắc ba điểm ( #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) ), quy tắc hiệu ( #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) ), quy tắc hình bình hành ( #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) ).
// @ANCHOR:T2|v|2|step|1
  - Bước 2: Kiểm tra từng đáp án bằng cách đối chiếu với quy tắc. Chú ý bẫy sai dấu (ví dụ  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`)  chứ không phải  #mi(`\vec{BC}`) ).
// @ANCHOR:T2|v|2|tip
  #v(4pt)
  #tip-box[
    #text(weight: "bold", fill: rgb("#b45309"))[💡 Mẹo & Phản xạ nhanh:] Thấy hiệu chung gốc  #mi(`\vec{AB} - \vec{AC}`) : Điểm đầu là điểm bị trừ ( #mi(`C`) ), điểm cuối là điểm trừ ( #mi(`B`) ), kết quả là  #mi(`\vec{CB}`) .
  ]
]
#v(6pt)

// @ANCHOR:T2|v|2|ex_prob
#example-card(title: "Ví dụ 3 (Trắc nghiệm): Nhận diện đẳng thức đúng")[
  Trong không gian, khẳng định nào sau đây là SAI? A.  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . B.  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) . C.  #mi(`\vec{AB} - \vec{AC} = \vec{BC}`) . D.  #mi(`\vec{MA} + \vec{MB} = \overrightarrow{0}`)  (với  #mi(`M`)  là trung điểm  #mi(`AB`) ).

  #v(4pt)
  #text(weight: "bold", fill: rgb("#2563eb"))[Lời giải theo đúng các bước hành động trên:]
  #if IS_TEACHER [
    \ #v(2pt)
// @ANCHOR:T2|v|2|ex_sol
    Bước 1: Kiểm tra các quy tắc. A đúng (quy tắc ba điểm). B đúng (quy tắc hiệu). D đúng (tính chất trung điểm). Bước 2: Xét C, theo quy tắc hiệu chung gốc:  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) , không phải  #mi(`\vec{BC}`) . Vậy C sai.
  ] else [
    \ #v(20pt)
    #align(center)[#text(size: 9pt, style: "italic", fill: rgb("#94a3b8"))[(Học sinh áp dụng các bước hành động ở trên để hoàn thiện lời giải ra vở)]]
    #v(10pt)
  ]
]
#v(8pt)
*Bài tập rèn luyện tương tự cho V3 (Luyện phản xạ cơ bắp):*
// @ANCHOR:T2|v|2|drill|0|prompt
*Bài Bài 3.1.* Cho hình bình hành  #mi(`ABCD`) . Khẳng định nào sau đây đúng? A.  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . B.  #mi(`\vec{AB} + \vec{AD} = \vec{BD}`) . C.  #mi(`\vec{AB} - \vec{AD} = \vec{AC}`) . D.  #mi(`\vec{AB} + \vec{AC} = \vec{AD}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|2|drill|0|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Nhớ quy tắc hình bình hành: Tổng hai vectơ cạnh kề bằng vectơ đường chéo xuất phát từ đỉnh chung. Bước 2: Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Vậy đáp án A đúng.]
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
*Bài Bài 3.2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Khẳng định nào sau đây đúng? A.  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC}`) . B.  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . C.  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AB'}`) . D.  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AD'}`) .
  #if IS_TEACHER [
    #v(2pt)
// @ANCHOR:T2|v|2|drill|1|sol
    #text(fill: rgb("#15803d"), weight: "bold")[→ Lời giải:] #text(fill: rgb("#334155"))[Bước 1: Nhớ quy tắc hình hộp: Tổng ba vectơ cạnh xuất phát từ một đỉnh bằng vectơ đường chéo chính xuất phát từ đỉnh đó. Bước 2: Ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Vậy đáp án B đúng.]
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
  [Bài 1.1], [Áp dụng quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Tính độ dài đường chéo chính hình lập phương cạnh 2.], [ #mi(`2\sqrt{3}`) ],
  [Bài 1.2], [Thay  #mi(`\vec{C'D'} = \vec{CD}`) , dùng quy tắc ba điểm thu gọn về  #mi(`\vec{AD}`) . Độ dài bằng cạnh hình lập phương.], [ #mi(`3`) ],
  [Bài 2.1], [Chèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`)  và chèn điểm  #mi(`B`)  vào  #mi(`\vec{CD}`) , nhóm các cặp vectơ đối để triệt tiêu.], [Đã chứng minh],
  [Bài 2.2], [Thay  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`) , sau đó áp dụng quy tắc hình hộp.], [Đã chứng minh],
  [Bài 3.1], [Sử dụng quy tắc hình bình hành cho hình bình hành  #mi(`ABCD`) .], [A],
  [Bài 3.2], [Sử dụng quy tắc hình hộp cho hình hộp  #mi(`ABCD.A'B'C'D'`) .], [B],
)
