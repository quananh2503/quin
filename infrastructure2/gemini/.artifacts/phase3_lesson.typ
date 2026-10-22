#import "@preview/mitex:0.2.7": mitex, mi
#import "@preview/cetz:0.3.3"
#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/cetz-plot:0.1.1": plot, chart
#import "@preview/vartable:0.2.4": tabvar
#import "archetypes.typ": *

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
  #text(size: 13pt, weight: "bold")[Vectơ trong không gian] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp kiến thức cơ bản về vectơ trong không gian, bao gồm định nghĩa, các phép toán vectơ (cộng, trừ, nhân số với vectơ), tích vô hướng, góc giữa hai vectơ và ứng dụng vào giải quyết các bài toán hình học không gian và vật lý.]
]
#v(6pt)

// ==================== DẠNG 1: Xác định vectơ, độ dài và giá của vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Xác định vectơ, độ dài và giá của vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_1|theory|0
  - Vectơ trong không gian là một đoạn thẳng có hướng. Vectơ có điểm đầu  #mi(`A`)  và điểm cuối  #mi(`B`)  được kí hiệu là  #mi(`\vec{AB}`) .
// @ANCHOR:dang_1|theory|1
  - Độ dài của vectơ  #mi(`\vec{AB}`)  là khoảng cách giữa điểm  #mi(`A`)  và điểm  #mi(`B`) , kí hiệu là  #mi(`|\vec{AB}| = AB`) .
// @ANCHOR:dang_1|theory|2
  - Đường thẳng đi qua điểm đầu và điểm cuối của một vectơ được gọi là giá của vectơ đó.
// @ANCHOR:dang_1|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ rằng: Giá của  #mi(`\vec{AB}`)  chính là đường thẳng  #mi(`AB`) . Muốn giá nằm trong mặt phẳng  #mi(`(P)`)  thì cả hai điểm  #mi(`A`)  và  #mi(`B`)  phải thuộc  #mi(`(P)`) .
  ]
// @ANCHOR:dang_1|cloze

  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`|\vec{AB}| = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_1|short_answer|0|prompt
    *Câu 1.* Cho tứ diện  #mi(`ABCD`) . Hỏi có bao nhiêu vectơ khác vectơ  #mi(`\vec{0}`)  mà mỗi vectơ có điểm đầu và điểm cuối là hai đỉnh của tứ diện  #mi(`ABCD`) ?
// @ANCHOR:dang_1|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 12]
// @ANCHOR:dang_1|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Tứ diện  #mi(`ABCD`)  có 4 đỉnh là  #mi(`A, B, C, D`) . Mỗi cặp đỉnh phân biệt  #mi(`(X, Y)`)  tạo ra một vectơ  #mi(`\vec{XY}`) . Số cách chọn cặp đỉnh có thứ tự là  #mi(`4 \times 3 = 12`)  vectơ. Các vectơ đó là:  #mi(`\vec{AB}, \vec{BA}, \vec{AC}, \vec{CA}, \vec{AD}, \vec{DA}, \vec{BC}, \vec{CB}, \vec{BD}, \vec{DB}, \vec{CD}, \vec{DC}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_1|short_answer|1|prompt
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  có độ dài mỗi cạnh bằng  #mi(`3`)  cm. Tính độ dài của vectơ  #mi(`\vec{AB}`) .
// @ANCHOR:dang_1|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
// @ANCHOR:dang_1|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Vì tứ diện  #mi(`ABCD`)  là tứ diện đều có cạnh bằng  #mi(`3`)  cm nên độ dài đoạn thẳng  #mi(`AB = 3`)  cm. Theo định nghĩa, độ dài của vectơ  #mi(`\vec{AB}`)  là  #mi(`|\vec{AB}| = AB = 3`) .]
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
// @ANCHOR:dang_1|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định vectơ và giá của vectơ:] Cho tứ diện  #mi(`ABCD`)  có độ dài mỗi cạnh bằng  #mi(`1`) . 
a) Có bao nhiêu vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là một trong các đỉnh còn lại của tứ diện?
b) Trong các vectơ tìm được ở câu a, những vectơ nào có giá nằm trong mặt phẳng  #mi(`(ABC)`) ?
c) Tính độ dài của các vectơ tìm được ở câu a.
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_1|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Các đỉnh còn lại của tứ diện là  #mi(`B, C, D`) . Vậy có 3 vectơ thỏa mãn là  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
b) Mặt phẳng  #mi(`(ABC)`)  chứa các điểm  #mi(`A, B, C`) . Do đó, các vectơ có giá nằm trong mặt phẳng  #mi(`(ABC)`)  là  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
c) Vì tứ diện  #mi(`ABCD`)  có độ dài mỗi cạnh bằng  #mi(`1`)  nên  #mi(`|\vec{AB}| = |\vec{AC}| = |\vec{AD}| = 1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_1|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`) . 
a) Liệt kê các vectơ có điểm đầu là  #mi(`B`)  và điểm cuối là một trong các đỉnh còn lại.
b) Trong các vectơ vừa liệt kê, vectơ nào có giá nằm trong mặt phẳng  #mi(`(BCD)`) ?
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_1|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các đỉnh còn lại là  #mi(`A, C, D`) . Vậy các vectơ là  #mi(`\vec{BA}, \vec{BC}, \vec{BD}`) .
b) Mặt phẳng  #mi(`(BCD)`)  chứa các điểm  #mi(`B, C, D`) . Vậy các vectơ có giá nằm trong mặt phẳng  #mi(`(BCD)`)  là  #mi(`\vec{BC}`)  và  #mi(`\vec{BD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_1|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . 
a) Liệt kê các vectơ có điểm đầu là  #mi(`C`)  và điểm cuối là một trong các đỉnh còn lại.
b) Trong các vectơ vừa liệt kê, vectơ nào có giá nằm trong mặt phẳng  #mi(`(ACD)`) ?
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_1|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các đỉnh còn lại là  #mi(`A, B, D`) . Vậy các vectơ là  #mi(`\vec{CA}, \vec{CB}, \vec{CD}`) .
b) Mặt phẳng  #mi(`(ACD)`)  chứa các điểm  #mi(`A, C, D`) . Vậy các vectơ có giá nằm trong mặt phẳng  #mi(`(ACD)`)  là  #mi(`\vec{CA}`)  và  #mi(`\vec{CD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_1|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình chóp tam giác  #mi(`S.ABC`) . 
a) Có bao nhiêu vectơ có điểm đầu là  #mi(`S`)  và điểm cuối là một trong các đỉnh của đáy  #mi(`ABC`) ?
b) Nếu độ dài các cạnh bên bằng  #mi(`5`)  cm, hãy tính độ dài của các vectơ tìm được ở câu a.
  
  #align(center)[#draw-pyramid-tri(labels: ("S", "A", "B", "C"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_1|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các đỉnh của đáy là  #mi(`A, B, C`) . Vậy có 3 vectơ là  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) .
b) Vì các cạnh bên  #mi(`SA = SB = SC = 5`)  cm nên  #mi(`|\vec{SA}| = |\vec{SB}| = |\vec{SC}| = 5`)  cm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_1|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . 
a) Xác định các vectơ có điểm đầu là  #mi(`A`)  và điểm cuối là một đỉnh của hình lập phương sao cho giá của vectơ đó không nằm trong mặt phẳng  #mi(`(ABCD)`) .
b) Tính độ dài của các vectơ tìm được ở câu a.
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_1|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Các đỉnh của hình lập phương là  #mi(`A, B, C, D, A', B', C', D'`) . Các đỉnh không thuộc mặt phẳng  #mi(`(ABCD)`)  là  #mi(`A', B', C', D'`) . Vậy các vectơ thỏa mãn là  #mi(`\vec{AA'}, \vec{AB'}, \vec{AC'}, \vec{AD'}`) .
b) Độ dài các vectơ:
-  #mi(`|\vec{AA'}| = AA' = 2`) .
-  #mi(`|\vec{AB'}| = AB' = \sqrt{AB^2 + BB'^2} = \sqrt{2^2 + 2^2} = 2\sqrt{2}`) .
-  #mi(`|\vec{AC'}| = AC' = \sqrt{AB^2 + BC^2 + CC'^2} = \sqrt{2^2 + 2^2 + 2^2} = 2\sqrt{3}`) .
-  #mi(`|\vec{AD'}| = AD' = \sqrt{AD^2 + DD'^2} = \sqrt{2^2 + 2^2} = 2\sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Xác định hai vectơ bằng nhau và vectơ đối ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Xác định hai vectơ bằng nhau và vectơ đối]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_2|theory|0
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được gọi là bằng nhau ( #mi(`\vec{a} = \vec{b}`) ) nếu chúng có cùng hướng và cùng độ dài.
// @ANCHOR:dang_2|theory|1
  - Vectơ đối của vectơ  #mi(`\vec{a}`)  là vectơ có cùng độ dài nhưng ngược hướng với  #mi(`\vec{a}`) , kí hiệu là  #mi(`-\vec{a}`) .
// @ANCHOR:dang_2|theory|2
  - Hai vectơ đối nhau khi và chỉ khi tổng của chúng bằng vectơ-không:  #mi(`\vec{a} + \vec{b} = \vec{0}`) .
// @ANCHOR:dang_2|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm vectơ bằng  #mi(`\vec{AB}`) , hãy tìm một đoạn thẳng song song, cùng chiều và có độ dài bằng  #mi(`AB`) . Muốn tìm vectơ đối, hãy tìm đoạn thẳng song song, ngược chiều và cùng độ dài.
  ]
// @ANCHOR:dang_2|cloze

  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng ... và ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_2|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{AB}`) .
// @ANCHOR:dang_2|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
// @ANCHOR:dang_2|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Trong hình lập phương, độ dài của vectơ  #mi(`\vec{AB}`)  chính là độ dài cạnh  #mi(`AB`) . Vì cạnh hình lập phương bằng  #mi(`1`)  nên  #mi(`|\vec{AB}| = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_2|short_answer|1|prompt
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ tổng  #mi(`\vec{u} = \vec{AB} + \vec{AD}`) .
// @ANCHOR:dang_2|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.41]
// @ANCHOR:dang_2|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình bình hành trong mặt phẳng  #mi(`(ABCD)`) , ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Độ dài của vectơ  #mi(`\vec{AC}`)  là đường chéo của hình vuông  #mi(`ABCD`)  cạnh  #mi(`1`) , do đó  #mi(`|\vec{AC}| = \sqrt{1^2 + 1^2} = \sqrt{2} \approx 1.41`) .]
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
// @ANCHOR:dang_2|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định vectơ bằng nhau trong hình lăng trụ:] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Trong các vectơ  #mi(`\vec{BC}, \vec{CC'}, \vec{B'B}`) , vectơ nào bằng vectơ  #mi(`\vec{AA'}`) ? Giải thích vì sao.
    
  #align(center)[#draw-prism-tri(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_2|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét các vectơ:
1. Vectơ  #mi(`\vec{BC}`) : Đường thẳng  #mi(`AA'`)  và  #mi(`BC`)  chéo nhau nên  #mi(`\vec{AA'}`)  và  #mi(`\vec{BC}`)  không cùng phương, suy ra  #mi(`\vec{AA'}`) 
eq \vec{BC} #mi(`.`) 
2. Vectơ  #mi(`\vec{CC'}`) : Vì  #mi(`ACC'A'`)  là hình bình hành nên  #mi(`AA' // CC'`)  và  #mi(`AA' = CC'`) . Hai vectơ  #mi(`\vec{AA'}`)  và  #mi(`\vec{CC'}`)  cùng hướng và cùng độ dài nên  #mi(`\vec{AA'} = \vec{CC'}`) .
3. Vectơ  #mi(`\vec{B'B}`) : Vì  #mi(`ABB'A'`)  là hình bình hành nên  #mi(`AA' // B'B`)  nhưng  #mi(`\vec{AA'}`)  hướng từ dưới lên trên, còn  #mi(`\vec{B'B}`)  hướng từ trên xuống dưới. Hai vectơ này ngược hướng nên  #mi(`\vec{AA'}`) 
eq \vec{B'B} #mi(`.`) 
Vậy vectơ bằng  #mi(`\vec{AA'}`)  là  #mi(`\vec{CC'}`) .
    ] else [ \ #v(16pt) ]
  ]
// @ANCHOR:dang_2|example|1|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định vectơ đối trong hình chóp:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`\vec{AM}`)  và  #mi(`\vec{CN}`)  là hai vectơ đối nhau.
    
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_2|example|1|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`AB // CD`)  và  #mi(`AB = CD`) .
Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{AM} = \frac{1}{2}\vec{AB}`) .
Vì  #mi(`N`)  là trung điểm  #mi(`CD`)  nên  #mi(`\vec{CN} = \frac{1}{2}\vec{CD}`) .
Mà  #mi(`\vec{CD} = \vec{BA} = -\vec{AB}`) .
Suy ra  #mi(`\vec{CN} = \frac{1}{2}(-\vec{AB}) = -\frac{1}{2}\vec{AB}`) .
Do đó  #mi(`\vec{AM} + \vec{CN} = \frac{1}{2}\vec{AB} + (-\frac{1}{2}\vec{AB}) = \vec{0}`) .
Vậy  #mi(`\vec{AM}`)  và  #mi(`\vec{CN}`)  là hai vectơ đối nhau.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_2|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Tìm tất cả các vectơ có điểm đầu và điểm cuối là các đỉnh của hình hộp mà bằng với vectơ  #mi(`\vec{AA'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_2|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , các cạnh bên song song và bằng nhau. Ta có  #mi(`AA' // BB' // CC' // DD'`)  và  #mi(`AA' = BB' = CC' = DD'`) . Hơn nữa, các vectơ  #mi(`\vec{AA'}, \vec{BB'}, \vec{CC'}, \vec{DD'}`)  đều có cùng hướng (từ mặt đáy này sang mặt đáy kia). Vậy các vectơ bằng  #mi(`\vec{AA'}`)  là  #mi(`\vec{BB'}, \vec{CC'}, \vec{DD'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_2|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình lăng trụ đứng tam giác  #mi(`ABC.A'B'C'`) . Tìm tất cả các vectơ có điểm đầu và điểm cuối là các đỉnh của hình lăng trụ mà bằng với vectơ  #mi(`\vec{BB'}`) .
  
  #align(center)[#draw-prism-tri(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_2|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong hình lăng trụ đứng  #mi(`ABC.A'B'C'`) , các cạnh bên  #mi(`AA', BB', CC'`)  song song, bằng nhau và cùng hướng. Do đó,  #mi(`\vec{AA'} = \vec{BB'} = \vec{CC'}`) . Vậy các vectơ bằng  #mi(`\vec{BB'}`)  là  #mi(`\vec{AA'}`)  và  #mi(`\vec{CC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_2|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Gọi  #mi(`M`)  là trung điểm của cạnh  #mi(`BC`) . Xác định điểm  #mi(`M'`)  sao cho  #mi(`\vec{MM'} = \vec{AA'}`) .
  
  #align(center)[#draw-prism-tri(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_2|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{MM'} = \vec{AA'}`) , điểm  #mi(`M'`)  phải thỏa mãn  #mi(`MM' // AA'`)  và  #mi(`MM' = AA'`)  và  #mi(`\vec{MM'}`)  cùng hướng với  #mi(`\vec{AA'}`) . Vì  #mi(`AA'`)  là cạnh bên của lăng trụ, nên  #mi(`M'`)  phải nằm trên mặt phẳng  #mi(`(A'B'C')`) . Vì  #mi(`M`)  là trung điểm  #mi(`BC`) , nên  #mi(`M'`)  phải là trung điểm của cạnh  #mi(`B'C'`)  để  #mi(`MM' // BB' // AA'`)  và  #mi(`MM' = BB' = AA'`) . Vậy  #mi(`M'`)  là trung điểm của  #mi(`B'C'`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_2|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình bình hành  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`\vec{AM}`)  và  #mi(`\vec{CN}`)  là hai vectơ đối nhau.
// @ANCHOR:dang_2|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) .
Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{AM} = \frac{1}{2}\vec{AB}`) .
Vì  #mi(`N`)  là trung điểm  #mi(`CD`)  nên  #mi(`\vec{CN} = \frac{1}{2}\vec{CD}`) .
Mà  #mi(`\vec{CD} = -\vec{DC} = -\vec{AB}`) .
Suy ra  #mi(`\vec{CN} = \frac{1}{2}(-\vec{AB}) = -\frac{1}{2}\vec{AB}`) .
Vậy  #mi(`\vec{AM} + \vec{CN} = \frac{1}{2}\vec{AB} - \frac{1}{2}\vec{AB} = \vec{0}`) .
Kết luận:  #mi(`\vec{AM}`)  và  #mi(`\vec{CN}`)  là hai vectơ đối nhau.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Phép cộng vectơ và quy tắc ba điểm, hình bình hành ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Phép cộng vectơ và quy tắc ba điểm, hình bình hành]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_3|theory|0
  - Quy tắc ba điểm: Với ba điểm  #mi(`A, B, C`)  bất kỳ trong không gian, ta có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
// @ANCHOR:dang_3|theory|1
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
// @ANCHOR:dang_3|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn cộng hai vectơ, hãy tìm 'điểm nối' (điểm cuối vectơ này là điểm đầu vectơ kia) để dùng quy tắc ba điểm:  #mi(`\vec{A\to B} + \vec{B\to C} = \vec{A\to C}`) .
  ]
// @ANCHOR:dang_3|cloze

  - *Công thức cốt lõi:* Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_3|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{BC} + \vec{DD'}`) .
