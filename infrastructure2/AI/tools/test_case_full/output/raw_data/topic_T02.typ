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
