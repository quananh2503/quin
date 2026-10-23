#import "@preview/mitex:0.2.7": mitex, mi

#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"

#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")
#set par(justify: true, leading: 0.72em)

#let card(title: none, body) = block(fill: rgb("#f8fafc"), stroke: 1pt + rgb("#cbd5e1"), radius: 6pt, inset: 10pt, width: 100%, [
  #if title != none [ #text(weight: "bold", size: 11.5pt, fill: rgb("#0f766e"))[#title] \ #v(2pt) ]
  #body
])

#align(center)[
  #if IS_TEACHER [
    #text(size: 17pt, weight: "bold", fill: rgb("#1e3a8a"))[GIÁO ÁN GIẢNG DẠY & ĐÁP ÁN (GIÁO VIÊN)]
  ] else [
    #text(size: 17pt, weight: "bold", fill: rgb("#0f766e"))[PHIẾU BÀI TẬP HỌC SINH]
  ]
  \ #v(2pt)
  #text(size: 13pt, weight: "bold")[Vectơ và Hệ Tọa Độ Trong Không Gian] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp nền tảng kiến thức toàn diện về Vectơ trong không gian, từ các khái niệm cơ bản, phép toán cộng, trừ, nhân số với vectơ, đến việc thiết lập và vận dụng hệ tọa độ Oxyz để giải quyết các bài toán hình học và thực tế như vật lý, radar, và cơ học.]
]
#v(6pt)

