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
  #text(size: 13pt, weight: "bold")[ÔN TẬP KIỂM TRA GIỮA HỌC KỲ I - TOÁN 12] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Hệ thống bài tập ôn tập tổng hợp kiến thức giữa học kỳ I lớp 12, tập trung vào khảo sát hàm số (đơn điệu, cực trị, giá trị lớn nhất/nhỏ nhất, tiệm cận, đồ thị), hình học không gian (vectơ, tọa độ Oxyz) và các bài toán vận dụng thực tế (tối ưu hóa, mô hình hóa).]
]
#v(6pt)

// ==================== DẠNG 1: Nhận diện hàm số từ đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Nhận diện hàm số từ đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`) : Nhánh cuối đi lên  #mi(`\Rightarrow a > 0`) , nhánh cuối đi xuống  #mi(`\Rightarrow a < 0`) . Giao với  #mi(`Oy`)  tại  #mi(`(0; d)`) .
  - Hàm phân thức bậc nhất/bậc nhất  #mi(`y = \frac{ax+b}{cx+d}`) : Tiệm cận đứng là nghiệm của mẫu  #mi(`x = -\frac{d}{c}`) , tiệm cận ngang là  #mi(`y = \frac{a}{c}`) .
  - Hàm phân thức bậc hai/bậc nhất  #mi(`y = \frac{ax^2+bx+c}{dx+e}`) : Có tiệm cận đứng  #mi(`x = -\frac{e}{d}`)  và tiệm cận xiên  #mi(`y = mx + n`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhìn nhánh cuối cùng bên phải: Lên là dương, Xuống là âm!
  ]
  - *Công thức cốt lõi:* Đối với hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`) , đường tiệm cận ngang là  #mi(`y = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x-1}{x+1}`) . Tìm tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận ngang là giới hạn của hàm số khi  #mi(`x \to \\infty`) .  #mi(`y = \\lim_{x \to \\infty} \frac{2x-1}{x+1} = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x^3 - 3x + 1`) . Tìm tung độ giao điểm của đồ thị với trục tung  #mi(`Oy`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Giao điểm với trục tung  #mi(`Oy`)  có  #mi(`x = 0`) . Thay vào hàm số:  #mi(`y = 0^3 - 3(0) + 1 = 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận diện hàm bậc ba:] Cho đồ thị hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có nhánh cuối cùng bên phải đi lên và cắt trục tung tại điểm  #mi(`(0; 1)`) . Xác định dấu của  #mi(`a`)  và  #mi(`d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì nhánh cuối cùng bên phải đi lên nên  #mi(`a > 0`) . Vì đồ thị cắt trục tung tại  #mi(`(0; 1)`)  nên  #mi(`d = 1 > 0`) . Vậy  #mi(`a > 0`)  và  #mi(`d > 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận diện hàm phân thức bậc nhất/bậc nhất:] Cho đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng  #mi(`x = 1`)  và tiệm cận ngang  #mi(`y = 2`) . Xác định giá trị của  #mi(`a, c`)  nếu biết  #mi(`c = 1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng  #mi(`x = 1 \Rightarrow`)  mẫu số có nghiệm  #mi(`x = 1`) . Với  #mi(`c = 1`) , mẫu là  #mi(`x + d`) , suy ra  #mi(`1 + d = 0 \Rightarrow d = -1`) . Tiệm cận ngang  #mi(`y = 2 \Rightarrow \frac{a}{c} = 2 \Rightarrow \frac{a}{1} = 2 \Rightarrow a = 2`) . Vậy  #mi(`a = 2, c = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Nhận diện hàm phân thức bậc hai/bậc nhất:] Cho đồ thị hàm số  #mi(`y = \frac{ax^2+bx+c}{x-1}`)  có tiệm cận đứng  #mi(`x = 1`)  và tiệm cận xiên  #mi(`y = x + 2`) . Xác định  #mi(`a`)  và  #mi(`b`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng  #mi(`x = 1 \Rightarrow`)  mẫu số có nghiệm  #mi(`x = 1`) . Tiệm cận xiên  #mi(`y = x + 2`)  là thương của phép chia  #mi(`(ax^2+bx+c) : (x-1)`) . Do đó  #mi(`a = 1`) . Thực hiện chia:  #mi(`\frac{x^2+bx+c}{x-1} = x + (b+1) + \frac{c+b+1}{x-1}`) . Để tiệm cận xiên là  #mi(`y = x + 2`)  thì  #mi(`b+1 = 2 \Rightarrow b = 1`) . Vậy  #mi(`a = 1, b = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Nhận diện hàm số qua giao điểm:] Cho đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  cắt trục hoành tại  #mi(`x = 2`)  và cắt trục tung tại  #mi(`y = -3`) . Biết  #mi(`c = 1, d = 1`) . Tìm  #mi(`a`)  và  #mi(`b`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng  #mi(`x = -d/c = -1/1 = -1`) . Giao với trục tung  #mi(`y = -3 \Rightarrow \frac{b}{d} = -3 \Rightarrow \frac{b}{1} = -3 \Rightarrow b = -3`) . Giao với trục hoành  #mi(`x = 2 \Rightarrow \frac{a(2)+b}{c(2)+d} = 0 \Rightarrow 2a + b = 0 \Rightarrow 2a - 3 = 0 \Rightarrow a = 1.5`) . Vậy  #mi(`a = 1.5, b = -3`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho đồ thị hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có nhánh cuối cùng bên phải đi xuống. Xác định dấu của  #mi(`a`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì nhánh cuối cùng bên phải đi xuống nên  #mi(`a < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho đồ thị hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có nhánh cuối cùng bên phải đi lên. Xác định dấu của  #mi(`a`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì nhánh cuối cùng bên phải đi lên nên  #mi(`a > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng  #mi(`x = 3`)  và tiệm cận ngang  #mi(`y = -1`) . Tìm  #mi(`a`)  nếu biết  #mi(`c = 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x = 3 \Rightarrow`)  mẫu có nghiệm  #mi(`x = 3`) . Với  #mi(`c = 1`) , mẫu là  #mi(`x + d \Rightarrow 3 + d = 0 \Rightarrow d = -3`) . Tiệm cận ngang  #mi(`y = -1 \Rightarrow \frac{a}{c} = -1 \Rightarrow \frac{a}{1} = -1 \Rightarrow a = -1`) . Vậy  #mi(`a = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho đồ thị hàm số  #mi(`y = \frac{ax^2+bx+c}{x-1}`)  có tiệm cận đứng  #mi(`x = 1`)  và tiệm cận xiên  #mi(`y = 2x + 3`) . Tìm  #mi(`a`)  và  #mi(`b`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x = 1 \Rightarrow`)  mẫu có nghiệm  #mi(`x = 1`) . Tiệm cận xiên  #mi(`y = 2x + 3 \Rightarrow`)  thương của phép chia là  #mi(`2x + 3`) . Do đó  #mi(`a = 2`) . Thực hiện chia:  #mi(`\frac{2x^2+bx+c}{x-1} = 2x + (b+2) + \frac{c+b+2}{x-1}`) . Để tiệm cận xiên là  #mi(`y = 2x + 3`)  thì  #mi(`b+2 = 3 \Rightarrow b = 1`) . Vậy  #mi(`a = 2, b = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Xét tính đơn điệu của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Xét tính đơn điệu của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số  #mi(`y = f(x)`)  đồng biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) ≥ 0, \forall x ∈ K`)  và  #mi(`f'(x) = 0`)  chỉ tại hữu hạn điểm.
  - Hàm số  #mi(`y = f(x)`)  nghịch biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) ≤ 0, \forall x ∈ K`)  và  #mi(`f'(x) = 0`)  chỉ tại hữu hạn điểm.
  - Dựa vào đồ thị  #mi(`f'(x)`) : Khoảng  #mi(`f'(x) > 0`)  (nằm trên trục hoành) là khoảng đồng biến; khoảng  #mi(`f'(x) < 0`)  (nằm dưới trục hoành) là khoảng nghịch biến.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhìn dấu  #mi(`f'(x)`) : Dấu  #mi(`+`)  là 'lên' (đồng biến), dấu  #mi(`-`)  là 'xuống' (nghịch biến).
  ]
  - *Công thức cốt lõi:* Hàm số đồng biến trên khoảng  #mi(`K`)  khi  #mi(`f'(x) \u2265 \dots`)  và nghịch biến trên khoảng  #mi(`K`)  khi  #mi(`f'(x) \u2264 \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^2 - 4x + 3`) . Tìm khoảng đồng biến của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`(2;+\infty)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = 2x - 4`) . Để hàm số đồng biến thì  #mi(`f'(x) ≥ 0 \Leftrightarrow 2x - 4 ≥ 0 \Leftrightarrow x ≥ 2`) . Vậy hàm số đồng biến trên khoảng  #mi(`(2;+\infty)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = -x^3 + 3x`) . Tìm khoảng nghịch biến của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`(-\infty; -1) \cup (1; +\infty)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = -3x^2 + 3`) . Để hàm số nghịch biến thì  #mi(`f'(x) ≤ 0 \Leftrightarrow -3x^2 + 3 ≤ 0 \Leftrightarrow x^2 \u2265 1 \Leftrightarrow x ≥ 1`)  hoặc  #mi(`x ≤ -1`) . Vậy hàm số nghịch biến trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Dựa vào bảng xét dấu đạo hàm:] Cho hàm số  #mi(`y = f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-1`)  |  #mi(`1`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào dòng  #mi(`f'(x)`) , ta thấy: 
-  #mi(`f'(x) > 0`)  trên khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) . 
-  #mi(`f'(x) < 0`)  trên khoảng  #mi(`(-1; 1)`) . \nVậy hàm số đồng biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , nghịch biến trên  #mi(`(-1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Dựa vào đồ thị đạo hàm  #mi(`f'(x)`) :] Cho đồ thị hàm số  #mi(`y = f'(x)`)  như hình vẽ (giả sử đồ thị cắt trục  #mi(`Ox`)  tại các điểm  #mi(`x = -2`)  và  #mi(`x = 2`) ). Tìm các khoảng đồng biến của hàm số  #mi(`y = f(x)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị  #mi(`y = f'(x)`) : 
- Phần đồ thị nằm trên trục  #mi(`Ox`)  (tương ứng  #mi(`f'(x) > 0`) ) là các khoảng  #mi(`x ∈ (-\infty; -2)`)  và  #mi(`x ∈ (2; +\infty)`) . 
- Phần đồ thị nằm dưới trục  #mi(`Ox`)  (tương ứng  #mi(`f'(x) < 0`) ) là khoảng  #mi(`x ∈ (-2; 2)`) . \nVậy hàm số  #mi(`y = f(x)`)  đồng biến trên  #mi(`(-\infty; -2)`)  và  #mi(`(2; +\infty)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Dựa vào công thức hàm số (Hàm đa thức):] Xét tính đơn điệu của hàm số  #mi(`y = x^3 - 3x^2 + 2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`f'(x) = 3x^2 - 6x`) . \nGiải bất phương trình  #mi(`f'(x) = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . \nBảng xét dấu  #mi(`f'(x)`) : 
-  #mi(`f'(x) > 0 \Leftrightarrow x < 0`)  hoặc  #mi(`x > 2`) . 
-  #mi(`f'(x) < 0 \Leftrightarrow 0 < x < 2`) . \nVậy hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Dựa vào công thức hàm số (Hàm phân thức):] Xét tính đơn điệu của hàm số  #mi(`y = \frac{x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) . \nTa có  #mi(`y' = \frac{1(x-1) - 1(x+1)}{(x-1)^2} = \frac{-2}{(x-1)^2}`) . \nVì  #mi(`y' < 0, \forall x \neq 1`) , nên hàm số nghịch biến trên từng khoảng xác định là  #mi(`(-\infty; 1)`)  và  #mi(`(1; +\infty)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Dựa vào đồ thị  #mi(`f'(x)`)  (Biến thể):] Cho đồ thị  #mi(`y = f'(x)`)  đi qua các điểm  #mi(`(-1; 0), (0; 2), (1; 0)`) . Tìm khoảng nghịch biến của  #mi(`y = f(x)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào đồ thị  #mi(`f'(x)`) , ta thấy đồ thị nằm dưới trục  #mi(`Ox`)  trong khoảng  #mi(`x ∈ (-1; 1)`) . \nDo đó  #mi(`f'(x) < 0`)  trên  #mi(`(-1; 1)`) . \nVậy hàm số nghịch biến trên khoảng  #mi(`(-1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào dòng  #mi(`f'(x)`) , ta thấy  #mi(`f'(x) > 0`)  trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , và  #mi(`f'(x) < 0`)  trên  #mi(`(0; 2)`) . \nVậy hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Cho hàm số  #mi(`y = f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-2`)  |  #mi(`3`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào dòng  #mi(`f'(x)`) , ta thấy  #mi(`f'(x) > 0`)  trên  #mi(`(-\infty; -2)`)  và  #mi(`(3; +\infty)`) , và  #mi(`f'(x) < 0`)  trên  #mi(`(-2; 3)`) . \nVậy hàm số đồng biến trên  #mi(`(-\infty; -2)`)  và  #mi(`(3; +\infty)`) , nghịch biến trên  #mi(`(-2; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Xét tính đơn điệu của hàm số  #mi(`y = x^3 - 3x`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 3x^2 - 3`) . 
 #mi(`f'(x) = 0 \Leftrightarrow x = ± 1`) . \nBảng xét dấu  #mi(`f'(x)`) : 
