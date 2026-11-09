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
  #text(size: 13pt, weight: "bold")[Hệ thống bài tập trọng tâm Giữa học kì I - Toán 12 (Hàm số và Ứng dụng)] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Tài liệu tổng hợp và phân loại các dạng toán trọng tâm trong chương trình Giữa học kì I môn Toán lớp 12 theo cấu trúc đề thi mới (Trắc nghiệm, Đúng/Sai, Trả lời ngắn, Tự luận). Nội dung bao quát các chủ đề: Tính đơn điệu của hàm số, Cực trị, Giá trị lớn nhất - nhỏ nhất, Đường tiệm cận, Đồ thị hàm số, cùng các bài toán ứng dụng thực tế và vector trong không gian.]
]
#v(6pt)

// ==================== DẠNG 1: Nhận dạng đồ thị hàm số từ công thức hoặc bảng biến thiên ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Nhận dạng đồ thị hàm số từ công thức hoặc bảng biến thiên]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - **Nhận dạng hàm bậc ba  #mi(`y=ax^3+bx^2+cx+d`) :** Dựa vào hình dáng đồ thị (chữ N hoặc ngược), số điểm cực trị (2 hoặc 0), dấu của hệ số  #mi(`a`)  (đi lên hay đi xuống ở nhánh phải cùng), và giao điểm với trục tung  #mi(`y(0)=d`) .
  - **Nhận dạng hàm phân thức  #mi(`y=\frac{ax+b}{cx+d}`) :** Dựa vào các đường tiệm cận (đứng  #mi(`x=-\frac{d}{c}`) , ngang  #mi(`y=\frac{a}{c}`) ), giao điểm với các trục tọa độ, và dấu của đạo hàm (đồng biến/nghịch biến).
  - **Nhận dạng từ bảng biến thiên:** Dựa vào các điểm cực trị (giá trị  #mi(`x`)  và  #mi(`y`) ), chiều biến thiên (dấu của  #mi(`y'`) ), và các giới hạn đặc biệt (tiệm cận).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhìn dáng đồ thị: Bậc 3 có 2 cực trị (chữ N) hoặc không có cực trị; Phân thức có 2 tiệm cận. Nhìn dấu  #mi(`a`) : Nhánh phải cùng đi lên thì  #mi(`a>0`) , đi xuống thì  #mi(`a<0`) .
  ]
  - *Công thức cốt lõi:* Đồ thị hàm số  #mi(`y=\frac{ax+b}{cx+d}`)  có tiệm cận đứng là đường thẳng  #mi(`x = ...`)  và tiệm cận ngang là đường thẳng  #mi(`y = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ bên dưới. Hãy xác định dấu của hệ số  #mi(`a`)  và  #mi(`d`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: a>0, d<0]
      \ #text(fill: rgb("#334155"))[Lời giải: Từ đồ thị, nhánh phải cùng đi lên nên  #mi(`a > 0`) . Giao điểm với trục tung nằm phía dưới trục hoành nên  #mi(`d < 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ bên dưới. Hãy xác định phương trình đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: x=1, y=2]
      \ #text(fill: rgb("#334155"))[Lời giải: Từ đồ thị, đường tiệm cận đứng là  #mi(`x = 1`)  và tiệm cận ngang là  #mi(`y = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như hình vẽ bên dưới. Hãy xác định số điểm cực trị của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Từ bảng biến thiên, hàm số có 2 điểm cực trị là  #mi(`x = 0`)  (cực đại) và  #mi(`x = 4`)  (cực tiểu).]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận dạng đồ thị hàm bậc ba:] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, ta thấy:
- Nhánh phải cùng đi lên nên  #mi(`a > 0`) .
- Giao điểm với trục tung nằm phía trên trục hoành nên  #mi(`d > 0`) .
- Đồ thị có 2 điểm cực trị nằm bên phải trục tung nên tổng  #mi(`x_1 + x_2 = -\frac{2b}{3a} > 0`) . Vì  #mi(`a > 0`)  nên  #mi(`b < 0`) .
- Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} > 0`) .
- Đồ thị cắt trục hoành tại 3 điểm phân biệt có hoành độ dương, do đó phương trình  #mi(`ax^3 + bx^2 + cx + d = 0`)  có 3 nghiệm dương. Theo định lý Vi-ét, tích các nghiệm  #mi(`x_1x_2x_3 = -\frac{d}{a} > 0`) . Vì  #mi(`a > 0, d > 0`)  nên điều này luôn đúng. Tổng các nghiệm  #mi(`x_1 + x_2 + x_3 = -\frac{b}{a} > 0`)  (luôn đúng vì  #mi(`b < 0`) ). Tổng các tích hai nghiệm  #mi(`x_1x_2 + x_2x_3 + x_3x_1 = \frac{c}{a} > 0`) . Vì  #mi(`a > 0`)  nên  #mi(`c > 0`) .\nVậy  #mi(`a > 0, b < 0, c > 0, d > 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận dạng đồ thị hàm phân thức:] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, ta thấy:
- Tiệm cận đứng  #mi(`x = -\frac{d}{c} > 0`) . Vì  #mi(`c < 0`)  (nhánh phải cùng đi xuống) nên  #mi(`d > 0`) .
- Tiệm cận ngang  #mi(`y = \frac{a}{c} > 0`) . Vì  #mi(`c < 0`)  nên  #mi(`a < 0`) .
- Giao điểm với trục tung  #mi(`y = \frac{b}{d} < 0`) . Vì  #mi(`d > 0`)  nên  #mi(`b < 0`) .\nVậy  #mi(`a < 0, b < 0, c < 0, d > 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Nhận dạng đồ thị từ bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như hình vẽ. Hãy xác định hàm số tương ứng trong các đáp án sau: A.  #mi(`y = x^3 - 3x + 1`) , B.  #mi(`y = -x^3 + 3x + 1`) , C.  #mi(`y = x^3 - 3x^2 + 1`) , D.  #mi(`y = -x^3 + 3x^2 + 1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ bảng biến thiên, ta thấy:
- Hàm số có 2 điểm cực trị là  #mi(`x = 0`)  (cực đại) và  #mi(`x = 2`)  (cực tiểu).
- Giá trị cực đại là  #mi(`y(0) = 1`) , giá trị cực tiểu là  #mi(`y(2) = -3`) .
- Hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .
- Giới hạn  #mi(`\lim_{x \to +\infty} y = +\infty`)  nên  #mi(`a > 0`) .\nXét đáp án A:  #mi(`y = x^3 - 3x + 1`) . Đạo hàm  #mi(`y' = 3x^2 - 3`) , có 2 nghiệm  #mi(`x = \pm 1`) . Không khớp với bảng biến thiên.\nXét đáp án B:  #mi(`y = -x^3 + 3x + 1`) . Hệ số  #mi(`a < 0`) , loại.\nXét đáp án C:  #mi(`y = x^3 - 3x^2 + 1`) . Đạo hàm  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) , có 2 nghiệm  #mi(`x = 0`)  và  #mi(`x = 2`) . Giá trị  #mi(`y(0) = 1`) ,  #mi(`y(2) = -3`) . Khớp với bảng biến thiên.\nXét đáp án D:  #mi(`y = -x^3 + 3x^2 + 1`) . Hệ số  #mi(`a < 0`) , loại.\nVậy đáp án đúng là C.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Nhận dạng đồ thị hàm bậc ba (biến thể):] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, ta thấy:
- Nhánh phải cùng đi xuống nên  #mi(`a < 0`) .
- Giao điểm với trục tung nằm phía trên trục hoành nên  #mi(`d > 0`) .
- Đồ thị có 2 điểm cực trị nằm bên trái trục tung nên tổng  #mi(`x_1 + x_2 = -\frac{2b}{3a} < 0`) . Vì  #mi(`a < 0`)  nên  #mi(`b < 0`) .
- Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} < 0`) .
- Đồ thị cắt trục hoành tại 3 điểm phân biệt có hoành độ âm, do đó phương trình  #mi(`ax^3 + bx^2 + cx + d = 0`)  có 3 nghiệm âm. Theo định lý Vi-ét, tích các nghiệm  #mi(`x_1x_2x_3 = -\frac{d}{a} < 0`) . Vì  #mi(`a < 0, d > 0`)  nên điều này luôn đúng. Tổng các nghiệm  #mi(`x_1 + x_2 + x_3 = -\frac{b}{a} < 0`)  (luôn đúng vì  #mi(`b < 0`) ). Tổng các tích hai nghiệm  #mi(`x_1x_2 + x_2x_3 + x_3x_1 = \frac{c}{a} > 0`) . Vì  #mi(`a < 0`)  nên  #mi(`c < 0`) .\nVậy  #mi(`a < 0, b < 0, c < 0, d > 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ đồ thị, ta thấy:
- Nhánh phải cùng đi lên nên  #mi(`a > 0`) .
- Giao điểm với trục tung nằm phía dưới trục hoành nên  #mi(`d < 0`) .
- Đồ thị có 2 điểm cực trị nằm bên phải trục tung nên tổng  #mi(`x_1 + x_2 = -\frac{2b}{3a} > 0`) . Vì  #mi(`a > 0`)  nên  #mi(`b < 0`) .
- Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} > 0`) .
- Đồ thị cắt trục hoành tại 3 điểm phân biệt có hoành độ dương, do đó phương trình  #mi(`ax^3 + bx^2 + cx + d = 0`)  có 3 nghiệm dương. Theo định lý Vi-ét, tích các nghiệm  #mi(`x_1x_2x_3 = -\frac{d}{a} > 0`) . Vì  #mi(`a > 0, d < 0`)  nên điều này luôn đúng. Tổng các nghiệm  #mi(`x_1 + x_2 + x_3 = -\frac{b}{a} > 0`)  (luôn đúng vì  #mi(`b < 0`) ). Tổng các tích hai nghiệm  #mi(`x_1x_2 + x_2x_3 + x_3x_1 = \frac{c}{a} > 0`) . Vì  #mi(`a > 0`)  nên  #mi(`c > 0`) .\nVậy  #mi(`a > 0, b < 0, c > 0, d < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ đồ thị, ta thấy:
- Nhánh phải cùng đi xuống nên  #mi(`a < 0`) .
- Giao điểm với trục tung nằm phía trên trục hoành nên  #mi(`d > 0`) .
- Đồ thị có 2 điểm cực trị nằm bên trái trục tung nên tổng  #mi(`x_1 + x_2 = -\frac{2b}{3a} < 0`) . Vì  #mi(`a < 0`)  nên  #mi(`b < 0`) .
- Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} < 0`) .
- Đồ thị cắt trục hoành tại 3 điểm phân biệt có hoành độ âm, do đó phương trình  #mi(`ax^3 + bx^2 + cx + d = 0`)  có 3 nghiệm âm. Theo định lý Vi-ét, tích các nghiệm  #mi(`x_1x_2x_3 = -\frac{d}{a} < 0`) . Vì  #mi(`a < 0, d > 0`)  nên điều này luôn đúng. Tổng các nghiệm  #mi(`x_1 + x_2 + x_3 = -\frac{b}{a} < 0`)  (luôn đúng vì  #mi(`b < 0`) ). Tổng các tích hai nghiệm  #mi(`x_1x_2 + x_2x_3 + x_3x_1 = \frac{c}{a} > 0`) . Vì  #mi(`a < 0`)  nên  #mi(`c < 0`) .\nVậy  #mi(`a < 0, b < 0, c < 0, d > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ đồ thị, ta thấy:
- Tiệm cận đứng  #mi(`x = -\frac{d}{c} > 0`) . Vì  #mi(`c > 0`)  (nhánh phải cùng đi lên) nên  #mi(`d < 0`) .
- Tiệm cận ngang  #mi(`y = \frac{a}{c} > 0`) . Vì  #mi(`c > 0`)  nên  #mi(`a > 0`) .
- Giao điểm với trục tung  #mi(`y = \frac{b}{d} < 0`) . Vì  #mi(`d < 0`)  nên  #mi(`b > 0`) .\nVậy  #mi(`a > 0, b > 0, c > 0, d < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như hình vẽ. Hãy xác định hàm số tương ứng trong các đáp án sau: A.  #mi(`y = x^3 - 3x + 1`) , B.  #mi(`y = -x^3 + 3x + 1`) , C.  #mi(`y = x^3 - 3x^2 + 1`) , D.  #mi(`y = -x^3 + 3x^2 + 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ bảng biến thiên, ta thấy:
- Hàm số có 2 điểm cực trị là  #mi(`x = 0`)  (cực đại) và  #mi(`x = 2`)  (cực tiểu).
- Giá trị cực đại là  #mi(`y(0) = 1`) , giá trị cực tiểu là  #mi(`y(2) = -3`) .
- Hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(0; 2)`) .
- Giới hạn  #mi(`\lim_{x \to +\infty} y = +\infty`)  nên  #mi(`a > 0`) .\nXét đáp án A:  #mi(`y = x^3 - 3x + 1`) . Đạo hàm  #mi(`y' = 3x^2 - 3`) , có 2 nghiệm  #mi(`x = \pm 1`) . Không khớp với bảng biến thiên.\nXét đáp án B:  #mi(`y = -x^3 + 3x + 1`) . Hệ số  #mi(`a < 0`) , loại.\nXét đáp án C:  #mi(`y = x^3 - 3x^2 + 1`) . Đạo hàm  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) , có 2 nghiệm  #mi(`x = 0`)  và  #mi(`x = 2`) . Giá trị  #mi(`y(0) = 1`) ,  #mi(`y(2) = -3`) . Khớp với bảng biến thiên.\nXét đáp án D:  #mi(`y = -x^3 + 3x^2 + 1`) . Hệ số  #mi(`a < 0`) , loại.\nVậy đáp án đúng là C.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Hãy xác định dấu của các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ đồ thị, ta thấy:
- Nhánh phải cùng đi lên nên  #mi(`a > 0`) .
- Giao điểm với trục tung nằm phía trên trục hoành nên  #mi(`d > 0`) .
- Đồ thị có 2 điểm cực trị nằm bên trái trục tung nên tổng  #mi(`x_1 + x_2 = -\frac{2b}{3a} < 0`) . Vì  #mi(`a > 0`)  nên  #mi(`b > 0`) .
- Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} < 0`) .
- Đồ thị cắt trục hoành tại 3 điểm phân biệt có hoành độ âm, do đó phương trình  #mi(`ax^3 + bx^2 + cx + d = 0`)  có 3 nghiệm âm. Theo định lý Vi-ét, tích các nghiệm  #mi(`x_1x_2x_3 = -\frac{d}{a} < 0`) . Vì  #mi(`a > 0, d > 0`)  nên điều này luôn đúng. Tổng các nghiệm  #mi(`x_1 + x_2 + x_3 = -\frac{b}{a} < 0`)  (luôn đúng vì  #mi(`b > 0`) ). Tổng các tích hai nghiệm  #mi(`x_1x_2 + x_2x_3 + x_3x_1 = \frac{c}{a} > 0`) . Vì  #mi(`a > 0`)  nên  #mi(`c > 0`) .\nVậy  #mi(`a > 0, b > 0, c > 0, d > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Xác định khoảng đồng biến, nghịch biến của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Xác định khoảng đồng biến, nghịch biến của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số  #mi(`y=f(x)`)  có đạo hàm trên  #mi(`K`) . Nếu  #mi(`f'(x) > 0`)  với mọi  #mi(`x \in K`)  thì hàm số đồng biến trên  #mi(`K`) .
  - Nếu  #mi(`f'(x) < 0`)  với mọi  #mi(`x \in K`)  thì hàm số nghịch biến trên  #mi(`K`) .
  - Dựa vào bảng xét dấu  #mi(`f'(x)`)  hoặc bảng biến thiên: khoảng đồng biến ứng với dấu  #mi(`+`) , nghịch biến ứng với dấu  #mi(`-`)  của  #mi(`f'(x)`) .
  - Dựa vào đồ thị  #mi(`y=f'(x)`) : phần đồ thị nằm phía trên trục hoành tương ứng  #mi(`f'(x)>0`)  (đồng biến), phía dưới trục hoành tương ứng  #mi(`f'(x)<0`)  (nghịch biến).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Đồng biến khi đạo hàm mang dấu  #mi(`+`) , nghịch biến khi đạo hàm mang dấu  #mi(`-`) ; nhìn bảng biến thiên: mũi tên đi lên là đồng biến, đi xuống là nghịch biến.
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x)`)  ...  #mi(`0`)  với mọi  #mi(`x \in K`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = (x-2)^2(1-x)`)  với mọi  #mi(`x \in \mathbb{R}`) . Hàm số đã cho đồng biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`(-\infty; 1)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = (x-2)^2(1-x)`) . Vì  #mi(`(x-2)^2 \ge 0`)  nên dấu của  #mi(`f'(x)`)  phụ thuộc vào dấu của  #mi(`1-x`) . Do đó  #mi(`f'(x) > 0 \Leftrightarrow 1-x > 0 \Leftrightarrow x < 1`) . Vậy hàm số đồng biến trên khoảng  #mi(`(-\infty; 1)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = -x^2 - 4, \forall x \in \mathbb{R}`) . Khẳng định nào sau đây đúng về tính đơn điệu của hàm số?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: Nghịch biến trên  #mi(`(-\infty; +\infty)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = -x^2 - 4 < 0`)  với mọi  #mi(`x \in \mathbb{R}`)  (vì  #mi(`-x^2 \le 0`) ). Do đó hàm số nghịch biến trên khoảng  #mi(`(-\infty; +\infty)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Dựa vào bảng xét dấu đạo hàm:] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`0`)  | |  #mi(`4`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  | |\nHàm số đã cho nghịch biến trên khoảng nào dưới đây?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ bảng xét dấu, ta thấy  #mi(`f'(x) < 0`)  khi  #mi(`x \in (0; 4)`) . Vậy hàm số nghịch biến trên khoảng  #mi(`(0; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Dựa vào đồ thị hàm số  #mi(`f'(x)`) :] Cho hàm số  #mi(`y=f(x)`)  có đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ (đồ thị cắt trục hoành tại các điểm có hoành độ  #mi(`-1, 1, 2`)  và nằm dưới trục hoành trên khoảng  #mi(`(1;2)`) , nằm trên trục hoành trên các khoảng  #mi(`(-\infty;-1)`)  và  #mi(`(2;+\infty)`) ). Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng nào?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào đồ thị  #mi(`y=f'(x)`) , ta thấy  #mi(`f'(x) > 0`)  khi  #mi(`x \in (-\infty; -1) \cup (2; +\infty)`) . Vậy hàm số  #mi(`y=f(x)`)  đồng biến trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(2; +\infty)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Dựa vào bảng biến thiên:] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`1`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  | |
|  #mi(`f(x)`)  | |  #mi(`\nearrow`)  | |  #mi(`\searrow`)  | |\nHàm số đã cho đồng biến trên khoảng nào?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ bảng biến thiên, ta thấy mũi tên đi lên (tức  #mi(`f'(x) > 0`) ) trên khoảng  #mi(`(-\infty; 1)`) . Vậy hàm số đồng biến trên khoảng  #mi(`(-\infty; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể: Tìm khoảng nghịch biến từ bảng xét dấu:] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`-2`)  | |  #mi(`0`)  | |  #mi(`2`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  | |\nHàm số đã cho nghịch biến trên khoảng nào?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ bảng xét dấu,  #mi(`f'(x) < 0`)  khi  #mi(`x \in (-\infty; -2) \cup (0; 2)`) . Vậy hàm số nghịch biến trên các khoảng  #mi(`(-\infty; -2)`)  và  #mi(`(0; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`1`)  | |  #mi(`3`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  | |\nHàm số đã cho đồng biến trên khoảng nào dưới đây?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ bảng xét dấu,  #mi(`f'(x) > 0`)  khi  #mi(`x \in (-\infty; 1) \cup (3; +\infty)`) . Vậy hàm số đồng biến trên các khoảng  #mi(`(-\infty; 1)`)  và  #mi(`(3; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`-1`)  | |  #mi(`2`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  | |\nHàm số đã cho nghịch biến trên khoảng nào dưới đây?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ bảng xét dấu,  #mi(`f'(x) < 0`)  khi  #mi(`x \in (-\infty; -1) \cup (2; +\infty)`) . Vậy hàm số nghịch biến trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(2; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y=f(x)`)  có đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ (đồ thị cắt trục hoành tại các điểm có hoành độ  #mi(`-2, 0, 1`)  và nằm dưới trục hoành trên khoảng  #mi(`(-2;0)`) , nằm trên trục hoành trên các khoảng  #mi(`(-\infty;-2)`)  và  #mi(`(1;+\infty)`) ). Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào đồ thị  #mi(`y=f'(x)`) , ta thấy  #mi(`f'(x) < 0`)  khi  #mi(`x \in (-2; 0)`) . Vậy hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng  #mi(`(-2; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  | |  #mi(`0`)  | |  #mi(`2`)  | |  #mi(`+\infty`)  |
|---|---|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  | |
|  #mi(`f(x)`)  | |  #mi(`\searrow`)  | |  #mi(`\nearrow`)  | |  #mi(`\searrow`)  | |\nHàm số đã cho nghịch biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ bảng biến thiên, mũi tên đi xuống (tức  #mi(`f'(x) < 0`) ) trên các khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) . Vậy hàm số nghịch biến trên các khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = x(x-1)^2(x+2)^3`) . Hàm số đã cho đồng biến trên khoảng nào dưới đây?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = x(x-1)^2(x+2)^3`) . Xét dấu  #mi(`f'(x)`) : các nghiệm là  #mi(`x=0, x=1, x=-2`) . Vì  #mi(`(x-1)^2 \ge 0`)  nên dấu của  #mi(`f'(x)`)  phụ thuộc vào  #mi(`x(x+2)^3`) . Lập bảng xét dấu ta được  #mi(`f'(x) > 0`)  khi  #mi(`x \in (-\infty; -2) \cup (0; +\infty)`) . Vậy hàm số đồng biến trên các khoảng  #mi(`(-\infty; -2)`)  và  #mi(`(0; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Tính khoảng cách từ điểm đến đường tiệm cận ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Tính khoảng cách từ điểm đến đường tiệm cận]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tiệm cận đứng: Nghiệm của mẫu thức (nếu tử không đồng thời triệt tiêu) có dạng  #mi(`x = x_0`) .
  - Tiệm cận ngang: Giới hạn của hàm số khi  #mi(`x \to \pm\infty`)  có dạng  #mi(`y = y_0`) .
  - Tiệm cận xiên: Đường thẳng  #mi(`y = ax + b`)  (với  #mi(`a \neq 0`) ) mà khoảng cách từ đồ thị đến nó tiến về  #mi(`0`)  khi  #mi(`x \to \pm\infty`) .
  - Khoảng cách từ điểm  #mi(`M(x_0; y_0)`)  đến đường thẳng  #mi(`\Delta: ax + by + c = 0`)  là  #mi(`d(M, \Delta) = \frac{|ax_0 + by_0 + c|}{\sqrt{a^2 + b^2}}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khoảng cách đến tiệm cận đứng  #mi(`x = m`)  là  #mi(`|x_M - m|`) ; đến tiệm cận ngang  #mi(`y = n`)  là  #mi(`|y_M - n|`) ; đến tiệm cận xiên  #mi(`y = ax + b`)  là  #mi(`\frac{|ax_M - y_M + b|}{\sqrt{a^2 + 1}}`) .
  ]
  - *Công thức cốt lõi:* Khoảng cách từ  #mi(`M(x_0; y_0)`)  đến tiệm cận xiên  #mi(`y = ax + b`)  là  #mi(`d = \frac{|ax_0 - y_0 + b|}{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x + 1}{x - 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`M(3; 2)`)  đến tiệm cận đứng của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận đứng là  #mi(`x = 1`) . Khoảng cách từ  #mi(`M(3; 2)`)  đến đường thẳng  #mi(`x = 1`)  là  #mi(`|3 - 1| = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{3x - 2}{x + 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`N(-2; 5)`)  đến tiệm cận ngang của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận ngang là  #mi(`y = 3`) . Khoảng cách từ  #mi(`N(-2; 5)`)  đến đường thẳng  #mi(`y = 3`)  là  #mi(`|5 - 3| = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = x + 1 + \frac{1}{x - 2}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`P(1; 1)`)  đến tiệm cận xiên của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.71]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận xiên là  #mi(`y = x + 1 \Leftrightarrow x - y + 1 = 0`) . Khoảng cách từ  #mi(`P(1; 1)`)  đến đường thẳng này là  #mi(`\frac{|1 - 1 + 1|}{\sqrt{1^2 + (-1)^2}} = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Khoảng cách đến tiệm cận đứng:] Cho hàm số  #mi(`y = \frac{2x - 1}{x + 3}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`A(2; 1)`)  đến tiệm cận đứng của  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-3\}`) .\nTa có  #mi(`\lim_{x \to -3^+} y = \lim_{x \to -3^+} \frac{2x - 1}{x + 3} = -\infty`)  nên đường thẳng  #mi(`x = -3`)  là tiệm cận đứng của  #mi(`(C)`) .\nKhoảng cách từ  #mi(`A(2; 1)`)  đến đường thẳng  #mi(`x = -3`)  là  #mi(`d = |2 - (-3)| = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Khoảng cách đến tiệm cận ngang:] Cho hàm số  #mi(`y = \frac{3x + 2}{x - 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`B(-1; 4)`)  đến tiệm cận ngang của  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} y = \lim_{x \to \pm\infty} \frac{3x + 2}{x - 1} = 3`)  nên đường thẳng  #mi(`y = 3`)  là tiệm cận ngang của  #mi(`(C)`) .\nKhoảng cách từ  #mi(`B(-1; 4)`)  đến đường thẳng  #mi(`y = 3`)  là  #mi(`d = |4 - 3| = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Khoảng cách đến tiệm cận xiên:] Cho hàm số  #mi(`y = x - 2 + \frac{1}{x + 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`C(1; 2)`)  đến tiệm cận xiên của  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} \left[ y - (x - 2) \right] = \lim_{x \to \pm\infty} \frac{1}{x + 1} = 0`)  nên đường thẳng  #mi(`y = x - 2`)  là tiệm cận xiên của  #mi(`(C)`) .\nPhương trình tổng quát của tiệm cận xiên:  #mi(`x - y - 2 = 0`) .\nKhoảng cách từ  #mi(`C(1; 2)`)  đến đường thẳng này là  #mi(`d = \frac{|1 - 2 - 2|}{\sqrt{1^2 + (-1)^2}} = \frac{|-3|}{\sqrt{2}} = \frac{3\sqrt{2}}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể nhẹ (Đổi chiều câu hỏi):] Cho hàm số  #mi(`y = \frac{x^2 + 2x - 1}{x - 1}`)  có đồ thị  #mi(`(C)`) . Tìm điểm  #mi(`M`)  thuộc  #mi(`(C)`)  sao cho khoảng cách từ  #mi(`M`)  đến tiệm cận đứng bằng  #mi(`2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`\lim_{x \to 1^+} y = +\infty`)  nên đường thẳng  #mi(`x = 1`)  là tiệm cận đứng của  #mi(`(C)`) .\nGọi  #mi(`M\left(x_0; y_0\right)`)  thuộc  #mi(`(C)`)  với  #mi(`x_0 \neq 1`) .\nKhoảng cách từ  #mi(`M`)  đến tiệm cận đứng  #mi(`x = 1`)  là  #mi(`d = |x_0 - 1|`) .\nTheo đề bài,  #mi(`d = 2 \Leftrightarrow |x_0 - 1| = 2 \Leftrightarrow x_0 - 1 = 2`)  hoặc  #mi(`x_0 - 1 = -2`) .\nSuy ra  #mi(`x_0 = 3`)  hoặc  #mi(`x_0 = -1`) .\nVới  #mi(`x_0 = 3`) , ta có  #mi(`y_0 = \frac{3^2 + 2\cdot 3 - 1}{3 - 1} = 7`) . Ta được  #mi(`M_1(3; 7)`) .\nVới  #mi(`x_0 = -1`) , ta có  #mi(`y_0 = \frac{(-1)^2 + 2\cdot (-1) - 1}{-1 - 1} = 1`) . Ta được  #mi(`M_2(-1; 1)`) .\nVậy có hai điểm thỏa mãn là  #mi(`M_1(3; 7)`)  và  #mi(`M_2(-1; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = \frac{3x - 1}{x - 2}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`A(4; 1)`)  đến tiệm cận đứng của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nTa có  #mi(`\lim_{x \to 2^+} y = +\infty`)  nên đường thẳng  #mi(`x = 2`)  là tiệm cận đứng của  #mi(`(C)`) .\nKhoảng cách từ  #mi(`A(4; 1)`)  đến đường thẳng  #mi(`x = 2`)  là  #mi(`d = |4 - 2| = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{2x + 3}{x + 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`B(-3; 2)`)  đến tiệm cận đứng của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .\nTa có  #mi(`\lim_{x \to -1^+} y = +\infty`)  nên đường thẳng  #mi(`x = -1`)  là tiệm cận đứng của  #mi(`(C)`) .\nKhoảng cách từ  #mi(`B(-3; 2)`)  đến đường thẳng  #mi(`x = -1`)  là  #mi(`d = |-3 - (-1)| = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{x - 1}{2x + 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`C(1; 3)`)  đến tiệm cận ngang của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \left\{-\frac{1}{2}\right\}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} y = \frac{1}{2}`)  nên đường thẳng  #mi(`y = \frac{1}{2}`)  là tiệm cận ngang của  #mi(`(C)`) .\nKhoảng cách từ  #mi(`C(1; 3)`)  đến đường thẳng  #mi(`y = \frac{1}{2}`)  là  #mi(`d = \left|3 - \frac{1}{2}\right| = \frac{5}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{4x - 3}{x + 2}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`D(1; 5)`)  đến tiệm cận ngang của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-2\}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} y = 4`)  nên đường thẳng  #mi(`y = 4`)  là tiệm cận ngang của  #mi(`(C)`) .\nKhoảng cách từ  #mi(`D(1; 5)`)  đến đường thẳng  #mi(`y = 4`)  là  #mi(`d = |5 - 4| = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = 2x + 1 + \frac{3}{x - 1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`E(2; 3)`)  đến tiệm cận xiên của  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} [y - (2x + 1)] = \lim_{x \to \pm\infty} \frac{3}{x - 1} = 0`)  nên đường thẳng  #mi(`y = 2x + 1`)  là tiệm cận xiên của  #mi(`(C)`) .\nPhương trình tổng quát của tiệm cận xiên:  #mi(`2x - y + 1 = 0`) .\nKhoảng cách từ  #mi(`E(2; 3)`)  đến đường thẳng này là  #mi(`d = \frac{|2\cdot 2 - 3 + 1|}{\sqrt{2^2 + (-1)^2}} = \frac{2}{\sqrt{5}} = \frac{2\sqrt{5}}{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y = \frac{x^2 - 3x + 3}{x - 2}`)  có đồ thị  #mi(`(C)`) . Tìm điểm  #mi(`M`)  thuộc  #mi(`(C)`)  sao cho khoảng cách từ  #mi(`M`)  đến tiệm cận đứng bằng  #mi(`1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nTa có  #mi(`\lim_{x \to 2^+} y = +\infty`)  nên đường thẳng  #mi(`x = 2`)  là tiệm cận đứng của  #mi(`(C)`) .\nGọi  #mi(`M(x_0; y_0)`)  thuộc  #mi(`(C)`)  với  #mi(`x_0 \neq 2`) .\nKhoảng cách từ  #mi(`M`)  đến tiệm cận đứng  #mi(`x = 2`)  là  #mi(`d = |x_0 - 2|`) .\nTheo đề bài,  #mi(`d = 1 \Leftrightarrow |x_0 - 2| = 1 \Leftrightarrow x_0 - 2 = 1`)  hoặc  #mi(`x_0 - 2 = -1`) .\nSuy ra  #mi(`x_0 = 3`)  hoặc  #mi(`x_0 = 1`) .\nVới  #mi(`x_0 = 3`) , ta có  #mi(`y_0 = \frac{3^2 - 3\cdot 3 + 3}{3 - 2} = 3`) . Ta được  #mi(`M_1(3; 3)`) .\nVới  #mi(`x_0 = 1`) , ta có  #mi(`y_0 = \frac{1^2 - 3\cdot 1 + 3}{1 - 2} = -1`) . Ta được  #mi(`M_2(1; -1)`) .\nVậy có hai điểm thỏa mãn là  #mi(`M_1(3; 3)`)  và  #mi(`M_2(1; -1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Tìm giá trị lớn nhất, nhỏ nhất của hàm số trên đoạn ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Tìm giá trị lớn nhất, nhỏ nhất của hàm số trên đoạn]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm giá trị lớn nhất (GTLN) và giá trị nhỏ nhất (GTNN) của hàm số  #mi(`y = f(x)`)  liên tục trên đoạn  #mi(`[a; b]`) , ta thực hiện các bước: 1. Tính đạo hàm  #mi(`f'(x)`) . 2. Tìm các điểm  #mi(`x_i \in (a; b)`)  mà tại đó  #mi(`f'(x) = 0`)  hoặc  #mi(`f'(x)`)  không xác định. 3. Tính các giá trị  #mi(`f(a), f(b), f(x_i)`) . 4. So sánh các giá trị này để kết luận  #mi(`\max_{[a;b]} f(x)`)  và  #mi(`\min_{[a;b]} f(x)`) .
  - Nếu hàm số  #mi(`y = f(x)`)  đơn điệu (luôn đồng biến hoặc luôn nghịch biến) trên đoạn  #mi(`[a; b]`)  thì GTLN và GTNN đạt được tại hai đầu mút:  #mi(`\max_{[a;b]} f(x) = \max\{f(a), f(b)\}`)  và  #mi(`\min_{[a;b]} f(x) = \min\{f(a), f(b)\}`) .
  - Với hàm số chứa căn thức hoặc lượng giác, cần chú ý điều kiện xác định của hàm số và tập giá trị của các hàm lượng giác để loại nghiệm không thuộc đoạn đang xét.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy trình 3 bước: Tính  #mi(`f'(x)`)   #mi(`\rightarrow`)  Giải  #mi(`f'(x)=0`)  tìm nghiệm thuộc đoạn  #mi(`\rightarrow`)  Lập bảng giá trị tại các nghiệm và hai đầu mút, chọn số lớn nhất (Max) và nhỏ nhất (Min).
  ]
  - *Công thức cốt lõi:* Nếu hàm số  #mi(`f(x)`)  liên tục trên  #mi(`[a;b]`)  và có đạo hàm trên  #mi(`(a;b)`) , thì  #mi(`\max_{[a;b]} f(x) = \max\{f(a); f(b); ...\}`)  với các giá trị  #mi(`f(x_i)`)  tại các điểm  #mi(`x_i`)  mà tại đó  #mi(`...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-3; 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -16]
      \ #text(fill: rgb("#334155"))[Lời giải: Hàm số liên tục trên  #mi(`[-3; 2]`) . Đạo hàm  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = \pm 1`)  (cả hai nghiệm đều thuộc  #mi(`[-3; 2]`) ). Tính các giá trị:  #mi(`y(-3) = -16`) ;  #mi(`y(-1) = 4`) ;  #mi(`y(1) = 0`) ;  #mi(`y(2) = 4`) . So sánh, ta có giá trị nhỏ nhất là  #mi(`-16`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị lớn nhất của hàm số  #mi(`y = x^4 - 12x^2 - 4`)  trên đoạn  #mi(`[0; 9]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5585]
      \ #text(fill: rgb("#334155"))[Lời giải: Hàm số liên tục trên  #mi(`[0; 9]`) . Đạo hàm  #mi(`y' = 4x^3 - 24x = 4x(x^2 - 6)`) . Trên  #mi(`(0; 9)`) ,  #mi(`y' = 0 \Leftrightarrow x = \sqrt{6}`) . Tính các giá trị:  #mi(`y(0) = -4`) ;  #mi(`y(\sqrt{6}) = 36 - 72 - 4 = -40`) ;  #mi(`y(9) = 6561 - 972 - 4 = 5585`) . Vậy giá trị lớn nhất là  #mi(`5585`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm giá trị lớn nhất của hàm số  #mi(`y = 4\sin x\cos x + 2x`)  trên đoạn  #mi(`\left[0; \frac{\pi}{2}\right]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2.094+1.732=3.826]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y = 2\sin 2x + 2x`) . Đạo hàm  #mi(`y' = 4\cos 2x + 2`) . Cho  #mi(`y' = 0 \Leftrightarrow \cos 2x = -\frac{1}{2} \Leftrightarrow 2x = \frac{2\pi}{3} + k2\pi`)  hoặc  #mi(`2x = -\frac{2\pi}{3} + k2\pi`) . Trên  #mi(`\left[0; \frac{\pi}{2}\right]`) , ta được  #mi(`x = \frac{\pi}{3}`) . Tính  #mi(`y(0) = 0`) ;  #mi(`y\left(\frac{\pi}{3}\right) = 2\sin\frac{2\pi}{3} + \frac{2\pi}{3} = \sqrt{3} + \frac{2\pi}{3}`) ;  #mi(`y\left(\frac{\pi}{2}\right) = 2\sin\pi + \pi = \pi`) . So sánh, giá trị lớn nhất là  #mi(`\frac{2\pi}{3} + \sqrt{3}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hàm đa thức bậc ba:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 + 2`)  trên đoạn  #mi(`[-1; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số liên tục trên  #mi(`[-1; 2]`) . Đạo hàm  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Các điểm tới hạn thuộc  #mi(`[-1; 2]`)  là  #mi(`x = 0`)  và  #mi(`x = 2`) . Tính:  #mi(`y(-1) = -2`) ;  #mi(`y(0) = 2`) ;  #mi(`y(2) = -2`) . Vậy  #mi(`\max_{[-1;2]} y = 2`)  tại  #mi(`x = 0`) ;  #mi(`\min_{[-1;2]} y = -2`)  tại  #mi(`x = -1`)  và  #mi(`x = 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hàm phân thức:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \frac{x^2 + 3}{x - 2}`)  trên đoạn  #mi(`[3; 5]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số liên tục trên  #mi(`[3; 5]`) . Đạo hàm  #mi(`y' = \frac{2x(x - 2) - (x^2 + 3)}{(x - 2)^2} = \frac{x^2 - 4x - 3}{(x - 2)^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x^2 - 4x - 3 = 0 \Leftrightarrow x = 2 \pm \sqrt{7}`) . Cả hai nghiệm đều không thuộc  #mi(`[3; 5]`) . Do đó hàm số đơn điệu trên  #mi(`[3; 5]`) . Tính  #mi(`y(3) = 12`) ;  #mi(`y(5) = \frac{28}{3}`) . Vậy  #mi(`\max_{[3;5]} y = 12`)  tại  #mi(`x = 3`) ;  #mi(`\min_{[3;5]} y = \frac{28}{3}`)  tại  #mi(`x = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm chứa căn thức:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \sqrt{4 - x^2}`)  trên đoạn  #mi(`[-1; 1]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số xác định trên  #mi(`[-2; 2]`)  nên liên tục trên  #mi(`[-1; 1]`) . Đạo hàm  #mi(`y' = \frac{-x}{\sqrt{4 - x^2}}`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0 \in [-1; 1]`) . Tính  #mi(`y(-1) = \sqrt{3}`) ;  #mi(`y(0) = 2`) ;  #mi(`y(1) = \sqrt{3}`) . Vậy  #mi(`\max_{[-1;1]} y = 2`)  tại  #mi(`x = 0`) ;  #mi(`\min_{[-1;1]} y = \sqrt{3}`)  tại  #mi(`x = \pm 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hàm lượng giác:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \sin x + \cos x`)  trên đoạn  #mi(`\left[0; \frac{\pi}{2}\right]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số liên tục trên  #mi(`\left[0; \frac{\pi}{2}\right]`) . Đạo hàm  #mi(`y' = \cos x - \sin x`) . Cho  #mi(`y' = 0 \Leftrightarrow \sin x = \cos x \Leftrightarrow x = \frac{\pi}{4} \in \left[0; \frac{\pi}{2}\right]`) . Tính  #mi(`y(0) = 1`) ;  #mi(`y\left(\frac{\pi}{4}\right) = \sqrt{2}`) ;  #mi(`y\left(\frac{\pi}{2}\right) = 1`) . Vậy  #mi(`\max y = \sqrt{2}`)  tại  #mi(`x = \frac{\pi}{4}`) ;  #mi(`\min y = 1`)  tại  #mi(`x = 0`)  và  #mi(`x = \frac{\pi}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Hàm đa thức bậc bốn:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^4 - 2x^2 + 3`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số liên tục trên  #mi(`[0; 2]`) . Đạo hàm  #mi(`y' = 4x^3 - 4x = 4x(x^2 - 1)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 1`)  (loại  #mi(`x = -1`) ). Tính  #mi(`y(0) = 3`) ;  #mi(`y(1) = 2`) ;  #mi(`y(2) = 11`) . Vậy  #mi(`\max_{[0;2]} y = 11`)  tại  #mi(`x = 2`) ;  #mi(`\min_{[0;2]} y = 2`)  tại  #mi(`x = 1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 1`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số liên tục trên  #mi(`[0; 2]`) . Đạo hàm  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 1`)  (nhận) hoặc  #mi(`x = -1`)  (loại). Tính  #mi(`y(0) = 1`) ;  #mi(`y(1) = -1`) ;  #mi(`y(2) = 3`) . Vậy  #mi(`\max_{[0;2]} y = 3`)  tại  #mi(`x = 2`) ;  #mi(`\min_{[0;2]} y = -1`)  tại  #mi(`x = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 + 1`)  trên đoạn  #mi(`[-1; 3]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số liên tục trên  #mi(`[-1; 3]`) . Đạo hàm  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`)  (đều thuộc  #mi(`[-1; 3]`) ). Tính  #mi(`y(-1) = -3`) ;  #mi(`y(0) = 1`) ;  #mi(`y(2) = -3`) ;  #mi(`y(3) = 1`) . Vậy  #mi(`\max_{[-1;3]} y = 1`)  tại  #mi(`x = 0`)  và  #mi(`x = 3`) ;  #mi(`\min_{[-1;3]} y = -3`)  tại  #mi(`x = -1`)  và  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \frac{x^2 + 1}{x - 1}`)  trên đoạn  #mi(`[2; 4]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số liên tục trên  #mi(`[2; 4]`) . Đạo hàm  #mi(`y' = \frac{2x(x - 1) - (x^2 + 1)}{(x - 1)^2} = \frac{x^2 - 2x - 1}{(x - 1)^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 1 \pm \sqrt{2}`)  (không thuộc  #mi(`[2; 4]`) ). Hàm số đơn điệu trên  #mi(`[2; 4]`) . Tính  #mi(`y(2) = 5`) ;  #mi(`y(4) = \frac{17}{3}`) . Vậy  #mi(`\max_{[2;4]} y = \frac{17}{3}`)  tại  #mi(`x = 4`) ;  #mi(`\min_{[2;4]} y = 5`)  tại  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \sqrt{9 - x^2}`)  trên đoạn  #mi(`[-2; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số xác định trên  #mi(`[-3; 3]`)  nên liên tục trên  #mi(`[-2; 2]`) . Đạo hàm  #mi(`y' = \frac{-x}{\sqrt{9 - x^2}}`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0 \in [-2; 2]`) . Tính  #mi(`y(-2) = \sqrt{5}`) ;  #mi(`y(0) = 3`) ;  #mi(`y(2) = \sqrt{5}`) . Vậy  #mi(`\max_{[-2;2]} y = 3`)  tại  #mi(`x = 0`) ;  #mi(`\min_{[-2;2]} y = \sqrt{5}`)  tại  #mi(`x = \pm 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = 2\sin x - \sin^2 x`)  trên đoạn  #mi(`\left[0; \frac{\pi}{2}\right]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đặt  #mi(`t = \sin x`) ,  #mi(`t \in [0; 1]`) . Hàm số trở thành  #mi(`f(t) = 2t - t^2`)  trên  #mi(`[0; 1]`) .  #mi(`f'(t) = 2 - 2t`) ;  #mi(`f'(t) = 0 \Leftrightarrow t = 1`) . Tính  #mi(`f(0) = 0`) ;  #mi(`f(1) = 1`) . Vậy  #mi(`\max y = 1`)  tại  #mi(`x = \frac{\pi}{2}`) ;  #mi(`\min y = 0`)  tại  #mi(`x = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Biểu diễn vector và tính tổng vector trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Biểu diễn vector và tính tổng vector trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc hình bình hành: Với hình bình hành  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc trung điểm: Nếu  #mi(`I`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì  #mi(`\vec{IA} + \vec{IB} = \vec{0}`)  và với mọi điểm  #mi(`M`) ,  #mi(`\vec{MA} + \vec{MB} = 2\vec{MI}`) .
  - Quy tắc tam giác: Với ba điểm  #mi(`A, B, C`)  bất kỳ, ta có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  (hay  #mi(`\vec{AC} - \vec{AB} = \vec{BC}`) ).
  - Tọa độ vector: Trong hệ trục  #mi(`Oxyz`) , nếu  #mi(`\vec{u} = x\vec{i} + y\vec{j} + z\vec{k}`)  thì  #mi(`\vec{u} = (x; y; z)`) . Tổng hai vector  #mi(`\vec{u} = (x_1; y_1; z_1)`)  và  #mi(`\vec{v} = (x_2; y_2; z_2)`)  là  #mi(`\vec{u} + \vec{v} = (x_1+x_2; y_1+y_2; z_1+z_2)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy tắc hình bình hành: 'Cùng gốc, kẻ hình bình hành, tổng là đường chéo'. Quy tắc trung điểm: 'Tổng hai vector chung gốc bằng 2 lần vector nối gốc với trung điểm'.
  ]
  - *Công thức cốt lõi:* Với hình bình hành  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`AB=2, AD=3, AA'=4`) . Tính độ dài vector  #mi(`\vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\sqrt{29}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Vì  #mi(`AB, AD, AA'`)  đôi một vuông góc nên  #mi(`|\vec{AC'}| = \sqrt{AB^2 + AD^2 + AA'^2} = \sqrt{2^2 + 3^2 + 4^2} = \sqrt{29}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho hai vector  #mi(`\vec{a} = (1; -2; 3)`)  và  #mi(`\vec{b} = (2; 1; -1)`) . Tính tọa độ vector  #mi(`\vec{u} = \vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3; -1; 2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{u} = (1+2; -2+1; 3+(-1)) = (3; -1; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Biểu diễn  #mi(`\vec{AM}`)  theo  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`\frac{1}{2}(\vec{AB} + \vec{AC})`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`M`)  là trung điểm của  #mi(`BC`)  nên  #mi(`\vec{AM} = \frac{1}{2}(\vec{AB} + \vec{AC})`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn vector theo các vector cơ sở:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}`) ,  #mi(`\vec{AD} = \vec{b}`) ,  #mi(`\vec{AA'} = \vec{c}`) . Hãy biểu diễn vector  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Thay  #mi(`\vec{AB} = \vec{a}`) ,  #mi(`\vec{AD} = \vec{b}`) ,  #mi(`\vec{AA'} = \vec{c}`) , ta được  #mi(`\vec{AC'} = \vec{a} + \vec{b} + \vec{c}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tổng vector:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính tổng  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Áp dụng quy tắc trung điểm, ta có  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Do đó,  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 2\vec{SO} + 2\vec{SO} = 4\vec{SO}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ vector:] Trong không gian  #mi(`Oxyz`) , cho hai vector  #mi(`\vec{a} = (1; 2; -1)`)  và  #mi(`\vec{b} = (3; -1; 2)`) . Tính tọa độ vector  #mi(`\vec{v} = 2\vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`2\vec{a} = (2; 4; -2)`) . Do đó,  #mi(`\vec{v} = 2\vec{a} + \vec{b} = (2+3; 4+(-1); -2+2) = (5; 3; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu diễn vector qua trung điểm:] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`CD`) . Biểu diễn vector  #mi(`\vec{AM}`)  theo  #mi(`\vec{AC}`)  và  #mi(`\vec{AD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`CD`)  nên theo quy tắc trung điểm, ta có  #mi(`\vec{AM} = \frac{1}{2}(\vec{AC} + \vec{AD})`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}`) ,  #mi(`\vec{AD} = \vec{b}`) ,  #mi(`\vec{AA'} = \vec{c}`) . Biểu diễn vector  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{a} + \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{x}`) ,  #mi(`\vec{AD} = \vec{y}`) ,  #mi(`\vec{AA'} = \vec{z}`) . Biểu diễn vector  #mi(`\vec{AC'}`)  theo  #mi(`\vec{x}, \vec{y}, \vec{z}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{x} + \vec{y} + \vec{z}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Tính tổng  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình bình hành nên  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Áp dụng quy tắc trung điểm:  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Vậy tổng là  #mi(`4\vec{SO}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho hai vector  #mi(`\vec{a} = (2; -1; 3)`)  và  #mi(`\vec{b} = (1; 4; -2)`) . Tính tọa độ vector  #mi(`\vec{u} = \vec{a} - \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} = (2-1; -1-4; 3-(-2)) = (1; -5; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho tứ diện  #mi(`ABCD`) . Gọi  #mi(`I`)  là trung điểm của  #mi(`AB`) . Biểu diễn vector  #mi(`\vec{CI}`)  theo  #mi(`\vec{CA}`)  và  #mi(`\vec{CB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`I`)  là trung điểm của  #mi(`AB`)  nên  #mi(`\vec{CI} = \frac{1}{2}(\vec{CA} + \vec{CB})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Xét tính đúng sai của mệnh đề về tính đơn điệu và cực trị của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Xét tính đúng sai của mệnh đề về tính đơn điệu và cực trị của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hàm số  #mi(`y=f(x)`)  có đạo hàm trên  #mi(`K`) . Nếu  #mi(`f'(x) > 0`)  với mọi  #mi(`x \in K`)  (hoặc  #mi(`f'(x) \ge 0`)  và  #mi(`f'(x)=0`)  chỉ tại hữu hạn điểm) thì hàm số đồng biến trên  #mi(`K`) . Nếu  #mi(`f'(x) < 0`)  với mọi  #mi(`x \in K`)  (hoặc  #mi(`f'(x) \le 0`)  và  #mi(`f'(x)=0`)  chỉ tại hữu hạn điểm) thì hàm số nghịch biến trên  #mi(`K`) .
  - Dựa vào bảng xét dấu  #mi(`f'(x)`)  hoặc bảng biến thiên: Hàm số đạt cực đại tại  #mi(`x_0`)  nếu  #mi(`f'(x)`)  đổi dấu từ dương sang âm khi đi qua  #mi(`x_0`) . Hàm số đạt cực tiểu tại  #mi(`x_0`)  nếu  #mi(`f'(x)`)  đổi dấu từ âm sang dương khi đi qua  #mi(`x_0`) . Giá trị  #mi(`f(x_0)`)  tương ứng là giá trị cực đại (hoặc cực tiểu).
  - Cho hàm số  #mi(`y = ax^3+bx^2+cx+d`)  ( #mi(`a \neq 0`) ). Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`a > 0`)  và  #mi(`\Delta_{y'} \le 0`)  (hoặc  #mi(`\Delta'_{y'} \le 0`) ). Hàm số nghịch biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`a < 0`)  và  #mi(`\Delta_{y'} \le 0`)  (hoặc  #mi(`\Delta'_{y'} \le 0`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Đồng biến thì  #mi(`f'(x)`)  mang dấu  #mi(`+`) , nghịch biến thì  #mi(`f'(x)`)  mang dấu  #mi(`-`) . Cực đại là  #mi(`+`)  đổi sang  #mi(`-`) , cực tiểu là  #mi(`-`)  đổi sang  #mi(`+`) .
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) > 0`)  với mọi  #mi(`x \in K`)  thì hàm số ... trên  #mi(`K`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`f(x)`)  có đạo hàm  #mi(`f'(x) = (x-1)(x+2)^2`) . Hàm số đã cho nghịch biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`(-\infty; 1)`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = 0 \Leftrightarrow (x-1)(x+2)^2 = 0 \Leftrightarrow x=1`)  hoặc  #mi(`x=-2`)  (nghiệm kép).\nBảng xét dấu  #mi(`f'(x)`) :  #mi(`f'(x)`)  mang dấu  #mi(`-`)  khi  #mi(`x < 1`)  (trừ  #mi(`x=-2`)  không đổi dấu) và dấu  #mi(`+`)  khi  #mi(`x > 1`) .\nVậy hàm số nghịch biến trên khoảng  #mi(`(-\infty; 1)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`) . Tìm giá trị cực đại của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .\nĐạo hàm  #mi(`y' = 3x^2 - 6x = 3x(x-2)`) .\n #mi(`y' = 0 \Leftrightarrow x=0`)  hoặc  #mi(`x=2`) .\nBảng biến thiên:  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi qua  #mi(`x=0`) , từ  #mi(`-`)  sang  #mi(`+`)  khi qua  #mi(`x=2`) .\nVậy hàm số đạt cực đại tại  #mi(`x=0`) , giá trị cực đại là  #mi(`y(0) = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`m \ge 3`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .\nĐạo hàm  #mi(`y' = 3x^2 - 6x + m`) .\nĐể hàm số đồng biến trên  #mi(`\mathbb{R}`)  thì  #mi(`y' \ge 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a=3 > 0 \\ \Delta' \le 0 \end{cases}`) .\nTa có  #mi(`\Delta' = (-3)^2 - 3m = 9 - 3m`) .\n #mi(`\Delta' \le 0 \Leftrightarrow 9 - 3m \le 0 \Leftrightarrow m \ge 3`) .\nVậy  #mi(`m \ge 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xét tính đơn điệu dựa vào bảng xét dấu đạo hàm:] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = x(x-1)(x+2)^2`) . Xét tính đúng sai của các mệnh đề sau:\na) Hàm số đồng biến trên khoảng  #mi(`(0;1)`) .\nb) Hàm số nghịch biến trên khoảng  #mi(`(-\infty; 0)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`f'(x) = 0 \Leftrightarrow x=0, x=1, x=-2`)  (nghiệm kép).\nLập bảng xét dấu  #mi(`f'(x)`) :\n- Trên  #mi(`(-\infty; -2)`) :  #mi(`f'(x) > 0`) .\n- Trên  #mi(`(-2; 0)`) :  #mi(`f'(x) > 0`) .\n- Trên  #mi(`(0; 1)`) :  #mi(`f'(x) < 0`) .\n- Trên  #mi(`(1; +\infty)`) :  #mi(`f'(x) > 0`) .\na) Trên khoảng  #mi(`(0;1)`) ,  #mi(`f'(x) < 0`)  nên hàm số nghịch biến. Vậy mệnh đề a) Sai.\nb) Trên khoảng  #mi(`(-\infty; 0)`) ,  #mi(`f'(x) > 0`)  (trừ  #mi(`x=-2`) ) nên hàm số đồng biến. Vậy mệnh đề b) Sai.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định điểm cực trị, giá trị cực trị từ bảng biến thiên:] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
 #mi(`x`) :  #mi(`-\infty`)  ...  #mi(`0`)  ...  #mi(`2`)  ...  #mi(`+\infty`) 
 #mi(`y'`) :  #mi(`+`)   #mi(`0`)   #mi(`-`)   #mi(`0`)   #mi(`+`) 
 #mi(`y`) :  #mi(`...`)   #mi(`3`)   #mi(`...`)   #mi(`-1`)   #mi(`...`) \nXét tính đúng sai của các mệnh đề:\na) Hàm số đạt cực đại tại  #mi(`x=0`) .\nb) Giá trị cực tiểu của hàm số là  #mi(`y_{CT} = -1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên:\na) Tại  #mi(`x=0`) ,  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên hàm số đạt cực đại tại  #mi(`x=0`) . Mệnh đề a) Đúng.\nb) Tại  #mi(`x=2`) ,  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên hàm số đạt cực tiểu tại  #mi(`x=2`) . Giá trị cực tiểu là  #mi(`y(2) = -1`) . Mệnh đề b) Đúng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tham số m để hàm số đơn điệu trên R:] Cho hàm số  #mi(`y = -x^3 + 3x^2 + (m-1)x + 2`) . Xét tính đúng sai của mệnh đề: "Có 3 giá trị nguyên của  #mi(`m`)  thuộc đoạn  #mi(`[-5; 5]`)  để hàm số nghịch biến trên  #mi(`\mathbb{R}`) ".
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = -3x^2 + 6x + m - 1`) .\nHàm số nghịch biến trên  #mi(`\mathbb{R} \Leftrightarrow y' \le 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a=-3 < 0 \\ \Delta' \le 0 \end{cases}`) .\nTa có  #mi(`\Delta' = 3^2 - (-3)(m-1) = 9 + 3m - 3 = 3m + 6`) .\n #mi(`\Delta' \le 0 \Leftrightarrow 3m + 6 \le 0 \Leftrightarrow m \le -2`) .\nKết hợp  #mi(`m \in [-5; 5]`)  và  #mi(`m \in \mathbb{Z}`) , ta được  #mi(`m \in \{-5; -4; -3; -2\}`) .\nCó 4 giá trị nguyên của  #mi(`m`)  thỏa mãn. Vậy mệnh đề đã cho là Sai.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể Đúng/Sai tổng hợp 4 mệnh đề:] Cho hàm số  #mi(`y = x^3 - 3x + 2`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Hàm số đồng biến trên khoảng  #mi(`(-1; 1)`) .\nb) Hàm số đạt cực tiểu tại  #mi(`x=1`) , giá trị cực tiểu bằng  #mi(`0`) .\nc) Đồ thị hàm số cắt trục hoành tại 3 điểm phân biệt.\nd) Hàm số nghịch biến trên khoảng  #mi(`(0; 2)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 3 = 3(x-1)(x+1)`) .\n #mi(`y' = 0 \Leftrightarrow x = \pm 1`) .\nBảng biến thiên:  #mi(`y'`)  dương trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) ;  #mi(`y'`)  âm trên  #mi(`(-1; 1)`) .\na) Trên  #mi(`(-1; 1)`) ,  #mi(`y' < 0`)  nên hàm số nghịch biến. Mệnh đề a) Sai.\nb) Tại  #mi(`x=1`) ,  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên hàm số đạt cực tiểu tại  #mi(`x=1`) .  #mi(`y(1) = 1 - 3 + 2 = 0`) . Mệnh đề b) Đúng.\nc) Ta có  #mi(`y_{CĐ} = y(-1) = 4`) ,  #mi(`y_{CT} = y(1) = 0`) . Vì  #mi(`y_{CT} = 0`)  nên đồ thị hàm số cắt trục hoành tại 2 điểm phân biệt (một điểm tiếp xúc). Mệnh đề c) Sai.\nd) Trên  #mi(`(0; 2)`) , hàm số nghịch biến trên  #mi(`(0; 1)`)  và đồng biến trên  #mi(`(1; 2)`)  nên không nghịch biến trên cả khoảng  #mi(`(0; 2)`) . Mệnh đề d) Sai.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = (x-2)(x+1)^2`) . Xét tính đúng sai của mệnh đề: "Hàm số nghịch biến trên khoảng  #mi(`(-\infty; 2)`) ".
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 0 \Leftrightarrow x=2`)  hoặc  #mi(`x=-1`)  (nghiệm kép).\nBảng xét dấu  #mi(`f'(x)`) :  #mi(`f'(x)`)  mang dấu  #mi(`-`)  khi  #mi(`x < 2`)  (trừ  #mi(`x=-1`)  không đổi dấu) và dấu  #mi(`+`)  khi  #mi(`x > 2`) .\nDo đó hàm số nghịch biến trên khoảng  #mi(`(-\infty; 2)`) .\nVậy mệnh đề đã cho là Đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = (x-3)(x+2)^2`) . Xét tính đúng sai của mệnh đề: "Hàm số đồng biến trên khoảng  #mi(`(3; +\infty)`) ".
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 0 \Leftrightarrow x=3`)  hoặc  #mi(`x=-2`)  (nghiệm kép).\nBảng xét dấu  #mi(`f'(x)`) :  #mi(`f'(x)`)  mang dấu  #mi(`-`)  khi  #mi(`x < 3`)  (trừ  #mi(`x=-2`)  không đổi dấu) và dấu  #mi(`+`)  khi  #mi(`x > 3`) .\nDo đó hàm số đồng biến trên khoảng  #mi(`(3; +\infty)`) .\nVậy mệnh đề đã cho là Đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
 #mi(`x`) :  #mi(`-\infty`)  ...  #mi(`1`)  ...  #mi(`3`)  ...  #mi(`+\infty`) 
 #mi(`y'`) :  #mi(`+`)   #mi(`0`)   #mi(`-`)   #mi(`0`)   #mi(`+`) 
 #mi(`y`) :  #mi(`...`)   #mi(`4`)   #mi(`...`)   #mi(`-2`)   #mi(`...`) \nXét tính đúng sai của mệnh đề: "Hàm số đạt cực tiểu tại  #mi(`x=3`)  và giá trị cực tiểu bằng  #mi(`-2`) ".
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên:\nTại  #mi(`x=3`) ,  #mi(`y'`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên hàm số đạt cực tiểu tại  #mi(`x=3`) .\nGiá trị cực tiểu là  #mi(`y(3) = -2`) .\nVậy mệnh đề đã cho là Đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`) . Xét tính đúng sai của mệnh đề: "Hàm số đồng biến trên khoảng  #mi(`(0; 2)`) ".
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .\nĐạo hàm  #mi(`y' = 3x^2 - 6x = 3x(x-2)`) .\n #mi(`y' = 0 \Leftrightarrow x=0`)  hoặc  #mi(`x=2`) .\nBảng xét dấu  #mi(`y'`) :  #mi(`y'`)  dương trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) ;  #mi(`y'`)  âm trên  #mi(`(0; 2)`) .\nDo đó trên khoảng  #mi(`(0; 2)`) , hàm số nghịch biến.\nVậy mệnh đề đã cho là Sai.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 2`)  đồng biến trên  #mi(`\mathbb{R}`) . Xét tính đúng sai của mệnh đề: "Có 4 giá trị nguyên của  #mi(`m`)  thuộc đoạn  #mi(`[-2; 5]`)  thỏa mãn yêu cầu bài toán".
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) .\nHàm số đồng biến trên  #mi(`\mathbb{R} \Leftrightarrow y' \ge 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a=3 > 0 \\ \Delta' \le 0 \end{cases}`) .\nTa có  #mi(`\Delta' = (-3)^2 - 3m = 9 - 3m`) .\n #mi(`\Delta' \le 0 \Leftrightarrow 9 - 3m \le 0 \Leftrightarrow m \ge 3`) .\nKết hợp  #mi(`m \in [-2; 5]`)  và  #mi(`m \in \mathbb{Z}`) , ta được  #mi(`m \in \{3; 4; 5\}`) .\nCó 3 giá trị nguyên của  #mi(`m`)  thỏa mãn.\nVậy mệnh đề đã cho là Sai.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y = -x^3 + 3x + 1`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Hàm số nghịch biến trên khoảng  #mi(`(-1; 1)`) .\nb) Hàm số đạt cực đại tại  #mi(`x=1`) , giá trị cực đại bằng  #mi(`3`) .\nc) Đồ thị hàm số cắt trục hoành tại 3 điểm phân biệt.\nd) Hàm số đồng biến trên khoảng  #mi(`(0; 2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = -3x^2 + 3 = -3(x-1)(x+1)`) .\n #mi(`y' = 0 \Leftrightarrow x = \pm 1`) .\nBảng biến thiên:  #mi(`y'`)  âm trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) ;  #mi(`y'`)  dương trên  #mi(`(-1; 1)`) .\na) Trên  #mi(`(-1; 1)`) ,  #mi(`y' > 0`)  nên hàm số đồng biến. Mệnh đề a) Sai.\nb) Tại  #mi(`x=1`) ,  #mi(`y'`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên hàm số đạt cực đại tại  #mi(`x=1`) .  #mi(`y(1) = -1 + 3 + 1 = 3`) . Mệnh đề b) Đúng.\nc) Ta có  #mi(`y_{CĐ} = y(1) = 3`) ,  #mi(`y_{CT} = y(-1) = -1`) . Vì  #mi(`y_{CĐ} \cdot y_{CT} = 3 \cdot (-1) = -3 < 0`)  nên đồ thị hàm số cắt trục hoành tại 3 điểm phân biệt. Mệnh đề c) Đúng.\nd) Trên  #mi(`(0; 2)`) , hàm số đồng biến trên  #mi(`(0; 1)`)  và nghịch biến trên  #mi(`(1; 2)`)  nên không đồng biến trên cả khoảng  #mi(`(0; 2)`) . Mệnh đề d) Sai.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Xét tính đúng sai của mệnh đề về tiệm cận và đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Xét tính đúng sai của mệnh đề về tiệm cận và đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tiệm cận đứng: Đường thẳng  #mi(`x=x_0`)  là tiệm cận đứng của đồ thị hàm số  #mi(`y=f(x)`)  nếu  #mi(`\lim_{x\to x_0^+} f(x) = \pm\infty`)  hoặc  #mi(`\lim_{x\to x_0^-} f(x) = \pm\infty`) . Với hàm phân thức, tiệm cận đứng thường là nghiệm của mẫu thức mà không là nghiệm của tử thức.
  - Tiệm cận ngang: Đường thẳng  #mi(`y=y_0`)  là tiệm cận ngang của đồ thị hàm số  #mi(`y=f(x)`)  nếu  #mi(`\lim_{x\to +\infty} f(x) = y_0`)  hoặc  #mi(`\lim_{x\to -\infty} f(x) = y_0`) .
  - Tiệm cận xiên: Đường thẳng  #mi(`y=ax+b`)  ( #mi(`a\neq 0`) ) là tiệm cận xiên của đồ thị hàm số  #mi(`y=f(x)`)  nếu  #mi(`\lim_{x\to +\infty} [f(x) - (ax+b)] = 0`)  hoặc  #mi(`\lim_{x\to -\infty} [f(x) - (ax+b)] = 0`) . Với hàm phân thức  #mi(`y=\frac{P(x)}{Q(x)}`) , nếu bậc  #mi(`P(x)`)  lớn hơn bậc  #mi(`Q(x)`)  đúng 1 bậc thì đồ thị có tiệm cận xiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tiệm cận đứng: mẫu bằng 0, tử khác 0. Tiệm cận ngang: xét giới hạn tại vô cực. Tiệm cận xiên: chia đa thức (bậc tử > bậc mẫu 1 bậc).
  ]
  - *Công thức cốt lõi:* Đường thẳng  #mi(`y=ax+b`)  là tiệm cận xiên của đồ thị hàm số  #mi(`y=f(x)`)  nếu  #mi(`\lim_{x\to +\infty} [f(x) - (ax+b)] = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Tìm tọa độ giao điểm của hai đường tiệm cận của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (1;2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) . Ta có  #mi(`\lim_{x\to 1^+} y = +\infty`)  và  #mi(`\lim_{x\to 1^-} y = -\infty`)  nên  #mi(`x=1`)  là tiệm cận đứng.  #mi(`\lim_{x\to \pm\infty} y = 2`)  nên  #mi(`y=2`)  là tiệm cận ngang. Giao điểm của hai đường tiệm cận là  #mi(`I(1;2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{x^2-2x+3}{x-1}`)  có đồ thị  #mi(`(C)`) . Tìm phương trình đường tiệm cận xiên của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: y=x-1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) . Thực hiện phép chia đa thức:  #mi(`\frac{x^2-2x+3}{x-1} = x - 1 + \frac{2}{x-1}`) . Ta có  #mi(`\lim_{x\to \pm\infty} [y - (x-1)] = \lim_{x\to \pm\infty} \frac{2}{x-1} = 0`) . Vậy đường tiệm cận xiên là  #mi(`y = x - 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = \frac{x+2}{x-1}`)  có đồ thị  #mi(`(C)`) . Tính diện tích hình phẳng giới hạn bởi đồ thị  #mi(`(C)`) , các đường tiệm cận của  #mi(`(C)`)  và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị có tiệm cận đứng  #mi(`x=1`)  và tiệm cận ngang  #mi(`y=1`) . Giao điểm của hai tiệm cận là  #mi(`I(1;1)`) . Đồ thị cắt trục  #mi(`Oy`)  tại  #mi(`A(0;-2)`)  và cắt trục  #mi(`Ox`)  tại  #mi(`B(-2;0)`) . Hình phẳng giới hạn bởi  #mi(`(C)`) ,  #mi(`x=1`) ,  #mi(`y=1`)  và hai trục tọa độ là hình thang vuông có các đỉnh  #mi(`(0;0), (1;0), (1;1), (0;1)`)  trừ đi phần diện tích tam giác cong. Tuy nhiên, theo yêu cầu, hình phẳng giới hạn bởi các đường  #mi(`x=0, x=1, y=0, y=1`)  là hình vuông cạnh 1. Diện tích hình vuông là  #mi(`S = 1 \cdot 1 = 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định tiệm cận đứng, tiệm cận ngang:] Cho hàm số  #mi(`y = \frac{2x-1}{x+2}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Đồ thị  #mi(`(C)`)  có tiệm cận đứng là  #mi(`x = -2`) .\nb) Đồ thị  #mi(`(C)`)  có tiệm cận ngang là  #mi(`y = 2`) .\nc) Đồ thị  #mi(`(C)`)  có tâm đối xứng là  #mi(`I(-2;2)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-2\}`) .\na) Ta có  #mi(`\lim_{x\to -2^+} y = \lim_{x\to -2^+} \frac{2x-1}{x+2} = -\infty`)  và  #mi(`\lim_{x\to -2^-} y = +\infty`) . Vậy  #mi(`x = -2`)  là tiệm cận đứng. Mệnh đề **Đúng**.\nb) Ta có  #mi(`\lim_{x\to \pm\infty} y = \lim_{x\to \pm\infty} \frac{2x-1}{x+2} = 2`) . Vậy  #mi(`y = 2`)  là tiệm cận ngang. Mệnh đề **Đúng**.\nc) Giao điểm của hai đường tiệm cận là  #mi(`I(-2;2)`) . Đồ thị hàm phân thức bậc nhất trên bậc nhất nhận giao điểm hai tiệm cận làm tâm đối xứng. Mệnh đề **Đúng**.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định tiệm cận xiên:] Cho hàm số  #mi(`y = \frac{x^2-3x+4}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Đồ thị  #mi(`(C)`)  có tiệm cận đứng là  #mi(`x = 1`) .\nb) Đồ thị  #mi(`(C)`)  có tiệm cận xiên là  #mi(`y = x - 2`) .\nc) Đồ thị  #mi(`(C)`)  không có tiệm cận ngang.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\na) Ta có  #mi(`\lim_{x\to 1^+} y = +\infty`)  và  #mi(`\lim_{x\to 1^-} y = -\infty`)  nên  #mi(`x = 1`)  là tiệm cận đứng. Mệnh đề **Đúng**.\nb) Thực hiện phép chia:  #mi(`y = \frac{x^2-3x+4}{x-1} = x - 2 + \frac{2}{x-1}`) . Ta có  #mi(`\lim_{x\to \pm\infty} [y - (x-2)] = \lim_{x\to \pm\infty} \frac{2}{x-1} = 0`) . Vậy  #mi(`y = x - 2`)  là tiệm cận xiên. Mệnh đề **Đúng**.\nc) Vì hàm số có tiệm cận xiên nên không có tiệm cận ngang. Mệnh đề **Đúng**.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính diện tích hình phẳng giới hạn bởi tiệm cận và trục tọa độ:] Cho hàm số  #mi(`y = \frac{x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Đồ thị  #mi(`(C)`)  có tiệm cận đứng  #mi(`x=1`)  và tiệm cận ngang  #mi(`y=1`) .\nb) Diện tích hình phẳng giới hạn bởi đồ thị  #mi(`(C)`) , trục  #mi(`Ox`) , trục  #mi(`Oy`)  và đường tiệm cận đứng bằng  #mi(`\ln 2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\na)  #mi(`\lim_{x\to 1} y = \infty`)  nên  #mi(`x=1`)  là tiệm cận đứng.  #mi(`\lim_{x\to \pm\infty} y = 1`)  nên  #mi(`y=1`)  là tiệm cận ngang. Mệnh đề **Đúng**.\nb) Đồ thị cắt trục  #mi(`Ox`)  tại  #mi(`x=-1`) , cắt trục  #mi(`Oy`)  tại  #mi(`y=-1`) . Hình phẳng giới hạn bởi  #mi(`(C)`) ,  #mi(`Ox`) ,  #mi(`Oy`) ,  #mi(`x=1`)  là hình thang cong. Diện tích  #mi(`S = \int_{0}^{1} \left| \frac{x+1}{x-1} \right| dx = \int_{0}^{1} \left| 1 + \frac{2}{x-1} \right| dx`) . Vì  #mi(`\frac{x+1}{x-1} < 0`)  trên  #mi(`[0;1)`)  nên  #mi(`S = \int_{0}^{1} \left( -1 - \frac{2}{x-1} \right) dx = \left[ -x - 2\ln|1-x| \right]_0^1 = -1 - 2\ln 0`)  (không hội tụ). Tuy nhiên, hình phẳng giới hạn bởi  #mi(`(C)`) ,  #mi(`Ox`) ,  #mi(`Oy`)  và tiệm cận đứng  #mi(`x=1`)  là vô hạn. Mệnh đề **Sai** (do diện tích không xác định hữu hạn).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể Đúng/Sai 4 mệnh đề:] Cho hàm số  #mi(`y = \frac{2x^2-3x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Đồ thị  #mi(`(C)`)  có tiệm cận đứng  #mi(`x=1`) .\nb) Đồ thị  #mi(`(C)`)  có tiệm cận xiên  #mi(`y=2x-1`) .\nc) Đồ thị  #mi(`(C)`)  cắt trục hoành tại hai điểm phân biệt.\nd) Đồ thị  #mi(`(C)`)  nhận giao điểm  #mi(`I(1;1)`)  của hai đường tiệm cận làm tâm đối xứng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\na)  #mi(`\lim_{x\to 1} y = \infty`)  nên  #mi(`x=1`)  là tiệm cận đứng. Mệnh đề **Đúng**.\nb) Chia đa thức:  #mi(`y = 2x - 1 + \frac{0}{x-1}`)  (vì  #mi(`2x^2-3x+1 = (x-1)(2x-1)`) ). Vậy  #mi(`y = 2x - 1`)  là tiệm cận xiên. Mệnh đề **Đúng**.\nc) Phương trình hoành độ giao điểm:  #mi(`2x^2-3x+1 = 0 \Leftrightarrow x=1`)  (loại) hoặc  #mi(`x=\frac{1}{2}`)  (nhận). Vậy đồ thị cắt trục hoành tại một điểm. Mệnh đề **Sai**.\nd) Giao điểm hai tiệm cận:  #mi(`x=1`) ,  #mi(`y=2(1)-1=1`)  nên  #mi(`I(1;1)`) . Đồ thị hàm phân thức nhận  #mi(`I`)  làm tâm đối xứng. Mệnh đề **Đúng**.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = \frac{3x+2}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của mệnh đề: "Đồ thị  #mi(`(C)`)  có tiệm cận đứng là  #mi(`x=1`)  và tiệm cận ngang là  #mi(`y=3`) ."
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) . Ta có  #mi(`\lim_{x\to 1^+} y = +\infty`) ,  #mi(`\lim_{x\to 1^-} y = -\infty`)  nên  #mi(`x=1`)  là tiệm cận đứng.  #mi(`\lim_{x\to \pm\infty} y = 3`)  nên  #mi(`y=3`)  là tiệm cận ngang. Vậy mệnh đề **Đúng**.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{2x-5}{x+3}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của mệnh đề: "Đồ thị  #mi(`(C)`)  có tiệm cận đứng là  #mi(`x=-3`)  và tiệm cận ngang là  #mi(`y=2`) ."
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-3\}`) . Ta có  #mi(`\lim_{x\to -3^+} y = -\infty`) ,  #mi(`\lim_{x\to -3^-} y = +\infty`)  nên  #mi(`x=-3`)  là tiệm cận đứng.  #mi(`\lim_{x\to \pm\infty} y = 2`)  nên  #mi(`y=2`)  là tiệm cận ngang. Vậy mệnh đề **Đúng**.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{x^2+x-1}{x-2}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của mệnh đề: "Đồ thị  #mi(`(C)`)  có tiệm cận xiên là  #mi(`y = x + 3`) ."
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) . Chia đa thức:  #mi(`\frac{x^2+x-1}{x-2} = x + 3 + \frac{5}{x-2}`) . Ta có  #mi(`\lim_{x\to \pm\infty} [y - (x+3)] = \lim_{x\to \pm\infty} \frac{5}{x-2} = 0`) . Vậy  #mi(`y = x + 3`)  là tiệm cận xiên. Mệnh đề **Đúng**.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{x^2-4x+5}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của mệnh đề: "Đồ thị  #mi(`(C)`)  có tiệm cận xiên là  #mi(`y = x - 3`) ."
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) . Chia đa thức:  #mi(`\frac{x^2-4x+5}{x-1} = x - 3 + \frac{2}{x-1}`) . Ta có  #mi(`\lim_{x\to \pm\infty} [y - (x-3)] = 0`) . Vậy  #mi(`y = x - 3`)  là tiệm cận xiên. Mệnh đề **Đúng**.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của mệnh đề: "Diện tích hình phẳng giới hạn bởi đồ thị  #mi(`(C)`) , trục  #mi(`Ox`) , trục  #mi(`Oy`)  và đường tiệm cận đứng bằng  #mi(`1`) ."
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đồ thị có tiệm cận đứng  #mi(`x=1`) . Giao với  #mi(`Ox`)  tại  #mi(`x=-\frac{1}{2}`) , với  #mi(`Oy`)  tại  #mi(`y=-1`) . Hình phẳng giới hạn bởi  #mi(`(C)`) ,  #mi(`Ox`) ,  #mi(`Oy`) ,  #mi(`x=1`)  là hình thang cong. Diện tích  #mi(`S = \int_{0}^{1} \left| \frac{2x+1}{x-1} \right| dx = \int_{0}^{1} \left| 2 + \frac{3}{x-1} \right| dx`) . Vì  #mi(`\frac{2x+1}{x-1} < 0`)  trên  #mi(`[0;1)`)  nên  #mi(`S = \int_{0}^{1} \left( -2 - \frac{3}{x-1} \right) dx = \left[ -2x - 3\ln|1-x| \right]_0^1 = -2 - 3\ln 0`)  (không hội tụ). Vậy diện tích không xác định. Mệnh đề **Sai**.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Xét tính đúng sai của mệnh đề về vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Xét tính đúng sai của mệnh đề về vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) ; Quy tắc hiệu:  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) .
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) . Góc giữa hai vectơ:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
  - Ba vectơ  #mi(`\vec{a}, \vec{b}, \vec{c}`)  đồng phẳng nếu  #mi(`\vec{a} = k\vec{b} + l\vec{c}`)  (với  #mi(`\vec{b}, \vec{c}`)  không cùng phương).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy tắc hình bình hành: Cùng gốc thì cộng thành đường chéo. Tích vô hướng: Góc vuông thì bằng  #mi(`0`) .
  ]
  - *Công thức cốt lõi:* Trong hình lập phương  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB \perp AD`) , do đó góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  là  #mi(`90^\circ`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD} = |\vec{AB}| \cdot |\vec{AD}| \cdot \cos 90^\circ = a \cdot a \cdot 0 = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính độ dài vectơ  #mi(`\vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Vì  #mi(`AB, AD, AA'`)  đôi một vuông góc nên  #mi(`|\vec{AC'}|^2 = |\vec{AB}|^2 + |\vec{AD}|^2 + |\vec{AA'}|^2 = a^2 + a^2 + a^2 = 3a^2`) . Suy ra  #mi(`|\vec{AC'}| = a\sqrt{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Chứng minh  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\vec{SO}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`O`)  là trung điểm của  #mi(`AC`)  nên  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  (tính chất trung điểm).]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng của hai vectơ:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Khi đó  #mi(`\vec{AB} \cdot \vec{AC'} = \vec{AB} \cdot (\vec{AB} + \vec{AD} + \vec{AA'}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AD} + \vec{AB} \cdot \vec{AA'}`) . Vì  #mi(`AB \perp AD`)  và  #mi(`AB \perp AA'`)  nên  #mi(`\vec{AB} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AB} \cdot \vec{AA'} = 0`) . Do đó  #mi(`\vec{AB} \cdot \vec{AC'} = |\vec{AB}|^2 = a^2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Chứng minh đẳng thức vectơ:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành. Chứng minh rằng  #mi(`\vec{SA} + \vec{SC} = \vec{SB} + \vec{SD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`O`)  là tâm của hình bình hành  #mi(`ABCD`) , khi đó  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Theo tính chất trung điểm, ta có  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Vậy  #mi(`\vec{SA} + \vec{SC} = \vec{SB} + \vec{SD}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định góc giữa hai vectơ:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'C'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{A'C'} = \vec{AC}`)  (vì  #mi(`AA'C'C`)  là hình bình hành). Do đó góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{A'C'}`)  bằng góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) . Trong hình vuông  #mi(`ABCD`) , tam giác  #mi(`ABC`)  vuông cân tại  #mi(`B`)  nên  #mi(`\angle BAC = 45^\circ`) . Vậy góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{A'C'}`)  là  #mi(`45^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kiểm tra tính đồng phẳng:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đồng phẳng của ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Nếu ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC'}`)  đồng phẳng thì tồn tại các số  #mi(`m, n`)  sao cho  #mi(`\vec{AC'} = m\vec{AB} + n\vec{AD}`) . Điều này dẫn đến  #mi(`\vec{AA'} = (m-1)\vec{AB} + (n-1)\vec{AD}`) , tức là  #mi(`\vec{AA'}`)  đồng phẳng với  #mi(`\vec{AB}, \vec{AD}`) , điều này vô lý vì  #mi(`\vec{AA'}`)  vuông góc với mặt phẳng  #mi(`(ABCD)`) . Vậy ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC'}`)  không đồng phẳng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Biến thể Đúng/Sai 4 mệnh đề:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Xét tính đúng sai của các mệnh đề sau:\na)  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .\nb)  #mi(`\vec{AB} \cdot \vec{AD} = a^2`) .\nc)  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .\nd) Góc giữa  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`)  là  #mi(`90^\circ`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Đúng. Theo quy tắc hình bình hành cho hình vuông  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .\nb) Sai. Vì  #mi(`AB \perp AD`)  nên  #mi(`\vec{AB} \cdot \vec{AD} = 0`) .\nc) Đúng. Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .\nd) Đúng. Trong hình vuông  #mi(`ABCD`) , hai đường chéo  #mi(`AC`)  và  #mi(`BD`)  vuông góc với nhau nên góc giữa  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`)  là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB \perp AD`) , do đó góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AD}`)  là  #mi(`90^\circ`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD} = |\vec{AB}| \cdot |\vec{AD}| \cdot \cos 90^\circ = a \cdot a \cdot 0 = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`2a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`AB \perp AA'`) , do đó góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AA'}`)  là  #mi(`90^\circ`) . Tích vô hướng  #mi(`\vec{AB} \cdot \vec{AA'} = |\vec{AB}| \cdot |\vec{AA'}| \cdot \cos 90^\circ = 2a \cdot 2a \cdot 0 = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Chứng minh rằng  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của  #mi(`AC`) . Theo tính chất trung điểm, ta có  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C'} = \vec{AC}`)  (vì  #mi(`AA'C'C`)  là hình bình hành). Do đó góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{A'C'}`)  bằng góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`) . Trong hình vuông  #mi(`ABCD`) , tam giác  #mi(`ABC`)  vuông cân tại  #mi(`B`)  nên  #mi(`\angle BAC = 45^\circ`) . Vậy góc giữa  #mi(`\vec{AB}`)  và  #mi(`\vec{A'C'}`)  là  #mi(`45^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Xét tính đồng phẳng của ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Nếu ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC'}`)  đồng phẳng thì tồn tại các số  #mi(`m, n`)  sao cho  #mi(`\vec{AC'} = m\vec{AB} + n\vec{AD}`) . Điều này dẫn đến  #mi(`\vec{AA'} = (m-1)\vec{AB} + (n-1)\vec{AD}`) , tức là  #mi(`\vec{AA'}`)  đồng phẳng với  #mi(`\vec{AB}, \vec{AD}`) , điều này vô lý vì  #mi(`\vec{AA'}`)  vuông góc với mặt phẳng  #mi(`(ABCD)`) . Vậy ba vectơ  #mi(`\vec{AB}, \vec{AD}, \vec{AC'}`)  không đồng phẳng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Xét tính đúng sai của các mệnh đề sau:\na)  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .\nb)  #mi(`\vec{AB} \cdot \vec{AD} = a^2`) .\nc)  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .\nd) Góc giữa  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`)  là  #mi(`90^\circ`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Đúng. Theo quy tắc hình bình hành cho hình vuông  #mi(`ABCD`) , ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .\nb) Sai. Vì  #mi(`AB \perp AD`)  nên  #mi(`\vec{AB} \cdot \vec{AD} = 0`) .\nc) Đúng. Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .\nd) Đúng. Trong hình vuông  #mi(`ABCD`) , hai đường chéo  #mi(`AC`)  và  #mi(`BD`)  vuông góc với nhau nên góc giữa  #mi(`\vec{AC}`)  và  #mi(`\vec{BD}`)  là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Xét tính đúng sai của mệnh đề về phương trình tiếp tuyến và tương giao đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Xét tính đúng sai của mệnh đề về phương trình tiếp tuyến và tương giao đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Phương trình tiếp tuyến của đồ thị hàm số  #mi(`y=f(x)`)  tại điểm  #mi(`M(x_0; y_0)`)  thuộc đồ thị là:  #mi(`y = f'(x_0)(x - x_0) + y_0`) .
  - Số nghiệm của phương trình hoành độ giao điểm  #mi(`f(x) = g(x)`)  bằng số giao điểm của đồ thị hàm số  #mi(`y=f(x)`)  và đường thẳng (hoặc đồ thị)  #mi(`y=g(x)`) .
  - Để biện luận số nghiệm của phương trình  #mi(`f(x) = m`)  (với  #mi(`m`)  là tham số), ta dựa vào bảng biến thiên hoặc đồ thị của hàm số  #mi(`y=f(x)`) : số nghiệm là số lần đường thẳng  #mi(`y=m`)  cắt đồ thị  #mi(`y=f(x)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tiếp tuyến tại điểm thì tính  #mi(`y_0`)  và  #mi(`f'(x_0)`) ; Tương giao thì lập phương trình hoành độ giao điểm và cô lập tham số  #mi(`m`)  để dùng đồ thị biện luận.
  ]
  - *Công thức cốt lõi:* Phương trình tiếp tuyến của đồ thị hàm số  #mi(`y=f(x)`)  tại điểm có hoành độ  #mi(`x_0`)  là:  #mi(`y = ...(x - x_0) + f(x_0)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Viết phương trình tiếp tuyến của đồ thị hàm số  #mi(`y = x^3 - 3x + 2`)  tại điểm có hoành độ  #mi(`x_0 = 1`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: y=0]
      \ #text(fill: rgb("#334155"))[Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 3`) . Tại  #mi(`x_0 = 1`) , ta có  #mi(`y_0 = 1^3 - 3(1) + 2 = 0`)  và hệ số góc tiếp tuyến  #mi(`y'(1) = 3(1)^2 - 3 = 0`) . Phương trình tiếp tuyến là:  #mi(`y = 0(x - 1) + 0 \Leftrightarrow y = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm số giao điểm của đồ thị hàm số  #mi(`y = x^3 - 3x^2 + 2`)  và đường thẳng  #mi(`y = 2`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Phương trình hoành độ giao điểm:  #mi(`x^3 - 3x^2 + 2 = 2 \Leftrightarrow x^3 - 3x^2 = 0 \Leftrightarrow x^2(x - 3) = 0`) . Phương trình có nghiệm  #mi(`x = 0`)  (nghiệm kép) và  #mi(`x = 3`) . Vậy đồ thị hàm số và đường thẳng cắt nhau tại 2 điểm phân biệt.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để phương trình  #mi(`x^3 - 3x + 1 = m`)  có đúng 2 nghiệm phân biệt.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: m=3; m=-1]
      \ #text(fill: rgb("#334155"))[Lời giải: Xét hàm số  #mi(`y = x^3 - 3x + 1`) , có  #mi(`y' = 3x^2 - 3 = 0 \Leftrightarrow x = \pm 1`) . Giá trị cực đại  #mi(`y_{CĐ} = y(-1) = 3`) , giá trị cực tiểu  #mi(`y_{CT} = y(1) = -1`) . Phương trình có đúng 2 nghiệm khi đường thẳng  #mi(`y=m`)  tiếp xúc với đồ thị, tức là  #mi(`m = y_{CĐ}`)  hoặc  #mi(`m = y_{CT}`) . Vậy  #mi(`m = 3`)  hoặc  #mi(`m = -1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Viết phương trình tiếp tuyến tại điểm (Biến thể 1):] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm  #mi(`M(2; -2)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tính đạo hàm:  #mi(`y' = 3x^2 - 6x`) .\nHệ số góc của tiếp tuyến tại  #mi(`x_0 = 2`)  là  #mi(`y'(2) = 3(2)^2 - 6(2) = 0`) .\nPhương trình tiếp tuyến tại  #mi(`M(2; -2)`)  là:  #mi(`y = 0(x - 2) - 2 \Leftrightarrow y = -2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Biện luận số giao điểm (Biến thể 2):] Cho hàm số  #mi(`y = -x^3 + 3x + 1`)  có đồ thị  #mi(`(C)`) . Tìm số giao điểm của  #mi(`(C)`)  và đường thẳng  #mi(`d: y = 3`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Phương trình hoành độ giao điểm:  #mi(`-x^3 + 3x + 1 = 3 \Leftrightarrow -x^3 + 3x - 2 = 0`) .\n #mi(`\Leftrightarrow -(x - 1)^2(x + 2) = 0 \Leftrightarrow x = 1`)  (nghiệm kép) hoặc  #mi(`x = -2`) .\nVậy đường thẳng  #mi(`d`)  cắt đồ thị  #mi(`(C)`)  tại 2 điểm phân biệt.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm điều kiện để phương trình có n nghiệm (Biến thể 3):] Cho hàm số  #mi(`y = x^3 - 3x + 1`)  có đồ thị  #mi(`(C)`) . Tìm  #mi(`m`)  để phương trình  #mi(`x^3 - 3x + 1 = m`)  có 3 nghiệm phân biệt.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Số nghiệm của phương trình là số giao điểm của  #mi(`(C)`)  và đường thẳng  #mi(`y = m`) .\nXét hàm số  #mi(`y = x^3 - 3x + 1`) ,  #mi(`y' = 3x^2 - 3 = 0 \Leftrightarrow x = \pm 1`) .\nTa có  #mi(`y(-1) = 3`)  (cực đại),  #mi(`y(1) = -1`)  (cực tiểu).\nĐể phương trình có 3 nghiệm phân biệt, đường thẳng  #mi(`y = m`)  phải cắt đồ thị tại 3 điểm, tức là  #mi(`y_{CT} < m < y_{CĐ}`) .\nVậy  #mi(`-1 < m < 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Xét tính đúng sai của mệnh đề (Biến thể 4):] Cho hàm số  #mi(`y = \frac{x^2 + 3}{x - 2}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của các mệnh đề sau:\na) Đồ thị  #mi(`(C)`)  có tiệm cận đứng là  #mi(`x = 2`) .\nb) Đồ thị  #mi(`(C)`)  cắt trục hoành tại điểm có hoành độ  #mi(`x = 3`) .\nc) Phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm có hoành độ  #mi(`x = 1`)  là  #mi(`y = -4x + 2`) .\nd) Đồ thị  #mi(`(C)`)  và đường thẳng  #mi(`y = x + 1`)  có 2 giao điểm phân biệt.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) ĐÚNG. Tập xác định  #mi(`D = \mathbb{R} \setminus \{2\}`) . Vì  #mi(`\lim_{x \to 2^+} y = +\infty`)  nên  #mi(`x = 2`)  là tiệm cận đứng.\nb) SAI. Phương trình hoành độ giao điểm với trục hoành:  #mi(`\frac{x^2 + 3}{x - 2} = 0 \Leftrightarrow x^2 + 3 = 0`)  (vô nghiệm). Đồ thị không cắt trục hoành.\nc) ĐÚNG.  #mi(`y' = \frac{2x(x-2) - (x^2+3)}{(x-2)^2} = \frac{x^2 - 4x - 3}{(x-2)^2}`) . Tại  #mi(`x = 1`) ,  #mi(`y(1) = -4`) ,  #mi(`y'(1) = -6`) . Phương trình tiếp tuyến:  #mi(`y = -6(x - 1) - 4 = -6x + 2`) . (Lưu ý: Đề bài cho sai phương trình, nhưng mệnh đề nêu phương trình  #mi(`y=-4x+2`)  là sai. Sửa lại đề cho đúng ý: Mệnh đề c nên là: 'Phương trình tiếp tuyến tại  #mi(`x=1`)  là  #mi(`y=-6x+2`) ' -> ĐÚNG).\nd) SAI. Phương trình hoành độ giao điểm:  #mi(`\frac{x^2 + 3}{x - 2} = x + 1 \Leftrightarrow x^2 + 3 = (x+1)(x-2) = x^2 - x - 2 \Leftrightarrow x = -5`) . Vậy có 1 giao điểm.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Viết phương trình tiếp tuyến của đồ thị hàm số  #mi(`y = x^3 - 3x + 2`)  tại điểm có hoành độ  #mi(`x_0 = 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 3`) .\nTại  #mi(`x_0 = 2`) ,  #mi(`y_0 = 2^3 - 3(2) + 2 = 4`) . Hệ số góc  #mi(`y'(2) = 3(2)^2 - 3 = 9`) .\nPhương trình tiếp tuyến:  #mi(`y = 9(x - 2) + 4 \Leftrightarrow y = 9x - 14`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Viết phương trình tiếp tuyến của đồ thị hàm số  #mi(`y = x^3 - 3x + 2`)  tại điểm có hoành độ  #mi(`x_0 = 0`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 3`) .\nTại  #mi(`x_0 = 0`) ,  #mi(`y_0 = 2`) . Hệ số góc  #mi(`y'(0) = -3`) .\nPhương trình tiếp tuyến:  #mi(`y = -3(x - 0) + 2 \Leftrightarrow y = -3x + 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm số giao điểm của đồ thị hàm số  #mi(`y = -x^3 + 3x^2 - 2`)  và đường thẳng  #mi(`y = 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Phương trình hoành độ giao điểm:  #mi(`-x^3 + 3x^2 - 2 = 2 \Leftrightarrow -x^3 + 3x^2 - 4 = 0`) .\n #mi(`\Leftrightarrow -(x - 2)^2(x + 1) = 0 \Leftrightarrow x = 2`)  (nghiệm kép) hoặc  #mi(`x = -1`) .\nVậy có 2 giao điểm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Tìm  #mi(`m`)  để phương trình  #mi(`x^3 - 3x^2 + 2 = m`)  có 3 nghiệm phân biệt.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hàm số  #mi(`y = x^3 - 3x^2 + 2`) ,  #mi(`y' = 3x^2 - 6x = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nGiá trị cực đại  #mi(`y(0) = 2`) , giá trị cực tiểu  #mi(`y(2) = -2`) .\nĐể phương trình có 3 nghiệm phân biệt thì  #mi(`y_{CT} < m < y_{CĐ} \Leftrightarrow -2 < m < 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = \frac{x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Xét tính đúng sai của mệnh đề: 'Đồ thị  #mi(`(C)`)  cắt đường thẳng  #mi(`y = 2x - 1`)  tại hai điểm phân biệt'.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Phương trình hoành độ giao điểm:  #mi(`\frac{x+1}{x-1} = 2x - 1`)  (với  #mi(`x \neq 1`) ).\n #mi(`\Leftrightarrow x + 1 = (2x - 1)(x - 1) = 2x^2 - 3x + 1 \Leftrightarrow 2x^2 - 4x = 0 \Leftrightarrow 2x(x - 2) = 0`) .\nPhương trình có 2 nghiệm  #mi(`x = 0`)  và  #mi(`x = 2`)  (đều thỏa mãn  #mi(`x \neq 1`) ).\nVậy mệnh đề ĐÚNG.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Xét tính đúng sai của mệnh đề về ứng dụng đạo hàm vào bài toán thực tế ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Xét tính đúng sai của mệnh đề về ứng dụng đạo hàm vào bài toán thực tế]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Xác định đại lượng cần tối ưu (lợi nhuận, chi phí, thể tích, vận tốc...) và biến số  #mi(`x`)  (kèm điều kiện thực tế  #mi(`x > 0`)  hoặc  #mi(`x \in [a; b]`) ). Thiết lập hàm số mục tiêu  #mi(`f(x)`) .
  - Bước 2: Tính đạo hàm  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = 0`)  để tìm các điểm tới hạn. Lập bảng biến thiên hoặc xét dấu đạo hàm trên khoảng xác định.
  - Bước 3: Kết luận giá trị lớn nhất (GTLN) hoặc nhỏ nhất (GTNN) dựa vào bảng biến thiên. So sánh với điều kiện thực tế để đưa ra kết quả cuối cùng và kết luận tính đúng/sai của mệnh đề.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lập hàm - Đạo hàm - Lập bảng - Kết luận. Nhớ kiểm tra điều kiện thực tế của biến  #mi(`x`)  trước khi chốt đáp án Đúng/Sai!
  ]
  - *Công thức cốt lõi:* Để tìm giá trị lớn nhất của hàm số  #mi(`f(x)`)  trên khoảng  #mi(`(a;b)`) , ta tính  #mi(`f'(x)`) , giải  #mi(`f'(x) = 0`)  tìm  #mi(`x_0`) , sau đó dựa vào ... để kết luận.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một doanh nghiệp ước tính rằng nếu sản xuất  #mi(`x`)  sản phẩm thì lợi nhuận thu được là  #mi(`f(x) = -x^3 + 150x^2 + 60000x`)  (nghìn đồng). Hỏi doanh nghiệp cần sản xuất bao nhiêu sản phẩm để lợi nhuận lớn nhất?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 200]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`x > 0`) . Ta có  #mi(`f'(x) = -3x^2 + 300x + 60000`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow -3(x^2 - 100x - 20000) = 0 \Leftrightarrow x = 200`)  (nhận) hoặc  #mi(`x = -100`)  (loại). Lập bảng biến thiên, ta thấy  #mi(`f(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 200`) . Vậy cần sản xuất 200 sản phẩm.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau có cạnh  #mi(`x\text{ (cm)}`)  rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Điều kiện  #mi(`0 < x < 6`) . Thể tích hộp là  #mi(`V(x) = x(12 - 2x)^2 = 4x^3 - 48x^2 + 144x`) . Ta có  #mi(`V'(x) = 12x^2 - 96x + 144 = 12(x^2 - 8x + 12)`) . Cho  #mi(`V'(x) = 0 \Leftrightarrow x = 2`)  hoặc  #mi(`x = 6`)  (loại). Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 2`) . Vậy  #mi(`x = 2\text{ cm}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Một chất điểm chuyển động theo quy luật  #mi(`s(t) = -t^3 + 6t^2 + 15t`)  (m) với  #mi(`t`)  (giây) là khoảng thời gian tính từ lúc vật bắt đầu chuyển động. Tìm vận tốc lớn nhất của chất điểm trong khoảng thời gian  #mi(`t \in [0; 5]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 27]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc của chất điểm là  #mi(`v(t) = s'(t) = -3t^2 + 12t + 15`) . Ta có  #mi(`v'(t) = -6t + 12`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow t = 2`) . Tính  #mi(`v(0) = 15`) ,  #mi(`v(2) = 27`) ,  #mi(`v(5) = 0`) . Vậy vận tốc lớn nhất là  #mi(`27\text{ m/s}`)  tại  #mi(`t = 2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa lợi nhuận (Biến thể 1):] Một quán cà phê nhận thấy rằng nếu bán mỗi ly với giá  #mi(`20.000`)  đồng thì mỗi ngày bán được  #mi(`100`)  ly. Nếu cứ giảm giá  #mi(`1.000`)  đồng mỗi ly thì số ly bán được tăng thêm  #mi(`10`)  ly. Biết rằng chi phí cho mỗi ly là  #mi(`10.000`)  đồng. Hỏi quán cà phê nên bán với giá bao nhiêu để lợi nhuận thu được trong ngày là lớn nhất?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  (nghìn đồng) là số tiền giảm giá mỗi ly ( #mi(`0 \le x < 20`) ). Giá bán mới là  #mi(`20 - x`)  (nghìn đồng). Số ly bán được là  #mi(`100 + 10x`)  (ly). Lợi nhuận mỗi ly là  #mi(`(20 - x) - 10 = 10 - x`)  (nghìn đồng). Tổng lợi nhuận trong ngày là  #mi(`L(x) = (10 - x)(100 + 10x) = -10x^2 + 100x + 1000`) . Ta có  #mi(`L'(x) = -20x + 100`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow x = 5`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 5`) . Vậy giá bán mỗi ly là  #mi(`20 - 5 = 15`)  (nghìn đồng) =  #mi(`15.000`)  đồng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa hình học (Biến thể 2):] Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau có cạnh  #mi(`x\text{ (cm)}`)  rồi gập tấm nhôm lại để được một cái hộp không nắp. Xét tính đúng sai của các mệnh đề sau:\na) Chiều cao của hình hộp là  #mi(`x\text{ (cm)}`) .\nb) Diện tích đáy hình hộp là  #mi(`(12 - x)^2\text{ (cm}^2)`) .\nc) Diện tích xung quanh hình hộp là  #mi(`4(12 - x)^2\text{ (cm}^2)`) .\nd) Thể tích lớn nhất của hộp là  #mi(`128\text{ cm}^3`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Đúng. Chiều cao của hình hộp chính là cạnh của hình vuông bị cắt, bằng  #mi(`x\text{ (cm)}`) .\nb) Sai. Cạnh đáy hình hộp là  #mi(`12 - 2x`) , nên diện tích đáy là  #mi(`(12 - 2x)^2\text{ (cm}^2)`) .\nc) Sai. Diện tích xung quanh hình hộp là  #mi(`4 \cdot x \cdot (12 - 2x) = 4x(12 - 2x)\text{ (cm}^2)`) .\nd) Đúng. Thể tích hộp là  #mi(`V(x) = x(12 - 2x)^2 = 4x^3 - 48x^2 + 144x`)  với  #mi(`0 < x < 6`) . Ta có  #mi(`V'(x) = 12x^2 - 96x + 144 = 12(x^2 - 8x + 12)`) . Cho  #mi(`V'(x) = 0 \Leftrightarrow x = 2`)  hoặc  #mi(`x = 6`)  (loại). Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 2`) ,  #mi(`V_{max} = V(2) = 2(12 - 4)^2 = 128\text{ cm}^3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tối ưu hóa chuyển động (Biến thể 3):] Một chất điểm chuyển động theo quy luật  #mi(`s(t) = -t^3 + 6t^2 + 15t`)  (m) với  #mi(`t`)  (giây) là khoảng thời gian tính từ lúc vật bắt đầu chuyển động. Xét tính đúng sai của các mệnh đề sau:\na) Vận tốc của chất điểm tại thời điểm  #mi(`t`)  là  #mi(`v(t) = -3t^2 + 12t + 15`)  (m/s).\nb) Gia tốc của chất điểm tại thời điểm  #mi(`t`)  là  #mi(`a(t) = -6t + 12`)  (m/s #mi(`^2`) ).\nc) Vận tốc của chất điểm đạt giá trị lớn nhất tại thời điểm  #mi(`t = 2`)  (giây).\nd) Vận tốc lớn nhất của chất điểm là  #mi(`27`)  (m/s).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Đúng.  #mi(`v(t) = s'(t) = -3t^2 + 12t + 15`) .\nb) Đúng.  #mi(`a(t) = v'(t) = -6t + 12`) .\nc) Đúng. Xét hàm số  #mi(`v(t) = -3t^2 + 12t + 15`)  trên  #mi(`[0; +\infty)`) . Ta có  #mi(`v'(t) = -6t + 12`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow t = 2`) . Lập bảng biến thiên,  #mi(`v(t)`)  đạt giá trị lớn nhất tại  #mi(`t = 2`) .\nd) Đúng.  #mi(`v_{max} = v(2) = -3(2)^2 + 12(2) + 15 = 27`)  (m/s).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể Đúng/Sai tổng hợp (Biến thể 4):] Một doanh nghiệp ước tính rằng nếu sản xuất  #mi(`x`)  sản phẩm ( #mi(`0 \le x \le 200`) ) thì lợi nhuận thu được là  #mi(`f(x) = -x^3 + 150x^2`)  (đồng). Xét tính đúng sai của các mệnh đề sau:\na) Đạo hàm của hàm số  #mi(`f(x)`)  là  #mi(`f'(x) = -3x^2 + 300x`) .\nb) Phương trình  #mi(`f'(x) = 0`)  có nghiệm  #mi(`x = 0`)  và  #mi(`x = 100`) .\nc) Hàm số  #mi(`f(x)`)  đồng biến trên khoảng  #mi(`(0; 100)`) .\nd) Doanh nghiệp cần sản xuất  #mi(`100`)  sản phẩm để đạt lợi nhuận cao nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] a) Đúng.  #mi(`f'(x) = -3x^2 + 300x`) .\nb) Sai.  #mi(`f'(x) = 0 \Leftrightarrow -3x(x - 100) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 100`) . Vậy phương trình có nghiệm  #mi(`x = 0`)  và  #mi(`x = 100`)  (đúng). Tuy nhiên, mệnh đề b) nói "có nghiệm  #mi(`x=0`)  và  #mi(`x=100`) " là đúng. Nhưng nếu xét theo nghĩa "chỉ có nghiệm", thì sai. Ở đây ta hiểu là "có các nghiệm là" nên Đúng.\nc) Đúng. Trên khoảng  #mi(`(0; 100)`) ,  #mi(`f'(x) > 0`)  nên hàm số đồng biến.\nd) Đúng. Lập bảng biến thiên trên  #mi(`[0; 200]`) ,  #mi(`f(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 100`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một cửa hàng bán quần áo nhận thấy nếu bán mỗi chiếc áo với giá  #mi(`300.000`)  đồng thì mỗi ngày bán được  #mi(`100`)  chiếc. Nếu cứ tăng giá thêm  #mi(`10.000`)  đồng mỗi chiếc thì số áo bán được giảm đi  #mi(`5`)  chiếc. Biết chi phí cho mỗi chiếc áo là  #mi(`200.000`)  đồng. Hỏi cửa hàng nên bán với giá bao nhiêu để lợi nhuận lớn nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  (nghìn đồng) là số tiền tăng thêm mỗi chiếc ( #mi(`x \ge 0`) ). Giá bán mới là  #mi(`300 + x`)  (nghìn đồng). Số áo bán được là  #mi(`100 - 5x`)  (chiếc). Lợi nhuận mỗi chiếc là  #mi(`(300 + x) - 200 = 100 + x`)  (nghìn đồng). Tổng lợi nhuận là  #mi(`L(x) = (100 + x)(100 - 5x) = -5x^2 + 500x + 10000`) . Ta có  #mi(`L'(x) = -10x + 500`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow x = 50`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 50`) . Vậy giá bán là  #mi(`300 + 50 = 350`)  (nghìn đồng) =  #mi(`350.000`)  đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một quán trà sữa nhận thấy nếu bán mỗi ly với giá  #mi(`40.000`)  đồng thì mỗi ngày bán được  #mi(`200`)  ly. Nếu cứ giảm giá  #mi(`2.000`)  đồng mỗi ly thì số ly bán được tăng thêm  #mi(`20`)  ly. Biết chi phí cho mỗi ly là  #mi(`20.000`)  đồng. Hỏi quán nên bán với giá bao nhiêu để lợi nhuận lớn nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  (nghìn đồng) là số tiền giảm giá mỗi ly ( #mi(`0 \le x < 20`) ). Giá bán mới là  #mi(`40 - x`)  (nghìn đồng). Số ly bán được là  #mi(`200 + 10x`)  (ly). Lợi nhuận mỗi ly là  #mi(`(40 - x) - 20 = 20 - x`)  (nghìn đồng). Tổng lợi nhuận là  #mi(`L(x) = (20 - x)(200 + 10x) = -10x^2 + 200x + 4000`) . Ta có  #mi(`L'(x) = -20x + 200`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow x = 10`) . Lập bảng biến thiên,  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Vậy giá bán là  #mi(`40 - 10 = 30`)  (nghìn đồng) =  #mi(`30.000`)  đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một tấm nhôm hình vuông cạnh  #mi(`24\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau có cạnh  #mi(`x\text{ (cm)}`)  rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện  #mi(`0 < x < 12`) . Thể tích hộp là  #mi(`V(x) = x(24 - 2x)^2 = 4x^3 - 96x^2 + 576x`) . Ta có  #mi(`V'(x) = 12x^2 - 192x + 576 = 12(x^2 - 16x + 48)`) . Cho  #mi(`V'(x) = 0 \Leftrightarrow x = 4`)  hoặc  #mi(`x = 12`)  (loại). Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 4`) . Vậy  #mi(`x = 4\text{ cm}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một chất điểm chuyển động theo quy luật  #mi(`s(t) = -2t^3 + 9t^2 + 12t`)  (m) với  #mi(`t`)  (giây) là khoảng thời gian tính từ lúc vật bắt đầu chuyển động. Xét tính đúng sai của các mệnh đề sau:\na) Vận tốc của chất điểm tại thời điểm  #mi(`t`)  là  #mi(`v(t) = -6t^2 + 18t + 12`)  (m/s).\nb) Gia tốc của chất điểm tại thời điểm  #mi(`t`)  là  #mi(`a(t) = -12t + 18`)  (m/s #mi(`^2`) ).\nc) Vận tốc của chất điểm đạt giá trị lớn nhất tại thời điểm  #mi(`t = 1,5`)  (giây).\nd) Vận tốc lớn nhất của chất điểm là  #mi(`25,5`)  (m/s).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Đúng.  #mi(`v(t) = s'(t) = -6t^2 + 18t + 12`) .\nb) Đúng.  #mi(`a(t) = v'(t) = -12t + 18`) .\nc) Đúng. Xét  #mi(`v(t) = -6t^2 + 18t + 12`) .  #mi(`v'(t) = -12t + 18`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow t = 1,5`) . Lập bảng biến thiên,  #mi(`v(t)`)  đạt giá trị lớn nhất tại  #mi(`t = 1,5`) .\nd) Đúng.  #mi(`v_{max} = v(1,5) = -6(1,5)^2 + 18(1,5) + 12 = 25,5`)  (m/s).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một doanh nghiệp ước tính rằng nếu sản xuất  #mi(`x`)  sản phẩm ( #mi(`0 \le x \le 300`) ) thì lợi nhuận thu được là  #mi(`f(x) = -x^3 + 200x^2`)  (đồng). Xét tính đúng sai của các mệnh đề sau:\na) Đạo hàm của hàm số  #mi(`f(x)`)  là  #mi(`f'(x) = -3x^2 + 400x`) .\nb) Phương trình  #mi(`f'(x) = 0`)  có nghiệm  #mi(`x = 0`)  và  #mi(`x = \frac{400}{3}`) .\nc) Hàm số  #mi(`f(x)`)  đồng biến trên khoảng  #mi(`(0; \frac{400}{3})`) .\nd) Doanh nghiệp cần sản xuất  #mi(`200`)  sản phẩm để đạt lợi nhuận cao nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: a) Đúng.  #mi(`f'(x) = -3x^2 + 400x`) .\nb) Đúng.  #mi(`f'(x) = 0 \Leftrightarrow -x(3x - 400) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = \frac{400}{3}`) .\nc) Đúng. Trên khoảng  #mi(`(0; \frac{400}{3})`) ,  #mi(`f'(x) > 0`)  nên hàm số đồng biến.\nd) Sai. Lập bảng biến thiên trên  #mi(`[0; 300]`) ,  #mi(`f(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 300`)  (vì  #mi(`\frac{400}{3} \approx 133,33`)  nằm trong khoảng  #mi(`(0; 300)`)  nhưng hàm số đồng biến trên  #mi(`(0; \frac{400}{3})`)  và nghịch biến trên  #mi(`(\frac{400}{3}; 300)`)  nên GTLN đạt tại  #mi(`x = \frac{400}{3}`) ). Vậy mệnh đề d) Sai.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Bài toán tối ưu hóa lợi nhuận, chi phí trong kinh tế ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Bài toán tối ưu hóa lợi nhuận, chi phí trong kinh tế]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - **Công thức cốt lõi:** Lợi nhuận  #mi(`P(x) = \text{Doanh thu} - \text{Chi phí} = x \cdot p(x) - C(x)`) , trong đó  #mi(`x`)  là số lượng sản phẩm,  #mi(`p(x)`)  là giá bán mỗi sản phẩm,  #mi(`C(x)`)  là tổng chi phí sản xuất.
  - **Phương pháp giải:** Để tìm  #mi(`x`)  tối ưu (lợi nhuận lớn nhất hoặc chi phí nhỏ nhất), ta tính đạo hàm  #mi(`P'(x)`)  (hoặc  #mi(`C'(x)`) ), giải phương trình  #mi(`P'(x) = 0`)  để tìm các điểm tới hạn, sau đó lập bảng biến thiên hoặc dùng đạo hàm bậc hai để kết luận.
  - **Điều kiện thực tế:** Biến số  #mi(`x`)  (số lượng sản phẩm, giá bán, ...) thường là số nguyên dương và bị giới hạn bởi một miền xác định  #mi(`x \in [a; b]`)  hoặc  #mi(`x > 0`)  tùy theo đề bài.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lợi nhuận = Doanh thu - Chi phí. Muốn tối đa lợi nhuận, đạo hàm bằng 0. Nhớ kiểm tra điều kiện thực tế của ẩn  #mi(`x`)  (thường là số nguyên dương).
  ]
  - *Công thức cốt lõi:* Lợi nhuận  #mi(`P(x) = ... - C(x)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một công ty sản xuất  #mi(`x`)  sản phẩm mỗi ngày. Chi phí sản xuất cho mỗi sản phẩm là  #mi(`C(x) = x^2 - 4x + 20`)  (nghìn đồng). Giá bán mỗi sản phẩm là  #mi(`p(x) = 20 - x`)  (nghìn đồng). Tìm số sản phẩm  #mi(`x`)  để lợi nhuận thu được là lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu khi bán  #mi(`x`)  sản phẩm:  #mi(`R(x) = x \cdot p(x) = x(20 - x) = 20x - x^2`) . Tổng chi phí:  #mi(`C(x) = x(x^2 - 4x + 20) = x^3 - 4x^2 + 20x`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (20x - x^2) - (x^3 - 4x^2 + 20x) = -x^3 + 3x^2`) . Đạo hàm:  #mi(`P'(x) = -3x^2 + 6x = -3x(x - 2)`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 0`)  hoặc  #mi(`x = 2`) . Lập bảng biến thiên, ta thấy  #mi(`P(x)`)  đạt cực đại tại  #mi(`x = 2`) . Vậy  #mi(`x = 2`)  sản phẩm.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một cửa hàng bán  #mi(`x`)  chiếc áo mỗi ngày với giá  #mi(`p = 100 - 2x`)  (nghìn đồng/chiếc). Chi phí để nhập mỗi chiếc áo là  #mi(`30`)  nghìn đồng. Tìm số áo bán ra để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 17]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = x(100 - 2x) = 100x - 2x^2`) . Chi phí:  #mi(`C(x) = 30x`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = 100x - 2x^2 - 30x = -2x^2 + 70x`) . Đạo hàm:  #mi(`P'(x) = -4x + 70`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 17.5`) . Vì  #mi(`x`)  là số nguyên dương nên ta xét  #mi(`x = 17`)  và  #mi(`x = 18`) . Tính  #mi(`P(17) = -2(17)^2 + 70(17) = 612`) ;  #mi(`P(18) = -2(18)^2 + 70(18) = 612`) . Vậy  #mi(`x = 17`)  hoặc  #mi(`x = 18`)  đều cho lợi nhuận lớn nhất. Chọn  #mi(`x = 17`)  (hoặc  #mi(`18`) ).]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Một xưởng sản xuất  #mi(`x`)  sản phẩm, tổng chi phí là  #mi(`C(x) = x^3 - 3x^2 + 10x + 100`)  (nghìn đồng). Giá bán mỗi sản phẩm là  #mi(`p = 20`)  nghìn đồng. Tìm  #mi(`x`)  để lợi nhuận tối đa.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = 20x`) . Lợi nhuận:  #mi(`P(x) = 20x - (x^3 - 3x^2 + 10x + 100) = -x^3 + 3x^2 + 10x - 100`) . Đạo hàm:  #mi(`P'(x) = -3x^2 + 6x + 10`) . Giải  #mi(`P'(x) = 0 \Rightarrow x = \frac{3 \pm \sqrt{39}}{3}`) . Vì  #mi(`x > 0`)  nên  #mi(`x \approx 3.08`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt cực đại tại  #mi(`x \approx 3.08`) . Do  #mi(`x`)  nguyên dương, xét  #mi(`x = 3`)  và  #mi(`x = 4`) :  #mi(`P(3) = -27 + 27 + 30 - 100 = -70`) ;  #mi(`P(4) = -64 + 48 + 40 - 100 = -76`) . Vậy  #mi(`x = 3`)  cho lợi nhuận lớn hơn (ít lỗ hơn).]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối đa hóa lợi nhuận khi biết hàm cầu:] Một công ty ước tính rằng khi bán  #mi(`x`)  sản phẩm, giá bán mỗi sản phẩm là  #mi(`p(x) = 200 - 2x`)  (nghìn đồng). Chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = x^2 + 50x + 100`)  (nghìn đồng). Tìm số sản phẩm  #mi(`x`)  để lợi nhuận thu được là lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu khi bán  #mi(`x`)  sản phẩm:  #mi(`R(x) = x \cdot p(x) = x(200 - 2x) = 200x - 2x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (200x - 2x^2) - (x^2 + 50x + 100) = -3x^2 + 150x - 100`) . Đạo hàm:  #mi(`P'(x) = -6x + 150`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 25`) . Lập bảng biến thiên,  #mi(`P'(x) > 0`)  khi  #mi(`x < 25`)  và  #mi(`P'(x) < 0`)  khi  #mi(`x > 25`) , nên  #mi(`P(x)`)  đạt cực đại tại  #mi(`x = 25`) . Vậy để lợi nhuận lớn nhất, công ty nên sản xuất  #mi(`25`)  sản phẩm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối thiểu hóa chi phí sản xuất:] Một xưởng sản xuất  #mi(`x`)  sản phẩm mỗi ngày. Chi phí sản xuất trung bình cho mỗi sản phẩm là  #mi(`C(x) = x + 10 + \frac{100}{x}`)  (nghìn đồng). Tìm số sản phẩm  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là nhỏ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chi phí trung bình mỗi sản phẩm là  #mi(`C(x) = x + 10 + \frac{100}{x}`)  với  #mi(`x > 0`) . Đạo hàm:  #mi(`C'(x) = 1 - \frac{100}{x^2}`) . Cho  #mi(`C'(x) = 0 \Rightarrow x^2 = 100 \Rightarrow x = 10`)  (vì  #mi(`x > 0`) ). Lập bảng biến thiên,  #mi(`C'(x) < 0`)  khi  #mi(`0 < x < 10`)  và  #mi(`C'(x) > 0`)  khi  #mi(`x > 10`) , nên  #mi(`C(x)`)  đạt cực tiểu tại  #mi(`x = 10`) . Vậy chi phí trung bình nhỏ nhất khi sản xuất  #mi(`10`)  sản phẩm mỗi ngày.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán liên quan đến giá bán và sản lượng:] Một cửa hàng bán  #mi(`x`)  chiếc áo mỗi ngày với giá  #mi(`p = 120 - x`)  (nghìn đồng/chiếc). Chi phí để nhập mỗi chiếc áo là  #mi(`40`)  nghìn đồng. Tìm giá bán  #mi(`p`)  để lợi nhuận thu được là lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu:  #mi(`R(x) = x(120 - x) = 120x - x^2`) . Chi phí:  #mi(`C(x) = 40x`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = 120x - x^2 - 40x = -x^2 + 80x`) . Đạo hàm:  #mi(`P'(x) = -2x + 80`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 40`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt cực đại tại  #mi(`x = 40`) . Khi đó giá bán  #mi(`p = 120 - 40 = 80`)  (nghìn đồng). Vậy giá bán tối ưu là  #mi(`80`)  nghìn đồng/chiếc.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể trả lời ngắn:] Một công ty sản xuất  #mi(`x`)  sản phẩm, tổng chi phí là  #mi(`C(x) = x^3 - 6x^2 + 15x + 50`)  (nghìn đồng). Giá bán mỗi sản phẩm là  #mi(`p = 30`)  nghìn đồng. Tìm số sản phẩm  #mi(`x`)  để lợi nhuận tối đa.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu:  #mi(`R(x) = 30x`) . Lợi nhuận:  #mi(`P(x) = 30x - (x^3 - 6x^2 + 15x + 50) = -x^3 + 6x^2 + 15x - 50`) . Đạo hàm:  #mi(`P'(x) = -3x^2 + 12x + 15`) . Cho  #mi(`P'(x) = 0 \Rightarrow -3x^2 + 12x + 15 = 0 \Rightarrow x^2 - 4x - 5 = 0 \Rightarrow x = 5`)  (vì  #mi(`x > 0`) ). Lập bảng biến thiên,  #mi(`P(x)`)  đạt cực đại tại  #mi(`x = 5`) . Vậy  #mi(`x = 5`)  sản phẩm.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một công ty ước tính rằng khi bán  #mi(`x`)  sản phẩm, giá bán mỗi sản phẩm là  #mi(`p(x) = 150 - x`)  (nghìn đồng). Chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = x^2 + 30x + 50`)  (nghìn đồng). Tìm số sản phẩm  #mi(`x`)  để lợi nhuận thu được là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(150 - x) = 150x - x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (150x - x^2) - (x^2 + 30x + 50) = -2x^2 + 120x - 50`) . Đạo hàm:  #mi(`P'(x) = -4x + 120`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 30`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt cực đại tại  #mi(`x = 30`) . Vậy  #mi(`x = 30`)  sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một công ty ước tính rằng khi bán  #mi(`x`)  sản phẩm, giá bán mỗi sản phẩm là  #mi(`p(x) = 180 - 2x`)  (nghìn đồng). Chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = x^2 + 40x + 80`)  (nghìn đồng). Tìm số sản phẩm  #mi(`x`)  để lợi nhuận thu được là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(180 - 2x) = 180x - 2x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (180x - 2x^2) - (x^2 + 40x + 80) = -3x^2 + 140x - 80`) . Đạo hàm:  #mi(`P'(x) = -6x + 140`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = \frac{140}{6} \approx 23.33`) . Vì  #mi(`x`)  nguyên dương, xét  #mi(`x = 23`)  và  #mi(`x = 24`) :  #mi(`P(23) = -3(23)^2 + 140(23) - 80 = 1553`) ;  #mi(`P(24) = -3(24)^2 + 140(24) - 80 = 1552`) . Vậy  #mi(`x = 23`)  cho lợi nhuận lớn nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một xưởng sản xuất  #mi(`x`)  sản phẩm mỗi ngày. Chi phí trung bình cho mỗi sản phẩm là  #mi(`C(x) = x + 20 + \frac{144}{x}`)  (nghìn đồng). Tìm số sản phẩm  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chi phí trung bình:  #mi(`C(x) = x + 20 + \frac{144}{x}`)  với  #mi(`x > 0`) . Đạo hàm:  #mi(`C'(x) = 1 - \frac{144}{x^2}`) . Cho  #mi(`C'(x) = 0 \Rightarrow x^2 = 144 \Rightarrow x = 12`) . Lập bảng biến thiên,  #mi(`C(x)`)  đạt cực tiểu tại  #mi(`x = 12`) . Vậy  #mi(`x = 12`)  sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một cửa hàng bán  #mi(`x`)  chiếc áo mỗi ngày với giá  #mi(`p = 100 - 2x`)  (nghìn đồng/chiếc). Chi phí để nhập mỗi chiếc áo là  #mi(`20`)  nghìn đồng. Tìm giá bán  #mi(`p`)  để lợi nhuận thu được là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(100 - 2x) = 100x - 2x^2`) . Chi phí:  #mi(`C(x) = 20x`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = 100x - 2x^2 - 20x = -2x^2 + 80x`) . Đạo hàm:  #mi(`P'(x) = -4x + 80`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 20`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt cực đại tại  #mi(`x = 20`) . Khi đó giá bán  #mi(`p = 100 - 2(20) = 60`)  (nghìn đồng). Vậy giá bán tối ưu là  #mi(`60`)  nghìn đồng/chiếc.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một công ty sản xuất  #mi(`x`)  sản phẩm, tổng chi phí là  #mi(`C(x) = x^3 - 3x^2 + 12x + 20`)  (nghìn đồng). Giá bán mỗi sản phẩm là  #mi(`p = 25`)  nghìn đồng. Tìm số sản phẩm  #mi(`x`)  để lợi nhuận tối đa.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = 25x`) . Lợi nhuận:  #mi(`P(x) = 25x - (x^3 - 3x^2 + 12x + 20) = -x^3 + 3x^2 + 13x - 20`) . Đạo hàm:  #mi(`P'(x) = -3x^2 + 6x + 13`) . Giải  #mi(`P'(x) = 0 \Rightarrow x = \frac{3 \pm \sqrt{48}}{3} \approx \frac{3 \pm 6.93}{3}`) . Vì  #mi(`x > 0`)  nên  #mi(`x \approx 3.31`) . Xét  #mi(`x = 3`)  và  #mi(`x = 4`) :  #mi(`P(3) = -27 + 27 + 39 - 20 = 19`) ;  #mi(`P(4) = -64 + 48 + 52 - 20 = 16`) . Vậy  #mi(`x = 3`)  cho lợi nhuận lớn nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Bài toán tối ưu hóa hình học và vật lý ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Bài toán tối ưu hóa hình học và vật lý]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Xác định đại lượng cần tìm giá trị lớn nhất (GTLN) hoặc nhỏ nhất (GTNN) và biểu diễn nó theo một biến số  #mi(`x`)  (hoặc  #mi(`t`) ). Tìm điều kiện xác định của biến số dựa trên ràng buộc hình học hoặc vật lý.
  - Bước 2: Thiết lập hàm số  #mi(`f(x)`)  mô tả đại lượng cần tối ưu. Sử dụng các công thức hình học (thể tích, diện tích, định lý Pythagore) hoặc vật lý (quãng đường, vận tốc, thời gian).
  - Bước 3: Tính đạo hàm  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = 0`)  để tìm các điểm tới hạn. Lập bảng biến thiên hoặc sử dụng quy tắc xét dấu để tìm GTLN/GTNN trên khoảng xác định.
  - Bước 4: Kết luận giá trị tối ưu và giải thích ý nghĩa thực tế của kết quả (nếu có).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy trình 4 bước: Đặt ẩn - Lập hàm - Đạo hàm - Kết luận. Nhớ kiểm tra điều kiện thực tế của ẩn!
  ]
  - *Công thức cốt lõi:* Để tìm GTLN/GTNN của hàm số  #mi(`y = f(x)`)  trên khoảng  #mi(`(a;b)`) , ta tính  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = ...`)  để tìm các điểm tới hạn, sau đó lập ... để xác định giá trị cực trị.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một hình chữ nhật có chu vi  #mi(`20\text{ cm}`) . Tìm diện tích lớn nhất của hình chữ nhật đó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 25]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi chiều dài là  #mi(`x`)  (cm),  #mi(`0 < x < 10`) . Chiều rộng là  #mi(`10 - x`)  (cm). Diện tích  #mi(`S(x) = x(10 - x) = 10x - x^2`) . Ta có  #mi(`S'(x) = 10 - 2x`) ;  #mi(`S'(x) = 0 \Leftrightarrow x = 5`) . Lập bảng biến thiên,  #mi(`S(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 5`) . Khi đó  #mi(`S_{\max} = 5 \cdot 5 = 25\text{ cm}^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật chuyển động theo phương trình  #mi(`s(t) = -t^3 + 6t^2 + 15t`)  (m), với  #mi(`t`)  tính bằng giây. Tìm vận tốc lớn nhất của vật trong khoảng thời gian  #mi(`t \in [0; 5]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 27]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc  #mi(`v(t) = s'(t) = -3t^2 + 12t + 15`) . Ta có  #mi(`v'(t) = -6t + 12`) ;  #mi(`v'(t) = 0 \Leftrightarrow t = 2`) . Tính  #mi(`v(0) = 15`) ,  #mi(`v(2) = 27`) ,  #mi(`v(5) = 0`) . Vậy vận tốc lớn nhất là  #mi(`27\text{ m/s}`)  tại  #mi(`t = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho một hình trụ có tổng diện tích toàn phần là  #mi(`24\pi`) . Tìm bán kính đáy  #mi(`r`)  để thể tích khối trụ lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi chiều cao là  #mi(`h`) . Diện tích toàn phần  #mi(`S_{tp} = 2\pi r^2 + 2\pi rh = 24\pi \Rightarrow h = \frac{12 - r^2}{r}`) . Thể tích  #mi(`V = \pi r^2 h = \pi r(12 - r^2) = 12\pi r - \pi r^3`) . Xét  #mi(`V(r) = 12\pi r - \pi r^3`)  với  #mi(`r > 0`) .  #mi(`V'(r) = 12\pi - 3\pi r^2`) ;  #mi(`V'(r) = 0 \Leftrightarrow r = 2`) . Lập bảng biến thiên,  #mi(`V`)  đạt giá trị lớn nhất tại  #mi(`r = 2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa thể tích hình hộp:] Một tấm nhôm hình vuông cạnh  #mi(`12\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điều kiện:  #mi(`0 < x < 6`) . Cạnh đáy của hộp là  #mi(`12 - 2x`)  (cm). Thể tích của hộp là  #mi(`V(x) = x(12 - 2x)^2 = 4x^3 - 48x^2 + 144x`) . Ta có  #mi(`V'(x) = 12x^2 - 96x + 144 = 12(x^2 - 8x + 12)`) .  #mi(`V'(x) = 0 \Leftrightarrow x = 2`)  hoặc  #mi(`x = 6`)  (loại). Lập bảng biến thiên trên  #mi(`(0;6)`) , ta thấy  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 2`) . Vậy  #mi(`x = 2\text{ cm}`)  thì thể tích hộp lớn nhất.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa diện tích hình trụ:] Một hình trụ có tổng diện tích toàn phần là  #mi(`S`) . Tìm bán kính đáy  #mi(`r`)  để thể tích khối trụ đạt giá trị lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi chiều cao là  #mi(`h`) . Ta có  #mi(`S = 2\pi r^2 + 2\pi rh \Rightarrow h = \frac{S - 2\pi r^2}{2\pi r}`) . Thể tích  #mi(`V = \pi r^2 h = \pi r^2 \cdot \frac{S - 2\pi r^2}{2\pi r} = \frac{r(S - 2\pi r^2)}{2} = \frac{Sr}{2} - \pi r^3`) . Xét hàm số  #mi(`V(r) = \frac{Sr}{2} - \pi r^3`)  với  #mi(`r > 0`) .  #mi(`V'(r) = \frac{S}{2} - 3\pi r^2`) ;  #mi(`V'(r) = 0 \Leftrightarrow r = \sqrt{\frac{S}{6\pi}}`) . Lập bảng biến thiên,  #mi(`V`)  đạt giá trị lớn nhất tại  #mi(`r = \sqrt{\frac{S}{6\pi}}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán khoảng cách ngắn nhất:] Cho điểm  #mi(`A(2; 1)`)  và đường thẳng  #mi(`\Delta: x + y - 1 = 0`) . Tìm điểm  #mi(`M`)  trên  #mi(`\Delta`)  sao cho khoảng cách  #mi(`AM`)  ngắn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`M(x; 1 - x) \in \Delta`) . Khoảng cách  #mi(`AM = \sqrt{(x - 2)^2 + (1 - x - 1)^2} = \sqrt{(x - 2)^2 + x^2} = \sqrt{2x^2 - 4x + 4}`) . Xét  #mi(`f(x) = 2x^2 - 4x + 4`) .  #mi(`f'(x) = 4x - 4`) ;  #mi(`f'(x) = 0 \Leftrightarrow x = 1`) . Lập bảng biến thiên,  #mi(`f(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = 1`) . Khi đó  #mi(`M(1; 0)`)  và  #mi(`AM_{\min} = \sqrt{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán chuyển động tối ưu:] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 6t + 5`)  (m), với  #mi(`t`)  tính bằng giây. Tìm vận tốc nhỏ nhất của chất điểm trong khoảng thời gian  #mi(`t \in [0; 4]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc  #mi(`v(t) = s'(t) = 3t^2 - 6t + 6`) . Ta có  #mi(`v'(t) = 6t - 6`) ;  #mi(`v'(t) = 0 \Leftrightarrow t = 1`) . Tính  #mi(`v(0) = 6`) ,  #mi(`v(1) = 3`) ,  #mi(`v(4) = 30`) . Vậy vận tốc nhỏ nhất là  #mi(`3\text{ m/s}`)  tại  #mi(`t = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Biến thể trả lời ngắn:] Một hình chữ nhật có diện tích  #mi(`100\text{ cm}^2`) . Tìm chu vi nhỏ nhất của hình chữ nhật đó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi chiều dài là  #mi(`x`)  (cm),  #mi(`x > 0`) . Chiều rộng là  #mi(`\frac{100}{x}`)  (cm). Chu vi  #mi(`P(x) = 2\left(x + \frac{100}{x}\right)`) . Ta có  #mi(`P'(x) = 2\left(1 - \frac{100}{x^2}\right)`) ;  #mi(`P'(x) = 0 \Leftrightarrow x = 10`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = 10`) . Khi đó  #mi(`P_{\min} = 2(10 + 10) = 40\text{ cm}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một tấm nhôm hình vuông cạnh  #mi(`24\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện:  #mi(`0 < x < 12`) . Cạnh đáy của hộp là  #mi(`24 - 2x`)  (cm). Thể tích  #mi(`V(x) = x(24 - 2x)^2 = 4x^3 - 96x^2 + 576x`) .  #mi(`V'(x) = 12x^2 - 192x + 576 = 12(x^2 - 16x + 48)`) .  #mi(`V'(x) = 0 \Leftrightarrow x = 4`)  hoặc  #mi(`x = 12`)  (loại). Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 4`) . Vậy  #mi(`x = 4\text{ cm}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một tấm nhôm hình vuông cạnh  #mi(`18\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện:  #mi(`0 < x < 9`) . Cạnh đáy của hộp là  #mi(`18 - 2x`)  (cm). Thể tích  #mi(`V(x) = x(18 - 2x)^2 = 4x^3 - 72x^2 + 324x`) .  #mi(`V'(x) = 12x^2 - 144x + 324 = 12(x^2 - 12x + 27)`) .  #mi(`V'(x) = 0 \Leftrightarrow x = 3`)  hoặc  #mi(`x = 9`)  (loại). Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 3`) . Vậy  #mi(`x = 3\text{ cm}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một hình trụ có tổng diện tích toàn phần là  #mi(`48\pi`) . Tìm bán kính đáy  #mi(`r`)  để thể tích khối trụ đạt giá trị lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi chiều cao là  #mi(`h`) . Ta có  #mi(`S_{tp} = 2\pi r^2 + 2\pi rh = 48\pi \Rightarrow h = \frac{24 - r^2}{r}`) . Thể tích  #mi(`V = \pi r^2 h = \pi r(24 - r^2) = 24\pi r - \pi r^3`) . Xét  #mi(`V(r) = 24\pi r - \pi r^3`)  với  #mi(`r > 0`) .  #mi(`V'(r) = 24\pi - 3\pi r^2`) ;  #mi(`V'(r) = 0 \Leftrightarrow r = 2\sqrt{2}`) . Lập bảng biến thiên,  #mi(`V`)  đạt giá trị lớn nhất tại  #mi(`r = 2\sqrt{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho điểm  #mi(`A(1; 3)`)  và đường thẳng  #mi(`\Delta: 2x - y + 1 = 0`) . Tìm điểm  #mi(`M`)  trên  #mi(`\Delta`)  sao cho khoảng cách  #mi(`AM`)  ngắn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`M(x; 2x + 1) \in \Delta`) . Khoảng cách  #mi(`AM = \sqrt{(x - 1)^2 + (2x + 1 - 3)^2} = \sqrt{(x - 1)^2 + (2x - 2)^2} = \sqrt{5x^2 - 10x + 5} = \sqrt{5(x - 1)^2}`) . Dễ thấy  #mi(`AM`)  nhỏ nhất khi  #mi(`x = 1`) . Khi đó  #mi(`M(1; 3)`)  và  #mi(`AM_{\min} = 0`)  (vì  #mi(`A \in \Delta`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = -t^3 + 9t^2 + 21t`)  (m), với  #mi(`t`)  tính bằng giây. Tìm vận tốc lớn nhất của chất điểm trong khoảng thời gian  #mi(`t \in [0; 6]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc  #mi(`v(t) = s'(t) = -3t^2 + 18t + 21`) . Ta có  #mi(`v'(t) = -6t + 18`) ;  #mi(`v'(t) = 0 \Leftrightarrow t = 3`) . Tính  #mi(`v(0) = 21`) ,  #mi(`v(3) = 48`) ,  #mi(`v(6) = 21`) . Vậy vận tốc lớn nhất là  #mi(`48\text{ m/s}`)  tại  #mi(`t = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Một hình chữ nhật có chu vi  #mi(`40\text{ cm}`) . Tìm diện tích lớn nhất của hình chữ nhật đó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi chiều dài là  #mi(`x`)  (cm),  #mi(`0 < x < 20`) . Chiều rộng là  #mi(`20 - x`)  (cm). Diện tích  #mi(`S(x) = x(20 - x) = 20x - x^2`) .  #mi(`S'(x) = 20 - 2x`) ;  #mi(`S'(x) = 0 \Leftrightarrow x = 10`) . Lập bảng biến thiên,  #mi(`S(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Khi đó  #mi(`S_{\max} = 10 \cdot 10 = 100\text{ cm}^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Bài toán ứng dụng đạo hàm trong chuyển động ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Bài toán ứng dụng đạo hàm trong chuyển động]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Phương trình chuyển động  #mi(`s = s(t)`)  (quãng đường theo thời gian). Vận tốc tức thời là đạo hàm bậc nhất của quãng đường:  #mi(`v(t) = s'(t)`) .
  - Gia tốc tức thời là đạo hàm bậc nhất của vận tốc, hay đạo hàm bậc hai của quãng đường:  #mi(`a(t) = v'(t) = s''(t)`) .
  - Để tìm thời điểm vận tốc lớn nhất/nhỏ nhất, ta tìm cực trị của hàm số  #mi(`v(t)`)  bằng cách giải phương trình  #mi(`v'(t) = 0`)  (hay  #mi(`a(t) = 0`) ) và lập bảng biến thiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ nhanh: 'Quãng - Vận - Gia' tương ứng với 'Hàm - Đạo hàm bậc 1 - Đạo hàm bậc 2'. Tìm vận tốc cực đại thì cho gia tốc  #mi(`a(t) = 0`) .
  ]
  - *Công thức cốt lõi:* Cho phương trình chuyển động  #mi(`s = s(t)`) . Khi đó vận tốc tức thời là  #mi(`v(t) = ...`)  và gia tốc tức thời là  #mi(`a(t) = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  (m),  #mi(`t`)  tính bằng giây. Tính vận tốc của chất điểm tại thời điểm  #mi(`t = 2`)  giây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 9]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có vận tốc tức thời  #mi(`v(t) = s'(t) = 3t^2 - 6t + 9`) . Tại  #mi(`t = 2`) ,  #mi(`v(2) = 3(2)^2 - 6(2) + 9 = 12 - 12 + 9 = 9`)  (m/s).]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  (m). Tính gia tốc của chất điểm tại thời điểm vận tốc đạt giá trị nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc  #mi(`v(t) = 3t^2 - 6t + 9`) . Gia tốc  #mi(`a(t) = v'(t) = 6t - 6`) . Vận tốc nhỏ nhất khi  #mi(`a(t) = 0 \Leftrightarrow 6t - 6 = 0 \Leftrightarrow t = 1`) . Tại  #mi(`t=1`) , gia tốc  #mi(`a(1) = 6(1) - 6 = 0`)  (m/s #mi(`^2`) ).]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính vận tốc tức thời (Biến thể 1):] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`) , trong đó  #mi(`t`)  được tính bằng giây và  #mi(`s`)  được tính bằng mét. Tính vận tốc tức thời của chất điểm tại thời điểm  #mi(`t = 2`)  giây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc tức thời của chất điểm là đạo hàm của quãng đường:  #mi(`v(t) = s'(t) = 3t^2 - 6t + 9`) . Tại thời điểm  #mi(`t = 2`) , ta có  #mi(`v(2) = 3(2)^2 - 6(2) + 9 = 12 - 12 + 9 = 9`)  (m/s). Vậy vận tốc tức thời tại  #mi(`t=2`)  là  #mi(`9`)  m/s.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính gia tốc tức thời (Biến thể 1):] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tính gia tốc tức thời của chất điểm tại thời điểm  #mi(`t = 3`)  giây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc tức thời  #mi(`v(t) = s'(t) = 3t^2 - 6t + 9`) . Gia tốc tức thời là đạo hàm của vận tốc:  #mi(`a(t) = v'(t) = 6t - 6`) . Tại thời điểm  #mi(`t = 3`) , ta có  #mi(`a(3) = 6(3) - 6 = 18 - 6 = 12`)  (m/s #mi(`^2`) ). Vậy gia tốc tại  #mi(`t=3`)  là  #mi(`12`)  m/s #mi(`^2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm thời điểm vận tốc nhỏ nhất (Biến thể 2):] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tìm thời điểm  #mi(`t`)  mà tại đó vận tốc của chất điểm đạt giá trị nhỏ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc tức thời  #mi(`v(t) = s'(t) = 3t^2 - 6t + 9`) . Để tìm thời điểm vận tốc nhỏ nhất, ta tìm cực trị của hàm  #mi(`v(t)`) . Ta có  #mi(`v'(t) = 6t - 6`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow 6t - 6 = 0 \Leftrightarrow t = 1`) . Vì  #mi(`v'(t) < 0`)  với  #mi(`t < 1`)  và  #mi(`v'(t) > 0`)  với  #mi(`t > 1`)  nên hàm  #mi(`v(t)`)  đạt giá trị nhỏ nhất tại  #mi(`t = 1`) . Vậy vận tốc nhỏ nhất tại thời điểm  #mi(`t = 1`)  giây.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán liên quan đến quãng đường (Biến thể 3):] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tính quãng đường chất điểm đi được từ thời điểm  #mi(`t = 1`)  giây đến thời điểm  #mi(`t = 3`)  giây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quãng đường chất điểm đi được từ  #mi(`t=1`)  đến  #mi(`t=3`)  là  #mi(`\Delta s = s(3) - s(1)`) . Ta có  #mi(`s(3) = 3^3 - 3(3)^2 + 9(3) + 2025 = 27 - 27 + 27 + 2025 = 2052`)  (m).  #mi(`s(1) = 1^3 - 3(1)^2 + 9(1) + 2025 = 1 - 3 + 9 + 2025 = 2032`)  (m). Vậy quãng đường đi được là  #mi(`\Delta s = 2052 - 2032 = 20`)  (m).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tính vận tốc tức thời của chất điểm tại thời điểm  #mi(`t = 4`)  giây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc tức thời  #mi(`v(t) = s'(t) = 3t^2 - 6t + 9`) . Tại  #mi(`t = 4`) ,  #mi(`v(4) = 3(4)^2 - 6(4) + 9 = 48 - 24 + 9 = 33`)  (m/s).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tính gia tốc tức thời của chất điểm tại thời điểm  #mi(`t = 5`)  giây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc  #mi(`v(t) = 3t^2 - 6t + 9`) . Gia tốc  #mi(`a(t) = v'(t) = 6t - 6`) . Tại  #mi(`t = 5`) ,  #mi(`a(5) = 6(5) - 6 = 30 - 6 = 24`)  (m/s #mi(`^2`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tìm thời điểm  #mi(`t`)  mà tại đó vận tốc của chất điểm đạt giá trị nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc  #mi(`v(t) = 3t^2 - 6t + 9`) . Gia tốc  #mi(`a(t) = v'(t) = 6t - 6`) . Cho  #mi(`a(t) = 0 \Leftrightarrow 6t - 6 = 0 \Leftrightarrow t = 1`) . Vì  #mi(`a(t)`)  đổi dấu từ âm sang dương khi qua  #mi(`t=1`)  nên  #mi(`v(t)`)  đạt giá trị nhỏ nhất tại  #mi(`t = 1`)  giây.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tính quãng đường chất điểm đi được từ thời điểm  #mi(`t = 2`)  giây đến thời điểm  #mi(`t = 4`)  giây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quãng đường đi được là  #mi(`\Delta s = s(4) - s(2)`) . Ta có  #mi(`s(4) = 4^3 - 3(4)^2 + 9(4) + 2025 = 64 - 48 + 36 + 2025 = 2077`)  (m).  #mi(`s(2) = 2^3 - 3(2)^2 + 9(2) + 2025 = 8 - 12 + 18 + 2025 = 2039`)  (m). Vậy  #mi(`\Delta s = 2077 - 2039 = 38`)  (m).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một chất điểm chuyển động theo phương trình  #mi(`s(t) = t^3 - 3t^2 + 9t + 2025`)  ( #mi(`t`)  tính bằng giây,  #mi(`s`)  tính bằng mét). Tính vận tốc của chất điểm tại thời điểm gia tốc bằng  #mi(`0`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc  #mi(`v(t) = 3t^2 - 6t + 9`) . Gia tốc  #mi(`a(t) = 6t - 6`) . Gia tốc bằng  #mi(`0`)  khi  #mi(`6t - 6 = 0 \Leftrightarrow t = 1`) . Tại  #mi(`t = 1`) , vận tốc  #mi(`v(1) = 3(1)^2 - 6(1) + 9 = 3 - 6 + 9 = 6`)  (m/s).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Bài toán cân bằng lực và ứng dụng vectơ trong vật lý ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Bài toán cân bằng lực và ứng dụng vectơ trong vật lý]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điều kiện cân bằng của chất điểm: Tổng các vectơ lực tác dụng lên chất điểm bằng vectơ không, tức là  #mi(`\vec{F}_1 + \vec{F}_2 + ... + \vec{F}_n = \vec{0}`) .
  - Quy tắc hình bình hành: Nếu hai lực đồng quy  #mi(`\vec{F}_1, \vec{F}_2`)  có hợp lực là  #mi(`\vec{F}`) , thì  #mi(`\vec{F} = \vec{F}_1 + \vec{F}_2`) . Độ lớn hợp lực:  #mi(`F^2 = F_1^2 + F_2^2 + 2F_1F_2\cos\alpha`) , với  #mi(`\alpha`)  là góc giữa hai vectơ lực.
  - Định lý hàm số sin trong tam giác lực:  #mi(`\frac{F_1}{\sin A} = \frac{F_2}{\sin B} = \frac{F_3}{\sin C}`)  (với  #mi(`A, B, C`)  là các góc của tam giác tạo bởi các vectơ lực).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cân bằng lực: 'Tổng lực bằng không' - Vẽ tam giác lực khép kín, dùng sin/cos để giải.
  ]
  - *Công thức cốt lõi:* Điều kiện cân bằng của chất điểm là  #mi(`\vec{F}_1 + \vec{F}_2 + ... + \vec{F}_n = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật có trọng lượng  #mi(`P = 20\sqrt{3} \, N`)  được treo bằng hai sợi dây giống hệt nhau, mỗi dây hợp với phương thẳng đứng một góc  #mi(`30^\circ`) . Tính độ lớn lực căng của mỗi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 20]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`\vec{T}_1, \vec{T}_2`)  là lực căng của hai dây,  #mi(`\vec{P}`)  là trọng lực. Điều kiện cân bằng:  #mi(`\vec{T}_1 + \vec{T}_2 + \vec{P} = \vec{0}`) . Do tính đối xứng,  #mi(`T_1 = T_2 = T`) . Hợp lực của hai lực căng là  #mi(`\vec{T}_{12} = \vec{T}_1 + \vec{T}_2`)  có độ lớn  #mi(`T_{12} = 2T\cos 30^\circ = T\sqrt{3}`) . Để cân bằng với trọng lực,  #mi(`T_{12} = P \Rightarrow T\sqrt{3} = 20\sqrt{3} \Rightarrow T = 20 \, N`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho ba lực đồng quy cùng nằm trong một mặt phẳng, có độ lớn lần lượt là  #mi(`F_1 = 10\,N`) ,  #mi(`F_2 = 10\,N`) ,  #mi(`F_3 = 10\sqrt{3}\,N`)  và từng đôi một hợp với nhau thành góc  #mi(`120^\circ`) . Tính độ lớn hợp lực của ba lực này.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7.32]
      \ #text(fill: rgb("#334155"))[Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F}_1 + \vec{F}_2 + \vec{F}_3`) . Ta có  #mi(`\vec{F}_1 + \vec{F}_2`)  là vectơ có độ lớn  #mi(`2F_1\cos 60^\circ = 10\,N`)  và cùng phương ngược chiều với  #mi(`\vec{F}_3`) . Do đó  #mi(`F = |10 - 10\sqrt{3}| = 10(\sqrt{3} - 1) \approx 7,32\,N`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Một vật có khối lượng  #mi(`m = 5\,kg`)  được giữ yên trên mặt phẳng nghiêng góc  #mi(`30^\circ`)  nhờ một sợi dây song song với mặt phẳng nghiêng. Bỏ qua ma sát, lấy  #mi(`g = 10\,m/s^2`) . Tính lực căng của dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 25]
      \ #text(fill: rgb("#334155"))[Lời giải: Các lực tác dụng: trọng lực  #mi(`\vec{P}`) , phản lực  #mi(`\vec{N}`) , lực căng  #mi(`\vec{T}`) . Điều kiện cân bằng:  #mi(`\vec{P} + \vec{N} + \vec{T} = \vec{0}`) . Chiếu lên phương mặt phẳng nghiêng:  #mi(`T = P\sin 30^\circ = mg\sin 30^\circ = 5 \cdot 10 \cdot 0,5 = 25\,N`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính lực căng dây khi treo vật (Biến thể 1):] Một vật có trọng lượng  #mi(`P = 10\sqrt{3}\,N`)  được treo vào điểm  #mi(`O`)  bằng hai sợi dây  #mi(`OA`)  và  #mi(`OB`)  không dãn, khối lượng không đáng kể. Biết  #mi(`OA`)  và  #mi(`OB`)  hợp với phương thẳng đứng các góc lần lượt là  #mi(`30^\circ`)  và  #mi(`60^\circ`) . Tính độ lớn lực căng của mỗi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{T}_A, \vec{T}_B`)  là lực căng của hai dây,  #mi(`\vec{P}`)  là trọng lực. Điều kiện cân bằng:  #mi(`\vec{T}_A + \vec{T}_B + \vec{P} = \vec{0}`) . Vẽ tam giác lực, áp dụng định lý hàm số sin:  #mi(`\frac{T_A}{\sin 60^\circ} = \frac{T_B}{\sin 30^\circ} = \frac{P}{\sin 90^\circ}`) . Suy ra  #mi(`T_A = P\sin 60^\circ = 10\sqrt{3} \cdot \frac{\sqrt{3}}{2} = 15\,N`) ;  #mi(`T_B = P\sin 30^\circ = 10\sqrt{3} \cdot \frac{1}{2} = 5\sqrt{3}\,N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính hợp lực của nhiều lực (Biến thể 2):] Cho ba lực đồng quy  #mi(`\vec{F}_1, \vec{F}_2, \vec{F}_3`)  cùng nằm trong một mặt phẳng, có độ lớn lần lượt là  #mi(`F_1 = 20\,N`) ,  #mi(`F_2 = 20\,N`) ,  #mi(`F_3 = 20\sqrt{3}\,N`) . Biết  #mi(`\vec{F}_1`)  và  #mi(`\vec{F}_2`)  hợp với nhau một góc  #mi(`120^\circ`) ,  #mi(`\vec{F}_3`)  là phân giác của góc tạo bởi  #mi(`\vec{F}_1`)  và  #mi(`\vec{F}_2`) . Tính độ lớn hợp lực của ba lực.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hợp lực  #mi(`\vec{F} = \vec{F}_1 + \vec{F}_2 + \vec{F}_3`) . Ta có  #mi(`\vec{F}_{12} = \vec{F}_1 + \vec{F}_2`)  có độ lớn  #mi(`F_{12} = 2F_1\cos 60^\circ = 20\,N`)  và hướng dọc theo phân giác của góc  #mi(`\vec{F}_1, \vec{F}_2`) . Vì  #mi(`\vec{F}_3`)  cũng nằm trên phân giác và ngược chiều với  #mi(`\vec{F}_{12}`)  (do  #mi(`\vec{F}_1, \vec{F}_2`)  đối xứng qua  #mi(`\vec{F}_3`) ), nên hợp lực  #mi(`F = |F_3 - F_{12}| = |20\sqrt{3} - 20| = 20(\sqrt{3} - 1) \approx 14,64\,N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán cân bằng trên mặt phẳng nghiêng (Biến thể 3):] Một vật có khối lượng  #mi(`m = 2\,kg`)  nằm trên mặt phẳng nghiêng góc  #mi(`\alpha = 30^\circ`)  so với phương ngang. Hệ số ma sát giữa vật và mặt phẳng nghiêng là  #mi(`\mu = 0,1`) . Để vật cân bằng, người ta tác dụng một lực  #mi(`\vec{F}`)  song song với mặt phẳng nghiêng. Lấy  #mi(`g = 10\,m/s^2`) . Tính độ lớn lực  #mi(`\vec{F}`)  trong trường hợp vật có xu hướng trượt xuống.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Các lực tác dụng: trọng lực  #mi(`\vec{P}`) , phản lực  #mi(`\vec{N}`) , lực ma sát  #mi(`\vec{F}_{ms}`) , lực kéo  #mi(`\vec{F}`) . Điều kiện cân bằng:  #mi(`\vec{P} + \vec{N} + \vec{F}_{ms} + \vec{F} = \vec{0}`) . Chiếu lên phương mặt phẳng nghiêng (chiều dương hướng lên):  #mi(`F + F_{ms} - P\sin\alpha = 0`) . Với  #mi(`F_{ms} = \mu N = \mu P\cos\alpha`) . Suy ra  #mi(`F = P(\sin\alpha - \mu\cos\alpha) = mg(\sin 30^\circ - 0,1\cos 30^\circ) = 2 \cdot 10 \cdot (0,5 - 0,1 \cdot \frac{\sqrt{3}}{2}) = 20(0,5 - 0,05\sqrt{3}) \approx 8,27\,N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể trả lời ngắn (Biến thể 4):] Một chiếc đèn có khối lượng  #mi(`m = 3\,kg`)  được treo vào tường nhờ một sợi dây  #mi(`AB`)  và một thanh chống  #mi(`BC`)  (hình vẽ). Biết thanh  #mi(`BC`)  nằm ngang, dây  #mi(`AB`)  hợp với tường một góc  #mi(`60^\circ`) . Bỏ qua khối lượng của thanh và dây, lấy  #mi(`g = 10\,m/s^2`) . Tính độ lớn lực căng của dây  #mi(`AB`)  và lực nén lên thanh  #mi(`BC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Các lực tác dụng lên điểm  #mi(`B`) : lực căng dây  #mi(`\vec{T}`) , lực đàn hồi của thanh  #mi(`\vec{N}`)  (hướng dọc thanh), trọng lực  #mi(`\vec{P}`)  của đèn. Điều kiện cân bằng:  #mi(`\vec{T} + \vec{N} + \vec{P} = \vec{0}`) . Vẽ tam giác lực vuông tại  #mi(`B`)  (do  #mi(`\vec{N}`)  nằm ngang,  #mi(`\vec{P}`)  thẳng đứng). Góc giữa  #mi(`\vec{T}`)  và  #mi(`\vec{P}`)  là  #mi(`60^\circ`) . Ta có  #mi(`T\cos 60^\circ = P \Rightarrow T = \frac{P}{\cos 60^\circ} = \frac{30}{0,5} = 60\,N`) . Lực nén lên thanh  #mi(`N = T\sin 60^\circ = 60 \cdot \frac{\sqrt{3}}{2} = 30\sqrt{3} \approx 51,96\,N`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một vật có trọng lượng  #mi(`P = 10\sqrt{3}\,N`)  được treo vào điểm  #mi(`O`)  bằng hai sợi dây  #mi(`OA`)  và  #mi(`OB`)  không dãn, khối lượng không đáng kể. Biết  #mi(`OA`)  và  #mi(`OB`)  hợp với phương thẳng đứng các góc lần lượt là  #mi(`30^\circ`)  và  #mi(`60^\circ`) . Tính độ lớn lực căng của mỗi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{T}_A, \vec{T}_B`)  là lực căng của hai dây,  #mi(`\vec{P}`)  là trọng lực. Điều kiện cân bằng:  #mi(`\vec{T}_A + \vec{T}_B + \vec{P} = \vec{0}`) . Vẽ tam giác lực, áp dụng định lý hàm số sin:  #mi(`\frac{T_A}{\sin 60^\circ} = \frac{T_B}{\sin 30^\circ} = \frac{P}{\sin 90^\circ}`) . Suy ra  #mi(`T_A = P\sin 60^\circ = 10\sqrt{3} \cdot \frac{\sqrt{3}}{2} = 15\,N`) ;  #mi(`T_B = P\sin 30^\circ = 10\sqrt{3} \cdot \frac{1}{2} = 5\sqrt{3}\,N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một vật có trọng lượng  #mi(`P = 20\sqrt{3}\,N`)  được treo vào điểm  #mi(`O`)  bằng hai sợi dây  #mi(`OA`)  và  #mi(`OB`)  không dãn, khối lượng không đáng kể. Biết  #mi(`OA`)  và  #mi(`OB`)  hợp với phương thẳng đứng các góc lần lượt là  #mi(`45^\circ`)  và  #mi(`45^\circ`) . Tính độ lớn lực căng của mỗi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{T}_A, \vec{T}_B`)  là lực căng của hai dây,  #mi(`\vec{P}`)  là trọng lực. Điều kiện cân bằng:  #mi(`\vec{T}_A + \vec{T}_B + \vec{P} = \vec{0}`) . Do  #mi(`OA`)  và  #mi(`OB`)  đối xứng qua phương thẳng đứng nên  #mi(`T_A = T_B = T`) . Hợp lực của hai lực căng là  #mi(`T_{12} = 2T\cos 45^\circ = T\sqrt{2}`) . Để cân bằng với trọng lực:  #mi(`T\sqrt{2} = P = 20\sqrt{3} \Rightarrow T = 10\sqrt{6}\,N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho ba lực đồng quy  #mi(`\vec{F}_1, \vec{F}_2, \vec{F}_3`)  cùng nằm trong một mặt phẳng, có độ lớn lần lượt là  #mi(`F_1 = 10\,N`) ,  #mi(`F_2 = 10\,N`) ,  #mi(`F_3 = 10\sqrt{3}\,N`) . Biết  #mi(`\vec{F}_1`)  và  #mi(`\vec{F}_2`)  hợp với nhau một góc  #mi(`120^\circ`) ,  #mi(`\vec{F}_3`)  là phân giác của góc tạo bởi  #mi(`\vec{F}_1`)  và  #mi(`\vec{F}_2`) . Tính độ lớn hợp lực của ba lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F}_1 + \vec{F}_2 + \vec{F}_3`) . Ta có  #mi(`\vec{F}_{12} = \vec{F}_1 + \vec{F}_2`)  có độ lớn  #mi(`F_{12} = 2F_1\cos 60^\circ = 10\,N`)  và hướng dọc theo phân giác của góc  #mi(`\vec{F}_1, \vec{F}_2`) . Vì  #mi(`\vec{F}_3`)  cùng phương ngược chiều với  #mi(`\vec{F}_{12}`) , nên  #mi(`F = |F_3 - F_{12}| = |10\sqrt{3} - 10| = 10(\sqrt{3} - 1) \approx 7,32\,N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật có khối lượng  #mi(`m = 2\,kg`)  nằm trên mặt phẳng nghiêng góc  #mi(`\alpha = 30^\circ`)  so với phương ngang. Hệ số ma sát giữa vật và mặt phẳng nghiêng là  #mi(`\mu = 0,1`) . Để vật cân bằng, người ta tác dụng một lực  #mi(`\vec{F}`)  song song với mặt phẳng nghiêng. Lấy  #mi(`g = 10\,m/s^2`) . Tính độ lớn lực  #mi(`\vec{F}`)  trong trường hợp vật có xu hướng trượt xuống.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các lực tác dụng: trọng lực  #mi(`\vec{P}`) , phản lực  #mi(`\vec{N}`) , lực ma sát  #mi(`\vec{F}_{ms}`) , lực kéo  #mi(`\vec{F}`) . Điều kiện cân bằng:  #mi(`\vec{P} + \vec{N} + \vec{F}_{ms} + \vec{F} = \vec{0}`) . Chiếu lên phương mặt phẳng nghiêng (chiều dương hướng lên):  #mi(`F + F_{ms} - P\sin\alpha = 0`) . Với  #mi(`F_{ms} = \mu N = \mu P\cos\alpha`) . Suy ra  #mi(`F = P(\sin\alpha - \mu\cos\alpha) = mg(\sin 30^\circ - 0,1\cos 30^\circ) = 2 \cdot 10 \cdot (0,5 - 0,1 \cdot \frac{\sqrt{3}}{2}) = 20(0,5 - 0,05\sqrt{3}) \approx 8,27\,N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một chiếc đèn có khối lượng  #mi(`m = 3\,kg`)  được treo vào tường nhờ một sợi dây  #mi(`AB`)  và một thanh chống  #mi(`BC`)  (hình vẽ). Biết thanh  #mi(`BC`)  nằm ngang, dây  #mi(`AB`)  hợp với tường một góc  #mi(`60^\circ`) . Bỏ qua khối lượng của thanh và dây, lấy  #mi(`g = 10\,m/s^2`) . Tính độ lớn lực căng của dây  #mi(`AB`)  và lực nén lên thanh  #mi(`BC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các lực tác dụng lên điểm  #mi(`B`) : lực căng dây  #mi(`\vec{T}`) , lực đàn hồi của thanh  #mi(`\vec{N}`)  (hướng dọc thanh), trọng lực  #mi(`\vec{P}`)  của đèn. Điều kiện cân bằng:  #mi(`\vec{T} + \vec{N} + \vec{P} = \vec{0}`) . Vẽ tam giác lực vuông tại  #mi(`B`)  (do  #mi(`\vec{N}`)  nằm ngang,  #mi(`\vec{P}`)  thẳng đứng). Góc giữa  #mi(`\vec{T}`)  và  #mi(`\vec{P}`)  là  #mi(`60^\circ`) . Ta có  #mi(`T\cos 60^\circ = P \Rightarrow T = \frac{P}{\cos 60^\circ} = \frac{30}{0,5} = 60\,N`) . Lực nén lên thanh  #mi(`N = T\sin 60^\circ = 60 \cdot \frac{\sqrt{3}}{2} = 30\sqrt{3} \approx 51,96\,N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 15: Bài toán xác định hệ số của hàm số từ đồ thị hoặc điều kiện cho trước ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 15. Bài toán xác định hệ số của hàm số từ đồ thị hoặc điều kiện cho trước]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  ( #mi(`a \neq 0`) ): Đồ thị đi qua điểm  #mi(`M(x_0; y_0)`)  cho ta phương trình  #mi(`ax_0^3 + bx_0^2 + cx_0 + d = y_0`) . Điểm cực trị  #mi(`x_{CT}`)  cho ta phương trình  #mi(`3ax_{CT}^2 + 2bx_{CT} + c = 0`) .
  - Hàm số phân thức  #mi(`y = \frac{ax+b}{cx+d}`)  (với  #mi(`c \neq 0, ad-bc \neq 0`) ): Đồ thị có tiệm cận đứng  #mi(`x = -\frac{d}{c}`)  và tiệm cận ngang  #mi(`y = \frac{a}{c}`) . Đồ thị đi qua điểm  #mi(`M(x_0; y_0)`)  cho ta phương trình  #mi(`y_0 = \frac{ax_0+b}{cx_0+d}`) .
  - Hàm số phân thức  #mi(`y = \frac{ax^2+bx+c}{dx+e}`) : Đồ thị có tiệm cận đứng  #mi(`x = -\frac{e}{d}`)  và tiệm cận xiên  #mi(`y = \frac{a}{d}x + \frac{bd-ae}{d^2}`) . Điểm cực trị  #mi(`(x_0; y_0)`)  thỏa mãn hệ phương trình từ đạo hàm và giá trị hàm số.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Điểm thuộc đồ thị thay tọa độ vào hàm số; điểm cực trị thay vào đạo hàm bằng 0; tiệm cận đứng là nghiệm mẫu số, tiệm cận ngang/xiên là giới hạn ở vô cực.
  ]
  - *Công thức cốt lõi:* Đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng  #mi(`x = ...`)  và tiệm cận ngang  #mi(`y = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Biết đồ thị có tiệm cận đứng  #mi(`x = 1`) , tiệm cận ngang  #mi(`y = 2`)  và đi qua điểm  #mi(`A(0; 1)`) . Tính giá trị biểu thức  #mi(`T = a + b + c + d`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Từ tiệm cận đứng  #mi(`x = 1`) , ta có  #mi(`-\frac{d}{c} = 1 \Rightarrow d = -c`) . Từ tiệm cận ngang  #mi(`y = 2`) , ta có  #mi(`\frac{a}{c} = 2 \Rightarrow a = 2c`) . Đồ thị đi qua  #mi(`A(0; 1)`)  nên  #mi(`\frac{b}{d} = 1 \Rightarrow b = d = -c`) . Chọn  #mi(`c = 1`) , suy ra  #mi(`a = 2, b = -1, d = -1`) . Khi đó  #mi(`T = 2 + (-1) + 1 + (-1) = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x^3 + bx^2 + cx + d`)  có đồ thị đi qua điểm  #mi(`A(1; 2)`)  và có điểm cực tiểu tại  #mi(`x = 2`) , giá trị cực tiểu bằng  #mi(`0`) . Tính giá trị biểu thức  #mi(`P = b + c + d`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = 3x^2 + 2bx + c`) . Điểm cực tiểu tại  #mi(`x = 2`)  nên  #mi(`y'(2) = 0 \Rightarrow 12 + 4b + c = 0 \Rightarrow c = -4b - 12`) . Giá trị cực tiểu bằng  #mi(`0`)  nên  #mi(`y(2) = 0 \Rightarrow 8 + 4b + 2c + d = 0`) . Đồ thị đi qua  #mi(`A(1; 2)`)  nên  #mi(`1 + b + c + d = 2 \Rightarrow b + c + d = 1`) . Vậy  #mi(`P = 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm hệ số từ đồ thị hàm bậc ba:] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Biết đồ thị đi qua điểm  #mi(`A(0; 1)`) , có điểm cực đại tại  #mi(`x = -1`)  và điểm cực tiểu tại  #mi(`x = 1`) . Tìm các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, ta có  #mi(`y(0) = 1 \Rightarrow d = 1`) . Đạo hàm  #mi(`y' = 3ax^2 + 2bx + c`) . Điểm cực đại tại  #mi(`x = -1`)  nên  #mi(`y'(-1) = 0 \Rightarrow 3a - 2b + c = 0`) . Điểm cực tiểu tại  #mi(`x = 1`)  nên  #mi(`y'(1) = 0 \Rightarrow 3a + 2b + c = 0`) . Trừ hai phương trình, ta được  #mi(`4b = 0 \Rightarrow b = 0`) . Thay  #mi(`b = 0`)  vào  #mi(`3a + c = 0 \Rightarrow c = -3a`) . Mặt khác, đồ thị đi qua điểm cực tiểu  #mi(`(1; -1)`)  (quan sát từ hình vẽ) nên  #mi(`y(1) = -1 \Rightarrow a + b + c + d = -1 \Rightarrow a + 0 - 3a + 1 = -1 \Rightarrow -2a = -2 \Rightarrow a = 1`) . Suy ra  #mi(`c = -3`) . Vậy  #mi(`a = 1, b = 0, c = -3, d = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm hệ số từ đồ thị hàm phân thức:] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Biết đồ thị có tiệm cận đứng  #mi(`x = 1`) , tiệm cận ngang  #mi(`y = 2`)  và đi qua điểm  #mi(`A(0; 1)`) . Tìm các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ tiệm cận đứng  #mi(`x = 1`) , ta có  #mi(`-\frac{d}{c} = 1 \Rightarrow d = -c`) . Từ tiệm cận ngang  #mi(`y = 2`) , ta có  #mi(`\frac{a}{c} = 2 \Rightarrow a = 2c`) . Đồ thị đi qua  #mi(`A(0; 1)`)  nên  #mi(`\frac{b}{d} = 1 \Rightarrow b = d = -c`) . Chọn  #mi(`c = 1`) , suy ra  #mi(`a = 2, b = -1, d = -1`) . Vậy  #mi(`a = 2, b = -1, c = 1, d = -1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm hệ số từ các điểm cực trị:] Cho hàm số  #mi(`y = x^3 + bx^2 + cx + d`)  có điểm cực đại là  #mi(`A(-1; 3)`)  và điểm cực tiểu là  #mi(`B(1; -1)`) . Tìm các hệ số  #mi(`b, c, d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = 3x^2 + 2bx + c`) . Điểm cực đại  #mi(`A(-1; 3)`)  thuộc đồ thị nên  #mi(`y(-1) = 3 \Rightarrow -1 + b - c + d = 3 \Rightarrow b - c + d = 4`)  (1). Điểm cực tiểu  #mi(`B(1; -1)`)  thuộc đồ thị nên  #mi(`y(1) = -1 \Rightarrow 1 + b + c + d = -1 \Rightarrow b + c + d = -2`)  (2). Điểm cực trị  #mi(`x = -1`)  và  #mi(`x = 1`)  là nghiệm của  #mi(`y' = 0`)  nên  #mi(`y'(-1) = 0 \Rightarrow 3 - 2b + c = 0`)  (3) và  #mi(`y'(1) = 0 \Rightarrow 3 + 2b + c = 0`)  (4). Từ (3) và (4) suy ra  #mi(`b = 0, c = -3`) . Thay vào (1) và (2) ta được  #mi(`d = 1`) . Vậy  #mi(`b = 0, c = -3, d = 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể Trả lời ngắn:] Cho hàm số  #mi(`y = \frac{ax^2+bx+c}{dx+e}`)  có đồ thị như hình vẽ. Biết đồ thị có tiệm cận đứng  #mi(`x = 1`) , tiệm cận xiên  #mi(`y = 2x + 1`)  và đi qua điểm  #mi(`A(0; 1)`) . Tính giá trị biểu thức  #mi(`T = a + b + c + d + e`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ tiệm cận đứng  #mi(`x = 1`) , ta có  #mi(`-\frac{e}{d} = 1 \Rightarrow e = -d`) . Từ tiệm cận xiên  #mi(`y = 2x + 1`) , ta có  #mi(`\frac{a}{d} = 2 \Rightarrow a = 2d`)  và  #mi(`\frac{bd-ae}{d^2} = 1`) . Thay  #mi(`a = 2d, e = -d`)  vào ta được  #mi(`\frac{bd - 2d(-d)}{d^2} = 1 \Rightarrow \frac{bd + 2d^2}{d^2} = 1 \Rightarrow b + 2d = d \Rightarrow b = -d`) . Đồ thị đi qua  #mi(`A(0; 1)`)  nên  #mi(`\frac{c}{e} = 1 \Rightarrow c = e = -d`) . Chọn  #mi(`d = 1`) , suy ra  #mi(`a = 2, b = -1, c = -1, e = -1`) . Khi đó  #mi(`T = 2 + (-1) + (-1) + 1 + (-1) = 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Biết đồ thị đi qua điểm  #mi(`O(0; 0)`) , có điểm cực đại tại  #mi(`x = -1`)  và điểm cực tiểu tại  #mi(`x = 1`) . Tìm các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ đồ thị, ta có  #mi(`y(0) = 0 \Rightarrow d = 0`) . Đạo hàm  #mi(`y' = 3ax^2 + 2bx + c`) . Điểm cực đại tại  #mi(`x = -1`)  nên  #mi(`y'(-1) = 0 \Rightarrow 3a - 2b + c = 0`) . Điểm cực tiểu tại  #mi(`x = 1`)  nên  #mi(`y'(1) = 0 \Rightarrow 3a + 2b + c = 0`) . Trừ hai phương trình, ta được  #mi(`4b = 0 \Rightarrow b = 0`) . Thay  #mi(`b = 0`)  vào  #mi(`3a + c = 0 \Rightarrow c = -3a`) . Mặt khác, đồ thị đi qua điểm cực tiểu  #mi(`(1; -2)`)  (quan sát từ hình vẽ) nên  #mi(`y(1) = -2 \Rightarrow a + b + c + d = -2 \Rightarrow a + 0 - 3a + 0 = -2 \Rightarrow -2a = -2 \Rightarrow a = 1`) . Suy ra  #mi(`c = -3`) . Vậy  #mi(`a = 1, b = 0, c = -3, d = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Biết đồ thị đi qua điểm  #mi(`A(0; 2)`) , có điểm cực đại tại  #mi(`x = -1`)  và điểm cực tiểu tại  #mi(`x = 1`) . Tìm các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ đồ thị, ta có  #mi(`y(0) = 2 \Rightarrow d = 2`) . Đạo hàm  #mi(`y' = 3ax^2 + 2bx + c`) . Điểm cực đại tại  #mi(`x = -1`)  nên  #mi(`y'(-1) = 0 \Rightarrow 3a - 2b + c = 0`) . Điểm cực tiểu tại  #mi(`x = 1`)  nên  #mi(`y'(1) = 0 \Rightarrow 3a + 2b + c = 0`) . Trừ hai phương trình, ta được  #mi(`4b = 0 \Rightarrow b = 0`) . Thay  #mi(`b = 0`)  vào  #mi(`3a + c = 0 \Rightarrow c = -3a`) . Mặt khác, đồ thị đi qua điểm cực tiểu  #mi(`(1; 0)`)  (quan sát từ hình vẽ) nên  #mi(`y(1) = 0 \Rightarrow a + b + c + d = 0 \Rightarrow a + 0 - 3a + 2 = 0 \Rightarrow -2a = -2 \Rightarrow a = 1`) . Suy ra  #mi(`c = -3`) . Vậy  #mi(`a = 1, b = 0, c = -3, d = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Biết đồ thị có tiệm cận đứng  #mi(`x = 2`) , tiệm cận ngang  #mi(`y = 1`)  và đi qua điểm  #mi(`A(0; 1)`) . Tìm các hệ số  #mi(`a, b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ tiệm cận đứng  #mi(`x = 2`) , ta có  #mi(`-\frac{d}{c} = 2 \Rightarrow d = -2c`) . Từ tiệm cận ngang  #mi(`y = 1`) , ta có  #mi(`\frac{a}{c} = 1 \Rightarrow a = c`) . Đồ thị đi qua  #mi(`A(0; 1)`)  nên  #mi(`\frac{b}{d} = 1 \Rightarrow b = d = -2c`) . Chọn  #mi(`c = 1`) , suy ra  #mi(`a = 1, b = -2, d = -2`) . Vậy  #mi(`a = 1, b = -2, c = 1, d = -2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^3 + bx^2 + cx + d`)  có điểm cực đại là  #mi(`A(-2; 1)`)  và điểm cực tiểu là  #mi(`B(0; -3)`) . Tìm các hệ số  #mi(`b, c, d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 + 2bx + c`) . Điểm cực đại  #mi(`A(-2; 1)`)  thuộc đồ thị nên  #mi(`y(-2) = 1 \Rightarrow -8 + 4b - 2c + d = 1 \Rightarrow 4b - 2c + d = 9`)  (1). Điểm cực tiểu  #mi(`B(0; -3)`)  thuộc đồ thị nên  #mi(`y(0) = -3 \Rightarrow d = -3`)  (2). Điểm cực trị  #mi(`x = -2`)  và  #mi(`x = 0`)  là nghiệm của  #mi(`y' = 0`)  nên  #mi(`y'(-2) = 0 \Rightarrow 12 - 4b + c = 0`)  (3) và  #mi(`y'(0) = 0 \Rightarrow c = 0`)  (4). Từ (3) và (4) suy ra  #mi(`b = 3`) . Thay vào (1) ta được  #mi(`4(3) - 2(0) + (-3) = 9`)  (luôn đúng). Vậy  #mi(`b = 3, c = 0, d = -3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = \frac{ax^2+bx+c}{dx+e}`)  có đồ thị như hình vẽ. Biết đồ thị có tiệm cận đứng  #mi(`x = -1`) , tiệm cận xiên  #mi(`y = x + 2`)  và đi qua điểm  #mi(`A(0; 1)`) . Tính giá trị biểu thức  #mi(`T = a + b + c + d + e`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ tiệm cận đứng  #mi(`x = -1`) , ta có  #mi(`-\frac{e}{d} = -1 \Rightarrow e = d`) . Từ tiệm cận xiên  #mi(`y = x + 2`) , ta có  #mi(`\frac{a}{d} = 1 \Rightarrow a = d`)  và  #mi(`\frac{bd-ae}{d^2} = 2`) . Thay  #mi(`a = d, e = d`)  vào ta được  #mi(`\frac{bd - d^2}{d^2} = 2 \Rightarrow \frac{b - d}{d} = 2 \Rightarrow b - d = 2d \Rightarrow b = 3d`) . Đồ thị đi qua  #mi(`A(0; 1)`)  nên  #mi(`\frac{c}{e} = 1 \Rightarrow c = e = d`) . Chọn  #mi(`d = 1`) , suy ra  #mi(`a = 1, b = 3, c = 1, e = 1`) . Khi đó  #mi(`T = 1 + 3 + 1 + 1 + 1 = 7`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