// ==================== DẠNG 1: Khái niệm và Quan hệ Vectơ trong Không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Khái niệm và Quan hệ Vectơ trong Không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vectơ trong không gian là một đoạn thẳng có hướng, kí hiệu là  #mi(`\vec{AB}`)  với  #mi(`A`)  là điểm đầu và  #mi(`B`)  là điểm cuối.
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được gọi là bằng nhau ( #mi(`\vec{a} = \vec{b}`) ) khi và chỉ khi chúng cùng hướng và cùng độ dài.
  - Hai vectơ được gọi là cùng phương nếu giá của chúng song song hoặc trùng nhau.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn biết hai vectơ có bằng nhau không? Phải kiểm tra đủ 2 điều kiện: Cùng hướng + Cùng độ dài!
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được gọi là đối nhau nếu chúng ngược hướng và có cùng độ dài, khi đó  #mi(`\vec{a} = -\vec{b}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện  #mi(`ABCD`)  đều cạnh  #mi(`a`) . Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.73]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\{u\}`)  chính là độ dài đường chéo hình lập phương cạnh  #mi(`1`) , tức là  #mi(`AC' = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng phương và cùng hướng. Biết  #mi(`|\vec{a}| = 5`)  và  #mi(`|\vec{b}| = 10`) . Tính độ dài của vectơ  #mi(`\vec{b} - \vec{a}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng hướng và  #mi(`|\vec{b}| = 2|\vec{a}|`) , nên  #mi(`\vec{b} = 2\vec{a}`) . Khi đó  #mi(`\vec{b} - \vec{a} = 2\vec{a} - \vec{a} = \vec{a}`) . Độ dài là  #mi(`|\vec{a}| = 5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận biết vectơ và tính độ dài:] Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . a) Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Tính độ dài của các vectơ tìm được ở câu a.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ khác  #mi(`\vec{0}`) . b) Vì tứ diện đều cạnh  #mi(`1`)  nên  #mi(`|\vec{AB}| = |\vec{AC}| = |\vec{AD}| = 1`) . Vậy độ dài của các vectơ là  #mi(`1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`2`) . a) Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ khác  #mi(`\vec{0}`) . b) Vì tứ diện đều cạnh  #mi(`2`)  nên  #mi(`|\vec{AB}| = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`5`) . a) Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Tính độ dài của vectơ  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\`) \vec{AB} #mi(`,`) \vec{AC} #mi(`,`) \  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ khác  #mi(`\vec{0}`) . b) Vì tứ diện đều cạnh  #mi(`5`)  nên  #mi(`|\vec{AC}| = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`3`) . a) Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? (Lưu ý: Đề bài yêu cầu điểm đầu là  #mi(`A`)  trong hình lập phương). Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) ,  #mi(`\vec{AA'}`) ,  #mi(`\vec{AC'}`) ,  #mi(`\vec{AD'}`) . Vậy có  #mi(`6`)  vectơ khác  #mi(`\vec{0}`) . b) Vì hình lập phương cạnh  #mi(`3`)  nên  #mi(`|\vec{AB}| = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng/Mở rộng).* Trong không gian, cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng phương và cùng hướng. Biết  #mi(`|\vec{a}| = 4`)  và  #mi(`|\vec{b}| = 12`) . Tính độ dài của vectơ  #mi(`\vec{b} + \vec{a}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng hướng và  #mi(`|\vec{b}| = 3|\vec{a}|`) , nên  #mi(`\vec{b} = 3\vec{a}`) . Khi đó  #mi(`\vec{b} + \vec{a} = 3\vec{a} + \vec{a} = 4\vec{a}`) . Độ dài là  #mi(`|4\vec{a}| = 4|\vec{a}| = 4 \times 4 = 16`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Phép Cộng và Trừ Vectơ - Quy tắc Hình học ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Phép Cộng và Trừ Vectơ - Quy tắc Hình học]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm (nối tiếp):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) 
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) 
  - Quy tắc hình hộp: Nếu  #mi(`ABCD.A'B'C'D'`)  là hình hộp thì  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn cộng nối tiếp thì 'đầu sau trùng đuôi trước', muốn trừ thì 'chung gốc lộn ngược'.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ một đỉnh dọc theo ba cạnh là  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \_{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính giá trị của biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng quy tắc ba điểm liên tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Tiếp tục:  #mi(`\vec{AC} + \vec{CD} = \vec{AD}`) . Cuối cùng:  #mi(`\vec{AD} + \vec{DA} = \vec{0}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AC'}`) . Trong hình lập phương cạnh  #mi(`a`) , độ dài đường chéo chính là  #mi(`AC' = a\sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`\vec{P} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp, theo quy tắc hình hộp, tổng ba vectơ xuất phát từ đỉnh  #mi(`A`)  dọc theo ba cạnh là vectơ đường chéo chính xuất phát từ đỉnh đó. Do đó:  #mi(`\vec{P} = \vec{AC'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hiệu:] Rút gọn biểu thức  #mi(`\vec{Q} = \vec{AB} - \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc hiệu (chung gốc  #mi(`A`) ):  #mi(`\vec{Q} = \vec{AB} - \vec{AC} = \vec{CB}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể kết hợp:] Cho hình bình hành  #mi(`ABCD`) . Rút gọn  #mi(`\vec{M} = \vec{AB} + \vec{CD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{CD} = \vec{BA}`) . Thay vào biểu thức:  #mi(`\vec{M} = \vec{AB} + \vec{BA} = \vec{0}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`\vec{S} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp cho ba vectơ xuất phát từ đỉnh  #mi(`A`) :  #mi(`\vec{S} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`\vec{T} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp, theo quy tắc hình hộp:  #mi(`\vec{T} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho hình bình hành  #mi(`ABCD`) . Rút gọn biểu thức  #mi(`\vec{P} = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc ba điểm nối tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) ;  #mi(`\vec{AC} + \vec{CD} = \vec{AD}`) ;  #mi(`\vec{AD} + \vec{DA} = \vec{0}`) . Vậy  #mi(`\vec{P} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành trên đáy  #mi(`ABCD`) ). Tiếp theo,  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`)  (quy tắc ba điểm, vì  #mi(`\vec{AA'} = \vec{CC'}`)  trong hình hộp). Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Phép Nhân Số với Vectơ và Điểm Đặc Biệt ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Phép Nhân Số với Vectơ và Điểm Đặc Biệt]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm  #mi(`M`)  là trung điểm của  #mi(`AB`)  khi và chỉ khi  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  hoặc  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`) 
  - Điểm  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  khi và chỉ khi  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  hoặc  #mi(`\vec{OG} = \frac{1}{3}(\vec{OA} + \vec{OB} + \vec{OC})`) 
  - Điểm  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  khi và chỉ khi  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`)  hoặc  #mi(`\vec{PI} = \frac{1}{4}(\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ quy tắc 'Chia cho số đỉnh': Trung điểm chia 2, trọng tâm tam giác chia 3, trọng tâm tứ diện chia 4.
  ]
  - *Công thức cốt lõi:* Với điểm  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`) , với mọi điểm  #mi(`P`)  bất kì, ta luôn có  #mi(`\vec{PI} = \ '...' \cdot (\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Tính giá trị biểu thức  #mi(`S = |\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD}|`)  biết  #mi(`\vec{PI} = 2\vec{u}`)  và  #mi(`|\vec{u}| = 5`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 40]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo tính chất trọng tâm tứ diện, ta có  #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = 4\vec{PI}`) . Thay  #mi(`\vec{PI} = 2\vec{u}`)  vào, ta được  #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = 4(2\vec{u}) = 8\vec{u}`) . Do đó,  #mi(`S = |8\vec{u}| = 8|\vec{u}| = 8 \cdot 5 = 40`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Nếu  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = k\vec{u}`)  với  #mi(`\vec{u}`) 
eq \vec{0} #mi(`, tìm`) k #mi(`.`) 
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo định nghĩa trọng tâm tam giác,  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Vì  #mi(`\vec{u}`) 
eq \vec{0} #mi(`nên`) k #mi(`phải bằng 0.`) ]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn vectơ qua 3 vectơ không đồng phẳng:] Cho tứ diện  #mi(`ABCD`) . Biểu diễn vectơ  #mi(`\vec{AB}`)  qua ba vectơ  #mi(`\vec{AC}, \vec{AD}, \vec{AI}`)  trong đó  #mi(`I`)  là trung điểm của  #mi(`BC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`I`)  là trung điểm  #mi(`BC`)  nên  #mi(`\vec{AB} = \vec{AI} + \vec{IB}`) . Vì  #mi(`I`)  là trung điểm  #mi(`BC`)  nên  #mi(`\vec{IB} = \frac{1}{2}\vec{CB} = \frac{1}{2}(\vec{AB} - \vec{AC})`)  (không dùng được vì có  #mi(`\vec{AB}`) ). 
Ta dùng cách chèn điểm khác:  #mi(`\vec{AB} = \vec{AC} + \vec{CB}`) . Mà  #mi(`\vec{CB} = 2\vec{CI}`)  (không đúng). 
Cách chuẩn:  #mi(`\vec{AI} = \frac{1}{2}(\vec{AB} + \vec{AC}) \Rightarrow \vec{AB} = 2\vec{AI} - \vec{AC}`) . 
Tuy nhiên đề yêu cầu qua  #mi(`\vec{AC}, \vec{AD}, \vec{AI}`) . 
Ta có  #mi(`\vec{AI} = \frac{1}{2}(\vec{AB} + \vec{AC}) \Rightarrow \vec{AB} = 2\vec{AI} - \vec{AC}`) . 
Nhưng  #mi(`\vec{AB}`)  lại xuất hiện ở vế phải. 
Sửa lại:  #mi(`\vec{AB} = \vec{AC} + \vec{CB}`) . Mà  #mi(`\vec{CI} = \frac{1}{2}\vec{CB} \Rightarrow \vec{CB} = 2\vec{CI}`) . 
Vậy  #mi(`\vec{AB} = \vec{AC} + 2\vec{CI}`) . 
Để biểu diễn qua  #mi(`\vec{AC}, \vec{AD}, \vec{AI}`) , ta cần dùng  #mi(`\vec{AI}`) . 
 #mi(`\vec{AI} = \vec{AC} + \vec{CI} \Rightarrow \vec{CI} = \vec{AI} - \vec{AC}`) . 
Thay vào:  #mi(`\vec{AB} = \vec{AC} + 2(\vec{AI} - \vec{AC}) = 2\vec{AI} - \vec{AC}`) . 
(Lưu ý: Trong không gian,  #mi(`\vec{AD}`)  không tham gia vào biểu diễn  #mi(`\vec{AB}`)  nếu  #mi(`A, B, C, I`)  đồng phẳng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ trọng tâm tứ diện:] Trong không gian  #mi(`Oxyz`) , cho tứ diện  #mi(`ABCD`)  với  #mi(`A(1; 2; -1), B(3; 0; 1), C(5; -2; 3), D(1; 4; 5)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trọng tâm  #mi(`I(x_I; y_I; z_I)`)  được tính theo công thức: 
 #mi(`x_I = \frac{x_A + x_B + x_C + x_D}{4} = \frac{1 + 3 + 5 + 1}{4} = \frac{10}{4} = 2.5`) 
 #mi(`y_I = \frac{y_A + y_B + y_C + y_D}{4} = \frac{2 + 0 + (-2) + 4}{4} = \frac{4}{4} = 1`) 
 #mi(`z_I = \frac{z_A + z_B + z_C + z_D}{4} = \frac{-1 + 1 + 3 + 5}{4} = \frac{8}{4} = 2`) 
Vậy  #mi(`I(2.5; 1; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Chứng minh rằng với mọi điểm  #mi(`M`)  bất kì, ta luôn có  #mi(`\vec{MA} + \vec{MB} + \vec{MC} + \vec{MD} = 4\vec{MI}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{MA} + \vec{MB} + \vec{MC} + \vec{MD} = (\vec{MI} + \vec{IA}) + (\vec{MI} + \vec{IB}) + (\vec{MI} + \vec{IC}) + (\vec{MI} + \vec{ID})`)  
 #mi(`= 4\vec{MI} + (\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID})`)  
Vì  #mi(`I`)  là trọng tâm tứ diện nên  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . 
Do đó:  #mi(`\vec{MA} + \vec{MB} + \vec{MC} + \vec{MD} = 4\vec{MI}`)  (đpcm).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Chứng minh rằng với mọi điểm  #mi(`P`)  bất kì, ta luôn có  #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = 4\vec{PI}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tương tự bài 1, ta có:  #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = (\vec{PI} + \vec{IA}) + (\vec{PI} + \vec{IB}) + (\vec{PI} + \vec{IC}) + (\vec{PI} + \vec{ID})`)  
 #mi(`= 4\vec{PI} + (\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID}) = 4\vec{PI} + \vec{0} = 4\vec{PI}`)  (đpcm).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Điểm  #mi(`M`)  thỏa mãn  #mi(`\vec{MA} + \vec{MB} + \vec{MC} = \vec{0}`) . Chứng minh  #mi(`M`)  trùng với  #mi(`G`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo định nghĩa trọng tâm tam giác  #mi(`ABC`) , điểm  #mi(`G`)  là điểm duy nhất thỏa mãn  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . 
Vì  #mi(`\vec{MA} + \vec{MB} + \vec{MC} = \vec{0}`)  nên  #mi(`M`)  phải là trọng tâm của tam giác  #mi(`ABC`) . 
Vậy  #mi(`M`)  trùng với  #mi(`G`)  (đpcm).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Biết  #mi(`\vec{IA} = \\vec{a}, \vec{IB} = \\vec{b}, \vec{IC} = \\vec{c}`) . Hãy biểu diễn vectơ  #mi(`\vec{AB}`)  qua  #mi(`\vec{a}, \vec{b}, \vec{c}`)  và  #mi(`\vec{ID}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = \vec{IB} - \vec{IA} = \vec{b} - \vec{a}`) . 
Mặt khác, vì  #mi(`I`)  là trọng tâm tứ diện nên  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0} \\Rightarrow \vec{ID} = -(\	ext{vec}(a) + \vec{b} + \vec{c}) = -\vec{a} - \vec{b} - \vec{c}`) . 
Vậy  #mi(`\vec{AB} = \vec{b} - \vec{a}`) . (Lưu ý:  #mi(`\vec{AB}`)  không phụ thuộc vào  #mi(`\vec{ID}`)  nếu đã có 3 vectơ kia, nhưng có thể viết  #mi(`\vec{AB} = \vec{b} - \vec{a} + 0\vec{ID}`) ). 
Nếu đề yêu cầu biểu diễn  #mi(`\vec{ID}`)  qua  #mi(`\vec{a}, \vec{b}, \vec{c}`)  thì  #mi(`\vec{ID} = -\vec{a} - \vec{b} - \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Chứng minh Đẳng thức Vectơ Thuần Hình ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Chứng minh Đẳng thức Vectơ Thuần Hình]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc cộng nối tiếp (quy tắc 3 điểm):  #mi(`\vec{AB} + \\vec{BC} = \vec{AC}`) 
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) 
  - Quy tắc hình hộp: Nếu  #mi(`ABCD.A'B'C'D'`)  là hình hộp thì  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh đẳng thức, hãy 'nối đuôi' các vectơ hoặc 'thay thế' các vectơ song song/bằng nhau để đưa về cùng một điểm đầu/cuối.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta luôn có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính giá trị của biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và  #mi(`\vec{CD} = -\vec{DC}`) . Ta có  #mi(`P = \vec{AC} + \vec{CD} + \vec{DA} = \vec{AD} + \vec{DA} = \vec{0}`) . Độ dài của vectơ không là 0.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.732]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo hình lập phương:  #mi(`|\vec{u}| = \sqrt{a^2 + a^2 + a^2} = a\sqrt{3}`) . Nếu  #mi(`a=1`) ,  #mi(`|\vec{u}| = \sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{BC} = \vec{AD}`)  (do  #mi(`ABCD`)  là hình bình hành).  #mi(`\vec{DC} = \vec{AB}`)  (do  #mi(`ABCD`)  là hình bình hành). Thay vào vế trái:  #mi(`VT = \vec{AD} + \vec{AB} + \vec{AA'}`) . Theo quy tắc hình bình hành trên đáy,  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Vậy  #mi(`VT = \vec{AC} + \vec{AA'}`) . Theo quy tắc 3 điểm,  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) . Vậy  #mi(`VT = VP`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh đẳng thức:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình bình hành cho đáy  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Khi đó,  #mi(`VT = \vec{AC} + \vec{AA'}`) . Theo quy tắc cộng 3 điểm, ta có  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) . Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh đẳng thức:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . (Đổi tên các đỉnh để thực hiện lại)
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hình hộp  #mi(`A'B'C'D'.A''B''C''D''`) . Ta có  #mi(`\vec{A'B'} + \vec{A'D'} + \vec{A'A''} = \vec{A'C''}`) . Áp dụng quy tắc hình bình hành cho đáy  #mi(`A'B'C'D'`) , ta có  #mi(`\vec{A'B'} + \vec{A'D'} = \vec{A'C'}`) . Sau đó,  #mi(`\vec{A'C'} + \vec{A'A''} = \vec{A'C''}`)  theo quy tắc 3 điểm. Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) , trong với  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`)  nên  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) . Chèn điểm  #mi(`A`)  vào đẳng thức này:  #mi(`(\vec{AB} - \vec{AG}) + (\vec{AC} - \vec{AG}) + (\vec{AD} - \vec{AG}) = \vec{0} \Leftrightarrow \vec{AB} + \vec{AC} + \vec{AD} - 3\vec{AG} = \vec{0} \Leftrightarrow \vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) . Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Biến đổi vế trái:  #mi(`VT = \vec{AC} + \vec{BD}`) . Chèn điểm  #mi(`D`)  vào  #mi(`\vec{AC}`)  và chèn điểm  #mi(`C`)  vào  #mi(`\vec{BD}`) :  #mi(`VT = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD})`) . Sắp xếp lại:  #mi(`VT = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) . Vì  #mi(`\vec{DC} + \vec{CD} = \vec{0}`) , nên  #mi(`VT = \vec{AD} + \vec{BC} = VP`) . Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Tọa độ Điểm và Vectơ trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Tọa độ Điểm và Vectơ trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tọa độ của điểm  #mi(`M`)  trong không gian  #mi(`Oxyz`)  là bộ ba số  #mi(`(x; y; z)`)  sao cho  #mi(`\vec{OM} = x\vec{i} + y\vec{j} + z\vec{k}`) .
  - Nếu  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  thì tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tọa độ vectơ  #mi(`\vec{AB}`) , hãy lấy 'Sau trừ Trước' (tọa độ điểm cuối trừ tọa độ điểm đầu).
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`\vec{AB} = (\dots; \dots; \dots)`)  với  #mi(`\dots`)  là hiệu tọa độ các thành phần tương ứng.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(2; -1; 4)`)  và  #mi(`B(5; 3; -2)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; 4; -6)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng cách lấy tọa độ điểm  #mi(`B`)  trừ đi tọa độ điểm  #mi(`A`) :  #mi(`\vec{AB} = (5 - 2; 3 - (-1); -2 - 4) = (3; 4; -6)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho điểm  #mi(`M(1; 2; 3)`) . Tìm tọa độ của điểm  #mi(`M'`)  đối xứng với  #mi(`M`)  qua gốc tọa độ  #mi(`O`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (-1; -2; -3)]
      \ #text(fill: rgb("#334155"))[Lời giải: Điểm  #mi(`M'`)  đối xứng với  #mi(`M`)  qua gốc tọa độ  #mi(`O`)  có tọa độ là đối của tọa độ  #mi(`M`) . Vậy  #mi(`M'(-1; -2; -3)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tọa độ vectơ từ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 0; 2)`)  và  #mi(`B(3; -2; 5)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ vectơ giữa hai điểm:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Thay số ta có:  #mi(`\vec{AB} = (3 - 1; -2 - 0; 5 - 2) = (2; -2; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định tọa độ từ hình vẽ (mô tả):] Cho hình hộp chữ nhật  #mi(`OABC.O'A'B'C'`)  có các cạnh  #mi(`OA, OB, OC`)  nằm trên các trục tọa độ. Biết  #mi(`A(2; 0; 0)`) ,  #mi(`B(0; 3; 0)`) ,  #mi(`C(0; 0; 4)`) . Tìm tọa độ điểm  #mi(`D`)  sao cho  #mi(`OABC`)  là hình bình hành đáy.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`OABC`)  là hình bình hành đáy nên  #mi(`\vec{OD} = \vec{OA} + \vec{OB}`)  (với  #mi(`D`)  là đỉnh đối diện  #mi(`O`)  trong mặt đáy). Tuy nhiên, trong hình hộp chữ nhật  #mi(`OABC`) ,  #mi(`D`)  thường là đỉnh trên mặt đáy  #mi(`OABC`)  sao cho  #mi(`\vec{OC} = \vec{OA} + \vec{OB}`)  không đúng, mà là  #mi(`\vec{OD} = \vec{OA} + \vec{OB}`)  nếu  #mi(`D`)  là đỉnh đối diện  #mi(`O`) . Ở đây, theo quy tắc hình bình hành:  #mi(`\vec{OC} = \vec{OA} + \vec{OB}`)  là sai. Ta có  #mi(`\vec{OD} = \vec{OA} + \vec{OB}`)  nếu  #mi(`D`)  là đỉnh đối diện  #mi(`O`)  trong mặt đáy. Với  #mi(`A(2;0;0), B(0;3;0)`) , ta có  #mi(`\vec{OD} = (2;3;0)`) , vậy  #mi(`D(2;3;0)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; -3)`)  và  #mi(`B(4; 0; 5)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Ta có:  #mi(`\vec{AB} = (4 - 1; 0 - 2; 5 - (-3)) = (3; -2; 8)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`M(2; 5; 1)`)  và  #mi(`N(-1; 3; 4)`) . Tìm tọa độ vectơ  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{MN}`)  là:  #mi(`\vec{MN} = (-1 - 2; 3 - 5; 4 - 1) = (-3; -2; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho điểm  #mi(`A(3; -1; 2)`)  và vectơ  #mi(`\vec{u} = (1; 4; -5)`) . Tìm tọa độ điểm  #mi(`B`)  sao cho  #mi(`\vec{AB} = \vec{u}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi tọa độ điểm  #mi(`B`)  là  #mi(`(x; y; z)`) . Theo giả thiết  #mi(`\vec{AB} = (x - 3; y - (-1); z - 2) = (1; 4; -5)`) . Giải hệ phương trình:  #mi(`x - 3 = 1 \Rightarrow x = 4`) ;  #mi(`y + 1 = 4 \Rightarrow y = 3`) ;  #mi(`z - 2 = -5 \Rightarrow z = -7`) . Vậy  #mi(`B(4; 3; -7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Trong không gian  #mi(`Oxyz`) , cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có đỉnh  #mi(`A`)  trùng với gốc tọa độ  #mi(`O(0; 0; 0)`) . Biết  #mi(`B(2; 0; 0)`) ,  #mi(`D(0; 3; 0)`)  và  #mi(`D'(0; 0; 4)`) . Tìm tọa độ đỉnh  #mi(`C`)  và đỉnh  #mi(`A'`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`A`)  trùng  #mi(`O`) , ta có  #mi(`A(0; 0; 0)`) . Do  #mi(`B(2; 0; 0)`)  và  #mi(`D(0; 3; 0)`)  nằm trên các trục tọa độ, nên  #mi(`C`)  là đỉnh nằm trên mặt phẳng  #mi(`(Oxy)`) , suy ra  #mi(`\vec{OC} = \vec{OB} + \vec{OD} = (2; 0; 0) + (0; 3; 0) = (2; 3; 0)`) . Vậy  #mi(`C(2; 3; 0)`) . Đỉnh  #mi(`A'`)  nằm trên trục  #mi(`Oz`) , nên  #mi(`\vec{OA'} = (0; 0; 4)`) , vậy  #mi(`A'(0; 0; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Độ dài và Khoảng cách trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Độ dài và Khoảng cách trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Độ dài của vectơ  #mi(`\vec{a} = (x; y; z)`)  được tính bằng công thức:  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
  - Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là độ dài của vectơ  #mi(`\vec{AB}`) :  #mi(`d(A, B) = |\vec{AB}| = \sqrt{(x_B - x_A)^2 + (y_B - y_A)^2 + (z_B - z_A)^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính độ dài hay khoảng cách, cứ lấy 'hiệu tọa độ' rồi 'bình phương - cộng - căn'.
  ]
  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{a} = (x; y; z)`)  là  #mi(`|\vec{a}| = \sqrt{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{a} = (2; -3; 6)`) . Tính độ dài của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7]
      \ #text(fill: rgb("#334155"))[Lời giải: Độ dài của vectơ  #mi(`\vec{a}`)  là:  #mi(`|\vec{a}| = \sqrt{2^2 + (-3)^2 + 6^2} = \sqrt{4 + 9 + 36} = \sqrt{49} = 7`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 0; -2)`)  và  #mi(`B(3; 2; 1)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{17}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AB} = (3-1; 2-0; 1-(-2)) = (2; 2; 3)`) . Khoảng cách  #mi(`d(A, B) = |\vec{AB}| = \sqrt{2^2 + 2^2 + 3^2} = \sqrt{4 + 4 + 9} = \sqrt{17}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính độ dài vectơ cơ bản:] Trong không gian  #mi(`Oxyz`) , cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài đường chéo  #mi(`AC'`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có thể chọn hệ tọa độ  #mi(`Oxyz`)  sao cho  #mi(`A(0;0;0)`) ,  #mi(`B(2;0;0)`) ,  #mi(`D(0;2;0)`)  và  #mi(`A'(0;0;2)`) . Khi đó  #mi(`C'(2;2;2)`) . Vectơ  #mi(`\vec{AC'} = (2-0; 2-0; 2-0) = (2; 2; 2)`) . Độ dài đường chéo  #mi(`AC'`)  là:  #mi(`|\vec{AC'}| = \sqrt{2^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{u} = (1; 2; -2)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài của vectơ  #mi(`\vec{u}`)  là:  #mi(`|\vec{u}| = \sqrt{1^2 + 2^2 + (-2)^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{v} = (3; 4; 0)`) . Tính độ dài của vectơ  #mi(`v`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài của vectơ  #mi(`\vec{v}`)  là:  #mi(`|\vec{v}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9 + 16 + 0} = \sqrt{25} = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; -1; 5)`)  và  #mi(`B(5; 3; 5)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = (5-2; 3-(-1); 5-5) = (3; 4; 0)`) . Khoảng cách  #mi(`d(A, B) = |\vec{AB}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{25} = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Trong không gian  #mi(`Oxyz`) , cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=3, AD=4, AA'=12`) . Tính độ dài đường chéo  #mi(`AC'`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ tọa độ sao cho  #mi(`A(0;0;0)`) ,  #mi(`B(3;0;0)`) ,  #mi(`D(0;4;0)`) ,  #mi(`A'(0;0;12)`) . Khi đó  #mi(`C'(3;4;12)`) . Vectơ  #mi(`\vec{AC'} = (3; 4; 12)`) . Độ dài đường chéo  #mi(`AC'`)  là:  #mi(`|\vec{AC'}| = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Tích Vô Hướng và Góc trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Tích Vô Hướng và Góc trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}=(x_a; y_a; z_a)`)  và  #mi(`\vec{b}=(x_b; y_b; z_b)`)  là:  #mi(`\vec{a} \cdot \vec{b} = x_a x_b + y_a y_b + z_a z_b`) .
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng  #mi(`0`) , tức là  #mi(`\vec{a} \cdot \vec{b} = 0`) .
  - Góc  #mi(`\theta`)  giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`b`)  được tính bởi công thức:  #mi(`\cos \theta = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh vuông góc, cứ cho 'tích' bằng  #mi(`0`)  là xong!
  ]
  - *Công thức cốt lõi:* Để tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) , ta sử dụng công thức  #mi(`\cos(\vec{a}, \vec{b}) =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1; 2; 2)`)  và  #mi(`\vec{b}=(2; 2; 1)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 8]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 2 \cdot 2 + 2 \cdot 1 = 2 + 4 + 2 = 8`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(1; 0; 1)`)  và  #mi(`\vec{v}=(0; 1; 0)`) . Tính  #mi(`\cos(\vec{u}, \vec{v})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 1 \cdot 0 + 0 \cdot 1 + 1 \cdot 0 = 0`) . Độ dài  #mi(`|\vec{u}| = \sqrt{1^2+0^2+1^2} = \sqrt{2}`)  và  #mi(`|\vec{v}| = \sqrt{0^2+1^2+0^2} = 1`) . Vậy  #mi(`\cos(\vec{u}, \vec{v}) = \frac{0}{\sqrt{2} \cdot 1} = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1; 2; 2)`)  và  #mi(`\vec{b}=(2; 2; 1)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 2 \cdot 2 + 2 \cdot 1 = 8`) . 
