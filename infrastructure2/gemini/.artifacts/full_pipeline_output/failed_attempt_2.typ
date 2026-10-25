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
  #text(size: 13pt, weight: "bold")[Vectơ trong không gian và các phép toán] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp nền tảng kiến thức toàn diện về Vectơ trong không gian, từ các khái niệm cơ bản, phép toán cộng, trừ, nhân với một số, đến hệ tọa độ Oxyz và các ứng dụng thực tiễn. Nội dung bao gồm các quy tắc hình học (ba điểm, hình bình hành, hình hộp), các tính chất của tích vô hướng, góc và khoảng cách trong không gian, cùng với các bài tập vận dụng từ mức độ nhận biết đến vận dụng cao.]
]
#v(6pt)

// ==================== DẠNG 1: Xác định các đặc tính cơ bản của vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Xác định các đặc tính cơ bản của vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vectơ trong không gian là một đoạn thẳng có hướng, xác định bởi điểm đầu và điểm cuối. Kí hiệu:  #mi(`\vec{AB}`)  (điểm đầu  #mi(`A`) , điểm cuối  #mi(`B`) ).
  - Giá của vectơ  #mi(`\vec{AB}`)  là đường thẳng đi qua hai điểm  #mi(`A`)  và  #mi(`B`) . Một vectơ có giá nằm trong mặt phẳng  #mi(`(P)`)  khi cả điểm đầu và điểm cuối của nó đều thuộc  #mi(`(P)`) .
  - Độ dài của vectơ  #mi(`\vec{AB}`) , kí hiệu là  #mi(`|\vec{AB}|`) , là khoảng cách giữa điểm đầu  #mi(`A`)  và điểm cuối  #mi(`B`) :  #mi(`|\vec{AB}| = AB`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để đếm số vectơ từ một điểm  #mi(`A`)  đến các đỉnh còn lại của đa diện, chỉ cần lấy (Tổng số đỉnh)  #mi(`- 1`) .
  ]
  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{AB}`)  được tính bằng khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) , kí hiệu là  #mi(`|\vec{AB}| = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện  #mi(`ABCD`) . Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) . Vậy có tất cả 3 vectơ.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{AC}`)  (với  #mi(`AC`)  là đường chéo của mặt đáy  #mi(`ABCD`) ).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2.83]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình vuông cạnh  #mi(`2`)  nên đường chéo  #mi(`AC = \sqrt{AB^2 + BC^2} = \sqrt{2^2 + 2^2} = \sqrt{8} = 2\sqrt{2}`) . Vậy  #mi(`|\vec{AC}| = 2\sqrt{2} \approx 2.83`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Đếm số vectơ:] Cho tứ diện  #mi(`ABCD`) . Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại của tứ diện  #mi(`ABCD`)  gồm:  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) . Vậy có tất cả 3 vectơ.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định giá của vectơ:] Cho tứ diện  #mi(`ABCD`) . Trong các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) , những vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABC)`) ?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giá của vectơ  #mi(`\vec{AB}`)  là đường thẳng  #mi(`AB`) , nằm trong mặt phẳng  #mi(`(ABC)`) .\nGiá của vectơ  #mi(`\vec{AC}`)  là đường thẳng  #mi(`AC`) , nằm trong mặt phẳng  #mi(`(ABC)`) .\nGiá của vectơ  #mi(`\vec{AD}`)  là đường thẳng  #mi(`AD`) , cắt mặt phẳng  #mi(`(ABC)`)  tại  #mi(`A`) , không nằm trong  #mi(`(ABC)`) .\nVậy các vectơ có giá nằm trong mặt phẳng  #mi(`(ABC)`)  là  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài vectơ trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . Tính độ dài của các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì tứ diện  #mi(`ABCD`)  là tứ diện đều cạnh  #mi(`1`)  nên  #mi(`AB = AC = AD = 1`) .\nDo đó:  #mi(`|\vec{AB}| = AB = 1`) ;  #mi(`|\vec{AC}| = AC = 1`) ;  #mi(`|\vec{AD}| = AD = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính độ dài vectơ trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{AC'}`)  (với  #mi(`AC'`)  là đường chéo chính của hình lập phương).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình lập phương cạnh  #mi(`a`) , độ dài đường chéo chính  #mi(`AC'`)  được tính theo công thức:  #mi(`AC' = a\sqrt{3}`) .\nVậy độ dài của vectơ  #mi(`\vec{AC'}`)  là  #mi(`|\vec{AC'}| = a\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tứ diện  #mi(`ABCD`) . Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`B`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là  #mi(`B`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{BA}, \vec{BC}, \vec{BD}`) . Vậy có tất cả 3 vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình chóp tam giác  #mi(`S.ABC`) . Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`S`)  và điểm cuối là một trong các đỉnh còn lại của hình chóp?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là  #mi(`S`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . Vậy có tất cả 3 vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tứ diện  #mi(`ABCD`) . Trong các vectơ  #mi(`\vec{BA}, \vec{BC}, \vec{BD}`) , những vectơ nào có giá nằm trong mặt phẳng  #mi(`(BCD)`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Giá của vectơ  #mi(`\vec{BC}`)  là đường thẳng  #mi(`BC`) , nằm trong mặt phẳng  #mi(`(BCD)`) .\nGiá của vectơ  #mi(`\vec{BD}`)  là đường thẳng  #mi(`BD`) , nằm trong mặt phẳng  #mi(`(BCD)`) .\nGiá của vectơ  #mi(`\vec{BA}`)  là đường thẳng  #mi(`BA`) , cắt mặt phẳng  #mi(`(BCD)`)  tại  #mi(`B`) , không nằm trong  #mi(`(BCD)`) .\nVậy các vectơ có giá nằm trong mặt phẳng  #mi(`(BCD)`)  là  #mi(`\vec{BC}`)  và  #mi(`\vec{BD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`3`) . Tính độ dài của vectơ  #mi(`\vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`A'B'C'D'`)  là hình vuông cạnh  #mi(`3`)  nên đường chéo  #mi(`A'C' = 3\sqrt{2}`) .\nVậy  #mi(`|\vec{A'C'}| = 3\sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{CD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì tứ diện  #mi(`ABCD`)  là tứ diện đều cạnh  #mi(`a`)  nên  #mi(`CD = a`) . Vậy  #mi(`|\vec{CD}| = a`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Nhận diện vectơ bằng nhau và vectơ đối ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Nhận diện vectơ bằng nhau và vectơ đối]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hai vectơ được gọi là bằng nhau nếu chúng cùng hướng và cùng độ dài. Kí hiệu:  #mi(`\vec{a} = \vec{b}`) .
  - Hai vectơ được gọi là đối nhau nếu chúng ngược hướng và có cùng độ dài. Vectơ đối của  #mi(`\vec{AB}`)  là  #mi(`\vec{BA}`) , kí hiệu là  #mi(`-\vec{AB} = \vec{BA}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Bằng nhau: 'Cùng hướng - Cùng độ'. Đối nhau: 'Ngược hướng - Cùng độ'.
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng cùng  #mi(`\cases{...}`)  và cùng  #mi(`\cases{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a} = (2; -3; 1)`) . Tìm tọa độ vectơ đối  #mi(`-\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (-2; 3; -1)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ của vectơ đối  #mi(`-\vec{a}`)  được tính bằng cách đổi dấu tất cả các thành phần tọa độ của  #mi(`\vec{a}`) . Ta có  #mi(`-\vec{a} = (-2; 3; -1)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u} = (5; 0; -2)`) . Tìm tọa độ vectơ  #mi(`\vec{v}`)  biết  #mi(`\vec{v} = \vec{u}`)  và điểm đầu là  #mi(`O`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (5; 0; -2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{v} = \{u`) , nên  #mi(`\vec{v}`)  có cùng tọa độ với  #mi(`\vec{u}`) . Vậy  #mi(`\vec{v} = (5; 0; -2)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định vectơ bằng nhau trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} = \vec{D'C'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`AB // D'C'`)  và  #mi(`AB = D'C'`)  (do các cạnh đối của các mặt là các cạnh bằng nhau). Đồng thời, hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{D'C'}`)  cùng hướng từ trái sang phải (hoặc theo quy ước hướng của hình hộp). Do đó,  #mi(`\vec{AB} = \vec{D'C'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định vectơ đối trong hình lăng trụ:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Chứng minh rằng  #mi(`\vec{AA'} = -\vec{A'A}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hai vectơ  #mi(`\vec{AA'}`)  và  #mi(`\vec{A'A}`)  có cùng độ dài là đoạn thẳng  #mi(`AA'`) . Tuy nhiên, chúng có hướng ngược nhau (một hướng từ  #mi(`A`)  đến  #mi(`A'`) , một hướng từ  #mi(`A'`)  đến  #mi(`A`) ). Do đó,  #mi(`\vec{AA'} = -\vec{A'A}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm điểm M dựa trên vectơ  #mi(`\vec{OM}`) :] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (3; -4; 5)`) . Tìm tọa độ điểm  #mi(`M`)  sao cho  #mi(`\vec{OM} = \vec{a}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`O`)  là gốc tọa độ  #mi(`(0; 0; 0)`) , nên tọa độ của điểm  #mi(`M`)  chính là tọa độ của vectơ  #mi(`\vec{OM}`) . Vậy  #mi(`M(3; -4; 5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Nhận diện cặp vectơ đối nhau:] Cho các vectơ  #mi(`\vec{u} = (1; 2; 3)`)  và  #mi(`\vec{v} = (-1; -2; -3)`) . Hai vectơ này có quan hệ gì?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta thấy  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  có độ dài bằng nhau:  #mi(`|\vec{u}| = |\vec{v}| = \sqrt{1^2 + 2^2 + 3^2} = \sqrt{14}`) . Tuy nhiên, các thành phần tọa độ của  #mi(`\vec{v}`)  là số đối của các thành phần tọa độ của  #mi(`\vec{u}`) . Điều này có nghĩa là chúng ngược hướng nhau. Vậy  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  là hai vectơ đối nhau.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} = \vec{A'D'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình lập phương, các cạnh đối  #mi(`AB`)  và  #mi(`A'D'`)  song song, cùng hướng và có độ dài bằng nhau. Do đó,  #mi(`\vec{AB} = \vec{A'D'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AD} = \vec{B'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình lập phương, các cạnh đối  #mi(`AD`)  và  #mi(`B'C'`)  song song, cùng hướng và có độ dài bằng nhau. Do đó,  #mi(`\vec{AD} = \vec{B'C'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (-1; 4; 2)`) . Tìm tọa độ vectơ đối  #mi(`-\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ của vectơ đối  #mi(`-\vec{a}`)  là  #mi(`(1; -4; -2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Nếu  #mi(`\vec{AB} = \vec{a}`)  và  #mi(`\vec{AD} = \vec{b}`) , hãy xác định vectơ đối của  #mi(`\vec{AB}`)  là gì?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ đối của  #mi(`\vec{AB}`)  là  #mi(`\vec{BA}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Nhận biết và kiểm tra đẳng thức vectơ cơ bản ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Nhận biết và kiểm tra đẳng thức vectơ cơ bản]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  (tính nối tiếp).
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc hình hộp: Nếu  #mi(`ABCD.A'B'C'D'`)  là hình hộp thì  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  - Quy tắc trọng tâm:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  (tam giác) và  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`)  (tứ diện).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn kiểm tra đẳng thức vectơ, hãy kiểm tra xem các vectơ có 'nối đuôi' nhau (quy tắc 3 điểm) hoặc 'xuất phát từ cùng một đỉnh' (quy tắc hình bình hành/hình hộp) hay không.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ đỉnh  #mi(`A`)  là  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính giá trị của biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc cộng nối tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Tiếp tục:  #mi(`\vec{AC} + \vec{CD} = \vec{AD}`) . Cuối cùng:  #mi(`\vec{AD} + \vec{DA} = \vec{AA} = \vec{0}`) . Vậy  #mi(`P = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Tính giá trị của  #mi(`\vec{GA} + \vec{GB} + \vec{GC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo tính chất trọng tâm tam giác, tổng các vectơ từ trọng tâm đến ba đỉnh của tam giác luôn bằng vectơ không. Vậy  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc ba điểm:] Cho ba điểm  #mi(`A, B, C`)  bất kỳ. Kiểm tra xem đẳng thức  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  có đúng không.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc cộng vectơ (quy tắc ba điểm), với ba điểm  #mi(`A, B, C`)  bất kỳ, ta luôn có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Vậy đẳng thức trên là đúng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`) . Kiểm tra xem đẳng thức  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  có đúng không.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên hai cạnh  #mi(`AB`)  và  #mi(`AD`)  cùng xuất phát từ đỉnh  #mi(`A`) . Theo quy tắc hình bình hành, tổng hai vectơ này bằng vectơ đường chéo xuất phát từ cùng đỉnh đó, tức là  #mi(`\vec{AC}`) . Vậy đẳng thức trên là đúng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Kiểm tra xem đẳng thức  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  có đúng không.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình hộp, ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  là ba cạnh xuất phát từ đỉnh  #mi(`A`) . Theo quy tắc hình hộp, tổng của chúng bằng vectơ đường chéo chính xuất phát từ đỉnh  #mi(`A`) , đó là  #mi(`\vec{AC'}`) . Vậy đẳng thức trên là đúng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Áp dụng quy tắc trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`)  có trọng tâm  #mi(`I`) . Kiểm tra xem đẳng thức  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`)  có đúng không.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa và tính chất của trọng tâm tứ diện  #mi(`I`) , tổng các vectơ từ  #mi(`I`)  đến bốn đỉnh của tứ diện luôn bằng vectơ không. Vậy đẳng thức trên là đúng.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình bình hành  #mi(`ABCD`) . Kiểm tra xem đẳng thức  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  có đúng không.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên theo quy tắc hình bình hành,  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Vậy đẳng thức đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Kiểm tra xem đẳng thức  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  có đúng không.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, tổng ba vectơ cạnh xuất phát từ một đỉnh bằng vectơ đường chéo chính xuất phát từ đỉnh đó. Vậy đẳng thức đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Kiểm tra xem đẳng thức  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  có đúng không.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo tính chất trọng tâm tam giác, tổng các vectơ từ trọng tâm đến các đỉnh bằng  #mi(`\vec{0}`) . Vậy đẳng thức đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình bình hành  #mi(`ABCD`) . Kiểm tra xem đẳng thức  #mi(`\vec{AB} + \vec{CD} = \vec{0}`)  có đúng không.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Do đó  #mi(`\vec{AB} + \vec{CD} = \vec{DC} + \vec{CD} = \vec{0}`)  (vì  #mi(`\vec{DC}`)  và  #mi(`\vec{CD}`)  là hai vectơ đối nhau). Vậy đẳng thức đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Tính độ dài vectơ tổng và vectơ hiệu bằng hình học thuần túy ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Tính độ dài vectơ tổng và vectơ hiệu bằng hình học thuần túy]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm (nối tiếp):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Để tính độ dài vectơ tổng, ta rút gọn về một vectơ duy nhất rồi tính độ dài đoạn thẳng biểu diễn nó.
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ cùng một đỉnh dọc theo ba cạnh bằng vectơ đường chéo chính xuất phát từ đỉnh đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính độ dài vectơ tổng, đừng cộng độ dài từng đoạn thẳng! Hãy rút gọn biểu thức vectơ về một vectơ duy nhất trước, sau đó mới tính độ dài đoạn thẳng đó.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  là độ dài đường chéo hình lập phương cạnh  #mi(`1`) :  #mi(`|\vec{u}| = AC' = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=2, AD=3, AA'=4`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{29}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{v}`)  là độ dài đường chéo hình hộp chữ nhật:  #mi(`|\vec{v}| = AC' = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{29}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc ba điểm và hình bình hành:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{BC} + \vec{DD'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`DD'C'C`)  là hình bình hành nên  #mi(`\vec{DD'} = \vec{CC'}`) . Thay vào biểu thức ta được:  #mi(`\vec{u} = \vec{BC} + \vec{CC'} = \vec{BC'}`)  (theo quy tắc ba điểm). Độ dài của vectơ  #mi(`\vec{u}`)  là độ dài đoạn thẳng  #mi(`BC'`) :  #mi(`|\vec{u}| = BC' = \sqrt{BC^2 + CC'^2} = \sqrt{1^2 + 1^2} = \sqrt{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình hộp:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, ta có  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{v}`)  là độ dài đường chéo hình lập phương cạnh  #mi(`2`) :  #mi(`|\vec{v}| = AC' = \sqrt{2^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`AB=3, AD=4`)  và  #mi(`AB \perp AD`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành). Độ dài của vectơ  #mi(`\vec{u}`)  là độ dài đường chéo  #mi(`AC`) :  #mi(`|\vec{u}| = AC = \sqrt{AB^2 + AD^2} = \sqrt{3^2 + 4^2} = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Áp dụng quy tắc ba điểm (biến thể):] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{w} = \vec{AB} + \vec{BC} + \vec{CD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc ba điểm liên tiếp:  #mi(`\vec{w} = (\vec{AB} + \vec{BC}) + \vec{CD} = \vec{AC} + \vec{CD} = \vec{AD}`) . Độ dài của vectơ  #mi(`\vec{w}`)  là độ dài đoạn thẳng  #mi(`AD`) :  #mi(`|\vec{w}| = AD = 1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{BC} + \vec{CC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`BCC'B'`)  là hình bình hành nên  #mi(`\vec{CC'} = \vec{BB'}`) . Ta có  #mi(`\vec{u} = \vec{BC} + \vec{BB'} = \vec{BC'}`)  (theo quy tắc hình bình hành). Độ dài của vectơ  #mi(`\vec{u}`)  là  #mi(`|\vec{u}| = BC' = \sqrt{BC^2 + BB'^2} = \sqrt{1^2 + 1^2} = \sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{BC} + \vec{CC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`BCC'B'`)  là hình bình hành nên  #mi(`\vec{CC'} = \vec{BB'}`) . Ta có  #mi(`\vec{v} = \vec{BC} + \vec{BB'} = \vec{BC'}`)  (theo quy tắc hình bình hành). Độ dài của vectơ  #mi(`\vec{v}`)  là  #mi(`|\vec{v}| = BC' = \sqrt{BC^2 + BB'^2} = \sqrt{2^2 + 2^2} = \sqrt{8} = 2\sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=3, AD=4, AA'=5`) . Tính độ dài của vectơ  #mi(`\vec{w} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{w} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{w}`)  là  #mi(`|\vec{w}| = AC' = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{3^2 + 4^2 + 5^2} = \sqrt{9 + 16 + 25} = \sqrt{50} = 5\sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  là  #mi(`|\vec{u}| = AC' = a\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Chứng minh đẳng thức vectơ trong hình học không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Chứng minh đẳng thức vectơ trong hình học không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Sử dụng quy tắc ba điểm (chèn điểm):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  để biến đổi vế này thành vế kia.
  - Áp dụng tính chất trung điểm  #mi(`M`)  của  #mi(`AB`) :  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  và với điểm  #mi(`O`)  bất kỳ,  #mi(`\vec{OA} + \vec{OB} = 2\vec{OM}`) .
  - Áp dụng tính chất trọng tâm  #mi(`G`)  của  #mi(`\triangle BCD`) :  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`)  và với điểm  #mi(`A`)  bất kỳ,  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .
  - Sử dụng tính chất hình hộp  #mi(`ABCD.A'B'C'D'`) :  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (quy tắc hình hộp).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh  #mi(`\vec{X} = \vec{Y}`) , hãy chọn vế phức tạp hơn, chèn điểm trung gian hoặc thay thế các vectơ bằng nhau dựa trên tính chất hình khối để đưa về vế còn lại.
  ]
  - *Công thức cốt lõi:* Với  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`)  và  #mi(`A`)  là điểm bất kỳ, ta có:  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = ...\vec{AG}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.732]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài  #mi(`|\vec{u}| = AC' = a\sqrt{3}`) . Với  #mi(`a=1`) , kết quả là  #mi(`\sqrt{3} \approx 1.732`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Nếu  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = (3; 6; 9)`) , hãy tìm tọa độ vectơ  #mi(`\vec{AG}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (1;2;3)]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) . Suy ra  #mi(`\vec{AG} = \frac{1}{3}(3; 6; 9) = (1; 2; 3)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chèn điểm trong tứ diện:] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta biến đổi vế trái (VT):
 #mi(`VT = \vec{AC} + \vec{BD}`) \nChèn điểm  #mi(`D`)  vào vectơ  #mi(`\vec{AC}`) :  #mi(`\vec{AC} = \vec{AD} + \vec{DC}`) \nKhi đó:  #mi(`VT = (\vec{AD} + \vec{DC}) + \vec{BD} = \vec{AD} + (\vec{BD} + \vec{DC})`) \nTheo quy tắc ba điểm:  #mi(`\vec{BD} + \vec{DC} = \vec{BC}`) \nVậy  #mi(`VT = \vec{AD} + \vec{BC} = VP`)  (điều phải chứng minh).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét hình hộp  #mi(`ABCD.A'B'C'D'`) :\nTheo quy tắc hình bình hành cho đáy  #mi(`ABCD`) :  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) \nKhi đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC} + \vec{AA'}`) \nVì  #mi(`ACC'A'`)  là hình bình hành nên theo quy tắc ba điểm:  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) \nVậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (điều phải chứng minh).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính chất trung điểm:] Cho tam giác  #mi(`ABC`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Chứng minh rằng với mọi điểm  #mi(`O`) , ta có  #mi(`\vec{OA} + \vec{OB} + \vec{OC} = \vec{OA} + 2\vec{OM}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`BC`)  nên  #mi(`\vec{MB} + \vec{MC} = \vec{0}`) .\nVới điểm  #mi(`O`)  bất kỳ, ta có:
 #mi(`\vec{OB} = \vec{OM} + \vec{MB}`) 
 #mi(`\vec{OC} = \vec{OM} + \vec{MC}`) \nCộng hai vế:  #mi(`\vec{OB} + \vec{OC} = 2\vec{OM} + (\vec{MB} + \vec{MC}) = 2\vec{OM} + \vec{0} = 2\vec{OM}`) \nVậy  #mi(`\vec{OA} + \vec{OB} + \vec{OC} = \vec{OA} + 2\vec{OM}`)  (điều phải chứng minh).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính chất trọng tâm:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta biến đổi vế trái (VT):
 #mi(`VT = \vec{AB} + \vec{AC} + \vec{AD}`) \nChèn điểm  #mi(`G`)  vào từng vectơ:
 #mi(`\vec{AB} = \vec{AG} + \vec{GB}`) 
 #mi(`\vec{AC} = \vec{AG} + \vec{GC}`) 
 #mi(`\vec{AD} = \vec{AG} + \vec{GD}`) \nKhi đó:  #mi(`VT = (\vec{AG} + \vec{GB}) + (\vec{AG} + \vec{GC}) + (\vec{AG} + \vec{GD}) = 3\vec{AG} + (\vec{GB} + \vec{GC} + \vec{GD})`) \nVì  #mi(`G`)  là trọng tâm  #mi(`\triangle BCD`)  nên  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) \nVậy  #mi(`VT = 3\vec{AG} + \vec{0} = 3\vec{AG} = VP`)  (điều phải chứng minh).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta biến đổi vế trái (VT):
 #mi(`VT = \vec{AB} + \vec{CD}`) \nChèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`) :  #mi(`\vec{AB} = \vec{AD} + \vec{DB}`) \nKhi đó:  #mi(`VT = (\vec{AD} + \vec{DB}) + \vec{CD} = \vec{AD} + (\vec{CD} + \vec{DB})`) \nTheo quy tắc ba điểm:  #mi(`\vec{CD} + \vec{DB} = \vec{CB}`) \nVậy  #mi(`VT = \vec{AD} + \vec{CB} = VP`)  (điều phải chứng minh).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AC} + \vec{DB} = \vec{AB} + \vec{DC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta biến đổi vế trái (VT):
 #mi(`VT = \vec{AC} + \vec{DB}`) \nChèn điểm  #mi(`B`)  vào  #mi(`\vec{AC}`) :  #mi(`\vec{AC} = \vec{AB} + \vec{BC}`) \nKhi đó:  #mi(`VT = (\vec{AB} + \vec{BC}) + \vec{DB} = \vec{AB} + (\vec{DB} + \vec{BC})`) \nTheo quy tắc ba điểm:  #mi(`\vec{DB} + \vec{BC} = \vec{DC}`) \nVậy  #mi(`VT = \vec{AB} + \vec{DC} = VP`)  (điều phải chứng minh).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình bình hành cho đáy  #mi(`ABCD`) :  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) \nTheo quy tắc hình bình hành cho mặt bên  #mi(`ACC'A'`) :  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) \nVậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (điều phải chứng minh).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Chứng minh rằng:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = 3\vec{GA} + \vec{AB} + \vec{AC} + \vec{AD}`)  là sai, hãy sửa lại cho đúng và chứng minh.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đẳng thức đúng phải là:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{GA} + \vec{0} = \vec{GA}`)  (vì  #mi(`G`)  là trọng tâm  #mi(`\triangle BCD`) ).\nChứng minh:  #mi(`\vec{GA} + (\vec{GB} + \vec{GC} + \vec{GD}) = \vec{GA} + \vec{0} = \vec{GA}`) .