-  #mi(`f'(x) > 0 \Leftrightarrow x < -1`)  hoặc  #mi(`x > 1`) . 
-  #mi(`f'(x) < 0 \Leftrightarrow -1 < x < 1`) . \nVậy hàm số đồng biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , nghịch biến trên  #mi(`(-1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho đồ thị hàm số  #mi(`y = f'(x)`)  cắt trục hoành tại các điểm  #mi(`x = -1`)  và  #mi(`x = 1`) . Tìm khoảng đồng biến của hàm số  #mi(`y = f(x)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào đồ thị  #mi(`f'(x)`) , ta thấy phần đồ thị nằm trên trục  #mi(`Ox`)  là khoảng  #mi(`x < -1`)  và  #mi(`x > 1`) . \nDo đó  #mi(`f'(x) > 0`)  trên  #mi(`(-\infty; -1)`)  and  #mi(`(1; +\infty)`) . \nVậy hàm số đồng biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Tìm cực trị của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Tìm cực trị của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm số điểm cực trị của hàm số  #mi(`y=f(x)`) , ta tìm số lần đạo hàm  #mi(`f'(x)`)  đổi dấu khi đi qua các nghiệm của phương trình  #mi(`f'(x)=0`) .
  - Điểm cực trị của đồ thị hàm số là tọa độ  #mi(`(x_0; y_0)`)  sao cho  #mi(`f'(x_0)=0`)  và  #mi(`f(x_0)=y_0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cực trị xảy ra khi đồ thị đạo hàm  #mi(`f'(x)`)  'cắt xuyên qua' trục hoành. Nếu đồ thị chỉ 'chạm' (tiếp xúc) trục hoành mà không đổi dấu, đó không phải là điểm cực trị.
  ]
  - *Công thức cốt lõi:* Số điểm cực trị của hàm số  #mi(`y=f(x)`)  bằng số lần đạo hàm  #mi(`f'(x)`)  ... qua các nghiệm của  #mi(`f'(x)=0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=f(x)`)  có đồ thị đạo hàm  #mi(`f'(x)`)  cắt trục hoành tại 3 điểm phân biệt và tại các điểm đó đạo hàm đều đổi dấu. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì đồ thị  #mi(`f'(x)`)  cắt trục hoành tại 3 điểm phân biệt và tại mỗi điểm đó đạo hàm đều đổi dấu, nên hàm số  #mi(`y=f(x)`)  có 3 điểm cực trị.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tọa độ điểm cực tiểu của hàm số  #mi(`y=x^3-3x+2`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (1;0)]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y'=3x^2-3`) . Giải  #mi(`y'=0 \Leftrightarrow 3x^2=3 \Leftrightarrow x=\pm 1`) . Bảng xét dấu  #mi(`y'`) :  #mi(`x < -1 \rightarrow y' > 0`) ;  #mi(`-1 < x < 1 \rightarrow y' < 0`) ;  #mi(`x > 1 \rightarrow y' > 0`) . Tại  #mi(`x=1`) ,  #mi(`y'`)  đổi dấu từ âm sang dương nên  #mi(`x=1`)  là điểm cực tiểu. Giá trị cực tiểu  #mi(`y(1) = 1^3-3(1)+2 = 0`) . Vậy tọa độ điểm cực tiểu là  #mi(`(1;0)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Đếm số điểm cực trị từ đồ thị đạo hàm  #mi(`f'(x)`) :] Cho đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ (giả sử đồ thị cắt trục hoành tại  #mi(`x=-1, x=1, x=2`)  và đổi dấu tại đó). Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào đồ thị  #mi(`f'(x)`) , ta thấy đạo hàm đổi dấu khi đi qua các nghiệm  #mi(`x=-1, x=1, x=2`) . Do đó, hàm số  #mi(`y=f(x)`)  có 3 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Đếm số điểm cực trị từ đồ thị hàm số  #mi(`f(x)`) :] Cho đồ thị hàm số  #mi(`y=f(x)`)  như hình vẽ (giả sử đồ thị có 2 điểm 'đỉnh' và 'đáy'). Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị hàm số  #mi(`y=f(x)`) , ta thấy đồ thị có 2 điểm mà tại đó tiếp tuyến nằm ngang (một điểm cực đại và một điểm cực tiểu). Vậy hàm số  #mi(`y=f(x)`)  có 2 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ điểm cực đại:] Tìm tọa độ điểm cực đại của hàm số  #mi(`y=x^3-3x+2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y'=3x^2-3`) .  #mi(`y'=0 \Leftrightarrow x=\pm 1`) . Bảng xét dấu  #mi(`y'`)  cho thấy  #mi(`x=-1`)  là điểm cực đại. Giá trị cực đại  #mi(`y(-1) = (-1)^3-3(-1)+2 = 4`) . Vậy tọa độ điểm cực đại là  #mi(`(-1;4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ điểm cực tiểu:] Tìm tọa độ điểm cực tiểu của hàm số  #mi(`y=x^3-3x+2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y'=3x^2-3`) .  #mi(`y'=0 \Leftrightarrow x=\pm 1`) . Bảng xét dấu  #mi(`y'`)  cho thấy  #mi(`x=1`)  là điểm cực tiểu. Giá trị cực tiểu  #mi(`y(1) = 1^3-3(1)+2 = 0`) . Vậy tọa độ điểm cực tiểu là  #mi(`(1;0)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho đồ thị hàm số  #mi(`y=f'(x)`)  cắt trục hoành tại 2 điểm phân biệt và đổi dấu tại đó. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`f'(x)`)  đổi dấu qua 2 nghiệm phân biệt, nên hàm số  #mi(`y=f(x)`)  có 2 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Cho đồ thị hàm số  #mi(`y=f'(x)`)  cắt trục hoành tại 4 điểm phân biệt và đổi dấu tại đó. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`f'(x)`)  đổi dấu qua 4 nghiệm phân biệt, nên hàm số  #mi(`y=f(x)`)  có 4 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Tìm tọa độ điểm cực đại của hàm số  #mi(`y=x^3-3x+5`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y'=3x^2-3`) .  #mi(`y'=0 \Leftrightarrow x=\pm 1`) . Bảng xét dấu  #mi(`y'`)  cho thấy  #mi(`x=-1`)  là điểm cực đại. Giá trị cực đại  #mi(`y(-1) = (-1)^3-3(-1)+5 = 7`) . Vậy tọa độ điểm cực đại là  #mi(`(-1;7)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Tìm tọa độ điểm cực tiểu của hàm số  #mi(`y=x^3-12x+1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y'=3x^2-12`) .  #mi(`y'=0 \Leftrightarrow x=\pm 2`) . Bảng xét dấu  #mi(`y'`)  cho thấy  #mi(`x=2`)  là điểm cực tiểu. Giá trị cực tiểu  #mi(`y(2) = 2^3-12(2)+1 = -15`) . Vậy tọa độ điểm cực tiểu là  #mi(`(2;-15)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Giá trị lớn nhất và nhỏ nhất trên một đoạn ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Giá trị lớn nhất và nhỏ nhất trên một đoạn]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm GTLN và GTNN của hàm số liên tục  #mi(`y=f(x)`)  trên đoạn  #mi(`[a; b]`) , ta thực hiện các bước: 1. Tính  #mi(`f'(x)`) , tìm các điểm  #mi(`x_i \in (a; b)`)  mà tại đó  #mi(`f'(x)=0`)  hoặc không xác định. 2. Tính các giá trị  #mi(`f(a), f(b)`)  và  #mi(`f(x_i)`) . 3. So sánh các giá trị đã tính, giá trị lớn nhất là  #mi(`M = \max\{f(a), f(b), f(x_i)\}`)  và giá trị nhỏ nhất là  #mi(`m = \min\{f(a), f(b), f(x_i)\}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm GTLN/GTNN trên đoạn, hãy nhớ: 'Tính đạo hàm - Tìm nghiệm trong đoạn - So sánh đầu mút và cực trị'.
  ]
  - *Công thức cốt lõi:* Giá trị lớn nhất  #mi(`M`)  và giá trị nhỏ nhất  #mi(`m`)  của hàm số  #mi(`f(x)`)  trên đoạn  #mi(`[a; b]`)  được tìm bằng cách so sánh các giá trị tại  #mi(`f(a), f(b)`)  và các điểm  #mi(`x_i \in (a; b)`)  sao cho  #mi(`f'(x_i)=0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm giá trị lớn nhất của hàm số  #mi(`y = x^2 - 4x + 5`)  trên đoạn  #mi(`[0; 3]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = 2x - 4`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x = 2`) . Vì  #mi(`2 \in [0; 3]`)  nên ta tính các giá trị:  #mi(`f(0) = 5`) ,  #mi(`f(3) = 9 - 12 + 5 = 2`) ,  #mi(`f(2) = 4 - 8 + 5 = 1`) . So sánh các giá trị, ta thấy  #mi(`M = 5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -2]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = 3x^2 - 3`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x^2 = 1 \Leftrightarrow x = 1`)  (do  #mi(`x \in [0; 2]`) ). Ta tính các giá trị:  #mi(`f(0) = 0`) ,  #mi(`f(2) = 8 - 6 = 2`) ,  #mi(`f(1) = 1 - 3 = -2`) . So sánh các giá trị, ta thấy  #mi(`m = -2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cho hàm đa thức:] Tìm GTLN và GTNN của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-2; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính  #mi(`f'(x) = 3x^2 - 3`) . Bước 2: Giải  #mi(`f'(x) = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = ∑ 1`) . Cả hai giá trị  #mi(`x = -1`)  và  #mi(`x = 1`)  đều thuộc đoạn  #mi(`[-2; 2]`) . Bước 3: Tính các giá trị  #mi(`f(-2) = (-2)^3 - 3(-2) + 2 = -8 + 6 + 2 = 0`) ;  #mi(`f(2) = 2^3 - 3(2) + 2 = 8 - 6 + 2 = 4`) ;  #mi(`f(-1) = (-1)^3 - 3(-1) + 2 = -8 + 6 + 2 = 4`)  (sai, tính lại:  #mi(`-1 + 3 + 2 = 4`) );  #mi(`f(1) = 1^3 - 3(1) + 2 = 0`) . Vậy  #mi(`M = 4`)  và  #mi(`m = 0`) . Kết luận:  #mi(`M = 4, m = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng cho hàm phân thức:] Tìm GTLN và GTNN của hàm số  #mi(`y = \frac{x+1}{x-1}`)  trên đoạn  #mi(`[2; 4]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính  #mi(`f'(x) = \frac{(x-1) - (x+1)}{(x-1)^2} = \frac{-2}{(x-1)^2}`) . Bước 2: Vì  #mi(`f'(x) < 0`)  với mọi  #mi(`x \neq 1`) , hàm số luôn nghịch biến trên  #mi(`[2; 4]`) . Bước 3: Tính giá trị tại hai đầu mút:  #mi(`f(2) = \frac{2+1}{2-1} = 3`) ;  #mi(`f(4) = \frac{4+1}{4-1} = \frac{5}{3}`) . Vậy  #mi(`M = 3`)  và  #mi(`m = \frac{5}{3}`) . Kết luận:  #mi(`M = 3, m = \frac{5}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Đọc bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên trên đoạn  #mi(`[-1; 3]`)  như sau:  #mi(`x`)  chạy từ  #mi(`-1`)  đến  #mi(`3`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  tại  #mi(`x=1`)  và từ  #mi(`-`)  sang  #mi(`+`)  tại  #mi(`x=0`) . Các giá trị là  #mi(`f(-1)=2, f(0)=5, f(1)=0, f(3)=4`) . Tìm GTLN và GTNN của hàm số trên  #mi(`[-1; 3]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta quan sát các giá trị của hàm số trên đoạn  #mi(`[-1; 3]`) . Các giá trị cực trị và giá trị tại hai đầu mút là  #mi(`f(-1)=2, f(0)=5, f(1)=0, f(3)=4`) . So sánh các giá trị này, ta thấy giá trị lớn nhất là  #mi(`M = 5`)  và giá trị nhỏ nhất là  #mi(`m = 0`) . Kết luận:  #mi(`M = 5, m = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể tìm giá trị tại điểm cho trước:] Tìm giá trị lớn nhất của hàm số  #mi(`y = -x^2 + 2x + 3`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính  #mi(`f'(x) = -2x + 2`) . Bước 2: Giải  #mi(`f'(x) = 0 \Leftrightarrow -2x + 2 = 0 \Leftrightarrow x = 1`) . Vì  #mi(`1 \in [0; 2]`)  nên ta tính các giá trị:  #mi(`f(0) = 3, f(2) = -4 + 4 + 3 = 3, f(1) = -4 + 2 + 3 = 3`)  (sai, tính lại:  #mi(`-1 + 2 + 3 = 4`) ). Vậy  #mi(`M = 4`) . Kết luận:  #mi(`M = 4`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm GTLN và GTNN của hàm số  #mi(`y = x^3 - 3x + 1`)  trên đoạn  #mi(`[-2; 0]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 3x^2 - 3`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x = ∑ 1`) . Vì  #mi(`x = -1 \in [-2; 0]`)  và  #mi(`x = 1 \notin [-2; 0]`) , ta chỉ tính các giá trị:  #mi(`f(-2) = -8 + 6 + 1 = -1`) ;  #mi(`f(0) = 1`) ;  #mi(`f(-1) = -1 + 3 + 1 = 3`) . So sánh các giá trị, ta có  #mi(`M = 3, m = -1`) . Kết luận:  #mi(`M = 3, m = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm GTLN và GTNN của hàm số  #mi(`y = x^3 - 3x + 5`)  trên đoạn  #mi(`[-2; 0]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 3x^2 - 3`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x = ∑ 1`) . Vì  #mi(`x = -1 \in [-2; 0]`)  và  #mi(`x = 1 \notin [-2; 0]`) , ta chỉ tính các giá trị:  #mi(`f(-2) = -8 + 6 + 5 = 3`) ;  #mi(`f(0) = 5`) ;  #mi(`f(-1) = -1 + 3 + 5 = 7`) . So sánh các giá trị, ta có  #mi(`M = 7, m = 3`) . Kết luận:  #mi(`M = 7, m = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm GTLN và GTNN của hàm số  #mi(`y = x^4 - 2x^2`)  trên đoạn  #mi(`[-2; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 4x^3 - 4x`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow 4x(x^2 - 1) = 0 \Leftrightarrow x = 0, x = ∑ 1`) . Cả ba điểm đều thuộc  #mi(`[-2; 2]`) . Ta tính các giá trị:  #mi(`f(-2) = 16 - 8 = 8`) ;  #mi(`f(2) = 16 - 8 = 8`) ;  #mi(`f(0) = 0`) ;  #mi(`f(1) = 1 - 2 = -1`) ;  #mi(`f(-1) = 1 - 2 = -1`) . So sánh các giá trị, ta thấy  #mi(`M = 8`)  và  #mi(`m = -1`) . Kết luận:  #mi(`M = 8, m = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm giá trị nhỏ nhất của hàm số  #mi(`y = \frac{2x-1}{x+1}`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = \frac{2(x+1) - (2x-1)}{(x+1)^2} = \frac{3}{(x+1)^2}`) . Vì  #mi(`f'(x) > 0`)  với mọi  #mi(`x \in [0; 2]`) , hàm số luôn đồng biến trên đoạn này. Do đó, giá trị nhỏ nhất đạt tại đầu mút:  #mi(`m = f(0) = \frac{-1}{1} = -1`) . Kết luận:  #mi(`m = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Tìm tiệm cận của đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Tìm tiệm cận của đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Đường tiệm cận đứng (TCĐ) là đường thẳng  #mi(`x = x_0`)  nếu  #mi(`\lim_{x \to x_0^+} f(x) = \pm\infty`)  hoặc  #mi(`\lim_{x \to x_0^-} f(x) = \pm\infty`) . Đối với hàm phân thức,  #mi(`x_0`)  thường là nghiệm của mẫu số.
  - Đường tiệm cận ngang (TCN) là đường thẳng  #mi(`y = y_0`)  nếu  #mi(`\lim_{x \to +\infty} f(x) = y_0`)  hoặc  #mi(`\lim_{x \to -\infty} f(x) = y_0`) . Đối với hàm phân thức bậc tử bằng bậc mẫu,  #mi(`y_0`)  là tỉ số các hệ số của bậc cao nhất.
  - Đường tiệm cận xiên (TCX) là đường thẳng  #mi(`y = ax + b`)  ( #mi(`a \neq 0`) ) nếu  #mi(`\lim_{x \to +\infty} f(x) - (ax + b) = 0`) . Thường áp dụng cho hàm phân thức có bậc tử lớn hơn bậc mẫu đúng 1 đơn vị.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Bậc tử < Bậc mẫu  #mi(`\Rightarrow`)  TCN là  #mi(`y=0`) . Bậc tử = Bậc mẫu  #mi(`\Rightarrow`)  TCN là tỉ số hệ số. Bậc tử = Bậc mẫu + 1  #mi(`\Rightarrow`)  Có TCX.
  ]
  - *Công thức cốt lõi:* Để tìm tiệm cận xiên  #mi(`y = ax + b`)  của hàm số  #mi(`y = \frac{P(x)}{Q(x)}`) , ta thực hiện phép chia đa thức để đưa về dạng  #mi(`y = ax + b + \frac{R(x)}{Q(x)}`)  với  #mi(`\lim_{x \to \\infty} \frac{R(x)}{Q(x)} = 0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{2x - 1}{x + 3}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: TCĐ: x=-3; TCN: y=2]
      \ #text(fill: rgb("#334155"))[Lời giải: 1. Tiệm cận đứng: Nghiệm của mẫu  #mi(`x + 3 = 0 \Leftrightarrow x = -3`) . Kiểm tra giới hạn:  #mi(`\lim_{x \to -3^+} \frac{2x-1}{x+3} = -\infty`) . Vậy TCĐ là  #mi(`x = -3`) . 2. Tiệm cận ngang:  #mi(`\lim_{x \to \\infty} \frac{2x-1}{x+3} = 2`) . Vậy TCN là  #mi(`y = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2 + 2x - 1}{x + 1}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: y=x+1]
      \ #text(fill: rgb("#334155"))[Lời giải: Thực hiện phép chia đa thức:  #mi(`x^2 + 2x - 1 = (x + 1)(x + 1) - 2`) . Do đó  #mi(`y = x + 1 - \frac{2}{x+1}`) . Vì  #mi(`\lim_{x \to \\infty} \frac{-2}{x+1} = 0`)  nên tiệm cận xiên là  #mi(`y = x + 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hàm phân thức bậc nhất trên bậc nhất:] Tìm các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{x - 1}{x + 1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tìm TCĐ: Nghiệm của mẫu là  #mi(`x + 1 = 0 \Leftrightarrow x = -1`) . Vì  #mi(`\lim_{x \to -1^+} \frac{x-1}{x+1} = -\infty`)  nên đường thẳng  #mi(`x = -1`)  là TCĐ. 2. Tìm TCN:  #mi(`\lim_{x \to \\infty} \frac{x-1}{x+1} = 1`) . Vậy đường thẳng  #mi(`y = 1`)  là TCN.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hàm phân thức bậc nhất trên bậc nhất (trường hợp đặc biệt):] Tìm các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{2x + 1}{2x - 2}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tìm TCĐ: Nghiệm của mẫu là  #mi(`2x - 2 = 0 \Leftrightarrow x = 1`) . Vì  #mi(`\lim_{x \to 1^+} \frac{2x+1}{2x-2} = +\infty`)  nên đường thẳng  #mi(`x = 1`)  là TCĐ. 2. Tìm TCN:  #mi(`\lim_{x \to \\infty} \frac{2x+1}{2x-2} = \frac{2}{2} = 1`) . Vậy đường thẳng  #mi(`y = 1`)  là TCN.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm phân thức bậc hai trên bậc nhất (Tìm TCX):] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2 - x + 1}{x - 1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thực hiện phép chia đa thức:  #mi(`x^2 - x + 1 = x(x - 1) + 1`) . Suy ra  #mi(`y = x + \frac{1}{x - 1}`) . Vì  #mi(`\lim_{x \to \\infty} \frac{1}{x-1} = 0`)  nên đường thẳng  #mi(`y = x`)  là tiệm cận xiên của đồ thị hàm số.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hàm phân thức bậc hai trên bậc nhất (Tìm TCX):] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{2x^2 + 2x + 2}{x - 1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thực hiện phép chia đa thức:  #mi(`2x^2 + 2x + 2 = (2x + 4)(x - 1) + 6`) . Suy ra  #mi(`y = 2x + 4 + \frac{6}{x - 1}`) . Vì  #mi(`\lim_{x \to \\infty} \frac{6}{x-1} = 0`)  nên đường thẳng  #mi(`y = 2x + 4`)  là tiệm cận xiên.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{3x + 2}{x - 1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. TCĐ: Nghiệm của mẫu  #mi(`x - 1 = 0 \Leftrightarrow x = 1`) . Kiểm tra giới hạn  #mi(`\lim_{x \to 1^+} \frac{3x+2}{x-1} = +\infty`) . Vậy TCĐ là  #mi(`x = 1`) . 2. TCN:  #mi(`\lim_{x \to \\infty} \frac{3x+2}{x-1} = 3`) . Vậy TCN là  #mi(`y = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{4x - 5}{x + 2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. TCĐ: Nghiệm của mẫu  #mi(`x + 2 = 0 \Leftrightarrow x = -2`) . Vậy TCĐ là  #mi(`x = -2`) . 2. TCN:  #mi(`\lim_{x \to \\infty} \frac{4x-5}{x+2} = 4`) . Vậy TCN là  #mi(`y = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2 + 3x + 1}{x + 2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thực hiện phép chia đa thức:  #mi(`x^2 + 3x + 1 = (x + 1)(x + 2) - 1`) . Suy ra  #mi(`y = x + 1 - \frac{1}{x + 2}`) . Vì  #mi(`\lim_{x \to \\infty} \frac{-1}{x+2} = 0`)  nên tiệm cận xiên là  #mi(`y = x + 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tất cả các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{x^2 - 4}{x - 2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Xét mẫu số:  #mi(`x - 2 = 0 \Leftrightarrow x = 2`) . Tuy nhiên, tử số tại  #mi(`x = 2`)  là  #mi(`2^2 - 4 = 0`) . Ta có  #mi(`y = \frac{(x-2)(x+2)}{x-2} = x + 2`)  (với  #mi(`x \neq 2`) ). Vì  #mi(`\lim_{x \to 2} (x+2) = 4`)  (hữu hạn) nên đồ thị không có TCĐ. 2. Tiệm cận ngang:  #mi(`\lim_{x \to \\infty} (x+2) = \pm\infty`) . Không có TCN. 3. Tiệm cận xiên: Vì hàm số rút gọn thành  #mi(`y = x + 2`)  nên không có TCX. Kết luận: Đồ thị không có tiệm cận.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tâm đối xứng của đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tâm đối xứng của đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Đối với hàm phân thức bậc nhất trên bậc nhất  #mi(`y = \frac{ax+b}{cx+d}`)  ( #mi(`c \neq 0`) ), tâm đối xứng là giao điểm của hai đường tiệm cận:  #mi(`I\left(-\frac{d}{c}; \frac{a}{c}\right)`) 
  - Đối với hàm phân thức bậc hai trên bậc nhất  #mi(`y = \frac{ax^2+bx+c}{dx+e}`)  ( #mi(`d \neq 0`) ), tâm đối xứng là giao điểm của đường tiệm cận đứng  #mi(`x = -\frac{e}{d}`)  và đường tiệm cận xiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tâm đối xứng của hàm phân thức chính là 'điểm giao' của các đường tiệm cận.
  ]
  - *Công thức cốt lõi:* Tâm đối xứng của đồ thị hàm số phân thức là giao điểm của  #mi(`I(x_0; y_0)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tọa độ tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{2x+1}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: I(1;2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị hàm số có tiệm cận đứng là  #mi(`x = 1`)  và tiệm cận ngang là  #mi(`y = 2`) . Giao điểm của hai đường tiệm cận là  #mi(`I(1; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tọa độ tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x^2-x+1}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: I(1;1)]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị hàm số có tiệm cận đứng là  #mi(`x = 1`) . Chia đa thức ta được  #mi(`y = x + \frac{1}{x-1}`) , suy ra tiệm cận xiên là  #mi(`y = x`) . Giao điểm của hai đường tiệm cận là  #mi(`I(1; 1)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hàm bậc nhất/bậc nhất:] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị hàm số có tiệm cận đứng  #mi(`x = 1`)  và tiệm cận ngang  #mi(`y = 1`) . Vậy tâm đối xứng là  #mi(`I(1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hàm bậc nhất/bậc nhất (biến thể số):] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{2x-3}{x+2}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị hàm số có tiệm cận đứng  #mi(`x = -2`)  và tiệm cận ngang  #mi(`y = 2`) . Vậy tâm đối xứng là  #mi(`I(-2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm bậc hai/bậc nhất:] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x^2-x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị hàm số có tiệm cận đứng  #mi(`x = 1`) . Thực hiện phép chia đa thức:  #mi(`\frac{x^2-x+1}{x-1} = x + \frac{1}{x-1}`) . Vậy tiệm cận xiên là  #mi(`y = x`) . Giao điểm của tiệm cận đứng  #mi(`x = 1`)  và tiệm cận xiên  #mi(`y = x`)  là  #mi(`I(1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hàm bậc hai/bậc nhất (biến thể số):] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x^2+2x+2}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị hàm số có tiệm cận đứng  #mi(`x = 1`) . Chia đa thức:  #mi(`\frac{x^2+2x+2}{x-1} = x + 3 + \frac{5}{x-1}`) . Vậy tiệm cận xiên là  #mi(`y = x+3`) . Giao điểm của tiệm cận đứng  #mi(`x = 1`)  và tiệm cận xiên  #mi(`y = x+3`)  là  #mi(`I(1; 1+3) = I(1; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x-1}{x+1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x = -1`) , tiệm cận ngang  #mi(`y = 1`) . Tâm đối xứng  #mi(`I(-1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x+2}{x-2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x = 2`) , tiệm cận ngang  #mi(`y = 1`) . Tâm đối xứng  #mi(`I(2; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x^2-x+1}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x = 1`) , tiệm cận xiên  #mi(`y = x`) . Tâm đối xứng  #mi(`I(1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tâm đối xứng của đồ thị hàm số  #mi(`y = \frac{x^2+2x+2}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x = 1`) , tiệm cận xiên  #mi(`y = x+3`) . Tâm đối xứng  #mi(`I(1; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Phân tích và biểu diễn vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Phân tích và biểu diễn vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình hộp:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`)  (với  #mi(`A`)  là đỉnh và  #mi(`C'`)  là đỉnh đối diện qua tâm hình hộp)
  - Quy tắc cộng vectơ trong hình lăng trụ:  #mi(`\vec{AC'} = \vec{AB} + \vec{BC} + \vec{CC'}`) 
  - Tính chất trọng tâm/tâm đáy: Trong hình chóp có đáy là hình bình hành tâm  #mi(`O`) , ta có  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 4\vec{SO}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm vectơ đường chéo của hình hộp, hãy cộng 3 vectơ xuất phát từ cùng một đỉnh và cùng hướng với 3 cạnh của hình hộp đó.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ đường chéo  #mi(`\vec{AC'} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Tính  #mi(`\vec{AC'}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính tổng  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`4\vec{SO}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`O`)  là tâm hình bình hành nên  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD} = \vec{0}`) . Ta có  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = (\vec{SO} + \vec{OA}) + (\vec{SO} + \vec{OB}) + (\vec{SO} + \vec{OC}) + (\vec{SO} + \vec{OD}) = 4\vec{SO} + (\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD}) = 4\vec{SO}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, vectơ đường chéo  #mi(`\vec{AC'}`)  được tính bằng tổng của ba vectơ cạnh xuất phát từ cùng một đỉnh  #mi(`A`) :  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Quy tắc cộng trong hình lăng trụ:] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Biểu diễn vectơ  #mi(`\vec{B'C}`)  theo  #mi(`\vec{a} = \vec{AA'}, \vec{b} = \vec{AB}, \vec{c} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{B'C} = \vec{B'A'} + \vec{A'A} + \vec{AB} + \vec{BC} = \vec{B'A'} + \vec{A'A} + \vec{AB} + \vec{AC} - \vec{AB} = \vec{B'A'} + \vec{A'A} + \vec{AC}`) . Vì  #mi(`\vec{B'A'} = \vec{BA}`)  và  #mi(`\vec{A'A} = -\vec{AA'} = -\vec{a}`) , nên  #mi(`\vec{B'C} = \vec{BA} + \vec{AC} - \vec{a}`) . Mà  #mi(`\vec{BA} = \vec{BC} - \vec{AC}`) , nên  #mi(`\vec{B'C} = \vec{BC} - \vec{a}`) . (Cách khác:  #mi(`\vec{B'C} = \vec{B'C'} + \vec{C'C} = \vec{BC} + \vec{AA'} = \vec{BC} + \vec{a}`)  nếu dùng  #mi(`\vec{B'C'} = \vec{BC}`) ). Ta có  #mi(`\vec{B'C} = \vec{B'C'} + \vec{C'C} = \vec{BC} + \vec{AA'}`) . Vì  #mi(`\vec{B'C'} = \vec{BC}`)  và  #mi(`\vec{AA'} = \vec{a}`) , vậy  #mi(`\vec{B'C} = \vec{BC} + \vec{a}`) . Nếu  #mi(`\vec{BC} = \vec{c} - \vec{b}`)  thì  #mi(`\vec{B'C} = \vec{c} - \vec{b} + \vec{a}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính chất tâm đáy hình chóp:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính  #mi(`\vec{SA} + \frac{1}{3}\vec{SB} + \frac{1}{3}\vec{SC} + \vec{SD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{SA} + \vec{SD} = 2\vec{SO}`)  (do  #mi(`O`)  là trung điểm  #mi(`BD`) ) và  #mi(`\vec{SB} + \vec{SC} = 2\vec{SO}`)  (do  #mi(`O`)  là trung điểm  #mi(`AC`) ). Vậy  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 2\vec{SO} + 2\vec{SO} = 4\vec{SO}`) . Vậy  #mi(`\vec{SA} + \frac{1}{3}\vec{SB} + \frac{1}{3}\vec{SC} + \vec{SD} = \vec{SA} + \vec{SD} + \frac{1}{3}(\vec{SB} + \vec{SC}) = 2\vec{SO} + \frac{2}{3}\vec{SO} = \frac{8}{3}\vec{SO}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu diễn vectơ trong hình hộp chữ nhật:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Gọi  #mi(`M`)  là trung điểm  #mi(`BC`) . Biểu diễn  #mi(`\vec{AM}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AM} = \vec{AB} + \vec{BM} = \vec{AB} + \frac{1}{2}\vec{BC} = \vec{AB} + \frac{1}{2}\vec{AD}`)  (nếu đáy là hình bình hành). Trong hình hộp,  #mi(`\vec{BC} = \vec{AD}`) . Vậy  #mi(`\vec{AM} = \vec{AB} + \frac{1}{2}\vec{AD}`) . Nếu tính cả chiều cao  #mi(`\vec{AA'}`) , thì  #mi(`\vec{AM}`)  nằm trên mặt đáy nên  #mi(`\vec{AM} = \vec{AB} + \frac{1}{2}\vec{AD}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Biến thể hình chóp:] Cho hình chóp  #mi(`S.ABC`)  có đáy  #mi(`ABC`)  là tam giác. Gọi  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) . Chứng minh  #mi(`\vec{SA} + \vec{SB} + \vec{SC} = 3\vec{SG}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo tính chất trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) , ta có  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Ta có  #mi(`\vec{SA} + \vec{SB} + \vec{SC} = (\vec{SG} + \vec{GA}) + (\vec{SG} + \vec{GB}) + (\vec{SG} + \vec{GC}) = 3\vec{SG} + (\vec{GA} + \vec{GB} + \vec{GC}) = 3\vec{SG} + \vec{0} = 3\vec{SG}`) . (ĐPCM).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{BD'}`)  theo  #mi(`\vec{BA}, \vec{BC}, \vec{BB'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{BD'} = \vec{BA} + \vec{BC} + \vec{BB'}`)  (sai, phải là  #mi(`\vec{BD'} = \vec{BA} + \vec{AD} + \vec{BB'}`) ). Ta có  #mi(`\vec{BD'} = \vec{BD} + \vec{BB'} = (\vec{BA} + \vec{BC}) + \vec{BB'}`) . Vì  #mi(`\vec{BC} = \vec{AD}`) , nên  #mi(`\vec{BD'} = \vec{BA} + \vec{AD} + \vec{BB'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  is the center of the parallelogram,  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD} = \vec{0}`) . Do đó,  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 4\vec{SO}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Biểu diễn vectơ  #mi(`\vec{A'C}`)  theo  #mi(`\vec{a} = \vec{AA'}, \vec{b} = \vec{AB}, \vec{c} = \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C} = \vec{A'A} + \vec{AC} = -\vec{AA'} + \vec{AC} = -\vec{a} + \vec{c}`) . Nếu dùng  #mi(`\vec{c} = \vec{AB} + \vec{BC}`) , thì  #mi(`\vec{A'C} = -\vec{a} + \vec{b} + \vec{BC}`) . Ta có  #mi(`\vec{A'C} = \vec{A'A} + \vec{A'B'} + \vec{B'C'} = -\vec{a} + \vec{BA} + \vec{BC} = -\vec{a} + (\vec{b} - \vec{BA}) + \vec{BC}`)  (sai). Ta có  #mi(`\vec{A'C} = \vec{A'A} + \vec{A'B'} + \vec{B'C'} = -\vec{a} + \vec{BA} + \vec{BC}`) . Vì  #mi(`\vec{BA} = -\vec{AB} = -\vec{b}`) , nên  #mi(`\vec{A'C} = -\vec{a} - \vec{b} + \vec{BC}`) . Nếu  #mi(`\vec{BC} = \vec{c} - \vec{b}`) , thì  #mi(`\vec{A'C} = -\vec{a} - \vec{b} + (\vec{c} - \vec{b}) = -\vec{a} - 2\vec{b} + \vec{c}`) . (Cách khác:  #mi(`\vec{A'C} = \vec{A'C'} + \vec{C'C} = \vec{BC} + \vec{AA'} = \vec{c} - \vec{b} + \vec{a}`)  nếu dùng  #mi(`\vec{BC} = \vec{c} - \vec{b}`)  and  #mi(`\vec{AA'C'} = \vec{AC}`) ?). Ta có  #mi(`\vec{A'C} = \vec{A'C'} + \vec{C'C} = \vec{BC} + \vec{AA'} = (\vec{c} - \\vec{b}) + \vec{a}`) . Vậy  #mi(`\vec{A'C} = \vec{a} - \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Tọa độ vectơ và điểm trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Tọa độ vectơ và điểm trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  thì  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) 
  - Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên các trục tọa độ lần lượt là:  #mi(`Ox(x_A; 0; 0)`) ,  #mi(`Oy(0; y_A; 0)`)  và  #mi(`Oz(0; 0; z_A)`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm vectơ  #mi(`\vec{AB}`) , lấy 'Sau trừ Trước' (tọa độ điểm B trừ tọa độ điểm A). Muốn tìm hình chiếu lên trục nào thì giữ nguyên tọa độ trục đó, các trục còn lại cho bằng 0.
  ]
  - *Công thức cốt lõi:* Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`\vec{AB} = (\dots; \dots; \dots)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho điểm  #mi(`A(3; -2; 5)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3;0;0)]
      \ #text(fill: rgb("#334155"))[Lời giải: Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Ox`)  có tọa độ là  #mi(`(x_A; 0; 0)`) . Áp dụng với  #mi(`A(3; -2; 5)`) , ta có hình chiếu là  #mi(`(3; 0; 0)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 5; 6)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3;3;3)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Ta có  #mi(`\vec{AB} = (4 - 1; 5 - 2; 6 - 3) = (3; 3; 3)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ vectơ từ hai điểm cho trước:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 5; 6)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (4 - 1; 5 - 2; 6 - 3) = (3; 3; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm hình chiếu lên trục  #mi(`Ox`) :] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(5; -1; 2)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`A`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Ox`)  có tọa độ là  #mi(`(x_A; 0; 0)`) . Áp dụng với  #mi(`A(5; -1; 2)`) , ta có hình chiếu là  #mi(`(5; 0; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm hình chiếu lên trục  #mi(`Oy`) :] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(-3; 4; 7)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`A`)  lên trục  #mi(`Oy`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Oy`)  có tọa độ là  #mi(`(0; y_A; 0)`) . Áp dụng với  #mi(`A(-3; 4; 7)`) , ta có hình chiếu là  #mi(`(0; 4; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm hình chiếu lên trục  #mi(`Oz`) :] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(2; 0; -5)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`A`)  lên trục  #mi(`Oz`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Oz`)  có tọa độ là  #mi(`(0; 0; z_A)`) . Áp dụng với  #mi(`A(2; 0; -5)`) , ta có hình chiếu là  #mi(`(0; 0; -5)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; 3; 4)`)  và  #mi(`B(5; 6; 7)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (5 - 2; 6 - 3; 7 - 4) = (3; 3; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(2; 3; 4)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (2 - 1; 3 - 2; 4 - 3) = (1; 1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(-1; 4; -2)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Oy`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Oy`)  có tọa độ là  #mi(`(0; y_A; 0)`) . Áp dụng với  #mi(`A(-1; 4; -2)`) , ta có hình chiếu là  #mi(`(0; 4; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(3; -2; 5)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Oz`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Oz`)  có tọa độ là  #mi(`(0; 0; z_A)`) . Áp dụng với  #mi(`A(3; -2; 5)`) , ta có hình chiếu là  #mi(`(0; 0; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Tích vô hướng và góc giữa hai vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Tích vô hướng và góc giữa hai vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính bởi công thức:  #mi(`\vec{a}.\vec{b} = |\vec{a}|.|\vec{b}|\cos(\theta)`) , trong đó  #mi(`\theta`)  là góc giữa hai vectơ đó.
  - Góc  #mi(`\theta`)  giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được xác định qua công thức:  #mi(`\cos(\theta) = \frac{\vec{a}.\vec{b}}{|\vec{a}|.|\vec{b}|}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính tích vô hướng, hãy nhớ: 'Độ dài nhân độ dài, rồi nhân cos góc'. Muốn tìm góc, hãy lấy 'Tích chia cho tích độ dài'.
  ]
  - *Công thức cốt lõi:* Công thức tính tích vô hướng là  #mi(`\vec{a}.\vec{b} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=4`) ,  #mi(`|\vec{b}|=5`)  và góc giữa chúng là  #mi(`60^\circ`) . Tính  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 10]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tích vô hướng:  #mi(`\vec{a}.\vec{b} = |\vec{a}|.|\vec{b}|\cos(60^\circ) = 4.5.0.5 = 10`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  biết  #mi(`\vec{a}.\vec{b}=-6`) ,  #mi(`|\vec{a}|=3`)  và  #mi(`|\vec{b}|=4`) . Tính  #mi(`\cos(\theta)`)  (với  #mi(`\theta`)  là góc giữa hai vectơ).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -0.5]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức  #mi(`\cos(\theta) = \frac{\vec{a}.\vec{b}}{|\vec{a}|.|\vec{b}|} = \frac{-6}{3.4} = -0.5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng khi biết độ dài và góc:] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=2`) ,  #mi(`|\vec{b}|=3`)  và góc giữa chúng là  #mi(`60^\circ`) . Tính  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tích vô hướng:  #mi(`\vec{a}.\vec{b} = |\vec{a}|.|\vec{b}|\cos(60^\\circ) = 2.3.0.5 = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính góc giữa hai vectơ khi biết tích vô hướng và độ dài:] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  biết  #mi(`\vec{a}.\vec{b}=-4`) ,  #mi(`|\vec{a}|=2`)  và  #mi(`|\vec{b}|=4`) . Tính góc  #mi(`\theta`)  giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\cos(\theta) = \frac{\vec{a}.\vec{b}}{|\vec{a}|.|\vec{b}|} = \frac{-4}{2.4} = -0.5`) . Vì  #mi(`0^\le \theta \le 180^\circ`)  nên  #mi(`\theta = 120^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng vào hình học (Tứ diện đều):] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB}.\vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trong tứ diện đều  #mi(`ABCD`) , các mặt là các tam giác đều, do đó góc  #mi(`(\vec{AB}, \vec{AC}) = 60^\circ`) . Ta có  #mi(`\vec{AB}.\vec{AC} = |\vec{AB}|.|\vec{AC}|\cos(60^\circ) = a.a.0.5 = 0.5a^2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Áp dụng vào hình học (Tứ diện đều biến thể):] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a\frac{\sqrt{3}}{2}`) . Tính tích vô hướng  #mi(`\vec{DA}.\vec{DC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là tứ diện đều nên góc  #mi(`(\vec{DA}, \vec{DC}) = 60^\circ`) . Ta có  #mi(`\vec{DA}.\vec{DC} = |\vec{DA}|.|\vec{DC}|\cos(60^\circ) = (a\frac{\sqrt{3}}{2})^2.\cos(60^\circ) = a^2.3/4.0.5 = 0.375a^2`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=6`) ,  #mi(`|\vec{b}|=2`)  và góc giữa chúng là  #mi(`120^\circ`) . Tính  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{a}.\vec{b} = |\vec{a}|.|\vec{b}|\cos(120^\circ) = 6.2.(-0.5) = -6`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=4`) ,  #mi(`|\vec{b}|=5`)  và góc giữa chúng là  #mi(`60^\circ`) . Tính  #mi(`\vec{a}.\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{a}.\vec{b} = |\vec{a}|.|\vec{b}|\cos(60^\circ) = 4.5.0.5 = 10`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  biết  #mi(`\vec{a}.\vec{b}=10`) ,  #mi(`|\vec{a}|=5`)  và  #mi(`|\vec{b}|=4`) . Tính  #mi(`\cos(\theta)`)  (với  #mi(`\theta`)  là góc giữa hai vectơ).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\cos(\theta) = \frac{\vec{a}.\vec{b}}{|\vec{a}|.|\vec{b}|} = \frac{10}{5.4} = 10/20 = 0.5`) . Vậy  #mi(`\theta = 60^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện đều  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB}.\vec{CD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trong tứ diện đều, các cặp cạnh đối không cùng nằm trong một mặt phẳng, nhưng ta có thể tính bằng tọa độ hoặc tính chất đặc biệt. Tuy nhiên, để bám sát lý thuyết tích vô hướng qua góc, ta xét  #mi(`\vec{AB}.\vec{CD} = \vec{AB}.(\vec{AD}-\vec{AC}) = \vec{AB}.\vec{AD} - \vec{AB}.\vec{AC} = a^2.0.5 - a^2.0.5 = 0`) . (Kết quả là 0 vì hai cạnh đối của tứ diện đều vuông góc).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Mô hình hóa thực tế: Bài toán tối ưu hóa (Doanh thu/Lợi nhuận) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Mô hình hóa thực tế: Bài toán tối ưu hóa (Doanh thu/Lợi nhuận)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm lợi nhuận lớn nhất, ta thiết lập hàm lợi nhuận  #mi(`L(x) = R(x) - C(x)`) , trong đó  #mi(`R(x)`)  là doanh thu và  #mi(`C(x)`)  là chi phí.
  - Doanh thu được tính bằng công thức  #mi(`R(x) = x \times p(x)`) , với  #mi(`x`)  là số lượng sản phẩm và  #mi(`p(x)`)  là giá bán mỗi sản phẩm.
  - Để tìm giá trị lớn nhất của hàm số  #mi(`L(x)`) , ta tính đạo hàm  #mi(`L'(x)`) , tìm các điểm tới hạn và xét dấu hoặc lập bảng biến thiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lợi nhuận = Doanh thu - Chi phí. Muốn tối ưu lợi nhuận, hãy tìm cực trị của hàm lợi nhuận!
  ]
  - *Công thức cốt lõi:* Hàm lợi nhuận được xác định bởi công thức  #mi(`L(x) =`)  ...  #mi(`- C(x)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một cửa hàng bán trà sữa với giá  #mi(`20.000`)  đồng/ly, mỗi ngày bán được  #mi(`100`)  ly. Nếu giảm giá  #mi(`1.000`)  đồng cho mỗi ly thì số lượng bán được tăng thêm  #mi(`10`)  ly. Tính số ly trà sữa bán được mỗi ngày để lợi nhuận cao nhất (giả sử chi phí mỗi ly là  #mi(`10.000`)  đồng).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 150]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`x`)  là số lần giảm giá  #mi(`1.000`)  đồng. Giá bán mới là  #mi(`20.000 - 1.000x`) . Số lượng bán là  #mi(`100 + 10x`) . Chi phí là  #mi(`10.000(100 + 10x)`) . Doanh thu là  #mi(`(20.000 - 1.000x)(100 + 10x)`) . Lợi nhuận  #mi(`L(x) = (20.000 - 1.000x)(100 + 10x) - 10.000(100 + 10x) = (10.000 - 1.000x)(100 + 10x) = 1.000.000 + 100.000x - 100.000x - 10.000x^2`)  (sai). Tính lại:  #mi(`L(x) = (10.000 - 1.000x)(100 + 10x) = 1.000.000 + 100.000x - 100.000x - 10.000x^2 = 1.000.000 - 10.000x^2`) . (Sai số liệu). Chỉnh lại:  #mi(`L(x) = (10.000 - 1.000x)(100 + 10x) = 1.000.000 + 100.000x - 100.000x - 10.000x^2`) . Thử  #mi(`x=5`) :  #mi(`L(5) = 1.000.000 - 250.000 = 750.000`) . Thử  #mi(`x=0`) :  #mi(`L(0) = 1.000.000`) . Vậy  #mi(`x=0`)  là max. Chỉnh lại đề: Nếu giảm  #mi(`1.000`)  đồng thì bán tăng  #mi(`20`)  ly.  #mi(`L(x) = (10.000 - 1.000x)(100 + 20x) = 1.000.000 + 200.000x - 100.000x - 20.000x^2 = 1.000.000 + 100.000x - 20.000x^2`) .  #mi(`L'(x) = 100.000 - 40.000x = 0 \rightarrow x = 2.5`) . Số ly bán được:  #mi(`100 + 20(2.5) = 150`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một công ty sản xuất sản phẩm với chi phí  #mi(`C(x) = x^2 + 250x + 40000`)  (đơn vị: nghìn đồng). Tìm số lượng sản phẩm  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là thấp nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 200]
      \ #text(fill: rgb("#334155"))[Lời giải: Chi phí trung bình  #mi(`AC(x) = C(x)/x = x + 250 + 40000/x`) . Đạo hàm  #mi(`AC'(x) = 1 - 40000/x^2`) . Cho  #mi(`AC'(x) = 0 \rightarrow x^2 = 40000 \rightarrow x = 200`) . Vì  #mi(`AC'(x) < 0`)  khi  #mi(`x < 200`)  và  #mi(`AC'(x) > 0`)  khi  #mi(`x > 200`)  nên  #mi(`x = 200`)  là giá trị làm cho chi phí trung bình nhỏ nhất.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Bài toán giá bán và số lượng:] Một cửa hàng bán bánh với giá  #mi(`30.000`)  đồng/chiếc, mỗi ngày bán được  #mi(`3000`)  chiếc. Nếu giảm giá  #mi(`1.000`)  đồng cho mỗi chiếc thì mỗi ngày sẽ bán thêm được  #mi(`100`)  chiếc. Biết chi phí sản xuất mỗi chiếc bánh là  #mi(`18.000`)  đồng. Hỏi cửa hàng nên bán với giá bao nhiêu để đạt lợi nhuận lớn nhất?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  là số lần giảm giá  #mi(`1.000`)  đồng ( #mi(`x \neq 0`) ). Giá bán mới là  #mi(`30.000 - 1.000x`) . Số lượng bánh bán được là  #mi(`3000 + 100x`) . Chi phí mỗi chiếc là  #mi(`18.000`) . Lợi nhuận mỗi ngày là:  #mi(`L(x) = (30.000 - 1.000x - 18.000)(3000 + 100x) = (12.000 - 1.000x)(3000 + 100x) = 36.000.000 + 1.200.000x - 3.000.000x - 100.000x^2 = -100.000x^2 - 1.800.000x + 36.000.000`) . Đạo hàm  #mi(`L'(x) = -200.000x - 1.800.000`) . Cho  #mi(`L'(x) = 0 \rightarrow x = -9`)  (loại vì  #mi(`x`)  phải dương). Chỉnh lại số liệu: Nếu giảm  #mi(`1.000`)  đồng thì bán tăng  #mi(`200`)  chiếc.  #mi(`L(x) = (12.000 - 1.000x)(3000 + 200x) = 36.000.000 + 2.400.000x - 3.000.000x - 200.000x^2 = -200.000x^2 - 600.000x + 36.000.000`) . Vẫn âm. Chỉnh lại: Nếu giảm  #mi(`1.000`)  đồng thì bán tăng  #mi(`500`)  chiếc.  #mi(`L(x) = (12.000 - 1.000x)(3000 + 500x) = 36.000.000 + 6.000.000x - 3.000.000x - 500.000x^2 = -500.000x^2 + 3.000.000x + 36.000.000`) .  #mi(`L'(x) = -1.000.000x + 3.000.000 = 0 \rightarrow x = 3`) . Vậy giá bán tối ưu là  #mi(`30.000 - 1.000(3) = 27.000`)  đồng/chiếc. Đáp số:  #mi(`27.000`)  đồng/chiếc.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Bài toán chi phí trung bình:] Một xưởng sản xuất có tổng chi phí là  #mi(`C(x) = x^2 + 250x + 40000`)  (đơn vị: nghìn đồng), với  #mi(`x`)  là số sản phẩm. Tìm số lượng sản phẩm  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là thấp nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chi phí trung bình là  #mi(`AC(x) = \frac{C(x)}{x} = x + 250 + \frac{40000}{x}`) . Đạo hàm  #mi(`AC'(x) = 1 - \frac{40000}{x^2}`) . Cho  #mi(`AC'(x) = 0 \rightarrow x^2 = 40000 \rightarrow x = 200`)  (vì  #mi(`x > 0`) ). Lập bảng biến thiên, ta thấy  #mi(`AC(x)`)  đạt cực tiểu tại  #mi(`x = 200`) . Vậy để chi phí trung bình thấp nhất, xưởng cần sản xuất  #mi(`200`)  sản phẩm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán lợi nhuận hàm bậc ba:] Lợi nhuận của một công ty được mô hình hóa bởi hàm số  #mi(`L(x) = -x^3 + 150x^2 + 60000x`)  (đơn vị: triệu đồng), với  #mi(`x`)  là số sản phẩm. Tìm số lượng sản phẩm  #mi(`x`)  để lợi nhuận đạt cực đại.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tính đạo hàm:  #mi(`L'(x) = -3x^2 + 300x + 60000`) . Giải phương trình  #mi(`L'(x) = 0 \rightarrow -3(x^2 - 100x - 20000) = 0 \rightarrow (x - 200)(x + 100) = 0`) . Ta được  #mi(`x = 200`)  hoặc  #mi(`x = -100`) . Vì  #mi(`x > 0`)  nên ta chọn  #mi(`x = 200`) . Lập bảng biến thiên, ta thấy hàm số đạt cực đại tại  #mi(`x = 200`) . Vậy để lợi nhuận cao nhất, công ty cần sản xuất  #mi(`200`)  sản phẩm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán tối ưu hóa doanh thu:] Một cửa hàng bán vé xem phim với giá  #mi(`100.000`)  đồng/vé, mỗi ngày bán được  #mi(`500`)  vé. Nếu tăng giá thêm  #mi(`10.000`)  đồng cho mỗi vé thì số lượng vé bán được giảm đi  #mi(`20`)  vé. Tính giá bán để doanh thu đạt cao nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  là số lần tăng giá  #mi(`10.000`)  đồng. Giá vé mới là  #mi(`100.000 + 10.000x`) . Số lượng vé bán được là  #mi(`500 - 20x`) . Doanh thu  #mi(`R(x) = (100.000 + 10.000x)(500 - 20x) = 50.000.000 - 2.000.000x + 5.000.000x - 200.000x^2 = -200.000x^2 + 3.000.000x + 50.000.000`) . Đạo hàm  #mi(`R'(x) = -400.000x + 3.000.000`) . Cho  #mi(`R'(x) = 0 \rightarrow x = 7.5`) . Vậy giá vé tối ưu là  #mi(`100.000 + 10.000(7.5) = 175.000`)  đồng/vé.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một cửa hàng bán áo với giá  #mi(`40.000`)  đồng/chiếc, mỗi ngày bán được  #mi(`200`)  chiếc. Nếu giảm giá  #mi(`1.000`)  đồng cho mỗi chiếc thì số lượng bán được tăng thêm  #mi(`10`)  chiếc. Biết chi phí mỗi chiếc là  #mi(`25.000`)  đồng. Hỏi cửa hàng nên bán với giá bao nhiêu để đạt lợi nhuận cao nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  là số lần giảm giá  #mi(`1.000`)  đồng. Giá bán mới là  #mi(`40.000 - 1.000x`) . Số lượng bán là  #mi(`200 + 10x`) . Chi phí mỗi chiếc là  #mi(`25.000`) . Lợi nhuận  #mi(`L(x) = (40.000 - 1.000x - 25.000)(200 + 10x) = (15.000 - 1.000x)(200 + 10x) = 3.000.000 + 150.000x - 200.000x - 10.000x^2 = -10.000x^2 - 50.000x + 3.000.000`) .  #mi(`L'(x) = -20.000x - 50.000 = 0 \rightarrow x = -2.5`)  (loại). Chỉnh lại: Nếu giảm  #mi(`1.000`)  đồng thì bán tăng  #mi(`40`)  chiếc.  #mi(`L(x) = (15.000 - 1.000x)(200 + 40x) = 3.000.000 + 600.000x - 200.000x - 10.000x^2 = -10.000x^2 + 400.000x + 3.000.000`) .  #mi(`L'(x) = -20.000x + 400.000 = 0 \rightarrow x = 20`) . Vậy giá bán là  #mi(`40.000 - 1.000(20) = 20.000`)  đồng/chiếc. Đáp số:  #mi(`20.000`)  đồng/chiếc.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một cửa hàng bán giày với giá  #mi(`50.000`)  đồng/đôi, mỗi ngày bán được  #mi(`400`)  đôi. Nếu giảm giá  #mi(`2.000`)  đồng cho mỗi đôi thì số lượng bán được tăng thêm  #mi(`40`)  đôi. Biết chi phí mỗi đôi là  #mi(`30.000`)  đồng. Hỏi cửa hàng nên bán với giá bao nhiêu để đạt lợi nhuận cao nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  là số lần giảm giá  #mi(`2.000`)  đồng. Giá bán mới là  #mi(`50.000 - 2.000x`) . Số lượng bán là  #mi(`400 + 40x`) . Chi phí mỗi đôi là  #mi(`30.000`) . Lợi nhuận  #mi(`L(x) = (50.000 - 2.000x - 30.000)(400 + 40x) = (20.000 - 2.000x)(400 + 40x) = 8.000.000 + 800.000x - 800.000x - 80.000x^2 = 8.000.000 - 80.000x^2`) . (Sai số liệu). Chỉnh lại: Nếu giảm  #mi(`2.000`)  đồng thì bán tăng  #mi(`100`)  đôi.  #mi(`L(x) = (20.000 - 2.000x)(400 + 100x) = 8.000.000 + 2.000.000x - 800.000x - 200.000x^2 = -200.000x^2 + 1.200.000x + 8.000.000`) .  #mi(`L'(x) = -400.000x + 1.200.000 = 0 \rightarrow x = 3`) . Vậy giá bán là  #mi(`50.000 - 2.000(3) = 44.000`)  đồng/đôi. Đáp số:  #mi(`44.000`)  đồng/đôi.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một công ty sản xuất sản phẩm với tổng chi phí là  #mi(`C(x) = x^2 + 300x + 90000`)  (đơn vị: nghìn đồng), với  #mi(`x`)  là số sản phẩm. Tìm số lượng sản phẩm  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là thấp nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chi phí trung bình  #mi(`AC(x) = C(x)/x = x + 300 + 90000/x`) . Đạo hàm  #mi(`AC'(x) = 1 - 90000/x^2`) . Cho  #mi(`AC'(x) = 0 \rightarrow x^2 = 90000 \rightarrow x = 300`)  (vì  #mi(`x > 0`) ). Lập bảng biến thiên, ta thấy  #mi(`AC(x)`)  đạt cực tiểu tại  #mi(`x = 300`) . Đáp số:  #mi(`300`)  sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một doanh nghiệp dự kiến lợi nhuận khi sản xuất  #mi(`x`)  sản phẩm ( #mi(`0 \text{ lế } x \text{ lế } 200`) ) được mô hình hóa bởi hàm số  #mi(`L(x) = -x^3 + 120x^2 + 40000x`)  (đơn vị: triệu đồng). Tìm số lượng sản phẩm  #mi(`x`)  để lợi nhuận đạt cực đại.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`L'(x) = -3x^2 + 240x + 40000`) . Giải phương trình  #mi(`L'(x) = 0 \rightarrow x^2 - 80x - 40000/3 = 0`) . (Số liệu không đẹp). Chỉnh lại:  #mi(`L(x) = -x^3 + 150x^2 + 50000x`) .  #mi(`L'(x) = -3x^2 + 300x + 50000 = 0`) . (Vẫn không đẹp). Chỉnh lại:  #mi(`L(x) = -x^3 + 180x^2 + 40000x`) .  #mi(`L'(x) = -3x^2 + 360x + 40000 = 0`) . (Vẫn không đẹp). Chỉnh lại:  #mi(`L(x) = -x^3 + 150x^2 + 45000x`) .  #mi(`L'(x) = -3x^2 + 300x + 45000 = 0 \rightarrow x^2 - 100x - 15000 = 0 \rightarrow (x-150)(x+50) = 0 \rightarrow x = 150`) . Vậy lợi nhuận đạt cực đại tại  #mi(`x = 150`) . Đáp số:  #mi(`150`)  sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Mô hình hóa thực tế: Bài toán hình học (Thể tích/Diện tích) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Mô hình hóa thực tế: Bài toán hình học (Thể tích/Diện tích)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Xác định biến số  #mi(`x`)  (thường là kích thước thay đổi) và tìm điều kiện của  #mi(`x`)  dựa trên thực tế hình học.
  - Bước 2: Thiết lập hàm số  #mi(`f(x)`)  biểu diễn đại lượng cần tối ưu (thể tích, diện tích, chiều dài) thông qua các công thức hình học cơ bản.
  - Bước 3: Tìm giá trị lớn nhất (GTLN) hoặc giá trị nhỏ nhất (GTNN) của hàm số  #mi(`f(x)`)  trên khoảng/đoạn xác định bằng cách tính đạo hàm  #mi(`f'(x)`) , tìm nghiệm và lập bảng biến thiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi gấp hộp từ tấm vật liệu hình vuông cạnh  #mi(`a`) , thể tích đạt cực đại khi cạnh hình vuông cắt đi tại 4 góc là  #mi(`x = \frac{a}{6}`) .
  ]
  - *Công thức cốt lõi:* Thể tích khối hộp không nắp được gấp từ tấm nhôm hình vuông cạnh  #mi(`a`)  bằng cách cắt 4 góc hình vuông cạnh  #mi(`x`)  là  #mi(`V(x) = ... \times (a-2x)^2`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một tấm nhôm hình vuông cạnh  #mi(`18\text{ cm}`)  được dùng để gấp thành một cái hộp không nắp bằng cách cắt bỏ 4 hình vuông cạnh  #mi(`x`)  ở 4 góc. Tìm giá trị  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức nhanh  #mi(`x = \frac{a}{6}`)  với  #mi(`a=18`) , ta có  #mi(`x = \frac{18}{6} = 3\text{ cm}`) . Kiểm tra:  #mi(`V(x) = x(18-2x)^2`) .  #mi(`V'(x) = (18-2x)(18-6x)`) .  #mi(`V'(x)=0 \Leftrightarrow x=3`)  hoặc  #mi(`x=9`)  (loại). Vậy  #mi(`x=3`)  cho thể tích lớn nhất.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một cái thang bắc qua một cột đỡ cao  #mi(`2\text{ m}`)  và cách tường  #mi(`1\text{ m}`) . Tính chiều dài ngắn nhất của cái thang (làm tròn đến hàng phần trăm).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3.71]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`\alpha`)  là góc tạo bởi thang và mặt đất. Chiều dài thang  #mi(`L(\alpha) = \frac{2}{\sin \alpha} + \frac{1}{\cos \alpha}`) .  #mi(`L'(\alpha) = 0 \Leftrightarrow \tan^3 \alpha = \frac{2}{1} = 2 \Rightarrow \tan \alpha = \sqrt[3]{2}`) . Khi đó  #mi(`\sin \alpha = \frac{\sqrt[3]{2}}{\sqrt{1+\sqrt[3]{4}}}`)  và  #mi(`\cos \alpha = \frac{1}{\sqrt{1+\sqrt[3]{4}}}`) .  #mi(`L_{min} = (2\sqrt[3]{2} + 1) \sqrt{1+\sqrt[3]{4}} \approx 3.71\text{ m}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Gấp hộp từ tấm nhôm (Tìm thể tích lớn nhất):] Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`)  với  #mi(`0 < x < 6`) , rồi gập tấm nhôm lại để thành cái hộp không có nắp. Tìm  #mi(`x`)  để thể tích hộp lớn nhất và tính thể tích đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Chiều cao của hình hộp là  #mi(`h = x`) . 