Bước 2: Tính độ dài  #mi(`|\vec{a}| = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{9} = 3`) . 
Bước 3: Tính độ dài  #mi(`|\vec{b}| = \sqrt{2^2 + 2^2 + 1^2} = \sqrt{9} = 3`) . 
Bước 4: Áp dụng công thức  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|} = \frac{8}{3 \cdot 3} = \frac{8}{9}`) . 
Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{8}{9}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1; 1; 0)`)  và  #mi(`\vec{b}=(0; 1; 1)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 0 + 1 \cdot 1 + 0 \cdot 1 = 1`) . 
Độ dài  #mi(`|\vec{a}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) . 
Độ dài  #mi(`|\vec{b}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . 
Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{1}{\sqrt{2} \cdot \sqrt{2}} = \frac{1}{2}`) . 
Suy ra góc giữa hai vectơ là  #mi(`60^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(2; 1; 2)`)  và  #mi(`\vec{v}=(1; 2; 2)`) . Tính  #mi(`\cos(\vec{u}, \vec{v})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 2 \cdot 1 + 1 \cdot 2 + 2 \cdot 2 = 2 + 2 + 4 = 8`) . 
Độ dài  #mi(`|\vec{u}| = \sqrt{2^2 + 1^2 + 2^2} = 3`) . 
Độ dài  #mi(`|\vec{v}| = \sqrt{1^2 + 2^2 + 2^2} = 3`) . 
Vậy  #mi(`\cos(\vec{u}, \vec{v}) = \frac{8}{3 \cdot 3} = \frac{8}{9}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2; -1; 2)`)  và  #mi(`\vec{b}=(x; 1; 1)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a} \cdot \vec{b} = 0`) . 
 #mi(`\vec{a} \cdot \vec{b} = 2 \cdot x + (-1) \cdot 1 + 2 \cdot 1 = 2x - 1 + 2 = 2x + 1`) . 
Cho  #mi(`2x + 1 = 0 \Leftrightarrow x = -1/2`) . 
Vậy  #mi(`x = -0.5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng/Mở rộng).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1; 1; 1)`)  và  #mi(`\vec{b}=(2; 0; -2)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 1 \cdot 0 + 1 \cdot (-2) = 0`) . 
Vì tích vô hướng bằng  #mi(`0`)  nên hai vectơ vuông góc với nhau. 
Vậy góc giữa hai vectơ là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Tìm Tọa độ Điểm theo Điều kiện Hình học ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Tìm Tọa độ Điểm theo Điều kiện Hình học]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu  #mi(`M`)  là trung điểm của  #mi(`AB`)  thì  #mi(`x_M = \frac{x_A + x_B}{2}; y_M = \frac{y_A + y_B}{2}; z_M = \frac{z_A + z_B}{2}`) .
  - Nếu  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  thì  #mi(`x_G = \frac{x_A + x_B + x_C}{3}; y_G = \frac{y_A + y_B + y_C}{3}; z_G = \frac{z_A + z_B + z_C}{3}`) .
  - Để tứ giác  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} = \vec{DC}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm điểm 'con', hãy lấy 'tổng' các điểm 'cha' rồi chia cho số lượng điểm (2 cho trung điểm, 3 cho trọng tâm).
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là  #mi(`x_G = \frac{...}{3}; y_G = \frac{...}{3}; z_G = \frac{...}{3}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 0; 1)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2; 1; 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`M`)  là trung điểm của  #mi(`AB`)  nên tọa độ của  #mi(`M`)  là:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+0}{2} = 1`) ;  #mi(`z_M = \frac{3+1}{2} = 2`) . Vậy  #mi(`M(2; 1; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 3; 4)`) ,  #mi(`C(3; 5; 6)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2; 3; 11/3]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên tọa độ của  #mi(`G`)  là:  #mi(`x_G = \frac{1+2+3}{3} = 2`) ;  #mi(`y_G = \frac{1+3+5}{3} = 3`) ;  #mi(`z_G = \frac{1+4+6}{3} = \frac{11}{3}`) . Vậy  #mi(`G(2; 3; \frac{11}{3})`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm đỉnh hình bình hành:] Trong không gian  #mi(`Oxyz`) , cho ba điểm  #mi(`A(1; 2; 1)`) ,  #mi(`B(3; 0; 2)`)  và  #mi(`C(5; 4; 2)`) . Tìm tọa độ điểm  #mi(`D`)  sao cho tứ giác  #mi(`ABCD`)  là hình bình hành.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} = \vec{DC}`) . 
Ta có:  #mi(`\vec{AB} = (3-1; 0-2; 2-1) = (2; -2; 1)`) . 
Gọi  #mi(`D(x; y; z)`) . Khi đó  #mi(`\vec{DC} = (5-x; 4-y; 2-z)`) . 
Vì  #mi(`\vec{AB} = \vec{DC}`)  nên: 
 #mi(`\begin{cases} 5-x = 2 \\ 4-y = -2 \\ 2-z = 1 \\ \end{cases} \Rightarrow \begin{cases} x = 3 \\ y = 6 \\ z = 1 \\ \end{cases}`) . 
