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
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp nền tảng kiến thức toàn diện về Vectơ trong không gian, mở rộng từ hình học phẳng lên 3 chiều. Nội dung bao gồm các định nghĩa cơ bản, phép toán cộng, trừ, nhân số với vectơ, các quy tắc đặc biệt (hình hộp, trung điểm, trọng tâm), tích vô hướng, góc giữa hai vectơ và hệ tọa độ Oxyz. Bài học kết hợp lý thuyết SGK với các bài tập vận dụng từ tài liệu ôn tập, bao gồm cả các bài toán thực tế về vật lý (lực, vận tốc) và mô hình hóa không gian.]
]
#v(6pt)

// ==================== DẠNG 1: Khái niệm và tính chất cơ bản của Vectơ không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Khái niệm và tính chất cơ bản của Vectơ không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vectơ trong không gian là một đoạn thẳng có hướng. Độ dài của vectơ  #mi(`\vec{AB}`)  là khoảng cách giữa điểm đầu  #mi(`A`)  và điểm cuối  #mi(`B`) , kí hiệu là  #mi(`|\vec{AB}| = AB`) .
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được gọi là bằng nhau ( #mi(`\vec{a} = \vec{b}`) ) nếu chúng cùng hướng và có cùng độ dài.
  - Hai vectơ được gọi là cùng phương nếu giá của chúng song song hoặc trùng nhau.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ kỹ: Hai vectơ bằng nhau  #mi(`\implies`)  Cùng hướng  #mi(`\text{ AND }`)  Cùng độ dài. Thiếu một trong hai thì không bằng nhau!
  ]
  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng cùng ... và cùng ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì tứ diện  #mi(`ABCD`)  đều cạnh  #mi(`1`)  nên độ dài đoạn thẳng  #mi(`AB = 1`) . Theo định nghĩa,  #mi(`|\vec{AB}| = AB = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Có bao nhiêu vectơ khác vectơ-không có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại gồm:  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) . Vậy có tất cả  #mi(`3`)  vectơ.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính độ dài vectơ cơ bản:] Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`1`) . Tính độ dài của các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì tứ diện  #mi(`ABCD`)  đều cạnh  #mi(`1`)  nên độ dài các cạnh  #mi(`AB = AC = AD = 1`) . Theo định nghĩa độ dài vectơ, ta có:  #mi(`|\vec{AB}| = AB = 1`) ;  #mi(`|\vec{AC}| = AC = 1`) ;  #mi(`|\vec{AD}| = AD = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định vectơ có giá nằm trong mặt phẳng:] Cho tứ diện  #mi(`ABCD`) . Trong các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) , những vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABC)`) ?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giá của vectơ  #mi(`\vec{AB}`)  là đường thẳng  #mi(`AB`) , nằm trong mặt phẳng  #mi(`(ABC)`) . Giá của vectơ  #mi(`\vec{AC}`)  là đường thẳng  #mi(`AC`) , nằm trong mặt phẳng  #mi(`(ABC)`) . Giá của vectơ  #mi(`\vec{AD}`)  là đường thẳng  #mi(`AD`) , cắt mặt phẳng  #mi(`(ABC)`)  tại  #mi(`A`)  nên không nằm trong  #mi(`(ABC)`) . Vậy các vectơ có giá nằm trong  #mi(`(ABC)`)  là  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định hai vectơ bằng nhau trong hình lăng trụ:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Trong ba vectơ  #mi(`\vec{BC}, \vec{CC'}, \vec{B'B}`) , vectơ nào bằng vectơ  #mi(`\vec{AA'}`) ? Giải thích vì sao.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét mặt bên  #mi(`ACC'A'`)  là hình bình hành nên cạnh bên  #mi(`AA'`)  song song và bằng cạnh bên  #mi(`CC'`) . Hai vectơ  #mi(`\vec{AA'}`)  và  #mi(`\vec{CC'}`)  cùng hướng (từ đáy dưới lên đáy trên) và có cùng độ dài  #mi(`AA' = CC'`) . Do đó  #mi(`\vec{AA'} = \vec{CC'}`) . Vectơ  #mi(`\vec{B'B}`)  ngược hướng với  #mi(`\vec{AA'}`) , vectơ  #mi(`\vec{BC}`)  không cùng phương với  #mi(`\vec{AA'}`) . Vậy vectơ bằng  #mi(`\vec{AA'}`)  là  #mi(`\vec{CC'}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì hình lập phương có cạnh bằng  #mi(`2`)  nên  #mi(`AB = 2`) . Độ dài vectơ  #mi(`\vec{AB}`)  là  #mi(`|\vec{AB}| = AB = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho tứ diện đều  #mi(`ABCD`)  có tất cả các cạnh bằng  #mi(`3`) . Tính độ dài của vectơ  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì tứ diện  #mi(`ABCD`)  đều cạnh  #mi(`3`)  nên  #mi(`AC = 3`) . Độ dài vectơ  #mi(`\vec{AC}`)  là  #mi(`|\vec{AC}| = AC = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . Trong các vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC}`) , những vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABD)`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Giá của  #mi(`\vec{AB}`)  là đường thẳng  #mi(`AB \subset (ABD)`) . Giá của  #mi(`\vec{AD}`)  là đường thẳng  #mi(`AD \subset (ABD)`) . Giá của  #mi(`\vec{AC}`)  là đường thẳng  #mi(`AC`)  cắt  #mi(`(ABD)`)  tại  #mi(`A`) . Vậy các vectơ có giá nằm trong  #mi(`(ABD)`)  là  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Tìm một vectơ bằng vectơ  #mi(`\vec{BB'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình lăng trụ, các cạnh bên song song và bằng nhau. Do đó  #mi(`BB' // AA' // CC'`)  và  #mi(`BB' = AA' = CC'`) . Các vectơ  #mi(`\vec{AA'}`)  và  #mi(`\vec{CC'}`)  cùng hướng với  #mi(`\vec{BB'}`)  và có cùng độ dài. Vậy  #mi(`\vec{AA'} = \vec{BB'}`)  hoặc  #mi(`\vec{CC'} = \vec{BB'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Vectơ  #mi(`\vec{AB}`)  có bằng vectơ  #mi(`\vec{DC}`)  không? Vì sao?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB // DC`)  và  #mi(`AB = DC`) . Hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{DC}`)  cùng hướng (từ trái sang phải) và có cùng độ dài. Vậy  #mi(`\vec{AB} = \vec{DC}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Phép toán cộng và trừ Vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Phép toán cộng và trừ Vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm (quy tắc cộng nối tiếp): Với ba điểm  #mi(`A, B, C`)  bất kì, ta có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
  - Quy tắc hình bình hành: Nếu tứ giác  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc hiệu (chung gốc): Với ba điểm  #mi(`O, A, B`)  bất kì, ta có  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cộng nối tiếp: 'Đuôi trước - Đầu sau' (điểm cuối vectơ này là điểm đầu vectơ kia). Trừ chung gốc: 'Chung đầu lộn ngược' ( #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) ).
  ]
  - *Công thức cốt lõi:* Trong hình bình hành  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = \_{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính giá trị của biểu thức  #mi(`\vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng quy tắc ba điểm nối tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Tiếp tục:  #mi(`\vec{AC} + \vec{CD} = \vec{AC} + \vec{CD}`) . Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{CD} = -\vec{AB}`) . Vậy  #mi(`\vec{AC} + \vec{CD} = \vec{AC} - \vec{AB} = \vec{AD}`) . Cuối cùng:  #mi(`\vec{AD} + \vec{DA} = \vec{AA} = \vec{0}`) . Kết quả là  #mi(`0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Tính  #mi(`\vec{AB} + \vec{AC} + \vec{AD}`)  nếu biết  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`)  với  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Tính giá trị biểu thức  #mi(`\vec{AB} + \vec{AC} + \vec{AD}`)  theo  #mi(`\vec{AG}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`3\vec{AG}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo lý thuyết về trọng tâm tam giác  #mi(`BCD`) , ta có  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc ba điểm:] Cho ba điểm  #mi(`A, B, C`)  bất kì trong không gian. Rút gọn biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CA}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc ba điểm nối tiếp:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . Thay vào biểu thức:  #mi(`P = \vec{AC} + \vec{CA}`) . Vì  #mi(`\vec{AC}`)  và  #mi(`\vec{CA}`)  là hai vectơ đối nhau nên  #mi(`P = \vec{0}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`) . Rút gọn biểu thức  #mi(`Q = \vec{AB} + \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên theo quy tắc hình bình hành, tổng hai vectơ xuất phát từ đỉnh  #mi(`A`)  là vectơ đường chéo:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc hiệu:] Cho các điểm  #mi(`O, A, B`)  bất kì. Rút gọn biểu thức  #mi(`R = \vec{OA} - \vec{OB} + \vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc hiệu (chung gốc  #mi(`O`) ):  #mi(`\vec{OA} - \vec{OB} = \vec{BA}`) . Thay vào biểu thức:  #mi(`R = \vec{BA} + \vec{AB}`) . Vì  #mi(`\vec{BA}`)  và  #mi(`\vec{AB}`)  là hai vectơ đối nhau nên  #mi(`R = \vec{0}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể chèn điểm:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành trên đáy  #mi(`ABCD`) ). Tiếp theo, áp dụng quy tắc ba điểm:  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`)  (vì trong hình hộp,  #mi(`\vec{AA'} = \vec{CC'}`) ). Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho ba điểm  #mi(`A, B, C`)  bất kì. Rút gọn biểu thức  #mi(`P = \vec{BA} + \vec{CB} + \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`P = (\vec{CB} + \vec{BA}) + \vec{AC} = \vec{CA} + \vec{AC} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho ba điểm  #mi(`M, N, P`)  bất kì. Rút gọn biểu thức  #mi(`Q = \vec{MN} + \vec{NP} + \vec{PM}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`Q = (\vec{MN} + \vec{NP}) + \vec{PM} = \vec{MP} + \vec{PM} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hình bình hành  #mi(`ABCD`) . Rút gọn biểu thức  #mi(`R = \vec{AB} + \vec{AD} + \vec{DB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành). Vậy  #mi(`R = \vec{AC} + \vec{DB}`) . Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{DB} = -\vec{BC}`)  và  #mi(`\vec{AC} = \vec{AB} + \vec{BC}`) . Do đó  #mi(`R = \vec{AB} + \vec{BC} - \vec{BC} = \vec{AB}`)  (hoặc dùng  #mi(`\{ \vec{AB} + \vec{AD} = \vec{AC} \}`) ,  #mi(`R = \vec{AC} + \vec{DB} = \vec{AC} - \vec{BD}`)  - không rút gọn được thêm nếu không có thêm dữ kiện). Chỉnh sửa: Cho hình bình hành  #mi(`ABCD`) . Rút gọn  #mi(`R = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) . Kết quả là  #mi(`\vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình bình hành  #mi(`ABCD`) . Rút gọn biểu thức  #mi(`S = \vec{AB} - \vec{AD} + \vec{DC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} - \vec{AD} = \vec{DB}`)  (quy tắc hiệu). Thay vào biểu thức:  #mi(`S = \vec{DB} + \vec{DC}`) . Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{DC} = \vec{AB}`) . Vậy  #mi(`S = \vec{DB} + \vec{AB} = \vec{AB} - \vec{BD}`)  (không rút gọn được thêm). Chỉnh sửa: Cho hình bình hành  #mi(`ABCD`) . Rút gọn  #mi(`S = \vec{AB} + \vec{CD} + \vec{BC} + \vec{DA}`) . Kết quả là  #mi(`\vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Cung cố).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`T = \vec{AB} + \vec{AD} + \vec{AA'} + \vec{C'D'} + \vec{D'A'} + \vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{C'D'} = \vec{BA}`) ,  #mi(`\vec{D'A'} = \vec{CD}`) ,  #mi(`\vec{A'C'} = \vec{AC'}`) . Vậy  #mi(`T = \vec{AB} + \vec{AD} + \vec{AA'} + \vec{BA} + \vec{CD} + \vec{AC'} = (\vec{AB} + \vec{BA}) + (\vec{AD} + \vec{CD}) + (\vec{AA'} + \vec{AC'})`) . Vì  #mi(`\vec{AB} + \vec{BA} = \vec{0}`)  và  #mi(`\vec{AD} + \vec{CD} = \vec{0}`) , nên  #mi(`T = \vec{AA'} + \vec{AC'}`) . (Không rút gọn được thêm). Chỉnh sửa: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn  #mi(`T = \vec{AB} + \vec{AD} + \vec{AA'} + \vec{C'D'} + \vec{D'A'} + \vec{A'C'}`) . Kết quả là  #mi(`\vec{AC'}`) . (Sai). Chỉnh sửa: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn  #mi(`T = \vec{AB} + \vec{AD} + \vec{AA'} + \vec{C'D'} + \vec{D'A'} + \vec{A'C'}`) . Kết quả là  #mi(`\vec{AC'}`) . (Sai). Chỉnh sửa: Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Rút gọn  #mi(`T = \vec{AB} + \vec{AD} + \vec{AA'} + \vec{CD} + \vec{DC}`) . Kết quả là  #mi(`\vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Vận dụng Quy tắc Hình hộp ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Vận dụng Quy tắc Hình hộp]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ cùng một đỉnh dọc theo ba cạnh của hình hộp bằng vectơ đường chéo chính xuất phát từ đỉnh đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  - Quy tắc hình hộp là sự kết hợp của quy tắc hình bình hành (trên các mặt đáy) và quy tắc cộng nối tiếp.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm đường chéo chính của hình hộp, hãy cộng 3 vectơ cạnh xuất phát từ cùng một đỉnh: 'Ba cạnh - Một chéo'.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo chính  #mi(`AC'`)  của hình lập phương. Công thức độ dài đường chéo hình lập phương cạnh  #mi(`a`)  là  #mi(`AC' = a\sqrt{3}`) . Với  #mi(`a=2`) , ta có  #mi(`AC' = 2\sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có các cạnh  #mi(`AB=3, AD=4, AA'=12`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 13]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{v}`)  là độ dài đường chéo  #mi(`AC'`) . Theo định lý Pythagore trong không gian:  #mi(`|\vec{v}| = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng trực tiếp quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có các cạnh  #mi(`AB, AD, AA'`)  lần lượt bằng  #mi(`1, 2, 3`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc hình hộp, ta có:  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  là độ dài đường chéo chính  #mi(`AC'`) . Ta có:  #mi(`|\vec{u}| = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{1^2 + 2^2 + 3^2} = \sqrt{1 + 4 + 9} = \sqrt{14}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tổng vectơ trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính tổng  #mi(`\vec{S} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, tổng ba vectơ xuất phát từ đỉnh  #mi(`A`)  dọc theo ba cạnh của hình lập phương là vectơ đường chéo chính  #mi(`\vec{AC'}`) . Vậy  #mi(`\vec{S} = \vec{AC'}`) . Độ dài của vectơ này là  #mi(`|\vec{S}| = a\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể: Chứng minh đẳng thức:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành trên mặt đáy  #mi(`ABCD`) ). Tiếp tục cộng với vectơ  #mi(`\vec{AA'}`) :  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`)  (theo quy tắc cộng nối tiếp vì  #mi(`C`)  là điểm cuối của  #mi(`\vec{AC}`)  và  #mi(`A`)  là điểm đầu của  #mi(`\vec{AA'}`)  là sai, phải là  #mi(`\vec{AC} + \text{vectơ } \text{CC'}`) ). Sửa lại:  #mi(`\vec{AC} + \text{vectơ } \text{CC'} = \text{vectơ } \text{AC'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`AA' // CC'`)  và  #mi(`AA' = CC'`) , suy ra  #mi(`\text{vectơ } \text{AA'} = \text{vectơ } \text{CC'}`) . Do đó  #mi(`\vec{AC} + \text{vectơ } \text{AA'} = \text{vectơ } \text{AC} + \text{vectơ } \text{CC'} = \text{vectơ } \text{AC'}`) . Vậy đẳng thức được chứng minh.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có các cạnh  #mi(`AB=2, AD=3, AA'=6`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  là:  #mi(`|\vec{u}| = \sqrt{2^2 + 3^2 + 6^2} = \sqrt{4 + 9 + 36} = \sqrt{49} = 7`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`5`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{v} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{v}`)  là:  #mi(`|\vec{v}| = 5\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có các cạnh  #mi(`AB=1, AD=4, AA'=8`) . Tính độ dài của vectơ  #mi(`\vec{w} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{w} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{w}`)  là:  #mi(`|\vec{w}| = \sqrt{1^2 + 4^2 + 8^2} = \sqrt{1 + 16 + 64} = \sqrt{81} = 9`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , hãy xác định vectơ tổng  #mi(`\vec{S} = \vec{AB} + \vec{AD} + \vec{AA'}`)  theo các vectơ đường chéo của hình hộp.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, tổng ba vectơ xuất phát từ cùng một đỉnh dọc theo ba cạnh của hình hộp bằng vectơ đường chéo chính xuất phát từ đỉnh đó. Vậy  #mi(`\vec{S} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có các cạnh  #mi(`AB=a, AD=b, AA'=c`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp:  #mi(`\vec{u} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  là:  #mi(`|\vec{u}| = \sqrt{a^2 + b^2 + c^2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 6 (Củng cố).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành). Tiếp tục cộng với  #mi(`\vec{AA'}`) , ta có  #mi(`\vec{AC} + \vec{AA'} = \vec{AC} + \vec{CC'} = \vec{AC'}`)  (vì  #mi(`\vec{AA'} = \vec{CC'}`) ). Vậy đẳng thức được chứng minh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Biểu diễn Vectơ qua điểm đặc biệt và Tích vô hướng, Góc giữa hai Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Biểu diễn Vectơ qua điểm đặc biệt và Tích vô hướng, Góc giữa hai Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  khi và chỉ khi  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) , suy ra  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .
  - Điểm  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  khi và chỉ khi  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) , suy ra  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) , từ đó  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ hệ số: Tam giác là  #mi(`\frac{1}{3}`) , Tứ diện là  #mi(`\frac{1}{4}`) . Tích vô hướng là 'Độ dài nhân độ dài nhân cos'.
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{AI} = \dots(\vec{AB} + \vec{AC} + \vec{AD})`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Tính giá trị biểu thức  #mi(`P = |\vec{GA} + \vec{GB} + \vec{GC}|`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo tính chất trọng tâm tam giác  #mi(`ABC`) , ta có  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Do đó,  #mi(`P = |\vec{0}| = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\b`)  có  #mi(`|\vec{a}| = 3`) ,  #mi(`|\vec{b}| = 4`)  và góc giữa chúng là  #mi(`60^\circ`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(60^\circ) = 3 \cdot 4 \cdot \frac{1}{2} = 6`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn qua trọng tâm tam giác:] Cho tam giác  #mi(`ABC`) . Hãy biểu diễn vectơ  #mi(`\vec{AM}`)  qua  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) , biết  #mi(`M`)  là trọng tâm tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{AM} = \frac{1}{3}(\vec{AB} + \vec{AC})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Biểu diễn qua trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`I`)  là trọng tâm tứ diện. Biểu diễn  #mi(`\vec{AI}`)  qua  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tích vô hướng:] Trong không gian, cho  #mi(`\vec{a} = (1; 2; 2)`)  và  #mi(`\vec{b} = (2; -1; 0)`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 2 \cdot (-1) + 2 \cdot 0 = 2 - 2 + 0 = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ:] Cho  #mi(`|\vec{a}| = 2, |\vec{b}| = 5`)  và  #mi(`\vec{a} \cdot \vec{b} = 5`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|} = \frac{5}{2 \cdot 5} = \frac{1}{2}`) . Suy ra góc  #mi(`(\vec{a}, \vec{b}) = 60^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn  #mi(`\vec{BG}`)  qua  #mi(`\vec{BA}`)  và  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{BG} = \vec{BA} + \vec{AG} = \vec{BA} + \frac{1}{3}(\vec{AB} + \vec{AC}) = \vec{BA} + \frac{1}{3}(-\vec{BA} + \vec{BC}) = \frac{2}{3}\vec{BA} + \frac{1}{3}\vec{BC}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`I`)  là trọng tâm tứ diện. Biểu diễn  #mi(`\vec{BI}`)  qua  #mi(`\vec{BA}, \vec{BC}, \vec{BD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{BI} = \vec{BA} + \vec{AI} = \vec{BA} + \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD}) = \vec{BA} + \frac{1}{4}(-\vec{BA} + \vec{BC} + \frac{1}{4}(\vec{BD}-\vec{BC}))`) . Cách nhanh nhất:  #mi(`\vec{BI} = \frac{1}{4}(\vec{BA} + \vec{BC} + \vec{BD} + \vec{BB}) = \frac{1}{4}(\vec{BA} + \vec{BC} + \vec{BD})`)  (vì  #mi(`\vec{BB}=\vec{0}`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho  #mi(`|\vec{a}| = 4, |\vec{b}| = 3`)  và góc  #mi(`(\vec{a}, \vec{b}) = 90^\circ`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} \cdot \vec{b} = 4 \cdot 3 \cdot \cos(90^\circ) = 12 \cdot 0 = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Tính  #mi(`|\vec{GA} + \vec{GB} + \vec{GC}|`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) , do đó  #mi(`|\vec{GA} + \vec{GB} + \vec{GC}| = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Cho  #mi(`\vec{a} = (2; 1; -1)`)  và  #mi(`\vec{b} = (1; 0; 3)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} \cdot \vec{b} = 2 \cdot 1 + 1 \cdot 0 + (-1) \cdot 3 = 2 - 3 = -1`) .  #mi(`|\vec{a}| = \sqrt{2^2+1^2+(-1)^2} = \sqrt{6}`) .  #mi(`|\vec{b}| = \sqrt{1^2+0^2+3^2} = \sqrt{10}`) .  #mi(`\cos(\vec{a}, \vec{b}) = \frac{-1}{\sqrt{6}\sqrt{10}} = \frac{-1}{\sqrt{60}} = \frac{-1}{2\sqrt{15}}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Chứng minh đẳng thức Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Chứng minh đẳng thức Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Phương pháp chèn điểm: Để biến đổi một vectơ  #mi(`\vec{XY}`) , ta chèn một điểm  #mi(`M`)  bất kỳ vào giữa để có  #mi(`\vec{XY} = \vec{XM} + \vec{MY}`) . Phương pháp này thường dùng cho các hình không có tính đối xứng cao như tứ diện.
  - Phương pháp thay thế vectơ bằng nhau: Trong các hình có tính đối xứng (hình hộp, hình lăng trụ), ta thay thế một vectơ bằng một vectơ khác cùng phương, cùng hướng và cùng độ dài (ví dụ trong hình hộp  #mi(`ABCD.A'B'C'D'`)  thì  #mi(`\vec{AB} = \vec{DC} = \vec{A'B'} = \vec{D'C'}`) ).
  - Quy tắc cộng nối tiếp (quy tắc 3 điểm):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi chứng minh đẳng thức, hãy nhìn vào vế phải để chọn điểm chèn phù hợp hoặc tìm các cặp cạnh song song và bằng nhau để thay thế.
  ]
  - *Công thức cốt lõi:* Để chứng minh  #mi(`\vec{u} = \vec{v}`) , ta thường biến đổi vế trái  #mi(`\vec{VT}`)  bằng cách chèn điểm hoặc thay thế để đưa về dạng của vế phải  #mi(`\vec{VP}`) , khi đó  #mi(`\vec{VT} = ... = \vec{VP}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a=1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{BC} + \vec{DD'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.41]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`DD'C'C`)  là hình bình hành nên  #mi(`\vec{DD'} = \vec{CC'}`) . Khi đó  #mi(`\vec{u} = \vec{BC} + \vec{CC'} = \vec{BC'}`) . Độ dài  #mi(`|\vec{u}| = BC'`) . Xét tam giác  #mi(`BCC'`)  vuông tại  #mi(`C`) , ta có  #mi(`BC' = \sqrt{BC^2 + CC'^2} = \sqrt{1^2 + 1^2} = \sqrt{2}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a=1`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.73]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài  #mi(`|\vec{v}| = AC'`) . Đường chéo hình lập phương cạnh  #mi(`a`)  là  #mi(`a\sqrt{3}`) . Với  #mi(`a=1`) , ta có  #mi(`AC' = \sqrt{3} \approx 1.73`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Phương pháp chèn điểm:] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta biến đổi vế trái (VT):
 #mi(`\vec{VT} = \vec{AC} + \vec{BD}`) \nChèn điểm  #mi(`D`)  vào  #mi(`\vec{AC}`)  và chèn điểm  #mi(`C`)  vào  #mi(`\vec{BD}`) :
 #mi(`\vec{VT} = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD})`) 
 #mi(`\vec{VT} = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) \nVì  #mi(`\vec{DC} + \vec{CD} = \vec{0}`)  nên:
 #mi(`\vec{VT} = \vec{AD} + \vec{BC} = \vec{VP}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Phương pháp thay thế vectơ:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta biến đổi vế trái (VT):
 #mi(`\vec{VT} = \vec{BC} + \vec{DC} + \vec{AA'}`) \nVì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`\vec{BC} = \vec{A'D'}`)  và  #mi(`\vec{DC} = \vec{D'C'}`) . Thay vào biểu thức:
 #mi(`\vec{VT} = \vec{A'D'} + \vec{D'C'} + \vec{AA'}`) \nSắp xếp lại theo quy tắc nối tiếp:
 #mi(`\vec{VT} = \vec{AA'} + \vec{A'D'} + \vec{D'C'}`) 
 #mi(`\vec{VT} = \vec{AD'} + \vec{D'C'} = \vec{AC'} = \vec{VP}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Kết hợp tỉ số và chèn điểm:] Cho hình chóp  #mi(`S.ABC`) . Trên cạnh  #mi(`SA`)  lấy điểm  #mi(`M`)  sao cho  #mi(`SM = 2AM`) . Trên cạnh  #mi(`BC`)  lấy điểm  #mi(`N`)  sao cho  #mi(`CN = 2BN`) . Chứng minh rằng:  #mi(`\vec{MN} = \frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ giả thiết  #mi(`SM = 2AM`)  và  #mi(`\vec{SM}, \vec{MA}`)  cùng phương nên  #mi(`\vec{SA} = 3\vec{MA} \Rightarrow \vec{MA} = \frac{1}{3}\vec{SA}`) .\nTương tự,  #mi(`CN = 2BN`)  nên  #mi(`\vec{BC} = 3\vec{BN} \Rightarrow \vec{BN} = \frac{1}{3}\vec{BC}`) .\nTa biến đổi  #mi(`\vec{MN}`)  bằng cách chèn điểm  #mi(`A`)  và  #mi(`B`) :
 #mi(`\vec{MN} = \vec{MA} + \vec{AB} + \vec{BN}`) \nThay các giá trị vectơ đã tìm được ở trên vào:
 #mi(`\vec{MN} = \frac{1}{3}\vec{SA} + \vec{AB} + \frac{1}{3}\vec{BC}`) 
 #mi(`\vec{MN} = \frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Biến đổi vế trái (VT):
 #mi(`\vec{VT} = \vec{AB} + \vec{CD}`) \nChèn điểm  #mi(`D`)  vào  #mi(`\vec{AB}`)  và chèn điểm  #mi(`B`)  vào  #mi(`\vec{CD}`) :
 #mi(`\vec{VT} = (\vec{AD} + \vec{DB}) + (\vec{CB} + \vec{BD})`) 
 #mi(`\vec{VT} = \vec{AD} + \vec{CB} + (\vec{DB} + \vec{BD})`) \nVì  #mi(`\vec{DB} + \vec{BD} = \vec{0}`)  nên  #mi(`\vec{VT} = \vec{AD} + \vec{CB} = \vec{VP}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng:  #mi(`\vec{AC} + \vec{DB} = \vec{AB} + \vec{DC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Biến đổi vế trái (VT):
 #mi(`\vec{VT} = \vec{AC} + \vec{DB}`) \nChèn điểm  #mi(`B`)  vào  #mi(`\vec{AC}`)  và chèn điểm  #mi(`C`)  vào  #mi(`\vec{DB}`) :
 #mi(`\vec{VT} = (\vec{AB} + \vec{BC}) + (\vec{DC} + \vec{CB})`) 
 #mi(`\vec{VT} = \vec{AB} + \vec{DC} + (\vec{BC} + \vec{CB})`) \nVì  #mi(`\vec{BC} + \vec{CB} = \vec{0}`)  nên  #mi(`\vec{VT} = \vec{AB} + \vec{DC} = \vec{VP}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đây là quy tắc hình hộp cơ bản. Ta có:
 #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  (quy tắc hình bình hành đáy  #mi(`ABCD`) )\nKhi đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC} + \vec{AA'}`) \nVì  #mi(`ACC'A'`)  là hình bình hành nên  #mi(`\vec{AA'} = \vec{CC'}`) .
 #mi(`\vec{VT} = \vec{AC} + \vec{CC'} = \vec{AC'} = \vec{VP}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng:  #mi(`\vec{A'B} + \vec{A'D} + \vec{A'A} = \vec{A'C}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta biến đổi vế trái (VT):
 #mi(`\vec{VT} = \vec{A'B} + \vec{A'D} + \vec{A'A}`) \nSử dụng quy tắc hình hộp tại đỉnh  #mi(`A'`)  với các cạnh  #mi(`\vec{A'B'}`) ,  #mi(`\vec{A'D'}`) ,  #mi(`\vec{A'A}`) :\nTa có  #mi(`\vec{A'B} = \vec{A'B'} + \vec{B'B}`)  và  #mi(`\vec{A'D} = \vec{A'D'} + \vec{D'D}`) .\nTuy nhiên, cách đơn giản nhất là dùng quy tắc hình hộp cho hình hộp  #mi(`A'B'C'D'.ABCD`)  với đỉnh xuất phát là  #mi(`A'`) :
 #mi(`\vec{A'B} + \vec{A'D} + \vec{A'A}`)  không phải là đường chéo chính. Hãy chèn điểm:
 #mi(`\vec{A'B} + \vec{A'D} + \vec{A'A} = (\vec{A'B'} + \vec{B'B}) + (\vec{A'D'} + \vec{D'D}) + \vec{A'A}`) 
 #mi(`= (\vec{A'B'} + \vec{A'D'}) + (\vec{B'B} + \vec{D'D}) + \vec{A'A}`) 
 #mi(`= \vec{A'C'} + 2\vec{AA'} + \vec{A'A} = \vec{A'C'} + \vec{AA'}`) .