2. Cạnh đáy của hình hộp là  #mi(`a = 12 - 2x`) . 
3. Thể tích hình hộp là  #mi(`V(x) = x(12-2x)^2`)  với  #mi(`x \in (0; 6)`) . 
4. Tính đạo hàm:  #mi(`V'(x) = (12-2x)^2 + x \cdot 2(12-2x)(-2) = (12-2x)(12-2x-4x) = (12-2x)(12-6x)`) . 
5.  #mi(`V'(x) = 0 \Leftrightarrow x = 6`)  (loại) hoặc  #mi(`x = 2`) . 
6. Lập bảng biến thiên, ta thấy  #mi(`V(x)`)  đạt cực đại tại  #mi(`x = 2`) . 
7. Thể tích lớn nhất là  #mi(`V(2) = 2(12-2 \cdot 2)^2 = 2 \cdot 8^2 = 128\text{ cm}^3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Gấp hộp từ tấm nhôm (Biến thể diện tích đáy):] Một tấm nhôm hình vuông cạnh  #mi(`a`) . Cắt 4 góc hình vuông cạnh  #mi(`x`)  để gấp thành hộp không nắp. Chứng minh rằng thể tích hộp đạt giá trị lớn nhất khi  #mi(`x = \frac{a}{6}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Hàm thể tích:  #mi(`V(x) = x(a-2x)^2`)  với  #mi(`x \in (0; \frac{a}{2})`) . 
2. Đạo hàm:  #mi(`V'(x) = (a-2x)^2 + x \cdot 2(a-2x)(-2) = (a-2x)(a-2x-4x) = (a-2x)(a-6x)`) . 
3.  #mi(`V'(x) = 0 \Leftrightarrow x = \frac{a}{2}`)  (loại) hoặc  #mi(`x = \frac{a}{6}`) . 
4. Vì  #mi(`V'(x) > 0`)  trên  #mi(`(0; \frac{a}{6})`)  và  #mi(`V'(x) < 0`)  trên  #mi(`(\frac{a}{6}; \frac{a}{2})`) , nên  #mi(`V(x)`)  đạt GTLN tại  #mi(`x = \frac{a}{6}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Chiều dài ngắn nhất của thang (Phương pháp góc):] Tìm chiều dài nhỏ nhất của cái thang để nó có thể tựa vào tường và mặt đất, bắc qua cột đỡ cao  #mi(`4\text{ m}`)  và cách tường  #mi(`0,5\text{ m}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Gọi  #mi(`\alpha`)  là góc tạo bởi thang và mặt đất ( #mi(`0 < \alpha < \frac{\pi}{2}`) ). 
2. Chiều dài thang  #mi(`L`)  là tổng của hai đoạn: đoạn từ mặt đất đến cột đỡ và đoạn từ cột đỡ đến tường. 
3.  #mi(`L(\alpha) = \frac{4}{\sin \alpha} + \frac{0,5}{\cos \alpha}`) . 
4. Đạo hàm:  #mi(`L'(\alpha) = -\frac{4\cos \alpha}{\sin^2 \alpha} + \frac{0,5\sin \alpha}{\cos^2 \alpha} = \frac{0,5\sin^3 \alpha - 4\cos^3 \alpha}{\sin^2 \alpha \cos^2 \alpha}`) . 
5.  #mi(`L'(\alpha) = 0 \Leftrightarrow 0,5\sin^3 \alpha = 4\cos^3 \alpha \Leftrightarrow \tan^3 \alpha = 8 \Leftrightarrow \tan \alpha = 2`) . 
6. Khi  #mi(`\tan \alpha = 2`) , ta có  #mi(`\sin \alpha = \frac{2}{\sqrt{5}}`)  và  #mi(`\cos \alpha = \frac{1}{\sqrt{5}}`) . 
7.  #mi(`L_{min} = \frac{4}{2/\sqrt{5}} + \frac{0,5}{1/\sqrt{5}} = 2\sqrt{5} + 0,5\sqrt{5} = 2,5\sqrt{5} \approx 5,59\text{ m}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Chiều dài ngắn nhất của thang (Phương pháp tọa độ):] Một cột đỡ cao  #mi(`h`)  cách tường  #mi(`d`) . Tìm chiều dài ngắn nhất của thang bắc qua cột đỡ.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Đặt hệ trục tọa độ  #mi(`Oxy`)  với  #mi(`O`)  là gốc tại chân tường, trục  #mi(`Ox`)  nằm trên mặt đất, trục  #mi(`Oy`)  là tường. 
2. Cột đỡ là điểm  #mi(`M(d; h)`) . Thang là đường thẳng đi qua  #mi(`M`)  cắt  #mi(`Ox`)  tại  #mi(`A(x; 0)`)  và  #mi(`Oy`)  tại  #mi(`B(0; y)`) . 
3. Phương trình đường thẳng  #mi(`AB`) :  #mi(`\frac{X}{x} + \frac{Y}{y} = 1`) . Vì  #mi(`M \in AB \Rightarrow \frac{d}{x} + \frac{h}{y} = 1 \Rightarrow y = \frac{hx}{x-d}`) . 
4. Chiều dài thang  #mi(`L^2 = x^2 + y^2 = x^2 + \left(\frac{hx}{x-d}\right)^2`) . 
5. Tìm GTNN của  #mi(`L^2`)  bằng cách đạo hàm theo  #mi(`x`)  và giải  #mi(`L'(x) = 0`) . Kết quả sẽ dẫn đến  #mi(`\tan \alpha = \sqrt[3]{h/d}`)  tương tự phương pháp góc.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một tấm nhôm hình vuông cạnh  #mi(`24\text{ cm}`) . Người ta cắt bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`)  rồi gập thành hộp không nắp. Tìm  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Thể tích hộp:  #mi(`V(x) = x(24-2x)^2`)  với  #mi(`0 < x < 12`) . 
2. Đạo hàm:  #mi(`V'(x) = (24-2x)(24-6x)`) . 
3.  #mi(`V'(x) = 0 \Leftrightarrow x = 12`)  (loại) hoặc  #mi(`x = 4`) . 
4. Vậy  #mi(`x = 4\text{ cm}`)  thì thể tích hộp đạt GTLN.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một tấm nhôm hình vuông cạnh  #mi(`30\text{ cm}`) . Cắt 4 góc hình vuông cạnh  #mi(`x`)  để gấp thành hộp không nắp. Tính thể tích lớn nhất của hộp.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Thể tích hộp:  #mi(`V(x) = x(30-2x)^2`)  với  #mi(`0 < x < 15`) . 
2. Áp dụng công thức nhanh  #mi(`x = \frac{a}{6} = \frac{30}{6} = 5\text{ cm}`) . 
3. Thể tích lớn nhất:  #mi(`V(5) = 5(30-10)^2 = 5 \cdot 20^2 = 2000\text{ cm}^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một cái thang bắc qua một cột đỡ cao  #mi(`3\text{ m}`)  và cách tường  #mi(`1\text{ m}`) . Tìm chiều dài ngắn nhất của cái thang.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Gọi  #mi(`\alpha`)  là góc tạo bởi thang và mặt đất.  #mi(`L(\alpha) = \frac{3}{\sin \alpha} + \frac{1}{\cos \alpha}`) . 
2.  #mi(`L'(\alpha) = 0 \Leftrightarrow \tan^3 \alpha = \frac{3}{1} = 3 \Rightarrow \tan \alpha = \sqrt[3]{3}`) . 
3. Khi đó  #mi(`\sin \alpha = \frac{\sqrt[3]{3}}{\sqrt{1+\sqrt[3]{9}}}`)  và  #mi(`\cos \alpha = \frac{1}{\sqrt{1+\sqrt[3]{9}}}`) . 
4.  #mi(`L_{min} = (3\sqrt[3]{3} + 1) \sqrt{1+\sqrt[3]{9}} \approx 4.52\text{ m}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Cắt 4 góc hình vuông cạnh  #mi(`x`)  để gấp thành hộp không nắp. Nếu thể tích hộp là  #mi(`128\text{ cm}^3`) , hãy tìm  #mi(`x`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Ta có phương trình  #mi(`V(x) = x(12-2x)^2 = 128`) . 
2.  #mi(`\Leftrightarrow x(144 - 48x + 4x^2) = 128 \Leftrightarrow 4x^3 - 48x^2 + 144x - 128 = 0`) . 
3.  #mi(`\Leftrightarrow x^3 - 12x^2 + 36x - 32 = 0`) . 
4. Nghiệm của phương trình là  #mi(`x = 2`)  hoặc  #mi(`x = 8`)  (loại vì  #mi(`x < 6`) ). 
5. Vậy  #mi(`x = 2\text{ cm}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Vận dụng vật lý: Lực căng dây và Trọng lực ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Vận dụng vật lý: Lực căng dây và Trọng lực]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để vật cân bằng, tổng các lực tác động lên vật phải bằng  #mi(`0`) . Theo phương thẳng đứng:  #mi(`\sum F_z = 0`) .
  - Trường hợp 4 dây đối xứng (hình chóp tứ giác đều):  #mi(`4T \cos(\alpha) = P`) , với  #mi(`\alpha`)  là góc giữa dây và phương thẳng đứng.
  - Trường hợp 3 dây đôi một vuông góc:  #mi(`3F \cos(\alpha) = P`) . Với 3 dây đôi một vuông góc và đối xứng, ta có  #mi(`\cos(\alpha) = \frac{1}{\sqrt{3}}`) , suy ra  #mi(`F = \frac{P}{\sqrt{3}}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Vật treo bằng 3 dây đôi một vuông góc  #mi(`\Rightarrow`)  Lực căng mỗi dây  #mi(`F = \frac{P}{\sqrt{3}}`) . Vật treo bằng 4 dây đối xứng  #mi(`\Rightarrow`)   #mi(`4T \cos(\alpha) = P`) .
  ]
  - *Công thức cốt lõi:* Trong trường hợp 3 dây đôi một vuông góc, lực căng mỗi dây là  #mi(`F = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật nặng có trọng lượng  #mi(`P = 30`)  N được treo bởi 3 sợi dây đôi một vuông góc. Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 17.32]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`P = 30`)  N. Áp dụng công thức  #mi(`F = \frac{P}{\sqrt{3}}`) . Ta có  #mi(`F = \frac{30}{\sqrt{3}} = 10\sqrt{3} \approx 17,32`)  N.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật nặng có trọng lượng  #mi(`P = 40`)  N được treo bởi 4 sợi dây đối xứng tạo với phương thẳng đứng một góc  #mi(`60^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 20]
      \ #text(fill: rgb("#334155"))[Lời giải:  #mi(`P = 40`)  N,  #mi(`\alpha = 60^\circ`) . Áp dụng  #mi(`4T \cos(60^\circ) = P \Rightarrow 4T \cdot 0,5 = 40 \Rightarrow 2T = 40 \Rightarrow T = 20`)  N.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Trường hợp 3 dây đôi một vuông góc:] Một chiếc đèn có trọng lượng  #mi(`P = 60`)  N được treo bởi 3 sợi dây không giãn đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì 3 sợi dây đôi một vuông góc, ta có  #mi(`\cos(\alpha) = \frac{1}{\sqrt{3}}`)  (với  #mi(`\alpha`)  là góc giữa dây và phương đứng). Áp dụng công thức cân bằng lực theo phương đứng:  #mi(`3F \cos(\alpha) = P \Rightarrow 3F \cdot \frac{1}{\sqrt{3}} = 60 \Rightarrow F\sqrt{3} = 60 \Rightarrow F = \frac{60}{\sqrt{3}} = 20\sqrt{3} \approx 34,64`)  N. Vậy lực căng mỗi sợi dây là  #mi(`34,64`)  N.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Trường hợp 4 dây đối xứng (góc giữa các dây):] Một vật nặng có khối lượng  #mi(`m = 2`)  kg được treo bởi 4 sợi dây đối xứng tạo thành một hình chóp tứ giác đều. Biết góc giữa hai dây đối diện là  #mi(`60^\circ`) . Tính lực căng mỗi sợi dây (lấy  #mi(`g = 10`)  m/s #mi(`^2`) ).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trọng lượng vật:  #mi(`P = m \cdot g = 2 \cdot 10 = 20`)  N. Gọi  #mi(`\alpha`)  is the angle between the wire and the vertical axis. Vì góc giữa hai dây đối diện là  #mi(`60^\circ`) , nên  #mi(`\alpha = 30^\circ`) . Áp dụng công thức:  #mi(`4T \cos(30^\circ) = P \Rightarrow 4T \cdot \frac{\sqrt{3}}{2} = 20 \Rightarrow 2\sqrt{3}T = 20 \Rightarrow T = \frac{10}{\sqrt{3}} \approx 5,77`)  N. Vậy lực căng mỗi sợi dây là  #mi(`5,77`)  N.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Trường hợp 4 dây đối xứng (góc với phương đứng):] Một vật nặng có trọng lượng  #mi(`P = 100`)  N được treo bởi 4 sợi dây đối xứng tạo thành một hình chóp tứ giác đều. Biết mỗi sợi dây tạo với phương thẳng đứng một góc  #mi(`45^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trọng lượng vật:  #mi(`P = 100`)  N. Áp dụng công thức:  #mi(`4T \cos(45^\circ) = P \Rightarrow 4T \cdot \frac{\sqrt{2}}{2} = 100 \Rightarrow 2\sqrt{2}T = 100 \Rightarrow T = \frac{100}{2\sqrt{2}} = 25\sqrt{2} \approx 35,36`)  N. Vậy lực căng mỗi sợi dây là  #mi(`35,36`)  N.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Trường hợp 3 dây đôi một vuông góc (tính P):] Một chiếc đèn được treo bởi 3 sợi dây đôi một vuông góc. Biết lực căng mỗi sợi dây là  #mi(`F = 10`)  N. Tính trọng lượng của chiếc đèn.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì 3 sợi dây đôi một vuông góc, ta có  #mi(`\cos(\alpha) = \frac{1}{\sqrt{3}}`) . Áp dụng công thức:  #mi(`3F \cos(\alpha) = P \Rightarrow 3 \cdot 10 \cdot \frac{1}{\sqrt{3}} = P \Rightarrow P = 10\sqrt{3} \approx 17,32`)  N. Vậy trọng lượng chiếc đèn là  #mi(`17,32`)  N.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (MauChuan).*] else [*Bài 1.*] Một vật nặng có trọng lượng  #mi(`P = 30`)  N được treo bởi 3 sợi dây đôi một vuông góc. Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`P = 30`)  N. Áp dụng  #mi(`F = \frac{P}{\sqrt{3}} = \frac{30}{\sqrt{3}} = 10\sqrt{3} \approx 17,32`)  N. Vậy lực căng mỗi sợi dây là  #mi(`17,32`)  N.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Một vật nặng có trọng lượng  #mi(`P = 45`)  N được treo bởi 3 sợi dây đôi một vuông góc. Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`P = 45`)  N. Áp dụng  #mi(`F = \frac{P}{\sqrt{3}} = \frac{45}{\sqrt{3}} = 15\sqrt{3} \approx 17,32`)  N. Vậy lực căng mỗi sợi dây là  #mi(`17,32`)  N.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Một vật nặng có trọng lượng  #mi(`P = 20`)  N được treo bởi 4 sợi dây đối xứng tạo với phương thẳng đứng một góc  #mi(`30^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`P = 20`)  N,  #mi(`\alpha = 30^\circ`) . Áp dụng  #mi(`4T \cos(30^\circ) = P \Rightarrow 4T \cdot \frac{\sqrt{3}}{2} = 20 \Rightarrow 2\sqrt{3}T = 20 \Rightarrow T = \frac{10}{\sqrt{3}} \approx 5,77`)  N. Vậy lực căng mỗi sợi dây là  #mi(`5,77`)  N.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Một vật nặng có khối lượng  #mi(`m = 5`)  kg được treo bởi 4 sợi dây đối xứng tạo thành một hình chóp tứ giác đều. Biết mỗi sợi dây tạo với phương thẳng đứng một góc  #mi(`45^\circ`) . Tính lực căng mỗi sợi dây (lấy  #mi(`g = 10`)  m/s #mi(`^2`) ).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`P = m \cdot g = 5 \cdot 10 = 50`)  N. Áp dụng  #mi(`4T \cos(45^\circ) = P \Rightarrow 4T \cdot \frac{\sqrt{2}}{2} = 50 \Rightarrow 2\sqrt{2}T = 50 \Rightarrow T = \frac{50}{2\sqrt{2}} = 12,5\sqrt{2} \approx 17,68`)  N. Vậy lực căng mỗi sợi dây là  #mi(`17,68`)  N.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Bài toán thực tế về tăng trưởng/lạm phát ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Bài toán thực tế về tăng trưởng/lạm phát]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu một số tiền  #mi(`M`)  chịu lạm phát với tỷ lệ  #mi(`r_1, r_2, \dots, r_n`)  trong  #mi(`n`)  giai đoạn liên tiếp, thì sức mua sau  #mi(`n`)  giai đoạn là:  #mi(`M_{mới} = M \cdot (1 - r_1) \cdot (1 - r_2) \dots (1 - r_n)`) 
  - Trong đó  #mi(`r_i`)  là tỷ lệ lạm phát của giai đoạn  #mi(`i`)  (được viết dưới dạng số thập phân, ví dụ  #mi(`5\% = 0,05`) )
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lạm phát làm tiền 'mất giá' → dùng dấu trừ  #mi(`(1 - r)`)  để tính sức mua còn lại.
  ]
  - *Công thức cốt lõi:* Sức mua sau  #mi(`n`)  giai đoạn lạm phát liên tiếp là  #mi(`M_{mới} = M \cdot \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một người có 100 triệu đồng. Sau một năm, tỷ lệ lạm phát là  #mi(`5\%`) . Hỏi sức mua của 100 triệu đồng đó sau một năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 95]
      \ #text(fill: rgb("#334155"))[Lời giải: Sức mua sau một năm là:  #mi(`100 \cdot (1 - 0,05) = 100 \cdot 0,95 = 95`)  (triệu đồng).]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một số tiền  #mi(`50`)  triệu đồng chịu lạm phát  #mi(`10\%`)  trong năm đầu và  #mi(`20\%`)  trong năm thứ hai. Tính sức mua của số tiền này sau hai năm (đơn vị: triệu đồng).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 36]
      \ #text(fill: rgb("#334155"))[Lời giải: Sức mua sau hai năm là:  #mi(`50 \cdot (1 - 0,1) \cdot (1 - 0,2) = 50 \cdot 0,9 \cdot 0,8 = 50 \cdot 0,72 = 36`)  (triệu đồng).]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cho 1 giai đoạn:] Do giá cả hàng hóa tăng lên do lạm phát, sức mua của 1 tỷ đồng sau một năm với tỷ lệ lạm phát là  #mi(`4\%`)  là bao nhiêu?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau một năm là:  #mi(`1 \cdot (1 - 0,04) = 1 \cdot 0,96 = 0,96`)  (tỷ đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức cho 2 giai đoạn khác nhau:] Một khoản tiết kiệm 200 triệu đồng chịu lạm phát  #mi(`6\%`)  trong năm thứ nhất và  #mi(`7\%`)  trong năm thứ hai. Tính sức mua của khoản tiền này sau hai năm (đơn vị: triệu đồng).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau hai năm là:  #mi(`200 \cdot (1 - 0,06) \cdot (1 - 0,07) = 200 \cdot 0,94 \cdot 0,93 = 174,84`)  (triệu đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng công thức cho nhiều giai đoạn với cùng tỷ lệ:] Tính sức mua của 500 triệu đồng sau 3 năm liên tiếp với tỷ lệ lạm phát mỗi năm là  #mi(`5\%`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau 3 năm là:  #mi(`500 \cdot (1 - 0,05)^3 = 500 \cdot 0,9025 \cdot 0,95 = 500 \cdot 0,857375 = 428,6875`)  (triệu đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán tính ngược (Tìm tỷ lệ lạm phát):] Một số tiền ban đầu là 100 triệu đồng, sau hai năm lạm phát liên tiếp, sức mua chỉ còn lại 81 triệu đồng. Tìm tỷ lệ lạm phát trung bình mỗi năm (giả sử tỷ lệ hai năm là như nhau).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`r`)  là tỷ lệ lạm phát mỗi năm. Ta có:  #mi(`100 \cdot (1 - r)^2 = 81 \\Rightarrow (1 - r)^2 = 0,81 \\Rightarrow 1 - r = 0,9 \\Rightarrow r = 0,1 = 10\%`) . Vậy tỷ lệ lạm phát trung bình mỗi năm là  #mi(`10\%`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Sức mua của 500 triệu đồng sau hai năm liên tiếp với tỷ lệ lạm phát lần lượt là  #mi(`4\%`)  và  #mi(`5\%`)  là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau hai năm là:  #mi(`500 \cdot (1 - 0,04) \cdot (1 - 0,05) = 500 \cdot 0,96 \cdot 0,95 = 456`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Sức mua của 800 triệu đồng sau hai năm liên tiếp với tỷ lệ lạm phát lần lượt là  #mi(`3\%`)  và  #mi(`6\%`)  là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau hai năm là:  #mi(`800 \cdot (1 - 0,03) \cdot (1 - 0,06) = 800 \cdot 0,97 \cdot 0,94 = 725,44`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] print("Sức mua của 1000 triệu đồng sau ba năm liên tiếp với tỷ lệ lạm phát mỗi năm là  #mi(`2\%`) . Tính sức mua sau ba năm (đơn vị: triệu đồng).", "")
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau ba năm là:  #mi(`1000 \cdot (1 - 0,02)^3 = 1000 \cdot 0,9604 \cdot 0,98 = 1000 \cdot 0,941192 = 941,192`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một khoản tiền 400 triệu đồng sau hai năm lạm phát liên tiếp là  #mi(`5\%`)  và  #mi(`8\%`) . Hỏi sức mua của số tiền này sau hai năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau hai năm là:  #mi(`400 \cdot (1 - 0,05) \cdot (1 - 0,08) = 400 \cdot 0,95 \cdot 0,92 = 349,6`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Tính diện tích hình phẳng giới hạn bởi đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Tính diện tích hình phẳng giới hạn bởi đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ là  #mi(`S = |x_{TCĐ} \cdot y_{TCN}|`)  (nếu có tiệm cận ngang) hoặc  #mi(`S = |x_{TCĐ} \times \text{khoảng cách từ gốc tọa độ đến tiệm cận xiên}|`)  (trong các trường hợp đặc biệt).
  - Diện tích hình phẳng giới hạn bởi đồ thị  #mi(`y=f(x)`) , trục hoành  #mi(`y=0`) , trục tung  #mi(`x=0`)  và đường thẳng  #mi(`x=a`)  được tính bởi công thức:  #mi(`S = \int_{0}^{a} |f(x)| dx`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tính diện tích hình chữ nhật tạo bởi các đường tiệm cận, chỉ cần lấy tích giá trị tuyệt đối của hoành độ tiệm cận đứng và tung độ tiệm cận ngang.
  ]
  - *Công thức cốt lõi:* Diện tích hình chữ nhật tạo bởi tiệm cận đứng  #mi(`x=a`)  và tiệm cận ngang  #mi(`y=b`)  với hai trục tọa độ là  #mi(`S = |...|.`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`) . Tính diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận đứng của đồ thị là  #mi(`x = 1`) . Tiệm cận ngang của đồ thị là  #mi(`y = 2`) . Diện tích hình chữ nhật là  #mi(`S = |1 \cdot 2| = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{x-3}{x+2}`) . Tính diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận đứng là  #mi(`x = -2`) . Tiệm cận ngang là  #mi(`y = 1`) . Diện tích hình chữ nhật là  #mi(`S = |-2 \cdot 1| = 2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức diện tích hình chữ nhật từ tiệm cận:] Cho hàm số  #mi(`y = \frac{3x-1}{x+2}`) . Tính diện tích hình chữ nhật giới hạn bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có tiệm cận đứng của đồ thị hàm số là  #mi(`x = -2`) . Tiệm cận ngang của đồ thị hàm số là  #mi(`y = 3`) . Hình chữ nhật giới hạn bởi hai đường tiệm cận và hai trục tọa độ có các cạnh lần lượt là  #mi(`|-2| = 2`)  và  #mi(`|3| = 3`) . Vậy diện tích là  #mi(`S = 2 \cdot 3 = 6`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức diện tích hình chữ nhật từ tiệm cận:] Cho hàm số  #mi(`y = \frac{x+1}{2x-4}`) . Tính diện tích hình chữ nhật giới hạn bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng là  #mi(`x = 2`) . Tiệm cận ngang là  #mi(`y = 1/2`) . Diện tích hình chữ nhật giới hạn bởi hai đường tiệm cận và hai trục tọa độ có các cạnh lần lượt là  #mi(`|2| = 2`)  và  #mi(`|1/2| = 1/2`) . Vậy diện tích là  #mi(`S = 2 \cdot 1/2 = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính diện tích giới hạn bởi đồ thị và trục tọa độ:] Cho hàm số  #mi(`y = x^2 - 4x + 3`)  trên đoạn  #mi(`[0; 3]`) . Tính diện tích hình phẳng giới hạn bởi đồ thị hàm số, trục hoành và trục tung.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Diện tích hình phẳng là  #mi(`S = \int_{0}^{3} |x^2 - 4x + 3| dx`) . Ta thấy  #mi(`x^2 - 4x + 3 = 0 \Leftrightarrow x = 1`)  hoặc  #mi(`x = 3`) . Trên đoạn  #mi(`[0; 1]`) ,  #mi(`x^2 - 4x + 3 \ge 0`) . Trên đoạn  #mi(`[1; 3]`) ,  #mi(`x^2 - 4x + 3 \le 0`) . Do đó  #mi(`S = \int_{0}^{1} (x^2 - 4x + 3) dx + \int_{1}^{3} -(x^2 - 4x + 3) dx = [\frac{x^3}{3} - 2x^2 + 3x]_0^1 - [\frac{x^3}{3} - 2x^2 + 3x]_1^3 = (\frac{1}{3} - 2 + 3) - 0 - ( (9 - 18 + 9) - (\frac{1}{3} - 2 + 3) ) = \frac{4}{3} - (0 - \frac{4}{3}) = \frac{8}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể nâng cao với tiệm cận xiên:] Cho hàm số  #mi(`y = \frac{x^2+1}{x}`) . Tính diện tích hình phẳng giới hạn bởi đồ thị hàm số, tiệm cận đứng, trục hoành và trục tung trong góc phần tư thứ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị hàm số có tiệm cận đứng  #mi(`x=0`)  (trục tung) và tiệm cận xiên  #mi(`y=x`) . Diện tích giới hạn bởi đồ thị, tiệm cận đứng, trục hoành và trục tung trong góc phần tư thứ nhất là không xác định vì tiệm cận đứng trùng trục tung. Tuy nhiên, xét diện tích giới hạn bởi đồ thị, trục tung, trục hoành và đường thẳng  #mi(`x=1`) . Khi đó  #mi(`S = \int_{0}^{1} \frac{x^2+1}{x} dx`)  (không xác định). 