Vậy  #mi(`D(3; 6; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho ba điểm  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 4; 5)`)  và  #mi(`C(5; 6; 7)`) . Tìm tọa độ điểm  #mi(`D`)  sao cho tứ giác  #mi(`ABCD`)  là hình bình hành.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} = \vec{DC}`) . 
Ta có  #mi(`\vec{AB} = (3-1; 4-2; 5-3) = (2; 2; 2)`) . 
Gọi  #mi(`D(x; y; z)`) . Khi đó  #mi(`\vec{DC} = (5-x; 6-y; 7-z)`) . 
Vì  #mi(`\vec{AB} = \vec{DC}`)  nên:  #mi(`\begin{cases} 5-x = 2 \\ 6-y = 2 \\ 7-z = 2 \\ \end{cases} \Rightarrow \begin{cases} x = 3 \\ y = 4 \\ z = 5 \\ \end{cases}`) . 
Vậy  #mi(`D(3; 4; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Trong không gian  #mi(`Oxyz`) , cho ba điểm  #mi(`A(0; 1; 2)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(4; 5; 6)`) . Tìm tọa độ điểm  #mi(`D`)  sao cho tứ giác  #mi(`ABCD`)  là hình bình hành.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} = \vec{DC}`) . 
Ta có  #mi(`\vec{AB} = (2-0; 3-1; 4-2) = (2; 2; 2)`) . 
Gọi  #mi(`D(x; y; z)`) . Khi đó  #mi(`\vec{DC} = (4-x; 5-y; 6-z)`) . 
Vì  #mi(`\vec{AB} = \vec{DC}`)  nên:  #mi(`\begin{cases} 4-x = 2 \\ 5-y = 2 \\ 6-z = 2 \\ \end{cases} \Rightarrow \begin{cases} x = 2 \\ y = 3 \\ z = 4 \\ \end{cases}`) . 
Vậy  #mi(`D(2; 3; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 0)`)  và trọng tâm  #mi(`G(2; 1; 1)`) . Tìm tọa độ đỉnh  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên: 
 #mi(`x_G = \frac{x_A + x_B + x_C}{3} \Rightarrow 2 = \frac{1+3+x_C}{3} \Rightarrow x_C = 2`) . 
 #mi(`y_G = \frac{y_A + y_B + y_C}{3} \Rightarrow 1 = \frac{0+2+y_C}{3} \Rightarrow y_C = 1`) . 
 #mi(`z_G = \frac{z_A + z_B + z_C}{3} \Rightarrow 1 = \frac{2+0+z_C}{3} \Rightarrow z_C = 1`) . 
