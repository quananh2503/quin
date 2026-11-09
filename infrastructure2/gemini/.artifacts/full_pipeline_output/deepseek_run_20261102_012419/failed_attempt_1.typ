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
  #text(size: 13pt, weight: "bold")[Chuyên đề Hàm số và Ứng dụng thực tế (Toán 12 - GDPT 2018)] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Hệ thống bài tập trắc nghiệm và tự luận về tính đơn điệu, cực trị, tiệm cận, đồ thị hàm số, cùng các bài toán tối ưu hóa thực tế và ứng dụng vectơ trong không gian. Tài liệu được tổng hợp từ 5 đề ôn tập giữa học kì I, kết hợp phương pháp giải nhanh và Casio.]
]
#v(6pt)

// ==================== DẠNG 1: Nhận dạng đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Nhận dạng đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  ( #mi(`a \neq 0`) ): Nhánh phải đi lên nếu  #mi(`a > 0`) , đi xuống nếu  #mi(`a < 0`) . Đồ thị nhận điểm uốn làm tâm đối xứng.
  - Hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`)  ( #mi(`c \neq 0, ad-bc \neq 0`) ): Tiệm cận đứng  #mi(`x = -\frac{d}{c}`) , tiệm cận ngang  #mi(`y = \frac{a}{c}`) . Giao điểm hai tiệm cận là tâm đối xứng.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Bậc ba: Nhìn nhánh phải (a>0 đi lên, a<0 đi xuống), tìm điểm uốn. Phân thức: Nhìn tiệm cận đứng (nghiệm mẫu) và tiệm cận ngang (tỉ số hệ số bậc cao nhất).
  ]
  - *Công thức cốt lõi:* Đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng là đường thẳng  #mi(`x = ...`)  và tiệm cận ngang là đường thẳng  #mi(`y = ...`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị nhận đường thẳng  #mi(`x=2`)  làm tiệm cận đứng và  #mi(`y=3`)  làm tiệm cận ngang. Tính giá trị biểu thức  #mi(`T = 2a - c`)  biết  #mi(`d = -2c`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận đứng  #mi(`x = -\frac{d}{c} = 2 \Rightarrow d = -2c`)  (thỏa mãn). Tiệm cận ngang  #mi(`y = \frac{a}{c} = 3 \Rightarrow a = 3c`) . Vậy  #mi(`T = 2(3c) - c = 5c`) . Do  #mi(`c`)  có thể chọn tùy ý khác 0, nhưng thường đề bài ẩn sẽ cho thêm dữ kiện. Nếu không,  #mi(`T`)  phụ thuộc  #mi(`c`) . Giả sử  #mi(`c=1`) ,  #mi(`T=5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị đi qua điểm  #mi(`A(0; 2)`)  và có điểm uốn  #mi(`I(1; 0)`) . Tính  #mi(`a + b + c + d`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị qua  #mi(`A(0;2) \Rightarrow d = 2`) . Điểm uốn  #mi(`I(1;0)`)  thuộc đồ thị  #mi(`\Rightarrow a + b + c + 2 = 0 \Rightarrow a+b+c = -2`) . Vậy  #mi(`a+b+c+d = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận dạng đồ thị hàm bậc ba:] Đồ thị hình bên là của hàm số nào trong các hàm số sau? Biết đồ thị có điểm uốn nằm trên trục tung và nhánh phải đi lên.\nA.  #mi(`y = -x^3 + 3x + 1`) \nB.  #mi(`y = x^3 - 3x + 1`) \nC.  #mi(`y = x^3 + 3x + 1`) \nD.  #mi(`y = -x^3 - 3x + 1`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, nhánh phải đi lên nên hệ số  #mi(`a > 0`) . Loại A, D. Đồ thị có 2 điểm cực trị nên  #mi(`y' = 3ax^2 + 2bx + c = 0`)  có 2 nghiệm phân biệt. Với B:  #mi(`y' = 3x^2 - 3 = 0`)  có 2 nghiệm. Với C:  #mi(`y' = 3x^2 + 3 > 0`)  vô nghiệm (hàm số luôn đồng biến, không có cực trị). Vậy chọn B.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận dạng đồ thị hàm phân thức:] Đồ thị hình bên là của hàm số nào?\nA.  #mi(`y = \frac{x-1}{x+1}`) \nB.  #mi(`y = \frac{x+1}{x-1}`) \nC.  #mi(`y = \frac{-x}{1-x}`) \nD.  #mi(`y = \frac{2x+1}{2x-2}`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị có tiệm cận đứng  #mi(`x = -1`)  và tiệm cận ngang  #mi(`y = 1`) . Xét các đáp án:\nA. TCĐ  #mi(`x = -1`) , TCN  #mi(`y = 1`) .\nB. TCĐ  #mi(`x = 1`) , TCN  #mi(`y = 1`) .\nC. TCĐ  #mi(`x = 1`) , TCN  #mi(`y = 1`) .\nD. TCĐ  #mi(`x = 1`) , TCN  #mi(`y = 1`) .\nVậy chọn A.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tham số từ đồ thị hàm bậc ba:] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Biết đồ thị đi qua gốc tọa độ và điểm cực đại là  #mi(`(-1; 2)`) . Tìm dấu của  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị đi qua gốc tọa độ  #mi(`O(0;0)`)  nên  #mi(`d = 0`) . Nhánh phải đi xuống nên  #mi(`a < 0`) . Điểm cực đại  #mi(`(-1; 2)`)  nằm bên trái trục tung, điểm cực tiểu nằm bên phải. Hoành độ điểm uốn  #mi(`x = -\frac{b}{3a} < 0`) . Vì  #mi(`a < 0`)  nên  #mi(`b < 0`) . Điểm cực đại  #mi(`(-1;2)`)  có hoành độ âm, điểm cực tiểu dương nên  #mi(`y' = 3ax^2 + 2bx + c = 0`)  có 2 nghiệm trái dấu  #mi(`\Rightarrow \frac{c}{3a} < 0 \Rightarrow c > 0`)  (vì  #mi(`a < 0`) ). Vậy  #mi(`a<0, b<0, c>0, d=0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tham số từ đồ thị hàm phân thức:] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Đồ thị có tiệm cận đứng  #mi(`x = 2`) , tiệm cận ngang  #mi(`y = 1`)  và đi qua điểm  #mi(`A(0; -1)`) . Tính  #mi(`a + b + c + d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] TCĐ  #mi(`x = 2 \Rightarrow -\frac{d}{c} = 2 \Rightarrow d = -2c`) . TCN  #mi(`y = 1 \Rightarrow \frac{a}{c} = 1 \Rightarrow a = c`) . Đồ thị qua  #mi(`A(0;-1) \Rightarrow \frac{b}{d} = -1 \Rightarrow b = -d = 2c`) . Chọn  #mi(`c = 1 \Rightarrow a=1, b=2, d=-2`) . Vậy  #mi(`a+b+c+d = 1+2+1-2 = 2`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Đồ thị hình bên là của hàm số nào? Biết đồ thị có nhánh phải đi xuống và cắt trục tung tại điểm có tung độ dương.\nA.  #mi(`y = -x^3 + 3x^2 + 1`) \nB.  #mi(`y = x^3 - 3x^2 + 1`) \nC.  #mi(`y = -x^3 - 3x^2 + 1`) \nD.  #mi(`y = x^3 + 3x^2 + 1`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Nhánh phải đi xuống  #mi(`\Rightarrow a < 0`) . Loại B, D. Đồ thị cắt trục tung tại điểm có tung độ dương  #mi(`\Rightarrow d > 0`) . Cả A và C đều có  #mi(`d=1>0`) . Xét điểm uốn:  #mi(`y' = -3x^2 + 6x = 0 \Rightarrow x=0`)  hoặc  #mi(`x=2`) . Điểm uốn  #mi(`x=1`) . Đồ thị A có điểm uốn  #mi(`x=1`)  (thuộc bên phải trục tung), đồ thị C có điểm uốn  #mi(`x=-1`)  (bên trái). Quan sát đồ thị thấy điểm uốn nằm bên phải trục tung. Chọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Đồ thị hình bên là của hàm số nào? Biết đồ thị có nhánh phải đi lên và cắt trục tung tại điểm có tung độ âm.\nA.  #mi(`y = x^3 - 3x - 1`) \nB.  #mi(`y = -x^3 + 3x - 1`) \nC.  #mi(`y = x^3 + 3x - 1`) \nD.  #mi(`y = -x^3 - 3x - 1`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Nhánh phải đi lên  #mi(`\Rightarrow a > 0`) . Loại B, D. Đồ thị cắt trục tung tại điểm có tung độ âm  #mi(`\Rightarrow d < 0`) . Cả A và C đều có  #mi(`d=-1<0`) . Xét cực trị: A có  #mi(`y' = 3x^2 - 3 = 0`)  có 2 nghiệm phân biệt. C có  #mi(`y' = 3x^2 + 3 > 0`)  vô nghiệm. Đồ thị có 2 cực trị nên chọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Đồ thị hình bên là của hàm số nào?\nA.  #mi(`y = \frac{x-2}{x-1}`) \nB.  #mi(`y = \frac{x+2}{x+1}`) \nC.  #mi(`y = \frac{x-1}{x+1}`) \nD.  #mi(`y = \frac{x+1}{x-1}`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đồ thị có tiệm cận đứng  #mi(`x = 1`)  và tiệm cận ngang  #mi(`y = 1`) . Xét các đáp án:\nA. TCĐ  #mi(`x=1`) , TCN  #mi(`y=1`) .\nB. TCĐ  #mi(`x=-1`) , TCN  #mi(`y=1`) .\nC. TCĐ  #mi(`x=-1`) , TCN  #mi(`y=1`) .\nD. TCĐ  #mi(`x=1`) , TCN  #mi(`y=1`) .
Đồ thị cắt trục hoành tại điểm có hoành độ dương. A có  #mi(`y=0 \Rightarrow x=2`)  (thỏa mãn). D có  #mi(`y=0 \Rightarrow x=-1`)  (loại). Chọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị nhận đường thẳng  #mi(`x = -2`)  làm tiệm cận đứng và  #mi(`y = 2`)  làm tiệm cận ngang. Biết đồ thị đi qua điểm  #mi(`M(0; 1)`) . Tính  #mi(`a + 2b + 3c + 4d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: TCĐ  #mi(`x = -2 \Rightarrow -\frac{d}{c} = -2 \Rightarrow d = 2c`) . TCN  #mi(`y = 2 \Rightarrow \frac{a}{c} = 2 \Rightarrow a = 2c`) . Đồ thị qua  #mi(`M(0;1) \Rightarrow \frac{b}{d} = 1 \Rightarrow b = d = 2c`) . Chọn  #mi(`c=1 \Rightarrow a=2, b=2, d=2`) . Vậy  #mi(`a + 2b + 3c + 4d = 2 + 4 + 3 + 8 = 17`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Biết đồ thị có điểm cực đại  #mi(`A(-1; 4)`)  và điểm cực tiểu  #mi(`B(1; 0)`) . Tính  #mi(`a + b + c + d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đồ thị qua  #mi(`B(1;0) \Rightarrow a + b + c + d = 0`) . (Không cần tìm cụ thể hệ số).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Biết đồ thị có tiệm cận đứng  #mi(`x = 1`) , tiệm cận ngang  #mi(`y = -1`)  và cắt trục hoành tại  #mi(`x = 2`) . Tính  #mi(`T = a - b + c - d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: TCĐ  #mi(`x=1 \Rightarrow -\frac{d}{c}=1 \Rightarrow d=-c`) . TCN  #mi(`y=-1 \Rightarrow \frac{a}{c}=-1 \Rightarrow a=-c`) . Cắt trục hoành tại  #mi(`x=2 \Rightarrow \frac{2a+b}{2c+d}=0 \Rightarrow 2a+b=0 \Rightarrow b=-2a=2c`) . Chọn  #mi(`c=1 \Rightarrow a=-1, b=2, d=-1`) . Vậy  #mi(`T = -1 - 2 + 1 - (-1) = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Tính đơn điệu của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Tính đơn điệu của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`K`)  nếu  #mi(`f'(x) > 0`)  với mọi  #mi(`x \in K`)  (dấu bằng xảy ra tại hữu hạn điểm).
  - Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng  #mi(`K`)  nếu  #mi(`f'(x) < 0`)  với mọi  #mi(`x \in K`)  (dấu bằng xảy ra tại hữu hạn điểm).
  - Từ bảng biến thiên hoặc đồ thị: Hàm số đồng biến trên các khoảng mà mũi tên đi lên (hoặc đồ thị đi lên từ trái sang phải), nghịch biến trên các khoảng mà mũi tên đi xuống (hoặc đồ thị đi xuống từ trái sang phải).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo nhớ nhanh: "Đồng biến thì đi lên, nghịch biến thì đi xuống". Đối với công thức đạo hàm, giải  #mi(`f'(x)=0`)  để tìm các điểm tới hạn, lập bảng xét dấu đạo hàm rồi kết luận.
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  có đạo hàm trên  #mi(`K`) . Nếu  #mi(`f'(x) ... 0`)  với mọi  #mi(`x \in K`)  thì hàm số đồng biến trên  #mi(`K`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`) . Tìm các khoảng đồng biến của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`(-\infty;0)`)  và  #mi(`(2;+\infty)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Giải  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' > 0`)  trên các khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`y' < 0`)  trên khoảng  #mi(`(0; 2)`) . Vậy hàm số đồng biến trên các khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = -x^3 + 3x`) . Tìm các khoảng nghịch biến của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`(-\infty;-1)`)  và  #mi(`(1;+\infty)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = -3x^2 + 3`) . Giải  #mi(`y' = 0 \Leftrightarrow -3(x^2 - 1) = 0 \Leftrightarrow x = \pm 1`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' < 0`)  trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) ;  #mi(`y' > 0`)  trên khoảng  #mi(`(-1; 1)`) . Vậy hàm số nghịch biến trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = x^3 - 3x^2 + 3x - 1`) . Chứng minh hàm số đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\mathbb{R}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = 3x^2 - 6x + 3 = 3(x^2 - 2x + 1) = 3(x - 1)^2 \ge 0`)  với mọi  #mi(`x \in \mathbb{R}`)  (dấu bằng xảy ra tại  #mi(`x = 1`) ). Vậy hàm số đồng biến trên  #mi(`\mathbb{R}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức đạo hàm cơ bản:] Xét tính đồng biến, nghịch biến của hàm số  #mi(`y = x^3 - 3x`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = 3x^2 - 3`) . Giải  #mi(`y' = 0 \Leftrightarrow 3(x^2 - 1) = 0 \Leftrightarrow x = 1`)  hoặc  #mi(`x = -1`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' > 0`)  trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) ;  #mi(`y' < 0`)  trên  #mi(`(-1; 1)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , nghịch biến trên  #mi(`(-1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Dựa vào bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`\nearrow`)  | |  #mi(`\searrow`)  | |  #mi(`\nearrow`)  |\nTìm các khoảng đồng biến, nghịch biến của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta thấy  #mi(`f'(x) > 0`)  trên các khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`f'(x) < 0`)  trên khoảng  #mi(`(0; 2)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Dựa vào đồ thị:] Cho hàm số  #mi(`y = f(x)`)  có đồ thị như hình vẽ (đồ thị đi lên trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , đi xuống trên  #mi(`(-1; 1)`) ). Tìm các khoảng đồng biến, nghịch biến của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị, ta thấy đồ thị đi lên (từ trái sang phải) trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , đi xuống trên khoảng  #mi(`(-1; 1)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , nghịch biến trên  #mi(`(-1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Áp dụng công thức đạo hàm (hàm bậc ba có hệ số a âm):] Xét tính đồng biến, nghịch biến của hàm số  #mi(`y = -x^3 + 3x^2 - 4`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = -3x^2 + 6x`) . Giải  #mi(`y' = 0 \Leftrightarrow -3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' < 0`)  trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`y' > 0`)  trên  #mi(`(0; 2)`) . Vậy hàm số nghịch biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , đồng biến trên  #mi(`(0; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Xét tính đồng biến, nghịch biến của hàm số  #mi(`y = x^3 - 3x^2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Giải  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' > 0`)  trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`y' < 0`)  trên  #mi(`(0; 2)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Xét tính đồng biến, nghịch biến của hàm số  #mi(`y = x^3 - 3x^2 + 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Giải  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' > 0`)  trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`y' < 0`)  trên  #mi(`(0; 2)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Xét tính đồng biến, nghịch biến của hàm số  #mi(`y = -x^3 + 3x^2 - 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = -3x^2 + 6x`) . Giải  #mi(`y' = 0 \Leftrightarrow -3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y' < 0`)  trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`y' > 0`)  trên  #mi(`(0; 2)`) . Vậy hàm số nghịch biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , đồng biến trên  #mi(`(0; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-1`)  |  #mi(`1`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`\nearrow`)  | |  #mi(`\searrow`)  | |  #mi(`\nearrow`)  |\nTìm các khoảng đồng biến, nghịch biến của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy  #mi(`f'(x) > 0`)  trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) ;  #mi(`f'(x) < 0`)  trên khoảng  #mi(`(-1; 1)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) , nghịch biến trên  #mi(`(-1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho hàm số  #mi(`y = f(x)`)  có đồ thị như hình vẽ (đồ thị đi lên trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , đi xuống trên  #mi(`(0; 2)`) ). Tìm các khoảng đồng biến, nghịch biến của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quan sát đồ thị, ta thấy đồ thị đi lên (từ trái sang phải) trên các khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , đi xuống trên khoảng  #mi(`(0; 2)`) . Vậy hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Chứng minh hàm số  #mi(`y = x^3 - 3x^2 + 3x`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Đạo hàm:  #mi(`y' = 3x^2 - 6x + 3 = 3(x^2 - 2x + 1) = 3(x - 1)^2 \ge 0`)  với mọi  #mi(`x \in \mathbb{R}`)  (dấu bằng xảy ra tại  #mi(`x = 1`) ). Vậy hàm số đồng biến trên  #mi(`\mathbb{R}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Cực trị của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Cực trị của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm  #mi(`x_0`)  là điểm cực đại nếu  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi đi qua  #mi(`x_0`) ; là điểm cực tiểu nếu  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi đi qua  #mi(`x_0`) .
  - Từ bảng biến thiên: Quan sát chiều mũi tên của hàm số. Điểm mà hàm số chuyển từ đồng biến sang nghịch biến là điểm cực đại; từ nghịch biến sang đồng biến là điểm cực tiểu.
  - Từ đồ thị: Điểm 'đỉnh' (cao nhất trong lân cận) là điểm cực đại, điểm 'đáy' (thấp nhất trong lân cận) là điểm cực tiểu.
  - Từ công thức: Tính  #mi(`y'`) , giải phương trình  #mi(`y'=0`)  tìm các nghiệm  #mi(`x_i`) . Lập bảng xét dấu  #mi(`y'`)  để kết luận cực trị.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo nhớ nhanh: 'Đổi dấu đạo hàm là cực trị'. Cụ thể: '+ sang -' là Cực Đại (Cao nhất), '- sang +' là Cực Tiểu (Thấp nhất).
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x)`)  đổi dấu từ  #mi(`...`)  sang  #mi(`...`)  khi đi qua  #mi(`x_0`)  thì  #mi(`x_0`)  là điểm cực đại.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`) . Tìm giá trị cực đại của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi qua  #mi(`x = 0`)  nên hàm số đạt cực đại tại  #mi(`x = 0`) . Giá trị cực đại là  #mi(`y(0) = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = -x^3 + 3x + 1`) . Gọi  #mi(`A`)  và  #mi(`B`)  là hai điểm cực trị của đồ thị hàm số. Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .  #mi(`y' = -3x^2 + 3 = 0 \Leftrightarrow x = \pm 1`) . Tọa độ các điểm cực trị là  #mi(`A(-1; 3)`)  và  #mi(`B(1; 3)`) . Độ dài  #mi(`AB = \sqrt{(1 - (-1))^2 + (3 - 3)^2} = \sqrt{2^2} = 2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm cực trị từ bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`1`)  |  #mi(`3`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`y'`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`y`)  |  #mi(`-\infty`)  |  #mi(`\nearrow`)  |  #mi(`4`)  |  #mi(`\searrow`)  |  #mi(`0`)  |  #mi(`\nearrow`)  |  #mi(`+\infty`)  |\nTìm các điểm cực trị của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x = 1`) ,  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x = 1`)  là điểm cực đại.
- Tại  #mi(`x = 3`) ,  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x = 3`)  là điểm cực tiểu.\nVậy hàm số đạt cực đại tại  #mi(`x = 1`)  và đạt cực tiểu tại  #mi(`x = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm cực trị từ đồ thị:] Cho đồ thị hàm số  #mi(`y = f(x)`)  như hình vẽ. Hãy xác định các điểm cực trị của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị, ta thấy:
- Đồ thị có điểm cao nhất trong lân cận tại  #mi(`x = -1`) , do đó hàm số đạt cực đại tại  #mi(`x = -1`) .
- Đồ thị có điểm thấp nhất trong lân cận tại  #mi(`x = 1`) , do đó hàm số đạt cực tiểu tại  #mi(`x = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm cực trị từ công thức:] Tìm các điểm cực trị của hàm số  #mi(`y = x^3 - 3x + 1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R}`) .\nTính đạo hàm:  #mi(`y' = 3x^2 - 3`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = \pm 1`) .\nLập bảng xét dấu  #mi(`y'`) :
- Khi  #mi(`x < -1`) ,  #mi(`y' > 0`) .
- Khi  #mi(`-1 < x < 1`) ,  #mi(`y' < 0`) .
- Khi  #mi(`x > 1`) ,  #mi(`y' > 0`) .\nVậy  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi qua  #mi(`x = -1`)  nên hàm số đạt cực đại tại  #mi(`x = -1`) .
 #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi qua  #mi(`x = 1`)  nên hàm số đạt cực tiểu tại  #mi(`x = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tham số m để hàm số có cực trị:] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3`) . Tìm tất cả các giá trị của tham số  #mi(`m`)  để hàm số có cực trị.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R}`) .\nTính đạo hàm:  #mi(`y' = 3x^2 - 6mx = 3x(x - 2m)`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2m) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2m`) .