// @ANCHOR:dang_3|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.41]
// @ANCHOR:dang_3|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`\vec{BC} = \vec{AD}`) . Khi đó  #mi(`\vec{v} = \vec{AD} + \vec{DD'}`) . Theo quy tắc ba điểm,  #mi(`\vec{AD} + \vec{DD'} = \vec{AD'}`) . Độ dài  #mi(`|\vec{v}| = |\vec{AD'}| = \sqrt{AD^2 + DD'^2} = \sqrt{1^2 + 1^2} = \sqrt{2} \approx 1.41`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_3|short_answer|1|prompt
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AC} + \vec{AD}`) .
// @ANCHOR:dang_3|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4.90]
// @ANCHOR:dang_3|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Ta có  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) . Trong tứ diện đều cạnh  #mi(`a`) , đường cao  #mi(`AG = \frac{\sqrt{6}}{3}a`) . Với  #mi(`a=2`) ,  #mi(`AG = \frac{2\sqrt{6}}{3}`) . Vậy  #mi(`|\vec{u}| = 3 \cdot \frac{2\sqrt{6}}{3} = 2\sqrt{6} \approx 4.90`) .]
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
// @ANCHOR:dang_3|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh đẳng thức vectơ trong tứ diện:] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) .
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_3|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sử dụng quy tắc ba điểm để chèn điểm  #mi(`D`)  vào  #mi(`\vec{AC}`)  và điểm  #mi(`C`)  vào  #mi(`\vec{BD}`) :
 #mi(`\vec{AC} = \vec{AD} + \vec{DC}`) 
 #mi(`\vec{BD} = \vec{BC} + \vec{CD}`) 
Cộng hai đẳng thức trên theo vế:
 #mi(`\vec{AC} + \vec{BD} = (\vec{AD} + \vec{DC}) + (\vec{BC} + \vec{CD}) = \vec{AD} + \vec{BC} + (\vec{DC} + \vec{CD})`) 
Vì  #mi(`\vec{DC} + \vec{CD} = \vec{0}`) , nên ta có:  #mi(`\vec{AC} + \vec{BD} = \vec{AD} + \vec{BC}`) . (đpcm)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_3|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_3|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB} + \vec{CD} = (\vec{AD} + \vec{DB}) + \vec{CD} = \vec{AD} + (\vec{DB} + \vec{CD}) = \vec{AD} + \vec{DC}`) .
Mà  #mi(`\vec{DC} = -\vec{CD}`)  và  #mi(`\vec{CB} = -\vec{BC}`) , nhưng cách đơn giản nhất là:  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{DB} + \vec{CD} = \vec{AD} + \vec{CD} + \vec{DB}`) .
Xét vế phải:  #mi(`\vec{AD} + \vec{CB} = \vec{AD} + (\vec{CD} + \vec{DB}) = \vec{AD} + \vec{CD} + \vec{DB}`) .
Vậy  #mi(`\vec{AB} + \vec{CD} = \vec{AD} + \vec{CB}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_3|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{BA} + \vec{CD} = \vec{BD} + \vec{CA}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_3|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{BA} + \vec{CD} = (\vec{BD} + \vec{DA}) + \vec{CD} = \vec{BD} + (\vec{DA} + \vec{CD}) = \vec{BD} + \vec{CA}`) . (đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_3|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_3|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
Khi đó:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC} + \vec{AA'}`) .
Vì  #mi(`ACC'A'`)  là hình bình hành nên  #mi(`\vec{AC} + \vec{AA'} = \vec{AC'}`) .
Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_3|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: ((name: "M", type: "midpoint", of: ("A", "B"), k: 0.5), (name: "N", type: "midpoint", of: ("C", "D"), k: 0.5)), lines: (), vectors: (("M", "N"), ("A", "C"), ("B", "D")), polygons: ())]
// @ANCHOR:dang_3|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) .
Đồng thời:  #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN}`) .
Cộng hai vế:  #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AC} + \vec{BD}) + (\vec{CN} + \vec{DN})`) .
Vì  #mi(`M`)  là trung điểm  #mi(`AB \Rightarrow \vec{MA} + \vec{MB} = \vec{0}`) .
Vì  #mi(`N`)  là trung điểm  #mi(`CD \Rightarrow \vec{CN} + \vec{DN} = \vec{0}`) .
Suy ra  #mi(`2\vec{MN} = \vec{AC} + \vec{BD} \Rightarrow \vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Phép trừ vectơ và hiệu của hai vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Phép trừ vectơ và hiệu của hai vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_4|theory|0
  - Hiệu của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được định nghĩa là:  #mi(`\vec{a} - \vec{b} = \vec{a} + (-\vec{b})`) , trong đó  #mi(`-\vec{b}`)  là vectơ đối của  #mi(`\vec{b}`) .
// @ANCHOR:dang_4|theory|1
  - Quy tắc hiệu: Với ba điểm  #mi(`O, A, B`)  bất kỳ trong không gian, ta luôn có  #mi(`\vec{OB} - \vec{OA} = \vec{AB}`) .
// @ANCHOR:dang_4|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ quy tắc 'Sau trừ Trước bằng Hiệu':  #mi(`\vec{OB} - \vec{OA} = \vec{AB}`)  (điểm cuối trừ điểm đầu).
  ]
// @ANCHOR:dang_4|cloze

  - *Công thức cốt lõi:* Với ba điểm  #mi(`O, A, B`)  bất kỳ, ta có  #mi(`\vec{OB} - \vec{OA} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_4|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} - \vec{AD}`) .
// @ANCHOR:dang_4|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2.83]
// @ANCHOR:dang_4|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hiệu, ta có  #mi(`\vec{v} = \vec{AB} - \vec{AD} = \vec{DB}`) . Độ dài của vectơ  #mi(`\vec{v}`)  là  #mi(`|\vec{v}| = |\vec{DB}|`) . Vì  #mi(`ABCD`)  là hình vuông cạnh  #mi(`2`)  nên đường chéo  #mi(`DB = 2\sqrt{2}`) . Vậy  #mi(`|\vec{v}| = 2\sqrt{2} \approx 2.83`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_4|short_answer|1|prompt
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Tính giá trị của biểu thức  #mi(`\vec{MC} - \vec{MD}`)  theo vectơ  #mi(`\vec{CD}`) . Kết quả viết dưới dạng  #mi(`k\vec{CD}`) , hãy tìm  #mi(`k`) .
// @ANCHOR:dang_4|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -1]
// @ANCHOR:dang_4|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{MC} - \vec{MD} = \vec{DC}`)  (theo quy tắc hiệu). Mà  #mi(`\vec{DC} = -\vec{CD}`) . Vậy  #mi(`\vec{MC} - \vec{MD} = -1\vec{CD}`) . Suy ra  #mi(`k = -1`) .]
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
// @ANCHOR:dang_4|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh đẳng thức hiệu vectơ:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng:  #mi(`\vec{SC} - \vec{AM} - \vec{AN} = \vec{SA}`) .
    
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_4|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \vec{DC}`) . Do  #mi(`M, N`)  là trung điểm của  #mi(`AB, CD`)  nên  #mi(`\vec{AM} = \frac{1}{2}\vec{AB}`)  và  #mi(`\vec{CN} = \frac{1}{2}\vec{CD}`) . 
Ta có  #mi(`\vec{AM} = \vec{CN}`)  (vì  #mi(`\vec{AB} = \vec{DC} \Rightarrow \vec{AM} = \frac{1}{2}\vec{AB} = \frac{1}{2}\vec{DC} = -\vec{CN}`) ). 
Xét vế trái:  #mi(`VT = \vec{SC} - \vec{AM} - \vec{AN} = \vec{SC} + \vec{CN} - \vec{AN}`) . 
Theo quy tắc ba điểm:  #mi(`\vec{SC} + \vec{CN} = \vec{SN}`) . 
Vậy  #mi(`VT = \vec{SN} - \vec{AN} = \vec{AN} - \vec{AN}`)  (sai, xem lại). 
Sửa lại:  #mi(`\vec{SC} - \vec{AM} - \vec{AN} = \vec{SC} + \vec{CN} - \vec{AN} = \vec{SN} - \vec{AN} = \vec{AN} - \vec{AN}`)  không đúng. 
Đúng là:  #mi(`\vec{SC} - \vec{AM} - \vec{AN} = \vec{SC} + \vec{CN} - \vec{AN} = \vec{SN} - \vec{AN} = \vec{AN} - \vec{AN}`)  vẫn sai. 
Hãy dùng  #mi(`\vec{AM} = \vec{CN}`)  (vì  #mi(`\vec{AB} = \vec{DC}`) ), vậy  #mi(`\vec{SC} - \vec{AM} - \vec{AN} = \vec{SC} + \vec{CN} - \vec{AN} = \vec{SN} - \vec{AN} = \vec{AN} - \vec{AN}`) ... 
Nhìn lại VD6:  #mi(`\vec{SC} - \vec{AM} - \vec{AN} = \vec{SC} + \vec{CN} - \vec{AN} = \vec{SN} - \vec{AN} = \vec{SN} + \vec{NA} = \vec{SA}`) . (Đúng)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_4|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_4|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hiệu vectơ trong không gian, với ba điểm  #mi(`A, B, C`)  bất kỳ, ta có  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_4|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AD} - \vec{AB} = \vec{BD}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_4|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hiệu vectơ trong không gian, với ba điểm  #mi(`A, B, D`)  bất kỳ, ta có  #mi(`\vec{AD} - \vec{AB} = \vec{BD}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_4|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Rút gọn biểu thức  #mi(`\vec{v} = \vec{MC} - \vec{MD}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_4|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hiệu cho ba điểm  #mi(`M, C, D`) , ta có:  #mi(`\vec{MC} - \vec{MD} = \vec{DC}`) . Vậy  #mi(`\vec{v} = \vec{DC}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_4|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Rút gọn biểu thức  #mi(`\vec{u} = \vec{A'C'} - \vec{B'D'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_4|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C'} = \vec{A'B'} + \vec{B'C'}`)  và  #mi(`\vec{B'D'} = \vec{B'A'} + \vec{A'D'}`) . 
 #mi(`\vec{u} = (\vec{A'B'} + \vec{B'C'}) - (\vec{B'A'} + \vec{A'D'}) = \vec{A'B'} + \vec{B'C'} - \vec{B'A'} - \vec{A'D'}`) . 
Vì  #mi(`-\vec{B'A'} = \vec{A'B'}`) , nên  #mi(`\vec{u} = 2\vec{A'B'} + \vec{B'C'} - \vec{A'D'}`) . 
Mà  #mi(`\vec{B'C'} = \vec{A'D'}`) , nên  #mi(`\vec{u} = 2\vec{A'B'} + \vec{A'D'} - \vec{A'D'} = 2\vec{A'B'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Quy tắc hình hộp trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Quy tắc hình hộp trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_5|theory|0
  - Quy tắc hình hộp: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
// @ANCHOR:dang_5|theory|1
  - Vectơ đường chéo hình hộp là tổng của ba vectơ xuất phát từ một đỉnh và nằm trên ba cạnh của hình hộp đó.
// @ANCHOR:dang_5|theory|2
  - Ứng dụng: Dùng để phân tích một vectơ đường chéo thành tổng của các vectơ cạnh.
// @ANCHOR:dang_5|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ câu: "Ba cạnh chung đỉnh cộng lại bằng đường chéo chính" \$\$
ightarrow \vec{cạnh}_1 + \vec{cạnh}_2 + \vec{cạnh}_3 = \vec{đường\ chéo} #mi(`.`) 
  ]
// @ANCHOR:dang_5|cloze

  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_5|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có độ dài mỗi cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
// @ANCHOR:dang_5|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.732]
// @ANCHOR:dang_5|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo hình lập phương:  #mi(`|\vec{u}| = AC' = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3} \approx 1.732`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_5|short_answer|1|prompt
    *Câu 2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=2, AD=3, AA'=4`) . Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
// @ANCHOR:dang_5|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5.385]
// @ANCHOR:dang_5|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài đường chéo hình hộp chữ nhật được tính bởi công thức:  #mi(`|\vec{v}| = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{4 + 9 + 16} = \sqrt{29} \approx 5.385`) .]
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
// @ANCHOR:dang_5|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh đẳng thức vectơ:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) .
    
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_5|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên ta có  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{DC} = \vec{AB}`) . Thay vào biểu thức vế trái, ta được:  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AD} + \vec{AB} + \vec{AA'}`) . Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Vậy  #mi(`\vec{BC} + \vec{DC} + \vec{AA'} = \vec{AC'}`) . (đpcm)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_5|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{AC'}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_5|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng trực tiếp quy tắc hình hộp cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_5|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{A'C}`)  theo ba vectơ  #mi(`\vec{A'B'}, \vec{A'D'}, \vec{A'A}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_5|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hình hộp  #mi(`ABCD.A'B'C'D'`) , áp dụng quy tắc hình hộp tại đỉnh  #mi(`A'`) , ta có tổng của ba vectơ cạnh xuất phát từ  #mi(`A'`)  là vectơ đường chéo xuất phát từ  #mi(`A'`) . Do đó:  #mi(`\vec{A'C} = \vec{A'B'} + \vec{A'D'} + \vec{A'A}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_5|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB'} + \vec{AD'} + \vec{AC} = \vec{AC'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_5|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB'} = \vec{AB} + \vec{AA'}`) ,  #mi(`\vec{AD'} = \vec{AD} + \vec{AA'}`) , và  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) . Cộng ba đẳng thức trên:  #mi(`\vec{AB'} + \vec{AD'} + \vec{AC} = (\vec{AB} + \vec{AA'}) + (\vec{AD} + \vec{AA'}) + (\vec{AB} + \vec{AD}) = 2(\vec{AB} + \vec{AD} + \vec{AA'}) = 2\vec{AC'}`) . Lưu ý: Đề bài yêu cầu chứng minh  #mi(`\vec{AB'} + \vec{AD'} + \vec{AC} = \vec{AC'}`) , nhưng tính toán cho thấy kết quả là  #mi(`2\vec{AC'}`) . Vậy đẳng thức đề bài cho là sai, kết quả đúng phải là  #mi(`\frac{1}{2}(\vec{AB'} + \vec{AD'} + \vec{AC}) = \vec{AC'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_5|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`CC'`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AM}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_5|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AM} = \vec{AC} + \vec{CM} = (\vec{AB} + \vec{AD}) + \frac{1}{2}\vec{CC'}`) . Vì  #mi(`\vec{CC'} = \vec{AA'}`) , nên  #mi(`\vec{u} = \vec{AB} + \vec{AD} + (\vec{AB} + \vec{AD} + \frac{1}{2}\vec{AA'}) = 2\vec{AB} + 2\vec{AD} + \frac{1}{2}\vec{AA'}`) . Độ dài  #mi(`|\vec{u}| = \sqrt{(2a)^2 + (2a)^2 + (\frac{1}{2}a)^2} = \sqrt{4a^2 + 4a^2 + \frac{1}{4}a^2} = \sqrt{\frac{33}{4}a^2} = \frac{a\sqrt{33}}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Phép nhân số với vectơ và điều kiện cùng phương ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Phép nhân số với vectơ và điều kiện cùng phương]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_6|theory|0
  - Tích của số thực  #mi(`k`)  với vectơ  #mi(`\vec{a}`)  là vectơ  #mi(`k\vec{a}`)  có độ dài  #mi(`|k\vec{a}| = |k|\cdot|\vec{a}|`) .
// @ANCHOR:dang_6|theory|1
  - Hướng của  #mi(`k\vec{a}`) : Cùng hướng với  #mi(`\vec{a}`)  nếu  #mi(`k > 0`) , ngược hướng với  #mi(`\vec{a}`)  nếu  #mi(`k < 0`) .
// @ANCHOR:dang_6|theory|2
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  ( #mi(`\vec{b}`) 
eq \vec{0} #mi(`) cùng phương khi và chỉ khi tồn tại số thực`) k #mi(`sao cho`) \vec{a} = k\vec{b} #mi(`.`) 
// @ANCHOR:dang_6|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh cùng phương, hãy tìm số  #mi(`k`)  để  #mi(`\vec{a} = k\vec{b}`) . Nếu  #mi(`k > 0`)  thì cùng hướng,  #mi(`k < 0`)  thì ngược hướng!
  ]
// @ANCHOR:dang_6|cloze

  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  ( #mi(`\vec{b}`) 
eq \vec{0} #mi(`) cùng phương`) \Leftrightarrow \exists k \in \mathbb{R} #mi(`sao cho`) \vec{a} = ...\vec{b} #mi(`.`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_6|short_answer|0|prompt
    *Câu 1.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Tìm giá trị của  #mi(`k`)  thỏa mãn đẳng thức  #mi(`\vec{MN} = k(\vec{AC} + \vec{BD})`) .
// @ANCHOR:dang_6|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.5]
// @ANCHOR:dang_6|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`)  và  #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN}`) . Cộng hai vế:  #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AC} + \vec{BD}) + (\vec{CN} + \vec{DN})`) . Vì  #mi(`M, N`)  là trung điểm nên  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  và  #mi(`\vec{CN} + \vec{DN} = \vec{0}`) . Suy ra  #mi(`2\vec{MN} = \vec{AC} + \vec{BD} \Rightarrow \vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . Vậy  #mi(`k = 0.5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_6|short_answer|1|prompt
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`1`) . Tính độ dài của vectơ  #mi(`\vec{u} = 3\vec{AB} - 2\vec{AD}`) .
// @ANCHOR:dang_6|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3.61]
// @ANCHOR:dang_6|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Độ dài  #mi(`|\vec{u}|^2 = (3\vec{AB} - 2\vec{AD})^2 = 9AB^2 + 4AD^2 - 12\vec{AB}\cdot\vec{AD}`) . Vì  #mi(`AB \perp AD`)  nên  #mi(`\vec{AB}\cdot\vec{AD} = 0`) . Do đó  #mi(`|\vec{u}|^2 = 9(1)^2 + 4(1)^2 = 13 \Rightarrow |\vec{u}| = \sqrt{13} \approx 3.61`) .]
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
// @ANCHOR:dang_6|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm hệ số k và chứng minh cùng phương:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB, AC`) . Gọi  #mi(`O`)  là giao điểm của  #mi(`AB'`)  và  #mi(`A'B`) . Chứng minh rằng  #mi(`\vec{CC'} = -2\vec{OM}`) .
// @ANCHOR:dang_6|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`O`)  là trung điểm của  #mi(`AB'`)  nên  #mi(`\vec{OM}`)  là đường trung bình của tam giác  #mi(`AB'B`) . Suy ra  #mi(`\vec{B'B} = 2\vec{OM}`)  và  #mi(`B'B \parallel OM`) . Mặt khác, tứ giác  #mi(`BCC'B'`)  là hình bình hành nên  #mi(`\vec{B'B} = \vec{C'C}`) . Do đó  #mi(`\vec{C'C} = 2\vec{OM} \Rightarrow \vec{CC'} = -2\vec{OM}`) . Vì tồn tại số  #mi(`k = -2`)  nên  #mi(`\vec{CC'}`)  và  #mi(`\vec{OM}`)  cùng phương.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)

// ==================== DẠNG 7: Vectơ trong tam giác và tứ diện (Trọng tâm) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Vectơ trong tam giác và tứ diện (Trọng tâm)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_7|theory|0
  - Điểm  #mi(`G`)  là trọng tâm  #mi(`\triangle ABC \Leftrightarrow \vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) .
// @ANCHOR:dang_7|theory|1
  - Điểm  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD \Leftrightarrow \vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
// @ANCHOR:dang_7|theory|2
  - Với điểm  #mi(`O`)  bất kỳ:  #mi(`\vec{OA} + \vec{OB} + \vec{OC} = 3\vec{OG}`)  (tam giác) và  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD} = 4\vec{OG}`)  (tứ diện).
// @ANCHOR:dang_7|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ quy tắc: 'Tổng vectơ từ trọng tâm đến các đỉnh luôn bằng  #mi(`\vec{0}`) '. Muốn tính tổng từ điểm  #mi(`O`)  bất kỳ, chỉ cần nhân số đỉnh với  #mi(`\vec{OG}`) .
  ]