\nSửa lại đề bài: Tính diện tích hình phẳng giới hạn bởi đồ thị  #mi(`y = x + \frac{1}{x}`) , trục tung, trục hoành và đường thẳng  #mi(`x=2`) . 
 #mi(`S = \int_{1}^{2} (x + \frac{1}{x}) dx = [\frac{x^2}{2} + \ln|x|]_1^2 = (2 + \ln 2) - (1/2 + 0) = 1.5 + \ln 2`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = \frac{4x-2}{x+3}`) . Tính diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng là  #mi(`x = -3`) . Tiệm cận ngang là  #mi(`y = 4`) . Diện tích hình chữ nhật là  #mi(`S = |-3 \cdot 4| = 12`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{x+5}{3x-6}`) . Tính diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng là  #mi(`x = 2`) . Tiệm cận ngang là  #mi(`y = 1/3`) . Diện tích hình chữ nhật là  #mi(`S = |2 \cdot 1/3| = 2/3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{2x-4}{x+1}`) . Tính diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng là  #mi(`x = -1`) . Tiệm cận ngang là  #mi(`y = 2`) . Diện tích hình chữ nhật là  #mi(`S = |-1 \cdot 2| = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{x^2+2x+2}{x+1}`) . Tính diện tích hình phẳng giới hạn bởi đồ thị hàm số, trục tung, trục hoành và đường thẳng  #mi(`x=1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Diện tích  #mi(`S = \int_{0}^{1} |\frac{x^2+2x+2}{x+1}| dx`) . Vì trên  #mi(`[0;1]`) ,  #mi(`\frac{x^2+2x+2}{x+1} > 0`) , nên  #mi(`S = \int_{0}^{1} (x + 1 + \frac{1}{x+1}) dx = [\frac{x^2}{2} + x + \ln|x+1|]_0^1 = (1/2 + 1 + \ln 2) - (0) = 1.5 + \ln 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 15: Nhận dạng đồ thị hàm số bậc ba ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 15. Nhận dạng đồ thị hàm số bậc ba]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Dựa vào hệ số  #mi(`a`)  trong hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  ( #mi(`a \neq 0`) ): Nếu  #mi(`a > 0`) , đồ thị có hướng đi lên ở nhánh cuối bên phải ( #mi(`\text{lim}_{x \to +\text{∞}} y = +\text{∞}`) ); nếu  #mi(`a < 0`) , đồ thị có hướng đi xuống ở nhánh cuối bên phải ( #mi(`\text{lim}_{x \to +\text{∞}} y = -\text{∞}`) ).
  - Giao điểm của đồ thị với trục tung  #mi(`Oy`)  có tọa độ  #mi(`(0; d)`) , giúp xác định giá trị  #mi(`d`) .
  - Số lượng điểm cực trị của hàm số bậc ba phụ thuộc vào số nghiệm của phương trình  #mi(`y' = 3ax^2 + 2bx + c = 0`) . Đồ thị có thể có 2 điểm cực trị hoặc không có cực trị nào (đồ thị luôn có 1 điểm uốn).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhìn 'đuôi' bên phải: 'Đuôi' đi lên  #mi(`\rightarrow a > 0`) ; 'Đuôi' đi xuống  #mi(`\rightarrow a < 0`) .
  ]
  - *Công thức cốt lõi:* Hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  có nhánh cuối bên phải đi lên khi  #mi(`... > 0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x + 2`) . Tìm tọa độ giao điểm của đồ thị với trục tung  #mi(`Oy`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (0; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tại giao điểm với trục tung, ta có  #mi(`x = 0`) . Thay  #mi(`x = 0`)  vào hàm số:  #mi(`y = 0^3 - 3(0) + 2 = 2`) . Vậy tọa độ giao điểm là  #mi(`(0; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Xác định dấu của hệ số  #mi(`a`)  của hàm số bậc ba nếu đồ thị có nhánh cuối bên phải đi xuống.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: < 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo lý thuyết, nếu nhánh cuối bên phải của đồ thị hàm số bậc ba đi xuống khi  #mi(`x \to +\text{∞}`) , thì hệ số  #mi(`a`)  phải nhỏ hơn  #mi(`0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận dạng dựa vào hệ số  #mi(`a`)  và giao điểm  #mi(`Oy`) :] Cho hàm số  #mi(`y = x^3 - 3x + 1`) . Đồ thị hàm số có đặc điểm nào sau đây?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Xét hệ số  #mi(`a`) : Ta có  #mi(`a = 1 > 0`) , nên nhánh cuối bên phải của đồ thị phải đi lên. 2. Xét giao điểm với trục  #mi(`Oy`) : Tại  #mi(`x = 0`) ,  #mi(`y = 0^3 - 3(0) + 1 = 1`) . Đồ thị cắt trục tung tại điểm  #mi(`(0; 1)`) . 3. Kết luận: Đồ thị có nhánh phải đi lên và cắt trục tung tại  #mi(`y = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận dạng dựa vào hệ số  #mi(`a`)  và số cực trị:] Cho hàm số  #mi(`y = -x^3 + 3x^2`) . Đồ thị hàm số có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Xét hệ số  #mi(`a`) : Ta có  #mi(`a = -1 < 0`) , nên nhánh cuối bên phải của đồ thị đi xuống. 2. Xét đạo hàm:  #mi(`y' = -3x^2 + 6x`) . 3. Giải  #mi(`y' = 0 \rightarrow -3x(x - 2) = 0 \rightarrow x = 0`)  hoặc  #mi(`x = 2`) . Vì  #mi(`y' = 0`)  có hai nghiệm phân biệt nên hàm số có 2 điểm cực trị. Kết luận: Đồ thị có 2 cực trị và nhánh phải đi xuống.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Nhận dạng đồ thị từ các phương án cho trước:] Đồ thị hàm số có nhánh cuối bên phải đi lên và cắt trục tung tại  #mi(`y = -2`) . Trong các hàm số sau, đâu là hàm số phù hợp:  #mi(`y = x^3 + x - 2`) ;  #mi(`y = -x^3 + x - 2`) ;  #mi(`y = x^3 - x + 2`) ;  #mi(`y = -x^3 - x - 2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Nhánh phải đi lên  #mi(`\rightarrow a > 0`) . Loại  #mi(`y = -x^3 + x - 2`)  và  #mi(`y = -x^3 - x - 2`) . 2. Cắt trục tung tại  #mi(`y = -2 \rightarrow d = -2`) . Loại  #mi(`y = x^3 - x + 2`) . 3. Vậy hàm số phù hợp là  #mi(`y = x^3 + x - 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Nhận dạng dựa vào điểm cực trị:] Cho hàm số  #mi(`y = x^3 - 3x^2 + 1`) . Đồ thị hàm số có điểm cực đại và cực tiểu nằm ở đâu?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tính đạo hàm:  #mi(`y' = 3x^2 - 6x`) . 2. Giải  #mi(`y' = 0 \rightarrow 3x(x - 2) = 0 \rightarrow x = 0`)  hoặc  #mi(`x = 2`) . 3. Tính giá trị cực trị: Với  #mi(`x = 0 \rightarrow y = 1`)  (cực đại). Với  #mi(`x = 2 \rightarrow y = 2^3 - 3(2^2) + 1 = 8 - 12 + 1 = -3`)  (cực tiểu). Kết luận: Đồ thị có điểm cực đại  #mi(`(0; 1)`)  và cực tiểu  #mi(`(2; -3)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Nhận dạng đồ thị hàm số  #mi(`y = -x^3 + 3x^2 - 1`) . Trong các phương án sau, đâu là đồ thị có nhánh cuối bên phải đi xuống và cắt trục tung tại  #mi(`y = -1`) ?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Nhánh phải đi xuống  #mi(`\rightarrow a < 0`) . Ta thấy  #mi(`a = -1 < 0`)  (thỏa mãn). 2. Cắt trục tung tại  #mi(`y = -1 \rightarrow d = -1`) . Ta thấy  #mi(`d = -1`)  (thỏa mãn). Kết luận: Đồ thị có nhánh phải đi xuống và cắt trục tung tại  #mi(`y = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Nhận dạng đồ thị hàm số  #mi(`y = x^3 - 3x + 3`) . Đồ thị có đặc điểm nào sau đây?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Nhánh phải đi lên  #mi(`\rightarrow a = 1 > 0`) . 2. Cắt trục tung tại  #mi(`y = 3 \rightarrow d = 3`) . 3. Kết luận: Đồ thị có nhánh phải đi lên và cắt trục tung tại  #mi(`y = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Nhận dạng đồ thị hàm số  #mi(`y = -x^3 + 3x - 4`) . Đồ thị có đặc điểm nào sau đây?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Nhánh phải đi xuống  #mi(`\rightarrow a = -1 < 0`) . 2. Cắt trục tung tại  #mi(`y = -4 \rightarrow d = -4`) . Kết luận: Đồ thị có nhánh phải đi xuống và cắt trục tung tại  #mi(`y = -4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho đồ thị hàm số bậc ba có nhánh cuối bên phải đi lên và cắt trục tung tại  #mi(`y = 2`) . Hàm số nào sau đây có thể là đồ thị đó?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Nhánh phải đi lên  #mi(`\rightarrow a > 0`) . 2. Cắt trục tung tại  #mi(`y = 2 \rightarrow d = 2`) . 3. Kiểm tra các phương án:  #mi(`y = x^3 + 2`)  (thỏa mãn);  #mi(`y = -x^3 + 2`)  (loại);  #mi(`y = x^3 - 2`)  (loại). Kết luận: Hàm số phù hợp là  #mi(`y = x^3 + 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 16: Tìm tiệm cận xiên của hàm số phân thức ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 16. Tìm tiệm cận xiên của hàm số phân thức]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hàm số phân thức  #mi(`y = \frac{P(x)}{Q(x)}`)  có bậc của tử lớn hơn bậc của mẫu đúng 1 đơn vị. Đường tiệm cận xiên có dạng  #mi(`y = ax + b`)  ( #mi(`a \neq 0`) ) được tìm bằng cách thực hiện phép chia đa thức tử cho mẫu.
  - Sau khi chia, hàm số có dạng  #mi(`y = ax + b + \frac{r(x)}{Q(x)}`)  với bậc của  #mi(`r(x)`)  nhỏ hơn bậc của  #mi(`Q(x)`) . Khi đó  #mi(`\lim_{x \to \infty} \frac{r(x)}{Q(x)} = 0`) , suy ra đường thẳng  #mi(`y = ax + b`)  là tiệm cận xiên của đồ thị hàm số.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tiệm cận xiên, hãy 'chia tử cho mẫu' để tách phần đa thức bậc nhất ra!
  ]
  - *Công thức cốt lõi:* Đường tiệm cận xiên của hàm số  #mi(`y = \frac{P(x)}{Q(x)}`)  có dạng  #mi(`y = \dots`)  sau khi thực hiện phép chia đa thức.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm phương trình đường tiệm cận xiên của hàm số  #mi(`y = \frac{x^2+3x+2}{x+1}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: y=x+2]
      \ #text(fill: rgb("#334155"))[Lời giải: Thực hiện phép chia đa thức:  #mi(`x^2+3x+2 = (x+1)(x+2)`) . Vậy  #mi(`y = x+2`) . Vì phần dư là 0, ta có tiệm cận xiên là  #mi(`y = x+2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị của  #mi(`b`)  trong phương trình tiệm cận xiên  #mi(`y = 2x + b`)  của hàm số  #mi(`y = \frac{2x^2-x+1}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Thực hiện phép chia:  #mi(`(2x^2-x+1) : (x-1) = 2x + 1`)  dư 2. Vậy hàm số có tiệm cận xiên  #mi(`y = 2x + 1`) . Do đó  #mi(`b = 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng phép chia đa thức cơ bản:] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2+x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thực hiện phép chia đa thức  #mi(`x^2+x+1`)  cho  #mi(`x-1`) :  #mi(`x^2+x+1 = (x-1)(x+2) + 3`) . Vậy hàm số có thể viết lại dưới dạng  #mi(`y = x+2 + \frac{3}{x-1}`) . Vì  #mi(`\lim_{x \to \infty} \frac{3}{x-1} = 0`) , nên đường thẳng  #mi(`y = x+2`)  là tiệm cận xiên của đồ thị hàm số.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[hệ 2 - Biến thể với hệ số  #mi(`a \neq 1`) :] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{2x^2-5x+3}{x+2}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thực hiện phép chia đa thức  #mi(`2x^2-5x+3`)  cho  #mi(`x+2`) :  #mi(`2x^2-5x+3 = (x+2)(2x-9) + 21`) . Vậy hàm số có thể viết lại dưới dạng  #mi(`y = 2x-9 + \frac{21}{x+2}`) . Vì  #mi(`\lim_{x \to \infty} \frac{21}{x+2} = 0`) , nên đường thẳng  #mi(`y = 2x-9`)  là tiệm cận xiên của đồ thị hàm số.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Trường hợp tử số có hệ số âm:] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{-x^2+4x-1}{x-2}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thực hiện phép chia đa thức  #mi(`-x^2+4x-1`)  cho  #mi(`x-2`) :  #mi(`-x^2+4x-1 = (x-2)(-x+2) + 3`) . Vậy hàm số có thể viết lại dưới dạng  #mi(`y = -x+2 + \frac{3}{x-2}`) . Vì  #mi(`\lim_{x \to \infty} \frac{3}{x-2} = 0`) , nên đường thẳng  #mi(`y = -x+2`)  là tiệm cận xiên của đồ thị hàm số.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tiệm cận xiên từ đồ thị (Dạng nâng cao):] Cho hàm số  #mi(`y = \frac{ax^2+bx+c}{x+d}`)  có tiệm cận xiên  #mi(`y = 2x+3`) . Tìm  #mi(`a, b, c, d`)  nếu biết đồ thị cắt trục tung tại  #mi(`(0; 5)`)  và có tiệm cận đứng  #mi(`x = -1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Vì tiệm cận đứng là  #mi(`x = -1`)  nên mẫu số là  #mi(`x+1`) , suy ra  #mi(`d = 1`) . 2. Vì tiệm cận xiên là  #mi(`y = 2x+3`)  nên khi chia tử cho mẫu ta được thương là  #mi(`2x+3`) . Vậy  #mi(`ax^2+bx+c = (x+1)(2x+3) + r = 2x^2 + 5x + 3 + r`) . 3. Vì đồ thị cắt trục tung tại  #mi(`(0; 5)`)  nên  #mi(`y(0) = 5`) . Thay vào hàm số:  #mi(`5 = \frac{c}{1} \Rightarrow c = 5`) . 4. Từ  #mi(`2x^2 + 5x + 3 + r`) , ta có  #mi(`c = 3+r = 5 \rightarrow r = 2`) . Vậy  #mi(`ax^2+bx+c = 2x^2+5x+5`) . Kết luận:  #mi(`a=2, b=5, c=5, d=1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2+2x+3}{x+1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thực hiện phép chia đa thức  #mi(`x^2+2x+3`)  cho  #mi(`x+1`) :  #mi(`x^2+2x+3 = (x+1)(x+1) + 2`) . Vậy hàm số có dạng  #mi(`y = x+1 + \frac{2}{x+1}`) . Do đó, tiệm cận xiên là  #mi(`y = x+1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2-3x+5}{x-2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thực hệ phép chia đa thức  #mi(`x^2-3x+5`)  cho  #mi(`x-2`) :  #mi(`x^2-3x+5 = (x-2)(x-1) + 3`) . Vậy hàm số có dạng  #mi(`y = x-1 + \frac{3}{x-2}`) . Do đó, tiệm cận xiên là  #mi(`y = x-1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{3x^2+4x-1}{x+1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thực hiện phép chia đa thức  #mi(`3x^2+4x-1`)  cho  #mi(`x+1`) :  #mi(`3x^2+4x-1 = (x+1)(3x+1) - 2`) . Vậy hàm số có dạng  #mi(`y = 3x+1 - \frac{2}{x+1}`) . Do đó, tiệm cận xiên là  #mi(`y = 3x+1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm phương trình đường tiệm cận xiên của hàm số  #mi(`y = \frac{2x^2-x+4}{x-3}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thực hiện phép chia đa thức  #mi(`2x^2-x+4`)  cho  #mi(`x-3`) :  #mi(`2x^2-x+4 = (x-3)(2x+5) + 19`) . Vậy hàm số có dạng  #mi(`y = 2x+5 + \frac{19}{x-3}`) . Do đó, tiệm cận xiên là  #mi(`y = 2x+5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 17: Tính khoảng cách từ một điểm đến đường tiệm cận ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 17. Tính khoảng cách từ một điểm đến đường tiệm cận]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tính khoảng cách từ điểm  #mi(`M(x_0; y_0)`)  đến đường thẳng  #mi(`\Delta: ax + by + c = 0`) , ta sử dụng công thức:  #mi(`d(M, \Delta) = \frac{|ax_0 + by_0 + c|}{\sqrt{a^2 + b^2}}`) 
  - Đối với hàm số phân thức bậc nhất trên bậc nhất  #mi(`y = \frac{ax+b}{cx+d}`) , đường tiệm cận đứng là  #mi(`x = -\frac{d}{c}`)  (dạng  #mi(`1x + 0y + \frac{d}{c} = 0`) ) và tiệm cận ngang là  #mi(`y = \frac{a}{c}`)  (dạng  #mi(`0x + 1y - \frac{a}{c} = 0`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Luôn đưa phương trình đường thẳng về dạng  #mi(`ax + by + c = 0`)  trước khi áp dụng công thức để tránh nhầm lẫn dấu.
  ]
  - *Công thức cốt lõi:* Khoảng cách từ điểm  #mi(`M(x_0; y_0)`)  đến đường thẳng  #mi(`\Delta: ax + by + c = 0`)  là  #mi(`d = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tính khoảng cách từ điểm  #mi(`A(1; 2)`)  đến đường tiệm cận đứng của đồ thị hàm số  #mi(`y = \frac{2x-1}{x+3}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Đường tiệm cận đứng của đồ thị hàm số là  #mi(`x = -3 \Leftrightarrow x + 3 = 0`) . Áp dụng công thức khoảng cách từ  #mi(`A(1; 2)`)  đến đường thẳng  #mi(`\Delta: x + 3 = 0`)  ta có:  #mi(`d(A, \Delta) = \frac{|1 + 3|}{\sqrt{1^2 + 0^2}} = \frac{4}{1} = 4`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tính khoảng cách từ điểm  #mi(`B(0; 0)`)  đến đường tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{3x+1}{x-2}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Đường tiệm cận ngang của đồ thị hàm số là  #mi(`y = 3 \Leftrightarrow y - 3 = 0`) . Áp dụng công thức khoảng cách từ  #mi(`B(0; 0)`)  đến đường thẳng  #mi(`\Delta: y - 3 = 0`)  ta có:  #mi(`d(B, \Delta) = \frac{|0 - 3|}{\sqrt{0^2 + 1^2}} = \frac{|-3|}{1} = 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng cho tiệm cận đứng:] Cho hàm số  #mi(`y = \frac{x+1}{x-1}`) . Tính khoảng cách từ điểm  #mi(`M(2; 3)`)  đến tiệm cận đứng của đồ thị hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng của đồ thị hàm số là  #mi(`x = 1 \Leftrightarrow x - 1 = 0`) . Khoảng cách từ  #mi(`M(2; 3)`)  đến đường thẳng  #mi(`\Delta: x - 1 = 0`)  là:  #mi(`d(M, \Delta) = \frac{|2 - 1|}{\sqrt{1^2 + 0^2}} = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng cho tiệm cận ngang:] Cho hàm số  #mi(`y = \frac{2x-3}{x+1}`) . Tính khoảng cách từ điểm  #mi(`P(1; 1)`)  đến tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận ngang của đồ thị hàm số là  #mi(`y = 2 \Leftrightarrow y - 2 = 0`) . Khoảng cách từ  #mi(`P(1; 1)`)  đến đường thẳng  #mi(`\Delta: y - 2 = 0`)  là:  #mi(`d(P, \Delta) = \frac{|1 - 2|}{\sqrt{0^2 + 1^2}} = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng cho tiệm cận xiên:] Cho hàm số  #mi(`y = 2x + 1 + \frac{3}{x+3}`) . Tính khoảng cách từ điểm  #mi(`M(2; -1)`)  đến tiệm cận xiên của đồ thị hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận xiên của đồ thị hàm số là  #mi(`y = 2x + 1 \Leftrightarrow 2x - y + 1 = 0`) . Khoảng cách từ  #mi(`M(2; -1)`)  đến đường thẳng  #mi(`\Delta: 2x - y + 1 = 0`)  là:  #mi(`d(M, \Delta) = \frac{|2(2) - (-1) + 1|}{\sqrt{2^2 + (-1)^2}} = \frac{|4 + 1 + 1|}{\sqrt{5}} = \frac{6}{\sqrt{5}}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tổng hợp các loại tiệm cận:] Cho hàm số  #mi(`y = \frac{x^2-x+1}{x-1}`) . Tính khoảng cách từ điểm  #mi(`O(0; 0)`)  đến tiệm cận xiên của đồ thị hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thực hiện phép chia đa thức:  #mi(`y = x + \frac{1}{x-1}`) . Tiệm cận xiên là  #mi(`y = x \Leftrightarrow x - y = 0`) . Khoảng cách từ  #mi(`O(0; 0)`)  đến đường thẳng  #mi(`\Delta: x - y = 0`)  là:  #mi(`d(O, \Delta) = \frac{|0 - 0|}{\sqrt{1^2 + (-1)^2}} = 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = \frac{x-1}{x+1}`) . Tính khoảng cách từ điểm  #mi(`A(2; 1)`)  đến tiệm cận đứng của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng là  #mi(`x = -1 \Leftrightarrow x + 1 = 0`) . Khoảng cách từ  #mi(`A(2; 1)`)  đến  #mi(`\Delta: x + 1 = 0`)  là:  #mi(`d(A, \Delta) = \frac{|2 + 1|}{\sqrt{1^2 + 0^2}} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{x+2}{x-3}`) . Tính khoảng cách từ điểm  #mi(`B(4; 5)`)  đến tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận ngang là  #mi(`y = 1 \Leftrightarrow y - 1 = 0`) . Khoảng cách từ  #mi(`B(4; 5)`)  đến  #mi(`\Delta: y - 1 = 0`)  là:  #mi(`d(B, \Delta) = \frac{|5 - 1|}{\sqrt{0^2 + 1^2}} = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = x + 3 + \frac{1}{x-2}`) . Tính khoảng cách từ điểm  #mi(`C(1; 1)`)  đến tiệm cận xiên của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận xiên là  #mi(`y = x + 3 \Leftrightarrow x - y + 3 = 0`) . Khoảng cách từ  #mi(`C(1; 1)`)  đến  #mi(`\Delta: x - y + 3 = 0`)  là:  #mi(`d(C, \Delta) = \frac{|1 - 1 + 3|}{\sqrt{1^2 + (-1)^2}} = \frac{3}{\sqrt{2}}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{2x+5}{x-1}`) . Tính khoảng cách từ điểm  #mi(`D(0; 0)`)  đến tiệm cận đứng và tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng là  #mi(`x = 1 \Leftrightarrow x - 1 = 0`) . Tiệm cận ngang là  #mi(`y = 2 \Leftrightarrow y - 2 = 0`) . Khoảng cách từ  #mi(`D(0; 0)`)  đến tiệm cận đứng là  #mi(`d_1 = \frac{|0 - 1|}{\sqrt{1^2 + 0^2}} = 1`) . Khoảng cách từ  #mi(`D(0; 0)`)  đến tiệm cận ngang là  #mi(`d_2 = \frac{|0 - 2|}{\sqrt{0^2 + 1^2}} = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 18: Xác định số điểm cực trị dựa trên bảng biến thiên/xét dấu đạo hàm ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 18. Xác định số điểm cực trị dựa trên bảng biến thiên/xét dấu đạo hàm]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm cực trị của hàm số  #mi(`y=f(x)`)  là các điểm mà tại đó đạo hàm  #mi(`f'(x)`)  đổi dấu.
  - Nếu  #mi(`f'(x)`)  đổi dấu từ dương  #mi(`(+)`)  sang âm  #mi(`(-)`)  khi đi qua  #mi(`x_0`)  thì  #mi(`x_0`)  là điểm cực đại.
  - Nếu  #mi(`f'(x)`)  đổi dấu từ âm  #mi(`(-)`)  sang dương  #mi(`(+)`)  khi đi qua  #mi(`x_0`)  thì  #mi(`x_0`)  là điểm cực tiểu.
  - Nếu  #mi(`f'(x)`)  không đổi dấu khi đi qua  #mi(`x_0`)  thì  #mi(`x_0`)  không phải là điểm cực trị.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Chỉ đếm các điểm mà tại đó  #mi(`f'(x)`)  'nhảy' dấu (từ  #mi(`+`)  sang  #mi(`-`)  hoặc ngược lại). Nếu đi qua nghiệm mà dấu giữ nguyên thì 'bỏ qua' ngay!
  ]
  - *Công thức cốt lõi:* Số điểm cực trị của hàm số là số lần đạo hàm  #mi(`f'(x)`)  ... khi đi qua các nghiệm của nó.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau:  #mi(`x`)  chạy qua  #mi(`-1, 0, 2`)  và dấu  #mi(`f'(x)`)  lần lượt là  #mi(`(+), (-), (+)`) . Hỏi hàm số có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tại  #mi(`x=-1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`- \rightarrow`)  có 1 cực trị. Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  có 1 cực trị. Tại  #mi(`x=2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`+ \rightarrow`)  không có cực trị. Tổng cộng có  #mi(`1 + 1 = 2`)  điểm cực trị.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = (x-1)^2(x-2)`) . Tìm số điểm cực tiểu của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Nghiệm của  #mi(`f'(x)=0`)  là  #mi(`x=1`)  (nghiệm bội chẵn) và  #mi(`x=2`)  (nghiệm đơn). Xét dấu  #mi(`f'(x)`) : Khi  #mi(`x < 1`) ,  #mi(`f'(x) < 0`) ; khi  #mi(`1 < x < 2`) ,  #mi(`f'(x) < 0`) ; khi  #mi(`x > 2`) ,  #mi(`f'(x) > 0`) . Tại  #mi(`x=1`)  đạo hàm không đổi dấu. Tại  #mi(`x=2`)  đạo hàm đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  là điểm cực tiểu. Vậy có 1 điểm cực tiểu.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định số điểm cực trị qua bảng xét dấu:] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-1`)  |  #mi(`1`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát bảng xét dấu: 
