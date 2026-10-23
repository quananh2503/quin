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
  #text(size: 13pt, weight: "bold")[Vectơ và Hệ tọa độ trong không gian Oxyz] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp kiến thức toàn diện về vectơ trong không gian 3 chiều, bao gồm các khái niệm cơ bản (độ dài, giá, vectơ cùng phương, bằng nhau), các phép toán vectơ (cộng, trừ, nhân với một số), các quy tắc đặc biệt (hình bình hành, hình hộp, trung điểm, trọng tâm), và hệ tọa độ Oxyz. Nội dung bao gồm cả phương pháp hình học thuần túy và phương pháp tọa độ để giải quyết các bài toán về biểu diễn vectơ, tính toán độ dài, góc, tích vô hướng và các bài toán ứng dụng thực tế.]
]
#v(6pt)

// ==================== DẠNG 1: Xác định vectơ, độ dài vectơ và vectơ bằng nhau trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Xác định vectơ, độ dài vectơ và vectơ bằng nhau trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vectơ trong không gian là một đoạn thẳng có hướng. Hai vectơ được gọi là bằng nhau nếu chúng cùng hướng và cùng độ dài.
  - Độ dài (hay độ lớn) của vectơ  #mi(`\vec{AB}`)  là khoảng cách giữa điểm đầu  #mi(`A`)  và điểm cuối  #mi(`B`) , kí hiệu là  #mi(`|\vec{AB}| = AB`) .
  - Giá của vectơ là đường thẳng đi qua điểm đầu và điểm cuối của vectơ đó.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn hai vectơ bằng nhau: Phải 'Cùng hướng' + 'Cùng độ dài'. Thiếu một trong hai là không bằng nhau!
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi  #mi(`\vec{a} = \vec{b}`)  và  #mi(`|\vec{a}| = |\vec{b}|`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`5`)  cm. Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có tất cả  #mi(`3`)  vectơ.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương cạnh  #mi(`2`)  nên độ dài đoạn thẳng  #mi(`AB = 2`) . Do đó,  #mi(`|\vec{AB}| = AB = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Trong không gian, cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có cùng hướng và cùng độ dài bằng  #mi(`4`) . Hỏi  #mi(`\vec{a}`)  có bằng  #mi(`\vec{b}`)  không?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: Có]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  cùng hướng và cùng độ dài ( #mi(`|\vec{a}| = |\vec{b}| = 4`) ), nên theo định nghĩa,  #mi(`\vec{a} = \vec{b}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Đếm số lượng vectơ từ một đỉnh:] Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . a) Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện? b) Trong các vectơ tìm được ở câu a, những vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABC)`) ?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) . Vậy có  #mi(`3`)  vectơ.\nb) Trong các vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) , chỉ có  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  có giá nằm trong mặt phẳng  #mi(`(ABC)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định vectơ bằng nhau trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Hãy xác định các vectơ bằng với vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong hình lập phương  #mi(`ABCD.A'B'C'D'`) , các vectơ cùng hướng và cùng độ dài với  #mi(`\vec{AB}`)  là:  #mi(`\vec{DC}`) ,  #mi(`\vec{A'D'}`) ,  #mi(`\vec{B'C'}`) . (Lưu ý:  #mi(`\vec{DC}`)  cùng hướng và bằng  #mi(`\vec{AB}`)  vì  #mi(`ABCD`)  là hình bình hành).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài vectơ:] Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA=3, SB=4, SC=5`)  và  #mi(`SA, SB, SC`)  đôi một vuông góc. Tính độ dài của vectơ  #mi(`\vec{SA}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Độ dài của vectơ  #mi(`\vec{SA}`)  là độ dài đoạn thẳng  #mi(`SA`) . Theo giả thiết  #mi(`SA=3`) , vậy  #mi(`|\vec{SA}| = 3`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`a`) . Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`B`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là  #mi(`B`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{BA}`) ,  #mi(`\vec{BC}`) ,  #mi(`\vec{BD}`) . Vậy có  #mi(`3`)  vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`2`)  cm. Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`C`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ có điểm đầu là  #mi(`C`)  và điểm cuối là các đỉnh còn lại gồm:  #mi(`\vec{CA}`) ,  #mi(`\vec{CB}`) ,  #mi(`\vec{CD}`) . Vậy có  #mi(`3`)  vectơ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`3`) . Trong các vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`) ,  #mi(`\vec{AD'}`) , vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABCD)`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AC}`) ,  #mi(`\vec{AD}`)  đều có điểm đầu và điểm cuối nằm trên các cạnh hoặc đường chéo của đáy  #mi(`ABCD`) , nên giá của chúng nằm trong mặt phẳng  #mi(`(ABCD)`) . Vectơ  #mi(`\vec{AD'}`)  có điểm cuối  #mi(`D'`)  không nằm trong  #mi(`(ABCD)`) , nên giá của nó không nằm trong  #mi(`(ABCD)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy chỉ ra một vectơ bằng với vectơ  #mi(`\vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình hộp, các cạnh bên song song và bằng nhau, nên  #mi(`\vec{AA'} = \vec{BB'} = \vec{CC'} = \vec{DD'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Cho hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  có cùng hướng và cùng độ dài bằng  #mi(`10`) . Hỏi  #mi(`\vec{u}`)  có bằng  #mi(`\vec{v}`)  không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  cùng hướng và cùng độ dài ( #mi(`|\vec{u}| = |\vec{v}| = 10`) ), nên theo định nghĩa,  #mi(`\vec{u} = \vec{v}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Quy tắc cộng, trừ vectơ cơ bản ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Quy tắc cộng, trừ vectơ cơ bản]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc cộng nối tiếp (quy tắc ba điểm):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) 
  - Quy tắc hiệu (chung gốc lộn ngược):  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cộng thì nối đuôi (điểm cuối vectơ này là điểm đầu vectơ kia), trừ thì chung gốc lộn ngược (cùng điểm đầu, kết quả là vectơ nối từ điểm cuối vectơ bị trừ đến điểm cuối vectơ trừ).
  ]
  - *Công thức cốt lõi:* Trong không gian, với ba điểm  #mi(`A, B, C`)  bất kì, ta luôn có  #mi(`\vec{AB} + \vec{BC} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho ba điểm  #mi(`A, B, C`)  thẳng hàng theo thứ tự đó. Rút gọn biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CA}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng quy tắc cộng nối tiếp:  #mi(`P = (\vec{AB} + \vec{BC}) + \vec{CA} = \vec{AC} + \vec{CA}`) . Vì  #mi(`\vec{AC}`)  và  #mi(`\vec{CA}`)  là hai vectơ đối nhau nên  #mi(`P = \vec{0}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho các vectơ  #mi(`\vec{a}, \vec{b}`) . Tính giá trị của biểu thức  #mi(`Q = \vec{a} - (\vec{a} + \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -b]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng quy tắc hiệu hoặc tính chất phân phối:  #mi(`Q = \vec{a} - \vec{a} - \vec{b} = \vec{0} - \vec{b} = -\vec{b}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc ba điểm:] Cho bốn điểm  #mi(`A, B, C, D`)  trong không gian. Rút gọn biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc cộng nối tiếp (quy tắc ba điểm) liên tiếp:  #mi(`P = (\vec{AB} + \vec{BC}) + \vec{CD} = \vec{AC} + \vec{CD} = \vec{AD}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hiệu:] Cho ba điểm  #mi(`O, A, B`)  bất kì. Rút gọn biểu thức  #mi(`Q = \vec{OA} - \vec{OB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hiệu (chung gốc  #mi(`O`) ):  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Chứng minh đẳng thức vectơ:] Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AD} = \vec{BC}`) . Thay vào vế trái, ta có:  #mi(`VT = \vec{AB} + \vec{AD} = \vec{AB} + \vec{BC}`) . Theo quy tắc cộng nối tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC} = VP`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Rút gọn biểu thức  #mi(`P = \vec{MN} + \vec{NP} + \vec{PQ}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`P = (\vec{MN} + \vec{NP}) + \vec{PQ} = \vec{MP} + \vec{PQ} = \vec{MQ}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Rút gọn biểu thức  #mi(`Q = \vec{XY} + \vec{YZ} + \vec`) Z #mi(`X`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`Q = (\vec{XY} + \vec{YZ}) + \vec{ZX} = \vec{XZ} + \vec{ZX} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho ba điểm  #mi(`O, M, N`)  bất kì. Rút gọn biểu thức  #mi(`R = \vec{OM} - \vec{ON}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hiệu:  #mi(`R = \vec{OM} - \vec{ON} = \vec{NM}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình bình hành  #mi(`ABCD`) . Rút gọn biểu thức  #mi(`S = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`S = (\vec{AB} + \vec{BC}) + (\vec{CD} + \vec{DA}) = \vec{AC} + \vec{CA} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Cho các vectơ  #mi(`\vec{a}, \vec{b}`) . Chứng minh rằng  #mi(`\vec{a} - \vec{b} + \vec{b} - \vec{a} = \vec{0}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`VT = (\vec{a} - \vec{b}) + (\vec{b} - \vec{a}) = \vec{a} - \vec{a} + \vec{b} - \vec{b} = \vec{0} = VP`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Quy tắc hình bình hành, hình hộp và phân tích vectơ theo hệ cơ sở ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Quy tắc hình bình hành, hình hộp và phân tích vectơ theo hệ cơ sở]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc hình hộp: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ cạnh xuất phát từ cùng một đỉnh bằng vectơ đường chéo chính xuất phát từ đỉnh đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  - Phân tích vectơ: Mọi vectơ trong không gian đều có thể biểu diễn duy nhất qua ba vectơ không đồng phẳng  #mi(`\vec{a}, \vec{b}, \vec{c}`)  dưới dạng  #mi(`\vec{x} = m\vec{a} + n\vec{b} + p\vec{c}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm đường chéo chính của hình hộp, hãy cộng 3 vectơ cạnh xuất phát từ cùng một đỉnh!
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo chính của hình lập phương. Với cạnh  #mi(`a=2`) , độ dài đường chéo chính là  #mi(`a\sqrt{3} = 2\sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình bình hành  #mi(`ABCD`) . Tính giá trị của biểu thức  #mi(`P = |\vec{AB} + \vec{AD}|`) . Biết  #mi(`AB = 3`)  và  #mi(`AD = 4`) , góc  #mi(`\widehat{BAD} = 90^\circ`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình bình hành,  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Do đó  #mi(`P = |\vec{AC}| = AC`) . Vì  #mi(`\widehat{BAD} = 90^\circ`)  nên tam giác  #mi(`ABC`)  vuông tại  #mi(`B`)  (do  #mi(`ABCD`)  là hình bình hành,  #mi(`BC=AD=4`) ). Áp dụng định lý Pythagore:  #mi(`AC = \sqrt{AB^2 + BC^2} = \sqrt{3^2 + 4^2} = \sqrt{25} = 5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành trên mặt đáy  #mi(`ABCD`) ). Tiếp theo, áp dụng quy tắc cộng nối tiếp (quy tắc 3 điểm):  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`) . Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính độ dài vectơ trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp,  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{v}`)  là độ dài đường chéo chính  #mi(`AC'`) . Trong hình lập phương cạnh  #mi(`a`) , ta có  #mi(`AC' = \sqrt{a^2 + a^2 + a^2} = a\sqrt{3}`) . Vậy  #mi(`|\vec{v}| = a\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Phân tích vectơ trong hình chóp:] Cho hình chóp  #mi(`S.ABC`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`SA`) . Hãy phân tích vectơ  #mi(`\vec{SM}`)  theo các vectơ  #mi(`\vec{SA}`) ,  #mi(`\vec{SB}`) ,  #mi(`\vec{SC}`)  (nếu có thể) hoặc chỉ ra mối liên hệ với  #mi(`\vec{SA}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`SA`)  nên  #mi(`\vec{SM} = \frac{1}{2}\vec{SA}`) . Đây là một dạng phân tích vectơ đơn giản dựa trên tỉ lệ độ dài và hướng.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh đẳng thức:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình bình hành cho đáy  #mi(`ABCD`) :  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Áp dụng quy tắc cộng nối tiếp:  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`) . Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài đường chéo chính của hình lập phương cạnh  #mi(`1`)  là  #mi(`AC' = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) . Vậy  #mi(`|\vec{u}| = \sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo định nghĩa quy tắc hình bình hành trong không gian, nếu  #mi(`ABCD`)  là hình bình hành thì tổng hai vectơ cạnh xuất phát từ cùng một đỉnh bằng vectơ đường chéo xuất phát từ đỉnh đó. Vậy  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Cho biết  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{v}`) . Hãy biểu diễn vectơ  #mi(`\vec{AC}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên theo quy tắc hình bình hành, ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Cho hình chóp  #mi(`S.ABC`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`SA`) . Hãy biểu diễn vectơ  #mi(`\vec{AM}`)  theo vectơ  #mi(`\vec{AS}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`M`)  là trung điểm của  #mi(`SA`)  nên  #mi(`\vec{AM} = \frac{1}{2}\vec{AS}`)  (hoặc  #mi(`\vec{AM} = -\frac{1}{2}\vec{SA}`)  tùy theo hướng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Tọa độ của điểm, vectơ và các phép toán cơ bản trong hệ tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Tọa độ của điểm, vectơ và các phép toán cơ bản trong hệ tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`)  là  #mi(`M\big(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\big)`) .
  - Cho tam giác  #mi(`ABC`)  có  #mi(`A(x_A; y_A; z_A)`) ,  #mi(`B(x_B; y_B; z_B)`) ,  #mi(`C(x_C; y_C; z_C)`) , tọa độ trọng tâm  #mi(`G`)  là  #mi(`G\big(\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3}\big)`) .
  - Cho  #mi(`\vec{a}=(x_1; y_1; z_1)`)  và  #mi(`\vec{b}=(x_2; y_2; z_2)`) , ta có  #mi(`\vec{a} + \vec{b} = (x_1+x_2; y_1+y_2; z_1+z_2)`)  và  #mi(`k\vec{a} = (kx_1; ky_1; kz_1)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Trung điểm là 'chia đôi tổng', trọng tâm là 'chia ba tổng'.
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`\vec{AB} = (\dots; \dots; \dots)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2;3;4]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`)  là:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+4}{2} = 3`) ;  #mi(`z_M = \frac{3+5}{2} = 4`) . Vậy  #mi(`M(2; 3; 4)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{a} = (1; -2; 3)`)  và  #mi(`\vec{b} = (4; 0; -1)`) . Tính tọa độ vectơ  #mi(`\vec{c} = 2\vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6;-4;5]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`2\vec{a} = (2\cdot 1; 2\cdot(-2); 2\cdot 3) = (2; -4; 6)`) . Tọa độ  #mi(`\vec{c} = (2+4; -4+0; 6+(-1)) = (6; -4; 5)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức trung điểm:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(2; 0; 6)`)  và  #mi(`B(4; -2; 10)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`)  là:  #mi(`M\big(\frac{2+4}{2}; \frac{0+(-2)}{2}; \frac{6+10}{2}\big) = M(3; -1; 8)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức trọng tâm:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 1)`) ,  #mi(`B(0; -3; 1)`)  và  #mi(`C(4; -1; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là:  #mi(`G\big(\frac{1+0+4}{3}; \frac{0+(-3)+(-1)}{3}; \frac{1+1+4}{3}\big) = G(5/3; -4/3; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Phép cộng và nhân vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (2; 1; -3)`)  và  #mi(`\vec{v} = (-1; 4; 5)`) . Tính tọa độ của  #mi(`\vec{w} = 3\vec{u} - 2\vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`3\vec{u} = (6; 3; -9)`) ;  #mi(`2\vec{v} = (-2; 8; 10)`) . Tọa độ  #mi(`\vec{w} = (6-(-2); 3-8; -9-10) = (8; -5; -19)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho  #mi(`A(1; 1; 1)`)  và  #mi(`B(5; 3; 7)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`M\big(\frac{1+5}{2}; \frac{1+3}{2}; \frac{1+7}{2}\big) = M(3; 2; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho  #mi(`A(0; 4; -2)`)  và  #mi(`B(6; 0; 2)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`M\big(\frac{0+6}{2}; \frac{4+0}{2}; \frac{-2+2}{2}\big) = M(3; 2; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 2; 2)`) ,  #mi(`B(4; 0; 6)`)  và  #mi(`C(0; 4; 1)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`G\big(\frac{2+4+0}{3}; \frac{2+0+4}{3}; \frac{2+6+1}{3}\big) = G(2; 2; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho  #mi(`\vec{a} = (3; -1; 2)`)  và  #mi(`\vec{b} = (1; 5; -4)`) . Tính tọa độ vectơ  #mi(`\vec{c} = \vec{a} - 2\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`2\vec{b} = (2; 10; -8)`) . Tọa độ  #mi(`\vec{c} = (3-2; -1-10; 2-(-8)) = (1; -11; 10)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có  #mi(`G(1; 1; 1)`)  là trọng tâm và  #mi(`A(0; 0; 0)`) ,  #mi(`B(2; 2; 2)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm nên  #mi(`x_G = \frac{x_A+x_B+x_C}{3} \Rightarrow 1 = \frac{0+2+x_C}{3} \Rightarrow x_C = 1`) . Tương tự  #mi(`y_C = 1, z_C = 1`) . Vậy  #mi(`C(1; 1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Tích vô hướng và góc giữa hai vectơ trong hệ tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Tích vô hướng và góc giữa hai vectơ trong hệ tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a} = (x_1; y_1; z_1)`)  và  #mi(`\vec{b} = (x_2; y_2; z_2)`)  được tính bởi công thức:  #mi(`\vec{a}.\vec{b} = x_1x_2 + y_1y_2 + z_1z_2`) .
  - Góc  #mi(`\theta`)  giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\b`)  được xác định qua công thức:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a}.\vec{b}}{|\vec{a}|.|\vec{b}|}`)  với  #mi(`|\vec{a}| = \sqrt{x_1^2 + y_1^2 + z_1^2}`) .
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng  #mi(`0`) , tức là  #mi(`\vec{a}.\vec{b} = 0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để chứng minh vuông góc, hãy 'triệt tiêu' tích vô hướng về  #mi(`0`) . Để tính góc, hãy nhớ 'Tích chia cho Tích độ dài'.
  ]
  - *Công thức cốt lõi:* Công thức tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\cos(\vec{a}, \vec{b}) = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a}=(1; 2; -2)`)  và  #mi(`\vec{b}=(3; 0; 4)`) . Tính tích vô hướng  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{a}.\vec{b} = 1.3 + 2.0 + (-2).4 = 3 + 0 - 8 = -5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u}=(1; 1; 1)`)  và  #mi(`\vec{v}=(1; -1; 0)`) . Tính  #mi(`\cos(\vec{u}, \vec{v})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{u}.\vec{v} = 1.1 + 1.(-1) + 1.0 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\cos(\vec{u}, \vec{v}) = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức tích vô hướng cơ bản:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a}=(2; -1; 3)`)  và  #mi(`\vec{b}=(4; 2; -2)`) . Tính  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tích vô hướng:  #mi(`\vec{a}.\vec{b} = x_1x_2 + y_1y_2 + z_1z_2`) . Ta có:  #mi(`\vec{a}.\vec{b} = 2.4 + (-1).2 + 3.(-2) = 8 - 2 - 6 = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(1; 1; 0)`)  và  #mi(`\vec{v}=(0; 1; 1)`) . Tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tính tích vô hướng:  #mi(`\vec{u}.\vec{v} = 1.0 + 1.1 + 0.1 = 1`) . 2. Tính độ dài  #mi(`\vec{u}`) :  #mi(`|\vec{u}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) . 3. Tính độ dài  #mi(`\vec{v}`) :  #mi(`|\vec{v}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . 4. Tính  #mi(`\cos(\vec{u}, \vec{v}) = \frac{1}{\sqrt{2}.\sqrt{2}} = \frac{1}{2}`) . 5. Suy ra góc  #mi(`(\vec{u}, \vec{v}) = 60^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Chứng minh hai vectơ vuông góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(x; 2; 1)`)  và  #mi(`\vec{b}=(1; -1; 2)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}.\vec{b} = 0`) . Ta có:  #mi(`\vec{a}.\vec{b} = x.1 + 2.(-1) + 1.2 = x - 2 + 2 = x`) . Để  #mi(`\vec{a}.\vec{b} = 0`)  thì  #mi(`x = 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(3; 4; 0)`)  và  #mi(`\vec{b}=(1; -2; 5)`) . Tính  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a}.\vec{b} = 3.1 + 4.(-2) + 0.5 = 3 - 8 + 0 = -5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(2; 2; 1)`)  và  #mi(`\vec{v}=(4; -1; 2)`) . Tính  #mi(`\vec{u}.\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u}.\vec{v} = 2.4 + 2.(-1) + 1.2 = 8 - 2 + 2 = 8`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(1; 0; 1)`)  và  #mi(`\vec{b}=(0; 1; 1)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1.  #mi(`\vec{a}.\vec{b} = 1.0 + 0.1 + 1.1 = 1`) . 2.  #mi(`|\vec{a}| = \sqrt{1^2+0^2+1^2} = \sqrt{2}`) . 3.  #mi(`|\vec{b}| = \sqrt{0^2+1^2+1^2} = \sqrt{2}`) . 4.  #mi(`\cos(\vec{a}, \vec{b}) = \frac{1}{\sqrt{2}.\sqrt{2}} = \frac{1}{2} \Rightarrow (\vec{a}, \vec{b}) = 60^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}=(2; 1; -1)`)  và  #mi(`\vec{b}=(x; 1; 3)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a}.\vec{b} = 0`) . Ta có:  #mi(`\vec{a}.\vec{b} = 2.x + 1.1 + (-1).3 = 2x + 1 - 3 = 2x - 2`) . Để  #mi(`2x - 2 = 0`)  thì  #mi(`x = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Ứng dụng tọa độ Oxyz vào bài toán thực tế và mô hình hóa ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Ứng dụng tọa độ Oxyz vào bài toán thực tế và mô hình hóa]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để mô hình hóa một vật thể hoặc chuyển động trong không gian, ta thiết lập hệ trục tọa độ  #mi(`Oxyz`)  sao cho gốc  #mi(`O`)  là điểm mốc (ví dụ: vị trí ra đa, góc phòng, điểm xuất phát) và các trục  #mi(`Ox, Oy, Oz`)  trùng với các hướng chuyển động hoặc các cạnh của vật thể.
  - Vectơ dịch chuyển của một vật từ điểm  #mi(`A(x_A; y_A; z_A)`)  đến điểm  #mi(`B(x_B; y_B; z_B)`)  được biểu diễn bởi  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  - Khoảng cách từ gốc tọa độ  #mi(`O(0;0;0)`)  đến một điểm  #mi(`M(x; y; z)`)  được tính bằng công thức  #mi(`OM = \sqrt{x^2 + y^2 + z^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Chọn gốc tọa độ  #mi(`O`)  tại điểm 'tĩnh' nhất (điểm đứng yên hoặc điểm mốc) để đơn giản hóa tọa độ các thành phần khác về dạng  #mi(`0`)  hoặc các số nguyên đẹp.
  ]
  - *Công thức cốt lõi:* Vectơ dịch chuyển từ  #mi(`A(x_A; y_A; z_A)`)  đến  #mi(`B(x_B; y_B; z_B)`)  là  #mi(`\vec{AB} = (\dots; \dots; \dots)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một máy bay di chuyển từ  #mi(`A(0; 0; 0)`)  đến  #mi(`B(10; 20; 30)`)  trong  #mi(`10`)  phút. Sau  #mi(`5`)  phút tiếp theo với cùng vận tốc và hướng, tọa độ của máy bay là bao nhiêu?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 15; 30; 45]
      \ #text(fill: rgb("#334155"))[Lời giải: Vectơ dịch chuyển trong  #mi(`10`)  phút là  #mi(`\vec{AB} = (10-0; 20-0; 30-0) = (10; 20; 30)`) . Vì thời gian bay tiếp theo là  #mi(`5`)  phút (bằng một nửa thời gian đầu), nên vectơ dịch chuyển thêm là  #mi(`\vec{v} = \frac{1}{2}\vec{AB} = (5; 10; 15)`) . Tọa độ mới là  #mi(`B + \vec{v} = (10+5; 20+10; 30+15) = (15; 30; 45)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một thiết bị ra đa đặt tại  #mi(`O(0; 0; 0)`)  có tầm quét bán kính  #mi(`R = 50`)  km. Một tàu thuyền đang ở vị trí  #mi(`M(30; 30; 20)`) . Thiết bị có phát hiện được tàu không?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: Có]
      \ #text(fill: rgb("#334155"))[Lời giải: Khoảng cách từ ra đa đến tàu là  #mi(`OM = \sqrt{30^2 + 30^2 + 20^2} = \sqrt{900 + 900 + 400} = \sqrt{2200} \approx 46.9`)  km. Vì  #mi(`46.9 < 50`)  nên thiết bị có phát hiện được tàu.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Mô hình hóa chuyển động máy bay:] Một chiếc máy bay di chuyển từ điểm  #mi(`A(800; 500; 7)`)  đến điểm  #mi(`B(940; 550; 8)`)  trong  #mi(`10`)  phút. Nếu máy bay tiếp tục giữ nguyên vận tốc và hướng bay, hãy xác định tọa độ của máy bay sau  #mi(`5`)  phút tiếp theo kể từ khi đến  #mi(`B`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ dịch chuyển trong  #mi(`10`)  phút là  #mi(`\vec{AB} = (940-800; 550-500; 8-7) = (140; 50; 1)`) . Vì thời gian bay thêm là  #mi(`5`)  phút, tức bằng  #mi(`1/2`)  thời gian ban đầu, nên vectơ dịch chuyển thêm là  #mi(`\vec{v} = \frac{1}{2}\vec{AB} = (70; 25; 0.5)`) . Tọa độ của máy bay sau  #mi(`5`)  phút tiếp theo là  #mi(`B + \vec{v} = (940+70; 550+25; 8+0.5) = (1010; 575; 8.5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Mô hình hóa tầm quét ra đa:] Một trạm quan sát đặt tại gốc tọa độ  #mi(`O(0; 0; 0)`)  có tầm quan sát bán kính  #mi(`R = 30`)  km. Một vật thể lạ được phát hiện tại tọa độ  #mi(`M(25; 15; -10)`) . Vật thể này có nằm trong phạm vi quan sát của trạm không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách từ trạm quan sát đến vật thể là  #mi(`OM = \sqrt{25^2 + 15^2 + (-10)^2} = \sqrt{625 + 225 + 100} = \sqrt{950} \approx 30.82`)  km. Vì  #mi(`30.82 > 30`)  nên vật thể nằm ngoài phạm vi quan sát của trạm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Mô hình hóa lực trong không gian:] Một vật nặng được kéo bởi một lực  #mi(`\vec{F} = (10; 20; 0)`)  N dọc theo một đường thẳng biểu diễn bởi vectơ dịch chuyển  #mi(`\vec{s} = (5; 10; 0)`)  m. Tính công  #mi(`A`)  thực hiện bởi lực  #mi(`\vec{F}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Công  #mi(`A`)  được tính bằng tích vô hướng của lực  #mi(`\vec{F}`)  và vectơ dịch chuyển  #mi(`\vec{s}`) :  #mi(`A = \vec{F} \cdot \vec{s} = 10 \cdot 5 + 20 \cdot 10 + 0 \cdot 0 = 50 + 200 + 0 = 250`)  (J).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Một flycam di chuyển từ điểm  #mi(`A(1; 2; 3)`)  đến điểm  #mi(`B(5; 6; 7)`)  trong  #mi(`4`)  giây. Xác định tọa độ của flycam sau  #mi(`2`)  giây tiếp theo nếu nó giữ nguyên vận tốc và hướng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong  #mi(`4`)  giây là  #mi(`\vec{AB} = (5-1; 6-2; 7-3) = (4; 4; 4)`) . Vectơ dịch chuyển trong  #mi(`2`)  giây là  #mi(`\vec{v} = \frac{2}{4}\vec{AB} = \frac{1}{2}(4; 4; 4) = (2; 2; 2)`) . Tọa độ của flycam sau  #mi(`2`)  giây là  #mi(`B + \vec{v} = (5+2; 6+2; 7+2) = (7; 8; 9)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Một tàu ngầm di chuyển từ  #mi(`A(10; -5; -20)`)  đến  #mi(`B(20; 5; -10)`)  trong  #mi(`20`)  phút. Sau  #mi(`10`)  phút tiếp theo với cùng vận tốc và hướng, tọa độ của tàu ngầm là bao nhiêu?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong  #mi(`20`)  phút là  #mi(`\vec{AB} = (20-10; 5-(-5); -10-(-20)) = (10; 10; 10)`) . Vectơ dịch chuyển trong  #mi(`10`)  phút là  #mi(`\vec{v} = \frac{10}{20}\vec{AB} = (5; 5; 5)`) . Tọa độ của tàu ngầm là  #mi(`B + \vec{v} = (20+5; 5+5; -10+5) = (25; 10; -5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Một trạm radar đặt tại  #mi(`O(0; 0; 0)`)  có tầm quét bán kính  #mi(`R = 100`)  km. Một máy bay đang ở tọa độ  #mi(`M(60; 40; 70)`) . Máy bay có nằm trong tầm quét không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách từ radar đến máy bay là  #mi(`OM = \sqrt{60^2 + 40^2 + 70^2} = \sqrt{3600 + 1600 + 4900} = \sqrt{10100} \approx 100.5`)  km. Vì  #mi(`100.5 > 100`)  nên máy bay nằm ngoài tầm quét.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Một robot di chuyển từ  #mi(`A(2; 2; 2)`)  đến  #mi(`B(4; 4; 4)`)  trong  #mi(`1`)  phút. Sau  #mi(`3`)  phút tiếp theo với cùng vận tốc và hướng, tọa độ của robot là bao nhiêu?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong  #mi(`1`)  phút là  #mi(`\vec{AB} = (2; 2; 2)`) . Vectơ dịch chuyển trong  #mi(`3`)  phút là  #mi(`\vec{v} = 3 \cdot \vec{AB} = (6; 6; 6)`) . Tọa độ của robot là  #mi(`B + \vec{v} = (4+6; 4+6; 4+6) = (10; 10; 10)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Một lực  #mi(`\vec{F} = (5; -2; 4)`)  N tác dụng lên một vật làm nó dịch chuyển một đoạn  #mi(`\vec{s} = (2; 3; 0)`)  m. Tính công  #mi(`A`)  thực hiện bởi lực  #mi(`\vec{F}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Công  #mi(`A = \vec{F} \cdot \vec{s} = 5 \cdot 2 + (-2) \cdot 3 + 4 \cdot 0 = 10 - 6 + 0 = 4`)  (J).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