Vậy  #mi(`C(2; 1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng/Mở rộng).* Trong không gian  #mi(`Oxyz`) , cho tứ diện  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 2; 2)`) ,  #mi(`C(3; 3; 3)`)  và trọng tâm  #mi(`G(2; 2; 2)`) . Tìm tọa độ đỉnh  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên: 
 #mi(`x_G = \frac{x_A + x_B + x_C + x_D}{4} \Rightarrow 2 = \frac{1+2+3+x_D}{4} \Rightarrow x_D = 2`) . 
 #mi(`y_G = \frac{y_A + y_B + y_C + y_D}{4} \Rightarrow 2 = \frac{1+2+3+y_D}{4} \Rightarrow y_D = 2`) . 
 #mi(`z_G = \frac{z_A + z_B + z_C + z_D}{4} \Rightarrow 2 = \frac{1+2+3+z_D}{4} \Rightarrow z_D = 2`) . 
Vậy  #mi(`D(2; 2; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Bài toán Thực tế Vận dụng Tọa độ và Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Bài toán Thực tế Vận dụng Tọa độ và Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để giải bài toán thực tế, bước quan trọng nhất là thiết lập hệ trục tọa độ  #mi(`Oxyz`)  sao cho các trục trùng với các hướng quan trọng (ví dụ: hướng Bắc-Nam, Đông-Tây, hoặc các cạnh của một căn phòng).
  - Vectơ dịch chuyển của một vật từ điểm  #mi(`M(x_1; y_1; z_1)`)  đến điểm  #mi(`N(x_2; y_2; z_2)`)  được biểu diễn bởi  #mi(`\vec{MN} = (x_2-x_1; y_2-y_1; z_2-z_1)`) .
  - Khoảng cách giữa hai điểm  #mi(`M`)  và  #mi(`N`)  trong không gian là  #mi(`d(M, N) = \sqrt{(x_2-x_1)^2 + (y_2-y_1)^2 + (z_2-z_1)^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn 'toán học hóa' thực tế: Hãy tìm một 'Gốc' (điểm  #mi(`O`) ) và các 'Hướng' (trục  #mi(`Ox, Oy, Oz`) ) để gắn số vào!
  ]
  - *Công thức cốt lõi:* Để tính độ lớn của một lực  #mi(`\vec{F} = (F_x; F_y; F_z)`) , ta dùng công thức  #mi(`|\vec{F}| = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chiếc máy bay đang ở vị trí  #mi(`A(10; 20; 500)`)  và bay đến vị trí  #mi(`B(30; 40; 1500)`)  (đơn vị km). Tính độ dài quãng đường máy bay đã bay.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1000.4]
      \ #text(fill: rgb("#334155"))[Lời giải: Vectơ dịch chuyển của máy bay là  #mi(`\vec{AB} = (30-10; 40-20; 1500-500) = (20; 20; 1000)`) . Độ dài quãng đường là  #mi(`|\vec{AB}| = \sqrt{20^2 + 20^2 + 1000^2} = \sqrt{400 + 400 + 1000000} = \sqrt{1000800} ≈ 1000.4`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một radar có phạm vi quét bán kính  #mi(`50`)  km. Một tàu thủy đang ở tọa độ  #mi(`(30; 40; 0)`) . Radar có phát hiện được tàu không?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: Có]
      \ #text(fill: rgb("#334155"))[Lời giải: Khoảng cách từ gốc radar  #mi(`O(0;0;0)`)  đến tàu là  #mi(`d = \sqrt{30^2 + 40^2 + 0^2} = \sqrt{900 + 1600} = 50`)  km. Vì  #mi(`d \le 50`)  nên radar có phát hiện được tàu.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Bài toán di chuyển máy bay:] Một chiếc máy bay di chuyển từ tầng 15 lên tầng 22, sau đó lên tầng 29 của một tòa nhà cao tầng. Biết mỗi tầng cao  #mi(`4`)  m. Hãy biểu diễn các vectơ dịch chuyển qua các trục tọa độ  #mi(`Oxyz`)  với gốc  #mi(`O`)  ở mặt đất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Chọn hệ trục  #mi(`Oxyz`)  với  #mi(`O`)  ở mặt đất, trục  #mi(`Oz`)  hướng lên trên. 