Để liên hệ với điểm  #mi(`A`) , ta có  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`)  (như đã chứng minh ở ví dụ 4). Do đó  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{GA}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hình hộp  #mi(`ABCD.A'B'C'D'`) :\nTa có  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`)  (tính chất hình bình hành  #mi(`ABCD`) )\nKhi đó:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AD} + \vec{AB} + \vec{AA'}`) \nTheo quy tắc hình hộp:  #mi(`\vec{AD} + \vec{AB} + \vec{AA'} = \vec{AC'}`) \nVậy  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`)  (điều phải chứng minh).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Biểu diễn (phân tích) vectơ theo các vectơ cơ sở trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Biểu diễn (phân tích) vectơ theo các vectơ cơ sở trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình hộp: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ đường chéo chính  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
  - Quy tắc trọng tâm tam giác: Với điểm  #mi(`O`)  bất kì,  #mi(`\vec{OM} = \frac{1}{3}(\vec{OA} + \vec{OB} + \vec{OC})`)  khi  #mi(`M`)  là trọng tâm  #mi(`\triangle ABC`) .
  - Quy tắc trung điểm: Với điểm  #mi(`O`)  bất kì,  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`)  khi  #mi(`M`)  là trung điểm  #mi(`AB`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn phân tích vectơ, hãy dùng phương pháp 'Chèn điểm': Chèn điểm đầu/cuối của vectơ cơ sở vào giữa vectơ cần tìm để tạo thành chuỗi nối tiếp.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta luôn có  #mi(`\vec{AC'} = \dots + \dots + \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Biểu diễn  #mi(`\vec{AC'}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng quy tắc hình hộp cho hình lập phương, vectơ đường chéo chính xuất phát từ đỉnh  #mi(`A`)  là  #mi(`\vec{AC'}`) . Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn  #mi(`\vec{AG}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\frac{1}{3}(\vec{AB} + \vec{AC})`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Chèn điểm  #mi(`A`)  vào các vectơ:  #mi(`(\vec{AA} - \vec{AG}) + (\vec{AB} - \vec{AG}) + (\vec{AC} - \vec{AG}) = \vec{0} \Rightarrow \vec{AB} + \vec{AC} - 3\vec{AG} = \vec{0} \Rightarrow \vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ  #mi(`\vec{AC'}`)  là đường chéo chính xuất phát từ đỉnh  #mi(`A`) . Theo quy tắc hình hộp, tổng ba vectơ xuất phát từ cùng một đỉnh dọc theo ba cạnh của hình hộp bằng vectơ đường chéo chính. Do đó:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Biến thể trung điểm trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của cạnh  #mi(`CC'`) . Biểu diễn  #mi(`\vec{AM}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{AM} = \vec{AC} + \vec{CM}`) . Vì  #mi(`M`)  là trung điểm  #mi(`CC'`)  nên  #mi(`\vec{CM} = \frac{1}{2}\vec{CC'} = \frac{1}{2}\vec{AA'}`) . Mặt khác,  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  (quy tắc hình bình hành). Vậy:  #mi(`\vec{AM} = \vec{AB} + \vec{AD} + \frac{1}{2}\vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc trọng tâm tam giác:] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn  #mi(`\vec{AG}`)  theo các vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên ta có hệ thức:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Chèn điểm  #mi(`A`)  vào các vectơ:  #mi(`\vec{GA} = \vec{AA} - \vec{AG} = -\vec{AG}`) ;  #mi(`\vec{GB} = \vec{AB} - \vec{AG}`) ;  #mi(`\vec{GC} = \vec{AC} - \vec{AG}`) . Thay vào hệ thức:  #mi(`-\vec{AG} + (\vec{AB} - \vec{AG}) + (\vec{AC} - \vec{AG}) = \vec{0} \Rightarrow \vec{AB} + \vec{AC} - 3\vec{AG} = \vec{0} \Rightarrow \vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể trong hình lăng trụ:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Gọi  #mi(`M`)  là trung điểm của cạnh  #mi(`BC`) . Biểu diễn  #mi(`\vec{AM}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{AM} = \vec{AB} + \vec{BM}`) . Vì  #mi(`M`)  là trung điểm  #mi(`BC`)  nên  #mi(`\vec{BM} = \frac{1}{2}\vec{BC} = \frac{1}{2}(\vec{AC} - \vec{AB})`) . Vậy:  #mi(`\vec{AM} = \vec{AB} + \frac{1}{2}(\vec{AC} - \vec{AB}) = \frac{1}{2}\vec{AB} + \frac{1}{2}\vec{AC}`) . (Lưu ý:  #mi(`\vec{AM}`)  không phụ thuộc vào  #mi(`\vec{AA'}`)  vì  #mi(`M`)  nằm trong mặt đáy  #mi(`ABC`) ).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn  #mi(`\vec{AC'}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Biểu diễn  #mi(`\vec{AC'}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn  #mi(`\vec{AG}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của cạnh  #mi(`CC'`) . Biểu diễn  #mi(`\vec{AM}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AM} = \vec{AC} + \vec{CM} = (\vec{AB} + \vec{AD}) + \frac{1}{2}\vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Phân tích nâng cao vectơ theo 3 vectơ không đồng phẳng ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Phân tích nâng cao vectơ theo 3 vectơ không đồng phẳng]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong không gian, cho ba vectơ  #mi(`\vec{a}, \vec{b}, \vec{c}`)  không đồng phẳng. Mọi vectơ  #mi(`\vec{x}`)  đều được biểu diễn duy nhất dưới dạng:  #mi(`\vec{x} = m\vec{a} + n\vec{b} + p\vec{c}`)  (với  #mi(`m, n, p \in \mathbb{R}`) ).
  - Để phân tích một vectơ  #mi(`\vec{u}`)  theo ba vectơ  #mi(`\vec{a}, \vec{b}, \vec{c}`) , ta thường sử dụng phương pháp chèn điểm (quy tắc ba điểm) hoặc thay thế các vectơ bằng nhau dựa trên tính chất hình học (hình hộp, hình lăng trụ).
  - Công thức trọng tâm tứ diện  #mi(`ABCD`) : Nếu  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  thì với điểm  #mi(`O`)  bất kỳ:  #mi(`\vec{OG} = \frac{1}{4}(\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD})`) . Đặc biệt  #mi(`\vec{AG} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi phân tích vectơ, hãy luôn tìm cách 'đưa' các điểm đầu và điểm cuối về các đỉnh của khung tham chiếu (ví dụ đỉnh  #mi(`A`)  trong  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) ) bằng cách chèn điểm.
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{AG} = \frac{1}{...}(\vec{AB} + \vec{AC} + \vec{AD})`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tứ diện. Biết  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 4\vec{u}`) . Tính giá trị của hệ số  #mi(`k`)  sao cho  #mi(`\vec{AG} = k\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo công thức trọng tâm tứ diện, ta có  #mi(`\vec{AG} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) . Thay  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 4\vec{u}`)  vào, ta được  #mi(`\vec{AG} = \frac{1}{4}(4\vec{u}) = 1\vec{u}`) . Vậy  #mi(`k = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`CC'`) . Biểu diễn  #mi(`\vec{AM}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) . Nếu  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) , hãy tính tổng các hệ số của  #mi(`\vec{AM} = m\vec{a} + n\vec{b} + p\vec{c}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2.5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AM} = \vec{AC} + \vec{CM} = (\vec{AB} + \vec{AD}) + \frac{1}{2}\vec{CC'} = \vec{AB} + \vec{AD} + \frac{1}{2}\vec{AA'}`) . Vậy  #mi(`m=1, n=1, p=0.5`) . Tổng các hệ số là  #mi(`1 + 1 + 0.5 = 2.5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Phân tích vectơ trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tứ diện  #mi(`ABCD`) . Hãy phân tích vectơ  #mi(`\vec{AG}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên ta có:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .\nChèn điểm  #mi(`A`)  vào các vectơ  #mi(`\vec{GB}, \vec{GC}, \vec{GD}`) :\n #mi(`\vec{GA} + (\vec{GA} + \vec{AB}) + (\vec{GA} + \vec{AC}) + (\vec{GA} + \vec{AD}) = \vec{0}`) .\n #mi(`\Rightarrow 4\vec{GA} + \vec{AB} + \vec{AC} + \vec{AD} = \vec{0}`) .\n #mi(`\Rightarrow 4\vec{AG} = \vec{AB} + \vec{AC} + \vec{AD}`) .\nVậy  #mi(`\vec{AG} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Phân tích vectơ trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của cạnh  #mi(`CC'`) . Hãy biểu diễn vectơ  #mi(`\vec{AM}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sử dụng quy tắc hình hộp và chèn điểm  #mi(`C`) :\n #mi(`\vec{AM} = \vec{AC} + \vec{CM}`) .\nVì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) .\nVì  #mi(`M`)  là trung điểm  #mi(`CC'`)  nên  #mi(`\vec{CM} = \frac{1}{2}\vec{CC'}`) .\nMà  #mi(`\vec{CC'} = \vec{AA'}`)  (do tính chất hình hộp).\nThay vào ta được:  #mi(`\vec{AM} = \vec{AB} + \vec{AD} + \frac{1}{2}\vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Phân tích vectơ nối trung điểm hai cạnh đối:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`)  và  #mi(`N`)  là trung điểm của  #mi(`CD`) . Hãy phân tích vectơ  #mi(`\vec{MN}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sử dụng quy tắc chèn điểm  #mi(`A`)  và  #mi(`D`) :\n #mi(`\vec{MN} = \vec{MA} + \vec{AD} + \vec{DN}`) .\nVì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{MA} = -\frac{1}{2}\vec{AB}`) .\nVì  #mi(`N`)  là trung điểm  #mi(`CD`)  nên  #mi(`\vec{DN} = \frac{1}{2}\vec{DC}`) .\nMà  #mi(`\vec{DC} = \vec{AC} - \vec{AB}`) .\nThay vào biểu thức:  #mi(`\vec{MN} = -\frac{1}{2}\vec{AB} + \vec{AD} + \frac{1}{2}(\vec{AC} - \vec{AB})`) .\n #mi(`\vec{MN} = -\frac{1}{2}\vec{AB} + \vec{AD} + \frac{1}{2}\vec{AC} - \frac{1}{2}\vec{AB}`) .\nVậy  #mi(`\vec{MN} = -\vec{AB} + \frac{1}{2}\vec{AC} + \vec{AD}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phân tích vectơ với tỉ lệ đoạn thẳng:] Cho tứ diện  #mi(`ABCD`) . Trên cạnh  #mi(`SA`)  lấy điểm  #mi(`M`)  sao cho  #mi(`\vec{SM} = 2\vec{MA}`) . Trên cạnh  #mi(`BC`)  lấy điểm  #mi(`N`)  sao cho  #mi(`\vec{CN} = 2\vec{BN}`) . Hãy phân tích  #mi(`\vec{MN}`)  theo  #mi(`\vec{SA}, \vec{BC}, \vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Phân tích các vectơ thành phần:\n1. Xét cạnh  #mi(`SA`) :  #mi(`\vec{SM} = 2\vec{MA} \Rightarrow \vec{SA} = \vec{SM} + \vec{MA} = 3\vec{MA} \Rightarrow \vec{MA} = \frac{1}{3}\vec{SA}`) .\n2. Xét cạnh  #mi(`BC`) :  #mi(`\vec{CN} = 2\vec{BN} \Rightarrow \vec{BC} = \vec{BN} + \vec{NC} = \vec{BN} - 2\vec{BN} = -\vec{BN} \Rightarrow \vec{BN} = -\vec{BC}`)  (Sai sót trong nháp, tính lại:  #mi(`\vec{CN} = 2\vec{BN} \Rightarrow \vec{BN} = \frac{1}{3}\vec{BC}`)  vì  #mi(`N`)  nằm giữa  #mi(`B, C`)  và  #mi(`\vec{BN}`)  cùng hướng  #mi(`\vec{BC}`) ).\n3. Chèn điểm:\n #mi(`\vec{MN} = \vec{MA} + \vec{AB} + \vec{BN}`) .\nThay các tỉ lệ vào:  #mi(`\vec{MN} = \frac{1}{3}\vec{SA} + \vec{AB} + \frac{1}{3}\vec{BC}`) .\nVậy  #mi(`\vec{MN} = \frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (MauChuan).*] else [*Bài 1.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tứ diện  #mi(`ABCD`) . Hãy phân tích vectơ  #mi(`\vec{AG}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .\nChèn điểm  #mi(`A`) :  #mi(`\vec{GA} + (\vec{GA} + \vec{AB}) + (\vec{GA} + \vec{AC}) + (\vec{GA} + \vec{AD}) = \vec{0}`) .\n #mi(`\Rightarrow 4\vec{GA} + \vec{AB} + \vec{AC} + \vec{AD} = \vec{0} \Rightarrow 4\vec{AG} = \vec{AB} + \vec{AC} + \vec{AD}`) .\nVậy  #mi(`\vec{AG} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tứ diện  #mi(`ABCD`) . Hãy phân tích vectơ  #mi(`\vec{BG}`)  theo ba vectơ  #mi(`\vec{BA}, \vec{BC}, \vec{BD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{GB} + \vec{GA} + \vec{GC} + \vec{GD} = \vec{0}`) .\nChèn điểm  #mi(`B`) :  #mi(`\vec{GB} + (\vec{GB} + \vec{BA}) + (\vec{GB} + \vec{BC}) + (\vec{GB} + \vec{BD}) = \vec{0}`) .\n #mi(`\Rightarrow 4\vec{GB} + \vec{BA} + \vec{BC} + \vec{BD} = \vec{0}`) .\n #mi(`\Rightarrow 4\vec{BG} = \vec{BA} + \vec{BC} + \vec{BD}`) .\nVậy  #mi(`\vec{BG} = \frac{1}{4}(\vec{BA} + \vec{BC} + \vec{BD})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`CC'`) . Hãy phân tích vectơ  #mi(`\vec{AM}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AM} = \vec{AC} + \vec{CM}`) .\nVì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) .\nVì  #mi(`M`)  là trung điểm  #mi(`CC'`)  nên  #mi(`\vec{CM} = \frac{1}{2}\vec{CC'}`) .\nMà  #mi(`\vec{CC'} = \vec{AA'}`) .\nVậy  #mi(`\vec{AM} = \vec{AB} + \vec{AD} + \frac{1}{2}\vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`)  và  #mi(`N`)  là trung điểm của  #mi(`CD`) . Hãy phân tích vectơ  #mi(`\vec{NM}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{NM} = -\vec{MN}`) .\nTừ kết quả phân tích  #mi(`\vec{MN}`)  (tương tự ví dụ 3), ta có  #mi(`\vec{MN} = -\vec{AB} + \frac{1}{2}\vec{AC} + \vec{AD}`) .\nVậy  #mi(`\vec{NM} = -(-\vec{AB} + \frac{1}{2}\vec{AC} + \vec{AD}) = \vec{AB} - \frac{1}{2}\vec{AC} - \vec{AD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (CungCo).*] else [*Bài 5.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`I`)  là trung điểm của  #mi(`AA'`) . Hãy phân tích vectơ  #mi(`\vec{CI}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{CI} = \vec{CA} + \vec{AI}`) .\nMà  #mi(`\vec{CA} = -(\vec{AB} + \vec{AD})`) .\nVì  #mi(`I`)  là trung điểm  #mi(`AA'`)  nên  #mi(`\vec{AI} = \frac{1}{2}\vec{AA'}`) .\nVậy  #mi(`\vec{CI} = -\vec{AB} - \vec{AD} + \frac{1}{2}\vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Xác định vị trí điểm thỏa mãn đẳng thức vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Xác định vị trí điểm thỏa mãn đẳng thức vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để xác định vị trí điểm  #mi(`M`) , ta biến đổi đẳng thức vectơ về dạng  #mi(`\vec{AM} = k\vec{v}`)  (với  #mi(`A`)  là điểm cố định và  #mi(`\vec{v}`)  là vectơ không đổi). Khi đó  #mi(`M`)  là điểm duy nhất thỏa mãn  #mi(`\vec{AM} = k\vec{v}`) .
  - Quy tắc chèn điểm:  #mi(`\vec{XY} = \vec{XA} + \vec{AY}`) . Đây là công cụ chính để cô lập vectơ chứa điểm cần tìm.
  - Đặc điểm trọng tâm tứ diện  #mi(`I`)  của tứ diện  #mi(`ABCD`) :  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . Với điểm  #mi(`P`)  bất kỳ,  #mi(`\vec{PI} = \frac{1}{4}(\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm điểm  #mi(`M`) , hãy 'đẩy'  #mi(`M`)  về một đầu của vectơ và biến đổi vế còn lại thành một vectơ cố định duy nhất.
  ]
  - *Công thức cốt lõi:* Điểm  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  khi và chỉ khi  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`I`)  là trọng tâm tứ diện. Với điểm  #mi(`P`)  bất kỳ, biết  #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = 4\vec{u}`) . Tính giá trị của  #mi(`\vec{PI}`)  theo  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo tính chất trọng tâm tứ diện  #mi(`I`) , ta có  #mi(`\vec{PI} = \frac{1}{4}(\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`) . Thay giả thiết vào ta được  #mi(`\vec{PI} = \frac{1}{4}(4\vec{u}) = \vec{u}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Tính tỉ số  #mi(`k`)  trong đẳng thức  #mi(`\vec{MN} = k(\vec{AC} + \vec{BD})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN} = -\frac{1}{2}\vec{AB} + \vec{AC} + \frac{1}{2}\vec{CD}`) .\n #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN} = \frac{1}{2}\vec{AB} + \vec{BD} - \frac{1}{2}\vec{CD}`) .\nCộng hai đẳng thức trên:  #mi(`2\vec{MN} = \vec{AC} + \vec{BD} \Rightarrow \vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . Vậy  #mi(`k = 0.5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định điểm M qua tổng vectơ:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`N`)  là trung điểm của  #mi(`CD`) . Tìm điểm  #mi(`M`)  trên cạnh  #mi(`AB`)  sao cho  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) .\nVì  #mi(`N`)  là trung điểm  #mi(`CD`)  nên  #mi(`\vec{CN} = \frac{1}{2}\vec{CD}`) .\n #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \frac{1}{2}\vec{CD}`) . (1)\nMặt khác,  #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN} = \vec{MB} + \vec{BD} - \frac{1}{2}\vec{CD}`) . (2)\nCộng (1) và (2) ta được:  #mi(`2\vec{MN} = \vec{MA} + \vec{MB} + \vec{AC} + \vec{BD}`) .\nĐể  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) , ta cần  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) .\nĐiều này xảy ra khi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Vậy điểm  #mi(`M`)  cần tìm là trung điểm của  #mi(`AB`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`) . Xác định điểm  #mi(`I`)  thỏa mãn  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . Hãy biểu diễn  #mi(`\vec{PI}`)  theo các vectơ  #mi(`\vec{PA}, \vec{PB}, \vec{PC}, \vec{PD}`)  với  #mi(`P`)  là điểm bất kỳ.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điểm  #mi(`I`)  thỏa mãn  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`)  được gọi là trọng tâm của tứ diện  #mi(`ABCD`) .\nVới điểm  #mi(`P`)  bất kỳ, ta chèn điểm  #mi(`I`)  vào các vectơ vế phải:\n #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = (\vec{PI} + \vec{IA}) + (\vec{PI} + \vec{IB}) + (\vec{PI} + \vec{IC}) + (\vec{PI} + \vec{ID})`) \n #mi(`= 4\vec{PI} + (\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID}) = 4\vec{PI} + \vec{0} = 4\vec{PI}`) .\nVậy  #mi(`\vec{PI} = \frac{1}{4}(\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm điểm M thỏa mãn đẳng thức cho trước:] Cho tam giác  #mi(`ABC`) . Tìm điểm  #mi(`M`)  sao cho  #mi(`\vec{MA} + 2\vec{MB} + 3\vec{MC} = \vec{0}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta biến đổi đẳng thức về dạng  #mi(`\vec{AM} = k\vec{v}`) .\n #mi(`\vec{MA} + 2\vec{MB} + 3\vec{MC} = \vec{0} \Leftrightarrow -\vec{AM} - 2\vec{BM} - 3\vec{CM} = \vec{0}`) .\nChèn điểm  #mi(`A`)  vào  #mi(`\vec{BM}`)  và  #mi(`\vec{CM}`) :\n #mi(`-\vec{AM} - 2(\vec{BA} + \vec{AM}) - 3(\vec{CA} + \vec{AM}) = \vec{0}`) \n #mi(`-\vec{AM} - 2\vec{BA} - 2\vec{AM} - 3\vec{CA} - 3\vec{AM} = \vec{0}`) \n #mi(`-6\vec{AM} = 2\vec{BA} + 3\vec{CA} \Rightarrow \vec{AM} = \frac{1}{6}(2\vec{AB} + 3\vec{AC})`) .\nVì  #mi(`A`)  cố định và vectơ  #mi(`2\vec{AB} + 3\vec{AC}`)  cố định, nên điểm  #mi(`M`)  là duy nhất.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Xác định điểm M trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Tìm điểm  #mi(`M`)  sao cho  #mi(`\vec{AM} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, tổng ba vectơ xuất phát từ một đỉnh dọc theo ba cạnh của hình hộp bằng vectơ đường chéo xuất phát từ đỉnh đó.\nTa có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nVậy  #mi(`\vec{AM} = \vec{AC'}`) . Vì  #mi(`A`)  là điểm cố định, nên điểm  #mi(`M`)  trùng với đỉnh  #mi(`C'`)  của hình hộp.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (MauChuan).*] else [*Bài 1.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`N`)  là trung điểm của  #mi(`CD`) . Tìm điểm  #mi(`M`)  trên cạnh  #mi(`AB`)  sao cho  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tương tự Ví dụ 1, ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN} = \vec{MA} + \vec{AC} + \frac{1}{2}\vec{CD}`) .\n #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN} = \vec{MB} + \vec{BD} - \frac{1}{2}\vec{CD}`) .\nCộng hai biểu thức:  #mi(`2\vec{MN} = \vec{MA} + \vec{MB} + \vec{AC} + \vec{BD}`) .\nĐể  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) , ta cần  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) .\nVậy  #mi(`M`)  là trung điểm của  #mi(`AB`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Tìm điểm  #mi(`N`)  trên cạnh  #mi(`CD`)  sao cho  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) .\n #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN}`) .\nCộng hai vế:  #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AC} + \vec{BD}) + (\vec{CN} + \vec{DN})`) .\nVì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) .\nĐể  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) , ta cần  #mi(`\vec{CN} + \vec{DN} = \vec{0}`) .\nĐiều này xảy ra khi  #mi(`N`)  là trung điểm của  #mi(`CD`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Cho tứ diện  #mi(`ABCD`) . Xác định điểm  #mi(`I`)  thỏa mãn  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . Biểu diễn  #mi(`\vec{PI}`)  theo  #mi(`\vec{PA}, \vec{PB}, \vec{PC}, \vec{PD}`)  với  #mi(`P`)  là điểm bất kỳ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điểm  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`) .\nVới điểm  #mi(`P`)  bất kỳ:  #mi(`\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD} = (\vec{PI} + \vec{IA}) + (\vec{PI} + \vec{IB}) + (\vec{PI} + \vec{IC}) + (\vec{PI} + \vec{ID})`) \n #mi(`= 4\vec{PI} + (\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID}) = 4\vec{PI} + \vec{0} = 4\vec{PI}`) .\nVậy  #mi(`\vec{PI} = \frac{1}{4}(\vec{PA} + \vec{PB} + \vec{PC} + \vec{PD})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Cho tam giác  #mi(`ABC`) . Tìm điểm  #mi(`M`)  sao cho  #mi(`\vec{MA} + 3\vec{MB} + 4\vec{MC} = \vec{0}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Biến đổi về dạng  #mi(`\vec{AM} = k\vec{v}`) .\n #mi(`\vec{MA} + 3\vec{MB} + 4\vec{MC} = \vec{0} \Leftrightarrow -\vec{AM} - 3\vec{BM} - 4\vec{CM} = \vec{0}`) .\nChèn điểm  #mi(`A`)  vào  #mi(`\vec{BM}`)  và  #mi(`\vec{CM}`) :\n #mi(`-\vec{AM} - 3(\vec{BA} + \vec{AM}) - 4(\vec{CA} + \vec{AM}) = \vec{0}`) \n #mi(`-\vec{AM} - 3\vec{BA} - 3\vec{AM} - 4\vec{CA} - 4\vec{AM} = \vec{0}`) \n #mi(`-8\vec{AM} = 3\vec{BA} + 4\vec{CA} \Rightarrow \vec{AM} = \frac{1}{8}(3\vec{AB} + 4\vec{AC})`) .\nVì  #mi(`A`)  cố định và vectơ  #mi(`3\vec{AB} + 4\vec{AC}`)  cố định, nên điểm  #mi(`M`)  là duy nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (CungCo).*] else [*Bài 5.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Tìm điểm  #mi(`M`)  sao cho  #mi(`\vec{AM} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .\nVậy  #mi(`\vec{AM} = \vec{AC'}`) . Vì  #mi(`A`)  là điểm cố định, nên điểm  #mi(`M`)  trùng với đỉnh  #mi(`C'`)  của hình hộp.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Tính tích vô hướng của hai vectơ bằng phương pháp hình học ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Tính tích vô hướng của hai vectơ bằng phương pháp hình học]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Định nghĩa tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) 
  - Nếu hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau thì  #mi(`\cos(\vec{a}, \vec{b}) = 0`) , suy ra  #mi(`\vec{a} \cdot \vec{b} = 0`) 
  - Trong tam giác đều hoặc tứ diện đều cạnh  #mi(`a`) , góc giữa hai vectơ xuất phát từ cùng một đỉnh là  #mi(`60^\circ`) , khi đó tích vô hướng của hai cạnh là  #mi(`\vec{u} \cdot \vec{v} = a \cdot a \cdot \cos(60^\circ) = \frac{a^2}{2}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ kỹ: Tích vô hướng có thể âm, dương hoặc bằng 0 tùy vào góc  #mi(`\cos(\vec{a}, \vec{b})`) . Góc nhọn  #mi(`\rightarrow`)  dương, góc tù  #mi(`\rightarrow`)  âm, góc vuông  #mi(`\rightarrow`)  bằng 0.
  ]
  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính theo công thức:  #mi(`\vec{a} \cdot \vec{b} = ... \cdot ... \cdot \cos(\vec{a}, \vec{b})`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có độ dài lần lượt là  #mi(`3`)  và  #mi(`5`) , góc giữa hai vectơ bằng  #mi(`60^\circ`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7.5]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b}) = 3 \cdot 5 \cdot \cos(60^\circ) = 15 \cdot \frac{1}{2} = 7.5`) ]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  vuông góc với nhau, biết  #mi(`|\vec{u}|=10`)  và  #mi(`|\vec{v}|=20`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{u} \perp \vec{v}`)  nên  #mi(`\cos(\vec{u}, \vec{v}) = 0`) . Suy ra  #mi(`\vec{u} \cdot \vec{v} = 10 \cdot 20 \cdot 0 = 0`) ]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản (Góc nhọn):] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có độ dài lần lượt là  #mi(`4`)  và  #mi(`6`) . Biết góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`45^\circ`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức định nghĩa tích vô hướng:
 #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) \nThay số:  #mi(`\vec{a} \cdot \vec{b} = 4 \cdot 6 \cdot \cos(45^\circ) = 24 \cdot \frac{\sqrt{2}}{2} = 12\sqrt{2}`) 
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tích vô hướng với góc tù:] Cho hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  có độ dài  #mi(`|\vec{u}|=2`)  và  #mi(`|\vec{v}|=3`) . Biết góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  là  #mi(`120^\circ`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức định nghĩa tích vô hướng:
 #mi(`\vec{u} \cdot \vec{v} = |\vec{u}| \cdot |\vec{v}| \cdot \cos(\vec{u}, \vec{v})`) \nThay số:  #mi(`\vec{u} \cdot \vec{v} = 2 \cdot 3 \cdot \cos(120^\circ) = 6 \cdot \left(-\frac{1}{2}\right) = -3`) 
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tích vô hướng trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là tứ diện đều cạnh  #mi(`a`)  nên  #mi(`|\vec{AB}| = |\vec{AC}| = a`)  và góc  #mi(`(\vec{AB}, \vec{AC}) = 60^\circ`)  (do tam giác  #mi(`ABC`)  đều).
Áp dụng công thức:
 #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| \cdot |\vec{AC}| \cdot \cos(\vec{AB}, \vec{AC}) = a \cdot a \cdot \cos(60^\circ) = a^2 \cdot \frac{1}{2} = \frac{a^2}{2}`) 
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Trường hợp hai vectơ vuông góc:] Cho hai vectơ  #mi(`\vec{m}`)  và  #mi(`\vec{n}`)  sao cho  #mi(`\vec{m} \perp \vec{n}`) . Biết  #mi(`|\vec{m}|=5`)  và  #mi(`|\vec{n}|=8`) . Tính  #mi(`\vec{m} \cdot \vec{n}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{m} \perp \vec{n}`)  nên góc giữa hai vectơ là  #mi(`90^\circ`) , suy ra  #mi(`\cos(\vec{m}, \vec{n}) = 0`) .\nDo đó:  #mi(`\vec{m} \cdot \vec{n} = 5 \cdot 8 \cdot 0 = 0`) 
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có độ dài lần lượt là  #mi(`2`)  và  #mi(`7`) , góc giữa hai vectơ là  #mi(`60^\circ`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b}) = 2 \cdot 7 \cdot \cos(60^\circ) = 14 \cdot \frac{1}{2} = 7`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  có độ dài lần lượt là  #mi(`5`)  và  #mi(`8`) , góc giữa hai vectơ là  #mi(`60^\circ`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{u} \cdot \vec{v} = |\vec{u}| \cdot |\vec{v}| \cdot \cos(\vec{u}, \vec{v}) = 5 \cdot 8 \cdot \cos(60^\circ) = 40 \cdot \frac{1}{2} = 20`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`)  nên  #mi(`|\vec{AB}| = |\vec{AD}| = a`)  và góc  #mi(`(\vec{AB}, \vec{AD}) = 60^\circ`) .\nSuy ra:  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos(60^\circ) = \frac{a^2}{2}`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có độ dài lần lượt là  #mi(`3`)  và  #mi(`4`) . Biết  #mi(`\vec{a} \cdot \vec{b} = -6`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b}) \Rightarrow -6 = 3 \cdot 4 \cdot \cos(\vec{a}, \vec{b}) \Rightarrow \cos(\vec{a}, \vec{b}) = \frac{-6}{12} = -\frac{1}{2}`) .\nSuy ra góc  #mi(`(\vec{a}, \vec{b}) = 120^\circ`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho tam giác đều  #mi(`ABC`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì tam giác  #mi(`ABC`)  đều cạnh  #mi(`a`)  nên  #mi(`|\vec{AB}| = |\vec{AC}| = a`)  và góc  #mi(`(\vec{AB}, \vec{AC}) = 60^\circ`) .\nSuy ra:  #mi(`\vec{AB} \cdot \vec{AC} = a \cdot a \cdot \cos(60^\circ) = \frac{a^2}{2}`) ] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Tính góc giữa hai vectơ bằng phương pháp hình học ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Tính góc giữa hai vectơ bằng phương pháp hình học]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  không cùng gốc, ta đưa chúng về cùng một gốc  #mi(`O`)  bằng cách sử dụng quy tắc chèn điểm hoặc quy tắc hiệu:  #mi(`\vec{u} \cdot \vec{v} = \vec{OA} \cdot \vec{OB}`)  (nếu  #mi(`\vec{u}=\vec{OA}, \vec{v}=\vec{OB}`) ).
  - Công thức tính cosin góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
  - Nếu  #mi(`\vec{a} \cdot \vec{b} = 0`)  thì hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau ( #mi(`\vec{a} \perp \vec{b}`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính góc giữa hai vectơ không cùng gốc, hãy 'kéo' chúng về cùng một điểm xuất phát bằng cách chèn điểm hoặc dùng quy tắc cộng/trừ vectơ.
  ]
  - *Công thức cốt lõi:* Công thức tính cosin góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\cos(\vec{a}, \vec{b}) = \\dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a=1`) . Tính  #mi(`\cos(\vec{AC}, \vec{BD})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{BD} = \vec{AD} - \vec{AB}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{BD} = (\vec{AB} + \vec{AD}) \cdot (\vec{AD} - \vec{AB}) = \vec{AD}^2 - \vec{AB}^2 = 1^2 - 1^2 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\cos(\vec{AC}, \vec{BD}) = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA=SB=SC=a`)  và  #mi(`SA \perp (ABC)`) . Tính  #mi(`\cos(\vec{SA}, \vec{BC})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`SA \perp (ABC)`)  nên  #mi(`SA \perp BC`) , suy ra  #mi(`\vec{SA} \cdot \vec{BC} = 0`) . Do đó  #mi(`\cos(\vec{SA}, \vec{BC}) = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{BD} = \vec{AD} - \vec{AB}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{BD} = (\vec{AB} + \vec{AD}) \cdot (\vec{AD} - \vec{AB}) = \vec{AD}^2 - \vec{AB}^2 = 1^2 - 1^2 = 0`) . Vì  #mi(`\vec{AC} \cdot \vec{BD} = 0`)  nên  #mi(`\cos(\vec{AC}, \vec{BD}) = 0`) , suy ra góc giữa hai vectơ là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Sử dụng quy tắc chèn điểm trong hình chóp:] Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA=SB=SC=a`)  và  #mi(`SA \perp (ABC)`) . Tính góc giữa hai vectơ  #mi(`\vec{SA}`)  và  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`SA \perp (ABC)`)  nên  #mi(`SA \perp BC`) . Do đó  #mi(`\vec{SA} \cdot \vec{BC} = 0`) . Suy ra  #mi(`\cos(\vec{SA}, \vec{BC}) = 0`) , vậy góc giữa hai vectơ  #mi(`\vec{SA}`)  và  #mi(`\vec{BC}`)  là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến đổi vectơ không cùng gốc:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'D'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Ta có  #mi(`\vec{A'D'} = \vec{A'A} + \vec{AD} = -\vec{AA'} + \vec{AD}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{A'D'} = (\vec{AB} + \vec{AD} + \vec{AA'}) \cdot (\vec{AD} - \vec{AA'}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AA'} + \vec{AD}^2 - \vec{AD} \cdot \vec{AA'} + \vec{AA'} \cdot \vec{AD} - \vec{AA'}^2 = 0 - 0 + a^2 - 0 + 0 - a^2 = 0`) . Vậy góc giữa hai vectơ là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ trong hình chóp đều:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA=a`)  và  #mi(`SA \perp (ABCD)`) . Tính góc giữa  #mi(`\vec{SA}`)  và  #mi(`\vec{BD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`SA \perp BD`) . Do đó  #mi(`\vec{SA} \cdot \vec{BD} = 0`) . Vậy góc giữa  #mi(`\vec{SA}`)  và  #mi(`\vec{BD}`)  là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a=2`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{BD} = \vec{AD} - \vec{AB}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{BD} = \vec{AD}^2 - \vec{AB}^2 = 2^2 - 2^2 = 0`) . Vậy góc giữa hai vectơ là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a=3`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{BD} = \vec{AD} - \vec{AB}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{BD} = \vec{AD}^2 - \vec{AB}^2 = 3^2 - 3^2 = 0`) . Vậy góc giữa hai vectơ là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA=SB=SC=a`)  và  #mi(`SA \perp (ABC)`) . Tính góc giữa  #mi(`\vec{SA}`)  và  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`SA \perp (ABC)`)  nên  #mi(`SA \perp BC`) . Do đó  #mi(`\vec{SA} \cdot \vec{BC} = 0`) . Vậy góc giữa hai vectơ là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Ta có  #mi(`\vec{A'C'} = \vec{A'B'} + \vec{A'D'} = \vec{AB} + \vec{AD}`) . Tích vô hướng  #mi(`\vec{AC} \cdot \vec{A'C'} = (\vec{AB} + \vec{AD} + \vec{AA'}) \cdot (\vec{AB} + \vec{AD}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AD} + \vec{AD} \cdot \vec{AB} + \vec{AD}^2 + \vec{AA'} \cdot \vec{AB} + \vec{AA'} \cdot \vec{AD} = a^2 + 0 + 0 + a^2 + 0 + 0 = 2a^2`) . Độ dài  #mi(`|\vec{AC}| = a\sqrt{3}`) , độ dài  #mi(`|\vec{A'C'}| = a\sqrt{2}`) . Vậy  #mi(`\cos(\vec{AC}, \vec{A'C'}) = \frac{2a^2}{a\sqrt{3} \cdot a\sqrt{2}} = \frac{2}{\sqrt{6}} = \frac{\sqrt{6}}{3}`) . Vậy góc là  #mi(`\arccos(\frac{\sqrt{6}}{3})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Tính cosin góc giữa hai đường thẳng trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Tính cosin góc giữa hai đường thẳng trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tính góc giữa hai đường thẳng  #mi(`d_1`)  và  #mi(`d_2`)  có các vectơ chỉ phương lần lượt là  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) , ta sử dụng công thức:  #mi(`\cos(d_1, d_2) = \frac{|\vec{u} \cdot \vec{v}|}{|\vec{u}| \cdot |\vec{v}|}`) 
  - Giá trị  #mi(`\cos(d_1, d_2)`)  luôn nằm trong đoạn  #mi(`[0; 1]`) , do đó góc giữa hai đường thẳng luôn là góc nhọn hoặc góc vuông ( #mi(`0^\circ \le (d_1, d_2) \le 90^\circ`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Luôn lấy giá trị tuyệt đối ở tử số để đảm bảo  #mi(`\cos \ge 0`)  (góc không bao giờ tù đối với đường thẳng).
  ]
  - *Công thức cốt lõi:* Công thức tính cosin góc giữa hai đường thẳng có VCP  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  là  #mi(`\cos(d_1, d_2) = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  có VCP  #mi(`\vec{u} = (1; 2; 0)`)  và  #mi(`d_2`)  có VCP  #mi(`\vec{v} = (0; 1; 1)`) . Tính  #mi(`\cos(d_1, d_2)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.63]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 1\cdot 0 + 2\cdot 1 + 0\cdot 1 = 2`) . Độ dài  #mi(`|\vec{u}| = \sqrt{1^2 + 2^2 + 0^2} = \sqrt{5}`) . Độ dài  #mi(`|\vec{v}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . Áp dụng công thức:  #mi(`\cos(d_1, d_2) = \frac{|2|}{\sqrt{5} \cdot \sqrt{2}} = \frac{2}{\sqrt{10}} = \frac{\sqrt{10}}{5}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tính góc giữa hai đường thẳng  #mi(`d_1: \frac{x-1}{2} = \frac{y}{1} = \frac{z}{-2}`)  và  #mi(`d_2: \frac{x}{1} = \frac{y}{2} = \frac{z}{2}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 90]
      \ #text(fill: rgb("#334155"))[Lời giải: VCP của  #mi(`d_1`)  là  #mi(`\vec{u} = (2; 1; -2)`) . VCP của  #mi(`d_2`)  là  #mi(`\vec{v} = (1; 2; 2)`) . Tích vô hướng  #mi(`\vec{u} \cdot \vec{v} = 2\cdot 1 + 1\cdot 2 + (-2)\cdot 2 = 2 + 2 - 4 = 0`) . Do đó  #mi(`\cos(d_1, d_2) = 0`) , suy ra góc giữa hai đường thẳng là  #mi(`90^\circ`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản với tọa độ điểm:] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  đi qua  #mi(`A(1; 0; 2)`)  và  #mi(`B(2; 1; 2)`) , đường thẳng  #mi(`d_2`)  đi qua  #mi(`C(0; 0; 0)`)  và  #mi(`D(1; 1; 1)`) . Tính  #mi(`\cos(d_1, d_2)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] VCP của  #mi(`d_1`)  là  #mi(`\vec{AB} = (2-1; 1-0; 2-2) = (1; 1; 0)`) . VCP của  #mi(`d_2`)  là  #mi(`\vec{CD} = (1-0; 1-0; 1-0) = (1; 1; 1)`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{CD} = 1\cdot 1 + 1\cdot 1 + 0\cdot 1 = 2`) . Độ dài  #mi(`|\vec{AB}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) . Độ dài  #mi(`|\vec{CD}| = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) . Vậy  #mi(`\cos(d_1, d_2) = \frac{|2|}{\sqrt{2} \cdot \sqrt{3}} = \frac{2}{\sqrt{6}} = \frac{\sqrt{6}}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc từ phương trình tham số:] Tính góc giữa hai đường thẳng  #mi(`d_1: \begin{cases} x = 1 + t \\ y = 2 - t \\ z = 3t \end{cases}`)  và  #mi(`d_2: \begin{cases} x = 2s \\ y = 1 + s \\ z = -s \end{cases}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ phương trình tham số, ta xác định được VCP của  #mi(`d_1`)  là  #mi(`\vec{u} = (1; -1; 3)`)  và VCP của  #mi(`d_2`)  là  #mi(`\vec{v} = (2; 1; -1)`) . Tích vô hướng  #mi(`\vec{u} \cdot \vec{v} = 1\cdot 2 + (-1)\cdot 1 + 3\cdot(-1) = 2 - 1 - 3 = -2`) . Độ dài  #mi(`|\vec{u}| = \sqrt{1^2 + (-1)^2 + 3^2} = \sqrt{11}`) . Độ dài  #mi(`|\vec{v}| = \sqrt{2^2 + 1^2 + (-1)^2} = \sqrt{6}`) . Vậy  #mi(`\cos(d_1, d_2) = \frac{|-2|}{\sqrt{11} \cdot \sqrt{6}} = \frac{2}{\sqrt{66}} = \frac{\sqrt{66}}{33}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Đường thẳng đi qua hai điểm cho trước:] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  đi qua  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) , đường thẳng  #mi(`d_2`)  đi qua  #mi(`C(0; 1; 0)`)  và  #mi(`D(2; 0; 1)`) . Tính góc giữa  #mi(`d_1`)  và  #mi(`d_2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] VCP của  #mi(`d_1`)  là  #mi(`\vec{AB} = (2; 2; 2)`) . VCP của  #mi(`d_2`)  là  #mi(`\vec{CD} = (2; -1; 1)`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{CD} = 2\cdot 2 + 2\cdot(-1) + 2\cdot 1 = 4 - 2 + 2 = 4`) . Độ dài  #mi(`|\vec{AB}| = \sqrt{2^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) . Độ dài  #mi(`|\vec{CD}| = \sqrt{2^2 + (-1)^2 + 1^2} = \sqrt{6}`) . Vậy  #mi(`\cos(d_1, d_2) = \frac{|4|}{2\sqrt{3} \cdot \sqrt{6}} = \frac{4}{2\sqrt{18}} = \frac{4}{6\sqrt{2}} = \frac{2}{3\sqrt{2}} = \frac{\sqrt{2}}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể với tọa độ âm:] Tính  #mi(`\cos`)  góc giữa hai đường thẳng  #mi(`d_1`)  có VCP  #mi(`\vec{u} = (-3; 4; 1)`)  và  #mi(`d_2`)  có VCP  #mi(`\vec{v} = (2; -1; 5)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tích vô hướng  #mi(`\vec{u} \cdot \vec{v} = (-3)\cdot 2 + 4\cdot(-1) + 1\cdot 5 = -6 - 4 + 5 = -5`) . Độ dài  #mi(`|\vec{u}| = \sqrt{(-3)^2 + 4^2 + 1^2} = \sqrt{26}`) . Độ dài  #mi(`|\vec{v}| = \sqrt{2^2 + (-1)^2 + 5^2} = \sqrt{30}`) . Vậy  #mi(`\cos(d_1, d_2) = \frac{|-5|}{\sqrt{26} \cdot \sqrt{30}} = \frac{5}{\sqrt{780}} = \frac{5}{2\sqrt{195}}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  có VCP  #mi(`\vec{u} = (1; 1; 1)`)  và  #mi(`d_2`)  có VCP  #mi(`\vec{v} = (1; -1; 0)`) . Tính  #mi(`\cos(d_1, d_2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 1\cdot 1 + 1\cdot(-1) + 1\cdot 0 = 0`) . Do đó  #mi(`\cos(d_1, d_2) = 0`) , suy ra góc giữa hai đường thẳng là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  có VCP  #mi(`\vec{u} = (2; 0; -1)`)  và  #mi(`d_2`)  có VCP  #mi(`\vec{v} = (1; 3; 2)`) . Tính  #mi(`\cos(d_1, d_2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 2\cdot 1 + 0\cdot 3 + (-1)\cdot 2 = 0`) . Do đó  #mi(`\cos(d_1, d_2) = 0`) , suy ra góc giữa hai đường thẳng là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tính  #mi(`\cos`)  góc giữa hai đường thẳng  #mi(`d_1: \begin{cases} x = t \\ y = 1+t \\ z = 2-t \end{cases}`)  và  #mi(`d_2: \begin{cases} x = 2s \\ y = s \\ z = 3s \end{cases}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: VCP của  #mi(`d_1`)  là  #mi(`\vec{u} = (1; 1; -1)`) . VCP của  #mi(`d_2`)  là  #mi(`\vec{v} = (2; 1; 3)`) . Tích vô hướng  #mi(`\vec{u} \cdot \vec{v} = 1\cdot 2 + 1\cdot 1 + (-1)\cdot 3 = 0`) . Do đó  #mi(`\cos(d_1, d_2) = 0`) , suy ra góc giữa hai đường thẳng là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hai đường thẳng  #mi(`d_1`)  đi qua  #mi(`A(1; 1; 1)`)  và  #mi(`B(2; 3; 4)`) , đường thẳng  #mi(`d_2`)  đi qua  #mi(`C(0; 0; 0)`)  và  #mi(`D(1; 0; 1)`) . Tính  #mi(`\cos(d_1, d_2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: VCP của  #mi(`d_1`)  là  #mi(`\vec{AB} = (1; 2; 3)`) . VCP của  #mi(`d_2`)  là  #mi(`\vec{CD} = (1; 0; 1)`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{CD} = 1\cdot 1 + 2\cdot 0 + 3\cdot 1 = 4`) . Độ dài  #mi(`|\vec{AB}| = \sqrt{1^2 + 2^2 + 3^2} = \sqrt{14}`) . Độ dài  #mi(`|\vec{CD}| = \sqrt{1^2 + 0^2 + 1^2} = \sqrt{2}`) . Vậy  #mi(`\cos(d_1, d_2) = \frac{|4|}{\sqrt{14} \cdot \sqrt{2}} = \frac{4}{\sqrt{28}} = \frac{4}{2\sqrt{7}} = \frac{2}{\sqrt{7}}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Thiết lập tọa độ điểm và vectơ trong hệ tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Thiết lập tọa độ điểm và vectơ trong hệ tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong không gian  #mi(`Oxyz`) , vectơ  #mi(`\vec{a}`)  được biểu diễn qua các vectơ đơn vị  #mi(`\vec{i}, \vec{j}, \vec{k}`)  là  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`) , khi đó tọa độ của vectơ  #mi(`\vec{a}`)  là  #mi(`(x; y; z)`) .
  - Một điểm  #mi(`M`)  có tọa độ  #mi(`(x; y; z)`)  khi và chỉ khi  #mi(`\vec{OM} = x\vec{i} + y\vec{j} + z\vec{k}`) , trong đó  #mi(`O`)  là gốc tọa độ.
  - Để xác định tọa độ điểm  #mi(`M`)  từ hình vẽ (thường là hình hộp chữ nhật), ta sử dụng quy tắc hình hộp:  #mi(`\vec{OM} = \vec{OA} + \vec{OB} + \vec{OC}`)  với  #mi(`A, B, C`)  là hình chiếu của  #mi(`M`)  lên các trục tọa độ.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Hệ số đứng trước  #mi(`\vec{i}, \vec{j}, \vec{k}`)  chính là hoành độ  #mi(`x`) , tung độ  #mi(`y`)  và cao độ  #mi(`z`)  theo đúng thứ tự.
  ]
  - *Công thức cốt lõi:* Điểm  #mi(`M`)  có tọa độ  #mi(`(x; y; z)`)  khi và chỉ khi  #mi(`\vec{OM} = ...\vec{i} + ...\vec{j} + ...\vec{k}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tọa độ của vectơ  #mi(`\vec{v}`)  biết  #mi(`\vec{v} = -\vec{i} + 4\vec{j} - 2\vec{k}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (-1; 4; -2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Hệ số của  #mi(`\vec{i}`)  là  #mi(`-1`) , hệ số của  #mi(`\vec{j}`)  là  #mi(`4`) , hệ số của  #mi(`\vec{k}`)  là  #mi(`-2`) . Vậy tọa độ của vectơ  #mi(`\vec{v}`)  là  #mi(`(-1; 4; -2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Điểm  #mi(`M`)  có  #mi(`\vec{OM} = 2\vec{i} + 0\vec{j} - 3\vec{k}`) . Tọa độ của điểm  #mi(`M`)  là gì?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2; 0; -3)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{OM} = 2\vec{i} + 0\vec{j} - 3\vec{k}`)  nên hoành độ  #mi(`x=2`) , tung độ  #mi(`y=0`) , cao độ  #mi(`z=-3`) . Vậy  #mi(`M(2; 0; -3)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tọa độ vectơ từ biểu thức:] Cho vectơ  #mi(`\vec{u} = 3\vec{i} - 2\vec{j} + 4\vec{k}`) . Hãy viết tọa độ của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa, nếu  #mi(`\vec{u} = x\vec{i} + y\vec{j} + z\vec{k}`)  thì tọa độ của  #mi(`\vec{u}`)  là  #mi(`(x; y; z)`) .\nỞ đây,  #mi(`x = 3, y = -2, z = 4`) .\nVậy  #mi(`\vec{u} = (3; -2; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định tọa độ điểm từ biểu thức:] Tìm tọa độ điểm  #mi(`A`)  biết  #mi(`\vec{OA} = 5\vec{i} + \vec{j} - 6\vec{k}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{OA} = 5\vec{i} + 1\vec{j} - 6\vec{k}`)  nên tọa độ của điểm  #mi(`A`)  là  #mi(`(5; 1; -6)`) .\nVậy  #mi(`A(5; 1; -6)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định tọa độ điểm từ hình vẽ:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M`)  sao cho hình chiếu của  #mi(`M`)  lên trục  #mi(`Ox`)  là  #mi(`A(2; 0; 0)`) , lên trục  #mi(`Oy`)  là  #mi(`B(0; 3; 0)`)  và lên trục  #mi(`Oz`)  là  #mi(`C(0; 0; 4)`) . Tìm tọa độ điểm  #mi(`M`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{OA} = 2\vec{i}, \vec{OB} = 3\vec{j}, \vec{OC} = 4\vec{k}`) .\nTheo quy tắc hình hộp:  #mi(`\vec{OM} = \vec{OA} + \vec{OB} + \vec{OC} = 2\vec{i} + 3\vec{j} + 4\vec{k}`) .\nVậy tọa độ điểm  #mi(`M`)  là  #mi(`(2; 3; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu diễn vectơ qua hệ đơn vị (Câu hỏi ngược):] Cho vectơ  #mi(`\vec{a} = (-1; 4; 0)`) . Hãy biểu diễn  #mi(`\vec{a}`)  qua các vectơ đơn vị  #mi(`\vec{i}, \vec{j}, \vec{k}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{a} = (-1; 4; 0)`)  nên  #mi(`x = -1, y = 4, z = 0`) .\nTheo công thức  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`) , ta có:\n #mi(`\vec{a} = -1\vec{i} + 4\vec{j} + 0\vec{k} = -\vec{i} + 4\vec{j}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho vectơ  #mi(`\vec{u} = 4\vec{i} + 3\vec{j} - 5\vec{k}`) . Tìm tọa độ của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hệ số của  #mi(`\vec{i}, \vec{j}, \vec{k}`)  lần lượt là  #mi(`4, 3, -5`) . Vậy  #mi(`\vec{u} = (4; 3; -5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho vectơ  #mi(`\vec{v} = -2\vec{i} + 6\vec{j} + \vec{k}`) . Tìm tọa độ của vectơ  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hệ số của  #mi(`\vec{i}, \vec{j}, \vec{k}`)  lần lượt là  #mi(`-2, 6, 1`) . Vậy  #mi(`\vec{v} = (-2; 6; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tọa độ điểm  #mi(`P`)  biết  #mi(`\vec{OP} = 7\vec{i} - 4\vec{j} + 2\vec{k}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{OP} = 7\vec{i} - 4\vec{j} + 2\vec{k}`)  nên tọa độ điểm  #mi(`P`)  là  #mi(`(7; -4; 2)`) . Vậy  #mi(`P(7; -4; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho vectơ  #mi(`\vec{w} = (2; -3; 6)`) . Hãy biểu diễn  #mi(`\vec{w}`)  qua các vectơ đơn vị  #mi(`\vec{i}, \vec{j}, \vec{k}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{w} = (2; -3; 6)`)  nên  #mi(`x = 2, y = -3, z = 6`) .\nVậy  #mi(`\vec{w} = 2\vec{i} - 3\vec{j} + 6\vec{k}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Trong không gian  #mi(`Oxyz`) , điểm  #mi(`M`)  có hình chiếu lên các trục tọa độ lần lượt là  #mi(`A(5; 0; 0), B(0; -2; 0), C(0; 0; 1)`) . Tìm tọa độ điểm  #mi(`M`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{OA} = 5\vec{i}, \vec{OB} = -2\vec{j}, \vec{OC} = 1\vec{k}`) .\nTheo quy tắc hình hộp:  #mi(`\vec{OM} = \vec{OA} + \vec{OB} + \vec{OC} = 5\vec{i} - 2\vec{j} + \vec{k}`) .\nVậy tọa độ điểm  #mi(`M`)  là  #mi(`(5; -2; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Tính độ dài vectơ và khoảng cách giữa hai điểm trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Tính độ dài vectơ và khoảng cách giữa hai điểm trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Độ dài của vectơ  #mi(`\vec{u} = (x; y; z)`)  được tính bằng công thức:  #mi(`|\vec{u}| = \sqrt{x^2 + y^2 + z^2}`) .
  - Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  trong không gian Oxyz là:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Độ dài vectơ  #mi(`\vec{u}`)  chính là độ dài đoạn thẳng biểu diễn vectơ đó. Nếu đã biết tọa độ vectơ  #mi(`\vec{u} = (x; y; z)`) , chỉ cần áp dụng công thức căn bậc hai của tổng bình phương các thành phần.
  ]
  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{u} = (x; y; z)`)  là  #mi(`|\vec{u}| = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian Oxyz, cho vectơ  #mi(`\vec{u} = (2; -3; 6)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tính độ dài vectơ:  #mi(`|\vec{u}| = \sqrt{x^2 + y^2 + z^2}`) . Ta có:  #mi(`|\vec{u}| = \sqrt{2^2 + (-3)^2 + 6^2} = \sqrt{4 + 9 + 36} = \sqrt{49} = 7`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian Oxyz, cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 6; 3)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tính khoảng cách giữa hai điểm:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) . Ta có:  #mi(`AB = \sqrt{(4-1)^2 + (6-2)^2 + (3-3)^2} = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9 + 16 + 0} = \sqrt{25} = 5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính độ dài vectơ cơ bản:] Trong không gian Oxyz, cho vectơ  #mi(`\vec{u} = (3; -4; 0)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính độ dài vectơ:  #mi(`|\vec{u}| = \sqrt{x^2 + y^2 + z^2}`) . Ta có:  #mi(`|\vec{u}| = \sqrt{3^2 + (-4)^2 + 0^2} = \sqrt{9 + 16 + 0} = \sqrt{25} = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính độ dài vectơ với các thành phần khác 0:] Trong không gian Oxyz, cho vectơ  #mi(`\vec{v} = (1; 2; 2)`) . Tính độ dài của vectơ  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính độ dài vectơ:  #mi(`|\vec{v}| = \sqrt{x^2 + y^2 + z^2}`) . Ta có:  #mi(`|\vec{v}| = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính khoảng cách giữa hai điểm:] Trong không gian Oxyz, cho hai điểm  #mi(`A(0; 0; 0)`)  và  #mi(`B(2; 1; -2)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính khoảng cách giữa hai điểm:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) . Ta có:  #mi(`AB = \sqrt{(2-0)^2 + (1-0)^2 + (-2-0)^2} = \sqrt{2^2 + 1^2 + (-2)^2} = \sqrt{4 + 1 + 4} = \sqrt{9} = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính khoảng cách giữa hai điểm có tọa độ phức tạp hơn:] Trong không gian Oxyz, cho hai điểm  #mi(`A(-1; 3; 2)`)  và  #mi(`B(2; -1; -2)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính khoảng cách giữa hai điểm:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) . Ta có:  #mi(`AB = \sqrt{(2 - (-1))^2 + (-1 - 3)^2 + (-2 - 2)^2} = \sqrt{3^2 + (-4)^2 + (-4)^2} = \sqrt{9 + 16 + 16} = \sqrt{41}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian Oxyz, cho vectơ  #mi(`\vec{u} = (4; 0; -3)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức tính độ dài vectơ:  #mi(`|\vec{u}| = \sqrt{x^2 + y^2 + z^2}`) . Ta có:  #mi(`|\vec{u}| = \sqrt{4^2 + 0^2 + (-3)^2} = \sqrt{16 + 0 + 9} = \sqrt{25} = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian Oxyz, cho vectơ  #mi(`\vec{v} = (-2; 2; 1)`) . Tính độ dài của vectơ  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức tính độ dài vectơ:  #mi(`|\vec{v}| = \sqrt{x^2 + y^2 + z^2}`) . Ta có:  #mi(`|\vec{v}| = \sqrt{(-2)^2 + 2^2 + 1^2} = \sqrt{4 + 4 + 1} = \sqrt{9} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian Oxyz, cho hai điểm  #mi(`A(2; 1; 0)`)  và  #mi(`B(5; 5; 0)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức tính khoảng cách giữa hai điểm:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) . Ta có:  #mi(`AB = \sqrt{(5-2)^2 + (5-5)^2 + (0-0)^2} = \sqrt{3^2 + 0^2 + 0^2} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian Oxyz, cho hai điểm  #mi(`A(1; -1; 4)`)  và  #mi(`B(3; 2; 4)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức tính khoảng cách giữa hai điểm:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) . Ta có:  #mi(`AB = \sqrt{(3-1)^2 + (2 - (-1))^2 + (4-4)^2} = \sqrt{2^2 + 3^2 + 0^2} = \sqrt{4 + 9 + 0} = \sqrt{13}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Tìm tọa độ điểm và vectơ dựa trên tính chất hình học Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Tìm tọa độ điểm và vectơ dựa trên tính chất hình học Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong hình bình hành  #mi(`ABCD`) , ta có đẳng thức vectơ  #mi(`\vec{AB} = \vec{DC}`)  (hoặc  #mi(`\vec{AD} = \vec{BC}`) ), từ đó suy ra tọa độ đỉnh còn lại:  #mi(`x_D = x_A + x_C - x_B; y_D = y_A + y_C - y_B; z_D = z_A + z_C - z_B`) .
  - Nếu  #mi(`M`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì tọa độ điểm  #mi(`M`)  là:  #mi(`M\left(\frac{x_A + x_B}{2}; \frac{y_A + y_B}{2}; \frac{z_A + z_B}{2}\right)`) .
  - Nếu  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`)  thì tọa độ điểm  #mi(`G`)  là:  #mi(`G\left(\frac{x_A + x_B + x_C}{3}; \frac{y_A + y_B + y_C}{3}; \frac{z_A + z_B + z_C}{3}\right)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tìm đỉnh thứ 4 của hình bình hành, hãy lấy: (Tổng tọa độ 2 đỉnh đối) - (Tọa độ đỉnh thứ 3).
  ]
  - *Công thức cốt lõi:* Trong tam giác  #mi(`ABC`) , tọa độ trọng tâm  #mi(`G`)  được tính bằng công thức  #mi(`G\left(\dots; \dots; \dots\right)`)  với  #mi(`\dots = \frac{x_A + x_B + x_C}{3}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 5)`)  và  #mi(`C(7; -3; 9)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: G(11/3;-1/3;16/3)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G`)  được tính theo công thức:  #mi(`x_G = \frac{1+3+7}{3} = \\frac{11}{3}`) ;  #mi(`y_G = \frac{0+2-3}{3} = -\frac{1}{3}`) ;  #mi(`z_G = \frac{2+5+9}{3} = \frac{16}{3}`) . Vậy  #mi(`G(\frac{11}{3}; -\frac{1}{3}; \frac{16}{3})`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho đoạn thẳng  #mi(`AB`)  với  #mi(`A(2; 4; -1)`)  và  #mi(`B(4; 0; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: M(3;2;2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{2+4}{2} = 3`) ;  #mi(`y_M = \frac{4+0}{2} = 2`) ;  #mi(`z_M = \frac{-1+5}{2} = 2`) . Vậy  #mi(`M(3; 2; 2)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ đỉnh của hình bình hành:] Trong không gian  #mi(`Oxyz`) , cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 5)`)  và  #mi(`C(7; -3; 9)`) . Tìm tọa độ đỉnh  #mi(`D`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Gọi  #mi(`D(x; y; z)`) . Ta có:  #mi(`\vec{AB} = (3-1; 2-0; 5-2) = (2; 2; 3)`) .  #mi(`\vec{DC} = (7-x; -3-y; 9-z)`) . Vì  #mi(`\vec{AB} = \vec{DC}`)  nên:  #mi(`\begin{cases} 7-x=2 \\ -3-y=2 \\ 9-z=3 \end{cases} \Rightarrow \begin{cases} x=5 \\ y=-5 \\ z=6 \end{cases}`) . Vậy  #mi(`D(5; -5; 6)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ trung điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 2; 1)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trung điểm  #mi(`M`)  được tính bằng công thức:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+2}{2} = 2`) ;  #mi(`z_M = \frac{3+1}{2} = 2`) . Vậy  #mi(`M(2; 2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ trọng tâm tam giác:] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trọng tâm  #mi(`G`)  được tính theo công thức:  #mi(`x_G = \frac{1+3+2}{3} = 2`) ;  #mi(`y_G = \frac{2+2-1}{3} = 1`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ đỉnh của hình hộp:] Trong không gian  #mi(`Oxyz`) , cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 5)`) ,  #mi(`C(7; -3; 9)`)  và  #mi(`A'(5; 0; 1)`) . Tìm tọa độ đỉnh  #mi(`D`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`ABCD`)  là hình bình hành. Do đó, tọa độ đỉnh  #mi(`D`)  được tìm tương tự như Ví dụ 1. Ta có  #mi(`\vec{AB} = (2; 2; 3)`) . Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{DC} = \vec{AB} \Rightarrow (7-x_D; -3-y_D; 9-z_D) = (2; 2; 3) \Rightarrow D(5; -5; 6)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(5; 5; 6)`) . Tìm tọa độ đỉnh  #mi(`D`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Ta có  #mi(`\vec{AB} = (2-1; 3-1; 4-1) = (1; 2; 3)`) . Gọi  #mi(`D(x; y; z)`) , ta có  #mi(`\vec{DC} = (5-x; 5-y; 6-z)`) . Vì  #mi(`\vec{AB} = \vec{DC}`)  nên:  #mi(`\begin{cases} 5-x=1 \\ 5-y=2 \\ 6-z=3 \end{cases} \Rightarrow D(4; 3; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hình bình hành  #mi(`PQRS`)  có  #mi(`P(0; 0; 0)`) ,  #mi(`Q(1; 2; 3)`)  và  #mi(`R(4; 4; 3)`) . Tìm tọa độ đỉnh  #mi(`S`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`PQRS`)  là hình bình hành nên  #mi(`\vec{PQ} = \vec{SR}`) . Ta có  #mi(`\vec{PQ} = (1; 2; 3)`) . Gọi  #mi(`S(x; y; z)`) , ta có  #mi(`\vec{SR} = (4-x; 4-y; 3-z)`) . Vì  #mi(`\vec{PQ} = \vec{SR}`)  nên:  #mi(`\begin{cases} 4-x=1 \\ 4-y=2 \\ 3-z=3 \end{cases} \Rightarrow S(3; 2; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(6; 0; 0)`)  và  #mi(`C(3; 3; 0)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trọng tâm  #mi(`G`)  là:  #mi(`x_G = \frac{0+6+3}{3} = 3`) ;  #mi(`y_G = \frac{0+0+3}{3} = 1`) ;  #mi(`z_G = \frac{0+0+0}{3} = 0`) . Vậy  #mi(`G(3; 1; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(2; 0; 0)`) ,  #mi(`C(2; 2; 0)`)  và  #mi(`D(0; 2; 0)`) . Biết  #mi(`A'(0; 0; 3)`) . Tìm tọa độ trung điểm  #mi(`M`)  của cạnh  #mi(`A'B'`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`A'B'`)  là cạnh của hình hộp, tọa độ  #mi(`A'`)  là  #mi(`(0; 0; 3)`) . Vì  #mi(`B`)  có tọa độ  #mi(`(2; 0; 0)`)  và  #mi(`ABCD`)  là hình bình hành đáy, ta có  #mi(`B'`)  có tọa độ  #mi(`(2; 0; 3)`)  (vì  #mi(`BB' = AA'`) ). Trung điểm  #mi(`M`)  của  #mi(`A'B'`)  có tọa độ:  #mi(`x_M = \frac{0+2}{2} = 1`) ;  #mi(`y_M = \frac{0+0}{2} = 0`) ;  #mi(`z_M = \frac{3+3}{2} = 3`) . Vậy  #mi(`M(1; 0; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 15: Tính tích vô hướng và góc giữa hai vectơ bằng tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 15. Tính tích vô hướng và góc giữa hai vectơ bằng tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}=(x_1;y_1;z_1)`)  và  #mi(`\vec{b}=(x_2;y_2;z_2)`)  là:  #mi(`\vec{a}.\vec{b} = x_1x_2 + y_1y_2 + z_1z_2`) 
  - Độ dài của vectơ  #mi(`\vec{a}=(x;y;z)`)  là:  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) 
  - Góc  #mi(`\theta`)  giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính bởi:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a}.\vec{b}}{|\vec{a}|\cdot|\vec{b}|}`) 
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi  #mi(`\vec{a}.\vec{b} = 0`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính tích vô hướng, hãy lấy 'tổng các tích tương ứng' của các tọa độ. Muốn kiểm tra vuông góc, chỉ cần tích vô hướng bằng  #mi(`0`) .
  ]
  - *Công thức cốt lõi:* Công thức tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\cos(\vec{a}, \vec{b}) =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a}=(1;2;3)`)  và  #mi(`\vec{b}=(4;5;6)`) . Tính tích vô hướng  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 32]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a}.\vec{b} = 1\cdot4 + 2\cdot5 + 3\cdot6 = 4 + 10 + 18 = 32`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u}=(3;0;-4)`)  và  #mi(`\vec{v}=(0;4;0)`) . Tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 90]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{u}.\vec{v} = 3\cdot0 + 0\cdot4 + (-4)\cdot0 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên hai vectơ vuông góc, góc giữa chúng là  #mi(`90^\circ`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức tích vô hướng cơ bản:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a}=(1;4;2)`)  và  #mi(`\vec{b}=(-4;1;0)`) . Tính tích vô hướng  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tích vô hướng:  #mi(`\vec{a}.\vec{b} = x_a x_b + y_a y_b + z_a z_b`) . Ta có:  #mi(`\vec{a}.\vec{b} = 1\cdot(-4) + 4\cdot1 + 2\cdot0 = -4 + 4 + 0 = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc giữa hai vectơ:] Cho  #mi(`\vec{u}=(1;1;0)`)  và  #mi(`\vec{v}=(0;1;1)`) . Tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tính tích vô hướng:  #mi(`\vec{u}.\vec{v} = 1\cdot0 + 1\cdot1 + 0\cdot1 = 1`) . 