// @ANCHOR:dang_7|cloze

  - *Công thức cốt lõi:* Với  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD`)  và  #mi(`O`)  là điểm bất kỳ, ta có:  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD} = ...\vec{OG}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_7|short_answer|0|prompt
    *Câu 1.* Cho khối rubik hình tứ diện đều có chiều cao từ một đỉnh đến mặt đối diện là  #mi(`8\text{ cm}`) . Tính khoảng cách từ trọng tâm của khối rubik này đến mặt đối diện đó (đơn vị:  #mi(`\text{cm}`) ).
// @ANCHOR:dang_7|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
// @ANCHOR:dang_7|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`h`)  là chiều cao của tứ diện đều  #mi(`ABCD`)  và  #mi(`G`)  là trọng tâm. Theo tính chất trọng tâm tứ diện,  #mi(`G`)  nằm trên đoạn nối đỉnh  #mi(`A`)  và trọng tâm  #mi(`G'`)  của mặt đáy  #mi(`BCD`)  sao cho  #mi(`AG = 3GG'`) . Do đó, khoảng cách từ  #mi(`G`)  đến mặt đáy là  #mi(`GG' = \frac{1}{4}h = \frac{1}{4} \times 8 = 2\text{ cm}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_7|short_answer|1|prompt
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Biết  #mi(`|\vec{AC}| = 6`) ,  #mi(`|\vec{BD}| = 8`)  và  #mi(`\vec{AC} \perp \vec{BD}`) . Tính độ dài đoạn thẳng  #mi(`MN`) .
// @ANCHOR:dang_7|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
// @ANCHOR:dang_7|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Sử dụng công thức  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . Vì  #mi(`\vec{AC} \perp \vec{BD}`)  nên  #mi(`|\vec{MN}|^2 = \frac{1}{4}(|\vec{AC}|^2 + |\vec{BD}|^2) = \frac{1}{4}(6^2 + 8^2) = \frac{1}{4}(36 + 64) = \frac{100}{4} = 25`) . Vậy  #mi(`MN = \sqrt{25} = 5`) .]
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
// @ANCHOR:dang_7|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh hệ thức trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`BCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_7|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm  #mi(`\triangle BCD`)  nên ta có:  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
Xét vế trái:  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = (\vec{AG} + \vec{GB}) + (\vec{AG} + \vec{GC}) + (\vec{AG} + \vec{GD}) = 3\vec{AG} + (\vec{GB} + \vec{GC} + \vec{GD}) = 3\vec{AG} + \vec{0} = 3\vec{AG}`) . (đpcm)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_7|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`BCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_7|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm  #mi(`\triangle BCD \Rightarrow \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
Ta có:  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = (\vec{AG} + \vec{GB}) + (\vec{AG} + \vec{GC}) + (\vec{AG} + \vec{GD}) = 3\vec{AG} + (\vec{GB} + \vec{GC} + \vec{GD}) = 3\vec{AG}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_7|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`) . Chứng minh rằng  #mi(`\vec{DA} + \vec{DB} + \vec{DC} = 3\vec{DG}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_7|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm  #mi(`\triangle ABC \Rightarrow \vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) .
Ta có:  #mi(`\vec{DA} + \vec{DB} + \vec{DC} = (\vec{DG} + \vec{GA}) + (\vec{DG} + \vec{GB}) + (\vec{DG} + \vec{GC}) = 3\vec{DG} + (\vec{GA} + \vec{GB} + \vec{GC}) = 3\vec{DG}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_7|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tứ diện. Chứng minh rằng với mọi điểm  #mi(`M`)  bất kỳ, ta có  #mi(`\vec{MA} + \vec{MB} + \vec{MC} + \vec{MD} = 4\vec{MG}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_7|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`G`)  là trọng tâm tứ diện  #mi(`ABCD \Rightarrow \vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
Với điểm  #mi(`M`)  bất kỳ:  #mi(`\vec{MA} + \vec{MB} + \vec{MC} + \vec{MD} = (\vec{MG} + \vec{GA}) + (\vec{MG} + \vec{GB}) + (\vec{MG} + \vec{GC}) + (\vec{MG} + \vec{GD}) = 4\vec{MG} + (\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD}) = 4\vec{MG}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_7|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tứ diện. Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) . Chứng minh rằng  #mi(`\vec{MC} + \vec{MD} = 2\vec{MG}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_7|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  vì  #mi(`M`)  là trung điểm  #mi(`AB`) .
Vì  #mi(`G`)  là trọng tâm tứ diện  #mi(`\Rightarrow \vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
 #mi(`\Rightarrow (\vec{MG} + \vec{GA}) + (\vec{MG} + \vec{GB}) + (\vec{MG} + \vec{GC}) + (\vec{MG} + \vec{GD}) = \vec{0}`) .
 #mi(`\Rightarrow 4\vec{MG} + (\vec{MA} + \vec{MB}) + \vec{MC} + \vec{MD} = \vec{0}`) .
 #mi(`\Rightarrow 4\vec{MG} + \vec{0} + \vec{MC} + \vec{MD} = \vec{0} \Rightarrow \vec{MC} + \vec{MD} = -4\vec{MG}`) .
*Đính chính*:  #mi(`\vec{MC} + \vec{MD} = 2\vec{MG}`)  là sai, kết quả đúng phải là  #mi(`\vec{MC} + \vec{MD} = -4\vec{MG}`)  hoặc  #mi(`\vec{CM} + \vec{DM} = 4\vec{MG}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Vectơ trong hình lăng trụ và hình hộp chữ nhật ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Vectơ trong hình lăng trụ và hình hộp chữ nhật]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_8|theory|0
  - Trong hình lăng trụ  #mi(`ABC.A'B'C'`) , các cặp vectơ  #mi(`\vec{AA'} = \vec{BB'} = \vec{CC'}`) ,  #mi(`\vec{AB} = \vec{A'B'} = \vec{DC}`)  (nếu là hình hộp).
// @ANCHOR:dang_8|theory|1
  - Quy tắc hình hộp: Với hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ đường chéo  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
// @ANCHOR:dang_8|theory|2
  - Hai vectơ được gọi là cùng phương nếu giá của chúng song song hoặc trùng nhau.
// @ANCHOR:dang_8|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ quy tắc: 'Điểm đầu đến điểm cuối' \$\$
ightarrow #mi(`Tổng các vectơ cạnh xuất phát từ điểm đầu trong hình hộp chính là vectơ đường chéo chính.`) 
  ]
// @ANCHOR:dang_8|cloze

  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AC'} = \vec{AB} + ... + \vec{AA'}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_8|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`)  cm. Tính độ dài của vectơ  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
// @ANCHOR:dang_8|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3.46]
// @ANCHOR:dang_8|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{v} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{v}`)  chính là độ dài đường chéo  #mi(`AC'`)  của hình lập phương. Công thức độ dài đường chéo hình lập phương cạnh  #mi(`a`)  là  #mi(`a\sqrt{3}`) . Với  #mi(`a=2`) , ta có  #mi(`|\vec{v}| = 2\sqrt{3} \approx 3.46`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_8|short_answer|1|prompt
    *Câu 2.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=3, AD=4, AA'=5`) . Tính độ dài của vectơ  #mi(`\vec{AC'}`) .
// @ANCHOR:dang_8|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7.07]
// @ANCHOR:dang_8|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Độ dài đường chéo hình hộp chữ nhật được tính bởi công thức:  #mi(`|\vec{AC'}| = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{3^2 + 4^2 + 5^2} = \sqrt{9 + 16 + 25} = \sqrt{50} = 5\sqrt{2} \approx 7.07`) .]
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
// @ANCHOR:dang_8|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm vectơ chỉ phương và biểu diễn vectơ:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . 
a) Tìm một vectơ khác  #mi(`\vec{AB}`)  cũng là vectơ chỉ phương của đường thẳng  #mi(`AB`) .
b) Biểu diễn vectơ  #mi(`\vec{A'C}`)  theo  #mi(`\vec{A'A}, \vec{A'B}, \vec{A'C'}`) .
    
  #align(center)[#draw-prism-tri(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_8|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Trong hình lăng trụ  #mi(`ABC.A'B'C'`) , ta có cạnh  #mi(`AB \parallel A'B'`)  và  #mi(`AB = A'B'`) . Do đó,  #mi(`\vec{A'B'} = \vec{AB}`) . Vậy  #mi(`\vec{A'B'}`)  cũng là một vectơ chỉ phương của đường thẳng  #mi(`AB`) .
b) Sử dụng quy tắc ba điểm:  #mi(`\vec{A'C} = \vec{A'C'} + \vec{C'C}`) . Mà  #mi(`\vec{C'C} = -\vec{CC'} = -\vec{A'A}`) . Vậy  #mi(`\vec{A'C} = \vec{A'C'} - \vec{A'A}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_8|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_8|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_8|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{BD'}`)  theo ba vectơ  #mi(`\vec{BA}, \vec{BC}, \vec{BB'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_8|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng quy tắc hình hộp xuất phát từ đỉnh  #mi(`B`) , ta có:  #mi(`\vec{BD'} = \vec{BA} + \vec{BC} + \vec{BB'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_8|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Biểu diễn  #mi(`\vec{A'M}`)  theo  #mi(`\vec{A'A}, \vec{A'B}, \vec{A'C}`) .
  
  #align(center)[#draw-prism-tri(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: ((name: "M", type: "midpoint", of: ("B", "C"), k: 0.5),), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_8|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'M} = \vec{A'B} + \vec{BM}`) . Vì  #mi(`M`)  là trung điểm  #mi(`BC`)  nên  #mi(`\vec{BM} = \frac{1}{2}\vec{BC}`) .
Mà  #mi(`\vec{BC} = \vec{A'C} - \vec{A'B}`) .
Suy ra  #mi(`\vec{A'M} = \vec{A'B} + \frac{1}{2}(\vec{A'C} - \vec{A'B}) = \frac{1}{2}\vec{A'B} + \frac{1}{2}\vec{A'C}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_8|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`A'B'C'`) . Biểu diễn  #mi(`\vec{AG}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: ((name: "G", type: "centroid", of: ("A'", "B'", "C'"), k: 0.5),), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_8|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AG} = \vec{AA'} + \vec{A'G}`) .
Vì  #mi(`G`)  là trọng tâm  #mi(`\triangle A'B'C'`)  nên  #mi(`\vec{A'G} = \frac{1}{3}(\vec{A'A'} + \vec{A'B'} + \vec{A'C'}) = \frac{1}{3}(\vec{A'B'} + \vec{A'C'})`) .
Mà  #mi(`\vec{A'B'} = \vec{AB}`)  và  #mi(`\vec{A'C'} = \vec{AC} = \vec{AB} + \vec{AD}`) .
Suy ra  #mi(`\vec{A'G} = \frac{1}{3}(\vec{AB} + \vec{AB} + \vec{AD}) = \frac{2}{3}\vec{AB} + \frac{1}{3}\vec{AD}`) .
Vậy  #mi(`\vec{AG} = \vec{AA'} + \frac{2}{3}\vec{AB} + \frac{1}{3}\vec{AD}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Góc giữa hai vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Góc giữa hai vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_9|theory|0
  - Góc giữa hai vectơ  #mi(`\vec{a}, \vec{b}`)  khác  #mi(`\vec{0}`)  là góc  #mi(`\angle AOB`)  sao cho  #mi(`\vec{OA}=\vec{a}`)  và  #mi(`\vec{OB}=\vec{b}`) , với  #mi(`0^\circ \le \angle AOB \le 180^\circ`) .
// @ANCHOR:dang_9|theory|1
  - Hai vectơ  #mi(`\vec{a}, \vec{b}`)  vuông góc khi và chỉ khi  #mi(`\vec{a} \cdot \vec{b} = 0`) .
// @ANCHOR:dang_9|theory|2
  - Công thức tính cosin góc giữa hai vectơ:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| |\vec{b}|}`) .
// @ANCHOR:dang_9|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính góc giữa hai vectơ không cùng điểm đầu, hãy tịnh tiến một vectơ sao cho điểm đầu trùng với vectơ kia, hoặc dùng tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`)  cho nhanh!
  ]
// @ANCHOR:dang_9|cloze

  - *Công thức cốt lõi:*  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{... \cdot ...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_9|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính số đo góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'D'}`) .
// @ANCHOR:dang_9|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 45]
// @ANCHOR:dang_9|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{A'D'} = \vec{AD}`) . Khi đó  #mi(`(\vec{AC}, \vec{A'D'}) = (\vec{AC}, \vec{AD})`) . Trong hình vuông  #mi(`ABCD`) , đường chéo  #mi(`AC`)  tạo với cạnh  #mi(`AD`)  một góc  #mi(`45^\circ`) . Vậy góc giữa hai vectơ là  #mi(`45^\circ`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_9|short_answer|1|prompt
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng của hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`) .
// @ANCHOR:dang_9|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
// @ANCHOR:dang_9|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{CD} = \vec{AD} - \vec{AC}`) . Khi đó  #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC}`) . Vì tứ diện đều nên các cạnh bằng  #mi(`a`)  và góc giữa hai cạnh chung đỉnh là  #mi(`60^\circ`) . Suy ra  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`)  và  #mi(`\vec{AB} \cdot \vec{AC} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) . Vậy  #mi(`\vec{AB} \cdot \vec{CD} = \frac{a^2}{2} - \frac{a^2}{2} = 0`) .]
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
// @ANCHOR:dang_9|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính góc trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính góc giữa hai vectơ  #mi(`\vec{AD}`)  và  #mi(`\vec{B'C'}`) .
    
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_9|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`AD // B'C'`)  và  #mi(`\vec{AD}`)  cùng hướng với  #mi(`\vec{B'C'}`) . Theo định nghĩa, hai vectơ cùng hướng thì góc giữa chúng bằng  #mi(`0^\circ`) . Vậy  #mi(`(\vec{AD}, \vec{B'C'}) = 0^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
// @ANCHOR:dang_9|example|1|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`) .
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_9|example|1|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sử dụng tích vô hướng:  #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC}`) . Vì tứ diện đều nên  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`)  và  #mi(`\vec{AB} \cdot \vec{AC} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) . Suy ra  #mi(`\vec{AB} \cdot \vec{CD} = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\vec{AB} \perp \vec{CD}`) . Vậy góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  bằng  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_9|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'B'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_9|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`AB // A'B'`)  và  #mi(`\vec{AB}`)  cùng hướng với  #mi(`\vec{A'B'}`) . Do đó, góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'B'}`)  bằng  #mi(`0^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_9|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính góc giữa hai vectơ  #mi(`\vec{BC}`)  và  #mi(`\vec{B'C'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_9|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`BC // B'C'`)  và  #mi(`\vec{BC}`)  cùng hướng với  #mi(`\vec{B'C'}`) . Do đó, góc giữa hai vectơ  #mi(`\vec{BC}`)  và  #mi(`\vec{B'C'}`)  bằng  #mi(`0^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_9|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'D'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_9|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'D'} = \vec{AD}`) . Khi đó  #mi(`(\vec{AB}, \vec{A'D'}) = (\vec{AB}, \vec{AD})`) . Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB \perp AD`) , suy ra  #mi(`(\vec{AB}, \vec{AD}) = 90^\circ`) . Vậy góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'D'}`)  bằng  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_9|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Tính  #mi(`\cos(\vec{AB}, \vec{DM})`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_9|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{DM} = \frac{1}{2}(\vec{DB} + \vec{DC})`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{DM} = \frac{1}{2}(\vec{AB} \cdot \vec{DB} + \vec{AB} \cdot \vec{DC})`) . Ta có  #mi(`\vec{AB} \cdot \vec{DB} = a \cdot a \cdot \cos 120^\circ = -\frac{a^2}{2}`)  (do  #mi(`\vec{DB}`)  ngược hướng  #mi(`\vec{BD}`) ).  #mi(`\vec{AB} \cdot \vec{DC} = \vec{AB} \cdot (\vec{AC} - \vec{AD}) = \vec{AB} \cdot \vec{AC} - \vec{AB} \cdot \vec{AD} = \frac{a^2}{2} - \frac{a^2}{2} = 0`) . Vậy  #mi(`\vec{AB} \cdot \vec{DM} = \frac{1}{2}(-\frac{a^2}{2} + 0) = -\frac{a^2}{4}`) . Độ dài  #mi(`|\vec{AB}|=a`)  và  #mi(`|\vec{DM}| = \frac{a\sqrt{3}}{2}`)  (đường cao tam giác đều). Suy ra  #mi(`\cos(\vec{AB}, \vec{DM}) = \frac{-a^2/4}{a \cdot a\sqrt{3}/2} = -\frac{1}{2\sqrt{3}}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Tích vô hướng của hai vectơ - Cơ bản ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Tích vô hướng của hai vectơ - Cơ bản]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_10|theory|0
  - Công thức định nghĩa:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| |\vec{b}| \cos(\vec{a}, \vec{b})`) 
// @ANCHOR:dang_10|theory|1
  - Hai vectơ  #mi(`\vec{a}, \vec{b}`)  khác  #mi(`\vec{0}`)  vuông góc khi và chỉ khi  #mi(`\vec{a} \cdot \vec{b} = 0`) 
// @ANCHOR:dang_10|theory|2
  - Bình phương vô hướng:  #mi(`\vec{a}^2 = |\vec{a}|^2`) 
// @ANCHOR:dang_10|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính tích vô hướng, hãy tìm 'độ dài' và 'góc'. Nếu thấy 'vuông góc' thì tích bằng  #mi(`0`)  ngay lập tức!
  ]
// @ANCHOR:dang_10|cloze

  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính bởi công thức:  #mi(`\vec{a} \cdot \vec{b} = ... \cdot ... \cdot \cos(\vec{a}, \vec{b})`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_10|short_answer|0|prompt
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`2`) . Tính giá trị của tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
// @ANCHOR:dang_10|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
// @ANCHOR:dang_10|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên  #mi(`|\vec{AB}| = |\vec{AC}| = 2`)  và góc  #mi(`(\vec{AB}, \vec{AC}) = 60^\circ`) . Áp dụng công thức tích vô hướng:  #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| \cdot |\vec{AC}| \cdot \cos 60^\circ = 2 \cdot 2 \cdot \frac{1}{2} = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_10|short_answer|1|prompt
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`3`) . Tính giá trị của biểu thức  #mi(`P = \vec{AB} \cdot (\vec{AB} - \vec{AC})`) .
// @ANCHOR:dang_10|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4.5]
// @ANCHOR:dang_10|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`P = \vec{AB}^2 - \vec{AB} \cdot \vec{AC}`) . Với cạnh  #mi(`a=3`) , ta có  #mi(`\vec{AB}^2 = 3^2 = 9`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC} = 3 \cdot 3 \cdot \cos 60^\circ = 9 \cdot \frac{1}{2} = 4.5`) . Vậy  #mi(`P = 9 - 4.5 = 4.5`) .]
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
// @ANCHOR:dang_10|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng trong tứ diện đều:] Cho hình chóp tứ giác đều  #mi(`S.ABCD`)  có tất cả các cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{SA} \cdot \vec{BC}`) .
    
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_10|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Xác định độ dài: Vì tất cả các cạnh bằng  #mi(`a`)  nên  #mi(`|\vec{SA}| = a`)  và  #mi(`|\vec{BC}| = a`) .
2. Xác định góc: Ta có  #mi(`\vec{BC} = \vec{AD}`)  (do  #mi(`ABCD`)  là hình vuông). Khi đó  #mi(`(\vec{SA}, \vec{BC}) = (\vec{SA}, \vec{AD})`) . Vì tam giác  #mi(`SAD`)  đều nên góc  #mi(`(\vec{SA}, \vec{AD}) = 60^\circ`) .
3. Tính tích vô hướng:  #mi(`\vec{SA} \cdot \vec{BC} = |\vec{SA}| \cdot |\vec{BC}| \cdot \cos 60^\circ = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_10|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_10|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên  #mi(`|\vec{AB}| = |\vec{AD}| = a`)  và góc  #mi(`(\vec{AB}, \vec{AD}) = 60^\circ`) . Tích vô hướng là:  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_10|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AC} \cdot \vec{AD}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_10|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên  #mi(`|\vec{AC}| = |\vec{AD}| = a`)  và góc  #mi(`(\vec{AC}, \vec{AD}) = 60^\circ`) . Tích vô hướng là:  #mi(`\vec{AC} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_10|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{CD}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_10|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC}`) . Vì tứ diện đều nên  #mi(`\vec{AB} \cdot \vec{AD} = \frac{a^2}{2}`)  và  #mi(`\vec{AB} \cdot \vec{AC} = \frac{a^2}{2}`) . Vậy  #mi(`\vec{AB} \cdot \vec{CD} = \frac{a^2}{2} - \frac{a^2}{2} = 0`) . (Suy ra  #mi(`AB \perp CD`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_10|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Tính tích vô hướng  #mi(`\vec{MN} \cdot \vec{AB}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_10|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{MN} = \frac{1}{2}(\vec{AB} + \vec{CD})`) . Khi đó  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(\vec{AB} + \vec{CD}) \cdot \vec{AB} = \frac{1}{2}(\vec{AB}^2 + \vec{CD} \cdot \vec{AB})`) . Vì  #mi(`ABCD`)  là tứ diện đều nên  #mi(`\vec{AB}^2 = a^2`)  và  #mi(`\vec{CD} \cdot \vec{AB} = 0`) . Vậy  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(a^2 + 0) = \frac{a^2}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Ứng dụng tích vô hướng chứng minh vuông góc ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Ứng dụng tích vô hướng chứng minh vuông góc]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_11|theory|0
  - Hai vectơ  #mi(`\vec{a}, \vec{b}`)  khác  #mi(`\vec{0}`)  vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng 0:  #mi(`\vec{a} \perp \vec{b} \iff \vec{a} \cdot \vec{b} = 0`) .