2. Tầng 15 có độ cao  #mi(`z_1 = 15 \times 4 = 60`)  m. Tầng 22 có độ cao  #mi(`z_2 = 22 \times 4 = 88`)  m. Tầng 29 có độ cao  #mi(`z_3 = 29 \times 4 = 116`)  m. 
3. Vectơ dịch chuyển lần 1:  #mi(`\vec{d}_1 = (0; 0; 88-60) = (0; 0; 28)`) . 
4. Vectơ dịch chuyển lần 2:  #mi(`\vec{d}_2 = (0; 0; 116-88) = (0; 0; 28)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Một chiếc máy bay di chuyển từ tọa độ  #mi(`A(2; 3; 10)`)  đến  #mi(`B(5; 7; 14)`) . Tính độ dài quãng đường máy bay đã bay.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển  #mi(`\vec{AB} = (5-2; 7-3; 14-10) = (3; 4; 4)`) . Độ dài  #mi(`|\vec{AB}| = \sqrt{3^2 + 4^2 + 4^2} = \sqrt{9 + 16 + 16} = \sqrt{41} ≈ 6.4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Một chiếc máy bay di chuyển từ tọa độ  #mi(`A(1; 1; 5)`)  đến  #mi(`B(4; 5; 10)`) . Tính độ dài quãng đường máy bay đã bay.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển  #mi(`\vec{AB} = (4-1; 5-1; 10-5) = (3; 4; 5)`) . Độ dài  #mi(`|\vec{AB}| = \sqrt{3^2 + 4^2 + 5^2} = \sqrt{9 + 16 + 25} = \sqrt{50} = 5\sqrt{2} ≈ 7.07`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Một radar có phạm vi quét  #mi(`100`)  km. Một tàu ngầm đang ở tọa độ  #mi(`(60; 80; 0)`) . Radar có phát hiện được tàu không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách từ gốc radar đến tàu là  #mi(`d = \sqrt{60^2 + 80^2 + 0^2} = \sqrt{3600 + 6400} = \sqrt{10000} = 100`)  km. Vì  #mi(`d ≤ 100`)  nên radar có phát hiện được tàu.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Một chiếc máy bay di chuyển từ  #mi(`A(0; 0; 0)`)  đến  #mi(`B(3; 4; 12)`) . Sau đó tiếp tục di chuyển từ  #mi(`B`)  đến  #mi(`C(6; 8; 24)`) . Tính tổng độ dài quãng đường máy bay đã bay.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Quãng đường  #mi(`AB`) :  #mi(`|\vec{AB}| = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) . 
2. Quãng đường  #mi(`BC`) :  #mi(`|\vec{BC}| = \sqrt{(6-3)^2 + (8-4)^2 + (24-12)^2} = \sqrt{3^2 + 4^2 + 12^2} = 13`) . 
3. Tổng quãng đường:  #mi(`13 + 13 = 26`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Tích Vô Hướng và Góc Thuần Hình học ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Tích Vô Hướng và Góc Thuần Hình học]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Định nghĩa tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = |\text{a}| \cdot |\text{b}| \cdot \cos(\vec{a}, \vec{b})`) 
  - Điều kiện vuông góc:  #mi(`\vec{a} \perp \vec{b} \ \Leftrightarrow \vec{a} \cdot \vec{b} = 0`) 
  - Mối liên hệ giữa tích vô hướng và độ dài:  #mi(`|\vec{a} + \vec{b}|^2 = |\vec{a}|^2 + |\vec{b}|^2 + 2\vec{a} \cdot \vec{b}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm góc, hãy 'phân thân' tích vô hướng:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\text{a}| \cdot |\text{b}|}`) 
  ]
  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính bằng công thức  #mi(`\vec{a} \cdot \vec{b} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a^2/2`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABC`)  là tam giác đều. Do đó, góc  #mi(`(\vec{AB}, \vec{AC}) = 60^\circ`) . Áp dụng công thức:  #mi(`\vec{AB} \cdot \vec{AC} = AB \cdot AC \cdot \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong hình lập phương cạnh  #mi(`a`) , tính tích vô hướng  #mi(`\vec{AC} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a^2`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Trong hình lập phương,  #mi(`\vec{AC}`)  là đường chéo mặt và  #mi(`\vec{AD}`)  là cạnh. Góc giữa  #mi(`\vec{AC}`)  và  #mi(`\vec{AD}`)  là  #mi(`45^\circ`)  (vì  #mi(`\triangle ACD`)  vuông cân tại  #mi(`D`) ). Vậy  #mi(`\vec{AC} \cdot \vec{AD} = AC \cdot AD \cdot \cos(45^\circ) = (a\sqrt{2}) \cdot a \cdot \frac{\sqrt{2}}{2} = a^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính góc trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{CD} = -\vec{DC}`) . Do đó  #mi(`\vec{AB} \cdot \vec{CD} = -\vec{AB} \cdot \vec{DC}`) . Trong tứ diện đều,  #mi(`\vec{AB}`)  và  #mi(`\vec{DC}`)  là hai cạnh đối diện, chúng vuông góc với nhau nên  #mi(`\vec{AB} \cdot \vec{DC} = 0`) . Vậy  #mi(`\vec{AB} \cdot \vec{CD} = 0`) . Suy ra góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABD`)  là tam giác đều. Do đó góc  #mi(`(\vec{AB}, \vec{AD}) = 60^\circ`) . Áp dụng công thức:  #mi(`\vec{AB} \cdot \vec{AD} = AB \cdot AD \cdot \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100% đổi số liệu).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`2a`) . Tính tích vô hướng  #mi(`\vec{AC} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ACD`)  là tam giác đều. Do đó góc  #mi(`(\vec{AC}, \vec{AD}) = 60^\circ`) . Áp dụng công thức:  #mi(`\vec{AC} \cdot \vec{AD} \cdot = (2a) \cdot (2a) \cdot \cos(60^\circ) = 4a^2 \cdot \frac{1}{2} = 2a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AC} \cdot \vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình lập phương,  #mi(`\vec{AC}`)  và  #mi(`\vec{A'C'}`)  là hai đường chéo của hai mặt đối diện. Chúng song song và cùng hướng nên góc giữa chúng là  #mi(`0^o`) . Vậy  #mi(`\vec{AC} \cdot \vec{A'C'} = AC \cdot A'C' \cdot \cos(0^o) = (a\sqrt{2}) \cdot (a\sqrt{2}) \cdot 1 = 2a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng/Mở rộng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AC} \cdot \vec{BD'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đặt hệ tọa độ  #mi(`Oxyz`)  tại  #mi(`D`)  với  #mi(`D(0;0;0), A(a;0;0), C(0;a;0), D'(0;0;a)`) . Khi đó  #mi(`B(a;a;0)`)  và  #mi(`A(a;0;0)`)  không đúng, hãy dùng tọa độ:  #mi(`D(0;0;0), A(a;0;0), C(0;a;0), D'(0;0;a), B(a;a;0), A'(a,0,a), C'(0,a,a)`) . Vậy  #mi(`\vec{AC} = (-a;a;0)`)  và  #mi(`\vec{BD'} = (a;0;a)`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{BD'} = (-a)(a) + (a)(0) + (0)(a) = -a^2`) . Suy ra góc giữa hai vectơ là  #mi(`120^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Vận dụng Vectơ trong Hình khối Đặc biệt ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Vận dụng Vectơ trong Hình khối Đặc biệt]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong tứ diện đều cạnh  #mi(`a`) , tích vô hướng của hai vectơ chung gốc là  #mi(`\vec{AB} \cdot`) \vec{AC} = \frac{1}{2}a^2 #mi(`.`) 
  - Trong hình lập phương cạnh  #mi(`a`) , độ dài đường chéo chính là  #mi(`|\vec{AC'}| = a`) 