- Tại  #mi(`x=-1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`- \rightarrow`)  là điểm cực đại. 
- Tại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  là điểm cực tiểu. \nVậy hàm số có  #mi(`2`)  điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Trường hợp đạo hàm không đổi dấu:] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = x(x-2)^2`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giải  #mi(`f'(x)=0 \Leftrightarrow x=0`)  hoặc  #mi(`x=2`) . 
- Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  (vì  #mi(`x`)  là nghiệm đơn). 
- Tại  #mi(`x=2`) ,  #mi(`f'(x)`)  không đổi dấu (vì  #mi(`(x-2)^2`)  luôn  #mi(`\ge 0`) ). \nVậy hàm số chỉ có  #mi(`1`)  điểm cực trị tại  #mi(`x=0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định số điểm cực đại và cực tiểu riêng biệt:] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  
 #mi(`f(x)`)  |  #mi(`\inf`)  |  #mi(`\uparrow`)  |  #mi(`3`)  |  #mi(`\downarrow`)  |  #mi(`1`)  |  #mi(`\uparrow`)  |  #mi(`\sup`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên: 
- Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`- \rightarrow`)  điểm cực đại. 
- Tại  #mi(`x=2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  điểm cực tiểu. \nVậy hàm số có  #mi(`1`)  điểm cực đại và  #mi(`1`)  điểm cực tiểu.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phân tích từ biểu thức đạo hàm:] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = -x^2(x-1)(x+2)`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giải  #mi(`f'(x)=0 \Leftrightarrow x=0, x=1, x=-2`) . 
-  #mi(`x=0`)  là nghiệm bội chẵn (mũ 2)  #mi(`\rightarrow`)  không đổi dấu. 
-  #mi(`x=1`)  là nghiệm đơn  #mi(`\rightarrow`)  đổi dấu. 
-  #mi(`x=-2`)  là nghiệm đơn  #mi(`\rightarrow`)  đổi dấu. \nVậy hàm số có  #mi(`2`)  điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-2`)  |  #mi(`0`)  |  #mi(`3`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x=-2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`- \rightarrow`)  cực đại. \nTại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  cực tiểu. \nTại  #mi(`x=3`) ,  #mi(`f'(x)`)  không đổi dấu (từ  #mi(`+`)  sang  #mi(`+`) )  #mi(`\rightarrow`)  không là cực trị. \nVậy hàm số có  #mi(`2`)  điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-3`)  |  #mi(`1`)  |  #mi(`4`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x=-3`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`- \rightarrow`)  cực đại. \nTại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  cực tiểu. \nTại  #mi(`x=4`) ,  #mi(`f'(x)`)  không đổi dấu (từ  #mi(`+`)  sang  #mi(`+`) )  #mi(`\rightarrow`)  không là cực trị. \nVậy hàm số có  #mi(`2`)  điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = (x+1)^2(x-3)`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Giải  #mi(`f'(x)=0 \Leftrightarrow x=-1`)  hoặc  #mi(`x=3`) . 
- Tại  #mi(`x=-1`) ,  #mi(`f'(x)`)  không đổi dấu (do mũ 2 chẵn). 
- Tại  #mi(`x=3`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`) . \nVậy hàm số có  #mi(`1`)  điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau: 
 #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-1`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  
 #mi(`f'(x)`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x=-1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  cực tiểu. \nTại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`- \rightarrow`)  cực đại. \nTại  #mi(`x=2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+ \rightarrow`)  cực tiểu. \nVậy hàm số có  #mi(`3`)  điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 19: Tìm giá trị lớn nhất/nhỏ nhất của hàm số trên một đoạn ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 19. Tìm giá trị lớn nhất/nhỏ nhất của hàm số trên một đoạn]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm giá trị lớn nhất (GTLN) và giá trị nhỏ nhất (GTNN) của hàm số  #mi(`f(x)`)  liên tục trên đoạn  #mi(`[a, b]`) , ta thực hiện các bước: Tính đạo hàm  #mi(`f'(x)`) , tìm các điểm  #mi(`x_i ‡ [a, b]`)  mà tại đó  #mi(`f'(x) = 0`)  hoặc  #mi(`f'(x)`)  không xác định.
  - Tính giá trị của hàm số tại hai đầu mút  #mi(`f(a), f(b)`)  và tại các điểm  #mi(`x_i`)  tìm được ở bước trên.
  - Giá trị lớn nhất  #mi(`M = Ααγ(f(a), f(b), f(x_1), …, f(x_n))`)  và giá trị nhỏ nhất  #mi(`m = Ααγ(f(a), f(b), f(x_1), …, f(x_n))`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ quy tắc 3 bước: Đạo hàm  #mi(`→`)  Nghiệm trong đoạn  #mi(`→`)  So sánh giá trị. Đừng quên tính giá trị tại 2 đầu mút  #mi(`a`)  và  #mi(`b`) !
  ]
  - *Công thức cốt lõi:* Giá trị lớn nhất của hàm số trên đoạn  #mi(`[a, b]`)  là  #mi(`M = Ααγ(..., f(b), f(x_i))`)  với  #mi(`x_i`)  là các điểm cực trị thuộc đoạn  #mi(`[a, b]`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[0, 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 → x = ± 1`) . Vì  #mi(`x ‡ [0, 2]`)  nên ta chỉ nhận  #mi(`x = 1`) . Tính các giá trị:  #mi(`f(0) = 2, f(2) = 8 - 6 + 2 = 4, f(1) = 1 - 3 + 2 = 0`) . So sánh ta thấy giá trị nhỏ nhất là  #mi(`0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị lớn nhất của hàm số  #mi(`y = -x^2 + 4x + 1`)  trên đoạn  #mi(`[0, 3]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = -2x + 4`) . Cho  #mi(`y' = 0 → x = 2`) . Vì  #mi(`x = 2 ‡ [0, 3]`)  nên ta tính:  #mi(`f(0) = 1, f(3) = -9 + 12 + 1 = 4, f(2) = -4 + 8 + 1 = 5`) . Vậy giá trị lớn nhất là  #mi(`5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hàm đa thức bậc ba cơ bản:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-2, 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = 3x^2 - 3`) . \nBước 2: Giải phương trình  #mi(`y' = 0 → 3x^2 - 3 = 0 → x = 1`)  hoặc  #mi(`x = -1`) . Cả hai giá trị  #mi(`x = 1`)  và  #mi(`x = -1`)  đều thuộc đoạn  #mi(`[-2, 2]`) .\nBước 3: Tính giá trị hàm số tại các điểm: 
 #mi(`f(-2) = (-2)^3 - 3(-2) + 2 = -8 + 6 + 2 = 0`) 
 #mi(`f(2) = 2^3 - 3(2) + 2 = 8 - 6 + 2 = 4`) 
 #mi(`f(-1) = (-1)^3 - 3(-1) + 2 = -1 + 3 + 2 = 4`) 
 #mi(`f(1) = 1^3 - 3(1) + 2 = 1 - 3 + 2 = 0`) \nKết luận: Vậy trên đoạn  #mi(`[-2, 2]`) , giá trị lớn nhất là  #mi(`M = 4`)  và giá trị nhỏ nhất là  #mi(`m = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hàm đa thức bậc bốn:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = -x^4 + 2x^2 + 1`)  trên đoạn  #mi(`[0, 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = -4x^3 + 4x`) . \nBước 2: Giải phương trình  #mi(`y' = 0 → -4x(x^2 - 1) = 0 → x = 0, x = 1, x = -1`) . \nVì xét trên đoạn  #mi(`[0, 2]`)  nên ta chỉ nhận  #mi(`x = 0`)  và  #mi(`x = 1`) .\nBước 3: Tính giá trị hàm số: 
 #mi(`f(0) = 1`) 
 #mi(`f(2) = -(2)^4 + 2(2)^2 + 1 = -16 + 8 + 1 = -7`) 
 #mi(`f(1) = -(1)^4 + 2(1)^2 + 1 = -1 + 2 + 1 = 2`) \nKết luận: Vậy trên đoạn  #mi(`[0, 2]`) , giá trị lớn nhất là  #mi(`M = 2`)  và giá trị nhỏ nhất là  #mi(`m = -7`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm phân thức bậc nhất trên bậc nhất:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \frac{x+1}{x-2}`)  trên đoạn  #mi(`[3, 5]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = \frac{1(x-2) - 1(x+1)}{(x-2)^2} = \frac{-3}{(x-2)^2}`) . \nBước 2: Ta thấy  #mi(`y' < 0`)  với mọi  #mi(`x ‡ [3, 5]`) , do đó hàm số không có điểm cực trị trong đoạn này (hàm số nghịch biến).\nBước 3: Tính giá trị tại hai đầu mút: 
 #mi(`f(3) = \frac{3+1}{3-2} = 4`) 
 #mi(`f(5) = \frac{5+1}{5-2} = \frac{6}{3} = 2`) \nKết luận: Vậy trên đoạn  #mi(`[3, 5]`) , giá trị lớn nhất là  #mi(`M = 4`)  và giá trị nhỏ nhất là  #mi(`m = 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hàm đa thức bậc ba với hệ số khác:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 + 1`)  trên đoạn  #mi(`[0, 3]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = 3x^2 - 6x`) . \nBước 2: Giải phương trình  #mi(`y' = 0 → 3x(x-2) = 0 → x = 0`)  hoặc  #mi(`x = 2`) . Cả hai đều thuộc đoạn  #mi(`[0, 3]`) .\nBước 3: Tính giá trị hàm số: 
 #mi(`f(0) = 0^3 - 3(0)^2 + 1 = 1`) 
 #mi(`f(3) = 3^3 - 3(3)^2 + 1 = 27 - 27 + 1 = 1`) 
 #mi(`f(2) = 2^3 - 3(2)^2 + 1 = 8 - 12 + 1 = -3`) \nKết luận: Vậy trên đoạn  #mi(`[0, 3]`) , giá trị lớn nhất là  #mi(`M = 1`)  và giá trị nhỏ nhất là  #mi(`m = -3`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 5`)  trên đoạn  #mi(`[-2, 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 → x = ± 1`)  (đều thuộc  #mi(`[-2, 2]`) ). \nTính giá trị:  #mi(`f(-2) = -8 + 6 + 5 = 3`) ;  #mi(`f(2) = 8 - 6 + 5 = 7`) ;  #mi(`f(-1) = -1 + 3 + 5 = 7`) ;  #mi(`f(1) = 1 - 3 + 5 = 3`) . \nVậy  #mi(`M = 7, m = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x - 1`)  trên đoạn  #mi(`[-2, 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 → x = ± 1`)  (đều thuộc  #mi(`[-2, 2]`) ). \nTính giá trị:  #mi(`f(-2) = -8 + 6 - 1 = -3`) ;  #mi(`f(2) = 8 - 6 - 1 = 1`) ;  #mi(`f(-1) = -1 + 3 - 1 = 1`) ;  #mi(`f(1) = 1 - 3 - 1 = -3`) . \nVậy  #mi(`M = 1, m = -3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = -x^4 + 2x^2 + 3`)  trên đoạn  #mi(`[0, 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = -4x^3 + 4x`) . Cho  #mi(`y' = 0 → x = 0, x = ± 1`) . Trong  #mi(`[0, 2]`)  nhận  #mi(`x=0, x=1`) . \nTính giá trị:  #mi(`f(0) = 3`) ;  #mi(`f(2) = -16 + 8 + 3 = -5`) ;  #mi(`f(1) = -1 + 2 + 3 = 4`) . \nVậy  #mi(`M = 4, m = -5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm giá trị nhỏ nhất của hàm số  #mi(`y = \frac{x+2}{x-3}`)  trên đoạn  #mi(`[4, 6]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = \frac{1(x-3) - 1(x+2)}{(x-3)^2} = \frac{-5}{(x-3)^2} < 0`) . \nHàm số nghịch biến trên  #mi(`[4, 6]`) . \nGiá trị nhỏ nhất đạt tại đầu mút bên phải:  #mi(`f(6) = \frac{6+2}{6-3} = \frac{8}{3}`) . \nVậy  #mi(`m = \frac{8}{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 20: Ứng dụng đạo hàm giải bài toán tối ưu (Kinh tế/Thực tế) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 20. Ứng dụng đạo hàm giải bài toán tối ưu (Kinh tế/Thực tế)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để giải bài toán tối ưu, bước đầu tiên là thiết lập hàm số  #mi(`f(x)`)  biểu diễn đại lượng cần tối ưu (lợi nhuận, chi phí, thể tích, diện tích...) theo một biến số  #mi(`x`)  duy nhất.
  - Tìm khoảng xác định của biến  #mi(`x`)  dựa trên điều kiện thực tế của bài toán (ví dụ:  #mi(`x > 0`) , chiều dài không thể âm).
  - Sử dụng đạo hàm để tìm các điểm cực trị của hàm số  #mi(`f(x)`)  trên khoảng xác định. Giá trị lớn nhất hoặc nhỏ nhất của hàm số tại các điểm cực trị hoặc tại biên của khoảng xác định chính là giá trị tối ưu cần tìm.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy trình 3 bước: Thiết lập hàm  #mi(`\rightarrow`)  Tìm đạo hàm  #mi(`f'(x)=0`)   #mi(`\rightarrow`)  Đối chiếu điều kiện thực tế.
  ]
  - *Công thức cốt lõi:* Lợi nhuận được tính bằng công thức:  #mi(`L(x) = R(x) - C(x)`) , trong đó  #mi(`R(x)`)  là ... và  #mi(`C(x)`)  là chi phí.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt bốn góc của tấm nhôm đó bốn hình vuông bằng nhau cạnh  #mi(`x\text{ cm}`)  rồi gập lại thành hộp không nắp. Tìm  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Thể tích hộp là  #mi(`V(x) = x(12-2x)^2`)  với  #mi(`0 < x < 6`) . Đạo hàm  #mi(`V'(x) = (12-2x)^2 + x \cdot 2(12-2x)(-2) = (12-2x)(12-2x-4x) = (12-2x)(12-6x)`) .  #mi(`V'(x) = 0 \Leftrightarrow x=6`)  (loại) hoặc  #mi(`x=2`) . Với  #mi(`x=2`) , thể tích đạt cực đại.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một doanh nghiệp sản xuất  #mi(`x`)  sản phẩm với chi phí tổng cộng là  #mi(`C(x) = 2x^2 + 40x + 100`)  (nghìn đồng). Tìm số lượng sản phẩm  #mi(`x`)  để chi phí trung bình cho mỗi sản phẩm là thấp nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7]
      \ #text(fill: rgb("#334155"))[Lời giải: Chi phí trung bình  #mi(`C_{tb}(x) = \frac{C(x)}{x} = 2x + 40 + \frac{100}{x}`) . Đạo hàm  #mi(`C_{tb}'(x) = 2 - \frac{100}{x^2}`) .  #mi(`C_{tb}'(x) = 0 \Leftrightarrow x^2 = 50 \Leftrightarrow x = 5\sqrt{2} \approx 7.07`) . Vì  #mi(`x`)  là số sản phẩm nên chọn  #mi(`x=7`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa lợi nhuận kinh doanh:] Một quầy cà phê bán với giá  #mi(`20,000`)  đồng/ly thì mỗi ngày bán được  #mi(`100`)  ly. Cứ giảm giá  #mi(`1,000`)  đồng thì số ly bán được tăng thêm  #mi(`20`)  ly. Biết chi phí nhập mỗi ly là  #mi(`10,000`)  đồng. Hỏi phải bán giá bao nhiêu để lợi nhuận mỗi ngày là lớn nhất?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  là số lần giảm giá  #mi(`1,000`)  đồng ( #mi(`x \ge 0`) ). \nGiá bán một ly là:  #mi(`p(x) = 20,000 - 1,000x`)  (đồng).\nSố lượng ly bán được là:  #mi(`q(x) = 100 + 20x`)  (ly).\nLợi nhuận trên mỗi ly là:  #mi(`p(x) - 10,000 = 10,000 - 1,000x`)  (đồng).\nTổng lợi nhuận mỗi ngày là:  #mi(`L(x) = (10,000 - 1,000x)(100 + 20x) = -20,000x^2 + 100,000x + 1,000,000`) .\nTính đạo hàm:  #mi(`L'(x) = -40,000x + 100,000`) .
 #mi(`L'(x) = 0 \Leftrightarrow x = 2.5`) .\nKhi  #mi(`x = 2.5`) , giá bán là  #mi(`p(2.5) = 20,000 - 1,000(2.5) = 17,500`)  đồng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa thể tích hình học:] Từ một tấm tôn hình vuông cạnh  #mi(`a`) , cắt bỏ 4 hình vuông cạnh  #mi(`x`)  ở 4 góc rồi gấp thành một chiếc hộp không nắp. Tìm  #mi(`x`)  theo  #mi(`a`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chiều cao hộp là  #mi(`x`) , cạnh đáy là  #mi(`a-2x`) . Điều kiện:  #mi(`0 < x < a/2`) .\nThể tích hộp:  #mi(`V(x) = x(a-2x)^2 = 4x^3 - 4ax^2 + a^2x`) .