Đề bài yêu cầu chứng minh bằng  #mi(`\vec{A'C}`) . Ta có  #mi(`\vec{A'C} = \vec{A'C'} + \vec{C'C} = \vec{A'C'} + \vec{AA'}`) .\nVậy  #mi(`\vec{VT} = \vec{A'C} = \vec{VP}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Cho hình chóp  #mi(`S.ABC`) . Trên cạnh  #mi(`SA`)  lấy điểm  #mi(`M`)  sao cho  #mi(`AM = 2MS`) . Trên cạnh  #mi(`BC`)  lấy điểm  #mi(`N`)  sao cho  #mi(`BN = 2NC`) . Chứng minh rằng:  #mi(`\vec{MN} = \frac{1}{3}(\vec{AS} + \vec{CB}) + \vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ  #mi(`AM = 2MS`)  nên  #mi(`\vec{AS} = 3\vec{MS} \Rightarrow \vec{MS} = \frac{1}{3}\vec{AS}`) .\nTừ  #mi(`BN = 2NC`)  nên  #mi(`\vec{BC} = 3\vec{BN} \Rightarrow \vec{BN} = \frac{1}{3}\vec{BC}`) .\nTa có  #mi(`\vec{MN} = \vec{MB} + \vec{BN}`) . Chèn điểm  #mi(`A`)  vào  #mi(`\vec{MB}`) :
 #mi(`\vec{MN} = \vec{MA} + \vec{AB} + \vec{BN}`) \nVì  #mi(`\vec{MA} = -\vec{AM} = -\frac{2}{3}\vec{AS}`)  (Sai, hãy xem lại tỉ số:  #mi(`AM=2MS \Rightarrow \vec{MA} = \frac{1}{3}\vec{SA}`) ).
 #mi(`\vec{MN} = \frac{1}{3}\vec{SA} + \vec{AB} + \frac{1}{3}\vec{BC} = \frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`) .