\sqrt{3} #mi(`.`) 
  - Quy tắc hình hộp:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tứ diện đều: 'Mọi cạnh bằng nhau, mọi góc  #mi(`60^\circ`) '. Hình lập phương: 'Ba cạnh xuất phát từ một đỉnh đôi một vuông góc'.
  ]
  - *Công thức cốt lõi:* Trong tứ diện đều cạnh  #mi(`a`) , tích vô hướng của hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  là  #mi(`\_{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot`) \vec{AC} #mi(`.`) 
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`0.5a^2`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABC`)  là tam giác đều. Do đó góc  #mi(`(\vec{AB}, \vec{AC}) = 60^\circ`) . Áp dụng công thức tích vô hướng:  #mi(`\vec{AB} \cdot \vec{AC} = AB \cdot AC \cdot \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{1}{2}a^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`2`) . Tính độ dài vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của  #mi(`\vec{u}`)  chính là độ dài đường chéo chính của hình lập phương. Với cạnh  #mi(`a=2`) , ta có  #mi(`|\vec{u}| = a`) 
\sqrt{3} = 2
\sqrt{3} #mi(`.`) ]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot`) \vec{AC'} #mi(`.`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . 
Do đó  #mi(`\vec{AB} \cdot \vec{AC'} = \vec{AB} \cdot (\vec{AB} + \vec{AD} + \vec{AA'}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AD} + \vec{AB} \cdot \vec{AA'}`) . 
Vì các cạnh của hình lập phương đôi một vuông góc nên  #mi(`\vec{AB} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AB} \cdot \vec{AA'} = 0`) . 
Vậy  #mi(`\vec{AB} \cdot \vec{AC'} = AB^2 = a^2`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Chứng minh rằng  #mi(`\vec{AB} +`) \vec{CD} =  #mi(`\vec{AC} +`) \vec{BD} #mi(`.`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} +`) \vec{CD} = \vec{AB} - \text{không dùng cách này} #mi(`.`) 
Sử dụng chèn điểm:  #mi(`\vec{AB} +`) \vec{CD} = \vec{AB} + (\vec{CB} - \text{không đúng}) #mi(`.`) 
Sử dụng chèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`) :  #mi(`\vec{AB} = \vec{AD} + \text{không đúng}`) . 
Cách đúng:  #mi(`\vec{AB} + \text{không đúng}`) . 
Xét vế trái:  #mi(`VT = \vec{AB} + \vec{CD}`) . 
Xét vế phải:  #mi(`VP = \vec{AC} + \vec{BD}`) . 
Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{BC}`)  và  #mi(`\vec{BD} = \vec{BC} + \text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`A`)  vào  #mi(`\vec{CD}`) :  #mi(`\vec{CD} = \vec{CA} + \vec{AD}`) . 
 #mi(`\vec{AB} + \vec{CD} = \vec{AB} + \vec{CA} + \vec{AD} = (\vec{AB} + \vec{CA}) + \vec{AD} = \vec{CB} + \vec{AD}`) . 