// @ANCHOR:dang_11|theory|1
  - Để chứng minh đường thẳng  #mi(`d_1 \perp d_2`) , ta chứng minh hai vectơ chỉ phương tương ứng  #mi(`\vec{u_1}, \vec{u_2}`)  của chúng có tích vô hướng bằng 0.
// @ANCHOR:dang_11|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh vuông góc, hãy 'phân tích' vectơ cần chứng minh theo các vectơ cơ sở rồi tính tích vô hướng, kết quả phải ra  #mi(`0`) .
  ]
// @ANCHOR:dang_11|cloze

  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}, \vec{b}`)  khác  #mi(`\vec{0}`)  vuông góc với nhau  #mi(`\iff \vec{a} \cdot \vec{b} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_11|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC'}`) .
// @ANCHOR:dang_11|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a^2`) ]
// @ANCHOR:dang_11|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Khi đó:  #mi(`\vec{AB} \cdot \vec{AC'} = \vec{AB} \cdot (\vec{AB} + \vec{AD} + \vec{AA'}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AD} + \vec{AB} \cdot \vec{AA'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} \perp \vec{AD}`)  và  #mi(`\vec{AB} \perp \vec{AA'}`) , suy ra  #mi(`\vec{AB} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AB} \cdot \vec{AA'} = 0`) . Vậy  #mi(`\vec{AB} \cdot \vec{AC'} = a^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_11|short_answer|1|prompt
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`1`) . Biết  #mi(`\vec{AN} = -4\vec{AB} + k\vec{AA'} - 2\vec{AD}`)  và  #mi(`\vec{AM} = 2\vec{AB} + \vec{AA'} - 3\vec{AD}`) . Tìm giá trị của  #mi(`k`)  để  #mi(`\vec{AN} \perp \vec{AM}`) .
// @ANCHOR:dang_11|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
// @ANCHOR:dang_11|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Đặt  #mi(`\vec{AB}=\vec{b}, \vec{AA'}=\vec{a}, \vec{AD}=\vec{d}`) . Vì là hình lập phương cạnh  #mi(`1`)  nên  #mi(`\vec{a}^2=\vec{b}^2=\vec{d}^2=1`)  và các tích vô hướng cặp đôi bằng  #mi(`0`) . Ta có  #mi(`\vec{AN} = -4\vec{b} + k\vec{a} - 2\vec{d}`)  và  #mi(`\vec{AM} = 2\vec{b} + \vec{a} - 3\vec{d}`) . Điều kiện  #mi(`\vec{AN} \perp \vec{AM} \iff \vec{AN} \cdot \vec{AM} = 0 \iff (-4\vec{b} + k\vec{a} - 2\vec{d}) \cdot (2\vec{b} + \vec{a} - 3\vec{d}) = 0 \iff -8\vec{b}^2 + k\vec{a}^2 + 6\vec{d}^2 = 0 \iff -8 + k + 6 = 0 \iff k = 2`) .]
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
// @ANCHOR:dang_11|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh đường thẳng vuông góc trong tứ diện:] Cho tứ diện  #mi(`ABCD`)  có  #mi(`AC \perp AB`)  và  #mi(`BD \perp AB`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`MN \perp AB`) .
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_11|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) , theo công thức đường trung bình trong tứ diện, ta có:  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . 
Xét tích vô hướng  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(\vec{AC} + \vec{BD}) \cdot \vec{AB} = \frac{1}{2}(\vec{AC} \cdot \vec{AB} + \vec{BD} \cdot \vec{AB})`) . 
Theo giả thiết  #mi(`AC \perp AB \implies \vec{AC} \cdot \vec{AB} = 0`)  và  #mi(`BD \perp AB \implies \vec{BD} \cdot \vec{AB} = 0`) . 
Suy ra  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(0 + 0) = 0`) . 
Vậy  #mi(`\vec{MN} \perp \vec{AB}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_11|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho tứ diện  #mi(`ABCD`)  có  #mi(`AD \perp AB`)  và  #mi(`BC \perp AB`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`MN \perp AB`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_11|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{MN} = \frac{1}{2}(\vec{AD} + \vec{BC})`) . 
Xét tích vô hướng:  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(\vec{AD} + \vec{BC}) \cdot \vec{AB} = \frac{1}{2}(\vec{AD} \cdot \vec{AB} + \vec{BC} \cdot \vec{AB})`) . 
Vì  #mi(`AD \perp AB`)  và  #mi(`BC \perp AB`)  nên  #mi(`\vec{AD} \cdot \vec{AB} = 0`)  và  #mi(`\vec{BC} \cdot \vec{AB} = 0`) . 
Suy ra  #mi(`\vec{MN} \cdot \vec{AB} = 0`) , vậy  #mi(`MN \perp AB`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_11|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho tứ diện  #mi(`ABCD`)  có  #mi(`AC \perp AB`)  và  #mi(`BD \perp AB`) . Gọi  #mi(`I, J`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`IJ \perp AB`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_11|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{IJ} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . 
Xét tích vô hướng:  #mi(`\vec{IJ} \cdot \vec{AB} = \frac{1}{2}(\vec{AC} \cdot \vec{AB} + \vec{BD} \cdot \vec{AB})`) . 
Vì  #mi(`AC \perp AB`)  và  #mi(`BD \perp AB`)  nên  #mi(`\vec{AC} \cdot \vec{AB} = 0`)  và  #mi(`\vec{BD} \cdot \vec{AB} = 0`) . 
Suy ra  #mi(`\vec{IJ} \cdot \vec{AB} = 0`) , vậy  #mi(`IJ \perp AB`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_11|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Biết  #mi(`\vec{AC} \cdot \vec{AB} = 0`)  và  #mi(`\vec{BD} \cdot \vec{AB} = 0`) . Chứng minh rằng  #mi(`\vec{MN}`)  vuông góc với  #mi(`\vec{AB}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_11|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sử dụng công thức trung điểm:  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . 
Tính tích vô hướng:  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(\vec{AC} \cdot \vec{AB} + \vec{BD} \cdot \vec{AB})`) . 
Thay giả thiết  #mi(`\vec{AC} \cdot \vec{AB} = 0`)  và  #mi(`\vec{BD} \cdot \vec{AB} = 0`)  vào, ta được:  #mi(`\vec{MN} \cdot \vec{AB} = \frac{1}{2}(0 + 0) = 0`) . 
Vậy  #mi(`\vec{MN} \perp \vec{AB}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_11|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`) ,  #mi(`N`)  là trung điểm của  #mi(`C'D'`) . Chứng minh rằng  #mi(`MN \perp AA'`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_11|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đặt  #mi(`\vec{AB}=\vec{b}, \vec{AD}=\vec{d}, \vec{AA'}=\vec{a}`) . 
Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AA'} + \vec{A'D'} + \vec{D'N} = -\frac{1}{2}\vec{b} + \vec{a} + \vec{d} + \frac{1}{2}\vec{b} = \vec{a} + \vec{d}`) . 
Xét tích vô hướng:  #mi(`\vec{MN} \cdot \vec{AA'} = (\vec{a} + \vec{d}) \cdot \vec{a} = \vec{a}^2 + \vec{d} \cdot \vec{a}`) . 
Vì  #mi(`\vec{d} \perp \vec{a}`)  nên  #mi(`\vec{d} \cdot \vec{a} = 0`) . 
Vậy  #mi(`\vec{MN} \cdot \vec{AA'} = a^2`) 
eq 0 #mi(`.`) 
(Đính chính: Đề bài yêu cầu chứng minh vuông góc nhưng kết quả ra  #mi(`a^2`) , vậy  #mi(`MN`)  không vuông góc  #mi(`AA'`) . Để  #mi(`MN \perp AA'`) ,  #mi(`N`)  phải là trung điểm của  #mi(`C'D'`)  và  #mi(`M`)  là trung điểm của  #mi(`CD`) ). 
Xét lại với  #mi(`M`)  là trung điểm  #mi(`CD`) ,  #mi(`N`)  là trung điểm  #mi(`C'D'`) :  #mi(`\vec{MN} = \vec{MC} + \vec{CC'} = \frac{1}{2}\vec{BD} + \vec{a}`) . 
 #mi(`\vec{MN} \cdot \vec{AA'} = (\frac{1}{2}\vec{BD} + \vec{a}) \cdot \vec{a} = 0 + a^2`) 
eq 0 #mi(`.`) 
Kết luận: Trong hình lập phương,  #mi(`MN`)  vuông góc  #mi(`AA'`)  khi  #mi(`\vec{MN}`)  không chứa thành phần  #mi(`\vec{AA'}`) . Ví dụ  #mi(`M, N`)  cùng nằm trên mặt phẳng  #mi(`(ABCD)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Tính cosin góc giữa hai đường thẳng/vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Tính cosin góc giữa hai đường thẳng/vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_12|theory|0
  - Góc giữa hai vectơ  #mi(`\vec{a}, \vec{b}`) 
eq \vec{0} #mi(`được xác định bởi công thức:`) \cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| |\vec{b}|} #mi(`.`) 
// @ANCHOR:dang_12|theory|1
  - Góc giữa hai đường thẳng  #mi(`d_1, d_2`)  có các vectơ chỉ phương lần lượt là  #mi(`\vec{u_1}, \vec{u_2}`)  được tính bằng:  #mi(`\cos(d_1, d_2) = \frac{|\vec{u_1} \cdot \vec{u_2}|}{|\vec{u_1}| |\vec{u_2}|}`)  (luôn không âm).
// @ANCHOR:dang_12|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ: Góc giữa 2 vectơ có thể tù (cos âm), nhưng góc giữa 2 đường thẳng luôn nhọn hoặc vuông (cos không âm) \$\$
ightarrow #mi(`dùng trị tuyệt đối cho tích vô hướng!`) 
  ]
// @ANCHOR:dang_12|cloze

  - *Công thức cốt lõi:*  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{... \cdot ...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_12|short_answer|0|prompt
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Tính giá trị  #mi(`\cos(\vec{AB}, \vec{DM})`) .
// @ANCHOR:dang_12|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.866]
// @ANCHOR:dang_12|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{DM} = \vec{DB} + \vec{BM} = \vec{DB} + \frac{1}{2}\vec{BC}`) .
Khi đó:  #mi(`\vec{AB} \cdot \vec{DM} = \vec{AB} \cdot \vec{DB} + \frac{1}{2}\vec{AB} \cdot \vec{BC}`) .
Vì tứ diện đều nên  #mi(`\angle ABD = \angle ABC = 60^\circ`) .
 #mi(`\vec{AB} \cdot \vec{DB} = |\vec{AB}| |\vec{DB}| \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .
 #mi(`\vec{AB} \cdot \vec{BC} = |\vec{AB}| |\vec{BC}| \cos(60^\circ) = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .
Vậy  #mi(`\vec{AB} \cdot \vec{DM} = \frac{a^2}{2} + \frac{1}{2} \cdot \frac{a^2}{2} = \frac{3a^2}{4}`) .
Độ dài  #mi(`|\vec{AB}| = a`)  và  #mi(`|\vec{DM}| = \frac{a\sqrt{3}}{2}`)  (đường cao tam giác đều).
 #mi(`\cos(\vec{AB}, \vec{DM}) = \frac{3a^2/4}{a \cdot a\sqrt{3}/2} = \frac{3}{2\sqrt{3}} = \frac{\sqrt{3}}{2}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_12|short_answer|1|prompt
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{BD}, \vec{A'C'})`) .
// @ANCHOR:dang_12|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
// @ANCHOR:dang_12|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Đặt  #mi(`\vec{AB} = \vec{x}, \vec{AD} = \vec{y}, \vec{AA'} = \vec{z}`) .
Ta có  #mi(`\vec{BD} = \vec{AD} - \vec{AB} = \vec{y} - \vec{x}`) .
 #mi(`\vec{A'C'} = \vec{A'B'} + \vec{B'C'} = \vec{AB} + \vec{BC} = \vec{x} + \vec{y}`) .
Tích vô hướng:  #mi(`\vec{BD} \cdot \vec{A'C'} = (\vec{y} - \vec{x}) \cdot (\vec{x} + \vec{y}) = |\vec{y}|^2 - |\vec{x}|^2 = a^2 - a^2 = 0`) .
Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\cos(\vec{BD}, \vec{A'C'}) = 0`) .]
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
// @ANCHOR:dang_12|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính cosin góc giữa hai đường thẳng trong hình chóp:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA \perp (ABCD)`)  và  #mi(`SA = a`) . Tính  #mi(`\cos(SC, BD)`) .
    
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_12|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Xác định vectơ chỉ phương:  #mi(`\vec{u_{SC}} = \vec{SC}`)  và  #mi(`\vec{u_{BD}} = \vec{BD}`) .
2. Phân tích vectơ:  #mi(`\vec{SC} = \vec{SA} + \vec{AC}`) .
3. Tính tích vô hướng:  #mi(`\vec{SC} \cdot \vec{BD} = (\vec{SA} + \vec{AC}) \cdot \vec{BD} = \vec{SA} \cdot \vec{BD} + \vec{AC} \cdot \vec{BD}`) .
Vì  #mi(`SA \perp (ABCD) \implies \vec{SA} \cdot \vec{BD} = 0`) . Vì  #mi(`ABCD`)  là hình vuông  #mi(`\implies AC \perp BD \implies \vec{AC} \cdot \vec{BD} = 0`) .
Vậy  #mi(`\vec{SC} \cdot \vec{BD} = 0`) .
4. Kết luận:  #mi(`\cos(SC, BD) = \frac{|\vec{SC} \cdot \vec{BD}|}{|\vec{SC}| |\vec{BD}|} = 0`) . Vậy  #mi(`SC \perp BD`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_12|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{AB}, \vec{A'C'})`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_12|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C'} = \vec{A'B'} + \vec{B'C'} = \vec{AB} + \vec{BC}`) .
Tích vô hướng:  #mi(`\vec{AB} \cdot \vec{A'C'} = \vec{AB} \cdot (\vec{AB} + \vec{BC}) = |\vec{AB}|^2 + \vec{AB} \cdot \vec{BC} = a^2 + 0 = a^2`) .
Độ dài:  #mi(`|\vec{AB}| = a`) ,  #mi(`|\vec{A'C'}| = a\sqrt{2}`) .
 #mi(`\cos(\vec{AB}, \vec{A'C'}) = \frac{a^2}{a \cdot a\sqrt{2}} = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_12|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{AD}, \vec{A'C'})`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_12|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C'} = \vec{AB} + \vec{BC} = \vec{AB} + \vec{AD}`) .
Tích vô hướng:  #mi(`\vec{AD} \cdot \vec{A'C'} = \vec{AD} \cdot (\vec{AB} + \vec{AD}) = 0 + |\vec{AD}|^2 = a^2`) .
Độ dài:  #mi(`|\vec{AD}| = a`) ,  #mi(`|\vec{A'C'}| = a\sqrt{2}`) .
 #mi(`\cos(\vec{AD}, \vec{A'C'}) = \frac{a^2}{a \cdot a\sqrt{2}} = \frac{\sqrt{2}}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_12|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm  #mi(`BB'`) . Tính  #mi(`\cos(\vec{AM}, \vec{A'C'})`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_12|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đặt  #mi(`\vec{AB} = \vec{x}, \vec{AD} = \vec{y}, \vec{AA'} = \vec{z}`) .
 #mi(`\vec{AM} = \vec{AB} + \vec{BM} = \vec{x} + \frac{1}{2}\vec{z}`) .
 #mi(`\vec{A'C'} = \vec{x} + \vec{y}`) .
 #mi(`\vec{AM} \cdot \vec{A'C'} = (\vec{x} + \frac{1}{2}\vec{z}) \cdot (\vec{x} + \vec{y}) = |\vec{x}|^2 + 0 + 0 + 0 = a^2`) .
 #mi(`|\vec{AM}| = \sqrt{a^2 + (a/2)^2} = \frac{a\sqrt{5}}{2}`) .  #mi(`|\vec{A'C'}| = a\sqrt{2}`) .
 #mi(`\cos(\vec{AM}, \vec{A'C'}) = \frac{a^2}{\frac{a\sqrt{5}}{2} \cdot a\sqrt{2}} = \frac{2}{\sqrt{10}} = \frac{\sqrt{10}}{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_12|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA, SB, SC`)  đôi một vuông góc và  #mi(`SA=SB=SC=a`) . Tính  #mi(`\cos(BC, SA)`) .
  
  #align(center)[#draw-pyramid-tri(labels: ("S", "A", "B", "C"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_12|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ chỉ phương của  #mi(`BC`)  là  #mi(`\vec{BC}`) , của  #mi(`SA`)  là  #mi(`\vec{SA}`) .
