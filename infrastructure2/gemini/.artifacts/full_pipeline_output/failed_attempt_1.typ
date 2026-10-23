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
  #text(size: 13pt, weight: "bold")[Vectơ và Hệ Tọa Độ trong Không Gian] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp nền tảng kiến thức toàn diện về Vectơ trong không gian, mở rộng từ hình học phẳng lên không gian 3 chiều. Nội dung bao gồm các định nghĩa cơ bản, phép toán cộng, trừ, nhân vectơ với một số, tích vô hướng, góc giữa hai vectơ, và ứng dụng hệ tọa độ Oxyz để giải quyết các bài toán hình học không gian thông qua tọa độ hóa.]
]
#v(6pt)

// ==================== DẠNG 1: Khái niệm và Đặc trưng Vectơ trong Không Gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Khái niệm và Đặc trưng Vectơ trong Không Gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vectơ trong không gian là một đoạn thẳng có hướng, xác định bởi điểm đầu và điểm cuối.
  - Hai vectơ được gọi là bằng nhau ( #mi(`\vec{a} = \vec{b}`) ) nếu chúng có cùng hướng và cùng độ dài.
  - Hai vectơ được gọi là đối nhau nếu chúng ngược hướng và có cùng độ dài (vectơ đối của  #mi(`\vec{AB}`)  là  #mi(`\vec{BA}`) ).
  - Giá của vectơ là đường thẳng đi qua điểm đầu và điểm cuối của vectơ đó.
  - Vectơ  #mi(`\vec{0}`)  có độ dài bằng  #mi(`0`)  và cùng phương, cùng hướng với mọi vectơ.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn biết hai vectơ có bằng nhau không? Kiểm tra 'Cùng hướng + Cùng độ dài'. Nếu thiếu một trong hai, chúng không bằng nhau!
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng có  #mi(`...`)  và  #mi(`...`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . Có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại của tứ diện gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có tất cả  #mi(`3`)  vectơ.]
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
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo của hình lập phương:  #mi(`|\vec{u}| = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định số lượng vectơ:] Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . a) Có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Trong các vectơ tìm được ở câu a, những vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABC)`) ?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ khác  #mi(`\vec{0}`) . b) Trong các vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) , chỉ có  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  có giá nằm trong mặt phẳng  #mi(`(ABC)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Kiểm tra tính bằng nhau của vectơ:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . a) Trong ba vectơ  #mi(`\vec{BC}`) ,  #mi(`\vec{CC'}`)  và  #mi(`\vec{B'B}`) , vectơ nào bằng  #mi(`\vec{AA'}`) ? b) Giải thích vì sao.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Vectơ bằng  #mi(`\vec{AA'}`)  là  #mi(`\vec{CC'}`) . b) Vì mặt bên  #mi(`ACC'A'`)  là hình bình hành nên  #mi(`\vec{AA'} = \vec{CC'}`)  (cùng hướng và cùng độ dài). Vectơ  #mi(`\vec{B'B}`)  ngược hướng với  #mi(`\vec{AA'}`)  nên  #mi(`\vec{B'B} = -\vec{AA'}`) . Vectơ  #mi(`\vec{BC}`)  không cùng phương với  #mi(`\vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định giá của vectơ:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Trong các vectơ  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) ,  #mi(`\vec{AD'}`) , vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABCD)`) ?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giá của  #mi(`\vec{AC}`)  là đường thẳng  #mi(`AC`) . Giá của  #mi(`\vec{AD}`)  là đường thẳng  #mi(`AD`) . Giá của  #mi(`\vec{AD'}`)  là đường thẳng  #mi(`AD'`) . Vì đường thẳng  #mi(`AC`)  và  #mi(`AD`)  đều nằm trong mặt phẳng  #mi(`(ABCD)`) , nên các vectơ có giá nằm trong mặt phẳng  #mi(`(ABCD)`)  là  #mi(`\vec{AC}`)  và  #mi(`\vec{AD}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Vectơ đối và vectơ không:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{BA} = \vec{0}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa vectơ đối,  #mi(`\vec{BA}`)  là vectơ đối của  #mi(`\vec{AB}`)  vì chúng ngược hướng và có cùng độ dài. Tổng của hai vectơ đối nhau luôn bằng vectơ  #mi(`\vec{0}`) . Vậy  #mi(`\vec{AB} + \vec{BA} = \vec{0}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`) . Có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại là  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình chóp  #mi(`S.ABC`)  có đáy là tam giác  #mi(`ABC`) . Có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  có điểm đầu là  #mi(`S`)  và điểm cuối là một trong các đỉnh còn lại của hình chóp?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là  #mi(`S`)  và điểm cuối là các đỉnh còn lại là  #mi(`\vec{SA}`) ,  #mi(`\vec{SB}`) ,  #mi(`\vec{SC}`) . Vậy có  #mi(`3`)  vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Trong các vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{BC}`) ,  #mi(`\vec{CD}`) ,  #mi(`\vec{DA}`) ,  #mi(`\vec{AA'}`) ,  #mi(`\vec{CC'}`) , vectơ nào bằng  #mi(`\vec{BB'}`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{BB'} = \vec{AA'} = \vec{CC'} = \vec{DD'}`) . Vậy vectơ bằng  #mi(`\vec{BB'}`)  là  #mi(`\vec{AA'}`) ,  #mi(`\vec{CC'}`)  và  #mi(`\vec{DD'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Cho biết  #mi(`\vec{AB} = \vec{u}`)  và  #mi(`\vec{AD} = \vec{v}`) . Hãy xác định xem vectơ  #mi(`\vec{BA}`)  có bằng vectơ  #mi(`\vec{AB}`)  không và giải thích.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ  #mi(`\vec{BA}`)  không bằng vectơ  #mi(`\vec{AB}`)  vì mặc dù chúng có cùng độ dài nhưng chúng ngược hướng nhau. Để hai vectơ bằng nhau, chúng phải cùng hướng và cùng độ dài.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Phép Cộng Vectơ và Quy tắc Hình hộp ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Phép Cộng Vectơ và Quy tắc Hình hộp]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ cùng một đỉnh dọc theo ba cạnh là  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (với  #mi(`\vec{AC'}`)  là vectơ đường chéo chính).
  - Quy tắc ba điểm (nối tiếp): Với ba điểm  #mi(`A, B, C`)  bất kì, ta có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm đường chéo chính của hình hộp, hãy cộng 3 vectơ cạnh xuất phát từ cùng một đỉnh!
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta luôn có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo chính  #mi(`AC'`) . Trong hình lập phương cạnh  #mi(`a`) , độ dài đường chéo chính là  #mi(`a\sqrt{3}`) . Với  #mi(`a=2`) , ta có  #mi(`AC' = 2\sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AC} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình bình hành ở đáy  #mi(`ABCD`) , ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = \vec{a} + \vec{b}`) . Do đó,  #mi(`\vec{v} = (\vec{a} + \vec{b}) + \vec{c} = \vec{a} + \vec{b} + \vec{c}`) . Đây chính là vectơ đường chéo chính  #mi(`\vec{AC'}`) . Nếu giả sử các vectơ  #mi(`\vec{a}, \vec{b}, \vec{c}`)  có độ dài bằng  #mi(`1`)  và đôi một vuông góc, thì  #mi(`|\vec{v}| = \sqrt{1^2+1^2+1^2} = \sqrt{3}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp cơ bản:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (theo quy tắc hình bình hành cho đáy  #mi(`ABCD`) ). Tiếp theo, áp dụng quy tắc ba điểm:  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`)  (vì trong hình hộp,  #mi(`\vec{AA'} = \vec{CC'}`) ). Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính độ dài đường chéo hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  là độ dài đường chéo chính  #mi(`AC'`) . Áp dụng công thức tính đường chéo hình lập phương:  #mi(`AC' = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{a^2 + a^2 + a^2} = a\sqrt{3}`) . Vậy  #mi(`|\vec{u}| = a\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể tổng các vectơ cạnh:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Cho biết  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Tính vectơ  #mi(`\vec{v} = \vec{AC} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = \vec{a} + \vec{b}`) . Thay vào biểu thức ta được:  #mi(`\vec{v} = (\vec{a} + \vec{b}) + \vec{c} = \vec{a} + \vec{b} + \vec{c}`) . Theo quy tắc hình hộp, đây chính là vectơ đường chéo chính  #mi(`\vec{AC'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kết hợp quy tắc hình bình hành:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xét đáy  #mi(`ABCD`)  là hình bình hành, ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . \nBước 2: Xét mặt bên  #mi(`ACC'A'`)  là hình bình hành, ta có  #mi(`\vec{AC} + \vec{CC'} = \vec{AC'}`) . \nBước 3: Vì  #mi(`\vec{AA'} = \vec{CC'}`) , thay vào ta được  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) . \nKết hợp lại:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . (đpcm).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình bình hành cho đáy  #mi(`ABCD`) :  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Áp dụng quy tắc ba điểm:  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`)  (do  #mi(`\vec{AA'} = \vec{CC'}`) ). Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`3`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài đường chéo chính của hình lập phương cạnh  #mi(`3`)  là  #mi(`AC' = 3\sqrt{3}`) . Vậy  #mi(`|\vec{u}| = 3\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Tính vectơ  #mi(`\vec{v} = \vec{AC} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = \vec{a} + \vec{b}`) . Do đó,  #mi(`\vec{v} = (\vec{a} + \vec{b}) + \vec{c} = \vec{a} + \vec{b} + \vec{c}`) . Đây chính là vectơ đường chéo chính  #mi(`\vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{w} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{w} = \vec{AC'}`) . Độ dài đường chéo chính của hình lập phương cạnh  #mi(`1`)  là  #mi(`AC' = 1\sqrt{3} = \sqrt{3}`) . Vậy  #mi(`|\vec{w}| = \sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Quy tắc Trung điểm và Trọng tâm bằng Biểu thức Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Quy tắc Trung điểm và Trọng tâm bằng Biểu thức Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm  #mi(`M`)  là trung điểm của đoạn thẳng  #mi(`AB`)  khi và chỉ khi:  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  hoặc với điểm  #mi(`O`)  bất kì:  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`) 
  - Điểm  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`)  khi và chỉ khi:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  hoặc với điểm  #mi(`O`)  bất kì:  #mi(`\vec{OG} = \frac{1}{3}(\vec{OA} + \vec{OB} + \vec{OC})`) 
  - Điểm  #mi(`I`)  là trọng tâm của tứ diện  #mi(`ABCD`)  khi và chỉ khi:  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`)  hoặc với điểm  #mi(`O`)  bất kì:  #mi(`\vec{OI} = \frac{1}{4}(\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD})`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ hệ số: Trung điểm là  #mi(`\frac{1}{2}`) , Trọng tâm tam giác là  #mi(`\frac{1}{3}`) , Trọng tâm tứ diện là  #mi(`\frac{1}{4}`) 
  ]
  - *Công thức cốt lõi:* Với điểm  #mi(`O`)  bất kì, trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  thỏa mãn  #mi(`\vec{OG} = \_{...}(\vec{OA} + \vec{OB} + \vec{OC})`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 0; 1)`)  và  #mi(`C(5; 4; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3;2;3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G(x; y; z)`)  được tính theo công thức:  #mi(`x = \frac{x_A + x_B + x_C}{3} = \frac{1 + 3 + 5}{3} = 3`) ;  #mi(`y = \frac{y_A + y_B + y_C}{3} = \frac{2 + 0 + 4}{3} = 2`) ;  #mi(`z = \frac{z_A + z_B + z_C}{3} = \frac{3 + 1 + 5}{3} = 3`) . Vậy  #mi(`G(3; 2; 3)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho đoạn thẳng  #mi(`AB`)  có  #mi(`A(2; -4; 6)`)  và  #mi(`B(4; 0; -2)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3;-2;2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M(x; y; z)`)  được tính theo công thức:  #mi(`x = \frac{x_A + x_B}{2} = \frac{2 + 4}{2} = 3`) ;  #mi(`y = \frac{y_A + y_B}{2} = \frac{-4 + 0}{2} = -2`) ;  #mi(`z = \frac{z_A + z_B}{2} = \frac{6 - 2}{2} = 2`) . Vậy  #mi(`M(3; -2; 2)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc trung điểm:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 0)`)  và  #mi(`C(5; -2; 4)`) . Tìm tọa độ trung điểm  #mi(`M`)  của cạnh  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`AB`)  nên tọa độ của  #mi(`M`)  là:  #mi(`x_M = \frac{1 + 3}{2} = 2`) ;  #mi(`y_M = \frac{0 + 2}{2} = 1`) ;  #mi(`z_M = \frac{2 + 0}{2} = 1`) . Vậy  #mi(`M(2; 1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc trọng tâm tam giác:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 4; -1)`) ,  #mi(`B(4; -2; 3)`)  và  #mi(`C(0; 0; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên tọa độ của  #mi(`G`)  là:  #mi(`x_G = \frac{2 + 4 + 0}{3} = 2`) ;  #mi(`y_G = \frac{4 - 2 + 0}{3} = \frac{2}{3}`) ;  #mi(`z_G = \frac{-1 + 3 + 5}{3} = \frac{7}{3}`) . Vậy  #mi(`G(2; \frac{2}{3}; \frac{7}{3})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(3; 1; 1)`) ,  #mi(`C(1; 3; 1)`)  và  #mi(`D(1; 1; 5)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên tọa độ của  #mi(`I`)  là:  #mi(`x_I = \frac{1 + 3 + 1 + 1}{4} = \frac{6}{4} = 1.5`) ;  #mi(`y_I = \frac{1 + 1 + 3 + 1}{4} = \frac{6}{4} = 1.5`) ;  #mi(`z_I = \frac{1 + 1 + 1 + 5}{4} = \frac{8}{4} = 2`) . Vậy  #mi(`I(1.5; 1.5; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Chứng minh bằng biểu thức vectơ:] Cho tam giác  #mi(`ABC`) . Chứng minh rằng nếu  #mi(`M`)  là trung điểm của  #mi(`BC`)  thì  #mi(`\vec{AB} + \vec{AC} = 2\vec{AM}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  is the midpoint of  #mi(`BC`) , we have  #mi(`\vec{MB} + \vec{MC} = \vec{0}`) . Theo quy tắc trung điểm, với điểm  #mi(`A`)  bất kì, ta có  #mi(`\vec{AM} = \frac{1}{2}(\vec{AB} + \vec{AC})`) . Nhân cả hai vế với 2, ta được  #mi(`\vec{AB} + \vec{AC} = 2\vec{AM}`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(6; 0; 0)`)  và  #mi(`C(0; 6; 0)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trọng tâm  #mi(`G`)  là:  #mi(`x_G = \frac{0 + 6 + 0}{3} = 2`) ;  #mi(`y_G = \frac{0 + 0 + 6}{3} = 2`) ;  #mi(`z_G = \frac{0 + 0 + 0}{3} = 0`) . Vậy  #mi(`G(2; 2; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(3; 3; 3)`) ,  #mi(`B(6; 3; 3)`)  và  #mi(`C(3; 6; 3)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trọng tâm  #mi(`G`)  là:  #mi(`x_G = \frac{3 + 6 + 3}{3} = 4`) ;  #mi(`y_G = \frac{3 + 3 + 6}{3} = 4`) ;  #mi(`z_G = \frac{3 + 3 + 3}{3} = 3`) . Vậy  #mi(`G(4; 4; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(4; 0; 0)`) ,  #mi(`C(0; 4; 0)`)  và  #mi(`D(0; 0; 4)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trọng tâm  #mi(`I`)  là:  #mi(`x_I = \frac{0 + 4 + 0 + 0}{4} = 1`) ;  #mi(`y_I = \frac{0 + 0 + 4 + 0}{4} = 1`) ;  #mi(`z_I = \frac{0 + 0 + 0 + 4}{4} = 1`) . Vậy  #mi(`I(1; 1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 2; 2)`)  và  #mi(`C(3; 3; 3)`) . Tìm tọa độ trung điểm  #mi(`M`)  của cạnh  #mi(`BC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{2 + 3}{2} = 2.5`) ;  #mi(`y_M = \frac{2 + 3}{2} = 2.5`) ;  #mi(`z_M = \frac{2 + 3}{2} = 2.5`) . Vậy  #mi(`M(2.5; 2.5; 2.5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Biến đổi và Chứng minh Đẳng thức Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Biến đổi và Chứng minh Đẳng thức Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Sử dụng quy tắc chèn điểm (quy tắc ba điểm):  #mi(`\vec{XY} = \vec{XZ} + \vec{ZY}`)  để biến đổi các vectơ về cùng một điểm đầu hoặc điểm cuối.
  - Sử dụng tính chất hình hộp/lăng trụ: Thay thế các vectơ bằng nhau (ví dụ trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} = \vec{DC}`) ,  #mi(`\vec{AD} = \vec{BC}`) ,  #mi(`\vec{AA'} = \vec{BB'} = \vec{CC'} = \vec{DD'}`) ).
  - Áp dụng quy tắc hình hộp: Tổng ba vectơ xuất phát từ một đỉnh dọc theo ba cạnh bằng vectơ đường chéo xuất phát từ đỉnh đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh đẳng thức vectơ: Một là 'chèn điểm' để nối đuôi, hai là 'thay thế' vectơ bằng nhau trong hình hộp/lăng trụ.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{BC} + \vec{DD'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.41]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`DD'C'C`)  là hình bình hành nên  #mi(`\vec{DD'} = \vec{CC'}`) . Khi đó  #mi(`\vec{u} = \vec{BC} + \vec{CC'} = \vec{BC'}`)  (theo quy tắc ba điểm). Độ dài  #mi(`|\vec{u}| = BC' = \sqrt{BC^2 + CC'^2} = \sqrt{1^2 + 1^2} = \sqrt{2}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.73]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài  #mi(`|\vec{v}| = AC' = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh đẳng thức trong tứ diện (Kỹ thuật chèn điểm):] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Biến đổi vế trái (VT):
 #mi(`\vec{AC} + \vec{BD} = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD})`)  (chèn điểm  #mi(`D`)  vào  #mi(`\vec{AC}`)  và điểm  #mi(`C`)  vào  #mi(`\vec{BD}`) )
 #mi(`= \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) 
 #mi(`= \vec{AD} + \vec{BC} + \vec{0} = \vec{AD} + \vec{BC} = \text{VP}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Chứng minh đẳng thức trong hình hộp (Kỹ thuật thay thế):] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`) .\nThay vào biểu thức vế trái:
 #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AD} + \vec{AB} + \vec{AA'}`) \nTheo quy tắc hình hộp, tổng ba vectơ xuất phát từ đỉnh  #mi(`A`)  dọc theo ba cạnh là  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nVậy  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến đổi vectơ trong hình hộp (Kết hợp chèn điểm và thay thế):] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{CD} - \vec{CC'} = \vec{0}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{CD} = \vec{BA}`)  (vì  #mi(`\vec{CD}`)  và  #mi(`\vec{BA}`)  cùng hướng và cùng độ dài).\nKhi đó:  #mi(`\vec{AB} + \vec{CD} = \vec{AB} + \vec{BA} = \vec{0}`) .\nBiểu thức trở thành:  #mi(`\vec{0} - \vec{CC'} = -\vec{CC'} = \vec{C'C}`) .