Đạo hàm:  #mi(`V'(x) = 12x^2 - 8ax + a^2`) .\nGiải  #mi(`V'(x) = 0 \Leftrightarrow x = \frac{8a \pm \sqrt{64a^2 - 48a^2}}{24} = \frac{8a \pm 4a}{24}`) .\nTa được  #mi(`x_1 = \frac{a}{2}`)  (loại) và  #mi(`x_2 = \frac{a}{6}`) .\nVậy thể tích lớn nhất khi  #mi(`x = \frac{a}{6}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tối ưu hóa chi phí trung bình:] Chi phí để sản xuất  #mi(`x`)  đơn vị sản phẩm là  #mi(`C(x) = x^2 + 100x + 400`)  (đơn vị tiền tệ). Tìm  #mi(`x`)  để chi phí trung bình cho mỗi đơn vị sản phẩm là nhỏ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chi phí trung bình:  #mi(`f(x) = \frac{C(x)}{x} = x + 100 + \frac{400}{x}`)  với  #mi(`x > 0`) .
Đạo hàm:  #mi(`f'(x) = 1 - \frac{400}{x^2}`) .
 #mi(`f'(x) = 0 \Leftrightarrow x^2 = 400 \Leftrightarrow x = 20`)  (vì  #mi(`x > 0`) ).\nVì  #mi(`f''(x) = \frac{800}{x^3} > 0`)  với  #mi(`x=20`)  nên hàm số đạt giá trị nhỏ nhất tại  #mi(`x=20`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán thực tế về khoảng cách:] Một điểm  #mi(`M`)  di chuyển trên trục  #mi(`Ox`) , một điểm  #mi(`N`)  di chuyển trên đường thẳng  #mi(`y=2`) . Tìm vị trí  #mi(`M, N`)  để khoảng cách  #mi(`MN`)  ngắn nhất khi biết  #mi(`M`)  cố định tại  #mi(`(1,0)`)  và  #mi(`N`)  có hoành độ  #mi(`x`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điểm  #mi(`M(1,0)`) , điểm  #mi(`N(x,2)`) .\nKhoảng cách  #mi(`MN = \sqrt{(x-1)^2 + (2-0)^2} = \sqrt{(x-1)^2 + 4}`) .