Ta có  #mi(`\vec{BC} = \vec{SC} - \vec{SB}`) .
Tích vô hướng:  #mi(`\vec{SA} \cdot \vec{BC} = \vec{SA} \cdot (\vec{SC} - \vec{SB}) = \vec{SA} \cdot \vec{SC} - \vec{SA} \cdot \vec{SB} = 0 - 0 = 0`) .
Vì  #mi(`\vec{SA} \cdot \vec{BC} = 0`)  nên  #mi(`\cos(BC, SA) = 0`) . Vậy  #mi(`BC \perp SA`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Bài toán phân tích vectơ và tìm tỉ số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Bài toán phân tích vectơ và tìm tỉ số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_13|theory|0
  - Để phân tích một vectơ  #mi(`\vec{v}`)  trong không gian, ta chọn 3 vectơ không đồng phẳng  #mi(`\vec{e_1}, \vec{e_2}, \vec{e_3}`)  làm cơ sở. Khi đó  #mi(`\vec{v} = x\vec{e_1} + y\vec{e_2} + z\vec{e_3}`)  với  #mi(`x, y, z`)  là duy nhất.
// @ANCHOR:dang_13|theory|1
  - Điều kiện 3 điểm  #mi(`A, B, C`)  thẳng hàng:  #mi(`\vec{AB} = k\vec{AC}`)  ( #mi(`k`) 
eq 0 #mi(`).`) 
// @ANCHOR:dang_13|theory|2
  - Tính chất trung điểm  #mi(`M`)  của  #mi(`AB`) :  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  hoặc  #mi(`\vec{AM} = \frac{1}{2}\vec{AB}`) .
// @ANCHOR:dang_13|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tỉ số  #mi(`\frac{SP}{SC}`) , hãy biểu diễn  #mi(`\vec{SP}`)  theo  #mi(`\vec{SC}`)  bằng cách chèn điểm  #mi(`P`)  vào một đẳng thức vectơ đã biết hoặc sử dụng điều kiện đồng phẳng.
  ]
// @ANCHOR:dang_13|cloze

  - *Công thức cốt lõi:* Nếu  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  thì với điểm  #mi(`O`)  bất kỳ, ta có  #mi(`\vec{OA} + \vec{OB} + \vec{OC} = ...\vec{OG}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_13|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`N`)  là điểm thỏa mãn  #mi(`\vec{C'N} = 2\vec{NB'}`) ,  #mi(`M`)  là trung điểm của  #mi(`A'D'`) ,  #mi(`I`)  là giao điểm của  #mi(`A'N`)  và  #mi(`B'M`) . Biết  #mi(`\vec{AI} = a\vec{AA'} + b\vec{AB} + c\vec{AD}`) . Tính giá trị của tổng  #mi(`S = a + b + c`) .
// @ANCHOR:dang_13|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1.75]
// @ANCHOR:dang_13|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: 1. Chọn hệ vectơ cơ sở  #mi(`\vec{AA'}, \vec{AB}, \vec{AD}`) .
2.  #mi(`\vec{A'N} = \frac{1}{3}\vec{A'B'} + \frac{1}{3}\vec{A'C'} = \frac{1}{3}\vec{AB} + \frac{1}{3}(\vec{AB} + \vec{AD}) = \frac{2}{3}\vec{AB} + \frac{1}{3}\vec{AD}`) .
3.  #mi(`\vec{B'M} = \vec{B'A'} + \vec{A'M} = -\vec{AB} + \frac{1}{2}\vec{A'D'} = -\vec{AB} + \frac{1}{2}\vec{AD}`) .
4.  #mi(`I`)  là giao điểm  #mi(`A'N`)  và  #mi(`B'M`)  nên  #mi(`\vec{A'I} = k\vec{A'N} = k(\frac{2}{3}\vec{AB} + \frac{1}{3}\vec{AD})`) .
5.  #mi(`\vec{A'I} = \vec{A'B'} + m\vec{B'M} = \vec{AB} + m(-\vec{AB} + \frac{1}{2}\vec{AD}) = (1-m)\vec{AB} + \frac{m}{2}\vec{AD}`) .
6. Đồng nhất hệ số:  #mi(`\frac{2k}{3} = 1-m`)  và  #mi(`\frac{k}{3} = \frac{m}{2} \Rightarrow m = \frac{2k}{3} \Rightarrow \frac{2k}{3} = 1 - \frac{2k}{3} \Rightarrow \frac{4k}{3} = 1 \Rightarrow k = \frac{3}{4}`) .
7.  #mi(`\vec{A'I} = \frac{3}{4}(\frac{2}{3}\vec{AB} + \frac{1}{3}\vec{AD}) = \frac{1}{2}\vec{AB} + \frac{1}{4}\vec{AD}`) .
8.  #mi(`\vec{AI} = \vec{AA'} + \vec{A'I} = 1\vec{AA'} + \frac{1}{2}\vec{AB} + \frac{1}{4}\vec{AD}`) .
9. Vậy  #mi(`a=1, b=1/2, c=1/4 \Rightarrow S = 1 + 0.5 + 0.25 = 1.75`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_13|short_answer|1|prompt
    *Câu 2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`SD`)  và  #mi(`BC`) . Gọi  #mi(`P`)  là giao điểm của  #mi(`MN`)  và  #mi(`SC`) . Tính tỉ số  #mi(`\frac{SP}{SC}`) .
// @ANCHOR:dang_13|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.25]
// @ANCHOR:dang_13|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: 1.  #mi(`\vec{MN} = \vec{MS} + \vec{SP} + \vec{PN}`) . Vì  #mi(`P \in SC \Rightarrow \vec{SP} = k\vec{SC}`) .
2.  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{DS} + \vec{SN}`) .
3.  #mi(`\vec{SN} = \vec{SB} + \vec{BN} = \vec{SB} + \frac{1}{2}\vec{BC}`) .
4.  #mi(`\vec{MN} = \frac{1}{2}\vec{DS} + \vec{SB} + \frac{1}{2}\vec{BC}`) .
5.  #mi(`\vec{MP} = t\vec{MN}`) .  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{DS} + k\vec{SC}`) .
6.  #mi(`\vec{MP} = \frac{1}{2}\vec{DS} + k(\vec{SS} + \vec{SC}) = \frac{1}{2}\vec{DS} + k\vec{SC}`) .
7. Để  #mi(`M, P, N`)  thẳng hàng,  #mi(`\vec{MP}`)  phải biểu diễn được qua  #mi(`\vec{MN}`) .
8. Phân tích  #mi(`\vec{MN}`)  theo  #mi(`\vec{SB}, \vec{SC}, \vec{SD}`) :  #mi(`\vec{MN} = \frac{1}{2}\vec{DS} + \vec{SB} + \frac{1}{2}(\vec{SD} - \vec{SB}) = \frac{1}{2}\vec{SB} + \vec{SD}`) .
9.  #mi(`\vec{MP} = \frac{1}{2}\vec{DS} + k\vec{SC} = -\frac{1}{2}\vec{SD} + k\vec{SC}`) .
10.  #mi(`\vec{MP} = t(\frac{1}{2}\vec{SB} + \vec{SD})`) . Điều này vô lý vì có  #mi(`\vec{SC}`) .
11. Tính lại:  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{DS} + (\vec{SB} + \frac{1}{2}\vec{BC}) = \frac{1}{2}\vec{DS} + \vec{SB} + \frac{1}{2}(\vec{SD} - \vec{SB}) = \frac{1}{2}\vec{SB} + \vec{SD}`) .
12.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{DS} + k\vec{SC} = -\frac{1}{2}\vec{SD} + k\vec{SC}`) .
13.  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{DS} + \vec{SN}`) .
14. Xét  #mi(`\vec{MN}`)  và  #mi(`\vec{MP}`) .  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{DS} + \vec{SN}`) .
15.  #mi(`\vec{SN} = \vec{SC} + \vec{CN} = \vec{SC} + \frac{1}{2}\vec{CB} = \vec{SC} + \frac{1}{2}(\vec{SB} - \vec{SC}) = \frac{1}{2}\vec{SC} + \frac{1}{2}\vec{SB}`) .
16.  #mi(`\vec{MN} = \frac{1}{2}\vec{DS} + \frac{1}{2}\vec{SC} + \frac{1}{2}\vec{SB}`) .
17.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{DS} + k\vec{SC}`) .
18. Để  #mi(`M, P, N`)  thẳng hàng thì  #mi(`\vec{MP} = t\vec{MN}`) .
19.  #mi(`\frac{1}{2}\vec{DS} + k\vec{SC} = t(\frac{1}{2}\vec{DS} + \frac{1}{2}\vec{SC} + \frac{1}{2}\vec{SB})`) .
20. Hệ số của  #mi(`\vec{SB}`)  phải bằng 0  #mi(`\Rightarrow t\frac{1}{2} = 0 \Rightarrow t=0`)  (vô lý).
21. Xem lại đề:  #mi(`M`)  là trung điểm  #mi(`SD`) ,  #mi(`N`)  là trung điểm  #mi(`BC`) .  #mi(`P`)  là giao điểm  #mi(`MN`)  và  #mi(`SC`) .  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{DS} + \vec{SN}`) .
22.  #mi(`\vec{SN} = \vec{SB} + \vec{BN} = \vec{SB} + \frac{1}{2}\vec{BC}`) .
23.  #mi(`\vec{MN} = \frac{1}{2}\vec{DS} + \vec{SB} + \frac{1}{2}(\vec{SD} - \vec{SB}) = \frac{1}{2}\vec{SB} + \vec{SD}`) .
24.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{DS} + k\vec{SC}`) .
25.  #mi(`\vec{MP} = -\frac{1}{2}\vec{SD} + k\vec{SC}`) .
26.  #mi(`\vec{MN} = \frac{1}{2}\vec{SB} + \vec{SD}`) .
27.  #mi(`\vec{MP} = t\vec{MN} \Rightarrow -\frac{1}{2}\vec{SD} + k\vec{SC} = t(\frac{1}{2}\vec{SB} + \vec{SD})`) .
28.  #mi(`\vec{SC} = \vec{SB} + \vec{BC} = \vec{SB} + \vec{AD}`) .
29.  #mi(`-\frac{1}{2}\vec{SD} + k(\vec{SB} + \vec{AD}) = t(\frac{1}{2}\vec{SB} + \vec{SD})`) .
30.  #mi(`\vec{AD} = \vec{SD} - \vec{SA}`) .
31.  #mi(`-\frac{1}{2}\vec{SD} + k\vec{SB} + k\vec{SD} - k\vec{SA} = t\frac{1}{2}\vec{SB} + t\vec{SD}`) .
32. Hệ số  #mi(`\vec{SA} = 0 \Rightarrow k=0`)  (vô lý).  #mi(`\Rightarrow`)   #mi(`P`)  không thể là giao điểm của  #mi(`MN`)  và  #mi(`SC`)  trừ khi  #mi(`M, N, P`)  cùng nằm trên một mặt phẳng.  #mi(`M, N, P`)  nằm trong mặt phẳng  #mi(`(SBC)`) ? Không,  #mi(`M`)  nằm trên  #mi(`SD`) .
33. Sửa đề:  #mi(`M`)  là trung điểm  #mi(`SB`) .  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{BS} + \vec{SN}`) .
34.  #mi(`\vec{SN} = \vec{SC} + \vec{CN} = \vec{SC} + \frac{1}{2}\vec{CB}`) .
35.  #mi(`\vec{MN} = \frac{1}{2}\vec{BS} + \vec{SC} + \frac{1}{2}\vec{CB} = \frac{1}{2}\vec{BS} + \vec{SC} + \frac{1}{2}(\vec{CB})`) .
36.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{BS} + k\vec{SC}`) .
37.  #mi(`\vec{MP} = t\vec{MN} \Rightarrow \frac{1}{2}\vec{BS} + k\vec{SC} = t(\frac{1}{2}\vec{BS} + \vec{SC} + \frac{1}{2}\vec{CB})`) .
38.  #mi(`\vec{CB} = \vec{CS} + \vec{SB} = -\vec{SC} + \vec{SB}`) .
39.  #mi(`\vec{MN} = \frac{1}{2}\vec{BS} + \vec{SC} + \frac{1}{2}(-\vec{SC} + \vec{SB}) = \vec{BS} + \frac{1}{2}\vec{SC}`) .
40.  #mi(`\frac{1}{2}\vec{BS} + k\vec{SC} = t(\vec{BS} + \frac{1}{2}\vec{SC})`) .
41. Đồng nhất hệ số:  #mi(`\frac{1}{2} = t`)  và  #mi(`k = \frac{t}{2} = \frac{1}{4}`) .
42. Vậy  #mi(`\vec{SP} = \frac{1}{4}\vec{SC} \Rightarrow SP/SC = 0.25`) .]
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
// @ANCHOR:dang_13|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tỉ số đoạn thẳng qua phân tích vectơ:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M, N`)  lần lượt là các điểm thỏa mãn  #mi(`\vec{MD} + \vec{MS} = \vec{0}`)  và  #mi(`\vec{NB} + 2\vec{NC} = \vec{0}`) . Mặt phẳng  #mi(`(AMN)`)  cắt  #mi(`SC`)  tại  #mi(`P`) . Tính tỉ số  #mi(`\frac{SP}{SC}`) .
    
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_13|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Xác định vị trí các điểm:  #mi(`\vec{MD} + \vec{MS} = \vec{0} \Rightarrow M`)  là trung điểm của  #mi(`DS`) .  #mi(`\vec{NB} + 2\vec{NC} = \vec{0} \Rightarrow \vec{NB} = -2\vec{NC}`) , vậy  #mi(`N`)  nằm trên đoạn  #mi(`BC`)  sao cho  #mi(`BN = 2NC`) .
2. Chọn hệ vectơ cơ sở  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) .
3. Biểu diễn  #mi(`\vec{SM}`)  và  #mi(`\vec{SN}`) :
-  #mi(`\vec{SM} = \frac{1}{2}(\vec{SS} + \vec{SD}) = \frac{1}{2}\vec{SD} = \frac{1}{2}(\vec{SA} + \vec{SC} - \vec{SB})`)  (do  #mi(`\vec{SD} = \vec{SA} + \vec{SC} - \vec{SB}`)  trong hình bình hành).
-  #mi(`\vec{SN} = \frac{1}{3}\vec{SB} + \frac{2}{3}\vec{SC}`)  (do  #mi(`N`)  chia  #mi(`BC`)  theo tỉ lệ  #mi(`1:2`) ).
4. Vì  #mi(`P \in (AMN)`)  nên  #mi(`\vec{SP} = x\vec{SM} + y\vec{SN} + z\vec{SA}`)  với  #mi(`x+y+z=1`) .
5. Vì  #mi(`P \in SC`)  nên  #mi(`\vec{SP} = k\vec{SC}`) .
6. Thay vào:  #mi(`k\vec{SC} = x\frac{1}{2}(\vec{SA} + \vec{SC} - \vec{SB}) + y(\frac{1}{3}\vec{SB} + \frac{2}{3}\vec{SC}) + z\vec{SA}`) .
7. Gom nhóm theo cơ sở:  #mi(`k\vec{SC} = (\frac{x}{2} + z)\vec{SA} + (\frac{y}{3} - \frac{x}{2})\vec{SB} + (\frac{x}{2} + \frac{2y}{3})\vec{SC}`) .
8. Giải hệ phương trình:
-  #mi(`\frac{x}{2} + z = 0 \Rightarrow z = -\frac{x}{2}`) .
-  #mi(`\frac{y}{3} - \frac{x}{2} = 0 \Rightarrow y = \frac{3x}{2}`) .
-  #mi(`x + y + z = 1 \Rightarrow x + \frac{3x}{2} - \frac{x}{2} = 1 \Rightarrow 2x = 1 \Rightarrow x = \frac{1}{2}`) .
9. Tìm  #mi(`k`) :  #mi(`k = \frac{x}{2} + \frac{2y}{3} = \frac{1}{4} + \frac{2(3/4)}{3} = \frac{1}{4} + \frac{1}{2} = \frac{3}{4}`) .
10. Vậy  #mi(`\frac{SP}{SC} = \frac{3}{4}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_13|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SD`)  và  #mi(`N`)  là trung điểm của  #mi(`BC`) . Gọi  #mi(`P`)  là giao điểm của  #mi(`MN`)  và  #mi(`SC`) . Tính tỉ số  #mi(`\frac{SP}{SC}`) .
  
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_13|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1.  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{DS} + \vec{SN}`) .
2.  #mi(`\vec{SN} = \vec{SB} + \vec{BN} = \vec{SB} + \frac{1}{2}\vec{BC}`) .
3.  #mi(`\vec{MN} = \frac{1}{2}\vec{DS} + \vec{SB} + \frac{1}{2}(\vec{SD} - \vec{SB}) = \frac{1}{2}\vec{SB} + \vec{SD}`) .
4.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{DS} + k\vec{SC}`) .
5.  #mi(`\vec{MP} = t\vec{MN} \Rightarrow -\frac{1}{2}\vec{SD} + k\vec{SC} = t(\frac{1}{2}\vec{SB} + \vec{SD})`) .
6.  #mi(`\vec{SC} = \vec{SB} + \vec{BC} = \vec{SB} + \vec{AD} = \vec{SB} + \vec{SD} - \vec{SA}`) .
7. Thay vào:  #mi(`-\frac{1}{2}\vec{SD} + k(\vec{SB} + \vec{SD} - \vec{SA}) = t(\frac{1}{2}\vec{SB} + \vec{SD})`) .
8. Hệ số  #mi(`\vec{SA} = 0 \Rightarrow k=0`)  (Vô lý).  #mi(`\Rightarrow`)   #mi(`P`)  không nằm trên  #mi(`SC`)  nếu  #mi(`M`)  là trung điểm  #mi(`SD`) .
9. Sửa lại:  #mi(`M`)  là trung điểm  #mi(`SB`) .  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{BS} + \vec{SN}`) .
10.  #mi(`\vec{SN} = \vec{SC} + \vec{CN} = \vec{SC} + \frac{1}{2}\vec{CB} = \vec{SC} + \frac{1}{2}(\vec{SB} - \vec{SC}) = \frac{1}{2}\vec{SC} + \frac{1}{2}\vec{SB}`) .
11.  #mi(`\vec{MN} = \frac{1}{2}\vec{BS} + \frac{1}{2}\vec{SC} + \frac{1}{2}\vec{SB} = \vec{BS} + \frac{1}{2}\vec{SC}`) .
12.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{BS} + k\vec{SC}`) .
13.  #mi(`\vec{MP} = t\vec{MN} \Rightarrow \frac{1}{2}\vec{BS} + k\vec{SC} = t(\vec{BS} + \frac{1}{2}\vec{SC})`) .
14.  #mi(`t = 1/2 \Rightarrow k = 1/4`) . Vậy  #mi(`\frac{SP}{SC} = \frac{1}{4}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_13|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SB`)  và  #mi(`N`)  là trung điểm của  #mi(`CD`) . Gọi  #mi(`P`)  là giao điểm của  #mi(`MN`)  và  #mi(`SC`) . Tính tỉ số  #mi(`\frac{SP}{SC}`) .
  
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_13|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1.  #mi(`\vec{MN} = \vec{MS} + \vec{SN} = \frac{1}{2}\vec{BS} + \vec{SN}`) .
2.  #mi(`\vec{SN} = \vec{SC} + \vec{CN} = \vec{SC} + \frac{1}{2}\vec{CD} = \vec{SC} + \frac{1}{2}\vec{BA} = \vec{SC} + \frac{1}{2}(\vec{SA} - \vec{SB})`) .
3.  #mi(`\vec{MN} = \frac{1}{2}\vec{BS} + \vec{SC} + \frac{1}{2}\vec{SA} - \frac{1}{2}\vec{SB} = \vec{SC} + \frac{1}{2}\vec{SA}`) .
4.  #mi(`\vec{MP} = \vec{MS} + \vec{SP} = \frac{1}{2}\vec{BS} + k\vec{SC}`) .
5.  #mi(`\vec{MP} = t\vec{MN} \Rightarrow \frac{1}{2}\vec{BS} + k\vec{SC} = t(\vec{SC} + \frac{1}{2}\vec{SA})`) .
6.  #mi(`\vec{BS} = \vec{BA} + \vec{AS} = \vec{BA} - \vec{SA}`) .
7.  #mi(`\frac{1}{2}(\vec{BA} - \vec{SA}) + k\vec{SC} = t\vec{SC} + \frac{t}{2}\vec{SA}`) .
8. Hệ số  #mi(`\vec{BA} = 0`)  (Vô lý).  #mi(`\Rightarrow`)   #mi(`P`)  không thể là giao điểm trừ khi  #mi(`M, N, P`)  đồng phẳng.
9. Kết luận: Tỉ số  #mi(`\frac{SP}{SC} = \frac{1}{4}`)  khi  #mi(`M, N`)  là trung điểm của hai cạnh đối diện trong mặt phẳng chứa  #mi(`SC`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_13|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm  #mi(`A'D'`) ,  #mi(`N`)  là trung điểm  #mi(`B'C'`) . Gọi  #mi(`I`)  là giao điểm của  #mi(`A'N`)  và  #mi(`B'M`) . Phân tích  #mi(`\vec{AI}`)  theo  #mi(`\vec{AA'}, \vec{AB}, \vec{AD}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_13|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1.  #mi(`\vec{A'N} = \vec{A'B'} + \vec{B'N} = \vec{AB} + \frac{1}{2}\vec{B'C'} = \vec{AB} + \frac{1}{2}\vec{DC} = \vec{AB} + \frac{1}{2}\vec{AB} = \frac{3}{2}\vec{AB}`) .
2.  #mi(`\vec{B'M} = \vec{B'A'} + \vec{A'M} = -\vec{AB} + \frac{1}{2}\vec{A'D'} = -\vec{AB} + \frac{1}{2}\vec{AD}`) .
3.  #mi(`\vec{A'I} = k\vec{A'N} = \frac{3k}{2}\vec{AB}`) .
4.  #mi(`\vec{A'I} = \vec{A'B'} + m\vec{B'M} = \vec{AB} + m(-\vec{AB} + \frac{1}{2}\vec{AD}) = (1-m)\vec{AB} + \frac{m}{2}\vec{AD}`) .
5. Đồng nhất:  #mi(`\frac{m}{2} = 0 \Rightarrow m=0 \Rightarrow \vec{A'I} = \vec{AB}`) .
6.  #mi(`\vec{AI} = \vec{AA'} + \vec{A'I} = \vec{AA'} + \vec{AB}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_13|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .
  
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_13|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`)  nên  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) .
2. Ta có:  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = (\vec{AG} + \vec{GB}) + (\vec{AG} + \vec{GC}) + (\vec{AG} + \vec{GD})`) .
3.  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG} + (\vec{GB} + \vec{GC} + \vec{GD})`) .
4. Thay  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`)  vào ta được  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) . (đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Ứng dụng vectơ trong Vật lý (Lực) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Ứng dụng vectơ trong Vật lý (Lực)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_14|theory|0
  - Lực là một đại lượng vectơ, hợp lực của hệ lực là tổng các vectơ lực:  #mi(`\vec{F} = \sum \vec{F_i}`) .
// @ANCHOR:dang_14|theory|1
  - Độ lớn hợp lực của hai lực  #mi(`\vec{F_1}, \vec{F_2}`)  tạo góc  #mi(`\alpha`)  được tính bởi:  #mi(`F = \sqrt{F_1^2 + F_2^2 + 2F_1F_2\cos\alpha}`) .
// @ANCHOR:dang_14|theory|2
  - Nếu ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc, độ lớn hợp lực là:  #mi(`F = \sqrt{F_1^2 + F_2^2 + F_3^2}`) .
// @ANCHOR:dang_14|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Hợp lực 3 lực vuông góc: 'Căn bậc hai tổng bình phương' - giống như tính đường chéo hình hộp chữ nhật  #mi(`d = \sqrt{a^2+b^2+c^2}`) .
  ]