(Lưu ý: Đề bài yêu cầu chứng minh  #mi(`\vec{AB} + \vec{CD} - \vec{CC'} = \vec{0}`)  là sai, kết quả đúng phải là  #mi(`\vec{C'C}`) ). Nếu đề bài là  #mi(`\vec{AB} + \vec{CD} + \vec{C'C} = \vec{0}`)  thì ta có  #mi(`\vec{AB} + \vec{BA} + \vec{C'C} = \vec{0} + \vec{C'C} = \vec{C'C}`) .\nXét lại:  #mi(`\vec{AB} + \vec{CD} = \vec{0}`) . Vậy  #mi(`\vec{AB} + \vec{CD} - \vec{CC'} = -\vec{CC'} = \vec{C'C}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Chứng minh đẳng thức trong hình hộp (Quy tắc hình hộp):] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`) .\nKhi đó  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AD} + \vec{AB} + \vec{AA'}`) .\nTheo quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nVậy  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (MauChuan).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: VT =  #mi(`\vec{AB} + \vec{CD} = (\vec{AD} + \vec{DB}) + \vec{CD} = \vec{AD} + (\vec{DB} + \vec{CD}) = \vec{AD} + \vec{CB}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (TuongTu100).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: VT =  #mi(`\vec{AC} + \vec{BD} = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD}) = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD}) = \vec{AD} + \vec{BC} + \vec{0} = \vec{AD} + \vec{BC}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (TuongTu100).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`) , nên  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AD} + \vec{AB} + \vec{AA'}`) . Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (BienTheNhe).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đây là áp dụng trực tiếp quy tắc hình hộp: Tổng ba vectơ xuất phát từ một đỉnh  #mi(`A`)  dọc theo ba cạnh  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  bằng vectơ đường chéo xuất phát từ đỉnh đó là  #mi(`\vec{AC'}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (CungCo).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{BC} + \vec{DC} + \vec{BB'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`)  và  #mi(`\vec{BB'} = \vec{AA'}`) , nên  #mi(`\vec{BC} + \vec{DC} + \vec{BB'} = \vec{AD} + \vec{AB} + \vec{AA'}`) . Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Phân tích Vectơ theo các Vectơ Cơ sở ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Phân tích Vectơ theo các Vectơ Cơ sở]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc trung điểm: Nếu  #mi(`M`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`)  với mọi điểm  #mi(`O`) .
  - Quy tắc trọng tâm tam giác: Nếu  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`)  thì  #mi(`\vec{OG} = \frac{1}{3}(\vec{OA} + \vec{OB} + \vec{OC})`)  với mọi điểm  #mi(`O`) .
  - Quy tắc trọng tâm tứ diện: Nếu  #mi(`I`)  là trọng tâm của tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{PI} = \frac{1}{4}(\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`)  với mọi điểm  #mi(`P`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ hệ số: Trung điểm là  #mi(`\frac{1}{2}`) , Trọng tâm tam giác là  #mi(`\frac{1}{3}`) , Trọng tâm tứ diện là  #mi(`\frac{1}{4}`) .
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`I`)  là trọng tâm của tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} =`)  '...'.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Tính giá trị của biểu thức  #mi(`P = 3\vec{GA} + 3\vec{GB} + 3\vec{GC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Do đó  #mi(`P = 3(\vec{GA} + \vec{GB} + \vec{GC}) = 3\vec{0} = \vec{0}`) . Độ dài của vectơ  #mi(`\vec{0}`)  là  #mi(`0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Tính giá trị của biểu thức  #mi(`Q = 4\vec{IA} + 4\vec{IB} + 4\vec{IC} + 4\vec{ID}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . Do đó  #mi(`Q = 4(\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID}) = 4\vec{0} = \vec{0}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc trung điểm:] Cho đoạn thẳng  #mi(`AB`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Biểu diễn vectơ  #mi(`\vec{AM}`)  theo vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`AB`)  nên  #mi(`\vec{AM} = \\frac{1}{2}\vec{AB}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc trọng tâm tam giác:] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn vectơ  #mi(`\vec{AG}`)  theo hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{AG} = \\frac{1}{3}(\vec{AB} + \vec{AC})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Biểu diễn vectơ  #mi(`\vec{AI}`)  theo ba vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`)  và  #mi(`\vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{AI} = \\frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể kết hợp trung điểm và trọng tâm:] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Biểu diễn vectơ  #mi(`\vec{GM}`)  theo  #mi(`\vec{GA}`)  và  #mi(`\vec{GB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{GM} = \\frac{1}{2}(\vec{GA} + \vec{GB})`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn vectơ  #mi(`\vec{AG}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Biểu diễn vectơ  #mi(`\vec{AI}`)  theo  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`)  và  #mi(`\vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho đoạn thẳng  #mi(`AB`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Biểu diễn vectơ  #mi(`\vec{OM}`)  theo  #mi(`\vec{OA}`)  và  #mi(`\vec{OB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Biểu diễn vectơ  #mi(`\vec{AM}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`M`)  là trung điểm  #mi(`BC`)  nên  #mi(`\vec{BM} = \vec{MC} = \frac{1}{2}\vec{BC} = \frac{1}{2}(\vec{AC} - \vec{AB})`) . Do đó  #mi(`\vec{AM} = \vec{AB} + \vec{BM} = \vec{AB} + \frac{1}{2}(\vec{AC} - \vec{AB}) = \frac{1}{2}\vec{AB} + \frac{1}{2}\vec{AC}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tích vô hướng và Góc giữa hai Vectơ Hình học ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tích vô hướng và Góc giữa hai Vectơ Hình học]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được xác định bởi:  #mi(`\vec{a}\cdot\vec{b} = |\vec{a}||\vec{b}|\cos(\vec{a},\vec{b})`) 
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi  #mi(`\vec{a}\cdot\vec{b} = 0`) 
  - Định lý cosin trong tam giác:  #mi(`\cos A = \frac{b^2 + c^2 - a^2}{2bc}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm góc, hãy tính tích vô hướng trước, sau đó chia cho tích độ dài hai vectơ:  #mi(`\cos(\vec{a},\vec{b}) = \frac{\vec{a}\cdot\vec{b}}{|\vec{a}||\vec{b}|}`) 
  ]
  - *Công thức cốt lõi:* Công thức tính tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\vec{a}\cdot\vec{b} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a} = (1; 2; 3)`)  và  #mi(`\vec{b} = (-4; 1; 0)`) . Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -2]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot(-4) + 2\cdot 1 + 3\cdot 0 = -4 + 2 + 0 = -2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{a} = (2; 1; 5)`)  và  #mi(`\vec{b} = (2; 2; 1)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 11]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 2\cdot 2 + 1\cdot 2 + 5\cdot 1 = 4 + 2 + 5 = 11`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức tích vô hướng cơ bản:] Cho  #mi(`\vec{a} = (1; 4; 2)`)  và  #mi(`\vec{b} = (-4; 1; 0)`) . Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot(-4) + 4\cdot 1 + 2\cdot 0 = -4 + 4 + 0 = 0`) . Vậy  #mi(`\vec{a}\cdot\vec{b} = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc giữa hai vectơ:] Cho  #mi(`\vec{a} = (1; 2; 3)`)  và  #mi(`\vec{b} = (3; 0; 4)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 3 + 2\cdot 0 + 3\cdot 4 = 3 + 0 + 12 = 15`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2 + 2^2 + 3^2} = \sqrt{14}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{3^2 + 0^2 + 4^2} = 5`) . Suy ra  #mi(`\cos(\vec{a},\vec{b}) = \frac{15}{5\sqrt{14}} = \frac{3}{\sqrt{14}}`) . Vậy góc  #mi(`(\vec{a},\vec{b}) = \arccos(\frac{3}{\sqrt{14}})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Kiểm tra tính vuông góc:] Cho  #mi(`\vec{a} = (2; -1; 4)`)  và  #mi(`\vec{b} = (2; 4; 0)`) . Hai vectơ này có vuông góc với nhau không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 2\cdot 2 + (-1)\cdot 4 + 4\cdot 0 = 4 - 4 + 0 = 0`) . Vì  #mi(`\vec{a}\cdot\vec{b} = 0`)  nên hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Áp dụng định lý cosin trong tam giác:] Trong tam giác  #mi(`ABC`) , cho  #mi(`AB = 3`) ,  #mi(`AC = 4`)  và góc  #mi(`\cos A = 0.5`) . Tính độ dài cạnh  #mi(`BC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng định lý cosin:  #mi(`BC^2 = AB^2 + AC^2 - 2\cdot AB\cdot AC\cdot \cos A = 3^2 + 4^2 - 2\cdot 3\cdot 4\cdot 0.5 = 9 + 16 - 12 = 13`) . Vậy  #mi(`BC = \sqrt{13}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho  #mi(`\vec{a} = (3; 1; 2)`)  và  #mi(`\vec{b} = (-3; 0; 4)`) . Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 3\cdot(-3) + 1\cdot 0 + 2\cdot 4 = -9 + 0 + 8 = -1`) . Vậy  #mi(`\vec{a}\cdot\vec{b} = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho  #mi(`\vec{a} = (6; -1; 0)`)  và  #mi(`\vec{b} = (1; 2; 3)`) . Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 6\cdot 1 + (-1)\cdot 2 + 0\cdot 3 = 6 - 2 + 0 = 4`) . Vậy  #mi(`\vec{a}\cdot\vec{b} = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho  #mi(`\vec{a} = (1; 0; 5)`)  và  #mi(`\vec{b} = (1; 3; 9)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 1 + 0\cdot 3 + 5\cdot 9 = 1 + 0 + 45 = 46`) . Vậy  #mi(`\vec{a}\cdot\vec{b} = 46`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho  #mi(`\vec{a} = (2; 2; 1)`)  và  #mi(`\vec{b} = (x; 0; 4)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a}`)  vuông góc với  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}\cdot\vec{b} = 0 \Leftrightarrow 2\cdot x + 2\cdot 0 + 1\cdot 4 = 0 \Leftrightarrow 2x + 4 = 0 \Leftrightarrow x = -2`) . Vậy  #mi(`x = -2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Xác định Tọa độ Điểm và Vectơ trong Hệ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Xác định Tọa độ Điểm và Vectơ trong Hệ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tọa độ điểm  #mi(`M`)  đối với hệ trục  #mi(`Oxyz`)  được xác định bởi bộ ba số  #mi(`(x; y; z)`)  sao cho  #mi(`\vec{OM} = x\vec{i} + y\vec{j} + z\vec{k}`) . Khi đó  #mi(`M(x; y; z)`) .
  - Tọa độ của vectơ  #mi(`\vec{AB}`)  được tính bằng hiệu tọa độ điểm cuối và điểm đầu:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  - Tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`)  là  #mi(`I\left(\frac{x_A + x_B}{2}; \frac{y_A + y_B}{2}; \frac{z_A + z_B}{2}\right)`) .
  - Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là  #mi(`G\left(\frac{x_A + x_B + x_C}{3}; \frac{y_A + y_B + y_C}{3}; \frac{z_A + z_B + z_C}{3}\right)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm vectơ  #mi(`\vec{AB}`) , hãy lấy 'Đích trừ Điểm đầu' (B trừ A). Muốn tìm tọa độ trung điểm, hãy lấy 'Trung bình cộng' của các tọa độ.
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{AB}`)  được tính theo công thức  #mi(`\vec{AB} = (\dots; \dots; \dots)`)  với  #mi(`\dots`)  là hiệu tọa độ các thành phần tương ứng.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2; 2; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng hiệu tọa độ điểm  #mi(`B`)  trừ tọa độ điểm  #mi(`A`) :  #mi(`\vec{AB} = (3 - 1; 4 - 2; 5 - 3) = (2; 2; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`M(2; 4; 6)`)  và  #mi(`N(4; 0; 2)`) . Tìm tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`MN`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; 2; 4)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`I`)  được tính bằng trung bình cộng tọa độ của  #mi(`M`)  và  #mi(`N`) :  #mi(`x_I = \frac{2+4}{2} = 3`) ;  #mi(`y_I = \frac{4+0}{2} = 2`) ;  #mi(`z_I = \frac{6+2}{2} = 4`) . Vậy  #mi(`I(3; 2; 4)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tọa độ điểm từ hình vẽ:] Trong không gian  #mi(`Oxyz`) , cho một hình hộp chữ nhật  #mi(`OADB.CFME`)  có các cạnh nằm trên các trục tọa độ. Biết  #mi(`A(2; 0; 0)`) ,  #mi(`B(0; 3; 0)`) ,  #mi(`C(0; 0; 4)`) . Hãy xác định tọa độ của điểm  #mi(`M`)  sao cho  #mi(`\vec{OM} = 2\vec{i} + 3\vec{j} + 4\vec{k}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa tọa độ điểm, nếu  #mi(`\vec{OM} = x\vec{i} + y\vec{j} + z\vec{k}`)  thì điểm  #mi(`M`)  có tọa độ  #mi(`(x; y; z)`) . Áp dụng vào bài toán:  #mi(`\vec{OM} = 2\vec{i} + 3\vec{j} + 4\vec{k} \Rightarrow M(2; 3; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ vectơ từ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(5; -1; 2)`)  và  #mi(`B(2; 3; -4)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (2 - 5; 3 - (-1); -4 - 2) = (-3; 4; -6)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ trung điểm:] Cho tam giác  #mi(`ABC`)  có tọa độ các đỉnh là  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 0; 1)`)  và  #mi(`C(5; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`I`)  của cạnh  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`)  là:  #mi(`x_I = \frac{1+3}{2} = 2`) ;  #mi(`y_I = \frac{2+0}{2} = 1`) ;  #mi(`z_I = \frac{3+1}{2} = 2`) . Vậy  #mi(`I(2; 1; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ trọng tâm tam giác:] Cho tam giác  #mi(`ABC`)  có tọa độ các đỉnh là  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 4; 6)`)  và  #mi(`C(0; -2; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là:  #mi(`x_G = \frac{1+3+0}{3} = \frac{4}{3}`) ;  #mi(`y_G = \frac{0+4-2}{3} = \frac{2}{3}`) ;  #mi(`z_G = \frac{2+6+4}{3} = 4`) . Vậy  #mi(`G(\frac{4}{3}; \frac{2}{3}; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`P(4; -2; 5)`)  và  #mi(`Q(1; 1; 0)`) . Tìm tọa độ vectơ  #mi(`\vec{PQ}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{PQ} = (1 - 4; 1 - (-2); 0 - 5) = (-3; 3; -5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M(0; 5; -3)`)  và  #mi(`N(2; -1; 4)`) . Tìm tọa độ vectơ  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{MN} = (2 - 0; -1 - 5; 4 - (-3)) = (2; -6; 7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho tam giác  #mi(`ABC`)  có tọa độ các đỉnh là  #mi(`A(2; 2; 2)`) ,  #mi(`B(4; 0; 0)`)  và  #mi(`C(0; 4; 4)`) . Tìm tọa độ trung điểm  #mi(`I`)  của cạnh  #mi(`BC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_I = \frac{4+0}{2} = 2`) ;  #mi(`y_I = \frac{0+4}{2} = 2`) ;  #mi(`z_I = \frac{0+4}{2} = 2`) . Vậy  #mi(`I(2; 2; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(1; 1; 1)`)  và  #mi(`B(4; 5; 7)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  biết  #mi(`C(6; 3; 2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{1+4+6}{3} = \frac{11}{3}`) ;  #mi(`y_G = \frac{1+5+3}{3} = 3`) ;  #mi(`z_G = \frac{1+7+2}{3} = \frac{10}{3}`) . Vậy  #mi(`G(\frac{11}{3}; 3; \frac{10}{3})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Các Phép toán Tọa độ Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Các Phép toán Tọa độ Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hai vectơ  #mi(`\vec{a} = (x_a; y_a; z_a)`)  và  #mi(`\vec{b} = (x_b; y_b; z_b)`) , ta có:  #mi(`\vec{a} + \vec{b} = (x_a + x_b; y_a + y_b; z_a + z_b)`)  và  #mi(`\vec{a} - \vec{b} = (x_a - x_b; y_a - y_b; z_a - z_b)`) .
  - Tích của một số thực  #mi(`k`)  với vectơ  #mi(`\vec{a} = (x_a; y_a; z_a)`)  là:  #mi(`k\vec{a} = (kx_a; ky_a; kz_a)`) .
  - Nếu  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là tọa độ hai điểm, thì tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn cộng, trừ hay nhân vectơ tọa độ? Chỉ cần thực hiện phép tính tương ứng trên từng thành phần  #mi(`x, y, z`) !
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{a} + k\vec{b}`)  được tính bằng cách:  #mi(`(x_a + kx_b; y_a + ky_b; z_a + kz_b)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 2; -3)`)  và  #mi(`\vec{b} = (4; -1; 5)`) . Tính tọa độ vectơ  #mi(`\vec{u} = 2\vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (6; 3; -1)]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`2\vec{a} = 2(1; 2; -3) = (2; 4; -6)`) .\nKhi đó:  #mi(`\vec{u} = (2; 4; -6) + (4; -1; 5) = (2+4; 4-1; -6+5) = (6; 3; -1)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(5; 0; -1)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (4; -2; -4)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB}`)  được tính theo công thức:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (5 - 1; 0 - 2; -1 - 3) = (4; -2; -4)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Phép cộng và phép trừ vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; -1; 3)`)  và  #mi(`\vec{b} = (1; 4; -2)`) . Tính  #mi(`\vec{a} + \vec{b}`)  và  #mi(`\vec{a} - \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:\n #mi(`\vec{a} + \vec{b} = (2+1; -1+4; 3+(-2)) = (3; 3; 1)`) .\n #mi(`\vec{a} - \vec{b} = (2-1; -1-4; 3-(-2)) = (1; -5; 5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Phép nhân vectơ với một số:] Cho  #mi(`\vec{u} = (-3; 4; 1)`) . Tính tọa độ của vectơ  #mi(`3\vec{u}`)  và  #mi(`-2\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:\n #mi(`3\vec{u} = 3(-3; 4; 1) = (-9; 12; 3)`) .\n #mi(`-2\vec{u} = -2(-3; 4; 1) = (6; -8; -2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ vectơ từ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`M(2; -1; 4)`)  và  #mi(`N(5; 3; -2)`) . Tìm tọa độ vectơ  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{MN}`)  là:\n #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M) = (5 - 2; 3 - (-1); -2 - 4) = (3; 4; -6)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tổ hợp tuyến tính các vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 0; 2)`) ,  #mi(`\vec{b} = (2; -1; 1)`)  và  #mi(`\vec{c} = (0; 3; -1)`) . Tính tọa độ vectơ  #mi(`\vec{v} = 2\vec{a} - \vec{b} + 3\vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:\n #mi(`2\vec{a} = (2; 0; 4)`) \n #mi(`\vec{b} = (2; -1; 1)`) \n #mi(`3\vec{c} = (0; 9; -3)`) \n #mi(`\vec{v} = (2 - 2 + 0; 0 - (-1) + 9; 4 - 1 + (-3)) = (0; 10; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (3; 1; 5)`)  và  #mi(`\vec{b} = (-2; 4; 0)`) . Tính  #mi(`\vec{a} + \vec{b}`)  và  #mi(`\vec{a} - \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} + \vec{b} = (3-2; 1+4; 5+0) = (1; 5; 5)`) .\n #mi(`\vec{a} - \vec{b} = (3-(-2); 1-4; 5-0) = (5; -3; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (4; -2; 6)`)  và  #mi(`\vec{v} = (1; 3; -1)`) . Tính  #mi(`2\vec{u} - 3\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`2\vec{u} = (8; -4; 12)`) .\n #mi(`3\vec{v} = (3; 9; -3)`) .\n #mi(`2\vec{u} - 3\vec{v} = (8-3; -4-9; 12-(-3)) = (5; -13; 15)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hai điểm  #mi(`P(1; 4; -2)`)  và  #mi(`Q(3; -1; 5)`) . Tìm tọa độ vectơ  #mi(`\vec{PQ}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{PQ} = (3-1; -1-4; 5-(-2)) = (2; -5; 7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 2; 3)`) ,  #mi(`\vec{b} = (0; -1; 4)`)  và  #mi(`\vec{c} = (2; 1; -1)`) . Tìm tọa độ vectơ  #mi(`\vec{x}`)  thỏa mãn  #mi(`\vec{x} = 3\vec{a} + 2\vec{b} - \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`3\vec{a} = (3; 6; 9)`) .\n #mi(`2\vec{b} = (0; -2; 8)`) .\n #mi(`\vec{c} = (2; 1; -1)`) .\n #mi(`\vec{x} = (3+0-2; 6-2-1; 9+8-(-1)) = (1; 3; 18)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Tọa độ Trung điểm và Trọng tâm trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Tọa độ Trung điểm và Trọng tâm trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong không gian  #mi(`Oxyz`) , nếu  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là hai điểm bất kì, tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  là:  #mi(`M\big(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\big)`) .
  - Trong không gian  #mi(`Oxyz`) , nếu  #mi(`A(x_A; y_A; z_A)`) ,  #mi(`B(x_B; y_B; z_B)`)  và  #mi(`C(x_C; y_C; z_C)`)  là ba đỉnh của một tam giác, tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là:  #mi(`G\big(\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3}\big)`) .
  - Để tìm tọa độ điểm  #mi(`C`)  khi biết  #mi(`A, B`)  và trọng tâm  #mi(`G`) , ta sử dụng công thức:  #mi(`x_C = 3x_G - x_A - x_B`) ;  #mi(`y_C = 3y_G - y_A - y_B`) ;  #mi(`z_C = 3z_G - z_A - z_B`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Trung điểm là 'chia đôi' (chia 2), Trọng tâm tam giác là 'chia ba' (chia 3). Khi tìm điểm thứ ba, hãy 'nhân ba trọng tâm rồi trừ đi hai điểm đã biết'.
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  được tính bằng công thức  #mi(`G\big(\frac{...}{3}; \frac{...}{3}; \frac{...}{3}\big)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2; 3; 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M`)  được tính theo công thức:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+4}{2} = 3`) ;  #mi(`z_M = \frac{3+5}{2} = 4`) . Vậy  #mi(`M(2; 3; 4)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(3; 0; 0)`)  và  #mi(`C(0; 3; 0)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1; 1; 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G`)  được tính theo công thức:  #mi(`x_G = \frac{0+3+0}{3} = 1`) ;  #mi(`y_G = \frac{0+0+3}{3} = 1`) ;  #mi(`z_G = \frac{0+0+0}{3} = 0`) . Vậy  #mi(`G(1; 1; 0)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức trung điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; 4; -6)`)  và  #mi(`B(0; 0; 2)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trung điểm:  #mi(`x_M = \frac{2+0}{2} = 1`) ;  #mi(`y_M = \frac{4+0}{2} = 2`) ;  #mi(`z_M = \frac{-6+2}{2} = -2`) . Vậy  #mi(`M(1; 2; -2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức trọng tâm tam giác:] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trọng tâm:  #mi(`x_G = \frac{1+3+2}{3} = 2`) ;  #mi(`y_G = \frac{2+2+(-1)}{3} = 1`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ điểm khi biết trọng tâm (Biến thể 1):] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 9; -1)`) ,  #mi(`B(9; 4; 5)`)  và trọng tâm  #mi(`G(3; 0; 4)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên:  #mi(`x_C = 3x_G - x_A - x_B = 3(3) - 2 - 9 = 9 - 11 = -2`) ;  #mi(`y_C = 3y_G - y_A - y_B = 3(0) - 9 - 4 = -13`) ;  #mi(`z_C = 3z_G - z_A - z_B = 3(4) - (-1) - 5 = 12 + 1 - 5 = 8`) . Vậy  #mi(`C(-2; -13; 8)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ trung điểm trong bài toán kết hợp:] Cho  #mi(`A(1; 1; 1)`) ,  #mi(`B(5; 3; 7)`)  và  #mi(`C(4; 5; 2)`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`)  và  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) . Tìm tọa độ  #mi(`G`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đầu tiên, tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) :  #mi(`x_M = \frac{1+5}{2} = 3`) ;  #mi(`y_M = \frac{1+3}{2} = 2`) ;  #mi(`z_M = \frac{1+7}{2} = 4`) . Vậy  #mi(`M(3; 2; 4)`) . Tuy nhiên, đề bài yêu cầu tìm  #mi(`G`) , ta tính trực tiếp:  #mi(`x_G = \frac{1+5+4}{3} = \frac{10}{3}`) ;  #mi(`y_G = \frac{1+3+5}{3} = 3`) ;  #mi(`z_G = \frac{1+7+2}{3} = \frac{10}{3}`) . Vậy  #mi(`G(\frac{10}{3}; 3; \frac{10}{3})`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(4; -2; 0)`)  và  #mi(`B(2; 6; 4)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_M = \frac{4+2}{2} = 3`) ;  #mi(`y_M = \frac{-2+6}{2} = 2`) ;  #mi(`z_M = \frac{0+4}{2} = 2`) . Vậy  #mi(`M(3; 2; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 5; 7)`)  và  #mi(`B(3; -1; 3)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{5+(-1)}{2} = 2`) ;  #mi(`z_M = \frac{7+3}{2} = 5`) . Vậy  #mi(`M(2; 2; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 0; 4)`) ,  #mi(`B(4; 6; -2)`)  và  #mi(`C(0; -2; 0)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{2+4+0}{3} = 2`) ;  #mi(`y_G = \frac{0+6+(-2)}{3} = \frac{4}{3}`) ;  #mi(`z_G = \frac{4+(-2)+0}{3} = \frac{2}{3}`) . Vậy  #mi(`G(2; \frac{4}{3}; \frac{2}{3})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G(1; 1; 1)`)  và  #mi(`A(0; 2; -1)`) . Tìm tọa độ điểm  #mi(`B`)  biết  #mi(`C`)  có tọa độ  #mi(`(2; 0; 3)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`x_B = 3x_G - x_A - x_C = 3(1) - 0 - 2 = 1`) ;  #mi(`y_B = 3y_G - y_A - y_C = 3(1) - 2 - 0 = 1`) ;  #mi(`z_B = 3z_G - z_A - z_C = 3(1) - (-1) - 3 = 1`) . Vậy  #mi(`B(1; 1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Độ dài Vectơ và Khoảng cách giữa Hai điểm trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Độ dài Vectơ và Khoảng cách giữa Hai điểm trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Độ dài của vectơ  #mi(`\vec{a} = (x; y; z)`)  được tính bởi công thức:  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
  - Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là độ dài đoạn thẳng  #mi(`AB`) :  #mi(`AB = \sqrt{(x_B - x_A)^2 + (y_B - y_A)^2 + (z_B - z_A)^2}`) .
  - Khoảng cách từ điểm  #mi(`M(x; y; z)`)  đến gốc tọa độ  #mi(`O(0; 0; 0)`)  chính là độ dài vectơ  #mi(`\vec{OM}`) :  #mi(`OM = \sqrt{x^2 + y^2 + z^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính độ dài hay khoảng cách: Bình phương các hiệu tọa độ  #mi(`\rightarrow`)  Cộng lại  #mi(`\rightarrow`)  Lấy căn bậc hai.
  ]
  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{a}(x;y;z)`)  là  #mi(`|\vec{a}| = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tính độ dài của vectơ  #mi(`\vec{u} = (2; -2; 1)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức độ dài vectơ:  #mi(`|\vec{u}| = \sqrt{2^2 + (-2)^2 + 1^2} = \sqrt{4 + 4 + 1} = \sqrt{9} = 3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`P(1; 2; 2)`) . Tính khoảng cách từ điểm  #mi(`P`)  đến gốc tọa độ  #mi(`O`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Khoảng cách  #mi(`OP = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính độ dài vectơ cơ bản:] Tính độ dài của vectơ  #mi(`\vec{a} = (3; -4; 12)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính độ dài vectơ, ta có:  #mi(`|\vec{a}| = \sqrt{3^2 + (-4)^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính khoảng cách giữa hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 5; 7)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính khoảng cách giữa hai điểm, ta có:  #mi(`AB = \sqrt{(3-1)^2 + (5-2)^2 + (7-3)^2} = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{4 + 9 + 16} = \sqrt{29}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính khoảng cách đến gốc tọa độ:] Tìm khoảng cách từ điểm  #mi(`M(2; -1; 2)`)  đến gốc tọa độ  #mi(`O`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách từ  #mi(`M`)  đến gốc tọa độ  #mi(`O`)  là:  #mi(`OM = \sqrt{2^2 + (-1)^2 + 2^2} = \sqrt{4 + 1 + 4} = \sqrt{9} = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính chu vi tam giác:] Trong không gian  #mi(`Oxyz`) , cho ba điểm  #mi(`A(1; 0; 1), B(0; -3; 1), C(4; -1; 4)`) . Tính chu vi tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta tính độ dài ba cạnh của tam giác  #mi(`ABC`) :  #mi(`\begin{cases} AB = \sqrt{(0-1)^2 + (-3-0)^2 + (1-1)^2} = \sqrt{1 + 9 + 0} = \sqrt{10} \\ BC = \sqrt{(4-0)^2 + (-1-(-3))^2 + (4-1)^2} = \sqrt{16 + 4 + 9} = \sqrt{29} \\ AC = \sqrt{(4-1)^2 + (-1-0)^2 + (4-1)^2} = \sqrt{9 + 1 + 9} = \sqrt{19} \end{cases}`)  Chu vi tam giác  #mi(`ABC`)  là:  #mi(`P = AB + BC + AC = \sqrt{10} + \sqrt{29} + \sqrt{19}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Tính độ dài của vectơ  #mi(`\vec{u} = (2; -2; 1)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài vectơ  #mi(`\vec{u}`)  là:  #mi(`|\vec{u}| = \sqrt{2^2 + (-2)^2 + 1^2} = \sqrt{4 + 4 + 1} = \sqrt{9} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Tính độ dài của vectơ  #mi(`\vec{v} = (-3; 4; 0)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài vectơ  #mi(`\vec{v}`)  là:  #mi(`|\vec{v}| = \sqrt{(-3)^2 + 4^2 + 0^2} = \sqrt{9 + 16 + 0} = \sqrt{25} = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; 1; 3)`)  và  #mi(`B(5; 4; 3)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài đoạn thẳng  #mi(`AB`)  là:  #mi(`AB = \sqrt{(5-2)^2 + (4-1)^2 + (3-3)^2} = \sqrt{3^2 + 3^2 + 0^2} = \sqrt{18} = 3\sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Tìm khoảng cách từ điểm  #mi(`P(1; 2; 2)`)  đến gốc tọa độ  #mi(`O`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách  #mi(`OP = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Tích vô hướng bằng Tọa độ trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Tích vô hướng bằng Tọa độ trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hai vectơ  #mi(`\vec{a}=(x_1;y_1;z_1)`)  và  #mi(`\vec{b}=(x_2;y_2;z_2)`) , tích vô hướng được tính bằng:  #mi(`\vec{a}\cdot\vec{b} = x_1x_2 + y_1y_2 + z_1z_2`) 
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng  #mi(`0`)  ( #mi(`\vec{a}\cdot\vec{b} = 0`) )
  - Tích vô hướng của một vectơ với một số thực  #mi(`k`)  và một vectơ khác:  #mi(`\vec{a}\cdot(k\vec{b}) = k(\vec{a}\cdot\vec{b})`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn kiểm tra vuông góc nhanh: Nhân các tọa độ tương ứng rồi cộng lại, nếu tổng bằng  #mi(`0`)  thì chúng vuông góc!
  ]
  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a}=(x_1;y_1;z_1)`)  và  #mi(`\vec{b}=(x_2;y_2;z_2)`)  là  #mi(`\vec{a}\cdot\vec{b} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;2;-1)`)  và  #mi(`\vec{b}=(3;0;6)`) . Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -3]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tích vô hướng:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot3 + 2\cdot0 + (-1)\cdot6 = 3 + 0 - 6 = -3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{a}=(2;1;2)`)  và  #mi(`\vec{b}=(x;4;1)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -3]
      \ #text(fill: rgb("#334155"))[Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}\cdot\vec{b} = 0`) . Ta có:  #mi(`2\cdot x + 1\cdot4 + 2\cdot1 = 0 \Leftrightarrow 2x + 4 + 2 = 0 \Leftrightarrow 2x + 6 = 0 \Leftrightarrow x = -3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2; -1; 3)`)  và  #mi(`\vec{b}=(4; 2; -1)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tích vô hướng:  #mi(`\vec{a}\cdot\vec{b} = 2\cdot4 + (-1)\cdot2 + 3\cdot(-1) = 8 - 2 - 3 = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Kiểm tra tính vuông góc:] Cho  #mi(`\vec{u}=(1; 2; 2)`)  và  #mi(`\vec{v}=(2; 1; -2)`) . Chứng minh rằng  #mi(`\vec{u} \perp \vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta tính tích vô hướng của hai vectơ:  #mi(`\vec{u}\cdot\vec{v} = 1\cdot2 + 2\cdot1 + 2\cdot(-2) = 2 + 2 - 4 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\vec{u} \perp \vec{v}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tích vô hướng của vectơ tổng:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1; 0; 2)`)  và  #mi(`\vec{b}=(3; -1; 1)`) . Tính  #mi(`\vec{a}\cdot(\vec{a}+\vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tìm tọa độ vectơ tổng  #mi(`\vec{c} = \vec{a}+\vec{b} = (1+3; 0+(-1); 2+1) = (4; -1; 3)`) . Bước 2: Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{c} = 1\cdot4 + 0\cdot(-1) + 2\cdot3 = 4 + 0 + 6 = 10`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tích vô hướng của vectơ hiệu:] Cho  #mi(`\vec{a}=(2; 3; -1)`)  và  #mi(`\vec{b}=(1; -1; 2)`) . Tính  #mi(`\vec{a}\cdot(\vec{a}-\vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tìm tọa độ vectơ hiệu  #mi(`\vec{d} = \vec{a}-\vec{b} = (2-1; 3-(-1); -1-2) = (1; 4; -3)`) . Bước 2: Tính tích vô hướng  #mi(`\vec{a}\cdot\vec{d} = 2\cdot1 + 3\cdot4 + (-1)\cdot(-3) = 2 + 12 + 3 = 17`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(3; 4; -2)`)  và  #mi(`\vec{b}=(1; -1; 5)`) . Tính  #mi(`\vec{a}\cdot\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{a}\cdot\vec{b} = 3\cdot1 + 4\cdot(-1) + (-2)\cdot5 = 3 - 4 - 10 = -11`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(5; 2; 1)`)  và  #mi(`\vec{v}=(-2; 3; 4)`) . Tính  #mi(`\vec{u}\cdot\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{u}\cdot\vec{v} = 5\cdot(-2) + 2\cdot3 + 1\cdot4 = -10 + 6 + 12 = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho  #mi(`\vec{a}=(1; 1; 1)`)  và  #mi(`\vec{b}=(x; 2; 3)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}\cdot\vec{b} = 0 \Leftrightarrow 1\cdot x + 1\cdot2 + 1\cdot3 = 0 \Leftrightarrow x + 5 = 0 \Leftrightarrow x = -5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho  #mi(`\vec{a}=(2; -1; 0)`)  và  #mi(`\vec{b}=(1; 3; 4)`) . Tính  #mi(`\vec{a}\cdot(\vec{a}+\vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bước 1:  #mi(`\vec{c} = \vec{a}+\vec{b} = (2+1; -1+3; 0+4) = (3; 2; 4)`) . Bước 2:  #mi(`\vec{a}\cdot\vec{c} = 2\cdot3 + (-1)\cdot2 + 0\cdot4 = 6 - 2 + 0 = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Góc giữa hai Vectơ trong Hệ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Góc giữa hai Vectơ trong Hệ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hai vectơ  #mi(`\vec{a}=(x_1;y_1;z_1)`)  và  #mi(`\vec{b}=(x_2;y_2;z_2)`)  khác  #mi(`\vec{0}`) , tích vô hướng được tính bởi:  #mi(`\vec{a}\cdot\vec{b} = x_1x_2 + y_1y_2 + z_1z_2`) .
  - Góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được xác định bởi công thức:  #mi(`\cos(\vec{a},\vec{b}) = \\frac{\vec{a}\cdot\vec{b}}{|\vec{a}|\cdot|\vec{b}|} = \\frac{x_1x_2 + y_1y_2 + z_1z_2}{\sqrt{x_1^2+y_1^2+z_1^2}\cdot\sqrt{x_2^2+y_2^2+z_2^2}}`) .
  - Nếu  #mi(`\vec{a}\cdot\vec{b} = 0`)  thì hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau ( #mi(`\vec{a} \perp \vec{b}`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tính góc nhanh, hãy tính Tích vô hướng trước, sau đó tính Độ dài từng vectơ, rồi mới thực hiện phép chia cuối cùng.
  ]
  - *Công thức cốt lõi:* Công thức tính cosin góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\cos(\vec{a},\vec{b}) =`) ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;2;2)`)  và  #mi(`\vec{b}=(2;2;1)`) . Tính  #mi(`\cos(\vec{a},\vec{b})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 8/9]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 2 + 2\cdot 2 + 2\cdot 1 = 2 + 4 + 2 = 8`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2+2^2+2^2} = \sqrt{9} = 3`) . Độ dài  #mi(`|\vec{b}| = \sqrt{2^2+2^2+1^2} = \sqrt{9} = 3`) . Vậy  #mi(`\cos(\vec{a},\vec{b}) = \frac{8}{3\cdot 3} = \frac{8}{9}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(1;0;1)`)  và  #mi(`\vec{v}=(0;1;0)`) . Tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 90]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{u}\cdot\vec{v} = 1\cdot 0 + 0\cdot 1 + 1\cdot 0 = 0`) . Vì tích vô hướng bằng 0 nên hai vectơ vuông góc với nhau. Góc giữa chúng là  #mi(`90^\circ`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cho vectơ chỉ phương:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a}=(1;2;3)`)  và  #mi(`\vec{b}=(4;5;6)`) . Tính  #mi(`\cos(\vec{a},\vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 4 + 2\cdot 5 + 3\cdot 6 = 4 + 10 + 18 = 32`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2+2^2+3^2} = \sqrt{14}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{4^2+5^2+6^2} = \sqrt{16+25+36} = \sqrt{77}`) . Vậy  #mi(`\cos(\vec{a},\vec{b}) = \frac{32}{\sqrt{14}\cdot\sqrt{77}} = \frac{32}{\sqrt{1078}}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc giữa hai vectơ từ các đỉnh hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng 1. Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'D'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chọn hệ trục tọa độ  #mi(`Oxyz`)  sao cho  #mi(`A(0;0;0), B(1;0;0), D(0;1;0), A'(0;0;1)`) . Khi đó  #mi(`C(1;1;0)`)  và  #mi(`D'(0;1;1)`) . Ta có  #mi(`\vec{AC}=(1;1;0)`)  và  #mi(`\vec{A'D'}=(0;1;1)-(0;0;1)=(0;1;0)`) . Tích vô hướng  #mi(`\vec{AC}\cdot\vec{A'D'} = 1\cdot 0 + 1\cdot 1 + 0\cdot 0 = 1`) . Độ dài  #mi(`|\vec{AC}| = \sqrt{1^2+1^2+0^2} = \sqrt{2}`) . Độ dài  #mi(`|\vec{A'D'}| = \sqrt{0^2+1^2+0^2} = 1`) . Vậy  #mi(`\cos(\vec{AC},\vec{A'D'}) = \frac{1}{\sqrt{2}\cdot 1} = \frac{1}{\sqrt{2}}`) . Suy ra góc giữa hai vectơ là  #mi(`45^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Kiểm tra tính vuông góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(2;-1;3)`)  và  #mi(`\vec{v}=(1;2;0)`) . Hai vectơ này có vuông góc với nhau không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có tích vô hướng  #mi(`\vec{u}\cdot\vec{v} = 2\cdot 1 + (-1)\cdot 2 + 3\cdot 0 = 2 - 2 + 0 = 0`) . Vì tích vô hướng bằng 0 nên hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  vuông góc với nhau.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ có chứa tham số:] Cho  #mi(`\vec{a}=(1;1;0)`)  và  #mi(`\vec{b}=(0;1;1)`) . Tính  #mi(`\cos(\vec{a},\vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 0 + 1\cdot 1 + 0\cdot 1 = 1`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2+1^2+0^2} = \sqrt{2}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{0^2+1^2+1^2} = \sqrt{2}`) . Vậy  #mi(`\cos(\vec{a},\vec{b}) = \frac{1}{\sqrt{2}\cdot\sqrt{2}} = \frac{1}{2}`) . Suy ra góc giữa hai vectơ là  #mi(`60^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2;1;2)`)  và  #mi(`\vec{b}=(1;2;2)`) . Tính  #mi(`\cos(\vec{a},\vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a}\cdot\vec{b} = 2\cdot 1 + 1\cdot 2 + 2\cdot 2 = 2 + 2 + 4 = 8`) . Độ dài  #mi(`|\vec{a}| = \sqrt{2^2+1^2+2^2} = 3`) . Độ dài  #mi(`|\vec{b}| = \sqrt{1^2+2^2+2^2} = 3`) . Vậy  #mi(`\cos(\vec{a},\vec{b}) = \frac{8}{3\cdot 3} = \frac{8}{9}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(3;0;4)`)  và  #mi(`\vec{v}=(4;0;3)`) . Tính  #mi(`\cos(\vec{u},\vec{v})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u}\cdot\vec{v} = 3\cdot 4 + 0\cdot 0 + 4\cdot 3 = 12 + 12 = 24`) . Độ dài  #mi(`|\vec{u}| = \sqrt{3^2+0^2+4^2} = 5`) . Độ dài  #mi(`|\vec{v}| = \sqrt{4^2+0^2+3^2} = 5`) . Vậy  #mi(`\cos(\vec{u},\vec{v}) = \frac{24}{5\cdot 5} = \frac{24}{25}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1;1;1)`)  và  #mi(`\vec{b}=(1;0;0)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 1 + 1\cdot 0 + 1\cdot 0 = 1`) . Độ dài  #mi(`|\vec{a}| = \sqrt{3}`) . Độ dài  #mi(`|\vec{b}| = 1`) . Vậy  #mi(`\cos(\vec{a},\vec{b}) = \frac{1}{\sqrt{3}}`) . Suy ra góc là  #mi(`\arccos(\frac{1}{\sqrt{3}})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng 2. Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ tọa độ  #mi(`Oxyz`)  sao cho  #mi(`A(0;0;0), B(2;0;0), D(0;2;0), A'(0;0;2)`) . Khi đó  #mi(`C(2;2;0)`) . Ta có  #mi(`\vec{AB}=(2;0;0)`)  và  #mi(`\vec{AC}=(2;2;0)`) . Tích vô hướng  #mi(`\vec{AB}\cdot\vec{AC} = 2\cdot 2 + 0\cdot 2 + 0\cdot 0 = 4`) . Độ dài  #mi(`|\vec{AB}| = 2`) . Độ dài  #mi(`|\vec{AC}| = \sqrt{2^2+2^2+0^2} = 2\sqrt{2}`) . Vậy  #mi(`\cos(\vec{AB},\vec{AC}) = \frac{4}{2\cdot 2\sqrt{2}} = \frac{1}{\sqrt{2}}`) . Suy ra góc là  #mi(`45^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Phương pháp Tọa độ hóa Giải toán Hình khối Chuyên sâu ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Phương pháp Tọa độ hóa Giải toán Hình khối Chuyên sâu]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để giải các bài toán hình học không gian phức tạp, ta thiết lập hệ trục tọa độ  #mi(`Oxyz`)  sao cho gốc  #mi(`O`)  trùng với một đỉnh và các trục  #mi(`Ox, Oy, Oz`)  trùng với các cạnh xuất phát từ đỉnh đó. Khi đó, tọa độ các đỉnh được xác định dựa trên độ dài các cạnh.
  - Tích vô hướng của hai vectơ  #mi(`\vec{a} = (x_1; y_1; z_1)`)  và  #mi(`\vec{b} = (x_2; y_2; z_2)`)  được tính theo công thức:  #mi(`\vec{a} \cdot \vec{b} = x_1x_2 + y_1y_2 + z_1z_2`) .
  - Góc  #mi(`\theta`)  giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được xác định qua công thức:  #mi(`\cos \theta = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|} = \frac{x_1x_2 + y_1y_2 + z_1z_2}{\sqrt{x_1^2 + y_1^2 + z_1^2} \cdot \sqrt{x_2^2 + y_2^2 + z_2^2}}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo 'Gốc - Trục - Đỉnh': Chọn Gốc tại đỉnh vuông góc, Trục trùng cạnh, Đỉnh xác định bằng độ dài cạnh.
  ]
  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\dots = x_1x_2 + y_1y_2 + z_1z_2`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`2`) . Chọn gốc tọa độ  #mi(`O`)  trùng với đỉnh  #mi(`A`) . Tìm tọa độ của vectơ  #mi(`\vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2;2;2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`A`)  trùng gốc tọa độ nên  #mi(`A(0;0;0)`) . Do cạnh bằng  #mi(`2`) , các đỉnh tương ứng là  #mi(`C(2;2;0)`)  và  #mi(`C'(2;2;2)`) . Vectơ  #mi(`\vec{AC'} = (2-0; 2-0; 2-0) = (2;2;2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a^2/2`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Trong tứ diện đều, góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  là  #mi(`60^\circ`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| \cdot |\vec{AC}| \cdot \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính góc trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`1`) . Thiết lập hệ trục tọa độ  #mi(`Oxyz`)  có gốc  #mi(`O`)  trùng với đỉnh  #mi(`A`) , các trục  #mi(`Ox, Oy, Oz`)  lần lượt trùng với các cạnh  #mi(`AB, AD, AA'`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{AD'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có tọa độ các đỉnh:  #mi(`A(0;0;0), C(1;1;0), D'(0;1;1)`) .\n #mi(`\vec{AC} = (1;1;0) \rightarrow |\vec{AC}| = \sqrt{1^2+1^2+0^2} = \sqrt{2}.`) \n #mi(`\vec{AD'} = (0;1;1) \rightarrow |\vec{AD'}| = \sqrt{0^2+1^2+1^2} = \sqrt{2}.`) \n #mi(`\vec{AC} \cdot \vec{AD'} = 1\cdot 0 + 1\cdot 1 + 0\cdot 1 = 1.\\n\cos(\vec{AC}, \vec{AD'}) = \frac{1}{\sqrt{2} \cdot \sqrt{2}} = \frac{1}{2}.\\n\Rightarrow \text{Góc giữa } \vec{AC} \text{ và } \vec{AD'} \text{ là } 60^\circ.`) 
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tích vô hướng trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  cạnh bằng  #mi(`a`) . Sử dụng phương pháp tọa độ hóa để tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đặt hệ trục tọa độ sao cho  #mi(`A(0;0;0)`) . Vì là tứ diện đều nên góc giữa các cặp vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`)  đều bằng  #mi(`60^\circ`) .\n #mi(`\vec{AB} \cdot \vec{AD} = |\vec{AB}| \cdot |\vec{AD}| \cdot \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}.`) 
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định tọa độ đỉnh hình hộp chữ nhật:] Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0;0;0), B(3;0;0), D(0;4;0)`) . Tìm tọa độ đỉnh  #mi(`C`)  và  #mi(`C'`) . Biết  #mi(`AA' = 5`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình chữ nhật đáy,  #mi(`A(0;0;0), B(3;0;0), D(0;4;0) \rightarrow C(3;4;0).`) \nVì  #mi(`AA'`)  song song với trục  #mi(`Oz`)  và  #mi(`AA'=5`) , nên  #mi(`A'(0;0;5).`) \nDo đó  #mi(`C'(3;4;5).`) 
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ trong không gian:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 2; -2)`)  và  #mi(`\vec{b} = (3; 0; 4)`) . Tính góc giữa hai vectơ này.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`|\vec{a}| = \sqrt{1^2+2^2+(-2)^2} = 3.\\n|\vec{b}| = \sqrt{3^2+0^2+4^2} = 5.\\n\vec{a} \cdot \vec{b} = 1\cdot 3 + 2\cdot 0 + (-2)\cdot 4 = 3 + 0 - 8 = -5.\\n\cos(\	ext{góc}) = \frac{-5}{3 \cdot 5} = -\frac{1}{3}.\\n\Rightarrow \text{Góc } \approx 109,47^\circ.`) 
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`3`) . Thiết lập hệ trục tọa độ  #mi(`Oxyz`)  có gốc  #mi(`O`)  trùng với  #mi(`A`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{BD'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`A(0;0;0), C(3;3;0), D'(0;3;3).`) \n #mi(`\vec{AC} = (3;3;0) \rightarrow |\vec{AC}| = 3\sqrt{2}.`) \n #mi(`\vec{BD'} = D' - B = (0;3;3) - (3;0;0) = (-3;3;3) \rightarrow |\vec{BD'}| = \sqrt{(-3)^2+3^2+3^2} = 3\sqrt{3}.`) \n #mi(`\vec{AC} \cdot \vec{BD'} = 3(-3) + 3(3) + 0(3) = 0.\\n\Rightarrow \text{Góc giữa } \vec{AC} \text{ và } \vec{BD'} \text{ là } 90^\circ.`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`2`) . Thiết lập hệ trục tọa độ  #mi(`Oxyz`)  có gốc  #mi(`O`)  trùng với  #mi(`A`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{AD'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`A(0;0;0), C(2;2;0), D'(0;2;2).`) \n #mi(`\vec{AC} = (2;2;0) \rightarrow |\vec{AC}| = 2\sqrt{2}.`) \n #mi(`\vec{AD'} = (0;2;2) \rightarrow |\vec{AD'}| = 2\sqrt{2}.`) \n #mi(`\vec{AC} \cdot \vec{AD'} = 2(0) + 2(2) + 0(2) = 4.\\n\cos(\text{góc}) = \frac{4}{2\sqrt{2} \cdot 2\sqrt{2}} = \frac{4}{8} = \frac{1}{2}.\\n\Rightarrow \text{Góc giữa } \vec{AC} \text{ và } \vec{AD'} \text{ là } 60^\circ.`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho tứ diện đều  #mi(`ABCD`)  cạnh bằng  #mi(`2`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì là tứ diện đều nên góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  là  #mi(`60^\circ`) .\n #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| \cdot |\vec{AC}| \cdot \cos(60^\circ) = 2 \cdot 2 \cdot \frac{1}{2} = 2.`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0;0;0), B(4;0;0), D(0;3;0), A'(0;0;2)`) . Tính góc giữa hai vectơ  #mi(`\vec{BD}`)  và  #mi(`\vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`B(4;0;0), D(0;3;0) \rightarrow \vec{BD} = (-4;3;0) \rightarrow |\vec{BD}| = 5.\\nC'(4;3;2), A'(0;0;2) \rightarrow \vec{A'C'} = (4;3;0) \rightarrow |\vec{A'C'}| = 5.\\n\vec{BD} \cdot \vec{A'C'} = (-4)(4) + 3(3) + 0(0) = -16 + 9 = -7.\\n\cos(\text{góc}) = \frac{-7}{5 \cdot 5} = -\frac{7}{25}.\\n\Rightarrow \text{Góc } \approx 106,26^\circ.`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Mô hình hóa Vật lý - Bài toán Hợp lực và Cân bằng Lực ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Mô hình hóa Vật lý - Bài toán Hợp lực và Cân bằng Lực]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hợp lực của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc với nhau có độ lớn là:  #mi(`|\vec{F}| = \sqrt{F_1^2 + F_2^2 + F_3^2}`) 
  - Điều kiện để một vật ở trạng thái cân bằng dưới tác dụng của các lực là tổng các vectơ lực bằng vectơ không:  #mi(`\vec{F_1} + \\vec{F_2} + \\dots + \\vec{F_n} = \vec{0}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Vuông góc thì dùng Pythagoras, Cân bằng thì dùng Tổng bằng 0!
  ]
  - *Công thức cốt lõi:* Độ lớn hợp lực của ba lực đôi một vuông góc là  #mi(`|\vec{F}| = \sqrt{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc có độ lớn lần lượt là  #mi(`20\text{ N}, 30\text{ N}, 40\text{ N}`) . Tính độ lớn hợp lực tác dụng lên vật.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 53.85]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì ba lực đôi một vuông góc, độ lớn hợp lực được tính theo công thức:  #mi(`|\vec{F}| = \sqrt{F_1^2 + F_2^2 + F_3^2} = \sqrt{20^2 + 30^2 + 40^2} = \sqrt{400 + 900 + 1600} = \sqrt{2900} = 10\sqrt{29} \approx 53.85\text{ N}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vecvec{F_2}, \vec{F_3}`)  có độ lớn lần lượt là  #mi(`10\text{ N}, 15\text{ N}, 25\text{ N}`) . Biết rằng  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  cùng hướng, còn  #mi(`\vec{F_3}`)  ngược hướng với  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`) . Tính độ lớn hợp lực.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Tổng các vectơ lực là  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`) . Vì  #mi(`\vec{F_1}, \vec{F_2}`)  cùng hướng và  #mi(`\vec{F_3}`)  ngược hướng, ta có:  #mi(`F = F_1 + F_2 - F_3 = 10 + 15 - 25 = 0\text{ N}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cho 3 lực vuông góc:] Một chiếc máy bay đang bay chịu tác dụng của ba lực: lực đẩy động cơ  #mi(`\vec{F_1}`) , lực cản không khí  #mi(`\vec{F_2}`)  và trọng lực  #mi(`\vec{F_3}`) . Biết rằng ba lực này đôi một vuông góc và có độ lớn lần lượt là  #mi(`3\text{ kN}, 4\text{ kN}, 12\text{ kN}`) . Tính độ lớn hợp lực tác dụng lên máy bay.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc, áp dụng công thức:  #mi(`|\vec{F}| = \sqrt{F_1^2 + F_2^2 + F_3^2} = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13\text{ kN}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức cho 3 lực vuông góc (số liệu khác):] Tính độ lớn hợp lực của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc có độ lớn lần lượt là  #mi(`1\text{ N}, 2\text{ N}, 2\text{ N}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức:  #mi(`|\vec{F}| = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Kiểm tra điều kiện cân bằng:] Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  có độ lớn lần lượt là  #mi(`5\text{ N}, 12\text{ N}, 13\text{ N}`) . Chứng minh rằng vật có thể ở trạng thái cân bằng nếu ba lực này cùng phương và  #mi(`\vec{F_1}, \vec{F_2}`)  cùng hướng,  #mi(`\vec{F_3}`)  ngược hướng với chúng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét tổng độ lớn các lực:  #mi(`F_1 + F_2 - F_3 = 5 + 12 - 13 = 0`) . Vì tổng các vectơ lực bằng  #mi(`\vec{0}`)  nên vật ở trạng thái cân bằng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán thực tế về lực căng dây:] Một vật treo bởi ba sợi dây  #mi(`\vec{T_1}, \vec{T_2}, \vec{T_3}`)  đang đứng yên. Biết độ lớn của hai lực căng dây  #mi(`\vec{T_1}`)  và  #mi(`\vec{T_2}`)  là  #mi(`10\text{ N}`)  và  #mi(`10\text{ N}`) , và chúng đôi một vuông góc. Tính độ lớn của lực căng dây  #mi(`\vec{T_3}`)  để vật cân bằng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để vật cân bằng, ta phải có  #mi(`\vec{T_1} + \vec{T_2} + \vec{T_3} + \vec{P} = \vec{0}`)  (với  #mi(`\vec{P}`)  là trọng lực). Giả sử  #mi(`\vec{T_3}`)  và  #mi(`\vec{P}`)  cùng hướng lên trên để triệt tiêu các lực khác. Khi đó,  #mi(`|\vec{T_3} + \vec{P}| = \sqrt{T_1^2 + T_2^2} = \sqrt{10^2 + 10^2} = 10\sqrt{2}`) . Vậy độ lớn lực cần thiết là  #mi(`10\sqrt{2}\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc có độ lớn lần lượt là  #mi(`6\text{ N}, 8\text{ N}, 24\text{ N}`) . Tính độ lớn hợp lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`|\vec{F}| = \sqrt{6^2 + 8^2 + 24^2} = \sqrt{36 + 64 + 576} = \sqrt{676} = 26\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Tính độ lớn hợp lực của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc có độ lớn lần lượt là  #mi(`2\text{ N}, 3\text{ N}, 6\text{ N}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`|\vec{F}| = \sqrt{2^2 + 3^2 + 6^2} = \sqrt{4 + 9 + 36} = \sqrt{49} = 7\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  có độ lớn lần lượt là  #mi(`15\text{ N}, 20\text{ N}, 25\text{ N}`) . Biết rằng  #mi(`\vec{F_1}, \vec{F_2}`)  cùng hướng, còn  #mi(`\vec{F_3}`)  ngược hướng với chúng. Vật có cân bằng không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét tổng độ lớn:  #mi(`F_1 + F_2 - F_3 = 15 + 20 - 25 = 10\text{ N} \neq 0`) . Vậy vật không cân bằng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vecvec{F_3}`)  đôi một vuông góc có độ lớn lần lượt là  #mi(`5\text{ N}, 12\text{ N}, 8\text{ N}`) . Tính độ lớn hợp lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`|\vec{F}| = \sqrt{5^2 + 12^2 + 8^2} = \sqrt{25 + 144 + 64} = \sqrt{233} \approx 15.26\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 15: Ứng dụng Hệ Tọa độ Oxyz Giải Bài toán Thực tế ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 15. Ứng dụng Hệ Tọa độ Oxyz Giải Bài toán Thực tế]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Thiết lập hệ trục tọa độ  #mi(`Oxyz`)  dựa trên các hướng thực tế: trục  #mi(`Ox`)  (Đông-Tây),  #mi(`Oy`)  (Bắc-Nam),  #mi(`Oz`)  (Độ cao/Thẳng đứng).
  - Tọa độ điểm  #mi(`M`)  là  #mi(`(x; y; z)`) , tọa độ vectơ dịch chuyển  #mi(`\vec{u}`)  là  #mi(`(x_u; y_u; z_u)`) .
  - Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là  #mi(`d = \sqrt{(x_B - x_A)^2 + (y_B - y_A)^2 + (z_B - z_A)^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Luôn xác định gốc  #mi(`O`)  và hướng các trục  #mi(`Ox, Oy, Oz`)  trước khi đặt tọa độ cho bất kỳ vật thể nào!
  ]
  - *Công thức cốt lõi:* Khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`)  được tính bằng công thức  #mi(`d = \sqrt{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chiếc máy bay đang ở vị trí  #mi(`A(100; 200; 500)`)  và di chuyển theo vectơ  #mi(`\vec{u} = (10; 20; 30)`) . Sau một đơn vị thời gian, tọa độ của máy bay là bao nhiêu?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (110; 220; 530)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ điểm mới  #mi(`B`)  được tính bằng cách cộng tọa độ điểm cũ với tọa độ vectơ dịch chuyển:  #mi(`B = A + \vec{u} = (100 + 10; 200 + 20; 500 + 30) = (110; 220; 530)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tính khoảng cách từ gốc tọa độ  #mi(`O(0;0;0)`)  đến một chiếc tàu ngầm đang ở tọa độ  #mi(`T(3; 4; 12)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 13]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`d = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Bài toán Ra đa phát hiện tàu biển:] Một trạm ra đa đặt tại gốc tọa độ  #mi(`O(0;0;0)`) . Phạm vi quét của ra đa là  #mi(`50`)  km. Một chiếc tàu đang ở vị trí  #mi(`T(30; 30; 10)`) . Hỏi ra đa có phát hiện được tàu không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách từ trạm ra đa đến tàu là:  #mi(`d = \sqrt{30^2 + 30^2 + 10^2} = \sqrt{900 + 900 + 100} = \sqrt{1900} \approx 43.59`)  km. Vì  #mi(`43.59 < 50`)  nên ra đa có phát hiện được tàu.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Bài toán máy bay di chuyển theo thời gian:] Một chiếc máy bay bay từ  #mi(`A(100; 100; 0)`)  đến  #mi(`B(200; 150; 10)`)  trong  #mi(`10`)  phút. Nếu máy bay tiếp tục giữ nguyên hướng và tốc độ đó, hãy tìm tọa độ của máy bay sau  #mi(`5`)  phút tiếp theo.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ dịch chuyển trong  #mi(`10`)  phút là  #mi(`\vec{AB} = (200-100; 150-100; 10-0) = (100; 50; 10)`) . Trong  #mi(`5`)  phút (tức là một nửa thời gian), vectơ dịch chuyển sẽ là  #mi(`\vec{u} = \frac{1}{2}\vec{AB} = (50; 25; 5)`) . Tọa độ máy bay sau  #mi(`5`)  phút tiếp theo là:  #mi(`B + \vec{u} = (200+50; 150+25; 10+5) = (250; 175; 15)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán xác định khoảng cách giữa hai vật thể:] Trong không gian, hai chiếc drone đang ở vị trí  #mi(`D_1(1; 2; 3)`)  và  #mi(`D_2(4; 6; 3)`) . Tính khoảng cách giữa hai drone này.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`d = \sqrt{(4-1)^2 + (6-2)^2 + (3-3)^2} = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9 + 16} = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán thiết lập hệ tọa độ thực tế:] Một căn phòng có chiều dài  #mi(`8`)  m, chiều rộng  #mi(`6`)  m và cao  #mi(`4`)  m. Thiết lập hệ tọa độ  #mi(`Oxyz`)  với gốc  #mi(`O`)  tại một góc sàn, trục  #mi(`Ox`)  dọc theo chiều dài,  #mi(`Oy`)  dọc theo chiều rộng và  #mi(`Oz`)  hướng lên trần. Tìm tọa độ của một chiếc đèn treo ở chính giữa trần nhà.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điểm treo đèn là trung điểm của mặt trần. Tọa độ của các đỉnh sàn là  #mi(`O(0;0;0), A(8;0;0), B(8;6;0), C(0;6;0)`) . Các đỉnh trần tương ứng là  #mi(`O'(0;0;4), A'(8;0;4), B'(8;6;4), C'(0;6;4)`) . Điểm treo đèn là trung điểm của  #mi(`O'B'`) , tọa độ là:  #mi(`M(\frac{0+8}{2}; \frac{0+6}{2}; \frac{4+4}{2}) = (4; 3; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Một trạm ra đa có phạm vi  #mi(`100`)  km. Một chiếc máy bay đang ở tọa độ  #mi(`P(60; 80; 0)`) . Hỏi ra đa có phát hiện được máy bay không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`d = \sqrt{60^2 + 80^2 + 0^2} = \sqrt{3600 + 6400} = \sqrt{10000} = 100`)  km. Vì  #mi(`d = 100`)  nên ra đa vừa đủ phát hiện được máy bay.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Một trạm ra đa có phạm vi  #mi(`200`)  km. Một chiếc tàu đang ở tọa độ  #mi(`T(120; 160; 0)`) . Hỏi ra đa có phát hiện được tàu không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`d = \sqrt{120^2 + 160^2 + 0^2} = \sqrt{14400 + 25600} = \sqrt{40000} = 200`)  km. Vì  #mi(`d = 200`)  nên ra đa vừa đủ phát hiện được tàu.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Một chiếc máy bay bay từ  #mi(`A(0; 0; 0)`)  đến  #mi(`B(10; 20; 30)`)  trong  #mi(`20`)  phút. Tìm tọa độ của máy bay sau  #mi(`10`)  phút tiếp theo.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong  #mi(`20`)  phút là  #mi(`\vec{AB} = (10; 20; 30)`) . Trong  #mi(`10`)  phút (tức là một nửa thời gian), vectơ dịch chuyển là  #mi(`\vec{u} = \frac{1}{2}\vec{AB} = (5; 10; 15)`) . Tọa độ máy bay sau  #mi(`10`)  phút tiếp theo là:  #mi(`B + \vec{u} = (10+5; 20+10; 30+15) = (15; 30; 45)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Một chiếc drone đang ở vị trí  #mi(`D(5; 5; 5)`) . Một chiếc drone khác đang ở vị trí  #mi(`E(8; 9; 5)`) . Tính khoảng cách giữa hai drone này.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`d = \sqrt{(8-5)^2 + (9-5)^2 + (5-5)^2} = \sqrt{3^2 + 4^2 + 0^2} = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