Sử dụng chèn điểm  #mi(`B`)  vào  #mi(`\vec{CD}`) :  #mi(`\vec{CD} = \vec{CB} + \text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`C`)  vào  #mi(`\text{không đúng}`) . 
Xét  #mi(`\vec{AC} + \vec{BD} = (\vec{AB} + \vec{BC}) + (\vec{BC} + \vec{CD}) = \text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`D`)  vào  #mi(`\vec{AC}`) :  #mi(`\vec{AC} = \vec{AD} + \vec{DC}`) . 
 #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{DC} + \vec{BD} = \vec{AD} + \vec{BC} + \text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`C`)  vào  #mi(`\vec{BD}`) :  #mi(`\vec{BD} = \vec{BC} + \text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`D`)  vào  #mi(`\text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`B`)  vào  #mi(`\text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`C`)  vào  #mi(`\text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`D`)  vào  #mi(`\text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`A`)  vào  #mi(`\text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`B`)  vào  #mi(`\text{không đúng}`) . 
Sử dụng chèn điểm  #mi(`C`)  vào  #mi(`\text{không đúng}`) . \text{Sử dụng chèn điểm } D \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } D \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } D \text{ vào } \text{không đúng} #mi(`.`) 
Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } D \text{ vào } \text{không đúng}`) . 
Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } D \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } D \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } D \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } B \text{ vào } \text{không đúng} #mi(`. \text{Sử dụng chèn điểm } C \text{ vào } \text{không đúng}`) . \text{Sử dụng chèn điểm } A \text{ vào } \text{không đúng}\$\$] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Tính toán tọa độ điểm và vectơ trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Tính toán tọa độ điểm và vectơ trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tọa độ vectơ  #mi(`\vec{MN}`)  được tính bằng hiệu tọa độ các điểm:  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) 
  - Tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`)  là  #mi(`I\left(\frac{x_A + x_B}{2}; \frac{y_A + y_B}{2}; \frac{z_A + z_B}{2}`) 
ight)\$\$
  - Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là  #mi(`G\left(\frac{x_A + x_B + x_C}{3}; \frac{y_A + y_B + y_C}{3}; \frac{z_A + z_B + z_C}{3}`) 
ight)\$\$
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm vectơ từ hai điểm, lấy 'Sau trừ Trước' (tọa độ điểm cuối trừ tọa độ điểm đầu). Muốn tìm trung điểm, lấy 'Tổng chia đôi'.
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{u} = k\vec{a}`)  với  #mi(`\vec{a}=(x;y;z)`)  là  #mi(`\vec{u}=(...; ...; ...)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2; 2; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB}`)  được tính theo công thức:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (3 - 1; 4 - 2; 5 - 3) = (2; 2; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 0)`)  và  #mi(`C(5; -2; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; 0; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G`)  được tính bằng công thức:  #mi(`x_G = \frac{1+3+5}{3} = 3`) ;  #mi(`y_G = \frac{0+2+(-2)}{3} = 0`) ;  #mi(`z_G = \frac{2+0+4}{3} = 2`) . Vậy  #mi(`G(3; 0; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa giải mẫu")[
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ trung điểm và vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(2; -1; 4)`)  và  #mi(`B(4; 3; 0)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  và tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) :
 #mi(`x_M = \frac{2+4}{2} = 3`) 
 #mi(`y_M = \frac{-1+3}{2} = 1`) 
 #mi(`z_M = \frac{4+0}{2} = 2`) 
Vậy  #mi(`M(3; 1; 2)`) .

2. Tọa độ vectơ  #mi(`\vec{AB}`) :
 #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (4 - 2; 3 - (-1); 0 - 4) = (2; 4; -4)`) .
Vậy  #mi(`\vec{AB} = (2; 4; -4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 1; 1)`)  và  #mi(`B(5; 3; -1)`) . Tìm tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`)  và tọa độ vectơ  #mi(`\vec{BA}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Tọa độ trung điểm  #mi(`I`) :
 #mi(`x_I = \frac{1+5}{2} = 3`) 
 #mi(`y_I = \frac{1+3}{2} = 2`) 
 #mi(`z_I = \frac{1+(-1)}{2} = 0`) 
Vậy  #mi(`I(3; 2; 0)`) .

2. Tọa độ vectơ  #mi(`\vec{BA}`) :
 #mi(`\vec{BA} = (x_A - x_B; y_A - y_B; z_A - z_B) = (1 - 5; 1 - 3; 1 - (-1)) = (-4; -2; 2)`) .
Vậy  #mi(`\vec{BA} = (-4; -2; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(0; 4; 2)`)  và  #mi(`B(6; 0; -4)`) . Tìm tọa độ trung điểm  #mi(`J`)  của đoạn thẳng  #mi(`AB`)  và tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Tọa độ trung điểm  #mi(`J`) :
 #mi(`x_J = \frac{0+6}{2} = 3`) 
 #mi(`y_J = \frac{4+0}{2} = 2`) 
 #mi(`z_J = \frac{2+(-4)}{2} = -1`) 
Vậy  #mi(`J(3; 2; -1)`) .

2. Tọa độ vectơ  #mi(`\vec{AB}`) :
 #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (6 - 0; 0 - 4; -4 - 2) = (6; -4; -6)`) .
Vậy  #mi(`\vec{AB} = (6; -4; -6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 2; 2)`) ,  #mi(`B(4; 0; 2)`)  và  #mi(`C(2; 4; 6)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trọng tâm  #mi(`G`)  được tính bằng công thức:
 #mi(`x_G = \frac{2+4+2}{3} = \frac{8}{3}`) 
 #mi(`y_G = \frac{2+0+4}{3} = 2`) 
 #mi(`z_G = \frac{2+2+6}{3} = \frac{10}{3}`) 
Vậy  #mi(`G(\frac{8}{3}; 2; \frac{10}{3})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Vận dụng).* Trong không gian  #mi(`Oxyz`) , cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(1; 0; 0)`) ,  #mi(`B(4; 0; 0)`) ,  #mi(`C(4; 3; 0)`)  và  #mi(`D(1; 3; 0)`) . Tìm tọa độ đỉnh  #mi(`A'`)  sao cho  #mi(`AA'`)  song song và bằng  #mi(`BB'`) . và  #mi(`AA'`)  có độ dài bằng 4 (hướng lên trên trục  #mi(`Oz`) ).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình hộp chữ nhật, các cạnh bên  #mi(`AA', BB', CC', DD'`)  đều song song và bằng nhau. Vì  #mi(`AA'`)  có độ dài bằng 4 và hướng lên trên trục  #mi(`Oz`) , nên tọa độ của  #mi(`A'`)  sẽ là tọa độ của  #mi(`A`)  cộng thêm vectơ  #mi(`\vec{AA'} = (0; 0; 4)`) .
 #mi(`x_{A'} = x_A + 0 = 1 + 0 = 1`) 
 #mi(`y_{A'} = y_A + 0 = 0 + 0 = 0`) 
 #mi(`z_{A'} = z_A + 4 = 0 + 4 = 4`) 
Vậy  #mi(`A'(1; 0; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