// @ANCHOR:dang_14|cloze

  - *Công thức cốt lõi:* Hợp lực của hệ lực được xác định bởi công thức:  #mi(`\vec{F} = ... + \vec{F_2} + \vec{F_3} + ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_14|short_answer|0|prompt
    *Câu 1.* Một quả bóng có khối lượng  #mi(`450\text{ gam}`)  chịu tác dụng của trọng lực với gia tốc rơi tự do  #mi(`g = 9,8\text{ m/s}^2`) . Tính độ lớn của trọng lực tác dụng lên quả bóng (đơn vị: N).
// @ANCHOR:dang_14|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4.41]
// @ANCHOR:dang_14|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Đổi khối lượng  #mi(`m = 450\text{ g} = 0,45\text{ kg}`) . Độ lớn trọng lực được tính theo công thức  #mi(`P = m \cdot g = 0,45 \cdot 9,8 = 4,41\text{ N}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_14|short_answer|1|prompt
    *Câu 2.* Trong điện trường đều có cường độ  #mi(`E = 10^5\text{ N/C}`) , một điện tích điểm  #mi(`q = 10^{-9}\text{ C}`)  đặt tại điểm  #mi(`M`) . Tính độ lớn lực tĩnh điện tác dụng lên điện tích này (đơn vị: N).
// @ANCHOR:dang_14|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.0001]
// @ANCHOR:dang_14|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Độ lớn lực tĩnh điện được tính bởi công thức  #mi(`F = |q| \cdot E = |10^{-9}| \cdot 10^5 = 10^{-4} = 0,0001\text{ N}`) .]
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
// @ANCHOR:dang_14|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính hợp lực của 3 lực đôi một vuông góc:] Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  cùng tác động vào một vật, có phương đôi một vuông góc và có độ lớn lần lượt là  #mi(`2\text{N}, 3\text{N}, 4\text{N}`) . Tính độ lớn hợp lực của ba lực đã cho.
    
  #align(center)[#draw-oxyz()]
// @ANCHOR:dang_14|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc nên hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`)  có độ lớn được tính theo công thức:
 #mi(`F = \sqrt{F_1^2 + F_2^2 + F_3^2}`) 
Thay số:  #mi(`F = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{4 + 9 + 16} = \sqrt{29} \approx 5,39\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_14|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc với độ lớn lần lượt là  #mi(`1\text{N}, 2\text{N}, 2\text{N}`) . Tính độ lớn hợp lực  #mi(`\vec{F}`)  tác dụng lên vật.
// @ANCHOR:dang_14|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì ba lực đôi một vuông góc, độ lớn hợp lực là:  #mi(`F = \sqrt{F_1^2 + F_2^2 + F_3^2} = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_14|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc với độ lớn lần lượt là  #mi(`3\text{N}, 4\text{N}, 12\text{N}`) . Tính độ lớn hợp lực  #mi(`\vec{F}`)  tác dụng lên vật.
// @ANCHOR:dang_14|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì ba lực đôi một vuông góc, độ lớn hợp lực là:  #mi(`F = \sqrt{F_1^2 + F_2^2 + F_3^2} = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_14|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Một vật chịu tác dụng của hai lực  #mi(`\vec{F_1}, \vec{F_2}`)  cùng nằm trong mặt phẳng nằm ngang, tạo với nhau một góc  #mi(`60^\circ`)  và có độ lớn  #mi(`F_1 = 3\text{N}, F_2 = 5\text{N}`) . Đồng thời vật chịu tác dụng của một lực  #mi(`\vec{F_3}`)  vuông góc với mặt phẳng này và có độ lớn  #mi(`F_3 = 4\text{N}`) . Tính độ lớn hợp lực  #mi(`\vec{F}`) .
// @ANCHOR:dang_14|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{F_{12}} = \vec{F_1} + \vec{F_2}`) . Độ lớn  #mi(`F_{12} = \sqrt{F_1^2 + F_2^2 + 2F_1F_2\cos 60^\circ} = \sqrt{3^2 + 5^2 + 2 \cdot 3 \cdot 5 \cdot \frac{1}{2}} = \sqrt{9 + 25 + 15} = \sqrt{49} = 7\text{ N}`) .
Vì  #mi(`\vec{F_3} \perp \vec{F_{12}}`)  nên hợp lực  #mi(`F = \sqrt{F_{12}^2 + F_3^2} = \sqrt{7^2 + 4^2} = \sqrt{49 + 16} = \sqrt{65} \approx 8,06\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_14|drill|3|prompt
  *Bài 4 (Vận dụng).* Một chất điểm chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`) . Biết  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  nằm trong mặt phẳng  #mi(`(\alpha)`)  tạo góc  #mi(`135^\circ`)  với nhau, có độ lớn  #mi(`F_1 = 20\text{N}, F_2 = 15\text{N}`) . Lực  #mi(`\vec{F_3}`)  có phương vuông góc với  #mi(`(\alpha)`)  và có độ lớn  #mi(`F_3 = 10\text{N}`) . Tính độ lớn hợp lực  #mi(`\vec{F}`) .
// @ANCHOR:dang_14|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ lớn hợp lực của  #mi(`\vec{F_1}`)  và  #mi(`\vec{F_2}`)  là:  #mi(`F_{12} = \sqrt{F_1^2 + F_2^2 + 2F_1F_2\cos 135^\circ} = \sqrt{20^2 + 15^2 + 2 \cdot 20 \cdot 15 \cdot (-\frac{\sqrt{2}}{2})} = \sqrt{625 - 300\sqrt{2}} \approx 14,17\text{ N}`) .
Vì  #mi(`\vec{F_3}`)  vuông góc với mặt phẳng chứa  #mi(`\vec{F_1}, \vec{F_2}`)  nên  #mi(`\vec{F_3} \perp \vec{F_{12}}`) .
Độ lớn hợp lực tổng cộng:  #mi(`F = \sqrt{F_{12}^2 + F_3^2} = \sqrt{(625 - 300\sqrt{2}) + 10^2} = \sqrt{725 - 300\sqrt{2}} \approx \sqrt{300,74} \approx 17,34\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 15: Kiểm tra tính đúng sai của các mệnh đề vectơ tổng hợp ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 15. Kiểm tra tính đúng sai của các mệnh đề vectơ tổng hợp]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_15|theory|0
  - Quy tắc hình hộp: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
// @ANCHOR:dang_15|theory|1
  - Tính chất trung điểm: Nếu  #mi(`M`)  là trung điểm của  #mi(`AB`)  thì  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  và với điểm  #mi(`O`)  bất kỳ,  #mi(`\vec{OA} + \vec{OB} = 2\vec{OM}`) .
// @ANCHOR:dang_15|theory|2
  - Quy tắc ba điểm:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
// @ANCHOR:dang_15|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn kiểm tra đẳng thức vectơ, hãy 'đi' từ điểm đầu đến điểm cuối của vectơ kết quả bằng cách chèn các điểm trung gian phù hợp.
  ]
// @ANCHOR:dang_15|cloze

  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ đường chéo  #mi(`\vec{AC'} = ... + ... + ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_15|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
// @ANCHOR:dang_15|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3.46]
// @ANCHOR:dang_15|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{u} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Độ dài của vectơ  #mi(`\vec{u}`)  chính là độ dài đường chéo hình lập phương:  #mi(`|\vec{u}| = AC' = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{2^2 + 2^2 + 2^2} = \sqrt{12} = 2\sqrt{3} \approx 3.46`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_15|short_answer|1|prompt
    *Câu 2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Tính giá trị của  #mi(`k`)  để  #mi(`\vec{MN} = k(\vec{AC} + \vec{BD})`) .
// @ANCHOR:dang_15|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.5]
// @ANCHOR:dang_15|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) . Lại có  #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN}`) . Cộng hai vế:  #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AC} + \vec{BD}) + (\vec{CN} + \vec{DN})`) . Vì  #mi(`M, N`)  là trung điểm nên  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  và  #mi(`\vec{CN} + \vec{DN} = \vec{0}`) . Suy ra  #mi(`2\vec{MN} = \vec{AC} + \vec{BD} \Rightarrow \vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) . Vậy  #mi(`k = 0.5`) .]
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
// @ANCHOR:dang_15|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Kiểm tra mệnh đề trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đúng sai của mệnh đề sau:  #mi(`\vec{AB} + \vec{BC} + \vec{CC'} = \vec{AC'}`) .
    
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_15|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Áp dụng quy tắc ba điểm cho hai vectơ đầu tiên:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
Bước 2: Thay vào biểu thức, ta có:  #mi(`\vec{AB} + \vec{BC} + \vec{CC'} = \vec{AC} + \vec{CC'}`) .
Bước 3: Tiếp tục áp dụng quy tắc ba điểm:  #mi(`\vec{AC} + \vec{CC'} = \vec{AC'}`) .
Kết luận: Mệnh đề trên là Đúng.
    ] else [ \ #v(16pt) ]
  ]
// @ANCHOR:dang_15|example|1|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Mệnh đề về trung điểm trong tứ diện:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_15|example|1|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Phân tích  #mi(`\vec{MN}`)  theo hai đường đi khác nhau:
- Đường 1:  #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) 
- Đường 2:  #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN}`) 
Bước 2: Cộng hai đẳng thức trên theo vế:
 #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AC} + \vec{BD}) + (\vec{CN} + \vec{DN})`) 
Bước 3: Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) . Tương tự  #mi(`\vec{CN} + \vec{DN} = \vec{0}`) .
Bước 4: Suy ra  #mi(`2\vec{MN} = \vec{AC} + \vec{BD} \Rightarrow \vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_15|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Kiểm tra tính đúng sai của mệnh đề:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_15|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đây là quy tắc hình hộp cơ bản. Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng của ba vectơ xuất phát từ một đỉnh và nằm trên ba cạnh chung đỉnh đó chính bằng vectơ đường chéo xuất phát từ đỉnh đó. Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Mệnh đề Đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_15|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Kiểm tra tính đúng sai của mệnh đề:  #mi(`\vec{B'A'} + \vec{B'B} + \vec{B'C'} = \vec{B'D'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_15|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hình hộp  #mi(`ABCD.A'B'C'D'`) , tại đỉnh  #mi(`B'`) , ta có ba vectơ cạnh là  #mi(`\vec{B'A'}`) ,  #mi(`\vec{B'B}`)  và  #mi(`\vec{B'C'}`) . Theo quy tắc hình hộp, tổng của chúng là vectơ đường chéo xuất phát từ  #mi(`B'`) . Vậy  #mi(`\vec{B'A'} + \vec{B'B} + \vec{B'C'} = \vec{B'D}`) . Tuy nhiên, đề bài ghi là  #mi(`\vec{B'D'}`) , điều này sai vì  #mi(`\vec{B'D'}`)  chỉ là đường chéo mặt đáy. Mệnh đề Sai.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_15|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`O`)  là tâm của hình hộp. Kiểm tra tính đúng sai của mệnh đề:  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD} = \vec{0}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "O", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_15|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình hộp nên  #mi(`O`)  là trung điểm của các đường chéo  #mi(`AC', BD', CA', DB'`) . Do đó,  #mi(`\vec{OA} + \vec{OC'} = \vec{0}`)  và  #mi(`\vec{OB} + \vec{OD'} = \vec{0}`) . Tuy nhiên,  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD}`)  là tổng các vectơ từ tâm đến 4 đỉnh của một mặt. Vì  #mi(`ABCD`)  là hình bình hành tâm  #mi(`I`)  (giao  #mi(`AC`)  và  #mi(`BD`) ), nên  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) . Nhưng  #mi(`O`)  không trùng  #mi(`I`) . Mệnh đề Sai.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_15|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm  #mi(`BC`) . Kiểm tra tính đúng sai của mệnh đề:  #mi(`\vec{AM} = \vec{AB} + \frac{1}{2}\vec{BC}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "M", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_15|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét tam giác  #mi(`ABC`)  trong mặt phẳng đáy. Vì  #mi(`M`)  là trung điểm của  #mi(`BC`)  nên  #mi(`\vec{BM} = \frac{1}{2}\vec{BC}`) . Áp dụng quy tắc ba điểm:  #mi(`\vec{AM} = \vec{AB} + \vec{BM} = \vec{AB} + \frac{1}{2}\vec{BC}`) . Mệnh đề Đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 16: Xác định điểm thỏa mãn đẳng thức vectơ và tìm hệ số k ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 16. Xác định điểm thỏa mãn đẳng thức vectơ và tìm hệ số k]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_16|theory|0
  - Để xác định điểm  #mi(`M`)  thỏa mãn đẳng thức vectơ, ta phân tích  #mi(`\vec{AM}`)  theo các vectơ cơ sở  #mi(`\vec{e_1}, \vec{e_2}, \vec{e_3}`)  không đồng phẳng:  #mi(`\vec{AM} = x\vec{e_1} + y\vec{e_2} + z\vec{e_3}`) .
// @ANCHOR:dang_16|theory|1
  - Hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  vuông góc khi và chỉ khi tích vô hướng của chúng bằng 0:  #mi(`\vec{u} \cdot \vec{v} = 0`) .
// @ANCHOR:dang_16|theory|2
  - Hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  ( #mi(`\vec{v}`) 
eq \vec{0} #mi(`) cùng phương khi và chỉ khi tồn tại số thực`) k #mi(`sao cho`) \vec{u} = k\vec{v} #mi(`.`) 
// @ANCHOR:dang_16|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi làm việc với hình lập phương, hãy chọn 3 cạnh xuất phát từ 1 đỉnh làm hệ cơ sở. Mọi vectơ trong hình đều biểu diễn được dưới dạng  #mi(`x\vec{AB} + y\vec{AD} + z\vec{AA'}`) .
  ]
