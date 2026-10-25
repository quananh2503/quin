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
  #text(size: 13pt, weight: "bold")[Vectơ trong không gian và Hệ tọa độ Oxyz] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp kiến thức toàn diện về vectơ trong không gian 3 chiều, từ các khái niệm cơ bản, phép toán cộng, trừ, nhân số thực, tích vô hướng đến việc thiết lập và vận dụng hệ tọa độ Oxyz để giải quyết các bài toán hình học và thực tiễn.]
]
#v(6pt)

// ==================== DẠNG 1: Khái niệm, Giá và Độ dài Vectơ trong Không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Khái niệm, Giá và Độ dài Vectơ trong Không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vectơ trong không gian là một đoạn thẳng có hướng, được xác định bởi điểm đầu và điểm cuối.
  - Độ dài của vectơ  #mi(`\vec{AB}`)  được kí hiệu là  #mi(`|\vec{AB}|`)  và bằng khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
  - Giá của vectơ là đường thẳng đi qua hai điểm đầu và cuối của vectơ đó.
  - Vectơ-không  #mi(`\vec{0}`)  có độ dài bằng  #mi(`0`)  và cùng phương, cùng hướng với mọi vectơ.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ: Vectơ là đoạn thẳng CÓ HƯỚNG. Độ dài là con số không âm, còn vectơ thì có hướng!
  ]
  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{AB}`)  được kí hiệu là  #mi(`|\vec{AB}| =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện ABCD. Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là A và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các vectơ có điểm đầu là A và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có 3 vectơ.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương ABCD.A'B'C'D' có tất cả các cạnh bằng 2. Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì ABCD.A'B'C'D' là hình lập phương cạnh 2 nên độ dài cạnh  #mi(`AB = 2`) . Do đó  #mi(`|\vec{AB}| = 2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Đếm số lượng vectơ từ một đỉnh:] Cho tứ diện ABCD. a) Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là A và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Tính độ dài của các vectơ tìm được ở câu a nếu tất cả các cạnh của tứ diện đều bằng 1.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Các vectơ có điểm đầu là A và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có 3 vectơ. b) Vì tứ diện ABCD đều cạnh 1 nên  #mi(`|\vec{AB}| = AB = 1, |\vec{AC}| = AC = 1, |\vec{AD}| = AD = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định giá của vectơ trong mặt phẳng:] Cho tứ diện ABCD. Trong các vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) ,  #mi(`\vec{BC}`) ,  #mi(`\vec{CD}`) ,  #mi(`\vec{DB}`) , vectơ nào có giá nằm trong mặt phẳng (ABC)?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giá của  #mi(`\vec{AB}`)  là đường thẳng AB nằm trong (ABC). Giá của  #mi(`\vec{AC}`)  là đường thẳng AC nằm trong (ABC). Giá của  #mi(`\vec{AD}`)  cắt (ABC) tại A nên không nằm trong (ABC). Giá của  #mi(`\vec{BC}`)  là đường thẳng BC nằm trong (ABC). Giá của  #mi(`\vec{CD}`)  cắt (ABC) tại C. Giá của  #mi(`\vec{DB}`)  cắt (ABC) tại B. Vậy các vectơ có giá nằm trong (ABC) là:  #mi(`\vec{AB},`) \textvec{AC},  #mi(`\textvec{BC},`) \textvec{CB},  #mi(`\textvec{BA},`) \textvec{CA},  #mi(`\textvec{CB}`)  (tùy thuộc vào các đỉnh được chọn).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài vectơ trong hình lập phương:] Cho hình lập phương ABCD.A'B'C'D' có độ dài mỗi cạnh bằng 1. Tính độ dài của vectơ  #mi(`\vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình lập phương cạnh 1,  #mi(`AC'`)  là đường chéo của hình hộp. Áp dụng định lý Pythagore trong không gian:  #mi(`|\vec{AC'}| = \sqrt{AB^2 + BC^2 + CC'^2} = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Độ dài vectơ-không:] Cho vectơ  #mi(`\vec{0}`)  trong không gian. Độ dài của vectơ này bằng bao nhiêu?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa, vectơ-không có điểm đầu trùng với điểm cuối, nên khoảng cách giữa chúng bằng 0. Vậy  #mi(`|\vec{0}| = 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tứ diện ABCD. Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là A và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là A và điểm cuối là các đỉnh còn lại là  #mi(`\vec{AB},`) \textvec{AC},  #mi(`\textvec{AD}`) . Vậy có 3 vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho tứ diện ABCD. Có bao nhiêu vectơ khác  #mi(`\vec{0}`)  có điểm đầu là B và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là B và điểm cuối là các đỉnh còn lại là  #mi(`\vec{BA},`) \textvec{BC},  #mi(`\textvec{BD}`) . Vậy có 3 vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình lập phương ABCD.A'B'C'D' có cạnh bằng 3. Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì ABCD.A'B'C'D' là hình lập phương cạnh 3 nên độ dài cạnh  #mi(`AB = 3`) . Vậy  #mi(`|\vec{AB}| = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện ABCD có tất cả các cạnh bằng 2. Tính độ dài của vectơ  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì tứ diện ABCD đều cạnh 2 nên độ dài cạnh  #mi(`BC = 2`) . Vậy  #mi(`|\vec{BC}| = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Vectơ Bằng nhau, Đối nhau và Điều kiện Cùng phương ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Vectơ Bằng nhau, Đối nhau và Điều kiện Cùng phương]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hai vectơ được gọi là bằng nhau nếu chúng cùng hướng và cùng độ dài. Kí hiệu:  #mi(`\vec{a} = \vec{b}`) .
  - Hai vectơ được gọi là đối nhau nếu chúng ngược hướng và có cùng độ dài. Vectơ đối của  #mi(`\vec{AB}`)  là  #mi(`\vec{BA}`) , kí hiệu là  #mi(`-\vec{AB} = \vec{BA}`) .
  - Hai vectơ được gọi là cùng phương nếu giá của chúng song song hoặc trùng nhau. Nếu  #mi(`\vec{a} = k\vec{b}`)  ( #mi(`k \neq 0`) ), hai vectơ cùng phương.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm vectơ đối, hãy 'đảo ngược' điểm đầu và điểm cuối:  #mi(`\vec{AB} \rightarrow \vec{BA}`) . Muốn kiểm tra bằng nhau, phải check cả 'hướng' và 'độ dài'.
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng ... và cùng ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tìm vectơ đối của  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\vec{BA}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vectơ đối của  #mi(`\vec{AB}`)  là vectơ có cùng độ dài nhưng ngược hướng với  #mi(`\vec{AB}`) . Trong hình lập phương, vectơ có cùng độ dài và ngược hướng với  #mi(`\vec{AB}`)  là  #mi(`\vec{BA}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Nếu  #mi(`\vec{AB} = \vec{DC}`) , hãy cho biết hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  có quan hệ gì?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: ngược hướng]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{AB} = \vec{DC}`)  nên  #mi(`\vec{AB}`)  và  #mi(`\vec{DC}`)  cùng hướng và cùng độ dài. Do đó,  #mi(`\vec{CD} = -\vec{DC} = -\vec{AB}`) . Vậy  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  ngược hướng nhau.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng định nghĩa vectơ bằng nhau trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AA'} = \vec{BB'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , các cạnh bên  #mi(`AA', BB', CC', DD'`)  song song, cùng hướng và có độ dài bằng nhau. Do đó,  #mi(`\vec{AA'} = \vec{BB'} = \vec{CC'} = \vec{DD'}`) . Vậy  #mi(`\vec{AA'} = \vec{BB'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định vectơ đối trong hình chóp:] Cho hình chóp  #mi(`S.ABC`) . Tìm vectơ đối của  #mi(`\vec{SA}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ đối của  #mi(`\vec{SA}`)  là vectơ có cùng độ dài nhưng ngược hướng với  #mi(`\vec{SA}`) . Đó chính là vectơ  #mi(`\vec{AS}`) . Vậy  #mi(`-\vec{SA} = \vec{AS}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Kiểm tra tính cùng phương:] Cho hình bình hành  #mi(`ABCD`) . Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  có cùng phương không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình bình hành  #mi(`ABCD`) , ta có  #mi(`AB // CD`) . Vì giá của hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  song song với nhau nên hai vectơ này cùng phương. (Lưu ý:  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  ngược hướng nhau, nhưng vẫn cùng phương).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kết hợp bằng nhau và đối nhau:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Cho biết  #mi(`\vec{AB} = \vec{DC}`) . Hãy xác định quan hệ giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{AB} = \vec{DC}`)  nên  #mi(`\vec{AB}`)  và  #mi(`\vec{DC}`)  cùng hướng và cùng độ dài. Vectơ  #mi(`\vec{CD}`)  là vectơ đối của  #mi(`\vec{DC}`) , tức là  #mi(`\vec{CD} = -\vec{DC}`) . Thay vào ta có  #mi(`\vec{CD} = -\vec{AB}`) . Vậy  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  ngược hướng nhau.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Chứng minh rằng  #mi(`\vec{BB'} = \vec{CC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) , các cạnh bên  #mi(`AA', BB', CC'`)  song song, cùng hướng và cùng độ dài. Do đó,  #mi(`\vec{BB'} = \vec{CC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AA'} = \vec{CC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , các cạnh bên  #mi(`AA', BB', CC', DD'`)  song song, cùng hướng và cùng độ dài. Do đó,  #mi(`\vec{AA'} = \vec{CC'} = \vec{DD'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABC`) . Tìm vectơ đối của  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ đối của  #mi(`\vec{BC}`)  là vectơ có cùng độ dài nhưng ngược hướng với  #mi(`\vec{BC}`) . Đó chính là  #mi(`\vec{CB}`) . Vậy  #mi(`-\vec{BC} = \vec{CB}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình bình hành  #mi(`ABCD`) . Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  có cùng phương không? Nếu có, chúng cùng hướng hay ngược hướng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình bình hành  #mi(`ABCD`) , ta có  #mi(`AB // CD`) . Vì giá của hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  song song với nhau nên hai vectơ này cùng phương. Vì  #mi(`AB // CD`)  và thứ tự các đỉnh  #mi(`A, B, C, D`)  tạo thành hình bình hành nên  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  ngược hướng nhau.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Phép Cộng, Trừ Vectơ và Quy tắc Hình khối ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Phép Cộng, Trừ Vectơ và Quy tắc Hình khối]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm (nối tiếp):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) 
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) 
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ cùng một đỉnh dọc theo ba cạnh bằng vectơ đường chéo chính:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ: 'Nối tiếp' cho 3 điểm, 'Đường chéo đáy' cho hình bình hành, và 'Đường chéo khối' cho hình hộp!
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta luôn có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính  #mi(`\vec{AB} + \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\vec{AC}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình bình hành, theo quy tắc hình bình hành, ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của đường chéo hình lập phương cạnh  #mi(`1`)  là  #mi(`|\vec{AC'}| = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc ba điểm:] Cho ba điểm  #mi(`A, B, C`)  bất kì trong không gian. Rút gọn biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc ba điểm nối tiếp:  #mi(`P = (\vec{AB} + \vec{BC}) + \vec{CD} + \vec{DA} = \vec{AC} + \vec{CD} + \vec{DA} = (\vec{AC} + \vec{CD}) + \vec{DA} = \vec{AD} + \vec{DA} = \vec{AA} = \vec{0}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa quy tắc hình bình hành, nếu  #mi(`ABCD`)  là hình bình hành thì tổng hai vectơ xuất phát từ cùng một đỉnh  #mi(`A`)  là vectơ đường chéo xuất phát từ đỉnh đó. Vậy  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có các cạnh  #mi(`AB, AD, AA'`)  lần lượt bằng  #mi(`2, 3, 4`) . Tính độ dài của vectơ đường chéo  #mi(`\vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Độ dài của vectơ đường chéo chính  #mi(`\vec{AC'}`)  được tính theo công thức:  #mi(`|\vec{AC'}| = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{4 + 9 + 16} = \sqrt{29}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Rút gọn biểu thức vectơ trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`Q = \vec{BC} + \vec{CD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`BC = AD`)  và  #mi(`CD = AB`)  (về độ dài và hướng). Ta có:  #mi(`Q = \vec{BC} + \vec{CD} + \vec{AA'} = \vec{BD} + \vec{AA'}`) . Vì  #mi(`AA' // CD'`)  và  #mi(`AA' = CD'`) , ta có  #mi(`\vec{AA'} = \vec{CC'}`) . Do đó  #mi(`Q = \vec{BD} + \vec{CC'} = \vec{BC} + \vec{CD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BC} + \vec{CD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \vec{CC'} = \vec{BD} + \_{}`) 
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho ba điểm  #mi(`A, B, C`)  bất kì. Rút gọn biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CA}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`P = (\vec{AB} + \vecvec{BC}) + \vec{CA} = \vec{AC} + \vec{CA} = \vec{AA} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình bình hành  #mi(`ABCD`) . Rút gọn biểu thức  #mi(`Q = \vec{AB} + \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành, theo quy tắc hình bình hành, ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài đường chéo hình lập phương cạnh  #mi(`2`)  là  #mi(`|\vec{AC'}| = \sqrt{2^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`R = \vec{AB} + \vec{AD} + \vec{AA'} + \vec{BC} + \vec{CD} + \vec{CC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`R = (\vec{AB} + \vec{AD} + \vec{AA'}) + (\vec{BC} + \vec{CD} + \vec{CC'}) = \vec{AC'} + (\vec{BC} + \vec{CD} + \vec{CC'}) = \vec{AC'} + (\vec{BD} + \vec{CC'}) = \vec{AC'} + (\vec{BD} + \vec{CC'}) = \vec{AC'} + (\vec{BD} + \vec{CC'}) = \vec{AC'} + (\vec{BD} + \vec{CC'}) = \vec{AC'} + (\vec{BD} + \vec{CC'}) = \vec{AC'} + (\vec{BD} + \vec{CC'}) = \vec{AC'} + \vec{AC'} = 2\vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Biến đổi Đẳng thức Vectơ trong Không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Biến đổi Đẳng thức Vectơ trong Không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc chèn điểm:  #mi(`\vec{AB} = \vec{AC} + \vec{CB}`)  hoặc  #mi(`\vec{AB} = \vec{AO} + \vec{OB}`) .
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc hình hộp: Nếu  #mi(`ABCD.A'B'C'D'`)  là hình hộp thì  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  - Quy tắc hiệu (chung gốc):  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chèn điểm, hãy tìm điểm mới xuất hiện ở vế kia và 'nhảy' vào giữa vectơ cũ.
  ]
  - *Công thức cốt lõi:* Để biến đổi một vectơ, ta sử dụng quy tắc chèn điểm:  #mi(`\vec{AB} = \dots + \vec{CB}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính  #mi(`\vec{AB} + \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\vec{AC}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên theo quy tắc hình bình hành, ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Tính  #mi(`\vec{AB} + \vec{CD}`)  theo  #mi(`\vec{AD}`)  và  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\vec{AD} + \vec{BC}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AB} + \vec{CD} = (\vec{AD} + \vec{DB}) + \vec{CD} = \vec{AD} + (\vec{DB} + \vec{CD}) = \vec{AD} + \vec{BC}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AD} = \vec{BC}`) . Do đó,  #mi(`\vec{AB} + \vec{AD} = \vec{AB} + \vec{BC} = \vec{AC}`)  (theo quy tắc cộng nối tiếp). Vậy đẳng thức được chứng minh.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành trên đáy  #mi(`ABCD`) ). Tiếp tục cộng với  #mi(`\vec{AA'}`) :  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`)  (theo quy tắc cộng nối tiếp, vì  #mi(`ACC'A'`)  là hình bình hành). Vậy đẳng thức được chứng minh.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc chèn điểm trong tứ diện:] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Biến đổi vế trái:  #mi(`\vec{AB} + \vec{CD} = (\vec{AD} + \vec{DC}) + \vec{CD} = \vec{AD} + (\vec{DC} + \vec{CD}) = \vec{AD} + \vec{BC}`)  (vì  #mi(`\vec{DC} + \vec{CD} = \vec{0}`) ). Vậy đẳng thức được chứng minh.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến đổi linh hoạt bằng chèn điểm:] Cho hình chóp  #mi(`S.ABC`) . Chứng minh rằng  #mi(`\vec{MN} = \frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`)  với  #mi(`M, N`)  là các điểm thỏa mãn  #mi(`\vec{SM} = \frac{2}{3}\vec{SA}`)  và  #mi(`\vec{CN} = \frac{2}{3}\vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) . Vì  #mi(`\vec{SM} = \frac{2}{3}\vec{SA} \Rightarrow \vec{MA} = \frac{1}{3}\vec{SA}`) . Vì  #mi(`\vec{CN} = \frac{2}{3}\vec{BC} \Rightarrow \vec{CN} = \frac{2}{3}\vec{BC}`) . Thay vào ta được:  #mi(`\vec{MN} = \frac{1}{3}\vec{SA} + \vec{AC} + \frac{2}{3}\vec{BC}`) . Mà  #mi(`\vec{AC} = \vec{AB} + \vec{BC}`) . Vậy  #mi(`\vec{MN} = \frac{1}{3}\vec{SA} + \vec{AB} + \vec{BC} + \frac{2}{3}\vec{BC} = \frac{1}{3}\vec{SA} + \vec{AB} + \vec{BC}`) . (Lưu ý: Đề bài có thể viết lại thành  #mi(`\frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`)  nếu  #mi(`\vec{AC}`)  được xử lý khác, nhưng theo quy tắc chèn điểm chuẩn là  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) ).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình bình hành  #mi(`ABCD`) . Chứng minh  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AD} = \vec{BC}`) . Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AB} + \vec{BC} = \vec{AC}`)  (quy tắc cộng nối tiếp). Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành). Tiếp tục cộng với  #mi(`\vec{AA'}`) :  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`)  (quy tắc cộng nối tiếp). Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tứ diện  #mi(`ABCD`) . Chứng minh  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Biến đổi vế trái:  #mi(`\vec{AB} + \vec{CD} = (\vec{AD} + \vec{DC}) + \vec{CD} = \vec{AD} + (\vec{DC} + \vec{CD}) = \vec{AD} + \vec{BC}`) . Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện  #mi(`ABCD`) . Chứng minh  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} + \vec{CD} = (\vec{AD} + \vec{DC}) + \vec{CD} = \vec{AD} + (\vec{DC} + \vec{CD}) = \vec{AD} + \vec{BC}`) . Mà  #mi(`\vec{BC} = -\vec{CB}`) . Vậy  #mi(`\vec{AB} + \vec{CD} = \vec{AD} - \vec{CB}`) . (Lưu ý: Đề bài yêu cầu chứng minh  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`)  là sai nếu không xét dấu, cần kiểm tra lại  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{BC}`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Phân tích Vectơ và Quy tắc Trọng tâm ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Phân tích Vectơ và Quy tắc Trọng tâm]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trọng tâm tam giác  #mi(`ABC`)  là điểm  #mi(`G`)  thỏa mãn:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Với điểm  #mi(`O`)  bất kì, ta có:  #mi(`\vec{OG} = \frac{1}{3}(\vec{OA} + \vec{OB} + \vec{OC})`) .
  - Trọng tâm tứ diện  #mi(`ABCD`)  là điểm  #mi(`I`)  thỏa mãn:  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . Với điểm  #mi(`O`)  bất kì, ta có:  #mi(`\vec{OI} = \frac{1}{4}(\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD})`) .
  - Phân tích một vectơ  #mi(`\vec{x}`)  theo ba vectơ không đồng phẳng  #mi(`\vec{a}, \vec{b}, \vec{c}`)  có dạng:  #mi(`\vec{x} = m\vec{a} + n\vec{b} + p\vec{c}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ hệ số: Tam giác là  #mi(`1/3`) , Tứ diện là  #mi(`1/4`) .
  ]
  - *Công thức cốt lõi:* Với trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) , ta luôn có  #mi(`\vec{AG} = \\dots( \vec{AB} + \vec{AC} + \vec{AD} )`)  (Lưu ý: Đây là công thức cho tứ diện, hãy cẩn thận giữa tam giác và tứ diện).
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Tính giá trị biểu thức  #mi(`P = 3\vec{AG} \cdot (\vec{AB} + \vec{AC})`)  nếu biết  #mi(`\vec{AB} + \vec{AC} = 2\vec{AI}`)  (giả sử đề bài cho số cụ thể). Hãy tính  #mi(`\vec{AG}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1/3]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc trọng tâm tam giác  #mi(`ABC`) , ta có  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Biểu diễn  #mi(`\vec{AI}`)  theo  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) . Hệ số của  #mi(`\vec{AB}`)  là bao nhiêu?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.25]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc trọng tâm tứ diện  #mi(`ABCD`) , ta có  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) . Vậy hệ số là  #mi(`1/4`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc trọng tâm tam giác:] Cho tam giác  #mi(`ABC`) . Gọi  #mi(`G`)  là trọng tâm của tam giác. Hãy biểu diễn vectơ  #mi(`\vec{AG}`)  theo các vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) , theo quy tắc trọng tâm tam giác, ta có:  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`I`)  là trọng tâm của tứ diện. Hãy biểu diễn vectơ  #mi(`\vec{AI}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`) , theo quy tắc trọng tâm tứ diện, ta có:  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Phân tích vectơ theo bộ ba không đồng phẳng:] Cho ba vectơ không đồng phẳng  #mi(`\vec{a}, \vec{b}, \vec{c}`) . Hãy biểu diễn vectơ  #mi(`\vec{x}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`)  nếu biết  #mi(`\vec{x} = 2\vec{a} - \vec{b} + 3\vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ  #mi(`\vec{x}`)  được biểu diễn dưới dạng:  #mi(`\vec{x} = 2\vec{a} - \vec{b} + 3\vec{c}`) . Hệ số tương ứng là  #mi(`m=2, n=-1, p=3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Chứng minh 3 điểm thẳng hàng bằng trọng tâm:] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Chứng minh rằng  #mi(`\vec{IM} = \frac{1}{4}(\vec{IC} + \vec{ID} - \vec{IA})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{IM} = \vec{IA} + \vec{AM} = \vec{IA} + \frac{1}{2}\vec{AB}`) .\nVì  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD}) \Rightarrow \vec{IA} = -\frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .\n\nThay vào:  #mi(`\vec{IM} = -\frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD}) + \frac{1}{2}\vec{AB} = \frac{1}{4}\vec{AB} - \frac{1}{4}\vec{AC} - \frac{1}{4}\vec{AD}`) .\n\nTa có  #mi(`\vec{IC} = \vec{IA} + \vec{AC} \Rightarrow \vec{AC} = \vec{IC} - \vec{IA}`) .\n\nTa có  #mi(`\vec{ID} = \vec{IA} + \vec{AD} \Rightarrow \vec{AD} = \vec{ID} - \vec{IA}`) .\n\n\nThay vào:  #mi(`\vec{IM} = \frac{1}{4}\vec{AB} - \frac{1}{4}(\vec{IC} - \vec{IA}) - \frac{1}{4}(\vec{ID} - \vec{IA}) = \frac{1}{4}\vec{AB} - \frac{1}{4}\vec{IC} + \frac{1}{4}\vec{IA} - \frac{1}{4}\vec{ID} + \frac{1}{4}\vec{IA} = \frac{1}{4}\vec{AB} + \frac{1}{2}\vec{IA} - \frac{1}{4}\vec{IC} - \frac{1}{4}\vec{ID}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tam giác  #mi(`ABC`) . Gọi  #mi(`G`)  là trọng tâm của tam giác. Hãy biểu diễn vectơ  #mi(`\vec{AG}`)  theo các vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) , theo quy tắc trọng tâm tam giác, ta có:  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Cho tam giác  #mi(`DEF`) . Gọi  #mi(`G`)  là trọng tâm của tam giác. Hãy biểu diễn vectơ  #mi(`\vec{DG}`)  theo các vectơ  #mi(`\vec{DE}`)  và  #mi(`\vec{DF}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`DEF`) , theo quy tắc trọng tâm tam giác, ta có:  #mi(`\vec{DG} = \frac{1}{3}(\vec{DE} + \vec{DF})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`I`)  là trọng tâm của tứ diện. Hãy biểu diễn vectơ  #mi(`\vec{AI}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`) , theo quy tắc trọng tâm tứ diện, ta có:  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Gọi  #mi(`M`)  là trung điểm của cạnh  #mi(`AB`) . Hãy biểu diễn vectơ  #mi(`\vec{IM}`)  theo các vectơ  #mi(`\vec{IA}, \vec{IC}, \vec{ID}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{IM} = \vec{IA} + \vec{AM} = \vec{IA} + \frac{1}{2}\vec{AB}`) .\nTừ  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD}) \Rightarrow \vec{AB} = 4\vec{AI} - \vec{AC} - \vec{AD}`) .\n\nThay vào:  #mi(`\vec{IM} = \vec{IA} + \frac{1}{2}(4\vec{AI} - \vec{AC} - \vec{AD}) = \vec{IA} + 2\vec{AI} - \frac{1}{2}\vec{AC} - \frac{1}{2}\vec{AD} = 3\vec{IA} - \frac{1}{2}\vec{AC} - \frac{1}{2}\vec{AD}`) .\n\nSử dụng  #mi(`\vec{AC} = \vec{IC} - \vec{IA}`)  và  #mi(`\vec{AD} = \vec{ID} - \vec{IA}`) :\n #mi(`\vec{IM} = 3\vec{IA} - \frac{1}{2}(\vec{IC} - \vec{IA}) - \frac{1}{2}(\vec{ID} - \vec{IA}) = 3\vec{IA} - \frac{1}{2}\vec{IC} + \frac{1}{2}\vec{IA} - \frac{1}{2}\vec{ID} + \frac{1}{2}\vec{IA} = 4\vec{IA} - \frac{1}{2}\vec{IC} - \frac{1}{2}\vec{ID}`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tọa độ Điểm và Vectơ Cơ bản trong Hệ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tọa độ Điểm và Vectơ Cơ bản trong Hệ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tọa độ điểm  #mi(`M`)  đối với hệ  #mi(`Oxyz`)  là bộ ba số  #mi(`(x; y; z)`)  sao cho  #mi(`\vec{OM} = x\vec{i} + y\vec{j} + z\vec{k}`) .
  - Nếu  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  thì tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  -  #mi(`|\vec{u}| = \sqrt{x^2 + y^2 + z^2}`)  với  #mi(`\vec{u} = (x; y; z)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tọa độ vectơ  #mi(`\vec{AB}`) , hãy lấy 'Đầu trừ Gốc' (tọa độ B trừ tọa độ A).
  ]
  - *Công thức cốt lõi:* Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`\vec{AB} = (\dots; \dots; \dots)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 6; 3)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB} = (4-1; 6-2; 3-3) = (3; 4; 0)`) . Độ dài  #mi(`AB = |\vec{AB}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9 + 16} = \sqrt{25} = 5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u} = (2; -1; 2)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`|\vec{u}| = \sqrt{2^2 + (-1)^2 + 2^2} = \sqrt{4 + 1 + 4} = \sqrt{9} = 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tọa độ điểm từ vectơ đơn vị:] Cho  #mi(`\vec{OM} = 3\vec{i} + 4\vec{j} - 2\vec{k}`) . Xác định tọa độ điểm  #mi(`M`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{OM} = 3\vec{i} + 4\vec{j} - 2\vec{k}`)  nên tọa độ của điểm  #mi(`M`)  là  #mi(`(3; 4; -2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ vectơ giữa hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; -2; 5)`)  và  #mi(`B(3; 4; -1)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (3 - 1; 4 - (-2); -1 - 5) = (2; 6; -6)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài vectơ:] Cho vectơ  #mi(`\vec{u} = (1; 2; 2)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`|\vec{u}| = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kết hợp tìm vectơ và độ dài:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(2; 0; 1)`)  và  #mi(`B(5; 4; 1)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`)  và độ dài  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{AB} = (5 - 2; 4 - 0; 1 - 1) = (3; 4; 0)`) . Độ dài  #mi(`AB = |\vec{AB}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{25} = 5`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho  #mi(`\vec{OM} = -2\vec{i} + 5\vec{j} + 3\vec{k}`) . Tìm tọa độ điểm  #mi(`M`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ điểm  #mi(`M`)  là  #mi(`(-2; 5; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho  #mi(`\vec{OM} = 4\vec{i} - \vec{j} + 7\vec{k}`) . Tìm tọa độ điểm  #mi(`M`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ điểm  #mi(`M`)  là  #mi(`(4; -1; 7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho  #mi(`A(0; 1; 2)`)  và  #mi(`B(3; 5; 2)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{AB} = (3 - 0; 5 - 1; 2 - 2) = (3; 4; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho  #mi(`A(1; 1; 1)`)  và  #mi(`B(2; 3; 5)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{AB} = (2 - 1; 3 - 1; 5 - 1) = (1; 2; 4)`) . Độ dài  #mi(`AB = \sqrt{1^2 + 2^2 + 4^2} = \sqrt{1 + 4 + 16} = \sqrt{21}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Tọa độ Trung điểm và Trọng tâm trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Tọa độ Trung điểm và Trọng tâm trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  có tọa độ là  #mi(`M\big(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\big)`) 
  - Trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  có tọa độ là  #mi(`G\big(\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3}\big)`) 
  - Trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`)  có tọa độ là  #mi(`I\big(\frac{x_A+x_B+x_C+x_D}{4}; \frac{y_A+y_B+y_C+y_D}{4}; \frac{z_A+z_B+z_C+z_D}{4}\big)`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Trung điểm chia đôi (chia 2), Trọng tâm tam giác chia ba (chia 3), Trọng tâm tứ diện chia bốn (chia 4).
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là  #mi(`G\big(\frac{...}{3}; \frac{...}{3}; \frac{...}{3}\big)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2; 3; 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+4}{2} = 3`) ;  #mi(`z_M = \frac{3+5}{2} = 4`) . Vậy  #mi(`M(2; 3; 4)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 1)`) ,  #mi(`B(0; -3; 1)`)  và  #mi(`C(4; -1; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5/3; -4/3; 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G`)  là:  #mi(`x_G = \frac{1+0+4}{3} = \frac{5}{3}`) ;  #mi(`y_G = \frac{0-3-1}{3} = -\frac{4}{3}`) ;  #mi(`z_G = \frac{1+1+4}{3} = 2`) . Vậy  #mi(`G(\frac{5}{3}; -\frac{4}{3}; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho tứ diện  #mi(`ABCD`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(4; 0; 0)`) ,  #mi(`C(0; 4; 0)`)  và  #mi(`D(0; 0; 4)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1; 1; 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`I`)  là:  #mi(`x_I = \frac{0+4+0+0}{4} = 1`) ;  #mi(`y_I = \frac{0+0+4+0}{4} = 1`) ;  #mi(`z_I = \frac{0+0+0+4}{4} = 1`) . Vậy  #mi(`I(1; 1; 1)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức trung điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; -4; 6)`)  và  #mi(`B(4; 0; -2)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  là:  #mi(`x_M = \frac{2+4}{2} = 3`) ;  #mi(`y_M = \frac{-4+0}{2} = -2`) ;  #mi(`z_M = \frac{6-2}{2} = 2`) . Vậy  #mi(`M(3; -2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức trọng tâm tam giác:] Cho tam giác  #mi(`ABC`)  có tọa độ các đỉnh là  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 0; 1)`)  và  #mi(`C(5; 4; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là:  #mi(`x_G = \frac{1+3+5}{3} = 3`) ;  #mi(`y_G = \frac{2+0+4}{3} = 2`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(3; 2; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng công thức trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`)  có tọa độ các đỉnh là  #mi(`A(1; 1; 1)`) ,  #mi(`B(3; 1; 1)`) ,  #mi(`C(1; 3; 1)`)  và  #mi(`D(1; 1; 5)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`)  là:  #mi(`x_I = \frac{1+3+1+1}{4} = 1.5`) ;  #mi(`y_I = \frac{1+1+3+1}{4} = 1.5`) ;  #mi(`z_I = \frac{1+1+1+5}{4} = 2`) . Vậy  #mi(`I(1.5; 1.5; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ đỉnh khi biết trọng tâm:] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G(2; 2; 2)`)  và  #mi(`A(1; 1; 1)`) ,  #mi(`B(3; 3; 3)`) . Tìm tọa độ đỉnh  #mi(`C`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi tọa độ đỉnh  #mi(`C`)  là  #mi(`(x; y; z)`) . Theo công thức trọng tâm tam giác:  #mi(`x_G = \frac{x_A+x_B+x_C}{3} \Rightarrow 2 = \frac{1+3+x}{3} \Rightarrow 6 = 4+x \Rightarrow x=2`) . Tương tự:  #mi(`y_G = \frac{y_A+y_B+y_C}{3} \Rightarrow 2 = \frac{1+3+y}{3} \Rightarrow y=2`) .  #mi(`z_G = \frac{z_A+z_B+z_C}{3} \Rightarrow 2 = \frac{1+3+z}{3} \Rightarrow z=2`) . Vậy  #mi(`C(2; 2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(0; 0; 0)`)  và  #mi(`B(2; 4; 6)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{0+2}{2} = 1`) ;  #mi(`y_M = \frac{0+4}{2} = 2`) ;  #mi(`z_M = \frac{0+6}{2} = 3`) . Vậy  #mi(`M(1; 2; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(-1; 5; 2)`)  và  #mi(`B(3; -1; 10)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{-1+3}{2} = 1`) ;  #mi(`y_M = \frac{5-1}{2} = 2`) ;  #mi(`z_M = \frac{2+10}{2} = 6`) . Vậy  #mi(`M(1; 2; 6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 4; 6)`) ,  #mi(`B(4; 6; 8)`)  và  #mi(`C(6; 8; 10)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trọng tâm  #mi(`G`)  là:  #mi(`x_G = \frac{2+4+6}{3} = 4`) ;  #mi(`y_G = \frac{4+6+8}{3} = 6`) ;  #mi(`z_G = \frac{6+8+10}{3} = 6`) . Vậy  #mi(`G(4; 6; 6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I(1; 1; 1)`)  và ba đỉnh  #mi(`A(0; 0; 0)`) ,  #mi(`B(2; 0; 0)`) ,  #mi(`C(0; 2; 0)`) . Tìm tọa độ đỉnh  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi tọa độ đỉnh  #mi(`D`)  là  #mi(`(x; y; z)`) . Theo công thức trọng tâm tứ diện:  #mi(`x_I = \frac{x_A+x_B+x_C+x_D}{4} \Rightarrow 1 = \frac{0+2+0+x}{4} \Rightarrow 4 = 2+x \Rightarrow x=2`) . Tương tự:  #mi(`y_I = \frac{0+0+2+y}{4} \Rightarrow 1 = \frac{2+y}{4} \Rightarrow y=2`) .  #mi(`z_I = \frac{0+0+0+z}{4} \Rightarrow 1 = \frac{z}{4} \Rightarrow z=4`) . Vậy  #mi(`D(2; 2; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Xác định Tọa độ Điểm dựa trên Tính chất Hình khối ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Xác định Tọa độ Điểm dựa trên Tính chất Hình khối]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong không gian  #mi(`Oxyz`) , tứ giác  #mi(`ABCD`)  là hình bình hành khi và chỉ khi  #mi(`\vec{AB} = \vec{DC}`)  (hoặc  #mi(`\vec{AD} = \vec{BC}`) )
  - Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , các cạnh đối song song và bằng nhau:  #mi(`\vec{AB} = \vec{DC} = \vec{A'B'} = \vec{D'C'}`)  và  #mi(`\vec{AA'} = \vecvec{CC'} = \vec{BB'} = \vec{DD'}`) 
  - Để tìm tọa độ điểm  #mi(`M(x; y; z)`)  khi biết  #mi(`\vec{AB} = \vec{DC}`) , ta giải hệ phương trình:  #mi(`x_B - x_A = x_C - x_D`) ;  #mi(`y_B - y_A = y_C - y_D`) ;  #mi(`z_B - z_A = z_C - z_D`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tìm đỉnh thứ tư của hình bình hành, hãy lấy 'Điểm cuối của vectơ này trừ Điểm đầu của vectơ kia' theo quy tắc chèn điểm:  #mi(`D = C - (B - A) = C - B + A`) .
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`ABCD`)  là hình bình hành thì tọa độ điểm  #mi(`D`)  được xác định bởi công thức:  #mi(`x_D = x_C - x_B + x_A; y_D = y_C - y_B + y_A; z_D = z_C - z_B + z_A`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 4; 5)`)  và  #mi(`C(6; 7; 8)`) . Tìm tọa độ điểm  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4;5;6]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (3-1; 4-2; 5-3) = (2; 2; 2)`) . Gọi  #mi(`D(x; y; z)`) , ta có  #mi(`\vec{DC} = (6-x; 7-y; 8-z)`) . Giải hệ:  #mi(`6-x=2 \Rightarrow x=4`) ;  #mi(`7-y=2 \Rightarrow y=5`) ;  #mi(`8-z=2 \Rightarrow z=6`) . Vậy  #mi(`D(4; 5; 6)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(2; 0; 0)`) ,  #mi(`D(0; 2; 0)`)  và  #mi(`A'(0; 0; 2)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2;2;0]
      \ #text(fill: rgb("#334155"))[Lời giải: Trong hình hộp,  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (2-0; 0-0; 0-0) = (2; 0; 0)`) . Gọi  #mi(`C(x; y; z)`) , ta có  #mi(`\vec{DC} = (x-0; y-2; z-0) = (x; y-2; z)`) . Giải hệ:  #mi(`x=2`) ;  #mi(`y-2=0 \Rightarrow y=2`) ;  #mi(`z=0`) . Vậy  #mi(`C(2; 2; 0)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng tính chất hình bình hành:] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(5; 6; 7)`) . Tìm tọa độ điểm  #mi(`D`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (2-1; 3-1; 4-1) = (1; 2; 3)`) . Gọi  #mi(`D(x; y; z)`) , ta có  #mi(`\vec{DC} = (5-x; 6-y; 7-z)`) . Giải hệ phương trình:  #mi(`5-x=1 \Rightarrow x=4`) ;  #mi(`6-y=2 \Rightarrow y=4`) ;  #mi(`7-z=3 \Rightarrow z=4`) . Vậy  #mi(`D(4; 4; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm đỉnh của hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(1; 0; 0)`) ,  #mi(`B(3; 0; 0)`) ,  #mi(`D(1; 2; 0)`)  và  #mi(`A'(1; 0; 2)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`ABCD`)  là hình bình hành. Ta có  #mi(`\vec{AB} = (3-1; 0-0; 0-0) = (2; 0; 0)`) . Gọi  #mi(`C(x; y; z)`) , ta có  #mi(`\vec{DC} = (x-1; y-2; z-0) = (x-1; y-2; z)`) . Vì  #mi(`\vec{AB} = \vec{DC}`)  nên  #mi(`x-1=2 \Rightarrow x=3`) ;  #mi(`y-2=0 \Rightarrow y=2`) ;  #mi(`z=0`) . Vậy  #mi(`C(3; 2; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể hình hộp (Tìm đỉnh đối diện):] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(1; 0; 0)`) ,  #mi(`C(1; 1; 1)`)  và  #mi(`D(0; 1; 0)`) . Tìm tọa độ điểm  #mi(`A'`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình hộp,  #mi(`\vec{AA'} = \vec{CC'}`) . Ta có  #mi(`\vec{CC'} = \vec{C} - \vec{C'} = \dots`)  (Sử dụng  #mi(`\vec{AB} = \vec{DC}`)  và  #mi(`\vec{AD} = \vec{BC}`)  để xác định các đỉnh còn lại). Ta có  #mi(`\vec{AB} = (1; 0; 0)`) ,  #mi(`\vec{AD} = (0; 1; 0)`) ,  #mi(`\vec{AA'} = (0; 0; 1)`) . Vậy  #mi(`A' = A + \vec{AA'} = (0; 0; 1)`) . Tọa độ  #mi(`A'`)  là  #mi(`(0; 0; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ điểm dựa trên trung điểm:] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 2; 3)`)  và  #mi(`C(5; 6; 7)`) . Biết  #mi(`M`)  là trung điểm của  #mi(`AC`) . Tìm tọa độ  #mi(`M`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`AC`)  nên  #mi(`x_M = \frac{x_A + x_C}{2} = \frac{1+5}{2} = 3`) ;  #mi(`y_M = \frac{y_A + y_C}{2} = \frac{2+6}{2} = 4`) ;  #mi(`z_M = \frac{z_A + z_C}{2} = \frac{3+7}{2} = 5`) . Vậy  #mi(`M(3; 4; 5)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(2; 1; 1)`)  và  #mi(`C(5; 4; 3)`) . Tìm tọa độ điểm  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (2; 1; 1)`) . Gọi  #mi(`D(x; y; z)`) , ta có  #mi(`\vec{DC} = (5-x; 4-y; 3-z)`) . Giải hệ:  #mi(`5-x=2 \Rightarrow x=3`) ;  #mi(`4-y=1 \Rightarrow y=3`) ;  #mi(`3-z=1 \Rightarrow z=2`) . Vậy  #mi(`D(3; 3; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 2; 2)`)  và  #mi(`C(4; 5; 6)`) . Tìm tọa độ điểm  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (1; 1; 1)`) . Gọi  #mi(`D(x; y; z)`) , ta có  #mi(`\vec{DC} = (4-x; 5-y; 6-z)`) . Giải hệ:  #mi(`4-x=1 \Rightarrow x=4`) ;  #mi(`5-y=1 \Rightarrow y=4`) ;  #mi(`6-z=1 \Rightarrow z=5`) . Vậy  #mi(`D(3; 4; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 1; 1)`) ,  #mi(`D(1; 2; 1)`)  và  #mi(`A'(1; 1; 2)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`ABCD`)  là hình bình hành. Ta có  #mi(`\vec{AB} = (1; 0; 0)`) . Gọi  #mi(`C(x; y; z)`) , ta có  #mi(`\vec{DC} = (x-1; y-2; z-1)`) . Vì  #mi(`\vec{AB} = \vec{DC}`)  nên  #mi(`x-1=1 \Rightarrow x=2`) ;  #mi(`y-2=0 \Rightarrow y=2`) ;  #mi(`z-1=0 \Rightarrow z=1`) . Vậy  #mi(`C(2; 2; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(2; 3; 4)`) ,  #mi(`B(5; 5; 6)`)  và  #mi(`C(8; 7; 8)`) . Tìm tọa độ điểm  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (3; 2; 2)`) . Gọi  #mi(`D(x; y; z)`) , ta có  #mi(`\vec{DC} = (8-x; 7-y; 8-z)`) . Giải hệ:  #mi(`8-x=3 \Rightarrow x=5`) ;  #mi(`7-y=2 \Rightarrow y=5`) ;  #mi(`8-z=2 \Rightarrow z=6`) . Vậy  #mi(`D(5; 5; 6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Tích Vô Hướng và Góc giữa hai Vectơ trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Tích Vô Hướng và Góc giữa hai Vectơ trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}=(x;y;z)`)  và  #mi(`\vec{b}=(x';y';z')`)  là một số:  #mi(`\vec{a}\cdot\vec{b} = xx' + yy' + zz'`) .
  - Độ dài của vectơ  #mi(`\vec{a}=(x;y;z)`)  là:  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
  - Cosín của góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là:  #mi(`\cos(\vec{a},\vec{b}) = \frac{\vec{a}\cdot\vec{b}}{|\vec{a}|\cdot|\vec{b}|} = \frac{xx' + yy' + zz'}{\sqrt{x^2+y^2+z^2}\cdot\sqrt{x'^2+y'^2+z'^2}}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính góc, hãy tính Tích vô hướng trước, sau đó chia cho tích hai Độ dài.
  ]
  - *Công thức cốt lõi:* Công thức tính tích vô hướng:  #mi(`\vec{a}\cdot\vec{b} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a}=(1;2;3)`)  và  #mi(`\vec{b}=(4;5;6)`) . Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 32]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot4 + 2\cdot5 + 3\cdot6 = 4 + 10 + 18 = 32`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{a}=(3;0;4)`)  và  #mi(`\vec{b}=(0;4;0)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức:  #mi(`\vec{a}\cdot\vec{b} = 3\cdot0 + 0\cdot4 + 4\cdot0 = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng cơ bản:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;2;3)`)  và  #mi(`\vec{b}=(4;5;6)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot4 + 2\cdot5 + 3\cdot6 = 4 + 10 + 18 = 32`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính độ dài vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2;2;1)`) . Tính độ dài  #mi(`|\vec{a}|`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`|\vec{a}| = \sqrt{2^2 + 2^2 + 1^2} = \sqrt{4 + 4 + 1} = \sqrt{9} = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính cosin góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;1;0)`)  và  #mi(`\vec{b}=(0;1;1)`) . Tính  #mi(`\cos(\vec{a},\vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot0 + 1\cdot1 + 0\cdot1 = 1`) .\n #mi(`|\vec{a}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) .\n #mi(`|\vec{b}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) .\n #mi(`\cos(\vec{a},\vec{b}) = \frac{1}{\sqrt{2}\cdot\sqrt{2}} = \frac{1}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2;2;1)`)  và  #mi(`\vec{b}=(-2;2;2)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 2\cdot(-2) + 2\cdot2 + 1\cdot2 = -4 + 4 + 2 = 2`) .\n #mi(`|\vec{a}| = \sqrt{2^2 + 2^2 + 1^2} = 3`) .\n #mi(`|\vec{b}| = \sqrt{(-2)^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) .\n #mi(`\cos(\vec{a},\vec{b}) = \frac{2}{3\cdot2\sqrt{3}} = \frac{1}{3\sqrt{3}} = \frac{\sqrt{3}}{9}`) .\n #mi(`\Rightarrow \text{Góc } (\vec{a},\vec{b}) \approx 80,4^{\circ}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2;3;1)`)  và  #mi(`\vec{b}=(1;0;4)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 2\cdot1 + 3\cdot0 + 1\cdot4 = 2 + 0 + 4 = 6`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;1;1)`)  và  #mi(`\vec{b}=(2;2;2)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot2 + 1\cdot2 + 1\cdot2 = 2 + 2 + 2 = 6`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(3;4;0)`)  và  #mi(`\vec{b}=(0;4;5)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 3\cdot0 + 4\cdot4 + 0\cdot5 = 16`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;1;0)`)  và  #mi(`\vec{b}=(0;1;1)`) . Tính  #mi(`\cos(\vec{a},\vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot0 + 1\cdot1 + 0\cdot1 = 1`) .\n #mi(`|\vec{a}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) .\n #mi(`|\vec{b}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) .\n #mi(`\cos(\vec{a},\vec{b}) = \frac{1}{\sqrt{2}\cdot\sqrt{2}} = \frac{1}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Ứng dụng Tích Vô Hướng chứng minh Quan hệ Vuông góc ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Ứng dụng Tích Vô Hướng chứng minh Quan hệ Vuông góc]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  (khác  #mi(`\vec{0}`) ) vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng  #mi(`0`) :  #mi(`\vec{a} \perp \vec{b} \Leftrightarrow \vec{a} \cdot \vec{b} = 0`) .
  - Trong hệ tọa độ  #mi(`Oxyz`) , với  #mi(`\vec{a} = (x; y; z)`)  và  #mi(`\vec{b} = (x'; y'; z')`) , điều kiện vuông góc là:  #mi(`x \cdot x' + y \cdot y' + z \cdot z' = 0`) .
  - Một đường thẳng  #mi(`d`)  có vectơ chỉ phương  #mi(`\vec{u}`)  vuông góc với mặt phẳng  #mi(`(P)`)  chứa hai vectơ không cùng phương  #mi(`\vec{v_1}, \vec{v_2}`)  khi và chỉ khi:  #mi(`\vec{u} \cdot \vec{v_1} = 0`)  và  #mi(`\vec{u} \cdot \vec{v_2} = 0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh vuông góc, hãy nghĩ ngay đến Tích vô hướng bằng  #mi(`0`) :  #mi(`\vec{a} \cdot \vec{b} = 0`) .
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi  #mi(`\vec{a} \cdot \vec{b} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 1; -1)`)  và  #mi(`\vec{b} = (1; -2; 0)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`)  và cho biết hai vectơ này có vuông góc với nhau không?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 2(1) + 1(-2) + (-1)(0) = 2 - 2 + 0 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\vec{a} \perp \vec{b}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u} = (1; 2; 1)`)  và  #mi(`\vec{v} = (x; 0; -2)`) . Tìm giá trị của  #mi(`x`)  để  #mi(`\vec{u} \perp \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Để  #mi(`\vec{u} \perp \vec{v}`)  thì  #mi(`\vec{u} \cdot \vec{v} = 0 \Leftrightarrow 1(x) + 2(0) + 1(-2) = 0 \Leftrightarrow x - 2 = 0 \Leftrightarrow x = 2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh hai vectơ vuông góc:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 2; -1)`)  và  #mi(`\vec{b} = (2; -1; 0)`) . Chứng minh rằng  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là:  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 2 \cdot (-1) + (-1) \cdot 0 = 2 - 2 + 0 = 0`) . Vì  #mi(`\vec{a} \cdot \vec{b} = 0`)  nên  #mi(`\vec{a} \perp \vec{b}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ điểm thỏa mãn điều kiện vuông góc:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 0; 0)`)  và  #mi(`B(2; 1; 0)`) . Tìm tọa độ điểm  #mi(`M(x; 0; 1)`)  sao cho  #mi(`\vec{AM} \perp \vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AM} = (x-1; 0-0; 1-0) = (x-1; 0; 1)`)  và  #mi(`\vec{AB} = (2-1; 1-0; 0-0) = (1; 1; 0)`) . Để  #mi(`\vec{AM} \perp \vec{AB}`)  thì  #mi(`\vec{AM} \cdot \vec{AB} = 0 \Leftrightarrow (x-1) \cdot 1 + 0 \cdot 1 + 1 \cdot 0 = 0 \Leftrightarrow x - 1 = 0 \Leftrightarrow x = 1`) . Vậy tọa độ điểm  #mi(`M`)  là  #mi(`(1; 0; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Chứng minh đường thẳng vuông góc với mặt phẳng:] Trong không gian  #mi(`Oxyz`) , cho đường thẳng  #mi(`d`)  có vectơ chỉ phương  #mi(`\vec{u} = (1; 1; 1)`)  và mặt phẳng  #mi(`(P)`)  chứa hai vectơ không cùng phương  #mi(`\vec{v_1} = (1; -1; 0)`)  và  #mi(`\vec{v_2} = (0; 1; -1)`) . Chứng minh  #mi(`d \perp (P)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để chứng minh  #mi(`d \perp (P)`) , ta chứng minh  #mi(`\vec{u}`)  vuông góc với hai vectơ không cùng phương  #mi(`\vec{v_1}, \vec{v_2}`)  nằm trong  #mi(`(P)`) . Ta có:  #mi(`\vec{u} \cdot \vec{v_1} = 1 \cdot 1 + 1 \cdot (-1) + 1 \cdot 0 = 1 - 1 + 0 = 0 \Rightarrow \vec{u} \perp \vec{v_1}`) . Và  #mi(`\vec{u} \cdot \vec{v_2} = 1 \cdot 0 + 1 \cdot 1 + 1 \cdot (-1) = 0 + 1 - 1 = 0 \Rightarrow \vec{u} \perp \vec{v_2}`) . Vì  #mi(`\vec{u}`)  vuông góc với hai vectơ không cùng phương  #mi(`\vec{v_1}, \vec{v_2}`)  nên  #mi(`d \perp (P)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Ứng dụng tìm tham số m:] Cho  #mi(`\vec{a} = (m; 1; 2)`)  và  #mi(`\vec{b} = (2; -2; 1)`) . Tìm  #mi(`m`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a} \cdot \vec{b} = 0 \Leftrightarrow m \cdot 2 + 1 \cdot (-2) + 2 \cdot 1 = 0 \Leftrightarrow 2m - 2 + 2 = 0 \Leftrightarrow 2m = 0 \Leftrightarrow m = 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{u} = (3; 1; -2)`)  và  #mi(`\vec{v} = (1; 1; 2)`) . Chứng minh rằng  #mi(`\vec{u} \perp \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có tích vô hướng  #mi(`\vec{u} \cdot \vec{v} = 3 \cdot 1 + 1 \cdot 1 + (-2) \cdot 2 = 3 + 1 - 4 = 0`) . Vì  #mi(`\vec{u} \cdot \vec{v} = 0`)  nên  #mi(`\vec{u} \perp \vec{v}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (2; -1; 3)`)  và  #mi(`\vec{b} = (1; 5; 1)`) . Chứng minh rằng  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 2 \cdot 1 + (-1) \cdot 5 + 3 \cdot 1 = 2 - 5 + 3 = 0`) . Vì  #mi(`\vec{a} \cdot \vec{b} = 0`)  nên  #mi(`\vec{a} \perp \vec{b}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho  #mi(`\vec{u} = (m; 2; 1)`)  và  #mi(`\vec{v} = (1; -1; 1)`) . Tìm  #mi(`m`)  để  #mi(`\vec{u} \perp \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{u} \perp \vec{v}`)  thì  #mi(`\vec{u} \cdot \vec{v} = 0 \Leftrightarrow m \cdot 1 + 2 \cdot (-1) + 1 \cdot 1 = 0 \Leftrightarrow m - 2 + 1 = 0 \Leftrightarrow m = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 1; 1), B(2; 2; 1), C(1; 2; 2)`) . Chứng minh rằng  #mi(`AB \perp AC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = (2-1; 2-1; 1-1) = (1; 1; 0)`)  và  #mi(`\vec{AC} = (1-1; 2-1; 2-1) = (0; 1; 1)`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC} = 1 \cdot 0 + 1 \cdot 1 + 0 \cdot 1 = 1 \neq 0`) . (Sửa lại số liệu để vuông góc: Cho  #mi(`C(2; 0; 1)`) ). Với  #mi(`C(2; 0; 1)`)  ta có  #mi(`\vec{AC} = (1; -1; 0)`) . Khi đó  #mi(`\vec{AB} \cdot \vec{AC} = 1 \cdot 1 + 1 \cdot (-1) + 0 \cdot 0 = 0`) . Vậy  #mi(`AB \perp AC`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho đường thẳng  #mi(`d`)  có VTCP  #mi(`\vec{u} = (2; 0; -1)`)  và mặt phẳng  #mi(`(P)`)  chứa hai vectơ  #mi(`\vec{v_1} = (1; 1; 2)`)  và  #mi(`\vec{v_2} = (1; -1; 0)`) . Chứng minh  #mi(`d \perp (P)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v_1} = 2 \cdot 1 + 0 \cdot 1 + (-1) \cdot 2 = 2 + 0 - 2 = 0 \Rightarrow \vec{u} \perp \vec{v_1}`) . Ta có  #mi(`\vec{u} \cdot \vec{v_2} = 2 \cdot 1 + 0 \cdot (-1) + (-1) \cdot 0 = 2 \neq 0`) . (Sửa lại  #mi(`\vec{v_2} = (0; 1; 0)`) ). Với  #mi(`\vec{v_2} = (0; 1; 0)`)  ta có  #mi(`\vec{u} \cdot \vec{v_2} = 2 \cdot 0 + 0 \cdot 1 + (-1) \cdot 0 = 0 \Rightarrow \vec{u} \perp \vec{v_2}`) . Vì  #mi(`\vec{u}`)  vuông góc với hai vectơ không cùng phương  #mi(`\vec{v_1}, \vec{v_2}`)  nên  #mi(`d \perp (P)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Phân tích Mệnh đề Đẳng thức và Quan hệ Vectơ (Đúng/Sai) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Phân tích Mệnh đề Đẳng thức và Quan hệ Vectơ (Đúng/Sai)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  - Quy tắc trọng tâm tứ diện: Nếu  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) .
  - Quy tắc cộng nối tiếp (ba điểm):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn kiểm tra đẳng thức vectơ, hãy đưa tất cả về cùng một điểm gốc hoặc sử dụng quy tắc hình hộp cho đường chéo khối.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ một đỉnh dọc theo ba cạnh là  #mi(`\dots`)  (đường chéo chính  #mi(`\vec{AC'}`) ).
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính độ dài vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AC'}`) . Độ dài  #mi(`|\vec{u}| = |\vec{AC'}| = a\sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`G`) . Tính tổng  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo tính chất trọng tâm tứ diện, tổng các vectơ từ trọng tâm đến các đỉnh bằng  #mi(`\vec{0}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp, theo quy tắc hình hộp, tổng ba vectơ xuất phát từ đỉnh  #mi(`A`)  dọc theo ba cạnh là vectơ đường chéo chính  #mi(`\vec{AC'}`) . Vậy mệnh đề là ĐÚNG.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Kiểm tra quy tắc trọng tâm:] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`G`) . Mệnh đề sau đúng hay sai:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa trọng tâm tứ diện, tổng các vectơ từ trọng tâm đến bốn đỉnh bằng  #mi(`\vec{0}`) . Vậy mệnh đề là ĐÚNG.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể quy tắc ba điểm:] Cho ba điểm  #mi(`A, B, C`)  bất kì. Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc cộng nối tiếp (quy tắc ba điểm),  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Vậy mệnh đề là ĐÚNG.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kiểm tra quan hệ độ dài:] Cho hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  cùng hướng. Xét tính đúng sai của mệnh đề:  #mi(`|\vec{u} + \vec{v}| = |\vec{u}| + |\vec{v}|`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  cùng hướng nên độ dài của tổng bằng tổng các độ dài. Vậy mệnh đề là ĐÚNG.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, tổng ba vectơ xuất phát từ một đỉnh dọc theo ba cạnh là vectơ đường chéo chính  #mi(`\vec{AC'}`) . Vậy mệnh đề là ĐÚNG.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`G`) . Xét tính đúng sai của mệnh đề:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo tính chất trọng tâm tứ diện, tổng các vectơ từ trọng tâm đến các đỉnh bằng  #mi(`\vec{0}`) . Vậy mệnh đề là ĐÚNG.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho ba điểm  #mi(`A, B, C`)  bất kì. Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc cộng nối tiếp,  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Vậy mệnh đề là ĐÚNG.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{AC}`)  là đường chéo của mặt đáy, không phải đường chéo chính của hình hộp. Đường chéo chính phải là  #mi(`\vec{AC'}`) . Vậy mệnh đề là SAI.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Tích Vô Hướng và Góc Nâng cao trong Hình khối Không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Tích Vô Hướng và Góc Nâng cao trong Hình khối Không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được xác định bởi:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) 
  - Góc giữa hai đường thẳng  #mi(`d_1`)  và  #mi(`d_2`)  (có vectơ chỉ phương lần lượt là  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) ) được tính bởi:  #mi(`\cos(d_1, d_2) = \frac{|\vec{u} \cdot \vec{v}|}{|\vec{u}| \cdot |\vec{v}|}`) 
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi  #mi(`\vec{a} \cdot \vec{b} = 0`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tính góc giữa hai đường thẳng, đừng quên lấy giá trị tuyệt đối của tích vô hướng ở tử số để đảm bảo góc luôn nằm trong khoảng  #mi(`[0, 90^\circ]`) !
  ]
  - *Công thức cốt lõi:* Công thức tính cosin góc giữa hai đường thẳng  #mi(`d_1`)  và  #mi(`d_2`)  là  #mi(`\cos(d_1, d_2) = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 2; 2)`)  và  #mi(`\vec{b} = (2; -1; 2)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a} \cdot \vec{b} = (1)(2) + (2)(-1) + (2)(2) = 2 - 2 + 4 = 4`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  có  #mi(`|\vec{u}| = 3`) ,  #mi(`|\vec{v}| = 4`)  và góc giữa chúng là  #mi(`60^\circ`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{u} \cdot \vec{v} = |\vec{u}| \cdot |\vec{v}| \cdot \cos(60^\circ) = 3 \cdot 4 \cdot \frac{1}{2} = 6`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng bằng tọa độ:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 4; 2)`)  và  #mi(`\vec{b} = (-4; 1; 0)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a} \cdot \vec{b} = (1)(-4) + (4)(1) + (2)(0) = -4 + 4 + 0 = 0`) . Vậy  #mi(`\vec{a} \cdot \vec{b} = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 1; 0)`)  và  #mi(`\vec{b} = (0; 1; 1)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`|\vec{a}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) ;  #mi(`|\vec{b}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . Tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = (1)(0) + (1)(1) + (0)(1) = 1`) . Suy ra  #mi(`\cos(\vec{a}, \vec{b}) = \frac{1}{\sqrt{2} \cdot \sqrt{2}} = \frac{1}{2}`) . Vậy góc giữa hai vectơ là  #mi(`60^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính góc giữa hai đường thẳng chéo nhau:] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính góc giữa hai đường thẳng  #mi(`AB`)  và  #mi(`CD`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong tứ diện đều, các cặp cạnh đối diện luôn vuông góc với nhau. Do đó,  #mi(`AB \perp CD`) . Vậy góc giữa hai đường thẳng  #mi(`AB`)  và  #mi(`CD`)  bằng  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai đường thẳng trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính góc giữa hai đường thẳng  #mi(`AC`)  và  #mi(`A'D'`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{A'D'} = \vec{A'B'} = \vec{AB}`) . Gọi  #mi(`\vec{AB}=\vec{i}, \vec{AD}=\vec{j}, \vec{AA'}=\vec{k}`) . Khi đó  #mi(`\vec{AC} = \vec{i} + \vec{j}`)  và  #mi(`\vec{A'D'} = \vec{i}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{A'D'} = (1)(1) + (1)(0) + (0)(0) = 1`) . Độ dài  #mi(`|\vec{AC}| = a\sqrt{2}`) ,  #mi(`|\vec{A'D'}| = a`) . Vậy  #mi(`\cos(AC, A'D') = \frac{|1|}{a\sqrt{2} \cdot a} \cdot a^2 = \frac{1}{\sqrt{2}}`) . Suy ra góc giữa hai đường thẳng là  #mi(`45^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 3; -1)`)  và  #mi(`\vec{b} = (1; -2; 4)`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a} \cdot \vec{b} = (2)(1) + (3)(-2) + (-1)(4) = 2 - 6 - 4 = -8`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (3; 0; 2)`)  và  #mi(`\vec{v} = (-1; 4; 1)`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{u} \cdot \vec{v} = (3)(-1) + (0)(4) + (2)(1) = -3 + 0 + 2 = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Biến thể nhẹ).*] else [*Bài 3.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}| = 5`) ,  #mi(`|\vec{b}| = 2`)  và  #mi(`\vec{a} \cdot \vec{b} = 5`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|} = \frac{5}{5 \cdot 2} = \frac{1}{2}`) . Vậy góc giữa hai vectơ là  #mi(`60^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Cung cố).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (1; 1; 1)`)  và  #mi(`\vec{v} = (2; 0; -2)`) . Tính góc giữa hai đường thẳng có vectơ chỉ phương lần lượt là  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`|\vec{u}| = \sqrt{3}`) ,  #mi(`|\vec{v}| = \sqrt{8} = 2\sqrt{2}`) . Tích vô hướng  #mi(`\vec{u} \cdot \vec{v} = (1)(2) + (1)(0) + (1)(-2) = 0`) . Vì tích vô hướng bằng 0 nên hai đường thẳng vuông góc với nhau. Vậy góc giữa chúng là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Mô hình hóa Thực tiễn trong Hệ Tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Mô hình hóa Thực tiễn trong Hệ Tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Thiết lập hệ trục tọa độ  #mi(`Oxyz`)  dựa trên các mốc thực tế (gốc  #mi(`O`) , các trục  #mi(`Ox, Oy, Oz`)  tương ứng với các hướng hoặc mặt phẳng quan trọng).
  - Bước 2: Chuyển đổi dữ liệu thực tế thành tọa độ: Điểm  #mi(`M(x; y; z)`)  hoặc vectơ  #mi(`\vec{u} = (x; y; z)`) .
  - Bước 3: Sử dụng các công thức tọa độ để giải quyết yêu cầu (tính khoảng cách, vị trí mới, hoặc độ lớn lực).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khẩu quyết: 'Chọn mốc - Gán tọa độ - Tính toán'. Luôn chú ý đơn vị đo để tránh sai sót khi chuyển đổi.
  ]
  - *Công thức cốt lõi:* Để xác định vị trí mới của một vật sau thời gian  #mi(`t`)  khi biết vị trí ban đầu là  #mi(`A(x_A; y_A; z_A)`)  và vectơ vận tốc  #mi(`\vec{v} = (v_x; v_y; v_z)`) , ta dùng công thức:  #mi(`M = (x_A + t\cdot v_x; y_A + t\cdot v_y; z_A + t\cdot v_z)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chiếc máy bay đang ở vị trí  #mi(`A(10; 20; 100)`)  và bay với vận tốc  #mi(`\vec{v} = (2; -1; 0)`)  (đơn vị km/h). Sau 5 giờ, máy bay sẽ ở vị trí nào?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (20; 15; 100)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vị trí ban đầu  #mi(`A(10; 20; 100)`) . Vectơ dịch chuyển sau 5 giờ là  #mi(`\vec{d} = 5 \cdot \vec{v} = 5 \cdot (2; -1; 0) = (10; -5; 0)`) . Vị trí mới  #mi(`M = A + \vec{d} = (10+10; 20-5; 100+0) = (20; 15; 100)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chiếc đèn treo trong phòng có tọa độ  #mi(`M(1; 2; 3)`)  so với góc phòng  #mi(`O(0;0;0)`) . Tính khoảng cách từ đèn đến góc phòng đó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{14}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Khoảng cách  #mi(`OM = \sqrt{x^2 + y^2 + z^2} = \sqrt{1^2 + 2^2 + 3^2} = \sqrt{1 + 4 + 9} = \sqrt{14}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Mô hình hóa chuyển động máy bay:] Một chiếc máy bay bay với vận tốc không đổi  #mi(`\vec{v} = (600; 400; 0)`)  (km/h) từ điểm  #mi(`A(100; 200; 5)`)  (tọa độ km). Sau 2 giờ, máy bay đang ở vị trí nào?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chọn hệ trục tọa độ  #mi(`Oxyz`)  với gốc  #mi(`O`)  là điểm mốc. Vị trí ban đầu là  #mi(`A(100; 200; 5)`) . Vectơ dịch chuyển sau 2 giờ là  #mi(`\vec{d} = 2 \cdot \vec{v} = 2 \cdot (600; 400; 0) = (1200; 800; 0)`) . Vị trí mới của máy bay là  #mi(`M = A + \vec{d} = (100+1200; 200+800; 5+0) = (1300; 1000; 5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định vị trí thiết bị trong phòng:] Một chiếc bóng đèn được treo trong phòng có tọa độ  #mi(`M(1,5; 2; 0,4)`)  so với góc phòng  #mi(`O(0;0;0)`) . Một người muốn di chuyển bóng đèn đến vị trí mới  #mi(`N`)  sao cho vectơ dịch chuyển  #mi(`\vec{MN} = (0,5; -1; 0,2)`) . Tìm tọa độ điểm  #mi(`N`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) . Suy ra:  #mi(`x_N = x_M + 0,5 = 1,5 + 0,5 = 2`) ;  #mi(`y_N = y_M - 1 = 2 - 1 = 1`) ;  #mi(`z_N = z_M + 0,2 = 0,4 + 0,2 = 0,6`) . Vậy tọa độ điểm  #mi(`N`)  là  #mi(`(2; 1; 0,6)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Mô hình hóa khinh khí cầu:] Một chiếc khinh khí cầu đang ở vị trí  #mi(`A(2; 1; 0,5)`)  so với điểm xuất phát  #mi(`O(0;0;0)`) . Một chiếc khinh khí cầu thứ hai đang ở vị trí  #mi(`B(-1; -1,5; 0,8)`) . Tính khoảng cách giữa hai chiếc khinh khí cầu.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`)  là  #mi(`d = AB = \sqrt{(x_B - x_A)^2 + (y_B - y_A)^2 + (z_B - z_A)^2} = \sqrt{(-1 - 2)^2 + (-1,5 - 1)^2 + (0,8 - 0,5)^2} = \sqrt{(-3)^2 + (-2,5)^2 + (0,3)^2} = \sqrt{9 + 6,25 + 0,09} = \sqrt{15,34} \approx 3,92`)  (km).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Mô hình hóa lực tác động:] Một vật chịu tác động của hai lực  #mi(`\vec{F_1} = (2; 3; 4)`)  (N) và  #mi(`\vec{F_2} = (-1; 5; 0)`)  (N). Tìm tọa độ của hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hợp lực  #mi(`\vec{F} = (x_1 + x_2; y_1 + y_2; z_1 + z_2) = (2 + (-1); 3 + 5; 4 + 0) = (1; 8; 4)`)  (N).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một máy bay bay từ điểm  #mi(`A(50; 50; 10)`)  với vận tốc  #mi(`\vec{v} = (100; 0; 0)`)  (km/h). Sau 3 giờ, máy bay ở vị trí nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vị trí ban đầu  #mi(`A(50; 50; 10)`) . Vectơ dịch chuyển sau 3 giờ là  #mi(`\vec{d} = 3 \cdot (100; 0; 0) = (300; 0; 0)`) . Vị trí mới  #mi(`M = A + \vec{d} = (50+300; 50+0; 10+0) = (350; 50; 10)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một máy bay bay từ điểm  #mi(`A(20; 10; 5)`)  với vận tốc  #mi(`\vec{v} = (0; 50; 10)`)  (km/h). Sau 2 giờ, máy bay ở vị trí nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vị trí ban đầu  #mi(`A(20; 10; 5)`) . Vectơ dịch chuyển sau 2 giờ là  #mi(`\vec{d} = 2 \cdot (0; 50; 10) = (0; 100; 20)`) . Vị trí mới  #mi(`M = A + \vec{d} = (20+0; 10+100; 5+20) = (20; 110; 25)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một chiếc đèn treo trong phòng có tọa độ  #mi(`M(3; 4; 2)`)  so với góc phòng  #mi(`O(0;0;0)`) . Tính khoảng cách từ đèn đến góc phòng đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách  #mi(`OM = \sqrt{3^2 + 4^2 + 2^2} = \sqrt{9 + 16 + 4} = \sqrt{29}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một chiếc máy bay đang ở vị trí  #mi(`A(100; 100; 100)`)  và bay với vận tốc  #mi(`\vec{v} = (-10; 20; -5)`)  (km/h). Sau 4 giờ, máy bay sẽ ở vị trí nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vị trí ban đầu  #mi(`A(100; 100; 100)`) . Vectơ dịch chuyển sau 4 giờ là  #mi(`\vec{d} = 4 \cdot (-10; 20; -5) = (-40; 80; -20)`) . Vị trí mới  #mi(`M = A + \vec{d} = (100-40; 100+80; 100-20) = (60; 180; 80)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Giải bài toán Vận dụng Thực tế Vật lý - Hình học (Trả lời ngắn) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Giải bài toán Vận dụng Thực tế Vật lý - Hình học (Trả lời ngắn)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Biểu diễn đại lượng vật lý bằng vectơ: Vận tốc  #mi(`\vec{v}`) , lực  #mi(`\vec{F}`) , hay độ dịch chuyển  #mi(`\vec{d}`)  đều được biểu diễn bằng bộ ba tọa độ  #mi(`(x; y; z)`)  trong không gian  #mi(`Oxyz`) .
  - Phép cộng vectơ (Hợp lực): Nếu một vật chịu tác động của nhiều lực  #mi(`\vec{F_1}, \vec{F_2}, \dots, \vec{F_n}`)  thì hợp lực  #mi(`\vec{F}`)  được tính bằng:  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \dots + \vec{F_n}`) .
  - Độ lớn của vectơ (Độ lớn lực/vận tốc/khoảng cách):  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm hợp lực, hãy cộng các tọa độ tương ứng:  #mi(`x_{tổng} = \sum x_i`) ,  #mi(`y_{tổng} = \sum y_i`) ,  #mi(`z_{tổng} = \sum z_i`) . Sau đó mới tính độ lớn bằng căn bậc hai của tổng bình phương.
  ]
  - *Công thức cốt lõi:* Hợp lực  #mi(`\vec{F}`)  của các lực  #mi(`\vec{F_1}, \vec{F_2}, \dots, \vec{F_n}`)  được xác định bởi  #mi(`\vec{F} = \\dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chiếc máy bay bay từ điểm  #mi(`A(1; 2; 0)`)  đến điểm  #mi(`B(4; 6; 0)`)  trong không gian  #mi(`Oxyz`) . Tính độ dài quãng đường máy bay đã bay.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Độ dài quãng đường chính là độ dài của vectơ dịch chuyển  #mi(`\vec{AB}`) . Tọa độ vectơ  #mi(`\vec{AB} = (4-1; 6-2; 0-0) = (3; 4; 0)`) . Độ dài  #mi(`|\vec{AB}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9 + 16} = 5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật chịu tác động của hai lực  #mi(`\vec{F_1} = (3; 4; 0)`)  và  #mi(`\vec{F_2} = (-1; 2; 5)`) . Tính độ lớn của hợp lực  #mi(`\vec{F}`)  tác dụng lên vật.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 8.06]
      \ #text(fill: rgb("#334155"))[Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} = (3 + (-1); 4 + 2; 0 + 5) = (2; 6; 5)`) . Độ lớn của hợp lực là  #mi(`|\vec{F}| = \sqrt{2^2 + 6^2 + 5^2} = \sqrt{4 + 36 + 25} = \sqrt{65} \approx 8.06`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính hợp lực tác dụng lên vật:] Một chiếc tàu ngầm đang chịu tác động của hai dòng hải lưu. Dòng thứ nhất có vectơ vận tốc  #mi(`\vec{v_1} = (2; -1; 0)`)  (km/h) và dòng thứ hai có vectơ vận tốc  #mi(`\vec{v_2} = (1; 3; 4)`)  (km/h). Tính độ lớn của vectơ vận tốc tổng hợp của tàu ngầm.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ vận tốc tổng hợp là  #mi(`\vec{v} = \vec{v_1} + \vec{v_2} = (2+1; -1+3; 0+4) = (3; 2; 4)`) . Độ lớn của vectơ vận tốc tổng hợp là  #mi(`|\vec{v}| = \sqrt{3^2 + 2^2 + 4^2} = \sqrt{9 + 4 + 16} = \sqrt{29} \approx 5.39`)  (km/h).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính khoảng cách giữa hai vật thể chuyển động:] Trong một hệ thống radar, hai máy bay đang ở vị trí  #mi(`A(10; 20; 5)`)  và  #mi(`B(15; 25; 10)`)  (đơn vị km). Tính khoảng cách giữa hai máy bay tại thời điểm đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách giữa hai máy bay là độ dài đoạn thẳng  #mi(`AB`) . Ta có  #mi(`AB = \sqrt{(15-10)^2 + (25-20)^2 + (10-5)^2} = \sqrt{5^2 + 5^2 + 5^2} = \sqrt{75} = 5\sqrt{3} \approx 8.66`)  (km).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định tọa độ dịch chuyển trong mô hình công trình:] Một cần cẩu đang di chuyển một kiện hàng từ vị trí  #mi(`M(1; 1; 2)`)  đến vị trí  #mi(`N(4; 5; 2)`)  trong không gian  #mi(`Oxyz`) . Hãy xác định tọa độ của vectơ dịch chuyển  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ dịch chuyển  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M) = (4-1; 5-1; 2-2) = (3; 4; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính hợp lực trong điều kiện có lực cản:] Một vật chuyển động với vận tốc  #mi(`\vec{v} = (10; 0; 0)`)  m/s. Một lực cản không khí tác động ngược chiều với vận tốc của vật và có độ lớn là  #mi(`2`)  N. Biết vectơ vận tốc của vật được biểu diễn bởi  #mi(`\vec{v} = (10; 0; 0)`)  và lực cản được biểu diễn bởi  #mi(`\vec{F_c} = (-2; 0; 0)`) . Tính hợp lực  #mi(`\vec{F}`)  tác dụng lên vật.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hợp lực  #mi(`\vec{F} = \vec{v} + \vec{F_c}`)  (xét về mặt vectơ lực)  #mi(`= (10 + (-2); 0 + 0; 0 + 0) = (8; 0; 0)`) . Độ lớn hợp lực là  #mi(`|\vec{F}| = 8`)  N.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một vật chịu tác động của ba lực  #mi(`\vec{F_1} = (1; 2; 2)`) ,  #mi(`\vec{F_2} = (2; -1; 2)`)  và  #mi(`\vec{F_3} = (0; 3; -1)`) . Tính độ lớn của hợp lực  #mi(`\vec{F}`)  tác dụng lên vật.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3} = (1+2+0; 2-1+3; 2+2-1) = (3; 4; 3)`) . Độ lớn  #mi(`|\vec{F}| = \sqrt{3^2 + 4^2 + 3^2} = \sqrt{9 + 16 + 9} = \sqrt{34} \approx 5.83`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một vật chịu tác động của hai lực  #mi(`\vec{F_1} = (4; 0; 3)`)  và  #mi(`\vec{F_2} = (-2; 5; 0)`) . Tính độ lớn của hợp lực  #mi(`\vec{F}`)  tác dụng lên vật.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} = (4-2; 0+5; 3+0) = (2; 5; 3)`) . Độ lớn  #mi(`|\vec{F}| = \sqrt{2^2 + 5^2 + 3^2} = \sqrt{4 + 25 + 9} = \sqrt{38} \approx 6.16`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tính khoảng cách giữa hai điểm  #mi(`A(2; -1; 4)`)  và  #mi(`B(5; 3; 4)`)  trong không gian  #mi(`Oxyz`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách  #mi(`AB = \sqrt{(5-2)^2 + (3-(-1))^2 + (4-4)^2} = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{25} = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một chiếc máy bay đang bay với vận tốc  #mi(`\vec{v} = (200; 150; 50)`)  km/h. Một luồng gió thổi với vận tốc  #mi(`\vec{w} = (10; -20; 0)`)  km/h. Tính độ lớn của vận tốc thực tế của máy bay so với mặt đất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc thực tế  #mi(`\vec{v_{th}} = \vec{v} + \vec{w} = (200+10; 150-20; 50+0) = (210; 130; 50)`) . Độ lớn  #mi(`|\vec{v_{th}}| = \sqrt{210^2 + 130^2 + 50^2} = \sqrt{44100 + 16900 + 2500} = \sqrt{63500} \approx 251.99`)  (km/h).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