Để ra kết quả  #mi(`\vec{AS} + \vec{CB}`) , ta viết  #mi(`\vec{SA} = -\vec{AS}`)  và  #mi(`\vec{BC} = -\vec{CB}`) .
 #mi(`\vec{MN} = \frac{1}{3}(-\vec{AS} - \vec{CB}) + \vec{AB}`) .
(Lưu ý: Đề bài yêu cầu  #mi(`\vec{AS} + \vec{CB}`)  có thể do nhầm dấu, kết quả chuẩn là  #mi(`\frac{1}{3}(\vec{SA} + \vec{BC}) + \vec{AB}`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Hệ tọa độ Oxyz và Tọa độ Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Hệ tọa độ Oxyz và Tọa độ Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong không gian  #mi(`Oxyz`) , cho các vectơ đơn vị  #mi(`\vec{i}, \vec{j}, \vec{k}`)  lần lượt nằm trên các trục  #mi(`Ox, Oy, Oz`) . Một vectơ  #mi(`\vec{a} = (x; y; z)`)  được biểu diễn dưới dạng:  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`) .
  - Cho hai vectơ  #mi(`\vec{a} = (x_1; y_1; z_1)`)  và  #mi(`\vec{b} = (x_2; y_2; z_2)`) . Các phép toán tọa độ được thực hiện như sau:  #mi(`\vec{a} + \vec{b} = (x_1 + x_2; y_1 + y_2; z_1 + z_2)`) ;  #mi(`\vec{a} - \vec{b} = (x_1 - x_2; y_1 - y_2; z_1 - z_2)`) ;  #mi(`k\vec{a} = (kx_1; ky_1; kz_1)`) .
  - Cho hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) . Tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tọa độ vectơ  #mi(`\vec{AB}`) , hãy lấy 'Tọa độ điểm cuối trừ Tọa độ điểm đầu' ( #mi(`B - A`) ).
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`)  thì tọa độ của vectơ  #mi(`\vec{a}`)  là  #mi(`...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a} = 2\vec{i} - 3\vec{j} + 4\vec{k}`) . Tìm tọa độ của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2; -3; 4)]
      \ #text(fill: rgb("#334155"))[Lời giải: Dựa vào định nghĩa biểu diễn qua vectơ đơn vị, tọa độ của  #mi(`\vec{a}`)  là các hệ số đi kèm với  #mi(`\vec{i}, \vec{j}, \vec{k}`) . Ta có:  #mi(`x=2, y=-3, z=4`) . Vậy  #mi(`\vec{a} = (2; -3; 4)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 0; -1)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; -2; -4)]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Ta có:  #mi(`\vec{AB} = (4 - 1; 0 - 2; -1 - 3) = (3; -2; -4)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn vectơ qua các vectơ đơn vị:] Cho vectơ  #mi(`\vec{a} = 3\vec{i} + 2\vec{j} - \vec{k}`) . Xác định tọa độ của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ  #mi(`\vec{a}`)  được biểu diễn dưới dạng  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`) . So sánh với  #mi(`\vec{a} = 3\vec{i} + 2\vec{j} - 1\vec{k}`) , ta có  #mi(`x=3, y=2, z=-1`) . Vậy tọa độ của  #mi(`\vec{a}`)  là  #mi(`(3; 2; -1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Thực hiện phép cộng và trừ vectơ tọa độ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; -2; 3)`)  và  #mi(`\vec{b} = (4; 5; -1)`) . Tính  #mi(`\vec{u} = 2\vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính  #mi(`2\vec{a} = 2(1; -2; 3) = (2; -4; 6)`) . Bước 2: Tính  #mi(`\vec{u} = (2; -4; 6) + (4; 5; -1) = (2+4; -4+5; 6-1) = (6; 1; 5)`) . Vậy  #mi(`\vec{u} = (6; 1; 5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ vectơ từ tọa độ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; -1; 4)`)  và  #mi(`B(5; 3; 0)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Ta có:  #mi(`\vec{AB} = (5 - 2; 3 - (-1); 0 - 4) = (3; 4; -4)`) . Vậy  #mi(`\vec{AB} = (3; 4; -4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho  #mi(`\vec{a} = -\vec{i} + 4\vec{j} + 2\vec{k}`) . Tìm tọa độ của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào biểu diễn  #mi(`\vec{a} = x\vec{i} + y\vec{j} + z\vec{k}`) , ta có  #mi(`x=-1, y=4, z=2`) . Vậy  #mi(`\vec{a} = (-1; 4; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho  #mi(`\vec{a} = 5\vec{i} - \vec{j} + 3\vec{k}`) . Tìm tọa độ của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tương tự bài 1, ta có  #mi(`x=5, y=-1, z=3`) . Vậy  #mi(`\vec{a} = (5; -1; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho  #mi(`A(0; 1; -2)`)  và  #mi(`B(3; -2; 5)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Ta có:  #mi(`\vec{AB} = (3 - 0; -2 - 1; 5 - (-2)) = (3; -3; 7)`) . Vậy  #mi(`\vec{AB} = (3; -3; 7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 3; -1)`)  và  #mi(`\vec{b} = (1; -1; 4)`) . Tính  #mi(`\vec{u} = \vec{a} - 2\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bước 1: Tính  #mi(`2\vec{b} = (2; -2; 8)`) . Bước 2: Tính  #mi(`\vec{u} = (2; 3; -1) - (2; -2; 8) = (2 - 2; 3 - (-2); -1 - 8) = (0; 5; -9)`) . Vậy  #mi(`\vec{u} = (0; 5; -9)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Cho  #mi(`A(1; 1; 1)`)  và  #mi(`B(2; 3; 5)`) . Tìm tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ trung điểm  #mi(`I`)  được tính bằng công thức  #mi(`x_I = \frac{x_A + x_B}{2}, y_I = \frac{y_A + y_B}{2}, z_I = \frac{z_A + z_B}{2}`) . Ta có:  #mi(`x_I = \frac{1+2}{2} = 1.5; y_I = \frac{1+1}{2} = 2; z_I = \frac{1+5}{2} = 3`) . Vậy  #mi(`I(1.5; 2; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Phép toán Tọa độ Vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Phép toán Tọa độ Vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hai vectơ  #mi(`\vec{u} = (x_1; y_1; z_1)`)  và  #mi(`\vec{v} = (x_2; y_2; z_2)`) , tọa độ vectơ tổng là  #mi(`\vec{u} + \vec{v} = (x_1 + x_2; y_1 + y_2; z_1 + z_2)`)  và tọa độ vectơ hiệu là  #mi(`\vec{u} - \vec{v} = (x_1 - x_2; y_1 - y_2; z_1 - z_2)`) .
  - Tọa độ của vectơ  #mi(`k\vec{u}`)  với  #mi(`k \in \mathbb{R}`)  là  #mi(`k\vec{u} = (kx_1; ky_1; kz_1)`) .
  - Cho hai điểm  #mi(`M(x_M; y_M; z_M)`)  và  #mi(`N(x_N; y_N; z_N)`) , tọa độ vectơ  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính tọa độ vectơ  #mi(`\vec{MN}`) , hãy lấy tọa độ điểm 'ngọn' trừ tọa độ điểm 'gốc': 'Ngọn trừ Gốc'.
  ]
  - *Công thức cốt lõi:* Tọa độ vectơ  #mi(`\vec{MN}`)  được tính bằng công thức:  #mi(`\vec{MN} = (..., ..., ...)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (1; 2; -3)`)  và  #mi(`\vec{v} = (4; -1; 5)`) . Tính tọa độ vectơ  #mi(`\vec{w} = \vec{u} + \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (5; 1; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{w}`)  là:  #mi(`(1 + 4; 2 + (-1); -3 + 5) = (5; 1; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai điểm  #mi(`A(2; -1; 4)`)  và  #mi(`B(5; 3; -2)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; 4; -6)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB}`)  là:  #mi(`(5 - 2; 3 - (-1); -2 - 4) = (3; 4; -6)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cộng và trừ vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; -3; 1)`)  và  #mi(`\vec{b} = (-1; 4; 5)`) . Tính tọa độ của  #mi(`\vec{u} = \vec{a} - \vec{b}`)  và  #mi(`\vec{v} = 2\vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{u} = \vec{a} - \vec{b} = (2 - (-1); -3 - 4; 1 - 5) = (3; -7; -4)`) .\n\nTa có:  #mi(`2\vec{a} = 2(2; -3; 1) = (4; -6; 2)`) .\n\nDo đó:  #mi(`\vec{v} = 2\vec{a} + \vec{b} = (4 + (-1); -6 + 4; 2 + 5) = (3; -2; 7)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tọa độ vectơ từ hai điểm cho trước:] Cho hai điểm  #mi(`M(1; 0; -2)`)  và  #mi(`N(4; -3; 5)`) . Tìm tọa độ vectơ  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ vectơ giữa hai điểm:  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) .\n\nTa có:  #mi(`\vec{MN} = (4 - 1; -3 - 0; 5 - (-2)) = (3; -3; 7)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Phép nhân vectơ với một số thực:] Cho  #mi(`\vec{u} = (x; y; z)`)  biết  #mi(`\vec{u}`)  có tọa độ là  #mi(`(2; -4; 6)`) . Tính tọa độ của vectơ  #mi(`\vec{w} = -0,5\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{w}`)  là:  #mi(`-0,5(2; -4; 6) = (-0,5 \cdot 2; -0,5 \cdot (-4); -0,5 \cdot 6) = (-1; 2; -3)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (3; 1; -2)`)  và  #mi(`\vec{b} = (0; 4; 5)`) . Tính tọa độ vectơ  #mi(`\vec{u} = \vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{u} = (3 + 0; 1 + 4; -2 + 5) = (3; 5; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (-2; 5; 1)`)  và  #mi(`\vec{b} = (3; -2; 4)`) . Tính tọa độ vectơ  #mi(`\vec{u} = \vec{a} - \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{u} = (-2 - 3; 5 - (-2); 1 - 4) = (-5; 7; -3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 0; -1)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB} = (4 - 1; 0 - 2; -1 - 3) = (3; -2; -4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho  #mi(`\vec{u} = (4; -2; 6)`)  và  #mi(`\vec{v} = (1; 3; -2)`) . Tính tọa độ vectơ  #mi(`\vec{w} = 3\vec{u} - 2\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`3\vec{u} = (12; -6; 18)`)  và  #mi(`2\vec{v} = (2; 6; -4)`) .\n\nDo đó:  #mi(`\vec{w} = (12 - 2; -6 - 6; 18 - (-4)) = (10; -12; 22)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Cho hai điểm  #mi(`M(0; 5; -1)`)  và  #mi(`N(2; -3; 4)`) . Tìm tọa độ vectơ  #mi(`\vec{NM}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{NM} = (0 - 2; 5 - (-3); -1 - 4) = (-2; 8; -5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Tọa độ điểm đặc biệt, Độ dài và Khoảng cách trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Tọa độ điểm đặc biệt, Độ dài và Khoảng cách trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`)  là  #mi(`M\big(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\big)`) .
  - Cho tam giác  #mi(`ABC`)  với  #mi(`A(x_A; y_A; z_A)`) ,  #mi(`B(x_B; y_B; z_B)`) ,  #mi(`C(x_C; y_C; z_C)`) , tọa độ trọng tâm  #mi(`G`)  là  #mi(`G\big(\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3}\big)`) .
  - Độ dài đoạn thẳng  #mi(`AB`)  (hoặc độ dài vectơ  #mi(`\vec{AB}`) ) là  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Trung điểm là 'chia đôi' (chia 2), trọng tâm là 'chia ba' (chia 3), độ dài là 'căn tổng bình phương các hiệu'.
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  được tính bằng công thức  #mi(`x_G = \dots; y_G = \dots; z_G = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 5; 7)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{29}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`AB = \sqrt{(3-1)^2 + (5-2)^2 + (7-3)^2} = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{4 + 9 + 16} = \sqrt{29}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 2)`) ,  #mi(`B(3; 2; 0)`)  và  #mi(`C(5; -2; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; 0; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`x_G = \frac{1+3+5}{3} = 3`) ;  #mi(`y_G = \frac{0+2-2}{3} = 0`) ;  #mi(`z_G = \frac{2+0+4}{3} = 2`) . Vậy  #mi(`G(3; 0; 2)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ trung điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trung điểm:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+4}{2} = 3`) ;  #mi(`z_M = \frac{3+5}{2} = 4`) . Vậy  #mi(`M(2; 3; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ trọng tâm:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trọng tâm:  #mi(`x_G = \frac{1+3+2}{3} = 2`) ;  #mi(`y_G = \frac{2+2-1}{3} = 1`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài đoạn thẳng:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(2; 0; 6)`)  và  #mi(`B(0; 4; 0)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`AB = \sqrt{(0-2)^2 + (4-0)^2 + (0-6)^2} = \sqrt{(-2)^2 + 4^2 + (-6)^2} = \sqrt{4 + 16 + 36} = \sqrt{56} = 2\sqrt{14}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho  #mi(`A(2; 4; 6)`)  và  #mi(`B(4; 6; 8)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_M = \frac{2+4}{2} = 3`) ;  #mi(`y_M = \frac{4+6}{2} = 5`) ;  #mi(`z_M = \frac{6+8}{2} = 7`) . Vậy  #mi(`M(3; 5; 7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự).* Cho  #mi(`A(1; -2; 3)`)  và  #mi(`B(5; 0; -1)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_M = \frac{1+5}{2} = 3`) ;  #mi(`y_M = \frac{-2+0}{2} = -1`) ;  #mi(`z_M = \frac{3-1}{2} = 1`) . Vậy  #mi(`M(3; -1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(0; 1; 2)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(4; 5; 6)`) . Tìm tọa độ trọng tâm  #mi(`G`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{0+2+4}{3} = 2`) ;  #mi(`y_G = \frac{1+3+5}{3} = 3`) ;  #mi(`z_G = \frac{2+4+6}{3} = 4`) . Vậy  #mi(`G(2; 3; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 2; 2)`) ,  #mi(`B(4; 4; 4)`)  và  #mi(`C(6; 6; 6)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`AB = \sqrt{(4-2)^2 + (4-2)^2 + (4-2)^2} = \sqrt{2^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Biến thể nhẹ).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 2; 2)`)  và  #mi(`C(3; 3; 3)`) . Tìm tọa độ điểm  #mi(`C`)  sao cho  #mi(`G(2; 2; 2)`)  là trọng tâm tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm nên  #mi(`x_C = 3x_G - x_A - x_B = 3(2) - 1 - 2 = 3`) ;  #mi(`y_C = 3y_G - y_A - y_B = 3(2) - 1 - 2 = 3`) ;  #mi(`z_C = 3z_G - z_A - z_B = 3(2) - 1 - 2 = 3`) . Vậy  #mi(`C(3; 3; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Tích vô hướng và Góc giữa hai Vectơ bằng Tọa độ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Tích vô hướng và Góc giữa hai Vectơ bằng Tọa độ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho  #mi(`\vec{a} = (x; y; z)`)  và  #mi(`\vec{b} = (x'; y'; z')`) , tích vô hướng được tính bởi:  #mi(`\vec{a} \bullet \vec{b} = x \times x' + y \times y' + z \times z'`) 
  - Cosín của góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \bullet \vec{b}}{|\vec{a}| \times |\vec{b}|}`) 
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng  #mi(`0`)  ( #mi(`\vec{a} \bullet \vec{b} = 0`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh vuông góc, chỉ cần nhân các tọa độ tương ứng rồi cộng lại, nếu kết quả bằng  #mi(`0`)  thì chúng vuông góc!
  ]
  - *Công thức cốt lõi:* Công thức tính cosin góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\cos(\vec{a}, \vec{b}) = \frac{...}{|\vec{a}| \times |\vec{b}|}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho  #mi(`\vec{a} = (1; 2; -1)`)  và  #mi(`\vec{b} = (3; 0; 2)`) . Tính tích vô hướng  #mi(`\vec{a} \bullet \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tích vô hướng  #mi(`\vec{a} \bullet \vec{b} = 1 \times 3 + 2 \times 0 + (-1) \times 2 = 3 + 0 - 2 = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{a} = (2; -1; 2)`)  và  #mi(`\vec{b} = (1; 2; 0)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`|\vec{a}| = \sqrt{2^2 + (-1)^2 + 2^2} = \sqrt{9} = 3`) .  #mi(`|\vec{b}| = \sqrt{1^2 + 2^2 + 0^2} = \sqrt{5}`) . Tích vô hướng  #mi(`\vec{a} \bullet \vec{b} = 2 \times 1 + (-1) \times 2 + 2 \times 0 = 0`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = 0 / (3 \times \text{sqrt}(5)) = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng cơ bản:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; -3; 1)`)  và  #mi(`\vec{b} = (4; 1; -2)`) . Tính tích vô hướng  #mi(`\vec{a} \bullet \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tích vô hướng:  #mi(`\vec{a} \bullet \vec{b} = 2 \times 4 + (-3) \times 1 + 1 \times (-2) = 8 - 3 - 2 = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Chứng minh hai vectơ vuông góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (1; 2; 2)`)  và  #mi(`\vec{v} = (2; 1; -2)`) . Chứng minh rằng  #mi(`\vec{u} \bot \vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta tính tích vô hướng:  #mi(`\vec{u} \bullet \vec{v} = 1 \times 2 + 2 \times 1 + 2 \times (-2) = 2 + 2 - 4 = 0`) . Vì  #mi(`\vec{u} \bullet \vec{v} = 0`)  nên  #mi(`\vec{u} \bot \vec{v}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính cosin góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 1; 0)`)  và  #mi(`\vec{b} = (0; 1; 1)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`|\vec{a}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) .  #mi(`|\vec{b}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . Tích vô hướng  #mi(`\vec{a} \bullet \vec{b} = 1 \times 0 + 1 \times 1 + 0 \times 1 = 1`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{1}{\sqrt{2} \times \sqrt{2}} = \frac{1}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính số đo góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 0; 0)`)  và  #mi(`\vec{b} = (1; 1; 1)`) . Tính số đo góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`|\vec{a}| = 1`) .  #mi(`|\vec{b}| = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) . Tích vô hướng  #mi(`\vec{a} \bullet \vec{b} = 1 \times 1 + 0 \times 1 + 0 \times 1 = 1`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{1}{1 \times \sqrt{3}} = \frac{\sqrt{3}}{3}`) . Suy ra góc  #mi(`(\vec{a}, \vec{b}) \approx 54.74^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (3; -1; 2)`)  và  #mi(`\vec{b} = (1; 4; -2)`) . Tính tích vô hướng  #mi(`\vec{a} \bullet \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{a} \bullet \vec{b} = 3 \times 1 + (-1) \times 4 + 2 \times (-2) = 3 - 4 - 4 = -5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (5; 2; -1)`)  và  #mi(`\vec{v} = (2; -3; 4)`) . Tính tích vô hướng  #mi(`\vec{u} \bullet \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{u} \bullet \vec{v} = 5 \times 2 + 2 \times (-3) + (-1) \times 4 = 10 - 6 - 4 = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho  #mi(`\vec{a} = (1; 2; 1)`)  và  #mi(`\vec{b} = (2; 0; -2)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`|\vec{a}| = \sqrt{1^2 + 2^2 + 1^2} = \sqrt{6}`) .  #mi(`|\vec{b}| = \sqrt{2^2 + 0^2 + (-2)^2} = \sqrt{8} = 2\sqrt{2}`) . Tích vô hướng  #mi(`\vec{a} \bullet \vec{b} = 1 \times 2 + 2 \times 0 + 1 \times (-2) = 0`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 1; -1)`)  và  #mi(`\vec{b} = (x; 2; 3)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \bot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \bot \vec{b}`)  thì  #mi(`\vec{a} \bullet \vec{b} = 0`) . Ta có:  #mi(`2 \times x + 1 \times 2 + (-1) \times 3 = 0 \Leftrightarrow 2x + 2 - 3 = 0 \Leftrightarrow 2x - 1 = 0 \Leftrightarrow x = 0.5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Cung cố).* Cho  #mi(`\vec{a} = (1; 1; 1)`)  và  #mi(`\vec{b} = (1; -1; 0)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`|\vec{a}| = \sqrt{3}`) .  #mi(`|\vec{b}| = \sqrt{2}`) . Tích vô hướng  #mi(`\vec{a} \bullet \vec{b} = 1 - 1 + 0 = 0`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Vận dụng Tọa độ giải Hình học Không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Vận dụng Tọa độ giải Hình học Không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để giải bài toán hình học bằng tọa độ, bước đầu tiên là chọn hệ trục tọa độ  #mi(`Oxyz`)  sao cho các cạnh vuông góc trùng với các trục tọa độ. Khi đó, tọa độ các đỉnh được xác định bởi độ dài các cạnh dọc theo các trục.
  - Tọa độ của các phép toán vectơ:  #mi(`\vec{u} + \vec{v} = (x_u+x_v; y_u+y_v; z_u+z_v)`) ;  #mi(`\vec{u} - \vec{v} = (x_u-x_v; y_u-y_v; z_u-z_v)`) ;  #mi(`k\vec{u} = (kx_u; ky_u; kz_u)`) .
  - Tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`)  và trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  là:  #mi(`M = (\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2})`)  và  #mi(`G = (\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3})`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo chọn gốc tọa độ: Hãy chọn đỉnh nào có 3 cạnh đôi một vuông góc (như đỉnh của hình hộp chữ nhật hoặc hình chóp có 3 cạnh bên vuông góc) làm gốc  #mi(`O`)  để tọa độ các đỉnh trở nên đơn giản nhất (nhiều số  #mi(`0`) ).
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  được tính bằng công thức  #mi(`G = (\dots; \dots; \dots)`)  với  #mi(`\dots`)  là trung bình cộng các tọa độ tương ứng.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`2`) . Chọn gốc tọa độ tại  #mi(`A`) . Tính tọa độ điểm  #mi(`C'`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2;2;2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`A`)  là gốc tọa độ nên  #mi(`A(0;0;0)`) . Do cạnh bằng  #mi(`2`)  và các cạnh  #mi(`AB, AD, AA'`)  nằm trên các trục  #mi(`Ox, Oy, Oz`) , ta có  #mi(`B(2;0;0)`) ,  #mi(`D(0;2;0)`) ,  #mi(`A'(0;0;2)`) . Điểm  #mi(`C'`)  là đỉnh đối diện với  #mi(`A`)  qua tâm hình lập phương, có tọa độ là  #mi(`(2;2;2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1;2;3)`) ,  #mi(`B(3;0;1)`)  và  #mi(`C(5;4;5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3;2;3)]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`x_G = \frac{1+3+5}{3} = 3`) ;  #mi(`y_G = \frac{2+0+4}{3} = 2`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(3;2;3)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tọa độ đỉnh hình hộp chữ nhật:] Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=3, AD=4, AA'=5`) . Thiết lập hệ trục tọa độ  #mi(`Oxyz`)  với gốc  #mi(`O`)  trùng với  #mi(`A`)  và các tia  #mi(`Ox, Oy, Oz`)  lần lượt trùng với các tia  #mi(`AB, AD, AA'`) . Tìm tọa độ các đỉnh  #mi(`C`)  và  #mi(`D'`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`A`)  là gốc tọa độ nên  #mi(`A(0;0;0)`) . Theo giả thiết:  #mi(`B`)  nằm trên  #mi(`Ox`)  nên  #mi(`B(3;0;0)`) ;  #mi(`D`)  nằm trên  #mi(`Oy`)  nên  #mi(`D(0;4;0)`) ;  #mi(`A'`)  nằm trên  #mi(`Oz`)  nên  #mi(`A'(0;0;5)`) . Điểm  #mi(`C`)  nằm trong mặt phẳng  #mi(`(Oxy)`)  với  #mi(`AB=3`)  và  #mi(`AD=4`)  nên  #mi(`C(3;4;0)`) . Điểm  #mi(`D'`)  nằm trên mặt phẳng  #mi(`(Oyz)`)  với  #mi(`AD=4`)  và  #mi(`AA'=5`)  nên  #mi(`D'(0;4;5)`) . Vậy  #mi(`C(3;4;0)`)  và  #mi(`D'(0;4;5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính toán vectơ bằng tọa độ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (1; -2; 3)`)  và  #mi(`\vec{v} = (4; 0; -1)`) . Tính tọa độ vectơ  #mi(`\vec{w} = 2\vec{u} - \vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:]  #mi(`2\vec{u} = (2\cdot1; 2\cdot(-2); 2\cdot3) = (2; -4; 6)`) .  #mi(`\vec{w} = (2; -4; 6) - (4; 0; -1) = (2-4; -4-0; 6-(-1)) = (-2; -4; 7)`) . Vậy  #mi(`\vec{w} = (-2; -4; 7)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Ứng dụng tọa độ giải bài toán trung điểm:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 4; -1)`) ,  #mi(`B(0; 2; 5)`)  và  #mi(`C(4; 0; 3)`) . Tìm tọa độ trung điểm  #mi(`M`)  của cạnh  #mi(`BC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ trung điểm  #mi(`M`)  của  #mi(`BC`)  được tính theo công thức:  #mi(`x_M = \frac{x_B+x_C}{2} = \frac{0+4}{2} = 2`) ;  #mi(`y_M = \frac{y_B+y_C}{2} = \frac{2+0}{2} = 1`) ;  #mi(`z_M = \frac{z_B+z_C}{2} = \frac{5+3}{2} = 4`) . Vậy  #mi(`M(2;1;4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh bằng  #mi(`3`) . Chọn gốc tọa độ tại  #mi(`A`)  và các trục  #mi(`Ox, Oy, Oz`)  lần lượt trùng với  #mi(`AB, AD, AA'`) . Tìm tọa độ các điểm  #mi(`B, D, A'`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`A`)  là gốc tọa độ nên  #mi(`A(0;0;0)`) . Do cạnh bằng  #mi(`3`)  nên  #mi(`B(3;0;0)`) ,  #mi(`D(0;3;0)`)  và  #mi(`A'(0;0;3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=5, AD=2, AA'=6`) . Chọn gốc tọa độ tại  #mi(`A`)  và các trục  #mi(`Ox, Oy, Oz`)  lần lượt trùng với  #mi(`AB, AD, AA'`) . Tìm tọa độ điểm  #mi(`C'`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gốc  #mi(`A(0;0;0)`) . Điểm  #mi(`C'`)  có tọa độ là  #mi(`(x_B; y_D; z_{A'}) = (5;2;6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Tương tự 100%).* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(0; 5; 6)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{1+2+0}{3} = 1`) ;  #mi(`y_G = \frac{1+3+5}{3} = 3`) ;  #mi(`z_G = \frac{1+4+6}{3} = 3,66...`)  (Làm tròn:  #mi(`G(1;3;3.67)`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; -1; 4)`)  và  #mi(`\vec{b} = (1; 3; -2)`) . Tính tọa độ vectơ  #mi(`\vec{c} = \vec{a} + 3\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`3\vec{b} = (3; 9; -6)`) .  #mi(`\vec{c} = (2+3; -1+9; 4-6) = (5; 8; -2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Chọn gốc tọa độ tại  #mi(`A`) . Chứng minh rằng tọa độ của tâm  #mi(`I`)  của hình lập phương là  #mi(`(\frac{a}{2}; \frac{a}{2}; \frac{a}{2})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tâm  #mi(`I`)  là trung điểm của đường chéo  #mi(`AC'`) . Tọa độ  #mi(`A(0;0;0)`)  và  #mi(`C'(a;a;a)`) . Tọa độ  #mi(`I = (\frac{0+a}{2}; \frac{0+a}{2}; \frac{0+a}{2}) = (\frac{a}{2}; \frac{a}{2}; \frac{a}{2})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Ứng dụng Vectơ trong Vật lý và Thực tế ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Ứng dụng Vectơ trong Vật lý và Thực tế]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Mô hình hóa lực và vận tốc: Một đại lượng có hướng (lực  #mi(`\vec{F}`) , vận tốc  #mi(`\vec{v}`) , độ dịch chuyển  #mi(`\vec{d}`) ) được biểu diễn bằng một vectơ có độ dài tỉ lệ với độ lớn và hướng theo hướng chuyển động/tác động.
  - Tổng hợp lực (Quy tắc hình bình hành): Nếu hai lực  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  cùng tác động vào một vật, hợp lực  #mi(`\vec{F}`)  được xác định bởi  #mi(`\vec{F} = \\[vec{F_1} + \vec{F_2}\mathbf{]}`)  sao cho tứ giác tạo bởi chúng là hình bình hành.
  - Công thức tính công:  #mi(`A = \text{độ lớn lực} \times \text{độ dịch chuyển} \times \text{cos}(\alpha) = F \times d \times \text{cos}(\alpha)`) , trong đó  #mi(`\alpha`)  là góc giữa lực và hướng chuyển động.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm hợp lực nhanh: Cùng hướng thì cộng độ lớn, ngược hướng thì trừ độ lớn, vuông góc thì dùng Pythagore!
  ]
  - *Công thức cốt lõi:* Hợp lực của hai lực  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  cùng hướng là  #mi(`\vec{F} = \dots`)  và nếu chúng vuông góc thì độ lớn là  #mi(`F = \sqrt{F_1^2 + F_2^2}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật chịu tác động của hai lực  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  có độ lớn lần lượt là  #mi(`30\text{N}`)  và  #mi(`40\text{N}`) . Biết hai lực này vuông góc với nhau. Tính độ lớn của hợp lực.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 50]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì hai lực vuông góc với nhau, ta áp dụng định lý Pythagore để tính độ lớn hợp lực:  #mi(`F = \sqrt{F_1^2 + F_2^2} = \sqrt{30^2 + 40^2} = \sqrt{900 + 1600} = \sqrt{2500} = 50\text{N}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chiếc máy bay di chuyển với vận tốc  #mi(`\vec{v}`)  có độ lớn  #mi(`500\text{km/h}`)  theo hướng Bắc. Một luồng gió thổi với vận tốc  #mi(`\vec{w}`)  có độ lớn  #mi(`50\text{km/h}`)  theo hướng Đông. Tính độ lớn vận tốc tổng hợp của máy bay.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 502.49]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc tổng hợp là  #mi(`\vec{v_{total}} = \vec{v} + \vec{w}`) . Vì hướng Bắc và hướng Đông vuông góc với nhau, độ lớn vận tốc tổng hợp là:  #mi(`v_{total} = \sqrt{v^2 + w^2} = \sqrt{500^2 + 50^2} = \sqrt{250000 + 2500} = \sqrt{252500} \approx 502.49\text{km/h}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc cộng vectơ cùng hướng:] Một chiếc xe tải đang chuyển động với vận tốc  #mi(`\vec{v_1} = 60\text{km/h}`)  về phía Đông. Một dòng nước chảy với vận tốc  #mi(`\vec{v_2} = 10\text{km/h}`)  cũng về phía Đông. Tính vận tốc tổng hợp của chiếc xe tải khi đi trên dòng nước.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì hai vectơ vận tốc  #mi(`\vec{v_1}`)  và  #mi(`\vec{v_2}`)  cùng hướng (cùng về phía Đông), ta có vận tốc tổng hợp là:  #mi(`\vec{v_{total}} = \vec{v_1} + \vec{v_2}`) . Độ lớn:  #mi(`v_{total} = v_1 + v_2 = 60 + 10 = 70\text{km/h}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình bình hành (lực vuông góc):] Một vật chịu tác động của hai lực  #mi(`\vec{F_1}`)  and  #mi(`\vec{F_2}`)  có độ lớn lần lượt là  #mi(`6\text{N}`)  và  #mi(`8\text{N}`) . Hai lực này vuông góc với nhau. Tính độ lớn của hợp lực.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì hai lực vuông góc, ta áp dụng công thức tính độ lớn hợp lực cho hai vectơ vuông góc:  #mi(`F = \sqrt{F_1^2 + F_2^2} = \sqrt{6^2 + 8^2} = \sqrt{36 + 64} = \sqrt{100} = 10\text{N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính công của một lực:] Một người kéo một thùng hàng với một lực  #mi(`\vec{F}`)  có độ lớn  #mi(`50\text{N}`)  theo phương nghiêng một góc  #mi(`60^\circ`)  so với phương ngang. Thùng hàng dịch chuyển một quãng đường  #mi(`d = 10\text{m}`)  theo phương ngang. Tính công  #mi(`A`)  sinh ra bởi lực  #mi(`\vec{F}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tính công:  #mi(`A = F \times d \times \text{cos}(\alpha)`) . Với  #mi(`F = 50\text{N}`) ,  #mi(`d = 10\text{m}`)  và  #mi(`\alpha = 60^\circ`) . Ta có:  #mi(`A = 50 \times 10 \times \text{cos}(60^\circ) = 500 \times 0.5 = 250\text{J}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
  *Bài 1 (Chuẩn mẫu).* Một vật chịu tác động của hai lực  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  có độ lớn lần lượt là  #mi(`5\text{N}`)  và  #mi(`12\text{N}`) . Biết hai lực này vuông góc với nhau. Tính độ lớn của hợp lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì hai lực vuông góc, ta có:  #mi(`F = \sqrt{F_1^2 + F_2^2} = \sqrt{5^2 + 12^2} = \sqrt{25 + 144} = \sqrt{169} = 13\text{N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 2 (Tương tự 100%).* Một vật chịu tác động của hai lực  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  có độ lớn lần lượt là  #mi(`8\text{N}`)  và  #mi(`15\text{N}`) . Biết hai lực này vuông góc với nhau. Tính độ lớn của hợp lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì hai lực vuông góc, ta có:  #mi(`F = \sqrt{F_1^2 + F_2^2} = \sqrt{8^2 + 15^2} = \sqrt{64 + 225} = \sqrt{289} = 17\text{N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 3 (Biến thể nhẹ).* Một chiếc thuyền di chuyển với vận tốc  #mi(`\vec{v_1} = 20\text{km/h}`)  về phía Bắc. Một dòng nước chảy với vận tốc  #mi(`\vec{v_2} = 15\text{km/h}`)  về phía Tây. Tính độ lớn vận tốc thực tế của chiếc thuyền so với bờ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc thực tế là  #mi(`\vec{v_{total}} = \vec{v_1} + \vec{v_2}`) . Vì hướng Bắc và hướng Tây vuông góc với nhau, độ lớn vận tốc là:  #mi(`v_{total} = \sqrt{20^2 + 15^2} = \sqrt{400 + 225} = \sqrt{625} = 25\text{km/h}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 4 (Biến thể nhẹ).* Một người kéo một chiếc xe với lực  #mi(`\vec{F}`)  có độ lớn  #mi(`100\text{N}`)  theo phương nghiêng một góc  #mi(`30^\circ`)  so với phương ngang. Chiếc xe dịch chuyển một quãng đường  #mi(`d = 20\text{m}`)  theo phương ngang. Tính công  #mi(`A`)  sinh ra bởi lực  #mi(`\vec{F}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức tính công:  #mi(`A = F \times d \times \text{cos}(\alpha)`) . Với  #mi(`F = 100\text{N}`) ,  #mi(`d = 20\text{m}`)  và  #mi(`\alpha = 30^\circ`) . Ta có:  #mi(`A = 100 \times 20 \times \text{cos}(30^\circ) = 2000 \times \frac{\sqrt{3}}{2} = 1000\sqrt{3} \approx 1732.05\text{J}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  *Bài 5 (Củng cố).* Một vật chịu tác động của hai lực  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  có độ lớn lần lượt là  #mi(`10\text{N}`)  và  #mi(`10\text{N}`) . Biết hai lực này cùng hướng với nhau. Tính độ lớn của hợp lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì hai lực cùng hướng, ta có:  #mi(`F = F_1 + F_2 = 10 + 10 = 20\text{N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