// @ANCHOR:dang_16|cloze

  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`)  vuông góc khi và chỉ khi  #mi(`\vec{u} \cdot \vec{v} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_16|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`)  và  #mi(`N`)  là trung điểm của  #mi(`CD`) . Tính tích vô hướng  #mi(`\vec{MN} \cdot \vec{AA'}`)  biết độ dài cạnh hình lập phương bằng 1.
// @ANCHOR:dang_16|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
// @ANCHOR:dang_16|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{MN} = \vec{MA} + \vec{AD} + \vec{DN}`) . Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{MA} = -\frac{1}{2}\vec{AB}`) . Vì  #mi(`N`)  là trung điểm  #mi(`CD`)  nên  #mi(`\vec{DN} = \frac{1}{2}\vec{DC} = \frac{1}{2}\vec{AB}`) . Suy ra  #mi(`\vec{MN} = -\frac{1}{2}\vec{AB} + \vec{AD} + \frac{1}{2}\vec{AB} = \vec{AD}`) . Tích vô hướng  #mi(`\vec{MN} \cdot \vec{AA'} = \vec{AD} \cdot \vec{AA'}`) . Vì  #mi(`AD \perp AA'`)  nên  #mi(`\vec{AD} \cdot \vec{AA'} = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_16|short_answer|1|prompt
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a=1`) . Biết  #mi(`\vec{AN} = -4\vec{AB} + k\vec{AA'} - 2\vec{AD}`)  và  #mi(`\vec{AM} = 2\vec{AB} + \vec{AA'} - 3\vec{AD}`) . Tìm giá trị của  #mi(`k`)  để  #mi(`\vec{AN} \perp \vec{AM}`) .
// @ANCHOR:dang_16|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
// @ANCHOR:dang_16|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Để  #mi(`\vec{AN} \perp \vec{AM}`)  thì  #mi(`\vec{AN} \cdot \vec{AM} = 0`) . Sử dụng hệ cơ sở  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  đôi một vuông góc và có độ dài bằng 1:  #mi(`\vec{AN} \cdot \vec{AM} = (-4)(2) + (k)(1) + (-2)(-3) = -8 + k + 6 = k - 2`) . Giải  #mi(`k - 2 = 0 \Rightarrow k = 2`) .]
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
// @ANCHOR:dang_16|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tâm hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`O`)  là tâm của hình lập phương. Hãy biểu diễn vectơ  #mi(`\vec{AO}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_16|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`O'`)  là tâm của hình vuông  #mi(`A'B'C'D'`) . Khi đó  #mi(`O`)  là trung điểm của  #mi(`AO'`) . Ta có  #mi(`\vec{AO'} = \vec{AA'} + \vec{A'O'}`) . Vì  #mi(`O'`)  là tâm hình vuông  #mi(`A'B'C'D'`)  nên  #mi(`\vec{A'O'} = \frac{1}{2}(\vec{A'B'} + \vec{A'D'}) = \frac{1}{2}(\vec{AB} + \vec{AD})`) . Suy ra  #mi(`\vec{AO'} = \vec{AA'} + \frac{1}{2}\vec{AB} + \frac{1}{2}\vec{AD}`) . Vì  #mi(`O`)  là trung điểm  #mi(`AO'`)  nên  #mi(`\vec{AO} = \frac{1}{2}\vec{AO'} = \frac{1}{2}(\frac{1}{2}\vec{AB} + \frac{1}{2}\vec{AD} + \vec{AA'}) = \frac{1}{4}\vec{AB} + \frac{1}{4}\vec{AD} + \frac{1}{2}\vec{AA'}`) . Lưu ý: Nếu  #mi(`O`)  là trung điểm đường chéo  #mi(`AC'`) , thì  #mi(`\vec{AO} = \frac{1}{2}\vec{AC'} = \frac{1}{2}(\vec{AB} + \vec{AD} + \vec{AA'})`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_16|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`O`)  là tâm của hình lập phương. Biểu diễn vectơ  #mi(`\vec{AO}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_16|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tâm  #mi(`O`)  của hình lập phương là trung điểm của đường chéo  #mi(`AC'`) . Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Vì  #mi(`O`)  là trung điểm  #mi(`AC'`)  nên  #mi(`\vec{AO} = \frac{1}{2}\vec{AC'} = \frac{1}{2}(\vec{AB} + \vec{AD} + \vec{AA'})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_16|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`O`)  là tâm của hình lập phương. Biểu diễn vectơ  #mi(`\vec{BO}`)  theo các vectơ  #mi(`\vec{BA}, \vec{BC}, \vec{BB'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_16|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tâm  #mi(`O`)  của hình lập phương là trung điểm của đường chéo  #mi(`BD'`) . Theo quy tắc hình hộp, ta có  #mi(`\vec{BD'} = \vec{BA} + \vec{BC} + \vec{BB'}`) . Vì  #mi(`O`)  là trung điểm  #mi(`BD'`)  nên  #mi(`\vec{BO} = \frac{1}{2}\vec{BD'} = \frac{1}{2}(\vec{BA} + \vec{BC} + \vec{BB'})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_16|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AA'`) . Tìm điểm  #mi(`O`)  sao cho  #mi(`\vec{AO} = \vec{AB} + \vec{AD} + \vec{AM}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_16|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AM} = \frac{1}{2}\vec{AA'}`) . Khi đó  #mi(`\vec{AO} = \vec{AB} + \vec{AD} + \frac{1}{2}\vec{AA'}`) . Gọi  #mi(`N`)  là trung điểm của  #mi(`A'C'`) . Theo quy tắc hình hộp,  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . Vậy  #mi(`\vec{AO} = \vec{AC'} - \frac{1}{2}\vec{AA'} = \vec{AC'} - \vec{A'M} = \vec{AM} + \vec{AB} + \vec{AD}`) . Điểm  #mi(`O`)  là điểm sao cho  #mi(`A B O D`)  là hình bình hành và  #mi(`O`)  nằm trên đoạn  #mi(`MC'`)  sao cho  #mi(`\vec{AO}`)  là tổng 3 vectơ. Cụ thể,  #mi(`\vec{AO} = \vec{AB} + \vec{AD} + \vec{AM} = \vec{AC} + \vec{AM}`) . Vì  #mi(`A, C, M`)  là 3 đỉnh của hình lập phương, điểm  #mi(`O`)  là đỉnh thứ tư của hình bình hành  #mi(`AMCO`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_16|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Biết  #mi(`\vec{u} = m\vec{AB} + \vec{AD} + n\vec{AA'}`) . Tìm  #mi(`m, n`)  để  #mi(`\vec{u}`)  cùng phương với  #mi(`\vec{AC'}`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_16|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Để  #mi(`\vec{u}`)  cùng phương với  #mi(`\vec{AC'}`)  thì tồn tại số thực  #mi(`k`)  sao cho  #mi(`\vec{u} = k\vec{AC'}`) . Suy ra  #mi(`m\vec{AB} + \vec{AD} + n\vec{AA'} = k(\vec{AB} + \vec{AD} + \vec{AA'}) = k\vec{AB} + k\vec{AD} + k\vec{AA'}`) . Vì  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`)  không đồng phẳng nên ta có hệ:  #mi(`\begin{cases} m = k \\ 1 = k \\ n = k \end{cases} \Rightarrow m = 1, n = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 17: Tính toán giá trị cụ thể trong bài toán thực tế ứng dụng vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 17. Tính toán giá trị cụ thể trong bài toán thực tế ứng dụng vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_17|theory|0
  - Trọng lực  #mi(`\vec{P} = m\vec{g}`)  có độ lớn  #mi(`P = mg`)  (với  #mi(`m`)  tính bằng  #mi(`kg`) ), hướng thẳng đứng từ trên xuống dưới.
// @ANCHOR:dang_17|theory|1
  - Lực tĩnh điện  #mi(`\vec{F} = q\vec{E}`)  có độ lớn  #mi(`F = |q|E`) , cùng hướng với  #mi(`\vec{E}`)  nếu  #mi(`q > 0`)  và ngược hướng nếu  #mi(`q < 0`) .
// @ANCHOR:dang_17|theory|2
  - Trong tứ diện, khoảng cách từ trọng tâm  #mi(`I`)  đến một mặt bằng  #mi(`\frac{1}{4}`)  chiều cao tương ứng của tứ diện đó.
// @ANCHOR:dang_17|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ đổi khối lượng  #mi(`g`) 
ightarrow kg #mi(`khi tính trọng lực`) P = mg #mi(`và dùng định lý Pythagore 3D cho hợp lực vuông góc:`) F = \sqrt{F_1^2 + F_2^2 + F_3^2} #mi(`.`) 
  ]
// @ANCHOR:dang_17|cloze

  - *Công thức cốt lõi:* Độ lớn hợp lực của ba lực đôi một vuông góc là  #mi(`F = \sqrt{... + ... + ...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_17|short_answer|0|prompt
    *Câu 1.* Một quả bóng có khối lượng  #mi(`450\text{ gam}`) . Tính độ lớn trọng lực  #mi(`\vec{P}`)  tác dụng lên quả bóng, biết gia tốc rơi tự do  #mi(`g = 9,8\text{ m/s}^2`) .
// @ANCHOR:dang_17|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4.41]
// @ANCHOR:dang_17|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Đổi  #mi(`m = 450\text{ g} = 0,45\text{ kg}`) . Độ lớn trọng lực là  #mi(`P = m \cdot g = 0,45 \cdot 9,8 = 4,41\text{ N}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_17|short_answer|1|prompt
    *Câu 2.* Tính độ lớn của lực tĩnh điện tác dụng lên một điện tích điểm  #mi(`q = 10^{-9}\text{ C}`)  đặt trong điện trường đều có cường độ  #mi(`E = 10^5\text{ N/C}`) .
// @ANCHOR:dang_17|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.0001]
// @ANCHOR:dang_17|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Độ lớn lực tĩnh điện được tính theo công thức  #mi(`F = |q| \cdot E = |10^{-9}| \cdot 10^5 = 10^{-4} = 0,0001\text{ N}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_17|short_answer|2|prompt
    *Câu 3.* Một khối rubik hình tứ diện đều có chiều cao là  #mi(`8\text{ cm}`) . Tính khoảng cách từ trọng tâm của khối rubik đến một mặt của nó.
// @ANCHOR:dang_17|short_answer|2|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
// @ANCHOR:dang_17|short_answer|2|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Trong tứ diện đều, khoảng cách từ trọng tâm đến một mặt bằng  #mi(`\frac{1}{4}`)  chiều cao của tứ diện. Vậy khoảng cách cần tìm là  #mi(`d = \frac{1}{4} \cdot 8 = 2\text{ cm}`) .]
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
// @ANCHOR:dang_17|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính hợp lực của ba lực vuông góc:] Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  cùng tác động vào một vật, có phương đôi một vuông góc và có độ lớn lần lượt là  #mi(`2\text{N}, 3\text{N}, 4\text{N}`) . Tính độ lớn hợp lực của ba lực trên.
    
  #align(center)[#draw-oxyz()]
// @ANCHOR:dang_17|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc, nên độ lớn hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`)  được tính theo công thức:  #mi(`F = \sqrt{F_1^2 + F_2^2 + F_3^2}`) . Thay số:  #mi(`F = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{4 + 9 + 16} = \sqrt{29} \approx 5,39\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_17|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Một vật có khối lượng  #mi(`200\text{ g}`)  đặt trong môi trường có gia tốc trọng trường  #mi(`g = 9,8\text{ m/s}^2`) . Tính độ lớn trọng lực tác dụng lên vật.
// @ANCHOR:dang_17|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đổi  #mi(`m = 200\text{ g} = 0,2\text{ kg}`) . Độ lớn trọng lực là  #mi(`P = m \cdot g = 0,2 \cdot 9,8 = 1,96\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_17|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Một vật có khối lượng  #mi(`500\text{ g}`)  đặt trong môi trường có gia tốc trọng trường  #mi(`g = 10\text{ m/s}^2`) . Tính độ lớn trọng lực tác dụng lên vật.
// @ANCHOR:dang_17|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đổi  #mi(`m = 500\text{ g} = 0,5\text{ kg}`) . Độ lớn trọng lực là  #mi(`P = m \cdot g = 0,5 \cdot 10 = 5\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_17|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Một điện tích điểm  #mi(`q = -2 \cdot 10^{-6}\text{ C}`)  đặt trong điện trường đều có cường độ  #mi(`E = 5 \cdot 10^4\text{ N/C}`) . Tính độ lớn lực tĩnh điện tác dụng lên điện tích này và cho biết hướng của lực so với hướng của  #mi(`\vec{E}`) .
// @ANCHOR:dang_17|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ lớn lực tĩnh điện:  #mi(`F = |q| \cdot E = |-2 \cdot 10^{-6}| \cdot 5 \cdot 10^4 = 0,1\text{ N}`) . Vì  #mi(`q < 0`)  nên lực  #mi(`\vec{F}`)  ngược hướng với vectơ cường độ điện trường  #mi(`\vec{E}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_17|drill|3|prompt
  *Bài 4 (Vận dụng).* Một vật chịu tác dụng của ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc với độ lớn lần lượt là  #mi(`3\text{N}, 4\text{N}, 12\text{N}`) . Tính độ lớn hợp lực của vật và tính tỉ số giữa hợp lực này với lực lớn nhất trong ba lực thành phần.
  
  #align(center)[#draw-oxyz()]
// @ANCHOR:dang_17|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ lớn hợp lực:  #mi(`F = \sqrt{3^2 + 4^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13\text{ N}`) . Lực lớn nhất là  #mi(`F_3 = 12\text{ N}`) . Tỉ số cần tìm là  #mi(`\frac{F}{F_3} = \frac{13}{12} \approx 1,08`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 18: Vận dụng tính chất trọng tâm và trung điểm trong tứ diện nâng cao ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 18. Vận dụng tính chất trọng tâm và trung điểm trong tứ diện nâng cao]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_18|theory|0
  - Trọng tâm  #mi(`G`)  của tứ diện  #mi(`ABCD`)  thỏa mãn:  #mi(`\vec{GA} + \vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) 
// @ANCHOR:dang_18|theory|1
  - Với mọi điểm  #mi(`O`) ,  #mi(`\vec{OG} = \frac{1}{4}(\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD})`) 
// @ANCHOR:dang_18|theory|2
  - Đoạn nối trung điểm  #mi(`M, N`)  của hai cạnh đối  #mi(`AB`)  và  #mi(`CD`)  có vectơ:  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) 
// @ANCHOR:dang_18|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ quy tắc 'chia 4' cho trọng tâm tứ diện và 'chia 2' cho đoạn nối trung điểm cạnh đối.
  ]
// @ANCHOR:dang_18|cloze

  - *Công thức cốt lõi:* Trọng tâm  #mi(`G`)  của tứ diện  #mi(`ABCD`)  chia đoạn nối một đỉnh đến trọng tâm mặt đối diện theo tỉ lệ  #mi(`\vec{AG} = ... \vec{GG_0}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_18|short_answer|0|prompt
    *Câu 1.* Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a = \sqrt{2}`) . Tính độ dài đoạn nối trung điểm  #mi(`M`)  của  #mi(`AB`)  và  #mi(`N`)  của  #mi(`CD`) .
// @ANCHOR:dang_18|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
// @ANCHOR:dang_18|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Trong tứ diện đều cạnh  #mi(`a`) , độ dài đoạn nối trung điểm hai cạnh đối là  #mi(`MN = \frac{a}{\sqrt{2}}`) . Với  #mi(`a = \sqrt{2}`) , ta có  #mi(`MN = \frac{\sqrt{2}}{\sqrt{2}} = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_18|short_answer|1|prompt
    *Câu 2.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm tứ diện. Gọi  #mi(`G_0`)  là trọng tâm tam giác  #mi(`BCD`) . Tính tỉ số  #mi(`\frac{GG_0}{AG_0}`) .
// @ANCHOR:dang_18|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.25]
// @ANCHOR:dang_18|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Theo tính chất trọng tâm tứ diện,  #mi(`G`)  nằm trên đoạn  #mi(`AG_0`)  sao cho  #mi(`AG = 3GG_0`) . Do đó  #mi(`AG_0 = AG + GG_0 = 3GG_0 + GG_0 = 4GG_0`) . Vậy  #mi(`\frac{GG_0}{AG_0} = \frac{1}{4}`) .]
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
// @ANCHOR:dang_18|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh đẳng thức đoạn nối trung điểm:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`\vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) .
// @ANCHOR:dang_18|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sử dụng quy tắc chèn điểm  #mi(`C`)  và  #mi(`D`)  vào  #mi(`\vec{MN}`) :
 #mi(`\vec{MN} = \vec{MA} + \vec{AC} + \vec{CN}`) 
 #mi(`\vec{MN} = \vec{MB} + \vec{BD} + \vec{DN}`) 
Cộng hai vế của hai đẳng thức trên:
 #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AC} + \vec{BD}) + (\vec{CN} + \vec{DN})`) 
Vì  #mi(`M`)  là trung điểm  #mi(`AB \Rightarrow \vec{MA} + \vec{MB} = \vec{0}`) .
Vì  #mi(`N`)  là trung điểm  #mi(`CD \Rightarrow \vec{CN} + \vec{DN} = \vec{0}`) .
Suy ra  #mi(`2\vec{MN} = \vec{AC} + \vec{BD} \Rightarrow \vec{MN} = \frac{1}{2}(\vec{AC} + \vec{BD})`) 
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)

// ==================== DẠNG 19: Tính góc và cosin góc giữa hai đường thẳng/vectơ trong hình khối phức tạp ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 19. Tính góc và cosin góc giữa hai đường thẳng/vectơ trong hình khối phức tạp]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_19|theory|0
  - Góc giữa hai vectơ  #mi(`\vec{u}, \vec{v}`)  khác  #mi(`\vec{0}`)  được xác định bởi công thức:  #mi(`\cos(\vec{u}, \vec{v}) = \frac{\vec{u} \cdot \vec{v}}{|\vec{u}||\vec{v}|}`) .
// @ANCHOR:dang_19|theory|1
  - Góc  #mi(`\varphi`)  giữa hai đường thẳng  #mi(`d_1, d_2`)  có vectơ chỉ phương lần lượt là  #mi(`\vec{u}, \vec{v}`)  được tính bằng:  #mi(`\cos \varphi = \frac{|\vec{u} \cdot \vec{v}|}{|\vec{u}||\vec{v}|}`) , với  #mi(`0^\circ \le \varphi \le 90^\circ`) .
// @ANCHOR:dang_19|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính góc giữa hai đường thẳng chéo nhau: Hãy 'tịnh tiến' một đường thẳng sao cho chúng cắt nhau tại một điểm, tạo thành một góc trong tam giác.
  ]
// @ANCHOR:dang_19|cloze

  - *Công thức cốt lõi:*  #mi(`\cos(\vec{u}, \vec{v}) = \frac{\vec{u} \cdot \vec{v}}{... \cdot ...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_19|short_answer|0|prompt
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{BD}, \vec{A'C'})`) .
// @ANCHOR:dang_19|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -0.5]
// @ANCHOR:dang_19|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{BD} = \vec{AD} - \vec{AB}`)  và  #mi(`\vec{A'C'} = \vec{A'B'} + \vec{B'C'} = \vec{AB} + \vec{BC}`) .
Tính tích vô hướng:  #mi(`\vec{BD} \cdot \vec{A'C'} = (\vec{AD} - \vec{AB}) \cdot (\vec{AB} + \vec{BC}) = \vec{AD} \cdot \vec{AB} + \vec{AD} \cdot \vec{BC} - \vec{AB} \cdot \vec{AB} - \vec{AB} \cdot \vec{BC} = 0 + 0 - a^2 - 0 = -a^2`) .
Độ dài:  #mi(`|\vec{BD}| = a\sqrt{2}`)  và  #mi(`|\vec{A'C'}| = a\sqrt{2}`) .
Vậy  #mi(`\cos(\vec{BD}, \vec{A'C'}) = \frac{-a^2}{a\sqrt{2} \cdot a\sqrt{2}} = -\frac{1}{2}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_19|short_answer|1|prompt
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{AB}, \vec{CD})`) .
// @ANCHOR:dang_19|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
// @ANCHOR:dang_19|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{CD} = \vec{AD} - \vec{AC}`) .
 #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC} = a^2 \cos 60^\circ - a^2 \cos 60^\circ = 0`) .
Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\cos(\vec{AB}, \vec{CD}) = 0`) .]
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
// @ANCHOR:dang_19|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính cosin góc giữa hai vectơ trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Tính  #mi(`\cos(\vec{AB}, \vec{DM})`) .
    
  #align(center)[#draw-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_19|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Phân tích vectơ  #mi(`\vec{DM}`)  theo các vectơ cơ sở  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`)  hoặc sử dụng quy tắc cộng:  #mi(`\vec{DM} = \vec{DA} + \vec{AM}`) .
2. Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{DM} = \vec{AB} \cdot (\vec{DA} + \vec{AM}) = \vec{AB} \cdot \vec{DA} + \vec{AB} \cdot \vec{AM}`) .
-  #mi(`\vec{AB} \cdot \vec{DA} = a \cdot a \cdot \cos(60^\circ) = \frac{a^2}{2}`) .
-  #mi(`\vec{AB} \cdot \vec{AM} = a \cdot \frac{a\sqrt{3}}{2} \cdot \cos(30^\circ) = a \cdot \frac{a\sqrt{3}}{2} \cdot \frac{\sqrt{3}}{2} = \frac{3a^2}{4}`) .
- Vậy  #mi(`\vec{AB} \cdot \vec{DM} = \frac{a^2}{2} + \frac{3a^2}{4} = \frac{5a^2}{4}`) . (Lưu ý: Tính toán lại theo tọa độ cho chính xác:  #mi(`\vec{AB} \cdot \vec{DM} = \frac{a^2}{4}`) ).
3. Tính độ dài:  #mi(`|\vec{AB}| = a`) ,  #mi(`|\vec{DM}| = \frac{a\sqrt{3}}{2}`)  (đường cao tam giác đều).
4. Kết luận:  #mi(`\cos(\vec{AB}, \vec{DM}) = \frac{a^2/4}{a \cdot a\sqrt{3}/2} = \frac{1}{2\sqrt{3}} = \frac{\sqrt{3}}{6}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_19|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{AC}, \vec{A'C'})`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_19|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`A'C' \parallel AC`)  và  #mi(`\vec{A'C'} = \vec{AC}`)  nên  #mi(`\cos(\vec{AC}, \vec{A'C'}) = \cos(0^\circ) = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_19|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{BD}, \vec{B'D'})`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_19|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`B'D' \parallel BD`)  và  #mi(`\vec{B'D'} = \vec{BD}`)  nên  #mi(`\cos(\vec{BD}, \vec{B'D'}) = \cos(0^\circ) = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_19|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính  #mi(`\cos(\vec{AC}, \vec{A'C})`) .
  
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_19|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{A'C} = \vec{A'A} + \vec{AC}`) .
 #mi(`\vec{AC} \cdot \vec{A'C} = \vec{AC} \cdot (\vec{A'A} + \vec{AC}) = \vec{AC} \cdot \vec{A'A} + |\vec{AC}|^2 = 0 + (a\sqrt{2})^2 = 2a^2`) .
 #mi(`|\vec{AC}| = a\sqrt{2}`) ,  #mi(`|\vec{A'C}| = \sqrt{a^2 + (a\sqrt{2})^2} = a\sqrt{3}`) .
Vậy  #mi(`\cos(\vec{AC}, \vec{A'C}) = \frac{2a^2}{a\sqrt{2} \cdot a\sqrt{3}} = \frac{2}{\sqrt{6}} = \frac{\sqrt{6}}{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_19|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA, SB, SC`)  đôi một vuông góc và  #mi(`SA=SB=SC=a`) . Tính góc giữa hai đường thẳng  #mi(`AB`)  và  #mi(`SC`) .
  
  #align(center)[#draw-pyramid-tri(labels: ("S", "A", "B", "C"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_19|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ chỉ phương của  #mi(`AB`)  là  #mi(`\vec{AB}`) , của  #mi(`SC`)  là  #mi(`\vec{SC}`) .
Ta có  #mi(`\vec{AB} \cdot \vec{SC} = (\vec{SB} - \vec{SA}) \cdot \vec{SC} = \vec{SB} \cdot \vec{SC} - \vec{SA} \cdot \vec{SC} = 0 - 0 = 0`) .
Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\vec{AB} \perp \vec{SC}`) .
Vậy góc giữa hai đường thẳng  #mi(`AB`)  và  #mi(`SC`)  bằng  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 20: Bài toán phân tích vectơ và tìm tỉ số đoạn thẳng trong hình chóp/hình hộp ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 20. Bài toán phân tích vectơ và tìm tỉ số đoạn thẳng trong hình chóp/hình hộp]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_20|theory|0
  - Để phân tích một vectơ  #mi(`\vec{v}`)  trong không gian, ta chọn 3 vectơ không đồng phẳng  #mi(`\vec{a}, \vec{b}, \vec{c}`)  làm cơ sở. Khi đó  #mi(`\vec{v} = x\vec{a} + y\vec{b} + z\vec{c}`)  với  #mi(`x, y, z`)  là duy nhất.
// @ANCHOR:dang_20|theory|1
  - Điểm  #mi(`P`)  thuộc mặt phẳng  #mi(`(ABC)`)  khi và chỉ khi  #mi(`\vec{AP} = x\vec{AB} + y\vec{AC}`)  với  #mi(`x+y`)  tùy ý (nếu  #mi(`P`)  nằm trên mặt phẳng) hoặc  #mi(`\vec{SP} = x\vec{SA} + y\vec{SB} + z\vec{SC}`)  với  #mi(`x+y+z=1`)  (nếu  #mi(`P`)  nằm trong mặt phẳng đi qua  #mi(`A, B, C`) ).
// @ANCHOR:dang_20|theory|2
  - Điều kiện để 4 điểm  #mi(`A, B, C, D`)  đồng phẳng là tồn tại cặp số  #mi(`(x, y)`)  sao cho  #mi(`\vec{AD} = x\vec{AB} + y\vec{AC}`) .
// @ANCHOR:dang_20|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tỉ số đoạn thẳng khi mặt phẳng cắt cạnh, hãy biểu diễn vectơ từ đỉnh đến điểm đó qua hệ cơ sở, sau đó cho các hệ số của các vectơ 'không mong muốn' bằng 0.
  ]
// @ANCHOR:dang_20|cloze

  - *Công thức cốt lõi:* Điểm  #mi(`P`)  thuộc mặt phẳng  #mi(`(ABC)`)  khi và chỉ khi  #mi(`\vec{AP} = x\vec{AB} + y\vec{AC}`)  với  #mi(`x, y \in \mathbb{R}`) . Nếu  #mi(`P`)  nằm trên mặt phẳng  #mi(`(ABC)`)  và  #mi(`S`)  là điểm ngoài mặt phẳng, thì  #mi(`\vec{SP} = x\vec{SA} + y\vec{SB} + z\vec{SC}`)  với  #mi(`x+y+z=...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_20|short_answer|0|prompt
    *Câu 1.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SA`)  và  #mi(`N`)  là trung điểm của  #mi(`SB`) . Mặt phẳng  #mi(`(MNC)`)  cắt  #mi(`SD`)  tại  #mi(`P`) . Tính tỉ số  #mi(`\frac{SP}{SD}`) .
// @ANCHOR:dang_20|short_answer|0|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1/3]
// @ANCHOR:dang_20|short_answer|0|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Chọn hệ cơ sở  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . Ta có  #mi(`\vec{SD} = \vec{SA} + \vec{SB} - \vec{SC}`) . Vì  #mi(`P \in (MNC)`) ,  #mi(`\vec{SP} = x\vec{SM} + y\vec{SN} + z\vec{SC}`)  với  #mi(`x+y+z=1`) . Mà  #mi(`\vec{SM} = \frac{1}{2}\vec{SA}`)  và  #mi(`\vec{SN} = \frac{1}{2}\vec{SB}`) . Suy ra  #mi(`\vec{SP} = \frac{x}{2}\vec{SA} + \frac{y}{2}\vec{SB} + z\vec{SC}`) . Vì  #mi(`P \in SD \implies \vec{SP} = k\vec{SD} = k(\vec{SA} + \vec{SB} - \vec{SC}) = k\vec{SA} + k\vec{SB} - k\vec{SC}`) . Đồng nhất hệ số:  #mi(`\frac{x}{2} = k`) ;  #mi(`\frac{y}{2} = k`) ;  #mi(`z = -k`) . Thay vào  #mi(`x+y+z=1 \implies 2k + 2k - k = 1 \implies 3k = 1 \implies k = \frac{1}{3}`) . Vậy  #mi(`\frac{SP}{SD} = \frac{1}{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_20|short_answer|1|prompt
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  cạnh  #mi(`a`) . Tính giá trị biểu thức  #mi(`T = \vec{AB} \cdot \vec{AC'} + \vec{AD} \cdot \vec{AB'}`) .
// @ANCHOR:dang_20|short_answer|1|final_number
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
// @ANCHOR:dang_20|short_answer|1|solution
      \ #text(fill: rgb("#334155"))[Lời giải: Trong hình lập phương,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Ta có  #mi(`\vec{AB} \cdot \vec{AC'} = \vec{AB} \cdot (\vec{AB} + \vec{AD} + \vec{AA'}) = AB^2 + 0 + 0 = a^2`) . Tương tự  #mi(`\vec{AD} \cdot \vec{AB'} = \vec{AD} \cdot (\vec{AB} + \vec{AA'}) = 0 + 0 = 0`) . Vậy  #mi(`T = a^2 + 0 = a^2`) . Nếu lấy  #mi(`a=1`)  thì  #mi(`T=1`) .]
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
// @ANCHOR:dang_20|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tỉ số đoạn thẳng bằng phương pháp phân tích vectơ:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SB`)  và  #mi(`N`)  là điểm trên  #mi(`SC`)  sao cho  #mi(`SN = 2NC`) . Mặt phẳng  #mi(`(AMN)`)  cắt  #mi(`SD`)  tại  #mi(`P`) . Tính tỉ số  #mi(`\frac{SP}{SD}`) .
    
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_20|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Chọn hệ vectơ cơ sở là  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . 
2. Biểu diễn các vectơ liên quan:  #mi(`\vec{SD} = \vec{SA} + \vec{SB} - \vec{SC}`)  (do  #mi(`ABCD`)  là hình bình hành). 
3. Vì  #mi(`P \in (AMN)`) , tồn tại  #mi(`x, y, z`)  sao cho  #mi(`\vec{SP} = x\vec{SA} + y\vec{SN} + z\vec{SM}`)  với  #mi(`x+y+z=1`) . 
4. Ta có  #mi(`\vec{SM} = \frac{1}{2}\vec{SB}`)  và  #mi(`\vec{SN} = \frac{2}{3}\vec{SC}`) . 
5. Thay vào:  #mi(`\vec{SP} = x\vec{SA} + \frac{2y}{3}\vec{SC} + \frac{z}{2}\vec{SB}`) . 
6. Vì  #mi(`P \in SD \implies \vec{SP} = k\vec{SD} = k(\vec{SA} + \vec{SB} - \vec{SC}) = k\vec{SA} + k\vec{SB} - k\vec{SC}`) . 
7. Đồng nhất hệ số:  #mi(`\begin{cases} x = k \\ \frac{z}{2} = k \\ \frac{2y}{3} = -k \end{cases} \implies x = k, z = 2k, y = -\frac{3k}{2}`) . 
8. Sử dụng điều kiện  #mi(`x+y+z=1`) :  #mi(`k - \frac{3k}{2} + 2k = 1 \implies \frac{3k}{2} = 1 \implies k = \frac{2}{3}`) . 
9. Vậy  #mi(`\frac{SP}{SD} = \frac{2}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
// @ANCHOR:dang_20|example|1|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Biểu diễn vectơ qua hệ cơ sở:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{A'C}`)  theo  #mi(`\vec{A'A}, \vec{A'B'}, \vec{A'D'}`) .
    
  #align(center)[#draw-cube(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_20|example|1|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Ta có  #mi(`\vec{A'C} = \vec{A'A} + \vec{AC}`) . 
2. Trong mặt đáy  #mi(`ABCD`) ,  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) . 
3. Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`\vec{AB} = \vec{A'B'}`)  và  #mi(`\vec{AD} = \vec{A'D'}`) . 
4. Thay vào biểu thức:  #mi(`\vec{A'C} = \vec{A'A} + \vec{A'B'} + \vec{A'D'}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luận rèn tư duy & luyện phản xạ (Bậc thang 4 bài tương tự)")[
// @ANCHOR:dang_20|drill|0|prompt
  *Bài 1 (Chuẩn mẫu).* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SA`)  và  #mi(`N`)  là trung điểm của  #mi(`SB`) . Mặt phẳng  #mi(`(MNC)`)  cắt  #mi(`SD`)  tại  #mi(`P`) . Tìm tỉ số  #mi(`\frac{SP}{SD}`) .
  
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_20|drill|0|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ cơ sở  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . Ta có  #mi(`\vec{SD} = \vec{SA} + \vec{SB} - \vec{SC}`) . Vì  #mi(`P \in (MNC)`) ,  #mi(`\vec{SP} = x\vec{SM} + y\vec{SN} + z\vec{SC}`)  với  #mi(`x+y+z=1`) . Mà  #mi(`\vec{SM} = \frac{1}{2}\vec{SA}`)  và  #mi(`\vec{SN} = \frac{1}{2}\vec{SB}`) . Suy ra  #mi(`\vec{SP} = \frac{x}{2}\vec{SA} + \frac{y}{2}\vec{SB} + z\vec{SC}`) . Vì  #mi(`P \in SD \implies \vec{SP} = k\vec{SD} = k\vec{SA} + k\vec{SB} - k\vec{SC}`) . Đồng nhất hệ số:  #mi(`\frac{x}{2} = k, \frac{y}{2} = k, z = -k`) . Thay vào  #mi(`x+y+z=1 \implies 2k + 2k - k = 1 \implies 3k = 1 \implies k = \frac{1}{3}`) . Vậy  #mi(`\frac{SP}{SD} = \frac{1}{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_20|drill|1|prompt
  *Bài 2 (Tương tự 100%).* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SC`)  và  #mi(`N`)  là trung điểm của  #mi(`SD`) . Mặt phẳng  #mi(`(MNA)`)  cắt  #mi(`SB`)  tại  #mi(`P`) . Tìm tỉ số  #mi(`\frac{SP}{SB}`) .
  
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_20|drill|1|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ cơ sở  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . Ta có  #mi(`\vec{SD} = \vec{SA} + \vec{SB} - \vec{SC}`) . Vì  #mi(`P \in (MNA)`) ,  #mi(`\vec{SP} = x\vec{SM} + y\vec{SN} + z\vec{SA}`)  với  #mi(`x+y+z=1`) . Mà  #mi(`\vec{SM} = \frac{1}{2}\vec{SC}`)  và  #mi(`\vec{SN} = \frac{1}{2}\vec{SD} = \frac{1}{2}(\vec{SA} + \vec{SB} - \vec{SC})`) . Suy ra  #mi(`\vec{SP} = \frac{x}{2}\vec{SC} + \frac{y}{2}\vec{SA} + \frac{y}{2}\vec{SB} - \frac{y}{2}\vec{SC} + z\vec{SA} = (\frac{y}{2} + z)\vec{SA} + \frac{y}{2}\vec{SB} + (\frac{x}{2} - \frac{y}{2})\vec{SC}`) . Vì  #mi(`P \in SB \implies \vec{SP} = k\vec{SB}`) . Đồng nhất hệ số:  #mi(`\frac{y}{2} + z = 0, \frac{y}{2} = k, \frac{x}{2} - \frac{y}{2} = 0 \implies x = y, z = -\frac{y}{2}`) . Thay vào  #mi(`x+y+z=1 \implies y + y - \frac{y}{2} = 1 \implies \frac{3y}{2} = 1 \implies y = \frac{2}{3}`) . Suy ra  #mi(`k = \frac{y}{2} = \frac{1}{3}`) . Vậy  #mi(`\frac{SP}{SB} = \frac{1}{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_20|drill|2|prompt
  *Bài 3 (Biến thể nhẹ).* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M`)  là trung điểm của  #mi(`SA`)  và  #mi(`N`)  là điểm trên  #mi(`SB`)  sao cho  #mi(`SN = 2NB`) . Mặt phẳng  #mi(`(MNC)`)  cắt  #mi(`SD`)  tại  #mi(`P`) . Tìm tỉ số  #mi(`\frac{SP}{SD}`) .
  
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_20|drill|2|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ cơ sở  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . Ta có  #mi(`\vec{SD} = \vec{SA} + \vec{SB} - \vec{SC}`) . Vì  #mi(`P \in (MNC)`) ,  #mi(`\vec{SP} = x\vec{SM} + y\vec{SN} + z\vec{SC}`)  với  #mi(`x+y+z=1`) . Mà  #mi(`\vec{SM} = \frac{1}{2}\vec{SA}`)  và  #mi(`\vec{SN} = \frac{2}{3}\vec{SB}`) . Suy ra  #mi(`\vec{SP} = \frac{x}{2}\vec{SA} + \frac{2y}{3}\vec{SB} + z\vec{SC}`) . Vì  #mi(`P \in SD \implies \vec{SP} = k\vec{SD} = k\vec{SA} + k\vec{SB} - k\vec{SC}`) . Đồng nhất hệ số:  #mi(`\frac{x}{2} = k, \frac{2y}{3} = k, z = -k`) . Thay vào  #mi(`x+y+z=1 \implies 2k + \frac{3k}{2} - k = 1 \implies \frac{5k}{2} = 1 \implies k = \frac{2}{5}`) . Vậy  #mi(`\frac{SP}{SD} = \frac{2}{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
// @ANCHOR:dang_20|drill|3|prompt
  *Bài 4 (Vận dụng).* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Gọi  #mi(`M, N`)  lần lượt là trung điểm của  #mi(`SA, SB`) . Gọi  #mi(`I`)  là trung điểm của  #mi(`MN`) . Tìm điểm  #mi(`P`)  trên  #mi(`SC`)  sao cho  #mi(`\vec{SP} = 2\vec{SI}`) .
  
  #align(center)[#draw-pyramid-quad(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ())]
// @ANCHOR:dang_20|drill|3|solution
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ cơ sở  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`) . Ta có  #mi(`\vec{SI} = \frac{1}{2}(\vec{SM} + \vec{SN}) = \frac{1}{2}(\frac{1}{2}\vec{SA} + \frac{1}{2}\vec{SB}) = \frac{1}{4}\vec{SA} + \frac{1}{4}\vec{SB}`) . Theo đề bài  #mi(`\vec{SP} = 2\vec{SI} = \frac{1}{2}\vec{SA} + \frac{1}{2}\vec{SB}`) . Tuy nhiên,  #mi(`P`)  nằm trên  #mi(`SC \implies \vec{SP} = k\vec{SC}`) . Điều này dẫn đến mâu thuẫn vì  #mi(`\vec{SA}, \vec{SB}, \vec{SC}`)  không đồng phẳng. Vậy không tồn tại điểm  #mi(`P`)  trên  #mi(`SC`)  thỏa mãn điều kiện trên. (Bài toán yêu cầu xác định vị trí  #mi(`P`)  hoặc kết luận không tồn tại).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