2. Tính độ dài:  #mi(`|\vec{u}| = \sqrt{1^2+1^2+0^2} = \sqrt{2}`) ;  #mi(`|\vec{v}| = \sqrt{0^2+1^2+1^2} = \sqrt{2}`) . 
3. Tính cosin:  #mi(`\cos(\vec{u}, \vec{v}) = \frac{1}{\sqrt{2}\cdot\sqrt{2}} = \frac{1}{2}`) . 
4. Suy ra góc:  #mi(`\angle(\vec{u}, \vec{v}) = 60^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Kiểm tra tính vuông góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2; -1; 1)`)  và  #mi(`\vec{b}=(x; 2; 4)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}.\vec{b} = 0`) . \nTa có:  #mi(`2\cdot x + (-1)\cdot 2 + 1\cdot 4 = 0 \Leftrightarrow 2x - 2 + 4 = 0 \Leftrightarrow 2x + 2 = 0 \Leftrightarrow x = -1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai đường thẳng qua vectơ chỉ phương:] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng có hai vectơ chỉ phương lần lượt là  #mi(`\vec{u}=(1; 2; 2)`)  và  #mi(`\vec{v}=(2; 1; -2)`) . Tính góc giữa hai đường thẳng này.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tính tích vô hướng:  #mi(`\vec{u}.\vec{v} = 1\cdot2 + 2\cdot1 + 2\cdot(-2) = 2 + 2 - 4 = 0`) . 
2. Vì tích vô hướng bằng  #mi(`0`)  nên hai đường thẳng vuông góc với nhau. 
3. Vậy góc giữa hai đường thẳng là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho  #mi(`\vec{a}=(2; 3; -1)`)  và  #mi(`\vec{b}=(1; -2; 4)`) . Tính tích vô hướng  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a}.\vec{b} = 2\cdot1 + 3\cdot(-2) + (-1)\cdot4 = 2 - 6 - 4 = -8`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho  #mi(`\vec{u}=(5; 0; 2)`)  và  #mi(`\vec{v}=(1; 4; -3)`) . Tính tích vô hướng  #mi(`\vec{u}.\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{u}.\vec{v} = 5\cdot1 + 0\cdot4 + 2\cdot(-3) = 5 + 0 - 6 = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho  #mi(`\vec{a}=(1; 1; 1)`)  và  #mi(`\vec{b}=(2; 2; 2)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1.  #mi(`\vec{a}.\vec{b} = 1\cdot2 + 1\cdot2 + 1\cdot2 = 6`) . 
2.  #mi(`|\vec{a}| = \sqrt{1^2+1^2+1^2} = \sqrt{3}`) ;  #mi(`|\vec{b}| = \sqrt{2^2+2^2+2^2} = \sqrt{12} = 2\sqrt{3}`) . 
3.  #mi(`\cos(\vec{a}, \vec{b}) = \frac{6}{\sqrt{3}\cdot2\sqrt{3}} = \frac{6}{6} = 1`) . 
4. Vì  #mi(`\cos = 1`)  nên góc là  #mi(`0^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(x; 1; 2)`)  và  #mi(`\vec{b}=(2; -2; 1)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}.\vec{b} = 0`) . \nTa có:  #mi(`x\cdot2 + 1\cdot(-2) + 2\cdot1 = 0 \Leftrightarrow 2x - 2 + 2 = 0 \Leftrightarrow 2x = 0 \Leftrightarrow x = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 16: Tính toán giá trị đại số và tọa độ tổng hợp trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 16. Tính toán giá trị đại số và tọa độ tổng hợp trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là:  #mi(`G = (\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3})`) 
  - Tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  là:  #mi(`M = (\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2})`) 
  - Nếu  #mi(`\vec{a} = (x; y; z)`)  và  #mi(`\vec{b} = (x'; y'; z')`)  thì  #mi(`\vec{a} \cdot \vec{b} = xx' + yy' + zz'`)  và  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) 
  - Tọa độ vectơ  #mi(`\vec{MN}`)  đi từ  #mi(`M(x_M; y_M; z_M)`)  đến  #mi(`N(x_N; y_N; z_N)`)  là:  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tìm tọa độ điểm thứ ba khi biết trọng tâm, hãy dùng quy tắc 'nhân 3 rồi trừ hai':  #mi(`x_C = 3x_G - x_A - x_B`) .
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  được tính bằng công thức  #mi(`x_G =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tính tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2; 1; 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G`)  được tính theo công thức:  #mi(`x_G = \frac{1+3+2}{3} = 2`) ;  #mi(`y_G = \frac{2+2-1}{3} = 1`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai điểm  #mi(`A(1; 0; 1)`)  và  #mi(`B(0; -3; 1)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.5; -1.5; 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{1+0}{2} = 0.5`) ;  #mi(`y_M = \frac{0-3}{2} = -1.5`) ;  #mi(`z_M = \frac{1+1}{2} = 1`) . Vậy  #mi(`M(0.5; -1.5; 1)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ trọng tâm tam giác:] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 1)`) ,  #mi(`B(0; -3; 1)`)  và  #mi(`C(4; -1; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trọng tâm tam giác  #mi(`ABC`) :  #mi(`x_G = \frac{x_A+x_B+x_C}{3} = \frac{1+0+4}{3} = \frac{5}{3}`) ;  #mi(`y_G = \frac{y_A+y_B+y_C}{3} = \frac{0-3-1}{3} = -\frac{4}{3}`) ;  #mi(`z_G = \frac{z_A+z_B+z_C}{3} = \frac{1+1+4}{3} = 2`) . Vậy  #mi(`G(\frac{5}{3}; -\frac{4}{3}; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ điểm khi biết trọng tâm:] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 9; -1)`) ,  #mi(`B(9; 4; 5)`)  và trọng tâm  #mi(`G(3; 0; 4)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên:  #mi(`x_C = 3x_G - x_A - x_B = 3(3) - 2 - 9 = -2`) ;  #mi(`y_C = 3y_G - y_A - y_B = 3(0) - 9 - 4 = -13`) ;  #mi(`z_C = 3z_G - z_A - z_B = 3(4) - (-1) - 5 = 8`) . Vậy  #mi(`C(-2; -13; 8)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tọa độ vectơ và độ dài:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(4; 2; -1)`)  và  #mi(`B(1; -1; 2)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`)  và độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (1 - 4; -1 - 2; 2 - (-1)) = (-3; -3; 3)`) . Độ dài  #mi(`AB = |\vec{AB}| = \sqrt{(-3)^2 + (-3)^2 + 3^2} = \sqrt{9 + 9 + 9} = \sqrt{27} = 3\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính cosin góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (-2; 2; 2)`)  và  #mi(`\vec{b} = (1; -1; -2)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{a} \cdot \vec{b} = (-2)(1) + (2)(-1) + (2)(-2) = -2 - 2 - 4 = -8`) . Độ dài  #mi(`|\vec{a}| = \sqrt{(-2)^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{1^2 + (-1)^2 + (-2)^2} = \sqrt{6}`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}||\vec{b}|} = \frac{-8}{2\sqrt{3} \cdot \sqrt{6}} = \frac{-8}{2\sqrt{18}} = \frac{-8}{6\sqrt{2}} = -\frac{4}{3\sqrt{2}} = -\frac{2\sqrt{2}}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{1+3+2}{3} = 2`) ;  #mi(`y_G = \frac{2+2-1}{3} = 1`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(0; 1; 2)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(4; 5; 6)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{0+2+4}{3} = 2`) ;  #mi(`y_G = \frac{1+3+5}{3} = 3`) ;  #mi(`z_G = \frac{2+4+6}{3} = 4`) . Vậy  #mi(`G(2; 3; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 4; -1)`) ,  #mi(`B(0; 2; 3)`)  và  #mi(`C(1; 0; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{2+0+1}{3} = 1`) ;  #mi(`y_G = \frac{4+2+0}{3} = 2`) ;  #mi(`z_G = \frac{-1+3+5}{3} = 7/3`) . Vậy  #mi(`G(1; 2; 7/3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 2; 2)`)  và trọng tâm  #mi(`G(2; 2; 2)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_C = 3(2) - 1 - 2 = 3`) ;  #mi(`y_C = 3(2) - 1 - 2 = 3`) ;  #mi(`z_C = 3(2) - 1 - 2 = 3`) . Vậy  #mi(`C(3; 3; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 17: Mô hình hóa thực tiễn bằng hệ tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 17. Mô hình hóa thực tiễn bằng hệ tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để mô hình hóa thực tế, ta chọn gốc tọa độ  #mi(`O`)  và các trục  #mi(`Ox, Oy, Oz`)  sao cho các hướng chuyển động hoặc vị trí vật thể tương ứng với các trục tọa độ.
  - Tọa độ của một điểm  #mi(`M`)  trong không gian  #mi(`Oxyz`)  được biểu diễn bằng bộ ba số  #mi(`(x; y; z)`) .
  - Vectơ dịch chuyển từ  #mi(`A`)  đến  #mi(`B`)  được tính bằng  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Gốc tọa độ  #mi(`O`)  thường được chọn tại các góc phòng, điểm xuất phát hoặc vị trí đứng yên của vật thể để đơn giản hóa tính toán.
  ]
  - *Công thức cốt lõi:* Tọa độ của điểm  #mi(`M`)  khi biết vectơ dịch chuyển  #mi(`\vec{OM} = (x; y; z)`)  là  #mi(`M(..., ..., ...)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chiếc máy bay bay từ điểm  #mi(`A(0; 0; 0)`)  đến  #mi(`B(100; 200; 300)`)  trong  #mi(`1`)  giờ. Sau đó máy bay tiếp tục bay theo hướng đó trong thêm  #mi(`30`)  phút nữa. Tìm tọa độ của máy bay tại thời điểm đó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 150; 300; 450]
      \ #text(fill: rgb("#334155"))[Lời giải: Vectơ dịch chuyển trong  #mi(`1`)  giờ là  #mi(`\vec{AB} = (100 - 0; 200 - 0; 300 - 0) = (100; 200; 300)`) . Trong  #mi(`30`)  phút ( #mi(`0,5`)  giờ), vectơ dịch chuyển thêm là  #mi(`\vec{BC} = 0,5 \cdot \vec{AB} = (50; 100; 150)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (100 + 50; 200 + 100; 300 + 150) = (150; 300; 450)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chiếc đèn treo cách trần nhà  #mi(`0,5`)  m, cách hai bức tường vuông góc nhau một khoảng lần lượt là  #mi(`1,2`)  m và  #mi(`1,6`)  m. Nếu chọn gốc tọa độ  #mi(`O`)  tại góc sàn nhà nơi hai bức tường gặp nhau, hãy xác định tọa độ của bóng đèn.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1,2; 1,6; 0,5]
      \ #text(fill: rgb("#334155"))[Lời giải: Chọn trục  #mi(`Ox`)  dọc theo bức tường thứ nhất,  #mi(`Oy`)  dọc theo bức tường thứ hai, và  #mi(`Oz`)  hướng lên trên. Tọa độ của đèn theo phương  #mi(`Ox`)  là  #mi(`1,2`) ; theo phương  #mi(`Oy`)  là  #mi(`1,6`) . Vì đèn cách trần nhà  #mi(`0,5`)  m, nếu gọi chiều cao phòng là  #mi(`H`) , thì tọa độ  #mi(`z`)  là  #mi(`H - 0,5`) . Tuy nhiên, nếu xét theo mô hình chuẩn trong tài liệu, ta coi tọa độ  #mi(`z`)  là khoảng cách từ sàn đến đèn. Giả sử đèn ở độ cao  #mi(`0,5`)  m so với sàn (theo cách hiểu khác), tọa độ sẽ là  #mi(`(1,2; 1,6; 0,5)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Mô hình chuyển động máy bay:] Một chiếc máy bay bay từ điểm  #mi(`A(800; 500; 7)`)  đến điểm  #mi(`B(940; 550; 8)`)  trong  #mi(`10`)  phút. Nếu máy bay tiếp tục giữ nguyên vận tốc và hướng bay, hãy tìm tọa độ của máy bay sau  #mi(`5`)  phút tiếp theo.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ dịch chuyển trong  #mi(`10`)  phút là  #mi(`\vec{AB} = (940 - 800; 550 - 500; 8 - 7) = (140; 50; 1)`) . Trong  #mi(`5`)  phút tiếp theo, vectơ dịch chuyển thêm là  #mi(`\vec{BC} = \frac{5}{10} \cdot \vec{AB} = 0,5 \cdot (140; 50; 1) = (70; 25; 0,5)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (940 + 70; 550 + 25; 8 + 0,5) = (1010; 575; 8,5)`) . Vậy tọa độ máy bay là  #mi(`(1010; 575; 8,5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Mô hình vật thể trong phòng:] Một chiếc đèn được treo trong phòng hình hộp chữ nhật. Đèn cách trần nhà  #mi(`0,5`)  m, cách hai bức tường vuông góc nhau lần lượt là  #mi(`1,2`)  m và  #mi(`1,6`)  m. Hãy lập hệ tọa độ  #mi(`Oxyz`)  với gốc  #mi(`O`)  tại góc sàn nhà và xác định tọa độ của đèn.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chọn trục  #mi(`Ox`)  nằm trên bức tường thứ nhất,  #mi(`Oy`)  nằm trên bức tường thứ hai, và  #mi(`Oz`)  hướng lên trên. Khoảng cách từ đèn đến hai bức tường tương ứng với tọa độ  #mi(`x`)  và  #mi(`y`) . Tọa độ  #mi(`x = 1,2`) ;  #mi(`y = 1,6`) . Khoảng cách từ đèn đến sàn nhà (trục  #mi(`Oz`) ) là  #mi(`z`) . Nếu đèn cách trần  #mi(`0,5`)  m và chiều cao phòng là  #mi(`H`) , thì  #mi(`z = H - 0,5`) . Trong các bài toán mô hình hóa đơn giản, nếu đề bài chỉ cho các khoảng cách từ các mặt phẳng tọa độ, ta có tọa độ là  #mi(`(1,2; 1,6; 0,5)`)  (với  #mi(`0,5`)  là độ cao so với sàn).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Mô hình khinh khí cầu:] Hai chiếc khinh khí cầu có tọa độ lần lượt là  #mi(`A(2; 1; 0,5)`)  và  #mi(`B(-1; -1,5; 0,8)`)  (đơn vị: km). Tính khoảng cách giữa hai chiếc khinh khí cầu.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ  #mi(`\vec{AB} = (-1 - 2; -1,5 - 1; 0,8 - 0,5) = (-3; -2,5; 0,3)`) . Độ dài đoạn thẳng  #mi(`AB`)  là  #mi(`|\vec{AB}| = \sqrt{(-3)^2 + (-2,5)^2 + 0,3^2} = \sqrt{9 + 6,25 + 0,09} = \sqrt{15,34} \approx 3,92`)  (km).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Mô hình lực tác động:] Một chiếc máy bay đang bay với vận tốc  #mi(`900`)  km/h. Sau đó tăng tốc lên  #mi(`920`)  km/h theo cùng một hướng. Hãy biểu diễn sự thay đổi vận tốc bằng vectơ trong hệ tọa độ  #mi(`Oxyz`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{v_1}`)  là vectơ vận tốc khi bay  #mi(`900`)  km/h và  #mi(`\vec{v_2}`)  là vectơ vận tốc khi bay  #mi(`920`)  km/h. Vì máy bay giữ nguyên hướng, hai vectơ này cùng phương và cùng hướng. Do đó  #mi(`\vec{v_2} = k \vec{v_1}`)  với  #mi(`k = \frac{920}{900} \approx 1,02`) . Nếu chọn hướng bay dọc theo trục  #mi(`Ox`) , thì  #mi(`\vec{v_1} = (900; 0; 0)`)  và  #mi(`\vec{v_2} = (920; 0; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một chiếc máy bay bay từ điểm  #mi(`A(10; 20; 30)`)  đến  #mi(`B(20; 40; 60)`)  trong  #mi(`2`)  giờ. Sau đó máy bay tiếp tục bay theo hướng đó trong thêm  #mi(`1`)  giờ nữa. Tìm tọa độ của máy bay tại thời điểm đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong  #mi(`2`)  giờ là  #mi(`\vec{AB} = (20 - 10; 40 - 20; 60 - 30) = (10; 20; 30)`) . Trong  #mi(`1`)  giờ, vectơ dịch chuyển thêm là  #mi(`\vec{BC} = \frac{1}{2} \cdot \vec{AB} = (5; 10; 15)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (20 + 5; 40 + 10; 60 + 15) = (25; 50; 75)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một chiếc máy bay bay từ điểm  #mi(`A(5; 5; 5)`)  đến  #mi(`B(15; 15; 15)`)  trong  #mi(`10`)  phút. Sau đó máy bay tiếp tục bay theo hướng đó trong thêm  #mi(`5`)  phút nữa. Tìm tọa độ của máy bay tại thời điểm đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong  #mi(`10`)  phút là  #mi(`\vec{AB} = (15 - 5; 15 - 5; 15 - 5) = (10; 10; 10)`) . Trong  #mi(`5`)  phút, vectơ dịch chuyển thêm là  #mi(`\vec{BC} = \frac{5}{10} \cdot \vec{AB} = (5; 5; 5)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (15 + 5; 15 + 5; 15 + 5) = (25; 25; 25)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một chiếc đèn treo trong phòng hình hộp chữ nhật. Đèn cách trần nhà  #mi(`0,4`)  m, cách hai bức tường vuông góc nhau lần lượt là  #mi(`1,5`)  m và  #mi(`2,0`)  m. Nếu chọn gốc tọa độ  #mi(`O`)  tại góc sàn nhà, hãy xác định tọa độ của đèn.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ  #mi(`x`)  là khoảng cách đến tường thứ nhất:  #mi(`x = 1,5`) . Tọa độ  #mi(`y`)  là khoảng cách đến tường thứ hai:  #mi(`y = 2,0`) . Tọa độ  #mi(`z`)  là độ cao so với sàn nhà (giả sử chiều cao phòng là  #mi(`H`) ):  #mi(`z = H - 0,4`) . Nếu xét theo mô hình chuẩn trong tài liệu, tọa độ là  #mi(`(1,5; 2,0; 0,4)`)  (với  #mi(`0,4`)  là khoảng cách từ sàn đến trần).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Hai chiếc khinh khí cầu có tọa độ  #mi(`A(0; 0; 0)`)  và  #mi(`B(2; 4; 6)`) . Tính khoảng cách giữa hai chiếc khinh khí cầu.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ  #mi(`\vec{AB} = (2 - 0; 4 - 0; 6 - 0) = (2; 4; 6)`) . Khoảng cách là  #mi(`|\vec{AB}| = \sqrt{2^2 + 4^2 + 6^2} = \sqrt{4 + 16 + 36} = \sqrt{56} = 2\sqrt{14}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