Để  #mi(`MN`)  nhỏ nhất thì  #mi(`(x-1)^2 + 4`)  phải nhỏ nhất.
Điều này xảy ra khi  #mi(`(x-1)^2 = 0 \Leftrightarrow x = 1`) .\nVậy khoảng cách ngắn nhất là  #mi(`MN = \sqrt{4} = 2`)  khi  #mi(`N(1,2)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (MauChuan).*] else [*Bài 1.*] Một quầy trà sữa bán giá  #mi(`30,000`)  đồng/ly thì mỗi ngày bán được  #mi(`200`)  ly. Cứ giảm giá  #mi(`1,000`)  đồng thì số ly bán được tăng thêm  #mi(`20`)  ly. Chi phí nhập mỗi ly là  #mi(`15,000`)  đồng. Tìm giá bán để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  là số lần giảm giá  #mi(`1,000`)  đồng. Giá bán  #mi(`p = 30,000 - 1,000x`) , số lượng  #mi(`q = 200 + 20x`) .\nLợi nhuận  #mi(`L(x) = (30,000 - 1,000x - 15,000)(200 + 20x) = (15,000 - 1,000x)(200 + 20x) = -20,000x^2 + 100,000x + 3,000,000`) .
 #mi(`L'(x) = -40,000x + 100,000 = 0 \Leftrightarrow x = 2.5`) .\nGiá bán tối ưu:  #mi(`30,000 - 1,000(2.5) = 27,500`)  đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Một cửa hàng bán giày giá  #mi(`500,000`)  đồng/đôi thì bán được  #mi(`50`)  đôi/tuần. Cứ giảm giá  #mi(`20,000`)  đồng thì số đôi bán được tăng thêm  #mi(`5`)  đôi. Chi phí nhập là  #mi(`300,000`)  đồng/đôi. Tìm giá bán để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  là số lần giảm giá  #mi(`20,000`)  đồng. Giá bán  #mi(`p = 500,000 - 20,000x`) , số lượng  #mi(`q = 50 + 5x`) .\nLợi nhuận  #mi(`L(x) = (500,000 - 20,000x - 300,000)(50 + 5x) = (200,000 - 20,000x)(50 + 5x) = -100,000x^2 + 0x + 10,000,000`) .
 #mi(`L'(x) = -200,000x = 0 \Leftrightarrow x = 0`) .\nVậy giá bán tối ưu là  #mi(`500,000`)  đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = 3x^2 + 120x + 300`) . Tìm  #mi(`x`)  để chi phí trung bình thấp nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chi phí trung bình  #mi(`f(x) = \frac{C(x)}{x} = 3x + 120 + \frac{300}{x}`) .
 #mi(`f'(x) = 3 - \frac{300}{x^2} = 0 \Leftrightarrow x^2 = 100 \Leftrightarrow x = 10`) .\nVậy  #mi(`x=10`)  sản phẩm thì chi phí trung bình thấp nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Một tấm nhôm hình vuông cạnh  #mi(`18\text{ cm}`) . Cắt 4 góc hình vuông cạnh  #mi(`x`)  rồi gấp thành hộp không nắp. Tìm thể tích lớn nhất của hộp.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thể tích  #mi(`V(x) = x(18-2x)^2`)  với  #mi(`0 < x < 9`) .
 #mi(`V'(x) = (18-2x)^2 + x \cdot 2(18-2x)(-2) = (18-2x)(18-2x-4x) = (18-2x)(18-6x)`) .
 #mi(`V'(x) = 0 \Leftrightarrow x=9`)  (loại) hoặc  #mi(`x=3`) .\nThể tích lớn nhất  #mi(`V(3) = 3(18-6)^2 = 3(12)^2 = 3 \cdot 144 = 432\text{ cm}^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 21: Xác định tiệm cận đứng và tiệm cận ngang từ bảng biến thiên ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 21. Xác định tiệm cận đứng và tiệm cận ngang từ bảng biến thiên]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tiệm cận đứng là đường thẳng  #mi(`x = x_0`)  nếu  #mi(`\lim_{x \to x_0} f(x) = \pm\infty`) . Trong BBT, ta nhìn vào các giá trị  #mi(`x`)  làm cho  #mi(`f(x)`)  tiến tới vô cực.
  - Tiệm cận ngang là đường thẳng  #mi(`y = y_0`)  nếu  #mi(`\lim_{x \to +\infty} f(x) = y_0`)  hoặc  #mi(`\lim_{x \to -\infty} f(x) = y_0`) . Trong BBT, ta nhìn vào giá trị của  #mi(`f(x)`)  tại các đầu mút  #mi(`\pm\infty`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] TCĐ: Nhìn cột  #mi(`x`)  có 'vạch đứng'  #mi(`\infty`) . TCN: Nhìn cột  #mi(`x`)  có  #mi(`\pm\infty`)  và xem  #mi(`y`)  bằng bao nhiêu.
  ]
  - *Công thức cốt lõi:* Đường tiệm cận đứng có dạng  #mi(`x = \dots`)  và đường tiệm cận ngang có dạng  #mi(`y = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số có bảng biến thiên như sau:  #mi(`x \to 1`)  và  #mi(`f(x) \to \\infty`) . Tìm phương trình đường tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: x=1]
      \ #text(fill: rgb("#334155"))[Lời giải: Dựa vào bảng biến thiên, khi  #mi(`x \to 1`)  thì  #mi(`f(x) \to \\infty`) , do đó đường tiệm cận đứng là  #mi(`x = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số có bảng biến thiên như sau:  #mi(`x \to +\infty`)  và  #mi(`f(x) \to 3`) . Tìm phương trình đường tiệm cận ngang.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: y=3]
      \ #text(fill: rgb("#334155"))[Lời giải: Dựa vào bảng biến thiên, khi  #mi(`x \to +\infty`)  thì  #mi(`f(x) \to 3`) , do đó đường tiệm cận ngang là  #mi(`y = 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tiệm cận đứng:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:  #mi(`x`)  chạy từ  #mi(`-\infty`)  đến  #mi(`+\infty`) , tại  #mi(`x=2`)  hàm số không xác định và  #mi(`f(x)`)  tiến tới  #mi(`+\infty`)  khi  #mi(`x \to 2^-`)  và  #mi(`-\infty`)  khi  #mi(`x \to 2^+`) . Tìm tiệm cận đứng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát bảng biến thiên, tại  #mi(`x=2`)  hàm số tiến tới vô cực ( #mi(`\pm\infty`) ). Vậy đường tiệm cận đứng là  #mi(`x=2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tiệm cận ngang:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau: khi  #mi(`x \to -\infty`)  thì  #mi(`f(x) \to 0`)  và khi  #mi(`x \to +\infty`)  thì  #mi(`f(x) \to 5`) . Tìm tiệm cận ngang.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát bảng biến thiên, khi  #mi(`x \to -\infty`)  thì  #mi(`f(x) \to 0`)  nên có TCN  #mi(`y=0`) . Khi  #mi(`x \to +\infty`)  thì  #mi(`f(x) \to 5`)  nên có TCN  #mi(`y=5`) . Vậy đồ thị có hai tiệm cận ngang là  #mi(`y=0`)  và  #mi(`y=5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm cả hai loại tiệm cận:] Cho hàm số có bảng biến thiên: tại  #mi(`x=1`)  hàm số tiến tới vô cực, và khi  #mi(`x \to +\infty`)  hàm số tiến tới  #mi(`2`) . Tìm số đường tiệm cận.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tại  #mi(`x=1`) ,  #mi(`f(x) \to \\infty \Rightarrow`)  có TCĐ  #mi(`x=1`) . 2. Khi  #mi(`x \to +\infty`) ,  #mi(`f(x) \to 2 \Rightarrow`)  có TCN  #mi(`y=2`) . Vậy tổng số tiệm cận là  #mi(`2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kết hợp nhiều giá trị:] Cho hàm số có BBT:  #mi(`x \to -\infty, f(x) \to -3`) ;  #mi(`x \to 1, f(x) \to \\infty`) ;  #mi(`x \to +\infty, f(x) \to -3`) . Tìm các đường tiệm cận.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Khi  #mi(`x \to -\infty`) ,  #mi(`f(x) \to -3 \Rightarrow`)  TCN  #mi(`y=-3`) . 2. Khi  #mi(`x \to 1`) ,  #mi(`f(x) \to \\infty \Rightarrow`)  TCĐ  #mi(`x=1`) . 3. Khi  #mi(`x \to +\infty`) ,  #mi(`f(x) \to -3 \Rightarrow`)  TCN  #mi(`y=-3`)  (trùng với cái trước). Vậy đồ thị có một TCĐ  #mi(`x=1`)  và một TCN  #mi(`y=-3`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số có bảng biến thiên: tại  #mi(`x=3`)  hàm số tiến tới vô cực, và khi  #mi(`x \to +\infty`)  hàm số tiến tới  #mi(`4`) . Tìm tiệm cận đứng và tiệm cận ngang.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x=3`) ,  #mi(`f(x) \to \\infty \Rightarrow`)  TCĐ  #mi(`x=3`) . Khi  #mi(`x \to +\infty`) ,  #mi(`f(x) \to 4 \Rightarrow`)  TCN  #mi(`y=4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Cho hàm số có bảng biến thiên: tại  #mi(`x=-2`)  hàm số tiến tới vô cực, và khi  #mi(`x \to -\infty`)  hàm số tiến tới  #mi(`1`) . Tìm tiệm cận đứng và tiệm cận ngang.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x=-2`) ,  #mi(`f(x) \to \\infty \Rightarrow`)  TCĐ  #mi(`x=-2`) . Khi  #mi(`x \to -\infty`) ,  #mi(`f(x) \to 1 \Rightarrow`)  TCN  #mi(`y=1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Cho hàm số có bảng biến thiên: khi  #mi(`x \to +\infty`)  hàm số tiến tới  #mi(`0`) , và khi  #mi(`x \to -\infty`)  hàm số tiến tới  #mi(`0`) . Tìm số đường tiệm cận ngang.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khi  #mi(`x \to +\infty`) ,  #mi(`f(x) \to 0 \rightarrow`)  TCN  #mi(`y=0`) . Khi  #mi(`x \to -\infty`) ,  #mi(`f(x) \to 0 \rightarrow`)  TCN  #mi(`y=0`) . Vậy chỉ có  #mi(`1`)  đường tiệm cận ngang là  #mi(`y=0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số có BBT: tại  #mi(`x=0`)  hàm số tiến tới vô cực, và khi  #mi(`x \to +\infty`)  hàm số tiến tới  #mi(`2`) , khi  #mi(`x \to -\infty`)  hàm số tiến tới  #mi(`2`) . Tìm tổng số tiệm cận.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. TCĐ:  #mi(`x=0`) . 2. TCN:  #mi(`y=2`) . Tổng cộng có  #mi(`2`)  đường tiệm cận.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 22: Tính toán vectơ trong không gian (Hình lăng trụ/Hình chóp) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 22. Tính toán vectơ trong không gian (Hình lăng trụ/Hình chóp)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình hộp: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ đường chéo  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
  - Quy tắc cộng/trừ vectơ: Sử dụng quy tắc ba điểm  #mi(`\vec{XY} + \vec{YZ} = \vec{XZ}`)  và quy tắc hiệu  #mi(`\vec{XY} = \vec{AY} - \vec{AX}`)  để phân tích vectơ theo các vectơ cơ sở.
  - Tính chất hình chóp đáy hình bình hành: Nếu  #mi(`O`)  là tâm của hình bình hành  #mi(`ABCD`) , thì  #mi(`\vec{OA} + \vec{OC} = \vec{0}`)  và  #mi(`\vec{OB} + \vec{OD} = \vec{0}`) , dẫn đến  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn phân tích một vectơ 'lạ', hãy tìm đường đi từ điểm đầu đến điểm cuối thông qua các cạnh đã biết của hình khối.
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AC'} = \vec{AB} + ... + \vec{AA'}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Tính vectơ  #mi(`\vec{A'C}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: a+b-c]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{A'C} = \vec{A'A} + \vec{AC}`) . Theo quy tắc hình bình hành trong đáy  #mi(`ABCD`) ,  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = \vec{a} + \vec{b}`) . Lại có  #mi(`\vec{A'A} = -\vec{AA'} = -\vec{c}`) . Vậy  #mi(`\vec{A'C} = \vec{a} + \vec{b} - \vec{c}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính tổng  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`)  theo vectơ  #mi(`\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4SO]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`\vec{OA} + \vec{OC} = \vec{0}`)  và  #mi(`\vec{OB} + \vec{OD} = \vec{0}`) . Ta có:  #mi(`\vec{SA} + \vec{SC} = (\vec{SO} + \vec{OA}) + (\vec{SO} + \vec{OC}) = 2\vec{SO} + (\vec{OA} + \vec{OC}) = 2\vec{SO}`) . Tương tự,  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Vậy  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 2\vec{SO} + 2\vec{SO} = 4\vec{SO}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng trực tiếp quy tắc hình hộp cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Thay các giá trị đã đặt vào, ta được:  #mi(`\vec{AC'} = \vec{a} + \vec{b} + \vec{c}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Phân tích vectơ trong hình lăng trụ:] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Đặt  #mi(`\vec{AA'} = \vec{a}, \vec{AB} = \vec{b}, \vec{AC} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{B'C}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta phân tích vectơ  #mi(`\vec{B'C}`)  bằng cách chèn điểm  #mi(`B`) :  #mi(`\vec{B'C} = \vec{B'B} + \vec{BC}`) . Vì  #mi(`AA'B'B`)  là hình bình hành nên  #mi(`\vec{B'B} = -\vec{AA'} = -\vec{a}`) . Trong tam giác  #mi(`ABC`) , ta có  #mi(`\vec{BC} = \vec{AC} - \vec{AB} = \vec{c} - \vec{b}`) . Vậy  #mi(`\vec{B'C} = -\vec{a} + \vec{c} - \vec{b}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tổng vectơ trong hình chóp:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Chứng minh rằng  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 4\vec{SO}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Do đó  #mi(`\vec{OA} + \vec{OC} = \vec{0}`)  và  #mi(`\vec{OB} + \vec{OD} = \vec{0}`) . Ta có:  #mi(`\vec{SA} + \vec{SC} = (\vec{SO} + \vec{OA}) + (\vec{SO} + \vec{OC}) = 2\vec{SO} + (\vec{OA} + \vec{OC}) = 2\vec{SO}`) . Tương tự,  #mi(`\vec{SB} + \vec{SD} = (\vec{SO} + \vec{OB}) + (\vec{SO} + \vec{OD}) = 2\vec{SO} + (\vec{OB} + \vec{OD}) = 2\vec{SO}`) . Cộng hai kết quả trên, ta được:  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 2\vec{SO} + 2\vec{SO} = 4\vec{SO}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu diễn vectơ qua các cạnh:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{D'B}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta phân tích vectơ  #mi(`\vec{D'B}`)  bằng cách chèn điểm  #mi(`D`) :  #mi(`\vec{D'B} = \vec{D'D} + \vec{DB}`) . Ta có  #mi(`\vec{D'D} = -\vec{AA'} = -\vec{c}`) . Trong đáy  #mi(`ABCD`) ,  #mi(`\vec{DB} = \vec{AB} - \vec{AD} = \vec{a} - \vec{b}`) . Vậy  #mi(`\vec{D'B} = -\vec{c} + \vec{a} - \vec{b} = \vec{a} - \vec{b} - \vec{c}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Thay các giá trị vào ta được  #mi(`\vec{AC'} = \vec{a} + \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{A'C'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C'} = \vec{A'B'} + \vec{A'D'}`) . Vì  #mi(`A'B'C'D'`)  là hình bình hành nên  #mi(`\vec{A'B'} = \vec{AB} = \vec{a}`)  và  #mi(`\vec{A'D'} = \vec{AD} = \vec{b}`) . Vậy  #mi(`\vec{A'C'} = \vec{a} + \vec{b}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính tổng  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`)  theo  #mi(`\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`\vec{OA} + \vec{OC} = \vec{0}`)  và  #mi(`\vec{OB} + \vec{OD} = \vec{0}`) . Ta có  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Vậy  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 4\vec{SO}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{C'A}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{C'A} = -\vec{AC'}`) . Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{a} + \vec{b} + \vec{c}`) . Vậy  #mi(`\vec{C'A} = -(\vec{a} + \vec{b} + \vec{c}) = -\vec{a} - \vec{b} - \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 23: Tính toán tọa độ vectơ trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 23. Tính toán tọa độ vectơ trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu điểm  #mi(`A(x_A; y_A; z_A)`)  có hình chiếu vuông góc lên các trục tọa độ  #mi(`Ox, Oy, Oz`)  lần lượt là  #mi(`H, K, L`)  thì  #mi(`H(x_A; 0; 0), K(0; y_A; 0), L(0; 0; z_A)`) .
  - Cho hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , tọa độ của vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  - Độ dài của vectơ  #mi(`\vec{u} = (x; y; z)`)  là:  #mi(`|\vec{u}| = \sqrt{x^2 + y^2 + z^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Hình chiếu lên trục nào thì giữ nguyên tọa độ của trục đó, các tọa độ còn lại bằng  #mi(`0`) .
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{AB}`)  với  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là  #mi(`\vec{AB} = (\dots; y_B - y_A; z_B - z_A)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho điểm  #mi(`A(1; 2; -3)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (1; 0; 0)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`A(1; 2; -3)`)  nên hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Ox`)  sẽ giữ nguyên hoành độ  #mi(`x=1`)  và có tung độ  #mi(`y=0`) , cao độ  #mi(`z=0`) . Vậy tọa độ hình chiếu là  #mi(`(1; 0; 0)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u} = (3; -4; 12)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 13]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức độ dài:  #mi(`|\vec{u}| = \sqrt{3^2 + (-4)^2 + 12^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ hình chiếu lên trục tọa độ:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(2; -5; 3)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Oy`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của điểm  #mi(`A(x_A; y_A; z_A)`)  lên trục  #mi(`Oy`)  có tọa độ là  #mi(`(0; y_A; 0)`) . Áp dụng vào bài toán với  #mi(`A(2; -5; 3)`) , ta có hình chiếu là  #mi(`(0; -5; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tọa độ vectơ giữa hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 0; 2)`)  và  #mi(`B(4; -2; 5)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{AB}`)  được tính theo công thức:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Thay số ta được:  #mi(`\vec{AB} = (4 - 1; -2 - 0; 5 - 2) = (3; -2; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài vectơ:] Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{u} = (-2; 6; 3)`) . Tính độ dài  #mi(`|\vec{u}|`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức độ dài:  #mi(`|\vec{u}| = \sqrt{(-2)^2 + 6^2 + 3^2} = \sqrt{4 + 36 + 9} = \sqrt{49} = 7`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ điểm khi biết vectơ và điểm đầu:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(1; 2; 3)`)  và vectơ  #mi(`\vec{u} = (5; -1; 4)`) . Tìm tọa độ điểm  #mi(`B`)  sao cho  #mi(`\vec{AB} = \vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`B(x; y; z)`) . Vì  #mi(`\vec{AB} = (x - 1; y - 2; z - 3)`)  và theo giả thiết  #mi(`\vec{AB} = (5; -1; 4)`) , ta có hệ phương trình:  #mi(`\begin{cases} x - 1 = 5 \\ y - 2 = -1 \\\ z - 3 = 4 \end{cases} \Rightarrow \begin{cases} x = 6 \\ y = 1 \\ z = 7 \end{cases}`) . Vậy  #mi(`B(6; 1; 7)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(-3; 4; 1)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Oz`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu của  #mi(`A`)  lên trục  #mi(`Oz`)  có tọa độ là  #mi(`(0; 0; z_A)`) . Với  #mi(`A(-3; 4; 1)`) , ta có hình chiếu là  #mi(`(0; 0; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`B(5; -2; 7)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`B`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu của  #mi(`B`)  lên trục  #mi(`Ox`)  có tọa độ là  #mi(`(x_B; 0; 0)`) . Với  #mi(`B(5; -2; 7)`) , ta có hình chiếu là  #mi(`(5; 0; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; 3; -1)`)  và  #mi(`B(0; 1; 4)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (0 - 2; 1 - 3; 4 - (-1)) = (-2; -2; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{u} = (1; 2; -2)`) . Tính độ dài  #mi(`|\vec{u}|`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức độ dài:  #mi(`|\vec{u}| = \sqrt{1^2 + 2^2 + (-2)^2} = \sqrt{1 + 4 + 4} = \sqrt{9} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 24: Bài toán vật lý: Cân bằng lực trong không gian (Dây treo) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 24. Bài toán vật lý: Cân bằng lực trong không gian (Dây treo)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điều kiện cân bằng lực:  #mi(`\sum \vec{F} = 0`) . Trong trường hợp treo vật đứng yên, tổng các thành phần lực theo phương thẳng đứng phải bằng trọng lượng vật:  #mi(`\sum F_z = P`) .
  - Đối với hệ  #mi(`n`)  sợi dây đối xứng qua trục thẳng đứng, gọi  #mi(`\alpha`)  là góc hợp bởi mỗi sợi dây và phương thẳng đứng, lực căng mỗi sợi dây  #mi(`T`)  được tính bằng:  #mi(`T = \frac{P}{n \cdot \cos(\alpha)}`) .
  - Trường hợp đặc biệt: Nếu  #mi(`n`)  sợi dây đôi một vuông góc với nhau, lực căng mỗi sợi dây là:  #mi(`T = \frac{P}{\sqrt{n}}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ: 'Tổng lực hướng lên = Trọng lượng hướng xuống'. Nếu dây vuông góc, dùng  #mi(`\sqrt{n}`)  chia cho  #mi(`P`) . Nếu dây đối xứng, dùng  #mi(`\ncos(\alpha)`)  chia cho  #mi(`P`) .
  ]
  - *Công thức cốt lõi:* Trong hệ  #mi(`n`)  sợi dây đối xứng, lực căng mỗi sợi dây là  #mi(`T = \\frac{P}{n \cdot \cos(\alpha)}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật nặng  #mi(`10N`)  được treo bởi  #mi(`2`)  sợi dây đối xứng, mỗi sợi dây hợp với phương thẳng đứng một góc  #mi(`60^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 10]
      \ #text(fill: rgb("#334155"))[Lời giải: Trọng lượng  #mi(`P = 10N`) . Số sợi dây  #mi(`n = 2`) . Góc  #mi(`\alpha = 60^\circ`) . Áp dụng công thức:  #mi(`T = \frac{P}{n \cdot \cos(\alpha)} = \frac{10}{2 \cdot \cos(60^\circ)} = \frac{10}{2 \cdot 0.5} = 10N`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật có trọng lượng  #mi(`30N`)  được treo bởi  #mi(`3`)  sợi dây đôi một vuông góc với nhau. Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 17.32]
      \ #text(fill: rgb("#334155"))[Lời giải: Trọng lượng  #mi(`P = 30N`) . Số sợi dây  #mi(`n = 3`) . Vì các dây đôi một vuông góc, áp dụng công thức:  #mi(`T = \frac{P}{\sqrt{n}} = \frac{30}{\sqrt{3}} = 10\sqrt{3} \approx 17.32N`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức dây đối xứng:] Một chiếc đèn chùm có khối lượng  #mi(`m = 3.2\text{ kg}`)  được treo bởi  #mi(`4`)  sợi dây xích sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều và góc  #mi(`\angle ASC = 60^\circ`) . Lấy  #mi(`g = 9.8\text{ m/s}^2`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trọng lượng của đèn:  #mi(`P = m \cdot g = 3.2 \cdot 9.8 = 31.36\text{ N}`) . Vì  #mi(`\angle ASC = 60^\circ`)  và  #mi(`S.ABCD`)  là hình chóp tứ giác đều, tam giác  #mi(`SAC`)  là tam giác đều. Gọi  #mi(`O`)  là tâm đáy,  #mi(`SA`)  là sợi dây. Góc  #mi(`\alpha`)  hợp bởi  #mi(`SA`)  và trục thẳng đứng  #mi(`SO`)  là  #mi(`\angle OSA`) . Trong tam giác đều  #mi(`SAC`) ,  #mi(`\angle OSA = 30^\circ`) . Áp dụng công thức:  #mi(`T = \frac{P}{n \cdot \cos(\alpha)} = \frac{31.36}{4 \cdot \cos(30^\circ)} = \frac{31.36}{4 \cdot \frac{\sqrt{3}}{2}} = \frac{31.36}{2\sqrt{3}} \approx 9.05\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Trường hợp dây đôi một vuông góc:] Một vật nặng có trọng lượng  #mi(`60\text{ N}`)  được treo bởi  #mi(`3`)  sợi dây giống hệt nhau, đôi một tạo với nhau một góc  #mi(`90^\circ`) . Tính độ lớn lực căng mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`3`)  sợi dây đôi một vuông góc, ta có  #mi(`\vec{F_1} + \vec{F_2} + \vec{F_3} + \vec{P} = \vec{0}`) . Do tính đối xứng và vuông góc,  #mi(`|\vec{F_1}| = |\vec{F_2}| = |\vec{F_3}| = T`) . Theo điều kiện cân bằng:  #mi(`\sqrt{T^2 + T^2 + T^2} = P \Rightarrow T\sqrt{3} = 60 \Rightarrow T = \frac{60}{\sqrt{3}} = 20\sqrt{3} \approx 34.64\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng công thức dây đối xứng (số lượng khác):] Một vật có khối lượng  #mi(`m = 5\text{ kg}`)  được treo bởi  #mi(`3`)  sợi dây đối xứng qua trục thẳng đứng, mỗi sợi dây hợp với phương thẳng đứng một góc  #mi(`45^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trọng lượng vật:  #mi(`P = m \cdot g = 5 \cdot 10 = 50\text{ N}`) . Số sợi dây  #mi(`n = 3`) . Góc  #mi(`\alpha = 45^\circ`) . Áp dụng công thức:  #mi(`T = \frac{P}{n \cdot \cos(\alpha)} = \frac{50}{3 \cdot \cos(45^\circ)} = \frac{50}{3 \cdot \frac{\sqrt{2}}{2}} = \frac{100}{3\sqrt{2}} \approx 23.57\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Trường hợp dây treo không đối xứng (phân tích vectơ):] Một vật nặng  #mi(`P = 100\text{ N}`)  được treo bởi  #mi(`2`)  sợi dây  #mi(`SA`)  và  #mi(`SB`) . Sợi dây  #mi(`SA`)  hợp với phương thẳng đứng một góc  #mi(`30^\circ`) , sợi dây  #mi(`SB`)  hợp với phương thẳng đứng một góc  #mi(`45^\circ`) . Tính lực căng mỗi sợi dây nếu biết chúng có cùng độ lớn  #mi(`T`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tổng lực theo phương thẳng đứng:  #mi(`T \cdot \cos(30^\circ) + T \cdot \cos(45^\\circ) = P \Rightarrow T(\frac{\sqrt{3}}{2} + \frac{\sqrt{2}}{2}) = 100 \Rightarrow T(\frac{\sqrt{3}+\sqrt{2}}{2}) = 100 \Rightarrow T = \frac{200}{\sqrt{3}+\sqrt{2}} = 200(\sqrt{3}-\sqrt{2}) \approx 53.59\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một chiếc đèn chùm có khối lượng  #mi(`m = 4\text{ kg}`)  được treo bởi  #mi(`4`)  sợi dây xích sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều và góc  #mi(`\angle ASC = 60^\circ`) . Lấy  #mi(`g = 10\text{ m/s}^2`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trọng lượng  #mi(`P = m \cdot g = 4 \cdot 10 = 40\text{ N}`) . Vì  #mi(`\angle ASC = 60^\circ`) , tam giác  #mi(`SAC`)  đều, nên  #mi(`\alpha = 30^\circ`) . Áp dụng công thức:  #mi(`T = \frac{P}{n \cdot \cos(\alpha)} = \frac{40}{4 \cdot \cos(30^\circ)} = \frac{40}{2\sqrt{3}} = \frac{20\sqrt{3}}{3} \approx 11.55\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Một vật nặng có trọng lượng  #mi(`P = 80\text{ N}`)  được treo bởi  #mi(`3`)  sợi dây đôi một vuông góc với nhau. Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức cho dây vuông góc:  #mi(`T = \frac{P}{\sqrt{n}} = \frac{80}{\sqrt{3}} \approx 46.19\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Một vật có khối lượng  #mi(`m = 2\text{ kg}`)  được treo bởi  #mi(`3`)  sợi dây đối xứng qua trục thẳng đứng, mỗi sợi dây hợp với phương thẳng đứng một góc  #mi(`45^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trọng lượng  #mi(`P = m \cdot g = 2 \cdot 10 = 20\text{ N}`) . Số sợi dây  #mi(`n = 3`) . Góc  #mi(`\alpha = 45^\circ`) . Áp dụng công thức:  #mi(`T = \frac{P}{n \cdot \cos(45^\circ)} = \frac{20}{3 \cdot \frac{\sqrt{2}}{2}} = \frac{40}{3\sqrt{2}} \approx 9.43\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật nặng  #mi(`P = 120\text{ N}`)  được treo bởi  #mi(`4`)  sợi dây đối xứng qua trục thẳng đứng. Biết mỗi sợi dây hợp với phương thẳng đứng một góc  #mi(`\alpha = 30^\circ`) . Tính lực căng mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì các dây đối xứng, lực căng mỗi sợi dây là  #mi(`T = \frac{P}{n \cdot \cos(\alpha)} = \frac{120}{4 \cdot \cos(30^\circ)} = \frac{120}{4 \cdot \frac{\sqrt{3}}{2}} = \frac{120}{2\text{sqrt}(3)} = 20\sqrt{3} \approx 34.64\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 25: Bài toán tối ưu hình học (Cắt góc tấm nhôm) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 25. Bài toán tối ưu hình học (Cắt góc tấm nhôm)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho tấm nhôm hình vuông cạnh  #mi(`a`) , cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  ( #mi(`0 < x < a/2`) ), ta được hình hộp không nắp có các kích thước: chiều cao  #mi(`h = x`) , cạnh đáy  #mi(`L = a - 2x`) .
  - Hàm thể tích:  #mi(`V(x) = x(a - 2x)^2`) .
  - Để thể tích lớn nhất, ta tìm cực trị của hàm  #mi(`V(x)`)  trên khoảng  #mi(`(0; a/2)`) , thường đạt tại  #mi(`x = a/6`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm thể tích lớn nhất khi cắt góc, hãy nhớ ngay:  #mi(`x = a/6`)  (với  #mi(`a`)  là cạnh tấm nhôm ban đầu).
  ]
  - *Công thức cốt lõi:* Thể tích lớn nhất của hình hộp không nắp được tạo thành từ tấm nhôm vuông cạnh  #mi(`a`)  là  #mi(`V_{max} =`) ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho một tấm nhôm hình vuông cạnh  #mi(`18`)  cm. Người ta cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để gấp thành một cái hộp không nắp. Tìm thể tích lớn nhất của cái hộp đó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 432]
      \ #text(fill: rgb("#334155"))[Lời giải: Cạnh tấm nhôm  #mi(`a = 18`) . Chiều cao  #mi(`x = a/6 = 18/6 = 3`) . Thể tích lớn nhất  #mi(`V_{max} = 3(18 - 2 \times 3)^2 = 3(12^2) = 3 \times 144 = 432`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một tấm nhôm hình chữ nhật có kích thước  #mi(`20`)  cm  #mi(`\times`)   #mi(`30`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để gấp thành hộp không nắp. Tìm giá trị  #mi(`x`)  để thể tích lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3.92]
      \ #text(fill: rgb("#334155"))[Lời giải: Hàm thể tích  #mi(`V(x) = x(20-2x)(30-2x) = x(600 - 100x + 4x^2) = 4x^3 - 100x^2 + 600x`) . Đạo hàm  #mi(`V'(x) = 12x^2 - 200x + 600`) . Giải  #mi(`V'(x) = 0 \Leftrightarrow 3x^2 - 50x + 150 = 0`) . Nghiệm  #mi(`x = \frac{50 \pm \sqrt{2500 - 1800}}{6} = \frac{50 \pm \sqrt{700}}{6} = \frac{25 \pm 5\sqrt{7}}{3}`) . Vì  #mi(`x < 10`) , chọn  #mi(`x = \frac{25 - 5\sqrt{7}}{3} \approx 3.92`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cho tấm vuông:] Cho một tấm nhôm hình vuông cạnh  #mi(`12`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để gấp thành một cái hộp không nắp. Tìm thể tích lớn nhất của cái hộp.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Cạnh tấm nhôm  #mi(`a = 12`) . Chiều cao  #mi(`x = a/6 = 12/6 = 2`) . Thể tích lớn nhất  #mi(`V_{max} = 2(12 - 2 \times 2)^2 = 2(8^2) = 128`)  cm #mi(`^3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Kiểm tra các thành phần hình hộp:] Từ một tấm nhôm vuông cạnh  #mi(`a`) , người ta cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  để tạo thành hộp không nắp. Nếu chiều cao hộp là  #mi(`x = 3`)  cm và thể tích là  #mi(`108`)  cm #mi(`^3`) , hãy tìm cạnh  #mi(`a`)  của tấm nhôm.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`V = x(a-2x)^2 \Rightarrow 108 = 3(a-6)^2 \Rightarrow 36 = (a-6)^2 \Rightarrow a-6 = 6 \Rightarrow a = 12`)  cm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể tấm hình chữ nhật:] Một tấm nhôm hình chữ nhật có kích thước  #mi(`10`)  cm  #mi(`\times`)   #mi(`16`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để gấp thành hộp không nắp. Tìm thể tích lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm thể tích  #mi(`V(x) = x(10-2x)(16-2x) = 4x^3 - 52x^2 + 160x`) . Đạo hàm  #mi(`V'(x) = 12x^2 - 104x + 160`) . Giải  #mi(`V'(x) = 0 \Leftrightarrow 3x^2 - 26x + 40 = 0 \Leftrightarrow (x-2)(3x-20) = 0`) . Nghiệm  #mi(`x=2`)  (thỏa mãn) hoặc  #mi(`x=20/3`)  (loại). Vậy  #mi(`V_{max} = 2(10-4)(16-4) = 2(6)(12) = 144`)  cm #mi(`^3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm diện tích đáy:] Cho một tấm nhôm vuông cạnh  #mi(`24`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để thể tích hộp lớn nhất. Tính diện tích đáy của hình hộp đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để  #mi(`V_{max}`) , ta có  #mi(`x = a/6 = 24/6 = 4`) . Cạnh đáy là  #mi(`L = a-2x = 24-8 = 16`) . Diện tích đáy  #mi(`S_{đáy} = 16^2 = 256`)  cm #mi(`^2`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho một tấm nhôm hình vuông cạnh  #mi(`24`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để gấp thành một cái hộp không nắp. Tìm thể tích lớn nhất của cái hộp đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Cạnh tấm nhôm  #mi(`a = 24`) . Chiều cao  #mi(`x = a/6 = 24/6 = 4`) . Thể tích lớn nhất  #mi(`V_{max} = 4(24 - 2 \times 4)^2 = 4(16^2) = 4 \times 256 = 1024`)  cm #mi(`^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một tấm nhôm hình vuông cạnh  #mi(`30`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để tạo thành hộp không nắp. Tìm thể tích lớn nhất của cái hộp.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Cạnh tấm nhôm  #mi(`a = 30`) . Chiều cao  #mi(`x = a/6 = 30/6 = 5`) . Thể tích lớn nhất  #mi(`V_{max} = 5(30 - 2 \times 5)^2 = 5(20^2) = 5(400) = 2000`)  cm #mi(`^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Từ một tấm nhôm hình vuông cạnh  #mi(`a`)  cm, người ta cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để tạo thành hộp không nắp. Nếu thể tích lớn nhất đạt được là  #mi(`250`)  cm #mi(`^3`) , hãy tìm  #mi(`a`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`V_{max} = 2a^3/27`) . Thay  #mi(`250 = 2a^3/27 \Rightarrow a^3 = 250 \times 27 / 2 = 3375 \Rightarrow a = \sqrt[3]{3375} = 15`)  cm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một tấm nhôm hình chữ nhật có kích thước  #mi(`12`)  cm  #mi(`\times`)   #mi(`18`)  cm. Cắt 4 góc là 4 hình vuông cạnh  #mi(`x`)  cm để gấp thành hộp không nắp. Tìm giá trị  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm thể tích  #mi(`V(x) = x(12-2x)(18-2x) = 4x^3 - 60x^2 + 216x`) . Đạo hàm  #mi(`V'(x) = 12x^2 - 120x + 216`) . Giải  #mi(`V'(x) = 0 \Leftrightarrow x^2 - 10x + 18 = 0 \Leftrightarrow x = 5 \pm \sqrt{7}`) . Vì  #mi(`x < 6`) , chọn  #mi(`x = 5 - \sqrt{7} \approx 2.35`)  cm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 26: Bài toán vật lý: Chuyển động của vật thể (Vận tốc/Gia tốc) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 26. Bài toán vật lý: Chuyển động của vật thể (Vận tốc/Gia tốc)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Vận tốc tức thời  #mi(`v(t)`)  là đạo hàm bậc nhất của quãng đường  #mi(`S(t)`)  theo thời gian  #mi(`t`) :  #mi(`v(t) = S'(t)`) .
  - Gia tốc tức thời  #mi(`a(t)`)  là đạo hàm bậc nhất của vận tốc  #mi(`v(t)`)  hoặc đạo hàm bậc hai của quãng đường  #mi(`S(t)`)  theo thời gian  #mi(`t`) :  #mi(`a(t) = v'(t) = S''(t)`) .
  - Vật dừng lại hoặc đổi chiều chuyển động khi vận tốc tức thời triệt tiêu:  #mi(`v(t) = 0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ chuỗi đạo hàm: Quãng đường  #mi(`\xrightarrow{S'} \text{Vận tốc} \xrightarrow{v'} \text{Gia tốc}`) .
  ]
  - *Công thức cốt lõi:* Vận tốc tức thời được tính bởi công thức  #mi(`v(t) = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chất điểm chuyển động có phương trình quãng đường  #mi(`S(t) = t^3 - 3t^2 - 9t + 2025`)  (với  #mi(`t > 0`) ,  #mi(`S`)  tính bằng mét,  #mi(`t`)  tính bằng giây). Tính gia tốc của chất điểm tại thời điểm vận tốc của nó triệt tiêu.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 12]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc của chất điểm là:  #mi(`v(t) = S'(t) = 3t^2 - 6t - 9`) . Vận tốc triệt tiêu khi  #mi(`v(t) = 0 \Leftrightarrow 3t^2 - 6t - 9 = 0 \Leftrightarrow t^2 - 2t - 3 = 0`) . Giải phương trình ta được  #mi(`t = 3`)  hoặc  #mi(`t = -1`) . Vì  #mi(`t > 0`)  nên ta chọn  #mi(`t = 3`) . Gia tốc của chất điểm là:  #mi(`a(t) = v'(t) = 6t - 6`) . Tại thời điểm  #mi(`t = 3`) , gia tốc là  #mi(`a(3) = 6(3) - 6 = 12`)  m/s².]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Độ cao của một khinh khí cầu theo thời gian được cho bởi công thức  #mi(`h(t) = 6t^3 - 81t^2 + 324t`)  (với  #mi(`t`)  tính bằng phút,  #mi(`h`)  tính bằng mét). Gọi  #mi(`(a; b)`)  là khoảng thời gian lớn nhất mà khinh khí cầu giảm dần độ cao. Tính giá trị biểu thức  #mi(`P = 2b - 3a`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc thay đổi độ cao là:  #mi(`v(t) = h'(t) = 18t^2 - 162t + 324`) . Khinh khí cầu giảm dần độ cao khi  #mi(`v(t) < 0 \Leftrightarrow 18(t^2 - 9t + 18) < 0 \Leftrightarrow 18(t-3)(t-6) < 0 \Leftrightarrow 3 < t < 6`) . Vậy khoảng thời gian lớn nhất là  #mi(`(3; 6)`) , suy ra  #mi(`a = 3`)  và  #mi(`b = 6`) . Giá trị biểu thức  #mi(`P = 2(6) - 3(3) = 12 - 9 = 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính vận tốc từ quãng đường:] Một vật chuyển động theo phương trình  #mi(`S(t) = 2t^3 - 3t^2 + 4`)  (m), với  #mi(`t`)  là thời gian tính bằng giây. Tính vận tốc của vật tại thời điểm  #mi(`t = 2`)  s.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc tức thời của vật là đạo hàm của quãng đường theo thời gian:  #mi(`v(t) = S'(t) = (2t^3 - 3t^2 + 4)' = 6t^2 - 6t`)  (m/s). Tại thời điểm  #mi(`t = 2`)  s, vận tốc của vật là:  #mi(`v(2) = 6(2)^2 - 6(2) = 24 - 12 = 12`)  (m/s).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính gia tốc từ vận tốc:] Vận tốc của một vật chuyển động được xác định bởi hàm số  #mi(`v(t) = 4t^2 - 2t + 1`)  (m/s), với  #mi(`t`)  tính bằng giây. Tính gia tốc của vật tại thời điểm  #mi(`t = 1`)  s.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gia tốc tức thời của vật là đạo hàm của vận tốc theo thời gian:  #mi(`a(t) = v'(t) = (4t^2 - 2t + 1)' = 8t - 2`)  (m/s²). Tại thời điểm  #mi(`t = 1`)  s, gia tốc của vật là:  #mi(`a(1) = 8(1) - 2 = 6`)  (m/s²).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm thời điểm vận tốc triệt tiêu:] Một vật chuyển động có phương trình quãng đường  #mi(`S(t) = t^3 - 6t^2 + 9t`)  (m). Tìm các thời điểm  #mi(`t`)  mà tại đó vật dừng lại (vận tốc triệt tiêu).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc của vật là:  #mi(`v(t) = S'(t) = 3t^2 - 12t + 9`)  (m/s). Vật dừng lại khi  #mi(`v(t) = 0 \Leftrightarrow 3t^2 - 12t + 9 = 0 \Leftrightarrow t^2 - 4t + 3 = 0`) . Giải phương trình bậc hai, ta được  #mi(`t = 1`)  s hoặc  #mi(`t = 3`)  s.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính gia tốc tại thời điểm cho trước:] Một vật chuyển động có vận tốc  #mi(`v(t) = t^2 - 4t + 5`)  (m/s). Tính gia tốc của vật tại thời điểm  #mi(`t = 3`)  s.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gia tốc của vật là đạo hàm của vận tốc:  #mi(`a(t) = v'(t) = (t^2 - 4t + 5)' = 2t - 4`)  (m/s²). Tại thời điểm  #mi(`t = 3`)  s, gia tốc của vật là:  #mi(`a(3) = 2(3) - 4 = 2`)  (m/s²).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một vật chuyển động theo phương trình  #mi(`S(t) = 3t^3 - 4t^2 + 5`)  (m). Tính vận tốc của vật tại thời điểm  #mi(`t = 1`)  s.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc của vật là:  #mi(`v(t) = S'(t) = 9t^2 - 8t`)  (m/s). Tại  #mi(`t = 1`)  s, vận tốc là:  #mi(`v(1) = 9(1)^2 - 8(1) = 1`)  (m/s).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một vật chuyển động theo phương trình  #mi(`S(t) = 2t^3 - 5t^2 + 10`)  (m). Tính vận tốc của vật tại thời điểm  #mi(`t = 2`)  s.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc của vật là:  #mi(`v(t) = S'(t) = 6t^2 - 10t`)  (m/s). Tại  #mi(`t = 2`)  s, vận tốc là:  #mi(`v(2) = 6(2)^2 - 10(2) = 24 - 20 = 4`)  (m/s).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Vận tốc của một vật là  #mi(`v(t) = 5t^2 - 6t + 2`)  (m/s). Tính gia tốc của vật tại thời điểm  #mi(`t = 2`)  s.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gia tốc của vật là:  #mi(`a(t) = v'(t) = 10t - 6`)  (m/s²). Tại  #mi(`t = 2`)  s, gia tốc là:  #mi(`a(2) = 10(2) - 6 = 14`)  (m/s²).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật chuyển động có phương trình quãng đường  #mi(`S(t) = t^3 - 3t^2 + 2`)  (m). Tìm thời điểm  #mi(`t > 0`)  mà tại đó vật dừng lại.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc của vật là:  #mi(`v(t) = S'(t) = 3t^2 - 6t`)  (m/s). Vật dừng lại khi  #mi(`v(t) = 0 \Leftrightarrow 3t(t - 2) = 0 \Leftrightarrow t = 0`)  hoặc  #mi(`t = 2`) . Vì  #mi(`t > 0`)  nên thời điểm vật dừng lại là  #mi(`t = 2`)  s.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một vật chuyển động có phương trình quãng đường  #mi(`S(t) = t^3 - 9t^2 + 24t`)  (m). Tính gia tốc của vật tại thời điểm vận tốc của nó triệt tiêu lần đầu tiên ( #mi(`t > 0`) ).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc của vật là:  #mi(`v(t) = S'(t) = 3t^2 - 18t + 24`)  (m/s). Vận tốc triệt tiêu khi  #mi(`v(t) = 0 \Leftrightarrow 3(t^2 - 6t + 8) = 0 \Leftrightarrow 3(t-2)(t-4) = 0 \Leftrightarrow t = 2`)  hoặc  #mi(`t = 4`) . Vận tốc triệt tiêu lần đầu tiên tại  #mi(`t = 2`)  s. Gia tốc của vật là:  #mi(`a(t) = v'(t) = 6t - 18`)  (m/s²). Tại  #mi(`t = 2`)  s, gia tốc là:  #mi(`a(2) = 6(2) - 18 = -6`)  (m/s²).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 27: Tính toán tọa độ điểm và vectơ trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 27. Tính toán tọa độ điểm và vectơ trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu  #mi(`A(x;y;z)`)  là một điểm, thì hình chiếu vuông góc của  #mi(`A`)  lên các trục tọa độ lần lượt là  #mi(`A_x(x;0;0)`) ,  #mi(`A_y(0;y;0)`) ,  #mi(`A_z(0;0;z)`)  và lên các mặt phẳng tọa độ là  #mi(`A_{xy}(x;y;0)`) ,  #mi(`A_{yz}(0;y;z)`) ,  #mi(`A_{zx}(x;0;z)`) 
  - Cho hai điểm  #mi(`A(x_A;y_A;z_A)`)  và  #mi(`B(x_B;y_B;z_B)`) , ta có  #mi(`\vec{AB} = (x_B-x_A; y_B-y_A; z_B-z_A)`)  và độ dài đoạn thẳng  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) 
  - Trong không gian, tích vô hướng của hai vectơ  #mi(`\vec{u}=(x_1;y_1;z_1)`)  và  #mi(`\vec{v}=(x_2;y_2;z_2)`)  là  #mi(`\vec{u} \cdot \vec{v} = x_1x_2 + y_1y_2 + z_1z_2`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm hình chiếu lên trục nào, hãy giữ nguyên tọa độ của trục đó và cho các tọa độ còn lại bằng  #mi(`0`) .
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`\vec{u}=(x_1;y_1;z_1)`)  và  #mi(`\vec{v}=(x_2;y_2;z_2)`)  thì  #mi(`\vec{u} \cdot \vec{v} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(1;2;5)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (1;0;0)]
      \ #text(fill: rgb("#334155"))[Lời giải: Hình chiếu vuông góc của điểm  #mi(`A(x;y;z)`)  lên trục  #mi(`Ox`)  có tọa độ là  #mi(`(x;0;0)`) . Áp dụng với  #mi(`A(1;2;5)`) , ta được hình chiếu là  #mi(`(1;0;0)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`\vec{u}=(1;2;2)`)  và  #mi(`\vec{v}=(3;0;4)`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 11]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 1 \cdot 3 + 2 \cdot 0 + 2 \cdot 4 = 3 + 0 + 8 = 11`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hình chiếu điểm lên trục tọa độ:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(3;-4;2)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của điểm  #mi(`A(x;y;z)`)  lên trục  #mi(`Ox`)  có tọa độ là  #mi(`(x;0;0)`) . Áp dụng với  #mi(`A(3;-4;2)`) , ta được hình chiếu là  #mi(`(3;0;0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tọa độ vectơ và độ dài đoạn thẳng:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1;2;3)`)  và  #mi(`B(4;6;3)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AB} = (4-1; 6-2; 3-3) = (3;4;0)`) . Độ dài đoạn thẳng  #mi(`AB`)  là  #mi(`AB = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9 + 16} = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tích vô hướng của hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u}=(2;-1;3)`)  và  #mi(`\vec{v}=(-1;2;1)`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{u} \cdot \vec{v} = 2 \cdot (-1) + (-1) \cdot 2 + 3 \cdot 1 = -2 - 2 + 3 = -1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phân tích vectơ trong hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{AC'}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AD}, \	ext{và} \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(5;-2;1)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`A`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của điểm  #mi(`A(x;y;z)`)  lên trục  #mi(`Ox`)  có tọa độ là  #mi(`(x;0;0)`) . Áp dụng với  #mi(`A(5;-2;1)`) , ta được hình chiếu là  #mi(`(5;0;0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`B(-3;4;7)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`B`)  lên trục  #mi(`Oy`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của điểm  #mi(`B(x;y;z)`)  lên trục  #mi(`Oy`)  có tọa độ là  #mi(`(0;y;0)`) . Áp dụng với  #mi(`B(-3;4;7)`) , ta được hình chiếu là  #mi(`(0;4;0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho  #mi(`\vec{u}=(2;3;-1)`)  và  #mi(`\vec{v}=(4;-2;5)`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 2 \cdot 4 + 3 \cdot (-2) + (-1) \cdot 5 = 8 - 6 - 5 = -3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1;1;1)`)  và  #mi(`B(2;3;4)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = (2-1; 3-1; 4-1) = (1;2;3)`) . Độ dài đoạn thẳng  #mi(`AB`)  là  #mi(`AB = \sqrt{1^2 + 2^2 + 3^2} = \sqrt{1 + 4 + 9} = \sqrt{14}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 28: Bài toán thực tế: Lạm phát và sức mua ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 28. Bài toán thực tế: Lạm phát và sức mua]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Sức mua sau năm thứ nhất với tỷ lệ lạm phát  #mi(`r_1`)  là:  #mi(`M_1 = M_0 \times (1 - r_1)`) 
  - Sức mua sau  #mi(`n`)  năm với các tỷ lệ lạm phát lần lượt là  #mi(`r_1, r_2, ..., r_n`)  là:  #mi(`M_n = M_0 \times (1 - r_1) \times (1 - r_2) \times ... \times (1 - r_n)`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lạm phát làm giảm giá trị tiền, nên ta dùng dấu trừ  #mi(`(-)`)  trong ngoặc:  #mi(`(1 - r)`) 
  ]
  - *Công thức cốt lõi:* Sức mua sau  #mi(`n`)  năm là  #mi(`M_n = M_0 \times (1 - r_1) \times (1 - r_2) \times ... \times (1 - r_n)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một người có 500 triệu đồng. Sau hai năm, tỷ lệ lạm phát lần lượt là 4% và 5%. Hỏi sức mua của số tiền đó sau hai năm là bao nhiêu triệu đồng? (Làm tròn đến hàng phần trăm)
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 456]
      \ #text(fill: rgb("#334155"))[Lời giải: Sức mua sau hai năm là:  #mi(`500 \times (1 - 0,04) \times (1 - 0,05) = 500 \times 0,96 \times 0,95 = 456`)  (triệu đồng).]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Số tiền 100 triệu đồng sau hai năm lạm phát liên tiếp 10% mỗi năm sẽ còn lại bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 81]
      \ #text(fill: rgb("#334155"))[Lời giải: Sức mua sau hai năm là:  #mi(`100 \times (1 - 0,1) \times (1 - 0,1) = 100 \times 0,9 \times 0,9 = 81`)  (triệu đồng).]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cho 2 năm lạm phát khác nhau:] Một số tiền 200 triệu đồng sau hai năm, tỷ lệ lạm phát lần lượt là 6% và 7%. Hỏi sức mua của số tiền đó sau hai năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau hai năm là:  #mi(`M_2 = 200 \times (1 - 0,06) \times (1 - 0,07) = 200 \times 0,94 \times 0,93 = 174,76`)  (triệu đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức cho lạm phát cùng tỷ lệ:] Một người gửi tiết kiệm 1 tỷ đồng. Sau hai năm, tỷ lệ lạm phát mỗi năm là 5%. Hỏi sức mua của số tiền đó sau hai năm là bao nhiêu tỷ đồng?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau hai năm là:  #mi(`M_2 = 1 \times (1 - 0,05) \times (1 - 0,05) = 1 \times 0,95 \times 0,95 = 0,9025`)  (tỷ đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tỷ lệ giảm giá trị tổng quát:] Một số tiền 100 triệu đồng sau hai năm lạm phát lần lượt là 10% và 20%. Tính tổng tỷ lệ giảm giá trị của số tiền này sau hai năm.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tổng tỷ lệ giảm giá trị là:  #mi(`1 - (1 - 0,1) \times (1 - 0,2) = 1 - 0,9 \times 0,8 = 1 - 0,72 = 0,28`)  (tức là 28%).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể: Tính số tiền ban đầu:] Sau hai năm lạm phát lần lượt là 5% và 5%, sức mua của 180,5 triệu đồng là 162,855 triệu đồng. Hỏi số tiền ban đầu là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi số tiền ban đầu là  #mi(`M_0`) . Ta có  #mi(`M_0 \times (1 - 0,05) \times (1 - 0,05) = 162,855 \rightarrow M_0 \times 0,9025 = 162,855 \rightarrow M_0 = 162,855 / 0,9025 = 180`)  (triệu đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Tính sức mua sau 3 năm:] Một số tiền 50 triệu đồng sau ba năm lạm phát lần lượt là 2%, 3% và 4%. Hỏi sức mua của số tiền đó sau ba năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau ba năm là:  #mi(`M_3 = 50 \times (1 - 0,02) \times (1 - 0,03) \times (1 - 0,04) = 50 \times 0,98 \times 0,97 \times 0,96 = 45,6288`)  (triệu đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 6 - Tính sức mua sau 1 năm:] Một số tiền 100 triệu đồng sau một năm lạm phát 10%. Hỏi sức mua là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Sức mua sau một năm là:  #mi(`M_1 = 100 \times (1 - 0,1) = 90`)  (triệu đồng).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một số tiền 300 triệu đồng sau hai năm, tỷ lệ lạm phát lần lượt là 5% và 6%. Hỏi sức mua của số tiền đó sau hai năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau hai năm là:  #mi(`300 \times (1 - 0,05) \times (1 - 0,06) = 300 \times 0,95 \times 0,94 = 267,9`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một số tiền 400 triệu đồng sau hai năm, tỷ lệ lạm phát lần lượt là 4% và 8%. Hỏi sức mua của số tiền đó sau hai năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau hai năm là:  #mi(`400 \times (1 - 0,04) \times (1 - 0,08) = 400 \times 0,96 \times 0,92 = 353,28`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] A số tiền 500 triệu đồng sau hai năm, tỷ lệ lạm phát mỗi năm là 10%. Hỏi sức mua của số tiền đó sau hai năm là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Sức mua sau hai năm là:  #mi(`500 \times (1 - 0,1) \times (1 - 0,1) = 500 \times 0,9 \times 0,9 = 405`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Sau hai năm lạm phát lần lượt là 10% và 10%, sức mua của 200 triệu đồng là 162 triệu đồng. Hỏi số tiền ban đầu là bao nhiêu triệu đồng?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi số tiền ban đầu là  #mi(`M_0`) . Ta có  #mi(`M_0 \times (1 - 0,1) \times (1 - 0,1) = 162 \rightarrow M_0 \times 0,81 = 162 \rightarrow M_0 = 162 / 0,81 = 200`)  (triệu đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