Để hàm số có cực trị thì phương trình  #mi(`y' = 0`)  phải có hai nghiệm phân biệt.
Điều này tương đương với  #mi(`2m \neq 0 \Leftrightarrow m \neq 0`) .\nVậy với  #mi(`m \neq 0`)  thì hàm số đã cho có cực trị.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm các điểm cực trị của hàm số  #mi(`y = x^3 - 3x^2 + 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi qua  #mi(`x = 0`)  nên hàm số đạt cực đại tại  #mi(`x = 0`) .  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi qua  #mi(`x = 2`)  nên hàm số đạt cực tiểu tại  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm các điểm cực trị của hàm số  #mi(`y = -x^3 + 3x^2 + 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = -3x^2 + 6x = -3x(x - 2)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi qua  #mi(`x = 0`)  nên hàm số đạt cực tiểu tại  #mi(`x = 0`) .  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi qua  #mi(`x = 2`)  nên hàm số đạt cực đại tại  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm các điểm cực trị của hàm số  #mi(`y = x^4 - 2x^2 + 3`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 4x^3 - 4x = 4x(x^2 - 1)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0, x = 1, x = -1`) . Lập bảng xét dấu  #mi(`y'`) :  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi qua  #mi(`x = -1`)  nên hàm số đạt cực tiểu tại  #mi(`x = -1`) .  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi qua  #mi(`x = 0`)  nên hàm số đạt cực đại tại  #mi(`x = 0`) .  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi qua  #mi(`x = 1`)  nên hàm số đạt cực tiểu tại  #mi(`x = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`2`)  |  #mi(`+\infty`)  |
|---|---|---|---|
|  #mi(`y'`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`y`)  |  #mi(`+\infty`)  |  #mi(`\searrow`)  |  #mi(`-1`)  |  #mi(`\nearrow`)  |  #mi(`+\infty`)  |\nHỏi hàm số đạt cực tiểu tại điểm nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy tại  #mi(`x = 2`) ,  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`) . Do đó, hàm số đạt cực tiểu tại  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho đồ thị hàm số  #mi(`y = f(x)`)  có điểm cao nhất trong lân cận tại  #mi(`(0; 3)`)  và điểm thấp nhất trong lân cận tại  #mi(`(2; -1)`) . Hỏi giá trị cực tiểu của hàm số bằng bao nhiêu?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điểm thấp nhất trong lân cận trên đồ thị là điểm cực tiểu. Tọa độ điểm này là  #mi(`(2; -1)`) , do đó giá trị cực tiểu của hàm số là  #mi(`y_{CT} = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3`) . Tìm tất cả các giá trị của tham số  #mi(`m`)  để hàm số có cực trị.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx = 3x(x - 2m)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2m`) . Để hàm số có cực trị thì phương trình  #mi(`y' = 0`)  phải có hai nghiệm phân biệt, tức là  #mi(`2m \neq 0 \Leftrightarrow m \neq 0`) . Vậy  #mi(`m \neq 0`)  là giá trị cần tìm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Tiệm cận của đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Tiệm cận của đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Đường thẳng  #mi(`x = x_0`)  là tiệm cận đứng (TCĐ) của đồ thị hàm số  #mi(`y = f(x)`)  nếu  #mi(`\lim_{x\to x_0^+} f(x) = \pm\infty`)  hoặc  #mi(`\lim_{x\to x_0^-} f(x) = \pm\infty`) .
  - Đường thẳng  #mi(`y = y_0`)  là tiệm cận ngang (TCN) của đồ thị hàm số  #mi(`y = f(x)`)  nếu  #mi(`\lim_{x\to +\infty} f(x) = y_0`)  hoặc  #mi(`\lim_{x\to -\infty} f(x) = y_0`) .
  - Đường thẳng  #mi(`y = ax + b`)  ( #mi(`a \neq 0`) ) là tiệm cận xiên (TCX) của đồ thị hàm số  #mi(`y = f(x)`)  nếu  #mi(`\lim_{x\to +\infty} [f(x) - (ax+b)] = 0`)  hoặc  #mi(`\lim_{x\to -\infty} [f(x) - (ax+b)] = 0`) .
  - Cho hàm phân thức  #mi(`y = \frac{P(x)}{Q(x)}`) : Nếu bậc  #mi(`P <`)  bậc  #mi(`Q`)  thì TCN là  #mi(`y=0`) ; nếu bậc  #mi(`P =`)  bậc  #mi(`Q`)  thì TCN là  #mi(`y = \frac{a}{c}`)  (với  #mi(`a, c`)  là hệ số bậc cao nhất của tử và mẫu); nếu bậc  #mi(`P =`)  bậc  #mi(`Q + 1`)  thì đồ thị có TCX (là phần nguyên của phép chia  #mi(`P(x)`)  cho  #mi(`Q(x)`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo nhớ nhanh: 'Đứng tìm nghiệm mẫu, Ngang tìm giới hạn vô cùng, Xiên chia đa thức'. Đối với hàm phân thức, TCĐ là nghiệm của mẫu không bị triệt tiêu bởi tử.
  ]
  - *Công thức cốt lõi:* Đường thẳng  #mi(`y = y_0`)  là tiệm cận ngang của đồ thị hàm số  #mi(`y = f(x)`)  nếu  #mi(`\lim_{x\to +\infty} f(x) = ...`)  hoặc  #mi(`\lim_{x\to -\infty} f(x) = y_0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{3x-2}{x+1}`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`I`)  là giao điểm của hai đường tiệm cận của  #mi(`(C)`) . Tính tổng hoành độ và tung độ của điểm  #mi(`I`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .\nTa có  #mi(`\lim_{x\to -1^+} y = \lim_{x\to -1^+} \frac{3x-2}{x+1} = -\infty`)  và  #mi(`\lim_{x\to -1^-} y = +\infty`) , suy ra TCĐ là  #mi(`x = -1`) .\nTa có  #mi(`\lim_{x\to \pm\infty} y = \lim_{x\to \pm\infty} \frac{3x-2}{x+1} = 3`) , suy ra TCN là  #mi(`y = 3`) .\nGiao điểm  #mi(`I`)  của hai tiệm cận là  #mi(`I(-1; 3)`) .\nTổng hoành độ và tung độ của  #mi(`I`)  là  #mi(`-1 + 3 = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{x^2-4x+3}{x-2}`)  có đồ thị  #mi(`(C)`) . Tìm hệ số góc  #mi(`a`)  và tung độ gốc  #mi(`b`)  của đường tiệm cận xiên của  #mi(`(C)`) . Tính  #mi(`a+b`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nThực hiện phép chia đa thức:  #mi(`\frac{x^2-4x+3}{x-2} = x - 2 - \frac{1}{x-2}`) .\nTa có  #mi(`\lim_{x\to \pm\infty} \left[ y - (x-2) \right] = \lim_{x\to \pm\infty} \frac{-1}{x-2} = 0`) .\nSuy ra đường tiệm cận xiên là  #mi(`y = x - 2`) .\nHệ số góc  #mi(`a = 1`) , tung độ gốc  #mi(`b = -2`) .\nVậy  #mi(`a + b = 1 + (-2) = -1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`2`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`y'`)  | |  #mi(`+`)  | ||  #mi(`-`)  | |
|  #mi(`y`)  | | |  #mi(`+\infty`)  | |  #mi(`1`)  |
| |  #mi(`1`)  | | |  #mi(`-\infty`)  | |\nBiết đồ thị hàm số có hai đường tiệm cận. Gọi  #mi(`I`)  là giao điểm của hai đường tiệm cận đó. Tính  #mi(`x_I - y_I`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Từ bảng biến thiên, ta có:
 #mi(`\lim_{x\to 2^+} y = +\infty`)  và  #mi(`\lim_{x\to 2^-} y = -\infty`) , suy ra TCĐ là  #mi(`x = 2`) .
 #mi(`\lim_{x\to +\infty} y = 1`)  và  #mi(`\lim_{x\to -\infty} y = 1`) , suy ra TCN là  #mi(`y = 1`) .\nGiao điểm của hai đường tiệm cận là  #mi(`I(2; 1)`) .\nVậy  #mi(`x_I - y_I = 2 - 1 = 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tiệm cận từ công thức (Hàm phân thức bậc 1/1):] Tìm các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{2x-1}{x+3}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-3\}`) .
- Tiệm cận đứng: Ta có  #mi(`\lim_{x\to -3^+} \frac{2x-1}{x+3} = -\infty`)  và  #mi(`\lim_{x\to -3^-} \frac{2x-1}{x+3} = +\infty`) . Vậy đường thẳng  #mi(`x = -3`)  là tiệm cận đứng.
- Tiệm cận ngang: Ta có  #mi(`\lim_{x\to \pm\infty} \frac{2x-1}{x+3} = \lim_{x\to \pm\infty} \frac{2 - \frac{1}{x}}{1 + \frac{3}{x}} = 2`) . Vậy đường thẳng  #mi(`y = 2`)  là tiệm cận ngang.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tiệm cận từ công thức (Hàm phân thức bậc 2/1):] Tìm các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{x^2 - 2x + 3}{x - 1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .
- Tiệm cận đứng: Ta có  #mi(`\lim_{x\to 1^+} \frac{x^2 - 2x + 3}{x - 1} = +\infty`)  và  #mi(`\lim_{x\to 1^-} \frac{x^2 - 2x + 3}{x - 1} = -\infty`) . Vậy  #mi(`x = 1`)  là tiệm cận đứng.
- Tiệm cận xiên: Thực hiện phép chia  #mi(`x^2 - 2x + 3`)  cho  #mi(`x - 1`) , ta được  #mi(`y = x - 1 + \frac{2}{x - 1}`) .\nTa có  #mi(`\lim_{x\to \pm\infty} [y - (x - 1)] = \lim_{x\to \pm\infty} \frac{2}{x - 1} = 0`) . Vậy  #mi(`y = x - 1`)  là tiệm cận xiên.
Đồ thị hàm số không có tiệm cận ngang.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tiệm cận từ bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như hình vẽ. Hãy xác định các đường tiệm cận của đồ thị hàm số.
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`1`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`y'`)  | |  #mi(`-`)  | ||  #mi(`-`)  | |
|  #mi(`y`)  |  #mi(`2`)  | |  #mi(`+\infty`)  | |  #mi(`-1`)  |
| | | |  #mi(`-\infty`)  | | |
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta có:
-  #mi(`\lim_{x\to 1^+} f(x) = -\infty`)  và  #mi(`\lim_{x\to 1^-} f(x) = +\infty`) , suy ra đường thẳng  #mi(`x = 1`)  là tiệm cận đứng.
-  #mi(`\lim_{x\to -\infty} f(x) = 2`) , suy ra đường thẳng  #mi(`y = 2`)  là tiệm cận ngang.
-  #mi(`\lim_{x\to +\infty} f(x) = -1`) , suy ra đường thẳng  #mi(`y = -1`)  là tiệm cận ngang.\nVậy đồ thị có tiệm cận đứng  #mi(`x = 1`)  và hai tiệm cận ngang  #mi(`y = 2`) ,  #mi(`y = -1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tiệm cận từ đồ thị:] Cho hàm số  #mi(`y = f(x)`)  có đồ thị như hình vẽ. Quan sát đồ thị, hãy xác định các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị hàm số:
- Khi  #mi(`x`)  tiến dần tới  #mi(`2`)  từ bên phải, đồ thị đi xuống vô cùng tận ( #mi(`-\infty`) ); khi  #mi(`x`)  tiến dần tới  #mi(`2`)  từ bên trái, đồ thị đi lên vô cùng tận ( #mi(`+\infty`) ). Do đó, đường thẳng  #mi(`x = 2`)  là tiệm cận đứng.
- Khi  #mi(`x`)  tiến ra  #mi(`+\infty`)  hoặc  #mi(`-\infty`) , đồ thị tiến sát tới đường thẳng  #mi(`y = -1`) . Do đó, đường thẳng  #mi(`y = -1`)  là tiệm cận ngang.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{3x+2}{x-2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .
- Tiệm cận đứng:  #mi(`\lim_{x\to 2^+} \frac{3x+2}{x-2} = +\infty`)  và  #mi(`\lim_{x\to 2^-} \frac{3x+2}{x-2} = -\infty`) . Vậy  #mi(`x = 2`)  là tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x\to \pm\infty} \frac{3x+2}{x-2} = 3`) . Vậy  #mi(`y = 3`)  là tiệm cận ngang.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{4-x}{2x+1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-\frac{1}{2}\}`) .
- Tiệm cận đứng:  #mi(`\lim_{x\to -\frac{1}{2}^+} \frac{4-x}{2x+1} = +\infty`)  và  #mi(`\lim_{x\to -\frac{1}{2}^-} \frac{4-x}{2x+1} = -\infty`) . Vậy  #mi(`x = -\frac{1}{2}`)  là tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x\to \pm\infty} \frac{4-x}{2x+1} = -\frac{1}{2}`) . Vậy  #mi(`y = -\frac{1}{2}`)  là tiệm cận ngang.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm các đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{x^2 + x - 1}{x + 2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-2\}`) .
- Tiệm cận đứng:  #mi(`\lim_{x\to -2^+} \frac{x^2+x-1}{x+2} = -\infty`)  và  #mi(`\lim_{x\to -2^-} \frac{x^2+x-1}{x+2} = +\infty`) . Vậy  #mi(`x = -2`)  là tiệm cận đứng.
- Tiệm cận xiên: Chia đa thức ta được  #mi(`y = x - 1 + \frac{1}{x+2}`) . Ta có  #mi(`\lim_{x\to \pm\infty} [y - (x-1)] = 0`) . Vậy  #mi(`y = x - 1`)  là tiệm cận xiên.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`-1`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`y'`)  | |  #mi(`+`)  | ||  #mi(`+`)  | |
|  #mi(`y`)  |  #mi(`-2`)  | |  #mi(`+\infty`)  | |  #mi(`3`)  |
| | | |  #mi(`-\infty`)  | | |\nHãy xác định các đường tiệm cận của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ bảng biến thiên, ta có:
-  #mi(`\lim_{x\to -1^+} f(x) = +\infty`)  và  #mi(`\lim_{x\to -1^-} f(x) = -\infty`) , suy ra  #mi(`x = -1`)  là tiệm cận đứng.
-  #mi(`\lim_{x\to -\infty} f(x) = -2`) , suy ra  #mi(`y = -2`)  là tiệm cận ngang.
-  #mi(`\lim_{x\to +\infty} f(x) = 3`) , suy ra  #mi(`y = 3`)  là tiệm cận ngang.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho hàm số  #mi(`y = f(x)`)  có đồ thị như hình vẽ. Đồ thị nhận đường thẳng  #mi(`x = 1`)  làm tiệm cận đứng và đường thẳng  #mi(`y = 2`)  làm tiệm cận ngang. Hãy viết phương trình các đường tiệm cận đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào hình vẽ và giả thiết:
- Đồ thị có tiệm cận đứng là đường thẳng  #mi(`x = 1`) .
- Đồ thị có tiệm cận ngang là đường thẳng  #mi(`y = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{mx+1}{x-2}`)  có tiệm cận ngang là đường thẳng  #mi(`y = 3`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nTa có  #mi(`\lim_{x\to \pm\infty} \frac{mx+1}{x-2} = m`) .
Để đồ thị hàm số có tiệm cận ngang là  #mi(`y = 3`)  thì  #mi(`m = 3`) .\nVậy  #mi(`m = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Giá trị lớn nhất, nhỏ nhất của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Giá trị lớn nhất, nhỏ nhất của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Định nghĩa: Cho hàm số  #mi(`y = f(x)`)  xác định trên tập  #mi(`D`) . Số  #mi(`M`)  là GTLN của hàm số trên  #mi(`D`)  nếu  #mi(`f(x) \le M, \forall x \in D`)  và tồn tại  #mi(`x_0 \in D`)  sao cho  #mi(`f(x_0) = M`) . Ký hiệu  #mi(`M = \max_D f(x)`) . Tương tự cho GTNN  #mi(`m = \min_D f(x)`) .
  - Quy tắc tìm GTLN, GTNN trên đoạn  #mi(`[a; b]`) : 1. Tìm các điểm  #mi(`x_i \in (a; b)`)  mà tại đó  #mi(`f'(x_i) = 0`)  hoặc  #mi(`f'(x_i)`)  không xác định. 2. Tính  #mi(`f(a), f(b), f(x_i)`) . 3. So sánh các giá trị và kết luận.
  - Quy tắc tìm GTLN, GTNN trên khoảng  #mi(`(a; b)`) : Lập bảng biến thiên của hàm số trên khoảng đó, từ đó suy ra GTLN, GTNN (nếu có).
  - Từ đồ thị hàm số  #mi(`y = f(x)`)  trên đoạn  #mi(`[a; b]`) : GTLN là giá trị tung độ lớn nhất của điểm cao nhất trên đồ thị, GTNN là giá trị tung độ nhỏ nhất của điểm thấp nhất trên đồ thị trong đoạn đó.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Trên đoạn thì tính giá trị tại hai đầu mút và các điểm tới hạn rồi so sánh. Trên khoảng thì phải lập bảng biến thiên để xem đỉnh cao nhất hay đáy thấp nhất. Từ đồ thị thì nhìn trực tiếp đỉnh cao nhất và đáy thấp nhất.
  ]
  - *Công thức cốt lõi:* Trên đoạn  #mi(`[a; b]`) , nếu hàm số  #mi(`f(x)`)  liên tục và chỉ có một điểm tới hạn  #mi(`x_0 \in (a; b)`)  thì  #mi(`\max_{[a;b]} f(x) = \max \{f(a); f(b); ...\}`)  và  #mi(`\min_{[a;b]} f(x) = \min \{f(a); f(b); ...\}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm hiệu số giữa giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 - 9x + 1`)  trên đoạn  #mi(`[-2; 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 27]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = 3x^2 - 6x - 9`) . Cho  #mi(`y' = 0 \Leftrightarrow 3(x^2 - 2x - 3) = 0 \Leftrightarrow x = -1`)  hoặc  #mi(`x = 3`) . Trên  #mi(`[-2; 2]`) , ta chỉ nhận  #mi(`x = -1`) . Tính  #mi(`y(-2) = -1`) ,  #mi(`y(-1) = 6`) ,  #mi(`y(2) = -21`) . Vậy  #mi(`\max_{[-2;2]} y = 6`) ,  #mi(`\min_{[-2;2]} y = -21`) . Hiệu số là  #mi(`6 - (-21) = 27`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x + \frac{1}{x}`)  trên đoạn  #mi(`\left[\frac{1}{2}; 3\right]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = 1 - \frac{1}{x^2} = \frac{x^2 - 1}{x^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x^2 - 1 = 0 \Leftrightarrow x = 1`)  (vì  #mi(`x > 0`) ). Tính  #mi(`y\left(\frac{1}{2}\right) = \frac{1}{2} + 2 = \frac{5}{2}`) ,  #mi(`y(1) = 2`) ,  #mi(`y(3) = 3 + \frac{1}{3} = \frac{10}{3}`) . So sánh các giá trị, ta có giá trị nhỏ nhất là  #mi(`2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm giá trị lớn nhất của hàm số  #mi(`y = -x^2 + 4x + 1`)  trên khoảng  #mi(`(-\infty; 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = -2x + 4`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 2`) . Lập bảng biến thiên: hàm số đồng biến trên  #mi(`(-\infty; 2)`)  và đạt cực đại tại  #mi(`x = 2`)  với  #mi(`y(2) = 5`) . Vậy  #mi(`\max_{(-\infty; 2]} y = 5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm GTLN, GTNN trên đoạn:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-3; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = 1`)  hoặc  #mi(`x = -1`)  (cả hai đều thuộc  #mi(`[-3; 2]`) ).\nTính các giá trị:  #mi(`y(-3) = (-3)^3 - 3(-3) + 2 = -16`) ;  #mi(`y(-1) = (-1)^3 - 3(-1) + 2 = 4`) ;  #mi(`y(1) = 1^3 - 3(1) + 2 = 0`) ;  #mi(`y(2) = 2^3 - 3(2) + 2 = 4`) .\nSo sánh các giá trị trên, ta có:
 #mi(`\max_{[-3;2]} y = 4`)  tại  #mi(`x = -1`)  hoặc  #mi(`x = 2`) .
 #mi(`\min_{[-3;2]} y = -16`)  tại  #mi(`x = -3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm GTLN, GTNN trên khoảng:] Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x + \frac{4}{x}`)  trên khoảng  #mi(`(0; +\infty)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = 1 - \frac{4}{x^2} = \frac{x^2 - 4}{x^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x^2 - 4 = 0 \Leftrightarrow x = 2`)  (vì  #mi(`x > 0`) ).\nLập bảng biến thiên:
- Khi  #mi(`x \to 0^+`) ,  #mi(`y \to +\infty`) .
- Khi  #mi(`x \to +\infty`) ,  #mi(`y \to +\infty`) .
- Hàm số nghịch biến trên  #mi(`(0; 2)`)  và đồng biến trên  #mi(`(2; +\infty)`) .\nTừ bảng biến thiên, hàm số đạt giá trị nhỏ nhất tại  #mi(`x = 2`)  với  #mi(`y(2) = 2 + \frac{4}{2} = 4`) . Hàm số không có giá trị lớn nhất trên khoảng  #mi(`(0; +\infty)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm GTLN, GTNN từ đồ thị:] Cho hàm số  #mi(`y = f(x)`)  liên tục trên đoạn  #mi(`[-1; 2]`)  và có đồ thị như hình vẽ bên dưới. Gọi  #mi(`M, m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số đã cho trên đoạn  #mi(`[-1; 2]`) . Tính  #mi(`M - m`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị hàm số trên đoạn  #mi(`[-1; 2]`) :
- Điểm cao nhất của đồ thị trên đoạn này có tọa độ là  #mi(`(1; 3)`) , do đó giá trị lớn nhất  #mi(`M = 3`) .
- Điểm thấp nhất của đồ thị trên đoạn này có tọa độ là  #mi(`(2; -2)`) , do đó giá trị nhỏ nhất  #mi(`m = -2`) .\nVậy  #mi(`M - m = 3 - (-2) = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán thực tế (đánh giá):] Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của khối hộp là lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Cạnh đáy của hình hộp là  #mi(`12 - 2x\text{ (cm)}`)  (với  #mi(`0 < x < 6`) ).\nThể tích của khối hộp là  #mi(`V(x) = x(12 - 2x)^2`) .\nTa có  #mi(`V'(x) = (12 - 2x)^2 + x \cdot 2(12 - 2x)(-2) = (12 - 2x)(12 - 2x - 4x) = (12 - 2x)(12 - 6x)`) .\nCho  #mi(`V'(x) = 0 \Leftrightarrow 12 - 2x = 0`)  hoặc  #mi(`12 - 6x = 0 \Leftrightarrow x = 6`)  (loại) hoặc  #mi(`x = 2`)  (nhận).\nLập bảng biến thiên, ta thấy  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 2`) .\nVậy  #mi(`x = 2\text{ cm}`)  thì thể tích khối hộp lớn nhất.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 + 2`)  trên đoạn  #mi(`[-1; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 - 6x`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`)  (cả hai thuộc  #mi(`[-1; 2]`) ).\nTính  #mi(`y(-1) = -2`) ,  #mi(`y(0) = 2`) ,  #mi(`y(2) = -2`) .\nVậy  #mi(`\max_{[-1;2]} y = 2`)  tại  #mi(`x = 0`) ;  #mi(`\min_{[-1;2]} y = -2`)  tại  #mi(`x = -1`)  hoặc  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^4 - 2x^2 + 3`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 4x^3 - 4x`) . Cho  #mi(`y' = 0 \Leftrightarrow 4x(x^2 - 1) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 1`)  (vì  #mi(`x \in [0; 2]`) ).\nTính  #mi(`y(0) = 3`) ,  #mi(`y(1) = 2`) ,  #mi(`y(2) = 11`) .\nVậy  #mi(`\max_{[0;2]} y = 11`)  tại  #mi(`x = 2`) ;  #mi(`\min_{[0;2]} y = 2`)  tại  #mi(`x = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x + \frac{9}{x}`)  trên khoảng  #mi(`(0; +\infty)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 1 - \frac{9}{x^2} = \frac{x^2 - 9}{x^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x^2 - 9 = 0 \Leftrightarrow x = 3`)  (vì  #mi(`x > 0`) ).\nLập bảng biến thiên, hàm số nghịch biến trên  #mi(`(0; 3)`)  và đồng biến trên  #mi(`(3; +\infty)`) .\nVậy  #mi(`\min_{(0; +\infty)} y = y(3) = 3 + \frac{9}{3} = 6`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = f(x)`)  liên tục trên đoạn  #mi(`[-2; 1]`)  và có đồ thị như hình vẽ (giả sử đồ thị có đỉnh cao nhất tại  #mi(`(-1; 4)`)  và đáy thấp nhất tại  #mi(`(1; -1)`) ). Gọi  #mi(`M, m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[-2; 1]`) . Tính  #mi(`M + m`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quan sát đồ thị trên đoạn  #mi(`[-2; 1]`) :
- Điểm cao nhất có tung độ  #mi(`4`) , suy ra  #mi(`M = 4`) .
- Điểm thấp nhất có tung độ  #mi(`-1`) , suy ra  #mi(`m = -1`) .\nVậy  #mi(`M + m = 4 + (-1) = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một tấm nhôm hình vuông cạnh  #mi(`10\text{ cm}`) . Người ta cắt bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của khối hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Cạnh đáy của hình hộp là  #mi(`10 - 2x\text{ (cm)}`)  (với  #mi(`0 < x < 5`) ).\nThể tích của khối hộp là  #mi(`V(x) = x(10 - 2x)^2`) .\nTa có  #mi(`V'(x) = (10 - 2x)^2 + x \cdot 2(10 - 2x)(-2) = (10 - 2x)(10 - 6x)`) .\nCho  #mi(`V'(x) = 0 \Leftrightarrow 10 - 2x = 0`)  hoặc  #mi(`10 - 6x = 0 \Leftrightarrow x = 5`)  (loại) hoặc  #mi(`x = \frac{5}{3}`)  (nhận).\nLập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = \frac{5}{3}`) .\nVậy  #mi(`x = \frac{5}{3}\text{ cm}`)  thì thể tích khối hộp lớn nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tìm tham số m để hàm số đơn điệu trên một khoảng ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tìm tham số m để hàm số đơn điệu trên một khoảng]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) \ge 0, \forall x \in K`)  (dấu bằng xảy ra tại hữu hạn điểm).
  - Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) \le 0, \forall x \in K`)  (dấu bằng xảy ra tại hữu hạn điểm).
  - Phương pháp cô lập tham số  #mi(`m`) : Đưa bất phương trình về dạng  #mi(`m \ge g(x), \forall x \in K \Leftrightarrow m \ge \max_{K} g(x)`)  hoặc  #mi(`m \le g(x), \forall x \in K \Leftrightarrow m \le \min_{K} g(x)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Đối với hàm bậc ba, nếu hệ số  #mi(`a>0`)  và yêu cầu đồng biến trên  #mi(`\mathbb{R}`)  thì điều kiện là  #mi(`\Delta' \le 0`) . Đối với hàm phân thức, đạo hàm không bao giờ đổi dấu, nên chỉ cần xét dấu của tử số và điều kiện xác định (tiệm cận đứng không thuộc khoảng đang xét).
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) \ge 0, \forall x \in K`) , tương đương với  #mi(`m \ge \max_{K} ...`)  hoặc  #mi(`m \le \min_{K} ...`)  (tùy vào chiều của bất phương trình sau khi cô lập  #mi(`m`) ).
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3mx^2 + 3(2m-1)x + 1`)  nghịch biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6mx + 3(2m-1)`) . Hàm số nghịch biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \le 0, \forall x \in \mathbb{R}`) . Vì hệ số  #mi(`a=3>0`)  nên điều kiện tương đương là  #mi(`\Delta' \le 0`) . Ta có  #mi(`\Delta' = (-3m)^2 - 3 \cdot 3(2m-1) = 9m^2 - 18m + 9 = 9(m-1)^2`) . Yêu cầu  #mi(`9(m-1)^2 \le 0 \Leftrightarrow m=1`) . Vậy  #mi(`m=1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị nguyên nhỏ nhất của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx+1}{x+m}`)  đồng biến trên khoảng  #mi(`(1; +\infty)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{-m\}`) . Đạo hàm  #mi(`y' = \frac{m^2 - 1}{(x+m)^2}`) . Hàm số đồng biến trên  #mi(`(1; +\infty)`)  khi và chỉ khi  #mi(`y' > 0, \forall x \in (1; +\infty)`)  và  #mi(`-m \notin (1; +\infty)`) . Điều kiện tương đương:  #mi(`m^2 - 1 > 0`)  và  #mi(`-m \le 1`) . Suy ra  #mi(`m > 1`)  hoặc  #mi(`m < -1`) , và  #mi(`m \ge -1`) . Kết hợp lại ta được  #mi(`m > 1`) . Giá trị nguyên nhỏ nhất của  #mi(`m`)  là  #mi(`2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm giá trị nhỏ nhất của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + m`)  đồng biến trên đoạn  #mi(`[1; 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`[1; 2]`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in [1; 2]`) . Ta có  #mi(`3x^2 - 6x + m \ge 0 \Leftrightarrow m \ge -3x^2 + 6x, \forall x \in [1; 2]`) . Xét hàm số  #mi(`g(x) = -3x^2 + 6x`)  trên  #mi(`[1; 2]`) . Ta có  #mi(`g'(x) = -6x + 6 = 0 \Leftrightarrow x=1`) . Tính  #mi(`g(1) = 3`) ,  #mi(`g(2) = 0`) . Suy ra  #mi(`\max_{[1;2]} g(x) = 3`) . Vậy  #mi(`m \ge 3`) . Giá trị nhỏ nhất của  #mi(`m`)  là  #mi(`3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản (Hàm bậc ba đồng biến trên R):] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in \mathbb{R}`) . Vì hệ số  #mi(`a=3>0`)  nên điều kiện tương đương là  #mi(`\Delta' \le 0`) . Ta có  #mi(`\Delta' = (-3)^2 - 3 \cdot m = 9 - 3m`) . Yêu cầu  #mi(`9 - 3m \le 0 \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Cô lập tham số (Hàm bậc ba đồng biến trên khoảng):] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  đồng biến trên khoảng  #mi(`(0; +\infty)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`(0; +\infty)`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in (0; +\infty)`) . Ta có  #mi(`3x^2 - 6x + m \ge 0 \Leftrightarrow m \ge -3x^2 + 6x, \forall x \in (0; +\infty)`) . Xét hàm số  #mi(`g(x) = -3x^2 + 6x`)  trên  #mi(`(0; +\infty)`) . Ta có  #mi(`g'(x) = -6x + 6 = 0 \Leftrightarrow x=1`) . Bảng biến thiên của  #mi(`g(x)`)  cho thấy  #mi(`\max_{(0; +\infty)} g(x) = g(1) = 3`) . Do đó, yêu cầu bài toán tương đương với  #mi(`m \ge 3`) . Vậy  #mi(`m \ge 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm phân thức đồng biến trên khoảng:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx+4}{x+m}`)  đồng biến trên khoảng  #mi(`(-\infty; 1)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{-m\}`) . Đạo hàm  #mi(`y' = \frac{m^2 - 4}{(x+m)^2}`) . Hàm số đồng biến trên  #mi(`(-\infty; 1)`)  khi và chỉ khi  #mi(`y' > 0, \forall x \in (-\infty; 1)`)  và  #mi(`-m \notin (-\infty; 1)`) . Điều kiện tương đương:  #mi(`m^2 - 4 > 0`)  và  #mi(`-m \ge 1`) . Ta có  #mi(`m^2 - 4 > 0 \Leftrightarrow m > 2`)  hoặc  #mi(`m < -2`) . Và  #mi(`-m \ge 1 \Leftrightarrow m \le -1`) . Kết hợp lại, ta được  #mi(`m < -2`) . Vậy  #mi(`m < -2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hàm phân thức nghịch biến trên khoảng:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{x+1}{x-m}`)  nghịch biến trên khoảng  #mi(`(2; +\infty)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{m\}`) . Đạo hàm  #mi(`y' = \frac{-m-1}{(x-m)^2}`) . Hàm số nghịch biến trên  #mi(`(2; +\infty)`)  khi và chỉ khi  #mi(`y' < 0, \forall x \in (2; +\infty)`)  và  #mi(`m \notin (2; +\infty)`) . Điều kiện tương đương:  #mi(`-m - 1 < 0`)  và  #mi(`m \le 2`) . Ta có  #mi(`-m - 1 < 0 \Leftrightarrow m > -1`) . Kết hợp với  #mi(`m \le 2`) , ta được  #mi(`-1 < m \le 2`) . Vậy  #mi(`-1 < m \le 2`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx - 2`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in \mathbb{R}`) . Vì hệ số  #mi(`a=3>0`)  nên điều kiện tương đương là  #mi(`\Delta' \le 0`) . Ta có  #mi(`\Delta' = (-3)^2 - 3 \cdot m = 9 - 3m`) . Yêu cầu  #mi(`9 - 3m \le 0 \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 + 3x^2 + mx + 1`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 + 6x + m`) . Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in \mathbb{R}`) . Vì hệ số  #mi(`a=3>0`)  nên điều kiện tương đương là  #mi(`\Delta' \le 0`) . Ta có  #mi(`\Delta' = 3^2 - 3 \cdot m = 9 - 3m`) . Yêu cầu  #mi(`9 - 3m \le 0 \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx+2}{x+m}`)  nghịch biến trên khoảng  #mi(`(-\infty; -2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{-m\}`) . Đạo hàm  #mi(`y' = \frac{m^2 - 2}{(x+m)^2}`) . Hàm số nghịch biến trên  #mi(`(-\infty; -2)`)  khi và chỉ khi  #mi(`y' < 0, \forall x \in (-\infty; -2)`)  và  #mi(`-m \notin (-\infty; -2)`) . Điều kiện tương đương:  #mi(`m^2 - 2 < 0`)  và  #mi(`-m \ge -2`) . Ta có  #mi(`m^2 - 2 < 0 \Leftrightarrow -\sqrt{2} < m < \sqrt{2}`) . Và  #mi(`-m \ge -2 \Leftrightarrow m \le 2`) . Kết hợp lại, ta được  #mi(`-\sqrt{2} < m < \sqrt{2}`) . Vậy  #mi(`-\sqrt{2} < m < \sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{x-2}{x-m}`)  đồng biến trên khoảng  #mi(`(1; +\infty)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{m\}`) . Đạo hàm  #mi(`y' = \frac{-m+2}{(x-m)^2}`) . Hàm số đồng biến trên  #mi(`(1; +\infty)`)  khi và chỉ khi  #mi(`y' > 0, \forall x \in (1; +\infty)`)  và  #mi(`m \notin (1; +\infty)`) . Điều kiện tương đương:  #mi(`-m + 2 > 0`)  và  #mi(`m \le 1`) . Ta có  #mi(`-m + 2 > 0 \Leftrightarrow m < 2`) . Kết hợp với  #mi(`m \le 1`) , ta được  #mi(`m \le 1`) . Vậy  #mi(`m \le 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2-1)x + 1`)  nghịch biến trên khoảng  #mi(`(0; 2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6mx + 3(m^2-1)`) . Hàm số nghịch biến trên  #mi(`(0; 2)`)  khi và chỉ khi  #mi(`y' \le 0, \forall x \in (0; 2)`) . Ta có  #mi(`y' \le 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 \le 0 \Leftrightarrow (x-m)^2 \le 1 \Leftrightarrow m-1 \le x \le m+1`) . Để bất phương trình đúng với mọi  #mi(`x \in (0; 2)`) , ta cần  #mi(`(0; 2) \subset [m-1; m+1]`) . Điều này tương đương với  #mi(`m-1 \le 0`)  và  #mi(`m+1 \ge 2`) . Suy ra  #mi(`m \le 1`)  và  #mi(`m \ge 1`) . Vậy  #mi(`m=1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx+1}{x+m}`)  nghịch biến trên khoảng  #mi(`(2; +\infty)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{-m\}`) . Đạo hàm  #mi(`y' = \frac{m^2 - 1}{(x+m)^2}`) . Hàm số nghịch biến trên  #mi(`(2; +\infty)`)  khi và chỉ khi  #mi(`y' < 0, \forall x \in (2; +\infty)`)  và  #mi(`-m \notin (2; +\infty)`) . Điều kiện tương đương:  #mi(`m^2 - 1 < 0`)  và  #mi(`-m \le 2`) . Ta có  #mi(`m^2 - 1 < 0 \Leftrightarrow -1 < m < 1`) . Và  #mi(`-m \le 2 \Leftrightarrow m \ge -2`) . Kết hợp lại, ta được  #mi(`-1 < m < 1`) . Vậy  #mi(`-1 < m < 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Tìm tham số m để hàm số có cực trị thỏa mãn điều kiện cho trước ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Tìm tham số m để hàm số có cực trị thỏa mãn điều kiện cho trước]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`) . Hàm số có 2 điểm cực trị khi và chỉ khi phương trình  #mi(`y' = 3ax^2 + 2bx + c = 0`)  có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  (tức là  #mi(`\Delta' > 0`) ).
  - Khi đó, theo định lý Vi-ét ta có:  #mi(`x_1 + x_2 = -\frac{2b}{3a}`)  và  #mi(`x_1x_2 = \frac{c}{3a}`) .
  - Các biểu thức đối xứng thường gặp:  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2`) ;  #mi(`|x_1 - x_2| = \sqrt{(x_1+x_2)^2 - 4x_1x_2}`) ;  #mi(`x_1^3 + x_2^3 = (x_1+x_2)^3 - 3x_1x_2(x_1+x_2)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Có cực trị  #mi(`\Leftrightarrow \Delta' > 0`) . Điều kiện đối xứng  #mi(`\rightarrow`)  Nghĩ ngay tới Vi-ét: Tổng  #mi(`S`) , Tích  #mi(`P`) .
  ]
  - *Công thức cốt lõi:* Để hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có hai điểm cực trị  #mi(`x_1, x_2`)  thì điều kiện là  #mi(`\Delta' = b^2 - 3ac > ...`)  và khi đó  #mi(`x_1 + x_2 = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x^2 + m`) . Tìm  #mi(`m`)  để khoảng cách giữa hai điểm cực trị của đồ thị hàm số bằng  #mi(`2\sqrt{5}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{5}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) .  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Hàm số luôn có hai điểm cực trị với mọi  #mi(`m`) . Tọa độ hai điểm cực trị là  #mi(`A(0; m)`)  và  #mi(`B(2; m - 4)`) . Khoảng cách  #mi(`AB = \sqrt{(2 - 0)^2 + (m - 4 - m)^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) . Vậy khoảng cách không phụ thuộc vào  #mi(`m`)  và luôn bằng  #mi(`2\sqrt{5}`) . Do đó không có giá trị  #mi(`m`)  nào cần tìm (hoặc  #mi(`m \in \mathbb{R}`) ).]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x`) . Tìm số giá trị nguyên dương của  #mi(`m`)  để đồ thị hàm số có hai điểm cực trị nằm về hai phía của trục hoành.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) .  #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0 \Leftrightarrow (x - m)^2 = 1 \Leftrightarrow x = m - 1`)  hoặc  #mi(`x = m + 1`) . Hàm số luôn có hai điểm cực trị  #mi(`x_1 = m - 1`)  và  #mi(`x_2 = m + 1`) . Giá trị cực trị:  #mi(`y_1 = y(m-1) = (m-1)^2(m+2)`) ;  #mi(`y_2 = y(m+1) = (m+1)^2(m-2)`) . Để hai điểm cực trị nằm về hai phía trục hoành thì  #mi(`y_1 \cdot y_2 < 0 \Leftrightarrow (m-1)^2(m+2)(m+1)^2(m-2) < 0 \Leftrightarrow (m+2)(m-2) < 0 \Leftrightarrow -2 < m < 2`) . Vì  #mi(`m`)  nguyên dương nên  #mi(`m = 1`) . Có 1 giá trị thỏa mãn.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^3 + x_2^3 = 8`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì  #mi(`\Delta' = 9 - 3m > 0 \Leftrightarrow m < 3`) . Khi đó, theo Vi-ét:  #mi(`x_1 + x_2 = 2`) ,  #mi(`x_1x_2 = \frac{m}{3}`) . Ta có  #mi(`x_1^3 + x_2^3 = (x_1+x_2)^3 - 3x_1x_2(x_1+x_2) = 8 - 3 \cdot \frac{m}{3} \cdot 2 = 8 - 2m`) . Theo yêu cầu bài toán:  #mi(`8 - 2m = 8 \Leftrightarrow m = 0`) . Kết hợp điều kiện  #mi(`m < 3`) , ta được  #mi(`m = 0`)  thỏa mãn.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm m để hàm số có cực trị thỏa mãn điều kiện về tổng bình phương:] Cho hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 4`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì phương trình  #mi(`y' = 0`)  có hai nghiệm phân biệt  #mi(`\Leftrightarrow \Delta' = 9 - 3m > 0 \Leftrightarrow m < 3`) . Khi đó, theo định lý Vi-ét ta có:  #mi(`x_1 + x_2 = 2`)  và  #mi(`x_1x_2 = \frac{m}{3}`) . Ta có  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2 = 2^2 - 2\frac{m}{3} = 4 - \frac{2m}{3}`) . Theo đề bài:  #mi(`4 - \frac{2m}{3} = 4 \Leftrightarrow m = 0`) . Kết hợp với điều kiện  #mi(`m < 3`) , ta được  #mi(`m = 0`)  thỏa mãn.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm m để hàm số có cực trị thỏa mãn điều kiện về khoảng cách:] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`|x_1 - x_2| = 2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) . Phương trình  #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0`) . Ta có  #mi(`\Delta' = m^2 - (m^2 - 1) = 1 > 0`)  với mọi  #mi(`m`) . Do đó hàm số luôn có hai điểm cực trị  #mi(`x_1, x_2`)  với mọi  #mi(`m`) . Theo Vi-ét:  #mi(`x_1 + x_2 = 2m`) ,  #mi(`x_1x_2 = m^2 - 1`) . Ta có  #mi(`|x_1 - x_2| = \sqrt{(x_1+x_2)^2 - 4x_1x_2} = \sqrt{4m^2 - 4(m^2 - 1)} = \sqrt{4} = 2`) . Vậy  #mi(`|x_1 - x_2| = 2`)  luôn đúng với mọi  #mi(`m`) . Kết luận:  #mi(`m \in \mathbb{R}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm m để hàm số có cực trị thỏa mãn điều kiện phức hợp:] Cho hàm số  #mi(`y = \frac{1}{3}x^3 - mx^2 + (m^2 - m + 1)x + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 10`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = x^2 - 2mx + m^2 - m + 1`) . Để hàm số có hai điểm cực trị thì  #mi(`\Delta' = m^2 - (m^2 - m + 1) = m - 1 > 0 \Leftrightarrow m > 1`) . Theo Vi-ét:  #mi(`x_1 + x_2 = 2m`) ,  #mi(`x_1x_2 = m^2 - m + 1`) . Ta có  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2 = 4m^2 - 2(m^2 - m + 1) = 2m^2 + 2m - 2`) . Theo đề bài:  #mi(`2m^2 + 2m - 2 = 10 \Leftrightarrow 2m^2 + 2m - 12 = 0 \Leftrightarrow m^2 + m - 6 = 0 \Leftrightarrow m = 2`)  hoặc  #mi(`m = -3`) . Kết hợp điều kiện  #mi(`m > 1`) , ta được  #mi(`m = 2`)  thỏa mãn.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể: Tìm m để hàm số có cực trị thỏa mãn điều kiện về tích:] Cho hàm số  #mi(`y = x^3 - 3x^2 + mx`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 2x_1x_2 + 4`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì  #mi(`\Delta' = 9 - 3m > 0 \Leftrightarrow m < 3`) . Theo Vi-ét:  #mi(`x_1 + x_2 = 2`) ,  #mi(`x_1x_2 = \frac{m}{3}`) . Ta có  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2 = 4 - \frac{2m}{3}`) . Theo đề bài:  #mi(`4 - \frac{2m}{3} = 2\frac{m}{3} + 4 \Leftrightarrow \frac{4m}{3} = 0 \Leftrightarrow m = 0`) . Kết hợp điều kiện  #mi(`m < 3`) , ta được  #mi(`m = 0`)  thỏa mãn.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + mx + 2`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 6`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì  #mi(`\Delta' = 9 - 3m > 0 \Leftrightarrow m < 3`) . Theo Vi-ét:  #mi(`x_1 + x_2 = 2`) ,  #mi(`x_1x_2 = \frac{m}{3}`) . Ta có  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2 = 4 - \frac{2m}{3}`) . Theo đề bài:  #mi(`4 - \frac{2m}{3} = 6 \Leftrightarrow \frac{2m}{3} = -2 \Leftrightarrow m = -3`) . Kết hợp điều kiện  #mi(`m < 3`) , ta được  #mi(`m = -3`)  thỏa mãn.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì  #mi(`\Delta' = 9 - 3m > 0 \Leftrightarrow m < 3`) . Theo Vi-ét:  #mi(`x_1 + x_2 = 2`) ,  #mi(`x_1x_2 = \frac{m}{3}`) . Ta có  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2 = 4 - \frac{2m}{3}`) . Theo đề bài:  #mi(`4 - \frac{2m}{3} = 2 \Leftrightarrow \frac{2m}{3} = 2 \Leftrightarrow m = 3`) . Kết hợp điều kiện  #mi(`m < 3`) , ta thấy  #mi(`m = 3`)  không thỏa mãn. Vậy không có giá trị  #mi(`m`)  nào.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x + 2`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`|x_1 - x_2| = 4`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) . Phương trình  #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0`) .  #mi(`\Delta' = m^2 - (m^2 - 1) = 1 > 0`)  với mọi  #mi(`m`) . Hàm số luôn có hai điểm cực trị. Theo Vi-ét:  #mi(`x_1 + x_2 = 2m`) ,  #mi(`x_1x_2 = m^2 - 1`) . Ta có  #mi(`|x_1 - x_2| = \sqrt{(x_1+x_2)^2 - 4x_1x_2} = \sqrt{4m^2 - 4(m^2 - 1)} = 2`) . Theo đề bài:  #mi(`|x_1 - x_2| = 4 \Leftrightarrow 2 = 4`)  (vô lý). Vậy không có giá trị  #mi(`m`)  nào thỏa mãn.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + mx`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 3x_1x_2 + 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì  #mi(`\Delta' = 9 - 3m > 0 \Leftrightarrow m < 3`) . Theo Vi-ét:  #mi(`x_1 + x_2 = 2`) ,  #mi(`x_1x_2 = \frac{m}{3}`) . Ta có  #mi(`x_1^2 + x_2^2 = (x_1+x_2)^2 - 2x_1x_2 = 4 - \frac{2m}{3}`) . Theo đề bài:  #mi(`4 - \frac{2m}{3} = 3\frac{m}{3} + 2 \Leftrightarrow 2 = \frac{5m}{3} \Leftrightarrow m = \frac{6}{5}`) . Kết hợp điều kiện  #mi(`m < 3`) , ta được  #mi(`m = \frac{6}{5}`)  thỏa mãn.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^3 + x_2^3 = 8`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) . Phương trình  #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0`) .  #mi(`\Delta' = 1 > 0`)  với mọi  #mi(`m`) . Hàm số luôn có hai điểm cực trị. Theo Vi-ét:  #mi(`x_1 + x_2 = 2m`) ,  #mi(`x_1x_2 = m^2 - 1`) . Ta có  #mi(`x_1^3 + x_2^3 = (x_1+x_2)^3 - 3x_1x_2(x_1+x_2) = 8m^3 - 3(m^2 - 1)2m = 8m^3 - 6m^3 + 6m = 2m^3 + 6m`) . Theo đề bài:  #mi(`2m^3 + 6m = 8 \Leftrightarrow m^3 + 3m - 4 = 0 \Leftrightarrow (m-1)(m^2 + m + 4) = 0 \Leftrightarrow m = 1`)  (vì  #mi(`m^2 + m + 4 > 0`) ). Vậy  #mi(`m = 1`)  thỏa mãn.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Tìm tham số m để phương trình, bất phương trình có nghiệm ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Tìm tham số m để phương trình, bất phương trình có nghiệm]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Phương pháp cô lập tham số  #mi(`m`) : Biến đổi phương trình, bất phương trình về dạng  #mi(`f(x) = g(m)`)  hoặc  #mi(`f(x) \ge g(m)`)  (hoặc  #mi(`f(x) \le g(m)`) ) với  #mi(`x \in D`) .
  - Lập bảng biến thiên của hàm số  #mi(`f(x)`)  trên tập xác định  #mi(`D`)  để tìm giá trị lớn nhất (GTLN) và giá trị nhỏ nhất (GTNN) của  #mi(`f(x)`) .
  - Điều kiện có nghiệm: Phương trình  #mi(`f(x) = g(m)`)  có nghiệm  #mi(`x \in D`)  khi và chỉ khi  #mi(`\min_D f(x) \le g(m) \le \max_D f(x)`) .
  - Điều kiện nghiệm đúng với mọi  #mi(`x`) : Bất phương trình  #mi(`f(x) \ge g(m)`)  nghiệm đúng  #mi(`\forall x \in D`)  khi và chỉ khi  #mi(`\min_D f(x) \ge g(m)`) . Tương tự,  #mi(`f(x) \le g(m)`)  nghiệm đúng  #mi(`\forall x \in D`)  khi và chỉ khi  #mi(`\max_D f(x) \le g(m)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cô lập m - Vẽ đồ thị (hoặc bảng biến thiên) - Kẹp giá trị: Có nghiệm thì kẹp giữa Min và Max, Nghiệm đúng mọi x thì so với Min hoặc Max tùy chiều bất phương trình.
  ]
  - *Công thức cốt lõi:* Phương trình  #mi(`f(x) = m`)  có nghiệm trên tập  #mi(`D`)  khi và chỉ khi  #mi(`... \le m \le \max_D f(x)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Có bao nhiêu giá trị nguyên của tham số  #mi(`m`)  để phương trình  #mi(`x^3 - 3x^2 + 2 = m`)  có 3 nghiệm phân biệt?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Xét hàm số  #mi(`f(x) = x^3 - 3x^2 + 2`)  trên  #mi(`\mathbb{R}`) . Ta có  #mi(`f'(x) = 3x^2 - 6x = 3x(x - 2)`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Ta có  #mi(`f(0) = 2`)  và  #mi(`f(2) = -2`) . Bảng biến thiên cho thấy hàm số đạt cực đại tại  #mi(`x=0`)  với  #mi(`y_{CĐ} = 2`)  và đạt cực tiểu tại  #mi(`x=2`)  với  #mi(`y_{CT} = -2`) . Để phương trình  #mi(`f(x) = m`)  có 3 nghiệm phân biệt thì đường thẳng  #mi(`y=m`)  phải cắt đồ thị tại 3 điểm, tức là  #mi(`-2 < m < 2`) . Vì  #mi(`m \in \mathbb{Z}`)  nên  #mi(`m \in \{-1; 0; 1\}`) . Có 3 giá trị nguyên của  #mi(`m`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Có bao nhiêu giá trị nguyên dương của tham số  #mi(`m`)  để bất phương trình  #mi(`x^4 - 4x^2 + 5 \ge m`)  nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`) ?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Bất phương trình nghiệm đúng  #mi(`\forall x \in \mathbb{R} \Leftrightarrow \min_{\mathbb{R}} f(x) \ge m`)  với  #mi(`f(x) = x^4 - 4x^2 + 5`) . Ta có  #mi(`f'(x) = 4x^3 - 8x = 4x(x^2 - 2)`) .  #mi(`f'(x) = 0 \Leftrightarrow x = 0, x = \pm\sqrt{2}`) . Tính  #mi(`f(0) = 5`) ,  #mi(`f(\pm\sqrt{2}) = 1`) . Bảng biến thiên cho thấy  #mi(`\min_{\mathbb{R}} f(x) = 1`) . Do đó  #mi(`m \le 1`) . Vì  #mi(`m`)  là số nguyên dương nên  #mi(`m = 1`) . Có 1 giá trị.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Có bao nhiêu giá trị nguyên của tham số  #mi(`m`)  để phương trình  #mi(`x + \sqrt{4-x^2} = m`)  có nghiệm?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Điều kiện:  #mi(`-2 \le x \le 2`) . Xét  #mi(`f(x) = x + \sqrt{4-x^2}`)  trên  #mi(`[-2; 2]`) .  #mi(`f'(x) = 1 - \frac{x}{\sqrt{4-x^2}} = \frac{\sqrt{4-x^2} - x}{\sqrt{4-x^2}}`) .  #mi(`f'(x) = 0 \Leftrightarrow \sqrt{4-x^2} = x \Leftrightarrow x = \sqrt{2}`) . Ta có  #mi(`f(-2) = -2`) ,  #mi(`f(2) = 2`) ,  #mi(`f(\sqrt{2}) = 2\sqrt{2}`) . Suy ra  #mi(`\min f(x) = -2`)  và  #mi(`\max f(x) = 2\sqrt{2}`) . Để phương trình có nghiệm thì  #mi(`-2 \le m \le 2\sqrt{2} \approx 2.828`) . Vì  #mi(`m \in \mathbb{Z}`)  nên  #mi(`m \in \{-2; -1; 0; 1; 2\}`) . Có 5 giá trị nguyên.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm m để phương trình có n nghiệm (Sử dụng đồ thị/bảng biến thiên):] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`x^3 - 3x = m`)  có 3 nghiệm phân biệt.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét hàm số  #mi(`f(x) = x^3 - 3x`)  trên  #mi(`\mathbb{R}`) . Đạo hàm  #mi(`f'(x) = 3x^2 - 3 = 3(x^2 - 1)`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x = \pm 1`) . Ta có  #mi(`f(-1) = 2`)  và  #mi(`f(1) = -2`) . Bảng biến thiên: Hàm số đạt cực đại tại  #mi(`x = -1`)  với  #mi(`y_{CĐ} = 2`) , đạt cực tiểu tại  #mi(`x = 1`)  với  #mi(`y_{CT} = -2`) . Số nghiệm của phương trình  #mi(`f(x) = m`)  chính là số giao điểm của đồ thị hàm số  #mi(`y = f(x)`)  và đường thẳng  #mi(`y = m`) . Để phương trình có 3 nghiệm phân biệt, đường thẳng  #mi(`y = m`)  phải cắt đồ thị tại 3 điểm phân biệt. Dựa vào bảng biến thiên, điều kiện là  #mi(`-2 < m < 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm m để phương trình có nghiệm (Cô lập m và khảo sát hàm số):] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`x + \sqrt{x^2 + 1} = m`)  có nghiệm.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét hàm số  #mi(`f(x) = x + \sqrt{x^2 + 1}`)  trên  #mi(`\mathbb{R}`) . Đạo hàm  #mi(`f'(x) = 1 + \frac{x}{\sqrt{x^2 + 1}} = \frac{\sqrt{x^2 + 1} + x}{\sqrt{x^2 + 1}}`) . Vì  #mi(`\sqrt{x^2 + 1} > \sqrt{x^2} = |x| \ge -x`)  nên  #mi(`\sqrt{x^2 + 1} + x > 0`)  với mọi  #mi(`x`) . Do đó  #mi(`f'(x) > 0, \forall x \in \mathbb{R}`) , hàm số đồng biến trên  #mi(`\mathbb{R}`) . Ta có  #mi(`\lim_{x \to -\infty} f(x) = \lim_{x \to -\infty} \frac{-1}{x - \sqrt{x^2 + 1}} = 0`)  và  #mi(`\lim_{x \to +\infty} f(x) = +\infty`) . Bảng biến thiên cho thấy tập giá trị của hàm số là  #mi(`(0; +\infty)`) . Phương trình  #mi(`f(x) = m`)  có nghiệm khi và chỉ khi  #mi(`m`)  thuộc tập giá trị của hàm số, tức là  #mi(`m > 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm m để bất phương trình nghiệm đúng với mọi x:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để bất phương trình  #mi(`x^4 - 2x^2 + 3 \ge m`)  nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bất phương trình nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`)  khi và chỉ khi  #mi(`\min_{\mathbb{R}} f(x) \ge m`)  với  #mi(`f(x) = x^4 - 2x^2 + 3`) . Xét hàm số  #mi(`f(x) = x^4 - 2x^2 + 3`)  trên  #mi(`\mathbb{R}`) . Đạo hàm  #mi(`f'(x) = 4x^3 - 4x = 4x(x^2 - 1)`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = \pm 1`) . Ta có  #mi(`f(0) = 3`)  và  #mi(`f(\pm 1) = 2`) . Bảng biến thiên cho thấy hàm số đạt cực tiểu tại  #mi(`x = \pm 1`)  với  #mi(`y_{CT} = 2`)  và  #mi(`\lim_{x \to \pm\infty} f(x) = +\infty`) . Do đó  #mi(`\min_{\mathbb{R}} f(x) = 2`) . Vậy điều kiện để bất phương trình nghiệm đúng với mọi  #mi(`x`)  là  #mi(`m \le 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm m để phương trình có nghiệm trên đoạn [a; b]:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`\sqrt{x+3} + \sqrt{6-x} = m`)  có nghiệm.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điều kiện xác định:  #mi(`x+3 \ge 0`)  và  #mi(`6-x \ge 0 \Leftrightarrow -3 \le x \le 6`) . Xét hàm số  #mi(`f(x) = \sqrt{x+3} + \sqrt{6-x}`)  trên đoạn  #mi(`[-3; 6]`) . Đạo hàm  #mi(`f'(x) = \frac{1}{2\sqrt{x+3}} - \frac{1}{2\sqrt{6-x}} = \frac{\sqrt{6-x} - \sqrt{x+3}}{2\sqrt{x+3}\sqrt{6-x}}`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow \sqrt{6-x} = \sqrt{x+3} \Leftrightarrow 6-x = x+3 \Leftrightarrow 2x = 3 \Leftrightarrow x = \frac{3}{2}`) . Ta có  #mi(`f(-3) = 3`) ,  #mi(`f(6) = 3`) ,  #mi(`f\left(\frac{3}{2}\right) = \sqrt{\frac{9}{2}} + \sqrt{\frac{9}{2}} = 3\sqrt{2}`) . Bảng biến thiên trên  #mi(`[-3; 6]`)  cho thấy  #mi(`\min f(x) = 3`)  và  #mi(`\max f(x) = 3\sqrt{2}`) . Phương trình  #mi(`f(x) = m`)  có nghiệm khi và chỉ khi  #mi(`\min f(x) \le m \le \max f(x)`) , tức là  #mi(`3 \le m \le 3\sqrt{2}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`x^3 - 3x = m`)  có 3 nghiệm phân biệt.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hàm số  #mi(`f(x) = x^3 - 3x`)  trên  #mi(`\mathbb{R}`) .  #mi(`f'(x) = 3x^2 - 3 = 3(x^2 - 1)`) .  #mi(`f'(x) = 0 \Leftrightarrow x = \pm 1`) . Ta có  #mi(`f(-1) = 2`) ,  #mi(`f(1) = -2`) . Bảng biến thiên cho thấy hàm số đạt cực đại tại  #mi(`x=-1`)  với  #mi(`y_{CĐ}=2`)  và cực tiểu tại  #mi(`x=1`)  với  #mi(`y_{CT}=-2`) . Để phương trình  #mi(`f(x) = m`)  có 3 nghiệm phân biệt, đường thẳng  #mi(`y=m`)  phải cắt đồ thị tại 3 điểm. Dựa vào bảng biến thiên, điều kiện là  #mi(`-2 < m < 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`x^3 - 3x^2 = m`)  có 3 nghiệm phân biệt.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hàm số  #mi(`f(x) = x^3 - 3x^2`)  trên  #mi(`\mathbb{R}`) .  #mi(`f'(x) = 3x^2 - 6x = 3x(x - 2)`) .  #mi(`f'(x) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Ta có  #mi(`f(0) = 0`) ,  #mi(`f(2) = -4`) . Bảng biến thiên cho thấy hàm số đạt cực đại tại  #mi(`x=0`)  với  #mi(`y_{CĐ}=0`)  và cực tiểu tại  #mi(`x=2`)  với  #mi(`y_{CT}=-4`) . Để phương trình  #mi(`f(x) = m`)  có 3 nghiệm phân biệt, đường thẳng  #mi(`y=m`)  phải cắt đồ thị tại 3 điểm. Dựa vào bảng biến thiên, điều kiện là  #mi(`-4 < m < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để bất phương trình  #mi(`x^4 - 2x^2 + 1 \ge m`)  nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bất phương trình nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`)  khi và chỉ khi  #mi(`\min_{\mathbb{R}} f(x) \ge m`)  với  #mi(`f(x) = x^4 - 2x^2 + 1`) . Xét hàm số  #mi(`f(x) = x^4 - 2x^2 + 1`)  trên  #mi(`\mathbb{R}`) .  #mi(`f'(x) = 4x^3 - 4x = 4x(x^2 - 1)`) .  #mi(`f'(x) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = \pm 1`) . Ta có  #mi(`f(0) = 1`) ,  #mi(`f(\pm 1) = 0`) . Bảng biến thiên cho thấy hàm số đạt cực tiểu tại  #mi(`x = \pm 1`)  với  #mi(`y_{CT} = 0`)  và  #mi(`\lim_{x \to \pm\infty} f(x) = +\infty`) . Do đó  #mi(`\min_{\mathbb{R}} f(x) = 0`) . Vậy điều kiện để bất phương trình nghiệm đúng với mọi  #mi(`x`)  là  #mi(`m \le 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`\sqrt{x+2} + \sqrt{4-x} = m`)  có nghiệm.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện xác định:  #mi(`-2 \le x \le 4`) . Xét hàm số  #mi(`f(x) = \sqrt{x+2} + \sqrt{4-x}`)  trên đoạn  #mi(`[-2; 4]`) .  #mi(`f'(x) = \frac{1}{2\sqrt{x+2}} - \frac{1}{2\sqrt{4-x}} = \frac{\sqrt{4-x} - \sqrt{x+2}}{2\sqrt{x+2}\sqrt{4-x}}`) .  #mi(`f'(x) = 0 \Leftrightarrow \sqrt{4-x} = \sqrt{x+2} \Leftrightarrow 4-x = x+2 \Leftrightarrow x = 1`) . Ta có  #mi(`f(-2) = \sqrt{6}`) ,  #mi(`f(4) = \sqrt{6}`) ,  #mi(`f(1) = 2\sqrt{3}`) . Bảng biến thiên trên  #mi(`[-2; 4]`)  cho thấy  #mi(`\min f(x) = \sqrt{6}`)  và  #mi(`\max f(x) = 2\sqrt{3}`) . Phương trình  #mi(`f(x) = m`)  có nghiệm khi và chỉ khi  #mi(`\min f(x) \le m \le \max f(x)`) , tức là  #mi(`\sqrt{6} \le m \le 2\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`x + \sqrt{x^2 + 1} = m`)  có nghiệm.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hàm số  #mi(`f(x) = x + \sqrt{x^2 + 1}`)  trên  #mi(`\mathbb{R}`) .  #mi(`f'(x) = 1 + \frac{x}{\sqrt{x^2 + 1}} = \frac{\sqrt{x^2 + 1} + x}{\sqrt{x^2 + 1}}`) . Vì  #mi(`\sqrt{x^2 + 1} > |x| \ge -x`)  nên  #mi(`\sqrt{x^2 + 1} + x > 0, \forall x`) . Do đó  #mi(`f'(x) > 0, \forall x \in \mathbb{R}`) , hàm số đồng biến trên  #mi(`\mathbb{R}`) . Ta có  #mi(`\lim_{x \to -\infty} f(x) = 0`)  và  #mi(`\lim_{x \to +\infty} f(x) = +\infty`) . Tập giá trị của hàm số là  #mi(`(0; +\infty)`) . Phương trình  #mi(`f(x) = m`)  có nghiệm khi và chỉ khi  #mi(`m > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để bất phương trình  #mi(`x^2 - 4x + 5 \ge m`)  nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bất phương trình nghiệm đúng với mọi  #mi(`x \in \mathbb{R}`)  khi và chỉ khi  #mi(`\min_{\mathbb{R}} f(x) \ge m`)  với  #mi(`f(x) = x^2 - 4x + 5`) . Xét hàm số  #mi(`f(x) = x^2 - 4x + 5`)  trên  #mi(`\mathbb{R}`) .  #mi(`f'(x) = 2x - 4`) .  #mi(`f'(x) = 0 \Leftrightarrow x = 2`) . Ta có  #mi(`f(2) = 1`) . Bảng biến thiên cho thấy hàm số đạt cực tiểu tại  #mi(`x = 2`)  với  #mi(`y_{CT} = 1`)  và  #mi(`\lim_{x \to \pm\infty} f(x) = +\infty`) . Do đó  #mi(`\min_{\mathbb{R}} f(x) = 1`) . Vậy điều kiện để bất phương trình nghiệm đúng với mọi  #mi(`x`)  là  #mi(`m \le 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Biểu diễn vectơ và các phép toán vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Biểu diễn vectơ và các phép toán vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm: Với ba điểm  #mi(`A, B, C`)  bất kỳ, ta có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và  #mi(`\vec{AC} - \vec{AB} = \vec{BC}`) .
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc trung điểm: Nếu  #mi(`I`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì  #mi(`\vec{IA} + \vec{IB} = \vec{0}`)  và với mọi điểm  #mi(`M`) , ta có  #mi(`\vec{MA} + \vec{MB} = 2\vec{MI}`) .
  - Quy tắc trọng tâm: Nếu  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`)  thì  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  và với mọi điểm  #mi(`M`) , ta có  #mi(`\vec{MA} + \vec{MB} + \vec{MC} = 3\vec{MG}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Gặp bài biểu diễn vectơ: Cứ 'chèn điểm' liên tục để nối các vectơ cần tính với các vectơ đã biết. Gặp tổng các vectơ có chung gốc: Nghĩ ngay đến quy tắc trung điểm (2 điểm) hoặc trọng tâm (3 điểm).
  ]
  - *Công thức cốt lõi:* Cho hình bình hành  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biết  #mi(`\vec{AC'} = a\vec{AB} + b\vec{AD} + c\vec{AA'}`) . Tính giá trị của biểu thức  #mi(`S = a + b + c`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp (hoặc chèn điểm), ta có:  #mi(`\vec{AC'} = \vec{AB} + \vec{BC} + \vec{CC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Do đó,  #mi(`a = 1, b = 1, c = 1`) . Vậy  #mi(`S = 1 + 1 + 1 = 3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Biết  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = k\vec{SO}`) . Tính giá trị của  #mi(`k`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) , theo quy tắc trung điểm ta có:  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Cộng vế theo vế, ta được:  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 4\vec{SO}`) . Vậy  #mi(`k = 4`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn vectơ theo các vectơ cạnh của hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{AC'}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc ba điểm, ta có:  #mi(`\vec{AC'} = \vec{AB} + \vec{BC} + \vec{CC'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`\vec{BC} = \vec{AD}`)  và  #mi(`\vec{CC'} = \vec{AA'}`) . Thay vào biểu thức trên, ta được:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Chứng minh đẳng thức vectơ:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Chứng minh rằng  #mi(`\vec{SA} + \vec{SC} = \vec{SB} + \vec{SD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Theo quy tắc trung điểm, ta có:  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  (1) và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`)  (2). Từ (1) và (2) suy ra  #mi(`\vec{SA} + \vec{SC} = \vec{SB} + \vec{SD}`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tổng các vectơ (quy tắc trọng tâm):] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`BCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc ba điểm, ta có:  #mi(`\vec{AB} = \vec{AG} + \vec{GB}`) ,  #mi(`\vec{AC} = \vec{AG} + \vec{GC}`) ,  #mi(`\vec{AD} = \vec{AG} + \vec{GD}`) . Cộng vế theo vế ba đẳng thức trên, ta được:  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG} + (\vec{GB} + \vec{GC} + \vec{GD})`) . Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`BCD`)  nên  #mi(`\vec{GB} + \vec{GC} + \vec{GD} = \vec{0}`) . Vậy  #mi(`\vec{AB} + \vec{AC} + \vec{AD} = 3\vec{AG}`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu diễn vectơ qua trung điểm:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  và  #mi(`N`)  lần lượt là trung điểm của các cạnh  #mi(`AB`)  và  #mi(`CD`) . Chứng minh rằng  #mi(`\vec{MN} = \frac{1}{2}(\vec{AD} + \vec{BC})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc ba điểm, ta có:  #mi(`\vec{MN} = \vec{MA} + \vec{AD} + \vec{DN}`)  và  #mi(`\vec{MN} = \vec{MB} + \vec{BC} + \vec{CN}`) . Cộng vế theo vế hai đẳng thức trên, ta được:  #mi(`2\vec{MN} = (\vec{MA} + \vec{MB}) + (\vec{AD} + \vec{BC}) + (\vec{DN} + \vec{CN})`) . Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) ;  #mi(`N`)  là trung điểm  #mi(`CD`)  nên  #mi(`\vec{DN} + \vec{CN} = \vec{0}`) . Do đó  #mi(`2\vec{MN} = \vec{AD} + \vec{BC}`) , hay  #mi(`\vec{MN} = \frac{1}{2}(\vec{AD} + \vec{BC})`)  (đpcm).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{BD'}`)  theo ba vectơ  #mi(`\vec{BA}, \vec{BC}, \vec{BB'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc ba điểm, ta có:  #mi(`\vec{BD'} = \vec{BA} + \vec{AD} + \vec{DD'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp nên  #mi(`\vec{AD} = \vec{BC}`)  và  #mi(`\vec{DD'} = \vec{BB'}`) . Thay vào biểu thức trên, ta được:  #mi(`\vec{BD'} = \vec{BA} + \vec{BC} + \vec{BB'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{AC}`)  theo ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình bình hành trong mặt phẳng đáy  #mi(`ABCD`) , ta có:  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) . Vì không có thành phần theo phương thẳng đứng nên hệ số của  #mi(`\vec{AA'}`)  là  #mi(`0`) . Vậy  #mi(`\vec{AC} = \vec{AB} + \vec{AD} + 0\vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Chứng minh rằng  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của đoạn thẳng  #mi(`AC`) . Theo quy tắc trung điểm với điểm  #mi(`S`)  bất kỳ, ta có:  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  (đpcm).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`) . Chứng minh rằng  #mi(`\vec{DA} + \vec{DB} + \vec{DC} = 3\vec{DG}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc ba điểm, ta có:  #mi(`\vec{DA} = \vec{DG} + \vec{GA}`) ,  #mi(`\vec{DB} = \vec{DG} + \vec{GB}`) ,  #mi(`\vec{DC} = \vec{DG} + \vec{GC}`) . Cộng vế theo vế ba đẳng thức trên, ta được:  #mi(`\vec{DA} + \vec{DB} + \vec{DC} = 3\vec{DG} + (\vec{GA} + \vec{GB} + \vec{GC})`) . Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Vậy  #mi(`\vec{DA} + \vec{DB} + \vec{DC} = 3\vec{DG}`)  (đpcm).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có tâm  #mi(`O`) . Chứng minh rằng  #mi(`\vec{OA} + \vec{OB} + \vec{OC} + \vec{OD} + \vec{OA'} + \vec{OB'} + \vec{OC'} + \vec{OD'} = \vec{0}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình hộp nên  #mi(`O`)  là trung điểm của các đường chéo  #mi(`AC', A'C, BD', B'D`) . Theo quy tắc trung điểm, ta có:  #mi(`\vec{OA} + \vec{OC'} = \vec{0}`) ,  #mi(`\vec{OB} + \vec{OD'} = \vec{0}`) ,  #mi(`\vec{OC} + \vec{OA'} = \vec{0}`) ,  #mi(`\vec{OD} + \vec{OB'} = \vec{0}`) . Cộng vế theo vế bốn đẳng thức trên, ta được tổng cần chứng minh bằng  #mi(`\vec{0}`)  (đpcm).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Tính tích vô hướng và góc giữa hai vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Tính tích vô hướng và góc giữa hai vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  trong không gian:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| |\vec{b}| \cos(\vec{a}, \vec{b})`) .
  - Góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  (khác  #mi(`\vec{0}`) ) được tính bởi công thức:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| |\vec{b}|}`) .
  - Độ dài của vectơ  #mi(`\vec{a}`)  được tính bởi công thức:  #mi(`|\vec{a}| = \sqrt{\vec{a}^2}`) .
  - Các tính chất của tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = \vec{b} \cdot \vec{a}`) ;  #mi(`\vec{a} \cdot (\vec{b} + \vec{c}) = \vec{a} \cdot \vec{b} + \vec{a} \cdot \vec{c}`) ;  #mi(`(k\vec{a}) \cdot \vec{b} = k(\vec{a} \cdot \vec{b})`) .
  - Trong hình lập phương, hình hộp chữ nhật, các cạnh xuất phát từ một đỉnh đôi một vuông góc với nhau. Trong tứ diện đều, góc giữa hai cạnh xuất phát từ một đỉnh là  #mi(`60^\circ`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính tích vô hướng, ta chọn một điểm gốc chung rồi phân tích các vectơ thành tổng hoặc hiệu của các vectơ cơ sở (thường là các cạnh của hình hộp, hình chóp). Sau đó, sử dụng tính chất phân phối và các tích vô hướng đã biết (bằng 0 nếu vuông góc, bằng  #mi(`a^2`)  nếu cùng phương cùng chiều, bằng  #mi(`\frac{a^2}{2}`)  nếu tạo góc  #mi(`60^\circ`) ).
  ]
  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\vec{a} \cdot \vec{b} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a^2`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Khi đó,  #mi(`\vec{AB} \cdot \vec{AC'} = \vec{AB} \cdot (\vec{AB} + \vec{AD} + \vec{AA'}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AD} + \vec{AB} \cdot \vec{AA'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} \perp \vec{AD}`)  và  #mi(`\vec{AB} \perp \vec{AA'}`) , suy ra  #mi(`\vec{AB} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AB} \cdot \vec{AA'} = 0`) . Vậy  #mi(`\vec{AB} \cdot \vec{AC'} = AB^2 = a^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 90]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{CD} = \vec{AD} - \vec{AC}`) . Khi đó,  #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC}`) . Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABD`)  và  #mi(`ABC`)  là các tam giác đều cạnh  #mi(`a`) . Do đó,  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`)  và  #mi(`\vec{AB} \cdot \vec{AC} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) . Suy ra  #mi(`\vec{AB} \cdot \vec{CD} = \frac{a^2}{2} - \frac{a^2}{2} = 0`) . Vậy góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{CD}`)  là  #mi(`90^\circ`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hình chóp  #mi(`S.ABCD`)  có  #mi(`SA \perp (ABCD)`) ,  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA = a`) . Tính độ dài của vectơ  #mi(`\vec{SB} + \vec{SD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a\sqrt{6}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`O`)  là tâm của hình vuông  #mi(`ABCD`) . Khi đó  #mi(`O`)  là trung điểm của  #mi(`BD`) , suy ra  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Ta có  #mi(`AO = \frac{a\sqrt{2}}{2}`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`SA \perp AO`) , do đó tam giác  #mi(`SAO`)  vuông tại  #mi(`A`) . Suy ra  #mi(`SO = \sqrt{SA^2 + AO^2} = \sqrt{a^2 + \frac{a^2}{2}} = \frac{a\sqrt{6}}{2}`) . Vậy  #mi(`|\vec{SB} + \vec{SD}| = 2SO = a\sqrt{6}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng của hai vectơ vuông góc:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`AB \perp AD`) . Do đó, góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  là  #mi(`90^\circ`) . Vậy  #mi(`\vec{AB} \cdot \vec{AD} = |\vec{AB}| |\vec{AD}| \cos 90^\circ = a \cdot a \cdot 0 = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tích vô hướng trong tứ diện đều:] Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABC`)  là tam giác đều cạnh  #mi(`a`) . Do đó, góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  là  #mi(`60^\circ`) . Vậy  #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| |\vec{AC}| \cos 60^\circ = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tích vô hướng bằng cách phân tích vectơ:] Cho hình chóp  #mi(`S.ABCD`)  có  #mi(`SA \perp (ABCD)`) ,  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA = a`) . Tính tích vô hướng  #mi(`\vec{SB} \cdot \vec{SC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{SB} = \vec{SA} + \vec{AB}`)  và  #mi(`\vec{SC} = \vec{SA} + \vec{AC}`) . Khi đó,  #mi(`\vec{SB} \cdot \vec{SC} = (\vec{SA} + \vec{AB}) \cdot (\vec{SA} + \vec{AC}) = \vec{SA}^2 + \vec{SA} \cdot \vec{AC} + \vec{AB} \cdot \vec{SA} + \vec{AB} \cdot \vec{AC}`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`SA \perp AC`)  và  #mi(`SA \perp AB`) , suy ra  #mi(`\vec{SA} \cdot \vec{AC} = 0`)  và  #mi(`\vec{AB} \cdot \vec{SA} = 0`) . Mặt khác,  #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| |\vec{AC}| \cos 45^\circ = a \cdot a\sqrt{2} \cdot \frac{\sqrt{2}}{2} = a^2`) . Vậy  #mi(`\vec{SB} \cdot \vec{SC} = a^2 + 0 + 0 + a^2 = 2a^2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ trong hình lập phương:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{BD'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{BD'} = \vec{BA} + \vec{BC} + \vec{BB'} = -\vec{AB} + \vec{AD} + \vec{AA'}`) . Khi đó,  #mi(`\vec{AC} \cdot \vec{BD'} = (\vec{AB} + \vec{AD}) \cdot (-\vec{AB} + \vec{AD} + \vec{AA'}) = -\vec{AB}^2 + \vec{AB} \cdot \vec{AD} + \vec{AB} \cdot \vec{AA'} - \vec{AD} \cdot \vec{AB} + \vec{AD}^2 + \vec{AD} \cdot \vec{AA'}`) . Vì  #mi(`\vec{AB} \perp \vec{AD}`) ,  #mi(`\vec{AB} \perp \vec{AA'}`) ,  #mi(`\vec{AD} \perp \vec{AA'}`)  nên  #mi(`\vec{AB} \cdot \vec{AD} = \vec{AB} \cdot \vec{AA'} = \vec{AD} \cdot \vec{AA'} = 0`) . Suy ra  #mi(`\vec{AC} \cdot \vec{BD'} = -a^2 + a^2 = 0`) . Vậy góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{BD'}`)  là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Tính độ dài đoạn thẳng dựa vào tích vô hướng:] Cho hình chóp  #mi(`S.ABCD`)  có  #mi(`SA \perp (ABCD)`) ,  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA = a`) . Tính độ dài đoạn thẳng  #mi(`SC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{SC} = \vec{SA} + \vec{AC}`) . Suy ra  #mi(`|\vec{SC}|^2 = (\vec{SA} + \vec{AC})^2 = \vec{SA}^2 + 2\vec{SA} \cdot \vec{AC} + \vec{AC}^2`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`SA \perp AC`) , do đó  #mi(`\vec{SA} \cdot \vec{AC} = 0`) . Mặt khác,  #mi(`\vec{SA}^2 = a^2`)  và  #mi(`\vec{AC}^2 = AC^2 = (a\sqrt{2})^2 = 2a^2`) . Vậy  #mi(`|\vec{SC}|^2 = a^2 + 0 + 2a^2 = 3a^2`) , suy ra  #mi(`SC = a\sqrt{3}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AD'} = \vec{AD} + \vec{AA'}`) . Khi đó,  #mi(`\vec{AB} \cdot \vec{AD'} = \vec{AB} \cdot (\vec{AD} + \vec{AA'}) = \vec{AB} \cdot \vec{AD} + \vec{AB} \cdot \vec{AA'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} \perp \vec{AD}`)  và  #mi(`\vec{AB} \perp \vec{AA'}`) , suy ra  #mi(`\vec{AB} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AB} \cdot \vec{AA'} = 0`) . Vậy  #mi(`\vec{AB} \cdot \vec{AD'} = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2a`) . Tính tích vô hướng  #mi(`\vec{AC} \cdot \vec{AB'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{AB'} = \vec{AB} + \vec{AA'}`) . Khi đó,  #mi(`\vec{AC} \cdot \vec{AB'} = (\vec{AB} + \vec{AD}) \cdot (\vec{AB} + \vec{AA'}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AA'} + \vec{AD} \cdot \vec{AB} + \vec{AD} \cdot \vec{AA'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} \perp \vec{AA'}`) ,  #mi(`\vec{AD} \perp \vec{AB}`) ,  #mi(`\vec{AD} \perp \vec{AA'}`) , suy ra  #mi(`\vec{AB} \cdot \vec{AA'} = \vec{AD} \cdot \vec{AB} = \vec{AD} \cdot \vec{AA'} = 0`) . Vậy  #mi(`\vec{AC} \cdot \vec{AB'} = \vec{AB}^2 = (2a)^2 = 4a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`2a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABC`)  là tam giác đều cạnh  #mi(`2a`) . Do đó, góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  là  #mi(`60^\circ`) . Vậy  #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| |\vec{AC}| \cos 60^\circ = 2a \cdot 2a \cdot \frac{1}{2} = 2a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình chóp  #mi(`S.ABCD`)  có  #mi(`SA \perp (ABCD)`) ,  #mi(`ABCD`)  là hình chữ nhật với  #mi(`AB = a`) ,  #mi(`AD = 2a`) ,  #mi(`SA = a`) . Tính tích vô hướng  #mi(`\vec{SB} \cdot \vec{SD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{SB} = \vec{SA} + \vec{AB}`)  và  #mi(`\vec{SD} = \vec{SA} + \vec{AD}`) . Khi đó,  #mi(`\vec{SB} \cdot \vec{SD} = (\vec{SA} + \vec{AB}) \cdot (\vec{SA} + \vec{AD}) = \vec{SA}^2 + \vec{SA} \cdot \vec{AD} + \vec{AB} \cdot \vec{SA} + \vec{AB} \cdot \vec{AD}`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`SA \perp AD`)  và  #mi(`SA \perp AB`) , suy ra  #mi(`\vec{SA} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AB} \cdot \vec{SA} = 0`) . Mặt khác,  #mi(`ABCD`)  là hình chữ nhật nên  #mi(`AB \perp AD`) , suy ra  #mi(`\vec{AB} \cdot \vec{AD} = 0`) . Vậy  #mi(`\vec{SB} \cdot \vec{SD} = \vec{SA}^2 = a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'B}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`)  và  #mi(`\vec{A'B} = \vec{AB} - \vec{AA'}`) . Khi đó,  #mi(`\vec{AC} \cdot \vec{A'B} = (\vec{AB} + \vec{AD}) \cdot (\vec{AB} - \vec{AA'}) = \vec{AB}^2 - \vec{AB} \cdot \vec{AA'} + \vec{AD} \cdot \vec{AB} - \vec{AD} \cdot \vec{AA'}`) . Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`\vec{AB} \perp \vec{AA'}`) ,  #mi(`\vec{AD} \perp \vec{AB}`) ,  #mi(`\vec{AD} \perp \vec{AA'}`) , suy ra  #mi(`\vec{AB} \cdot \vec{AA'} = \vec{AD} \cdot \vec{AB} = \vec{AD} \cdot \vec{AA'} = 0`) . Do đó,  #mi(`\vec{AC} \cdot \vec{A'B} = \vec{AB}^2 = a^2`) . Mặt khác,  #mi(`|\vec{AC}| = a\sqrt{2}`)  và  #mi(`|\vec{A'B}| = a\sqrt{2}`) . Vậy  #mi(`\cos(\vec{AC}, \vec{A'B}) = \frac{\vec{AC} \cdot \vec{A'B}}{|\vec{AC}| |\vec{A'B}|} = \frac{a^2}{a\sqrt{2} \cdot a\sqrt{2}} = \frac{1}{2}`) . Suy ra góc giữa hai vectơ  #mi(`\vec{AC}`)  và  #mi(`\vec{A'B}`)  là  #mi(`60^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hình chóp  #mi(`S.ABCD`)  có  #mi(`SA \perp (ABCD)`) ,  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA = a\sqrt{2}`) . Tính độ dài đoạn thẳng  #mi(`SC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{SC} = \vec{SA} + \vec{AC}`) . Suy ra  #mi(`|\vec{SC}|^2 = (\vec{SA} + \vec{AC})^2 = \vec{SA}^2 + 2\vec{SA} \cdot \vec{AC} + \vec{AC}^2`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`SA \perp AC`) , do đó  #mi(`\vec{SA} \cdot \vec{AC} = 0`) . Mặt khác,  #mi(`\vec{SA}^2 = (a\sqrt{2})^2 = 2a^2`)  và  #mi(`\vec{AC}^2 = AC^2 = (a\sqrt{2})^2 = 2a^2`) . Vậy  #mi(`|\vec{SC}|^2 = 2a^2 + 0 + 2a^2 = 4a^2`) , suy ra  #mi(`SC = 2a`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Xác định tọa độ điểm và vectơ trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Xác định tọa độ điểm và vectơ trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Định nghĩa tọa độ vectơ:  #mi(`\vec{u} = x\vec{i} + y\vec{j} + z\vec{k} \Leftrightarrow \vec{u} = (x;y;z)`) .
  - Tọa độ của vectơ nối hai điểm: Cho  #mi(`A(x_A;y_A;z_A)`)  và  #mi(`B(x_B;y_B;z_B)`)  thì  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  - Hình chiếu vuông góc của điểm  #mi(`M(x;y;z)`)  lên các trục  #mi(`Ox, Oy, Oz`)  lần lượt là  #mi(`M_1(x;0;0), M_2(0;y;0), M_3(0;0;z)`) .
  - Hình chiếu vuông góc của điểm  #mi(`M(x;y;z)`)  lên các mặt phẳng  #mi(`(Oxy), (Oyz), (Oxz)`)  lần lượt là  #mi(`M_4(x;y;0), M_5(0;y;z), M_6(x;0;z)`) .
  - Thiết lập hệ tọa độ: Chọn gốc tọa độ tại đỉnh vuông góc, các trục tọa độ trùng với các cạnh vuông góc xuất phát từ đỉnh đó.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] MẸO NHỚ: 'Trục giữ nguyên, mặt phẳng thay 0'. Hình chiếu lên trục nào thì giữ nguyên tọa độ trục đó, hai tọa độ còn lại bằng 0. Hình chiếu lên mặt phẳng nào thì giữ nguyên hai tọa độ của mặt phẳng đó, tọa độ còn lại bằng 0.
  ]
  - *Công thức cốt lõi:* Cho hai điểm  #mi(`A(x_A;y_A;z_A)`)  và  #mi(`B(x_B;y_B;z_B)`) , tọa độ vectơ  #mi(`\vec{AB} = (`)  ...  #mi(`; y_B - y_A ; z_B - z_A)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1;-2;3)`)  và  #mi(`B(2;1;-1)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{26}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AB} = (2-1; 1-(-2); -1-3) = (1;3;-4)`) .\nĐộ dài đoạn thẳng  #mi(`AB = |\vec{AB}| = \sqrt{1^2 + 3^2 + (-4)^2} = \sqrt{1+9+16} = \sqrt{26}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M(2;-3;4)`) . Tìm tọa độ hình chiếu vuông góc của  #mi(`M`)  lên trục  #mi(`Oy`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (0;-3;0)]
      \ #text(fill: rgb("#334155"))[Lời giải: Hình chiếu vuông góc của điểm  #mi(`M(x;y;z)`)  lên trục  #mi(`Oy`)  là điểm có tọa độ  #mi(`(0;y;0)`) .\nÁp dụng với  #mi(`M(2;-3;4)`) , hình chiếu lên  #mi(`Oy`)  là  #mi(`(0;-3;0)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Trong không gian  #mi(`Oxyz`) , cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0;0;0)`) ,  #mi(`B(2;0;0)`) ,  #mi(`D(0;3;0)`)  và  #mi(`A'(0;0;4)`) . Tìm tọa độ điểm  #mi(`C'`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2;3;4)]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình hộp chữ nhật nên  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .\nTa có  #mi(`\vec{AB} = (2;0;0)`) ,  #mi(`\vec{AD} = (0;3;0)`) ,  #mi(`\vec{AA'} = (0;0;4)`) .\nSuy ra  #mi(`\vec{AC'} = (2;3;4)`) .\nVì  #mi(`A(0;0;0)`)  nên tọa độ điểm  #mi(`C'`)  là  #mi(`(2;3;4)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ vectơ khi biết tọa độ điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1;2;3)`)  và  #mi(`B(3;-1;2)`) . Tìm tọa độ của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa, tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .\nThay số:  #mi(`\vec{AB} = (3-1; -1-2; 2-3) = (2;-3;-1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ hình chiếu vuông góc:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M(-1;4;-2)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`M`)  lên trục  #mi(`Ox`)  và lên mặt phẳng  #mi(`(Oyz)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của  #mi(`M(x;y;z)`)  lên trục  #mi(`Ox`)  là điểm  #mi(`(x;0;0)`) . Do đó hình chiếu của  #mi(`M(-1;4;-2)`)  lên  #mi(`Ox`)  là  #mi(`(-1;0;0)`) .\nHình chiếu vuông góc của  #mi(`M(x;y;z)`)  lên mặt phẳng  #mi(`(Oyz)`)  là điểm  #mi(`(0;y;z)`) . Do đó hình chiếu của  #mi(`M(-1;4;-2)`)  lên  #mi(`(Oyz)`)  là  #mi(`(0;4;-2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Thiết lập hệ tọa độ cho hình chóp:] Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA`)  vuông góc với mặt phẳng  #mi(`(ABC)`) , tam giác  #mi(`ABC`)  vuông tại  #mi(`A`) . Biết  #mi(`SA = a`) ,  #mi(`AB = b`) ,  #mi(`AC = c`) . Thiết lập hệ tọa độ  #mi(`Oxyz`)  với gốc  #mi(`A`) , các trục  #mi(`Ax, Ay, Az`)  lần lượt trùng với các tia  #mi(`AB, AC, AS`) . Tìm tọa độ các đỉnh của hình chóp.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chọn hệ tọa độ  #mi(`Oxyz`)  với  #mi(`O \equiv A(0;0;0)`) .\nTrục  #mi(`Ox`)  trùng tia  #mi(`AB`) , trục  #mi(`Oy`)  trùng tia  #mi(`AC`) , trục  #mi(`Oz`)  trùng tia  #mi(`AS`) .\nVì  #mi(`B`)  thuộc tia  #mi(`AB`)  và  #mi(`AB = b`)  nên  #mi(`B(b;0;0)`) .\nVì  #mi(`C`)  thuộc tia  #mi(`AC`)  và  #mi(`AC = c`)  nên  #mi(`C(0;c;0)`) .\nVì  #mi(`S`)  thuộc tia  #mi(`AS`)  và  #mi(`AS = a`)  nên  #mi(`S(0;0;a)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Thiết lập hệ tọa độ cho hình hộp:] Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB = 2`) ,  #mi(`AD = 3`) ,  #mi(`AA' = 4`) . Chọn hệ tọa độ  #mi(`Oxyz`)  với  #mi(`O \equiv A`) , các tia  #mi(`Ox, Oy, Oz`)  lần lượt trùng với các tia  #mi(`AB, AD, AA'`) . Tìm tọa độ các điểm  #mi(`C`)  và  #mi(`C'`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chọn hệ tọa độ  #mi(`Oxyz`)  với  #mi(`A(0;0;0)`) .\nTia  #mi(`Ox`)  trùng  #mi(`AB`)  nên  #mi(`B(2;0;0)`) . Tia  #mi(`Oy`)  trùng  #mi(`AD`)  nên  #mi(`D(0;3;0)`) . Tia  #mi(`Oz`)  trùng  #mi(`AA'`)  nên  #mi(`A'(0;0;4)`) .\nVì  #mi(`ABCD`)  là hình chữ nhật nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = (2;3;0)`) , suy ra  #mi(`C(2;3;0)`) .\nVì  #mi(`A'B'C'D'`)  là hình chữ nhật và  #mi(`\vec{CC'} = \vec{AA'} = (0;0;4)`)  nên  #mi(`C' = C + \vec{CC'} = (2;3;4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`M(2;-1;3)`)  và  #mi(`N(4;2;0)`) . Tìm tọa độ của vectơ  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M) = (4-2; 2-(-1); 0-3) = (2;3;-3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`P(-1;2;4)`)  và  #mi(`Q(3;-2;1)`) . Tìm tọa độ của vectơ  #mi(`\vec{PQ}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{PQ} = (x_Q - x_P; y_Q - y_P; z_Q - z_P) = (3-(-1); -2-2; 1-4) = (4;-4;-3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`A(2;-3;5)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`A`)  lên trục  #mi(`Oz`)  và lên mặt phẳng  #mi(`(Oxy)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của  #mi(`A(x;y;z)`)  lên trục  #mi(`Oz`)  là  #mi(`(0;0;z)`) . Do đó hình chiếu của  #mi(`A(2;-3;5)`)  lên  #mi(`Oz`)  là  #mi(`(0;0;5)`) .\nHình chiếu vuông góc của  #mi(`A(x;y;z)`)  lên mặt phẳng  #mi(`(Oxy)`)  là  #mi(`(x;y;0)`) . Do đó hình chiếu của  #mi(`A(2;-3;5)`)  lên  #mi(`(Oxy)`)  là  #mi(`(2;-3;0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0;0;0)`) ,  #mi(`B(1;0;0)`) ,  #mi(`D(0;2;0)`)  và  #mi(`A'(0;0;3)`) . Tìm tọa độ điểm  #mi(`B'`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chọn hệ tọa độ với  #mi(`A(0;0;0)`) . Ta có  #mi(`\vec{AB} = (1;0;0)`) ,  #mi(`\vec{AD} = (0;2;0)`) ,  #mi(`\vec{AA'} = (0;0;3)`) .\nVì  #mi(`ABB'A'`)  là hình chữ nhật nên  #mi(`\vec{AB'} = \vec{AB} + \vec{AA'} = (1;0;3)`) .\nSuy ra tọa độ điểm  #mi(`B'`)  là  #mi(`(1;0;3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Trong không gian  #mi(`Oxyz`) , cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA`)  vuông góc với đáy và  #mi(`SA = a\sqrt{2}`) . Chọn hệ tọa độ  #mi(`Oxyz`)  với  #mi(`A(0;0;0)`) ,  #mi(`B(a;0;0)`) ,  #mi(`D(0;a;0)`)  và  #mi(`S(0;0;a\sqrt{2})`) . Tìm tọa độ điểm  #mi(`C`)  và vectơ  #mi(`\vec{SC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD} = (a;0;0) + (0;a;0) = (a;a;0)`) . Suy ra  #mi(`C(a;a;0)`) .\nTọa độ vectơ  #mi(`\vec{SC} = (x_C - x_S; y_C - y_S; z_C - z_S) = (a-0; a-0; 0-a\sqrt{2}) = (a;a;-a\sqrt{2})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Bài toán tối ưu hóa chi phí và lợi nhuận trong kinh doanh ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Bài toán tối ưu hóa chi phí và lợi nhuận trong kinh doanh]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm doanh thu:  #mi(`R(x) = x \cdot p(x)`) , với  #mi(`p(x)`)  là hàm cầu (giá bán phụ thuộc vào số lượng  #mi(`x`) ).
  - Hàm lợi nhuận:  #mi(`L(x) = R(x) - C(x)`) , với  #mi(`C(x)`)  là hàm chi phí sản xuất.
  - Để tối ưu hóa lợi nhuận hoặc doanh thu, ta tìm giá trị lớn nhất của hàm số  #mi(`L(x)`)  hoặc  #mi(`R(x)`)  bằng cách tính đạo hàm, giải phương trình  #mi(`L'(x) = 0`)  hoặc  #mi(`R'(x) = 0`)  và lập bảng biến thiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lợi nhuận = Doanh thu - Chi phí. Tối ưu hóa bằng cách tìm đạo hàm bằng 0 và xét dấu để tìm cực đại.
  ]
  - *Công thức cốt lõi:* Hàm lợi nhuận được xác định bởi công thức  #mi(`L(x) = ... - ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một công ty có hàm cầu  #mi(`p = 50 - x`)  (nghìn đồng) và hàm chi phí  #mi(`C(x) = 10x + 20`)  (nghìn đồng). Tính lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 380]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = x(50 - x) = 50x - x^2`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = (50x - x^2) - (10x + 20) = -x^2 + 40x - 20`) . Đạo hàm:  #mi(`L'(x) = -2x + 40`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 20`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 20`) . Khi đó  #mi(`L(20) = -20^2 + 40 \cdot 20 - 20 = 380`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một công ty có hàm cầu  #mi(`p = 120 - 3x`)  (nghìn đồng). Tính doanh thu lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1200]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = x(120 - 3x) = 120x - 3x^2`) . Đạo hàm:  #mi(`R'(x) = 120 - 6x`) . Cho  #mi(`R'(x) = 0 \Rightarrow x = 20`) . Lập bảng biến thiên,  #mi(`R(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 20`) . Khi đó  #mi(`R(20) = 120 \cdot 20 - 3 \cdot 20^2 = 1200`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Một công ty có hàm chi phí  #mi(`C(x) = 2x^2 + 10x + 100`)  (nghìn đồng) và giá bán cố định  #mi(`p = 50`)  (nghìn đồng). Tính lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 100]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = 50x`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = 50x - (2x^2 + 10x + 100) = -2x^2 + 40x - 100`) . Đạo hàm:  #mi(`L'(x) = -4x + 40`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 10`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Khi đó  #mi(`L(10) = -2 \cdot 10^2 + 40 \cdot 10 - 100 = 100`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa lợi nhuận khi biết hàm cầu và chi phí:] Một công ty sản xuất và bán một loại sản phẩm. Hàm cầu của sản phẩm là  #mi(`p = 20 - 0.1x`)  (nghìn đồng), trong đó  #mi(`x`)  là số lượng sản phẩm bán ra. Hàm chi phí sản xuất là  #mi(`C(x) = 10x + 100`)  (nghìn đồng). Hỏi công ty cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu khi bán  #mi(`x`)  sản phẩm là  #mi(`R(x) = x \cdot p = x(20 - 0.1x) = 20x - 0.1x^2`) . Lợi nhuận thu được là  #mi(`L(x) = R(x) - C(x) = (20x - 0.1x^2) - (10x + 100) = -0.1x^2 + 10x - 100`) . Đạo hàm  #mi(`L'(x) = -0.2x + 10`) . Cho  #mi(`L'(x) = 0 \Rightarrow -0.2x + 10 = 0 \Rightarrow x = 50`) . Lập bảng biến thiên, ta thấy  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 50`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(50) = -0.1 \cdot 50^2 + 10 \cdot 50 - 100 = -250 + 500 - 100 = 150`)  (nghìn đồng). Vậy công ty cần sản xuất và bán 50 sản phẩm để đạt lợi nhuận lớn nhất là 150 nghìn đồng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa doanh thu khi biết hàm cầu:] Một cửa hàng bán một loại sản phẩm với hàm cầu  #mi(`p = 100 - 2x`)  (nghìn đồng), trong đó  #mi(`x`)  là số lượng sản phẩm bán ra. Hỏi cửa hàng cần bán bao nhiêu sản phẩm để doanh thu lớn nhất? Tính doanh thu lớn nhất đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu khi bán  #mi(`x`)  sản phẩm là  #mi(`R(x) = x \cdot p = x(100 - 2x) = 100x - 2x^2`) . Đạo hàm  #mi(`R'(x) = 100 - 4x`) . Cho  #mi(`R'(x) = 0 \Rightarrow 100 - 4x = 0 \Rightarrow x = 25`) . Lập bảng biến thiên, ta thấy  #mi(`R(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 25`) . Khi đó, doanh thu lớn nhất là  #mi(`R(25) = 100 \cdot 25 - 2 \cdot 25^2 = 2500 - 1250 = 1250`)  (nghìn đồng). Vậy cửa hàng cần bán 25 sản phẩm để đạt doanh thu lớn nhất là 1250 nghìn đồng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tối ưu hóa lợi nhuận khi biết hàm chi phí và giá bán cố định:] Một doanh nghiệp sản xuất một loại sản phẩm với hàm chi phí  #mi(`C(x) = x^2 + 20x + 50`)  (nghìn đồng), trong đó  #mi(`x`)  là số lượng sản phẩm. Giá bán của mỗi sản phẩm trên thị trường là cố định  #mi(`p = 60`)  (nghìn đồng). Hỏi doanh nghiệp cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu khi bán  #mi(`x`)  sản phẩm là  #mi(`R(x) = 60x`) . Lợi nhuận thu được là  #mi(`L(x) = R(x) - C(x) = 60x - (x^2 + 20x + 50) = -x^2 + 40x - 50`) . Đạo hàm  #mi(`L'(x) = -2x + 40`) . Cho  #mi(`L'(x) = 0 \Rightarrow -2x + 40 = 0 \Rightarrow x = 20`) . Lập bảng biến thiên, ta thấy  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 20`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(20) = -20^2 + 40 \cdot 20 - 50 = -400 + 800 - 50 = 350`)  (nghìn đồng). Vậy doanh nghiệp cần sản xuất và bán 20 sản phẩm để đạt lợi nhuận lớn nhất là 350 nghìn đồng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể nhẹ: Tìm giá bán để lợi nhuận lớn nhất:] Một công ty có hàm chi phí  #mi(`C(x) = 5x + 20`)  (nghìn đồng) và hàm cầu  #mi(`p = 30 - x`)  (nghìn đồng). Hỏi công ty cần bán sản phẩm với giá bao nhiêu để lợi nhuận lớn nhất?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu:  #mi(`R(x) = x(30 - x) = 30x - x^2`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = (30x - x^2) - (5x + 20) = -x^2 + 25x - 20`) . Đạo hàm:  #mi(`L'(x) = -2x + 25`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 12.5`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 12.5`) . Khi đó, giá bán để lợi nhuận lớn nhất là  #mi(`p = 30 - 12.5 = 17.5`)  (nghìn đồng).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một công ty có hàm cầu  #mi(`p = 30 - 0.2x`)  (nghìn đồng) và hàm chi phí  #mi(`C(x) = 5x + 50`)  (nghìn đồng). Hỏi công ty cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(30 - 0.2x) = 30x - 0.2x^2`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = (30x - 0.2x^2) - (5x + 50) = -0.2x^2 + 25x - 50`) . Đạo hàm:  #mi(`L'(x) = -0.4x + 25`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 62.5`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 62.5`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(62.5) = -0.2 \cdot 62.5^2 + 25 \cdot 62.5 - 50 = 731.25`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một công ty có hàm cầu  #mi(`p = 40 - 0.5x`)  (nghìn đồng) và hàm chi phí  #mi(`C(x) = 8x + 20`)  (nghìn đồng). Hỏi công ty cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(40 - 0.5x) = 40x - 0.5x^2`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = (40x - 0.5x^2) - (8x + 20) = -0.5x^2 + 32x - 20`) . Đạo hàm:  #mi(`L'(x) = -x + 32`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 32`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 32`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(32) = -0.5 \cdot 32^2 + 32 \cdot 32 - 20 = 492`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một cửa hàng có hàm cầu  #mi(`p = 80 - 4x`)  (nghìn đồng). Hỏi cửa hàng cần bán bao nhiêu sản phẩm để doanh thu lớn nhất? Tính doanh thu lớn nhất đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(80 - 4x) = 80x - 4x^2`) . Đạo hàm:  #mi(`R'(x) = 80 - 8x`) . Cho  #mi(`R'(x) = 0 \Rightarrow x = 10`) . Lập bảng biến thiên,  #mi(`R(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Khi đó, doanh thu lớn nhất là  #mi(`R(10) = 80 \cdot 10 - 4 \cdot 10^2 = 400`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một doanh nghiệp có hàm chi phí  #mi(`C(x) = x^2 + 10x + 20`)  (nghìn đồng) và giá bán cố định  #mi(`p = 40`)  (nghìn đồng). Hỏi doanh nghiệp cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = 40x`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = 40x - (x^2 + 10x + 20) = -x^2 + 30x - 20`) . Đạo hàm:  #mi(`L'(x) = -2x + 30`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 15`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 15`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(15) = -15^2 + 30 \cdot 15 - 20 = 205`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một công ty có hàm cầu  #mi(`p = 60 - 2x`)  (nghìn đồng) và hàm chi phí  #mi(`C(x) = 5x + 30`)  (nghìn đồng). Hỏi công ty cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(60 - 2x) = 60x - 2x^2`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = (60x - 2x^2) - (5x + 30) = -2x^2 + 55x - 30`) . Đạo hàm:  #mi(`L'(x) = -4x + 55`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 13.75`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 13.75`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(13.75) = -2 \cdot 13.75^2 + 55 \cdot 13.75 - 30 = 348.125`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Một doanh nghiệp có hàm chi phí  #mi(`C(x) = 3x^2 + 5x + 10`)  (nghìn đồng) và giá bán cố định  #mi(`p = 35`)  (nghìn đồng). Hỏi doanh nghiệp cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận lớn nhất? Tính lợi nhuận lớn nhất đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = 35x`) . Lợi nhuận:  #mi(`L(x) = R(x) - C(x) = 35x - (3x^2 + 5x + 10) = -3x^2 + 30x - 10`) . Đạo hàm:  #mi(`L'(x) = -6x + 30`) . Cho  #mi(`L'(x) = 0 \Rightarrow x = 5`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 5`) . Khi đó, lợi nhuận lớn nhất là  #mi(`L(5) = -3 \cdot 5^2 + 30 \cdot 5 - 10 = 65`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Bài toán tối ưu hóa hình học và vật lý thực tế ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Bài toán tối ưu hóa hình học và vật lý thực tế]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Xác định đại lượng cần tối ưu (thể tích, diện tích, chi phí, lực...) và gọi biến số  #mi(`x`)  cho một kích thước hình học phù hợp. Đặt điều kiện cho  #mi(`x`)  (thường là  #mi(`x > 0`) ).
  - Bước 2: Biểu diễn đại lượng cần tối ưu thành một hàm số  #mi(`f(x)`)  dựa trên các công thức hình học hoặc vật lý đã biết (ví dụ:  #mi(`V = x^2 h`) ,  #mi(`S = 2x^2 + 4xh`) ,  #mi(`P = mg`) ).
  - Bước 3: Tìm giá trị lớn nhất hoặc nhỏ nhất của hàm số  #mi(`f(x)`)  trên khoảng xác định bằng cách tính đạo hàm  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = 0`)  để tìm điểm tới hạn, lập bảng biến thiên và kết luận.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy trình 3 bước 'MỤC - HÀM - ĐẠO': Xác định MỤC tiêu tối ưu -> Thiết lập HÀM số một biến -> Tính ĐẠO hàm tìm cực trị. Nhớ đặt điều kiện biến số theo thực tế!
  ]
  - *Công thức cốt lõi:* Để tìm giá trị lớn nhất/nhỏ nhất của hàm số  #mi(`f(x)`)  trên khoảng  #mi(`(a;b)`) , ta tính đạo hàm  #mi(`f'(x)`) , giải phương trình  #mi(`... = 0`)  và lập bảng biến thiên.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một tấm nhôm hình vuông cạnh  #mi(`24\text{ cm}`) . Người ta cắt bốn góc tấm nhôm bốn hình vuông bằng nhau cạnh  #mi(`x\text{ (cm)}`)  rồi gập lại thành một cái hộp không nắp. Tính thể tích lớn nhất của hộp (đơn vị  #mi(`\text{cm}^3`) ).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1024]
      \ #text(fill: rgb("#334155"))[Lời giải: Thể tích của hộp là  #mi(`V(x) = x(24 - 2x)^2`)  với  #mi(`0 < x < 12`) . Ta có  #mi(`V'(x) = (24 - 2x)^2 + x \cdot 2(24 - 2x)(-2) = (24 - 2x)(24 - 6x)`) . Cho  #mi(`V'(x) = 0`)  ta được  #mi(`x = 12`)  (loại) hoặc  #mi(`x = 4`)  (nhận). Lập bảng biến thiên, hàm số đạt giá trị lớn nhất tại  #mi(`x = 4`) . Khi đó  #mi(`V_{\max} = V(4) = 4(24 - 8)^2 = 4 \cdot 16^2 = 1024\text{ cm}^3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một hộp chữ nhật không nắp có đáy là hình vuông cạnh  #mi(`x`) , chiều cao  #mi(`h`) , thể tích bằng  #mi(`4`) . Chi phí làm đáy gấp  #mi(`4`)  lần chi phí làm mặt bên. Tìm  #mi(`x`)  để chi phí sản xuất hộp là nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt[3]{2}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Thể tích  #mi(`V = x^2 h = 4 \Rightarrow h = \frac{4}{x^2}`) . Chi phí sản xuất  #mi(`C(x) = 4x^2 + 4xh = 4x^2 + 4x \cdot \frac{4}{x^2} = 4x^2 + \frac{16}{x}`)  với  #mi(`x > 0`) . Ta có  #mi(`C'(x) = 8x - \frac{16}{x^2}`) . Cho  #mi(`C'(x) = 0 \Leftrightarrow 8x^3 = 16 \Leftrightarrow x^3 = 2 \Leftrightarrow x = \sqrt[3]{2}`) . Lập bảng biến thiên, hàm số đạt giá trị nhỏ nhất tại  #mi(`x = \sqrt[3]{2}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho điểm  #mi(`A(2;3)`) . Một đường thẳng đi qua  #mi(`A`)  cắt các tia  #mi(`Ox, Oy`)  lần lượt tại  #mi(`B`)  và  #mi(`C`) . Tìm diện tích nhỏ nhất của tam giác  #mi(`OBC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 12]
      \ #text(fill: rgb("#334155"))[Lời giải: Giả sử  #mi(`B(a;0)`)  và  #mi(`C(0;b)`)  với  #mi(`a > 2, b > 3`) . Phương trình đường thẳng  #mi(`BC`)  là  #mi(`\frac{x}{a} + \frac{y}{b} = 1`) . Vì  #mi(`A(2;3)`)  thuộc  #mi(`BC`)  nên  #mi(`\frac{2}{a} + \frac{3}{b} = 1 \Rightarrow b = \frac{3a}{a - 2}`) . Diện tích tam giác  #mi(`OBC`)  là  #mi(`S = \frac{1}{2}ab = \frac{1}{2}a \cdot \frac{3a}{a - 2} = \frac{3a^2}{2(a - 2)}`) . Ta có  #mi(`S' = \frac{3}{2} \cdot \frac{2a(a - 2) - a^2}{(a - 2)^2} = \frac{3}{2} \cdot \frac{a^2 - 4a}{(a - 2)^2}`) . Cho  #mi(`S' = 0 \Rightarrow a = 4`)  (vì  #mi(`a > 2`) ). Khi đó  #mi(`b = 6`) . Diện tích nhỏ nhất là  #mi(`S = \frac{1}{2} \cdot 4 \cdot 6 = 12`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa thể tích hình hộp:] Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt bốn góc tấm nhôm bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`)  với  #mi(`0 < x < 6`) , rồi gập tấm nhôm lại để thành cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chiều cao của hộp là  #mi(`x`) , đáy của hộp là hình vuông có cạnh  #mi(`12 - 2x`) . Thể tích của hộp là  #mi(`V(x) = x(12 - 2x)^2`)  với  #mi(`0 < x < 6`) . Ta có  #mi(`V'(x) = (12 - 2x)^2 + x \cdot 2(12 - 2x)(-2) = (12 - 2x)(12 - 6x)`) . Cho  #mi(`V'(x) = 0`)  ta được  #mi(`x = 6`)  (loại) hoặc  #mi(`x = 2`)  (nhận). Lập bảng biến thiên, ta thấy hàm số đạt giá trị lớn nhất tại  #mi(`x = 2`) . Vậy thể tích lớn nhất của hộp là  #mi(`V(2) = 2(12 - 4)^2 = 128\text{ cm}^3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa chi phí sản xuất vật thể hình học:] Một hộp chữ nhật không nắp có đáy là hình vuông cạnh  #mi(`x`) , chiều cao  #mi(`h`) , thể tích bằng  #mi(`8`) . Chi phí làm đáy gấp  #mi(`2`)  lần chi phí làm mặt bên. Tìm kích thước của hộp để chi phí sản xuất là nhỏ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thể tích  #mi(`V = x^2 h = 8 \Rightarrow h = \frac{8}{x^2}`) . Chi phí sản xuất  #mi(`C(x) = 2x^2 + 4xh = 2x^2 + 4x \cdot \frac{8}{x^2} = 2x^2 + \frac{32}{x}`)  với  #mi(`x > 0`) . Ta có  #mi(`C'(x) = 4x - \frac{32}{x^2}`) . Cho  #mi(`C'(x) = 0 \Leftrightarrow 4x^3 = 32 \Leftrightarrow x^3 = 8 \Leftrightarrow x = 2`) . Lập bảng biến thiên, hàm số đạt giá trị nhỏ nhất tại  #mi(`x = 2`) . Khi đó  #mi(`h = \frac{8}{4} = 2`) . Vậy hộp có đáy là hình vuông cạnh  #mi(`2`)  và chiều cao  #mi(`2`)  thì chi phí sản xuất nhỏ nhất.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tối ưu hóa diện tích tam giác:] Cho điểm  #mi(`A(3;2)`) . Một đường thẳng đi qua  #mi(`A`)  cắt các tia  #mi(`Ox, Oy`)  lần lượt tại  #mi(`B`)  và  #mi(`C`) . Tìm diện tích nhỏ nhất của tam giác  #mi(`OBC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giả sử  #mi(`B(a;0)`)  và  #mi(`C(0;b)`)  với  #mi(`a > 3, b > 2`) . Phương trình đường thẳng  #mi(`BC`)  là  #mi(`\frac{x}{a} + \frac{y}{b} = 1`) . Vì  #mi(`A(3;2)`)  thuộc  #mi(`BC`)  nên  #mi(`\frac{3}{a} + \frac{2}{b} = 1 \Rightarrow b = \frac{2a}{a - 3}`) . Diện tích tam giác  #mi(`OBC`)  là  #mi(`S = \frac{1}{2}ab = \frac{1}{2}a \cdot \frac{2a}{a - 3} = \frac{a^2}{a - 3}`) . Ta có  #mi(`S' = \frac{2a(a - 3) - a^2}{(a - 3)^2} = \frac{a^2 - 6a}{(a - 3)^2}`) . Cho  #mi(`S' = 0 \Rightarrow a = 6`)  (vì  #mi(`a > 3`) ). Khi đó  #mi(`b = 4`) . Diện tích nhỏ nhất là  #mi(`S = \frac{1}{2} \cdot 6 \cdot 4 = 12`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tối ưu hóa trong vật lý (Lực căng dây):] Một vật có trọng lượng  #mi(`P = 60\text{ N}`)  được treo bởi ba sợi dây đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{F}_1, \vec{F}_2, \vec{F}_3`)  là các lực căng của ba sợi dây. Do ba sợi dây đôi một vuông góc và có độ dài bằng nhau nên  #mi(`|\vec{F}_1| = |\vec{F}_2| = |\vec{F}_3| = T`) . Hợp lực của ba lực căng cân bằng với trọng lực  #mi(`\vec{P}`) , tức là  #mi(`\vec{F}_1 + \vec{F}_2 + \vec{F}_3 + \vec{P} = \vec{0}`) . Độ lớn hợp lực của ba lực căng là  #mi(`|\vec{F}_1 + \vec{F}_2 + \vec{F}_3| = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Do đó  #mi(`T\sqrt{3} = P = 60 \Rightarrow T = \frac{60}{\sqrt{3}} = 20\sqrt{3}\text{ N}`) . Vậy độ lớn lực căng của mỗi sợi dây là  #mi(`20\sqrt{3}\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một tấm nhôm hình vuông cạnh  #mi(`16\text{ cm}`) . Người ta cắt bốn góc tấm nhôm bốn hình vuông bằng nhau cạnh  #mi(`x\text{ (cm)}`)  với  #mi(`0 < x < 8`) , rồi gập tấm nhôm lại để thành cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chiều cao của hộp là  #mi(`x`) , đáy của hộp là hình vuông có cạnh  #mi(`16 - 2x`) . Thể tích của hộp là  #mi(`V(x) = x(16 - 2x)^2`)  với  #mi(`0 < x < 8`) . Ta có  #mi(`V'(x) = (16 - 2x)^2 + x \cdot 2(16 - 2x)(-2) = (16 - 2x)(16 - 6x)`) . Cho  #mi(`V'(x) = 0`)  ta được  #mi(`x = 8`)  (loại) hoặc  #mi(`x = \frac{8}{3}`)  (nhận). Lập bảng biến thiên, hàm số đạt giá trị lớn nhất tại  #mi(`x = \frac{8}{3}`) . Vậy thể tích lớn nhất của hộp là  #mi(`V\left(\frac{8}{3}\right) = \frac{8}{3}\left(16 - \frac{16}{3}\right)^2 = \frac{8}{3} \cdot \left(\frac{32}{3}\right)^2 = \frac{8192}{27}\text{ cm}^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một tấm nhôm hình vuông cạnh  #mi(`20\text{ cm}`) . Người ta cắt bốn góc tấm nhôm bốn hình vuông bằng nhau cạnh  #mi(`x\text{ (cm)}`)  với  #mi(`0 < x < 10`) , rồi gập tấm nhôm lại để thành cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chiều cao của hộp là  #mi(`x`) , đáy của hộp là hình vuông có cạnh  #mi(`20 - 2x`) . Thể tích của hộp là  #mi(`V(x) = x(20 - 2x)^2`)  với  #mi(`0 < x < 10`) . Ta có  #mi(`V'(x) = (20 - 2x)^2 + x \cdot 2(20 - 2x)(-2) = (20 - 2x)(20 - 6x)`) . Cho  #mi(`V'(x) = 0`)  ta được  #mi(`x = 10`)  (loại) hoặc  #mi(`x = \frac{10}{3}`)  (nhận). Lập bảng biến thiên, hàm số đạt giá trị lớn nhất tại  #mi(`x = \frac{10}{3}`) . Vậy thể tích lớn nhất của hộp là  #mi(`V\left(\frac{10}{3}\right) = \frac{10}{3}\left(20 - \frac{20}{3}\right)^2 = \frac{10}{3} \cdot \left(\frac{40}{3}\right)^2 = \frac{16000}{27}\text{ cm}^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một hộp chữ nhật không nắp có đáy là hình vuông cạnh  #mi(`x`) , chiều cao  #mi(`h`) , thể tích bằng  #mi(`32`) . Chi phí làm đáy gấp  #mi(`3`)  lần chi phí làm mặt bên. Tìm kích thước của hộp để chi phí sản xuất là nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thể tích  #mi(`V = x^2 h = 32 \Rightarrow h = \frac{32}{x^2}`) . Chi phí sản xuất  #mi(`C(x) = 3x^2 + 4xh = 3x^2 + 4x \cdot \frac{32}{x^2} = 3x^2 + \frac{128}{x}`)  với  #mi(`x > 0`) . Ta có  #mi(`C'(x) = 6x - \frac{128}{x^2}`) . Cho  #mi(`C'(x) = 0 \Leftrightarrow 6x^3 = 128 \Leftrightarrow x^3 = \frac{64}{3} \Leftrightarrow x = \frac{4}{\sqrt[3]{3}}`) . Lập bảng biến thiên, hàm số đạt giá trị nhỏ nhất tại  #mi(`x = \frac{4}{\sqrt[3]{3}}`) . Khi đó  #mi(`h = \frac{32}{\left(\frac{4}{\sqrt[3]{3}}\right)^2} = \frac{32}{\frac{16}{\sqrt[3]{9}}} = 2\sqrt[3]{9}`) . Vậy hộp có đáy là hình vuông cạnh  #mi(`\frac{4}{\sqrt[3]{3}}`)  và chiều cao  #mi(`2\sqrt[3]{9}`)  thì chi phí sản xuất nhỏ nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho điểm  #mi(`A(2;1)`) . Một đường thẳng đi qua  #mi(`A`)  cắt các tia  #mi(`Ox, Oy`)  lần lượt tại  #mi(`B`)  và  #mi(`C`) . Tìm diện tích nhỏ nhất của tam giác  #mi(`OBC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Giả sử  #mi(`B(a;0)`)  và  #mi(`C(0;b)`)  với  #mi(`a > 2, b > 1`) . Phương trình đường thẳng  #mi(`BC`)  là  #mi(`\frac{x}{a} + \frac{y}{b} = 1`) . Vì  #mi(`A(2;1)`)  thuộc  #mi(`BC`)  nên  #mi(`\frac{2}{a} + \frac{1}{b} = 1 \Rightarrow b = \frac{a}{a - 2}`) . Diện tích tam giác  #mi(`OBC`)  là  #mi(`S = \frac{1}{2}ab = \frac{1}{2}a \cdot \frac{a}{a - 2} = \frac{a^2}{2(a - 2)}`) . Ta có  #mi(`S' = \frac{1}{2} \cdot \frac{2a(a - 2) - a^2}{(a - 2)^2} = \frac{1}{2} \cdot \frac{a^2 - 4a}{(a - 2)^2}`) . Cho  #mi(`S' = 0 \Rightarrow a = 4`)  (vì  #mi(`a > 2`) ). Khi đó  #mi(`b = 2`) . Diện tích nhỏ nhất là  #mi(`S = \frac{1}{2} \cdot 4 \cdot 2 = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một vật có trọng lượng  #mi(`P = 100\text{ N}`)  được treo bởi ba sợi dây đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{F}_1, \vec{F}_2, \vec{F}_3`)  là các lực căng của ba sợi dây. Do ba sợi dây đôi một vuông góc và có độ dài bằng nhau nên  #mi(`|\vec{F}_1| = |\vec{F}_2| = |\vec{F}_3| = T`) . Hợp lực của ba lực căng cân bằng với trọng lực  #mi(`\vec{P}`) , tức là  #mi(`\vec{F}_1 + \vec{F}_2 + \vec{F}_3 + \vec{P} = \vec{0}`) . Độ lớn hợp lực của ba lực căng là  #mi(`|\vec{F}_1 + \vec{F}_2 + \vec{F}_3| = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Do đó  #mi(`T\sqrt{3} = P = 100 \Rightarrow T = \frac{100}{\sqrt{3}} = \frac{100\sqrt{3}}{3}\text{ N}`) . Vậy độ lớn lực căng của mỗi sợi dây là  #mi(`\frac{100\sqrt{3}}{3}\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Ứng dụng vectơ và hệ tọa độ để giải bài toán cân bằng lực ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Ứng dụng vectơ và hệ tọa độ để giải bài toán cân bằng lực]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điều kiện cân bằng của chất điểm: Tổng các lực tác dụng lên chất điểm bằng vectơ không:  #mi(`\vec{F}_1 + \vec{F}_2 + ... + \vec{F}_n = \vec{0}`) .
  - Phương pháp hình học: Sử dụng quy tắc hình bình hành hoặc đa giác lực để tổng hợp lực. Nếu 3 lực cân bằng, chúng phải đồng phẳng và đồng quy, hợp lực của 2 lực bất kỳ cân bằng với lực thứ 3.
  - Phương pháp tọa độ: Chọn hệ trục tọa độ Oxyz phù hợp, chiếu các vectơ lực lên các trục tọa độ để được hệ phương trình đại số:  #mi(`\sum F_x = 0, \sum F_y = 0, \sum F_z = 0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cân bằng lực: Tổng vectơ lực bằng 0. Chiếu lên trục, giải hệ tìm ẩn. Nhớ kỹ: Hình bình hành cho 2 lực, đa giác cho nhiều lực, hệ tọa độ cho không gian 3 chiều.
  ]
  - *Công thức cốt lõi:* Điều kiện cân bằng của chất điểm dưới dạng vectơ là:  #mi(`\vec{F}_1 + \vec{F}_2 + ... + \vec{F}_n = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật có trọng lượng  #mi(`P = 200\sqrt{3} \, N`)  được treo bởi hai sợi dây giống hệt nhau, mỗi dây hợp với phương thẳng đứng một góc  #mi(`30^\circ`) . Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 200]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`T`)  là độ lớn lực căng của mỗi sợi dây. Vật cân bằng dưới tác dụng của trọng lực  #mi(`\vec{P}`)  và hai lực căng  #mi(`\vec{T}_1, \vec{T}_2`) . Theo điều kiện cân bằng:  #mi(`\vec{P} + \vec{T}_1 + \vec{T}_2 = \vec{0}`) . Chiếu lên phương thẳng đứng:  #mi(`2T\cos 30^\circ = P \Rightarrow 2T \cdot \frac{\sqrt{3}}{2} = 200\sqrt{3} \Rightarrow T\sqrt{3} = 200\sqrt{3} \Rightarrow T = 200 \, N`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật có trọng lượng  #mi(`P = 300 \, N`)  được treo bởi ba sợi dây không dãn, đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 173.2]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`T`)  là độ lớn lực căng của mỗi sợi dây. Ba lực căng đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T\sqrt{3}`) . Vật cân bằng nên  #mi(`T\sqrt{3} = P = 300 \Rightarrow T = \frac{300}{\sqrt{3}} = 100\sqrt{3} \approx 173,2 \, N`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Một vật có trọng lượng  #mi(`P = 500 \, N`)  được giữ cân bằng bởi một lực kéo  #mi(`\vec{F}`)  hợp với phương ngang một góc  #mi(`60^\circ`)  và một lực nén  #mi(`\vec{N}`)  theo phương ngang. Tính độ lớn của lực kéo  #mi(`F`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 577.4]
      \ #text(fill: rgb("#334155"))[Lời giải: Vật cân bằng:  #mi(`\vec{P} + \vec{F} + \vec{N} = \vec{0}`) . Chiếu lên phương thẳng đứng:  #mi(`F\sin 60^\circ = P \Rightarrow F \cdot \frac{\sqrt{3}}{2} = 500 \Rightarrow F = \frac{1000}{\sqrt{3}} \approx 577,4 \, N`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Bài toán treo vật bằng hai sợi dây:] Một vật có trọng lượng  #mi(`P = 100 \, N`)  được treo bởi hai sợi dây không dãn, mỗi dây hợp với phương thẳng đứng một góc lần lượt là  #mi(`30^\circ`)  và  #mi(`60^\circ`) . Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`T_1, T_2`)  lần lượt là độ lớn lực căng của hai sợi dây. Vật cân bằng dưới tác dụng của trọng lực  #mi(`\vec{P}`)  và hai lực căng  #mi(`\vec{T}_1, \vec{T}_2`) . Ta có:  #mi(`\vec{P} + \vec{T}_1 + \vec{T}_2 = \vec{0}`) . Chọn hệ trục tọa độ Oxy với Ox nằm ngang, Oy thẳng đứng hướng lên. Chiếu các lực lên hai trục:
- Theo phương Ox:  #mi(`T_1\sin 30^\circ - T_2\sin 60^\circ = 0 \Rightarrow T_1 \cdot \frac{1}{2} = T_2 \cdot \frac{\sqrt{3}}{2} \Rightarrow T_1 = T_2\sqrt{3}`) .
- Theo phương Oy:  #mi(`T_1\cos 30^\circ + T_2\cos 60^\circ - P = 0 \Rightarrow T_1 \cdot \frac{\sqrt{3}}{2} + T_2 \cdot \frac{1}{2} = 100`) .\nThay  #mi(`T_1 = T_2\sqrt{3}`)  vào phương trình Oy:  #mi(`T_2\sqrt{3} \cdot \frac{\sqrt{3}}{2} + T_2 \cdot \frac{1}{2} = 100 \Rightarrow \frac{3T_2}{2} + \frac{T_2}{2} = 100 \Rightarrow 2T_2 = 100 \Rightarrow T_2 = 50 \, N`) . Suy ra  #mi(`T_1 = 50\sqrt{3} \approx 86,6 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Bài toán treo vật bằng ba sợi dây đối xứng:] Một vật có trọng lượng  #mi(`P = 120 \, N`)  được treo bởi ba sợi dây không dãn, có độ dài bằng nhau, đôi một tạo với nhau một góc  #mi(`120^\circ`)  trong mặt phẳng ngang. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`T`)  là độ lớn lực căng của mỗi sợi dây. Do tính đối xứng, ba lực căng có cùng độ lớn và hợp lực của chúng hướng thẳng đứng lên trên, cân bằng với trọng lực. Gọi  #mi(`\alpha`)  là góc giữa mỗi dây và phương thẳng đứng. Hình chiếu của ba lực căng lên phương thẳng đứng là  #mi(`3T\cos\alpha`) . Vì ba dây đôi một tạo góc  #mi(`120^\circ`)  trong mặt phẳng ngang, góc giữa dây và phương thẳng đứng được xác định bởi  #mi(`\cos\alpha = \frac{1}{\sqrt{3}}`) . Do đó:  #mi(`3T \cdot \frac{1}{\sqrt{3}} = P \Rightarrow T\sqrt{3} = 120 \Rightarrow T = \frac{120}{\sqrt{3}} = 40\sqrt{3} \approx 69,3 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán cân bằng lực trong không gian:] Một vật có trọng lượng  #mi(`P = 200 \, N`)  được treo bởi ba sợi dây không dãn, đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`T_1, T_2, T_3`)  là độ lớn lực căng của ba sợi dây. Do ba dây đôi một vuông góc nên hợp lực của ba lực căng có độ lớn  #mi(`T = \sqrt{T_1^2 + T_2^2 + T_3^2}`) . Vật cân bằng nên  #mi(`T = P = 200 \, N`) . Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T`) . Suy ra  #mi(`T\sqrt{3} = 200 \Rightarrow T = \frac{200}{\sqrt{3}} \approx 115,5 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán kéo vật bằng cần cẩu:] Một vật có trọng lượng  #mi(`P = 1000 \, N`)  được giữ cân bằng bởi một cần cẩu. Dây cáp của cần cẩu hợp với phương thẳng đứng một góc  #mi(`30^\circ`) . Tính độ lớn lực căng của dây cáp và lực nén của cần cẩu lên vật.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{T}`)  là lực căng dây cáp,  #mi(`\vec{N}`)  là lực nén của cần cẩu lên vật. Vật cân bằng:  #mi(`\vec{P} + \vec{T} + \vec{N} = \vec{0}`) . Chọn hệ trục Oxy với Ox nằm ngang, Oy thẳng đứng. Chiếu lên Ox:  #mi(`T\sin 30^\circ - N = 0 \Rightarrow N = T\sin 30^\circ`) . Chiếu lên Oy:  #mi(`T\cos 30^\circ - P = 0 \Rightarrow T = \frac{P}{\cos 30^\circ} = \frac{1000}{\frac{\sqrt{3}}{2}} = \frac{2000}{\sqrt{3}} \approx 1154,7 \, N`) . Suy ra  #mi(`N = T\sin 30^\circ = \frac{2000}{\sqrt{3}} \cdot \frac{1}{2} = \frac{1000}{\sqrt{3}} \approx 577,4 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một vật có trọng lượng  #mi(`P = 80 \, N`)  được treo bởi hai sợi dây không dãn, mỗi dây hợp với phương thẳng đứng một góc lần lượt là  #mi(`45^\circ`)  và  #mi(`45^\circ`) . Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`T`)  là độ lớn lực căng của mỗi sợi dây. Do hai dây hợp với phương thẳng đứng góc bằng nhau nên  #mi(`T_1 = T_2 = T`) . Chiếu lên phương thẳng đứng:  #mi(`2T\cos 45^\circ = P \Rightarrow 2T \cdot \frac{\sqrt{2}}{2} = 80 \Rightarrow T\sqrt{2} = 80 \Rightarrow T = 40\sqrt{2} \approx 56,6 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một vật có trọng lượng  #mi(`P = 60 \, N`)  được treo bởi hai sợi dây không dãn, mỗi dây hợp với phương thẳng đứng một góc lần lượt là  #mi(`30^\circ`)  và  #mi(`60^\circ`) . Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tương tự Ví dụ 1:  #mi(`T_1\sin 30^\circ = T_2\sin 60^\circ \Rightarrow T_1 = T_2\sqrt{3}`) . Phương thẳng đứng:  #mi(`T_1\cos 30^\circ + T_2\cos 60^\circ = 60 \Rightarrow T_2\sqrt{3} \cdot \frac{\sqrt{3}}{2} + T_2 \cdot \frac{1}{2} = 60 \Rightarrow 2T_2 = 60 \Rightarrow T_2 = 30 \, N`) ,  #mi(`T_1 = 30\sqrt{3} \approx 52,0 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một vật có trọng lượng  #mi(`P = 150 \, N`)  được treo bởi ba sợi dây không dãn, đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`T`)  là độ lớn lực căng của mỗi sợi dây. Hợp lực của ba lực căng là  #mi(`T\sqrt{3}`) . Cân bằng với trọng lực:  #mi(`T\sqrt{3} = 150 \Rightarrow T = \frac{150}{\sqrt{3}} = 50\sqrt{3} \approx 86,6 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật có trọng lượng  #mi(`P = 200 \, N`)  được giữ cân bằng bởi một lực kéo  #mi(`\vec{F}`)  hợp với phương ngang một góc  #mi(`45^\circ`)  và một lực nén  #mi(`\vec{N}`)  theo phương ngang. Tính độ lớn của lực kéo  #mi(`F`)  và lực nén  #mi(`N`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vật cân bằng:  #mi(`\vec{P} + \vec{F} + \vec{N} = \vec{0}`) . Chiếu lên phương thẳng đứng:  #mi(`F\sin 45^\circ = P \Rightarrow F \cdot \frac{\sqrt{2}}{2} = 200 \Rightarrow F = 200\sqrt{2} \approx 282,8 \, N`) . Chiếu lên phương ngang:  #mi(`N = F\cos 45^\circ = 200\sqrt{2} \cdot \frac{\sqrt{2}}{2} = 200 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một vật có trọng lượng  #mi(`P = 300 \, N`)  được treo bởi ba sợi dây không dãn, có độ dài bằng nhau, đôi một tạo với nhau một góc  #mi(`120^\circ`)  trong mặt phẳng ngang. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`T`)  là độ lớn lực căng của mỗi sợi dây. Góc giữa mỗi dây và phương thẳng đứng là  #mi(`\alpha`)  với  #mi(`\cos\alpha = \frac{1}{\sqrt{3}}`) . Hình chiếu lên phương thẳng đứng:  #mi(`3T\cos\alpha = P \Rightarrow 3T \cdot \frac{1}{\sqrt{3}} = 300 \Rightarrow T\sqrt{3} = 300 \Rightarrow T = 100\sqrt{3} \approx 173,2 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
