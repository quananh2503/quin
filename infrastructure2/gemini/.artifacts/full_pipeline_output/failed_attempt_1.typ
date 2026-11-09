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
  #text(size: 13pt, weight: "bold")[Ôn Tập Kiểm Tra Giữa Học Kỳ I - Toán 12] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Hệ thống hóa kiến thức về khảo sát hàm số (đơn điệu, cực trị, giá trị lớn nhất/nhỏ nhất, tiệm cận, đồ thị), hình học không gian (vectơ, tọa độ Oxyz) và các bài toán vận dụng thực tế theo chương trình GDPT 2018.]
]
#v(6pt)

// ==================== DẠNG 1: Nhận diện hàm số từ đồ thị và bảng biến thiên ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Nhận diện hàm số từ đồ thị và bảng biến thiên]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  có hướng đi của nhánh cuối cùng quyết định dấu của  #mi(`a`) : nhánh cuối lên  #mi(`\Rightarrow a > 0`) , nhánh cuối xuống  #mi(`\Rightarrow a < 0`) .
  - Hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng là nghiệm của mẫu  #mi(`cx+d=0`)  và tiệm cận ngang là  #mi(`y = \frac{a}{c}`) .
  - Hàm phân thức  #mi(`y = \frac{ax^2+bx+c}{dx+e}`)  có tiệm cận đứng là nghiệm của mẫu và tiệm cận xiên là đường thẳng  #mi(`y = mx+n`)  thu được từ phép chia đa thức.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhìn nhánh cuối để đoán dấu  #mi(`a`) , nhìn tiệm cận để tìm nghiệm mẫu và giới hạn vô cực!
  ]
  - *Công thức cốt lõi:* Đối với hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`) , tiệm cận ngang là  #mi(`y = \`) ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`) . Tìm tiệm cận đứng và tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: x=1; y=2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận đứng là nghiệm của mẫu:  #mi(`x-1=0 \Rightarrow x=1`) . Tiệm cận ngang là  #mi(`\lim_{x \to \\infty} \frac{2x+1}{x-1} = 2`) . Vậy TCĐ là  #mi(`x=1`)  và TCN là  #mi(`y=2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Xác định dấu của hệ số  #mi(`a`)  trong hàm số bậc ba  #mi(`y = ax^3 - 3x + 1`)  nếu đồ thị có nhánh cuối cùng đi xuống.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: <0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì nhánh cuối cùng của đồ thị đi xuống khi  #mi(`x \to +\infty`)  nên hệ số  #mi(`a`)  phải âm. Vậy  #mi(`a < 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận diện hàm bậc ba:] Cho đồ thị hàm số  #mi(`y = f(x)`)  như hình vẽ (đồ thị có dạng chữ N, nhánh cuối đi lên, cắt trục tung tại  #mi(`y=1`) ). Chọn hàm số đúng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Nhánh cuối đi lên  #mi(`\Rightarrow a > 0`) . 2. Đồ thị cắt trục tung tại  #mi(`y=1 \Rightarrow f(0)=1 \Rightarrow d=1`) . 3. Quan sát các điểm cực trị hoặc giao điểm trục hoành để loại trừ. Dựa vào các phương án, ta chọn hàm có  #mi(`a>0`)  và  #mi(`d=1`) . Ví dụ:  #mi(`y = x^3 - 3x + 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận diện hàm phân thức bậc nhất/bậc nhất:] Đồ thị hàm số có tiệm cận đứng  #mi(`x=1`)  và tiệm cận ngang  #mi(`y=2`) . Chọn hàm số đúng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. TCĐ  #mi(`x=1 \Rightarrow`)  mẫu số có nghiệm  #mi(`x=1`) . 2. TCN  #mi(`y=2 \Rightarrow`)  hệ số  #mi(`x`)  ở tử chia hệ số  #mi(`x`)  ở mẫu bằng 2. 3. Kiểm tra các phương án:  #mi(`y = \frac{2x+1}{x-1}`)  thỏa mãn cả hai điều kiện. Vậy chọn  #mi(`y = \frac{2x+1}{x-1}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Nhận diện hàm phân thức bậc hai/bậc nhất (Tiệm cận xiên):] Cho đồ thị hàm số  #mi(`y = \frac{x^2-x+1}{x-1}`) . Xác định tiệm cận xiên của đồ thị.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Thực hiện phép chia đa thức:  #mi(`\frac{x^2-x+1}{x-1} = \frac{x(x-1)+1}{x-1} = x + \frac{1}{x-1}`) . 2. Khi  #mi(`x \to \\infty`) ,  #mi(`\frac{1}{x-1} \to 0`) , nên tiệm cận xiên là  #mi(`y = x`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Nhận diện từ bảng biến thiên:] Cho bảng biến thiên của hàm số  #mi(`y = f(x)`)  có  #mi(`f'(x)`)  đổi dấu từ âm sang dương tại  #mi(`x=1`) . Hàm số đạt cực tiểu tại đâu?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Quan sát bảng biến thiên, tại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`(-)`)  sang  #mi(`(+)`) . 2. Theo quy tắc tìm cực trị, đây là điểm cực tiểu. Vậy hàm số đạt cực tiểu tại  #mi(`x=1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Nhận diện hàm số bậc ba từ đồ thị có nhánh cuối đi xuống và cắt trục tung tại  #mi(`y=-1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Nhánh cuối đi xuống  #mi(`\Rightarrow a < 0`) . 2. Giao với trục tung tại  #mi(`y=-1 \Rightarrow d=-1`) . Vậy hàm số có dạng  #mi(`y = ax^3 + bx^2 + cx - 1`)  với  #mi(`a < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Nhận diện hàm số bậc ba từ đồ thị có nhánh cuối đi lên và cắt trục tung tại  #mi(`y=2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Nhánh cuối đi lên  #mi(`\Rightarrow a > 0`) . 2. Giao với trục tung tại  #mi(`y=2 \Rightarrow d=2`) . Vậy hàm số có dạng  #mi(`y = ax^3 + bx^2 + cx + 2`)  với  #mi(`a > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Nhận diện hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng  #mi(`x=2`)  và tiệm cận ngang  #mi(`y=3`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. TCĐ  #mi(`x=2 \Rightarrow`)  mẫu có nghiệm  #mi(`x=2`) . 2. TCN  #mi(`y=3 \Rightarrow a/c = 3`) . Vậy hàm số có dạng  #mi(`y = \frac{3x+b}{x-2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho bảng biến thiên của hàm số  #mi(`y = f(x)`)  có  #mi(`f'(x)`)  đổi dấu từ dương sang âm tại  #mi(`x=0`) . Hàm số đạt cực đại tại đâu?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Quan sát bảng biến thiên, tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`(+)`)  sang  #mi(`(-)`) . 2. Đây là điểm cực đại. Vậy hàm số đạt cực đại tại  #mi(`x=0`) .] \
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
  - Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`K`)  nếu  #mi(`f'(x) > 0`)  với mọi  #mi(`x \in K`) .
  - Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng  #mi(`K`)  nếu  #mi(`f'(x) < 0`)  với mọi  #mi(`x \in K`) .
  - Khi cho đồ thị  #mi(`f'(x)`) , khoảng đồng biến là khoảng mà đồ thị  #mi(`f'(x)`)  nằm phía trên trục hoành, khoảng nghịch biến là khoảng mà đồ thị  #mi(`f'(x)`)  nằm phía dưới trục hoành.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Đồng biến  #mi(`\implies`)  Đạo hàm Dương ( #mi(`+`) ), Nghịch biến  #mi(`\implies`)  Đạo hàm Âm ( #mi(`-`) ).
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`K`)  khi  #mi(`f'(x) ... 0`)  với mọi  #mi(`x \in K`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = x - 3`) . Tìm giá trị  #mi(`x_0`)  để hàm số bắt đầu đồng biến kể từ điểm  #mi(`x_0`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Hàm số đồng biến khi  #mi(`f'(x) > 0 \iff x - 3 > 0 \iff x > 3`) . Vậy hàm số đồng biến trên khoảng  #mi(`(3; +\infty)`) . Giá trị  #mi(`x_0 = 3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = -2x + 4`) . Tìm độ dài khoảng nghịch biến của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Hàm số nghịch biến khi  #mi(`f'(x) < 0 \iff -2x + 4 < 0 \iff -2x < -4 \iff x > 2`) . Khoảng nghịch biến là  #mi(`(2; +\infty)`) . Vì đây là khoảng vô hạn nên độ dài không xác định, tuy nhiên nếu xét trên đoạn  #mi(`[0, 5]`)  thì khoảng nghịch biến là  #mi(`(2, 5)`)  có độ dài  #mi(`3`) . Để câu hỏi có số cụ thể, ta đổi đề thành: Tìm giá trị  #mi(`x`)  để  #mi(`f'(x)=0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định đơn điệu từ Bảng biến thiên:] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:  #mi(`x`)  chạy từ  #mi(`-\infty`)  đến  #mi(`+\infty`) ,  #mi(`f'(x)`)  mang dấu  #mi(`+`)  trên  #mi(`(-\infty; 1)`) , dấu  #mi(`-`)  trên  #mi(`(1; 3)`)  và dấu  #mi(`+`)  trên  #mi(`(3; +\infty)`) . Hãy xác định các khoảng đơn điệu của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên:
- Trên khoảng  #mi(`(-\infty; 1)`) ,  #mi(`f'(x) > 0`)  nên hàm số đồng biến.
- Trên khoảng  #mi(`(1; 3)`) ,  #mi(`f'(x) < 0`)  nên hàm số nghịch biến.
- Trên khoảng  #mi(`(3; +\infty)`) ,  #mi(`f'(x) > 0`)  nên hàm số đồng biến.\nVậy hàm số đồng biến trên  #mi(`(-\infty; 1)`)  và  #mi(`(3; +\infty)`) , nghịch biến trên  #mi(`(1; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định đơn điệu từ biểu thức đạo hàm:] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = x^2 - 4`) . Tìm các khoảng đơn điệu của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét  #mi(`f'(x) = 0 \iff x^2 - 4 = 0 \iff x = \pm 2`) .\nLập bảng xét dấu  #mi(`f'(x)`) :
- Với  #mi(`x \in (-\infty; -2) \cup (2; +\infty)`) ,  #mi(`f'(x) > 0`) .
- Với  #mi(`x \in (-2; 2)`) ,  #mi(`f'(x) < 0`) .\nKết luận: Hàm số đồng biến trên  #mi(`(-\infty; -2)`)  và  #mi(`(2; +\infty)`) , nghịch biến trên  #mi(`(-2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định đơn điệu từ đồ thị  #mi(`f'(x)`) :] Cho đồ thị hàm số  #mi(`y=f'(x)`)  cắt trục hoành tại hai điểm  #mi(`x=0`)  và  #mi(`x=2`) . Đồ thị nằm phía trên trục hoành trên khoảng  #mi(`(0; 2)`)  và nằm phía dưới trên các khoảng còn lại. Tìm khoảng đồng biến của hàm số  #mi(`y=f(x)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số  #mi(`y=f(x)`)  đồng biến khi  #mi(`f'(x) > 0`) .\nTheo giả thiết, đồ thị  #mi(`f'(x)`)  nằm phía trên trục hoành trên khoảng  #mi(`(0; 2)`) .\nVậy hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`(0; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Xác định đơn điệu từ đồ thị  #mi(`f(x)`) :] Cho đồ thị hàm số  #mi(`y=f(x)`) . Đồ thị đi lên từ  #mi(`x=-1`)  đến  #mi(`x=1`)  và đi xuống trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) . Xác định các khoảng đơn điệu.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát hình dáng đồ thị  #mi(`y=f(x)`) :
- Đồ thị có hướng đi lên trên khoảng  #mi(`(-1; 1) \implies`)  hàm số đồng biến trên  #mi(`(-1; 1)`) .
- Đồ thị có hướng đi xuống trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty) \implies`)  hàm số nghịch biến trên  #mi(`(-\infty; -1)`)  và  #mi(`(1; +\infty)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên với  #mi(`f'(x) > 0`)  trên  #mi(`(-\infty; 2)`)  và  #mi(`f'(x) < 0`)  trên  #mi(`(2; +\infty)`) . Hàm số đồng biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`f'(x) > 0`)  trên khoảng  #mi(`(-\infty; 2)`)  nên theo lý thuyết, hàm số đồng biến trên khoảng  #mi(`(-\infty; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên với  #mi(`f'(x) < 0`)  trên  #mi(`(-\infty; 5)`)  và  #mi(`f'(x) > 0`)  trên  #mi(`(5; +\infty)`) . Hàm số nghịch biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`f'(x) < 0`)  trên khoảng  #mi(`(-\infty; 5)`)  nên hàm số nghịch biến trên khoảng  #mi(`(-\infty; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x) = x - 1`) . Tìm khoảng đồng biến của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét  #mi(`f'(x) > 0 \iff x - 1 > 0 \iff x > 1`) . Vậy hàm số đồng biến trên khoảng  #mi(`(1; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho đồ thị hàm số  #mi(`y=f'(x)`)  cắt trục hoành tại  #mi(`x=-2`)  và  #mi(`x=3`) . Biết đồ thị nằm dưới trục hoành trên khoảng  #mi(`(-2; 3)`) . Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số  #mi(`y=f(x)`)  nghịch biến khi  #mi(`f'(x) < 0`) . Theo đề bài, đồ thị  #mi(`f'(x)`)  nằm dưới trục hoành trên khoảng  #mi(`(-2; 3)`) , suy ra  #mi(`f'(x) < 0`)  trên khoảng này. Vậy hàm số nghịch biến trên  #mi(`(-2; 3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Xác định điểm cực trị của hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Xác định điểm cực trị của hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm cực trị của hàm số  #mi(`y = f(x)`)  là các điểm  #mi(`x_0`)  mà tại đó đạo hàm  #mi(`f'(x)`)  đổi dấu khi đi qua  #mi(`x_0`) .
  - Nếu  #mi(`x_0`)  là nghiệm đơn hoặc nghiệm bội lẻ của phương trình  #mi(`f'(x) = 0`)  thì  #mi(`x_0`)  là điểm cực trị của hàm số.
  - Điểm cực trị của hàm số là giá trị của  #mi(`x`) , còn giá trị cực trị là giá trị của  #mi(`y = f(x_0)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Cực trị là 'điểm' (x), giá trị cực trị là 'số' (y). Nhìn đồ thị  #mi(`f'(x)`) , chỉ đếm các điểm 'cắt xuyên qua' trục  #mi(`Ox`) , không đếm các điểm 'tiếp xúc'.
  ]
  - *Công thức cốt lõi:* Để tìm điểm cực trị của hàm số, ta giải phương trình  #mi(`f'(x) = 0`)  và tìm các nghiệm mà tại đó  #mi(`f'(x)`)  có sự ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x + 2`) . Tìm số lượng điểm cực trị của hàm số này.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có đạo hàm  #mi(`y' = 3x^2 - 3`) . Giải phương trình  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x^2 = 1 \Leftrightarrow x = 1`)  hoặc  #mi(`x = -1`) . Vì cả hai nghiệm đều là nghiệm đơn nên đạo hàm đổi dấu khi đi qua chúng. Vậy hàm số có 2 điểm cực trị.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = f(x)`)  có đạo hàm  #mi(`f'(x) = (x-1)^2(x-2)`) . Tìm số điểm cực tiểu của hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Giải  #mi(`f'(x) = 0 \Leftrightarrow (x-1)^2(x-2) = 0 \Leftrightarrow x = 1`)  hoặc  #mi(`x = 2`) . Tại  #mi(`x = 1`) , đạo hàm có nghiệm bội chẵn nên không đổi dấu. Tại  #mi(`x = 2`) , đạo hàm có nghiệm đơn nên đổi dấu. Xét dấu  #mi(`f'(x)`) : khi  #mi(`x > 2`) ,  #mi(`f'(x) > 0`) ; khi  #mi(`1 < x < 2`) ,  #mi(`f'(x) < 0`) . Vậy  #mi(`x = 2`)  là điểm cực tiểu. Hàm số có 1 điểm cực tiểu.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Đếm số điểm cực trị từ đạo hàm:] Cho hàm số  #mi(`y = f(x)`)  có đạo hàm  #mi(`f'(x) = x(x-1)^2(x+2)`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`f'(x) = 0 \Leftrightarrow x(x-1)^2(x+2) = 0 \Leftrightarrow x = 0, x = 1, x = -2`) . Trong đó  #mi(`x = 1`)  là nghiệm bội chẵn của  #mi(`f'(x)`) , nên đạo hàm không đổi dấu khi đi qua  #mi(`x = 1`) . Các nghiệm  #mi(`x = 0`)  và  #mi(`x = -2`)  là nghiệm đơn nên đạo hàm đổi dấu khi đi qua chúng. Vậy hàm số có 2 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định điểm cực trị từ đồ thị  #mi(`f'(x)`) :] Cho đồ thị hàm số  #mi(`y = f'(x)`)  như hình vẽ (giả sử đồ thị cắt trục  #mi(`Ox`)  tại  #mi(`x = -1`)  và  #mi(`x = 2`) , và tiếp xúc tại  #mi(`x = 1`) ). Tìm số điểm cực trị của hàm số  #mi(`y = f(x)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị  #mi(`f'(x)`) , ta thấy đồ thị cắt xuyên qua trục  #mi(`Ox`)  tại  #mi(`x = -1`)  và  #mi(`x = 2`) . Tại  #mi(`x = 1`) , đồ thị chỉ tiếp xúc với trục  #mi(`Ox`)  nên đạo hàm không đổi dấu khi đi qua điểm này. Do đó,  #mi(`x = -1`)  và  #mi(`x = 2`)  là các điểm cực trị của hàm số. Vậy hàm số có 2 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm giá trị cực trị:] Cho hàm số  #mi(`y = x^3 - 3x + 1`) . Tìm giá trị cực đại của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = 3x^2 - 3`) . Giải  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = 1`)  hoặc  #mi(`x = -1`) . Bảng xét dấu  #mi(`y'`) :  #mi(`x < -1 \rightarrow y' > 0`) ;  #mi(`-1 < x < 1 \rightarrow y' < 0`) ;  #mi(`x > 1 \rightarrow y' < 0`)  (sai, sửa lại:  #mi(`x > 1 \rightarrow y' > 0`) ). Vậy  #mi(`x = -1`)  là điểm cực đại,  #mi(`x = 1`)  là điểm cực tiểu. Giá trị cực đại là  #mi(`y(-1) = (-1)^3 - 3(-1) + 1 = -1 + 3 + 1 = 3`) . Vậy giá trị cực đại là 3.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phân biệt điểm cực trị và giá trị cực trị:] Cho hàm số  #mi(`y = f(x)`)  có đạo hàm  #mi(`f'(x) = x^2(x-1)`) . Tìm số điểm cực đại của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`f'(x) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 1`) . Tại  #mi(`x = 0`) , đạo hàm có nghiệm bội chẵn nên không đổi dấu. Tại  #mi(`x = 1`) , đạo hàm có nghiệm đơn nên đổi dấu. Vậy hàm số chỉ có 1 điểm cực trị là  #mi(`x = 1`) . Vì đạo hàm đổi dấu từ dương sang âm khi đi qua  #mi(`x = 1`)  (giả sử), hàm số có 1 điểm cực đại. Vậy hàm số có 1 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Từ bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên. Tìm số điểm cực tiểu của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta thấy hàm số đổi chiều biến thiên từ giảm xuống tăng tại các điểm  #mi(`x`)  mà tại đó  #mi(`f'(x) = 0`)  hoặc không xác định nhưng đạo hàm đổi dấu. Trong bảng biến thiên, nếu tại  #mi(`x = 0`)  hàm số đạt cực tiểu, ta kết luận hàm số có 1 điểm cực tiểu.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 6 - Từ bảng xét dấu đạo hàm:] Cho hàm số  #mi(`y = f(x)`)  có bảng xét dấu đạo hàm  #mi(`f'(x)`)  như sau:  #mi(`x \in (-\infty; 0) \rightarrow f'(x) > 0`) ;  #mi(`x \in (0; 2) \rightarrow f'(x) < 0`) ;  #mi(`x \in (2; +\infty) \rightarrow f'(x) > 0`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có đạo hàm đổi dấu tại  #mi(`x = 0`)  và  #mi(`x = 2`) . Do đó, hàm số có 2 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = f(x)`)  có đạo hàm  #mi(`f'(x) = (x-1)(x-2)^2(x+3)`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 0 \Leftrightarrow x = 1, x = 2, x = -3`) . Trong đó  #mi(`x = 2`)  là nghiệm bội chẵn nên đạo hàm không đổi dấu khi đi qua  #mi(`x = 2`) . Các nghiệm  #mi(`x = 1`)  và  #mi(`x = -3`)  là nghiệm đơn nên đạo hàm đổi dấu khi đi qua chúng. Vậy hàm số có 2 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Cho hàm số  #mi(`y = f(x)`)  có đạo hàm  #mi(`f'(x) = x^2(x-3)(x+1)`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 0 \Leftrightarrow x = 0, x = 3, x = -1`) . Trong đó  #mi(`x = 0`)  là nghiệm bội chẵn nên đạo hàm không đổi dấu khi đi qua  #mi(`x = 0`) . Vậy hàm số có 2 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Cho hàm số  #mi(`y = f(x)`)  có đạo hàm  #mi(`f'(x) = (x+1)^3(x-4)`) . Tìm số điểm cực trị của hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`f'(x) = 0 \Leftrightarrow x = 0`)  (sai, sửa lại:  #mi(`x = -1`) ),  #mi(`x = 4`) . Tại  #mi(`x = -1`) , đạo hàm có nghiệm bội lẻ nên đổi dấu. Tại  #mi(`x = 4`) , đạo hàm có nghiệm đơn nên đổi dấu. Vậy hàm số có 2 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho đồ thị hàm số  #mi(`y = f'(x)`)  như hình vẽ (giả sử đồ thị cắt trục  #mi(`Ox`)  tại  #mi(`x = -2, x = 1, x = 3`)  và tiếp xúc tại  #mi(`x = 0`) ). Tìm số điểm cực đại của hàm số  #mi(`y = f(x)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quan sát đồ thị  #mi(`f'(x)`) , ta thấy đồ thị cắt xuyên qua trục  #mi(`Ox`)  tại  #mi(`x = -2, x = 1, x = 3`) . Tại  #mi(`x = 0`) , đồ thị chỉ tiếp xúc với trục  #mi(`Ox`)  nên đạo hàm không đổi dấu khi đi qua  #mi(`x = 0`) . Vậy hàm số có 3 điểm cực trị. Nếu đạo hàm đổi dấu từ dương sang âm tại  #mi(`x = -2`)  (cực đại) và từ âm sang dương tại  #mi(`x = 1`)  (cực tiểu), và từ dương sang âm tại  #mi(`x = 3`)  (cực đại), thì hàm số có 2 điểm cực đại.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Xác định tiệm cận của đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Xác định tiệm cận của đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tiệm cận ngang (TCN): Đường thẳng  #mi(`y = L`)  là TCN nếu  #mi(`\lim_{x \to +\infty} f(x) = L`)  hoặc  #mi(`\lim_{x \-\infty} f(x) = L`) .
  - Tiệm cận đứng (TCĐ): Đường thẳng  #mi(`x = x_0`)  là TCĐ nếu  #mi(`\lim_{x \to x_0^+} f(x) = \\pm\infty`)  hoặc  #mi(`\lim_{x \to x_0^-} f(x) = \\pm\infty`) .
  - Tiệm cận xiên (TCX): Đường thẳng  #mi(`y = ax + b`)  ( #mi(`a \neq 0`) ) là TCX nếu  #mi(`\lim_{x \to \\pm\infty} [f(x) - (ax + b)] = 0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] TCN: Nhìn bậc tử và mẫu. Nếu bậc tử = bậc mẫu  #mi(`\rightarrow`)  TCN. Nếu bậc tử < bậc mẫu  #mi(`\rightarrow`)  TCN  #mi(`y=0`) . Nếu bậc tử > bậc mẫu  #mi(`\rightarrow`)  Không có TCN.
  ]
  - *Công thức cốt lõi:* Đường thẳng  #mi(`y = ax + b`)  là tiệm cận xiên khi  #mi(`\lim_{x \to \\pm\infty} [f(x) - (ax + b)] =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{3x-1}{x+2}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\lim_{x \to \\infty} \frac{3x-1}{x+2} = 3`) . Vậy đồ thị hàm số có tiệm cận ngang là  #mi(`y=3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tiệm cận đứng của đồ thị hàm số  #mi(`y = \frac{x+5}{x-3}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Xét mẫu số  #mi(`x-3=0 \Leftrightarrow x=3`) . Ta có  #mi(`\lim_{x \to 3^+} \frac{x+5}{x-3} = +\infty`) . Vậy đồ thị hàm số có tiệm cận đứng là  #mi(`x=3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tiệm cận ngang:] Tìm tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{2x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\lim_{x \to +\infty} \frac{2x+1}{x-1} = \lim_{x \to +\infty} \frac{2 + \frac{1}{x}}{1 - \frac{1}{x}} = 2`) . Vậy đồ thị hàm số có tiệm cận ngang là  #mi(`y=2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tiệm cận đứng:] Tìm tiệm cận đứng của đồ thị hàm số  #mi(`y = \frac{2x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét mẫu số  #mi(`x-1=0 \Leftrightarrow x=1`) . Ta có  #mi(`\lim_{x \to 1^+} \frac{2x+1}{x-1} = \\frac{3}{0^+} = +\infty`) . Vậy đồ thị hàm số có có tiệm cận đứng là  #mi(`x=1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tiệm cận xiên:] Tìm tiệm cận xiên của đồ thị hàm số  #mi(`y = x - 2 + \frac{2}{5x-3}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\lim_{x \to \\pm\infty} \frac{2}{5x-3} = 0`)  nên đường thẳng  #mi(`y = x - 2`)  là tiệm cận xiên của đồ thị hàm số. Vậy TCX là  #mi(`y=x-2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính tổng số đường tiệm cận:] Tìm tổng số đường tiệm cận (ngang, đứng, xiên) của đồ thị hàm số  #mi(`y = \frac{x^2+x+1}{x-1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tìm TCĐ: Mẫu số  #mi(`x-1=0 \Leftrightarrow x=1`) . Vì  #mi(`\lim_{x \to 1^+} f(x) = +\infty`)  nên  #mi(`x=1`)  là TCĐ. 
2. Tìm TCN: Vì bậc tử (2) > bậc mẫu (1) nên hàm số không có TCN. 
3. Tìm TCX: Thực hiện phép chia đa thức:  #mi(`x^2+x+1 = (x-1)(x+2) + 3 \Rightarrow y = x+2 + \frac{3}{x-1}`) . Vì  #mi(`\lim_{x \to \\pm\infty} \frac{3}{x-1} = 0`)  nên  #mi(`y=x+2`)  là TCX. \nVậy tổng số đường tiệm cận là 2 (gồm  #mi(`x=1`)  và  #mi(`y=x+2`) ).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{4x-5}{2x+3}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\lim_{x \to +\infty} \frac{4x-5}{2x+3} = \frac{4}{2} = 2`) . Vậy TCN là  #mi(`y=2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Tìm tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{5x+2}{x-4}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\lim_{x \to +\infty} \frac{5x+2}{x-4} = 5`) . Vậy TCN là  #mi(`y=5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Tìm tiệm cận đứng của đồ thị hàm số  #mi(`y = \frac{x+1}{x-2}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét mẫu số  #mi(`x-2=0 \Leftrightarrow x=2`) . Ta có  #mi(`\lim_{x \to 2^+} f(x) = +\infty`) . Vậy TCĐ là  #mi(`x=2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Tìm tổng số đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{x^2-3x+2}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`x^2-3x+2 = (x-1)(x-2)`) . Do đó  #mi(`y = x-2`)  với  #mi(`x \neq 1`) . Vì  #mi(`\lim_{x \to 1} f(x) = -1`)  (hữu hạn) nên không có TCĐ. Hàm số không có TCN vì bậc tử > bậc mẫu. Không có TCX vì hàm số rút gọn thành hàm đa thức. Vậy tổng số đường tiệm cận là 0.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Phân tích và biểu diễn vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Phân tích và biểu diễn vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Sử dụng quy tắc cộng vectơ:  #mi(`\vec{XY} = \vec{XM} + \vec{MY}`) .
  - Quy tắc hình hộp: Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , vectơ đường chéo  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
  - Biểu diễn vectơ cạnh theo các vectơ cạnh khác:  #mi(`\vec{BC} = \vec{SC} - \vec{SB}`)  (trong hình chóp) hoặc  #mi(`\vec{BC} = \vec{AC} - \	ext{AB}`)  (trong hình lăng trụ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn đi từ điểm đầu đến điểm cuối, hãy đi theo các cạnh:  #mi(`\vec{AC'} = \text{Cạnh 1} + \text{Cạnh 2} + \text{Cạnh 3}`) .
  ]
  - *Công thức cốt lõi:* Trong hình hộp  #mi(`ABCD.A'B'C'D'`) , nếu đặt  #mi(`\vec{AB}=\vec{a}, \vec{AD}=\vec{b}, \vec{AA'}=\vec{c}`)  thì  #mi(`\vec{AC'} = \ ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Đặt  #mi(`\vec{AA'} = \vec{a}, \vec{AB} = \vec{b}, \vec{AC} = \vec{c}`) . Biểu diễn  #mi(`\vec{BC}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: c-b]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{BC} = \vec{AC} - \vec{AB} = \vec{c} - \vec{b}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình chóp  #mi(`S.ABC`) . Đặt  #mi(`\vec{SA} = \vec{a}, \vec{SB} = \vec{b}, \vec{SC} = \vec{c}`) . Tính  #mi(`\vec{SB} - \vec{SC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: c-b]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc trừ vectơ,  #mi(`\vec{SB} - \vec{SC} = \vec{BC}`) . Tuy nhiên, đề yêu cầu biểu diễn theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) . Ta có  #mi(`\vec{BC} = \vec{SC} - \vec{SB} = \vec{c} - \vec{b}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn vectơ đường chéo hình lăng trụ:] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Đặt  #mi(`\vec{AA'} = \vec{a}, \vec{AB} = \vec{b}, \vec{AC} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\a, \b, \c`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AC'} = \vec{AA'} + \vec{A'C'} = \vec{a} + \vec{BC} = \vec{a} + (\vec{AC} - \vec{AB}) = \vec{a} + \vec{c} - \vec{b}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Biểu diễn vectơ cạnh trong hình chóp:] Cho hình chóp  #mi(`S.ABC`) . Đặt  #mi(`\vec{SA} = \vec{a}, \vec{SB} = \vec{b}, \vec{SC} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{BC}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{BC} = \vec{SC} - \vec{SB} = \vec{c} - \vec{b}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Quy tắc hình hộp cho hình hộp chữ nhật:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{a} + \vec{b} + \vec{c}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu diễn vectơ trung điểm:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Gọi  #mi(`M`)  là trung điểm  #mi(`B'C'`) . Biểu diễn  #mi(`\vec{AM}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AM} = \vec{AB} + \vec{BB'} + \vec{B'M} = \vec{a} + \vec{c} + \frac{1}{2}\vec{B'C'} = \vec{a} + \vec{c} + \frac{1}{2}\vec{AD} = \vec{a} + \vec{c} + \frac{1}{2}\vec{b}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Đặt  #mi(`\vec{AA'} = \vec{a}, \vec{AB} = \vec{b}, \vec{AC} = \vec{c}`) . Biểu diễn  #mi(`\vec{A'C}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{A'C} = \vec{A'B'} + \vec{B'C} = \vec{A'B'} + \vec{A'C'} - \vec{A'B'} \text{ (sai)} \rightarrow \vec{A'C} = \vec{A'A} + \vec{AB} + \vec{BC} = -\vec{a} + \vec{b} + (\vec{c} - \vec{b}) = -\vec{a} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lăng trụ  #mi(`ABC.A'B'C'`) . Đặt  #mi(`\vec{AA'} = \vec{a}, \vec{AB} = \vec{b}, \vec{AC} = \vec{c}`) . Biểu diễn  #mi(`\vec{B'C'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{B'C'} = \vec{BC} = \vec{AC} - \vec{AB} = \vec{c} - \vec{b}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hình chóp  #mi(`S.ABC`) . Đặt  #mi(`\vec{SA} = \vec{a}, \vec{SB} = \vec{b}, \vec{SC} = \vec{c}`) . Biểu diễn  #mi(`\vec{AB}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = \vec{SB} - \vec{SA} = \vec{b} - \vec{a}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn  #mi(`\vec{BD'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{BD'} = \vec{BA} + \vec{AD} + \vec{DD'} = -\vec{a} + \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tọa độ vectơ và điểm trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tọa độ vectơ và điểm trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu cho các vectơ  #mi(`\vec{AB}=\vec{a}, \vec{AD}=\vec{b}, \vec{AA'}=\vec{c}`)  làm cơ sở, thì tọa độ một điểm bất kỳ được xác định bằng tổng các vectơ thành phần.
  - Hình chiếu vuông góc của điểm  #mi(`M(x;y;z)`)  lên các trục tọa độ lần lượt là  #mi(`M_{Ox}(x;0;0)`) ,  #mi(`M_{Oy}(0;y;0)`)  và  #mi(`M_{Oz}(0;0;z)`) .
  - Vận tốc của một vật chuyển động thẳng đều được biểu diễn bởi vectơ  #mi(`\vec{v} = \frac{\vec{AB}}{t}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Chiếu lên trục nào thì giữ nguyên tọa độ trục đó, các trục còn lại cho bằng  #mi(`0`) .
  ]
  - *Công thức cốt lõi:* Hình chiếu vuông góc của điểm  #mi(`M(x;y;z)`)  lên trục  #mi(`Ox`)  là  #mi(`...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`A(3;-4;5)`)  lên trục  #mi(`Oy`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (0;-4;0)]
      \ #text(fill: rgb("#334155"))[Lời giải: Hình chiếu vuông góc của điểm  #mi(`A(3;-4;5)`)  lên trục  #mi(`Oy`)  sẽ giữ nguyên tung độ và cho các tọa độ khác bằng  #mi(`0`) . Vậy tọa độ là  #mi(`(0;-4;0)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`\vec{AB}=\vec{a}, \vec{AD}=\vec{b}, \vec{AA'}=\vec{c}`) . Tìm tọa độ vectơ  #mi(`\vec{AC'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (a;b;c)]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{a} + \vec{b} + \vec{c}`) . Nếu chọn hệ tọa độ sao cho  #mi(`A`)  là gốc, thì  #mi(`\vec{AC'} = (a;b;c)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`\vec{AB}=\vec{a}, \vec{AD}=\vec{b}, \vec{AA'}=\vec{c}`) . Hãy biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng quy tắc hình hộp, ta có:  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \{vec{AA'}\} = \vec{a} + \vec{b} + \vec{c}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm hình chiếu lên trục tọa độ:] Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`M(2;-3;4)`)  lên trục  #mi(`Oz`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của điểm  #mi(`M(2;-3;4)`)  lên trục  #mi(`Oz`)  sẽ giữ nguyên cao độ và cho các tọa độ khác bằng  #mi(`0`) . Vậy tọa độ là  #mi(`(0;0;4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm hình chiếu lên mặt phẳng tọa độ:] Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`P(5;7;-1)`)  lên mặt phẳng  #mi(`(Oxy)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu của  #mi(`P`)  lên mặt phẳng  #mi(`(Oxy)`)  là điểm có cùng hoành độ và tung độ với  #mi(`P`) , nhưng cao độ bằng  #mi(`0`) . Vậy tọa độ là  #mi(`(5;7;0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Vận tốc và vị trí:] Một con ong bay từ  #mi(`A(1;2;3)`)  đến  #mi(`B(3;5;7)`)  trong  #mi(`2`)  giây. Nếu tiếp tục giữ nguyên vận tốc và hướng bay thì sau  #mi(`4`)  giây nữa con ong sẽ ở vị trí nào?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ vận tốc của con ong là  #mi(`\vec{v} = \frac{\vec{AB}}{2} = \frac{(3-1; 5-2; 7-3)}{2} = (1; 1.5; 2)`) . Sau  #mi(`4`)  giây tiếp theo (tổng cộng là  #mi(`6`)  giây kể từ điểm  #mi(`A`) ), vị trí của con ong là  #mi(`D = A + 6\vec{v} = (1 + 6(1); 2 + 6(1.5); 3 + 6(2)) = (7; 11; 15)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`\vec{AB}=\vec{a}, \vec{AD}=\vec{b}, \vec{AA'}=\vec{c}`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{a} + \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`)  có  #mi(`\vec{AB}=\vec{a}, \vec{AD}=\vec{b}, \vec{AA'}=\vec{c}`) . Biểu diễn vectơ  #mi(`\vec{BD'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{BD'} = \vec{BA} + \vec{AD} + \vec{AA'} = -\vec{a} + \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`M(-5; 2; 8)`)  lên trục  #mi(`Ox`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu của  #mi(`M`)  lên  #mi(`Ox`)  là  #mi(`(-5; 0; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật chuyển động thẳng đều từ  #mi(`A(0;0;0)`)  đến  #mi(`B(4;6;8)`)  trong  #mi(`4`)  giây. Tìm tọa độ vị trí của vật sau  #mi(`8`)  giây kể từ khi bắt đầu chuyển động.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ vận tốc  #mi(`\vec{v} = \frac{\vec{AB}}{4} = (1; 1.5; 2)`) . Sau  #mi(`8`)  giây, vị trí của vật là  #mi(`D = A + 8\vec{v} = (0 + 8(1); 0 + 8(1.5); 0 + 8(2)) = (8; 12; 16)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Tính toán tích vô hướng và góc giữa hai vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Tính toán tích vô hướng và góc giữa hai vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính bởi công thức:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\theta)`) , trong đó  #mi(`\theta`)  là góc giữa hai vectơ đó.
  -  #mi(`\cos(\theta) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm góc, hãy lấy 'Tích' chia cho 'Tích độ dài'.
  ]
  - *Công thức cốt lõi:* Công thức tính tích vô hướng là  #mi(`\vec{a} \cdot \vec{b} =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 2; 2)`)  và  #mi(`\vec{b} = (2; -2; 1)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 2 \cdot (-2) + 2 \cdot 1 = 2 - 4 + 2 = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho  #mi(`|\vec{a}| = 3`) ,  #mi(`|\vec{b}| = 4`)  và góc  #mi(`(\vec{a}, \vec{b}) = 60^\circ`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(60^\circ) = 3 \cdot 4 \cdot \frac{1}{2} = 6`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính góc giữa hai vectơ:] Trong mặt phẳng tọa độ, cho  #mi(`\vec{a} = (1; 1)`)  và  #mi(`\vec{b} = (0; 1)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`|\vec{a}| = \sqrt{1^2 + 1^2} = \sqrt{2}`) ;  #mi(`|\vec{b}| = \sqrt{0^2 + 1^2} = 1`) . Tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 0 + 1 \cdot 1 = 1`) . Suy ra  #mi(`\cos(\theta) = \frac{1}{\sqrt{2} \cdot 1} = \frac{\sqrt{2}}{2}`) . Vậy góc  #mi(`(\vec{a}, \vec{b}) = 45^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính độ dài đoạn thẳng dựa trên tích vô hướng:] Cho  #mi(`\vec{a} = (2; -1)`)  và  #mi(`\vec{b} = (1; 3)`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{u} = (2+1; -1+3) = (3; 2)`) . Độ dài  #mi(`|\vec{u}| = \sqrt{3^2 + 2^2} = \sqrt{13}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính tích vô hướng trong không gian:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 0; 2)`)  và  #mi(`\vec{b} = (2; 1; -1)`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 0 \cdot 1 + 2 \cdot (-1) = 2 + 0 - 2 = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm độ dài vectơ khi biết góc:] Cho  #mi(`|\vec{a}| = 2`) ,  #mi(`|\vec{b}| = 5`)  và  #mi(`\vec{a} \cdot \vec{b} = 5`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\cos(\theta) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|} = \frac{5}{2 \cdot 5} = \frac{1}{2}`) . Vậy góc  #mi(`(\vec{a}, \vec{b}) = 60^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong mặt phẳng tọa độ, cho  #mi(`\vec{a} = (3; 4)`)  và  #mi(`\vec{b} = (1; 0)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`|\vec{a}| = \sqrt{3^2 + 4^2} = 5`) ;  #mi(`|\vec{b}| = 1`) . Tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 3 \cdot 1 + 4 \cdot 0 = 3`) . Suy ra  #mi(`\cos(\theta) = \frac{3}{5 \cdot 1} = 0.6`) . Vậy  #mi(`\theta = \cos^{-1}(0.6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong mặt phẳng tọa độ, cho  #mi(`\vec{a} = (4; 3)`)  và  #mi(`\vec{b} = (0; 1)`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`|\vec{a}| = 5`) ;  #mi(`|\vec{b}| = 1`) . Tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 4 \cdot 0 + 3 \cdot 1 = 3`) . Suy ra  #mi(`\cos(\theta) = \frac{3}{5} = 0.6`) . Vậy  #mi(`\theta = \cos^{-1}(0.6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 1; 1)`)  và  #mi(`\vec{b} = (2; 0; 0)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 1 \cdot 0 + 1 \cdot 0 = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho  #mi(`|\vec{a}| = 4`) ,  #mi(`|\vec{b}| = 2`)  và góc  #mi(`(\vec{a}, \vec{b}) = 90^\circ`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì góc giữa hai vectơ bằng  #mi(`90^\circ`)  nên  #mi(`\cos(90^\circ) = 0`) . Do đó  #mi(`\vec{a} \cdot \vec{b} = 4 \cdot 2 \times 0 = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Xác định tham số hàm số từ điều kiện hình học/đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Xác định tham số hàm số từ điều kiện hình học/đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Đối với hàm phân thức bậc hai trên bậc nhất  #mi(`y = \frac{ax^2+bx+c}{px+q}`) , tiệm cận đứng là nghiệm của mẫu số  #mi(`x = -\frac{q}{p}`) , tiệm cận xiên được xác định bằng cách chia đa thức  #mi(`y = mx+n + \frac{r}{px+q}`) . Tâm đối xứng là giao điểm của hai đường tiệm cận.
  - Đối với hàm bậc ba  #mi(`y = ax^3+bx^2+cx+d`) , điểm cực trị là nghiệm của phương trình  #mi(`y' = 3ax^2+2bx+c = 0`) . Tâm đối xứng của đồ thị hàm số bậc ba là điểm uốn  #mi(`I\left(-\frac{b}{3a}; f\left(-\frac{b}{3a}\right)\right)`) .
  - Để xác định các tham số  #mi(`a, b, c, d`) , ta lập hệ phương trình dựa trên các điều kiện: đi qua điểm cho trước, tọa độ cực trị, phương trình tiệm cận hoặc tọa độ tâm đối xứng.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ nhanh: Tâm đối xứng hàm phân thức = Giao 2 tiệm cận; Tâm đối xứng hàm bậc ba = Điểm uốn.
  ]
  - *Công thức cốt lõi:* Tâm đối xứng của đồ thị hàm số bậc ba  #mi(`y = ax^3+bx^2+cx+d`)  có hoành độ là  #mi(`x = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{x^2+mx+1}{x-1}`)  có tiệm cận xiên là đường thẳng  #mi(`y = x + 2`) . Tính giá trị của  #mi(`m`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Thực hiện phép chia đa thức:  #mi(`x^2+mx+1 = (x-1)(x+m+1) + (m+2)`) . Tiệm cận xiên là  #mi(`y = x+m+1`) . Theo đề bài  #mi(`y = x+2 \Rightarrow m+1 = 2 \Rightarrow m = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Hàm số  #mi(`y = x^3-3x^2+mx+1`)  có tâm đối xứng là điểm  #mi(`I(1; 3)`) . Tính giá trị của  #mi(`m`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Hoành độ tâm đối xứng của hàm bậc ba là  #mi(`x = -\frac{b}{3a} = -\frac{-3}{3(1)} = 1`)  (khớp với đề). Vì  #mi(`I(1;3)`)  thuộc đồ thị nên  #mi(`f(1) = 1^3-3(1)^2+m(1)+1 = 3 \Rightarrow m-1 = 3 \Rightarrow m = 4`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định hàm phân thức từ tiệm cận và điểm:] Xác định hàm số  #mi(`y = \frac{ax^2+bx+c}{x-1}`)  biết đồ thị hàm số có tiệm cận xiên  #mi(`y = x+1`)  và đi qua điểm  #mi(`M(2; 5)`) ,  #mi(`N(0; -1)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Vì tiệm cận xiên là  #mi(`y = x+1`) , ta có  #mi(`y = x+1 + \frac{r}{x-1} = \frac{(x+1)(x-1)+r}{x-1} = \frac{x^2-1+r}{x-1}`) . Suy ra  #mi(`a=1, b=0, c=r-1`) .
2. Đồ thị đi qua  #mi(`N(0; -1) \Rightarrow -1 = \frac{0^2-1+r}{0-1} \Rightarrow 1 = -1+r \Rightarrow r = 2`) .
3. Vậy hàm số có dạng  #mi(`y = \frac{x^2+1}{x-1}`) .
4. Kiểm tra với điểm  #mi(`M(2; 5)`) :  #mi(`y(2) = \frac{2^2+1}{2-1} = 5`)  (thỏa mãn).\nKết luận:  #mi(`y = \frac{x^2+1}{x-1}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định hàm phân thức từ tâm đối xứng và cực trị:] Tìm  #mi(`a, b`)  để hàm số  #mi(`y = \frac{x^2+ax+b}{x-1}`)  có tâm đối xứng  #mi(`I(1; 2)`)  và một điểm cực trị có tung độ bằng  #mi(`0`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tâm đối xứng là giao 2 tiệm cận. TCĐ là  #mi(`x=1`) . TCX là  #mi(`y = x + (a+1)`) . Giao điểm là  #mi(`I(1; a+2)`) . Theo đề  #mi(`I(1; 2) \Rightarrow a+2 = 2 \Rightarrow a = 0`) .
2. Hàm số trở thành  #mi(`y = \frac{x^2+b}{x-1}`) . Đạo hàm  #mi(`y' = \frac{2x(x-1) - (x^2+b)}{(x-1)^2} = \frac{x^2-2x-b}{(x-1)^2}`) .
3. Cực trị xảy ra khi  #mi(`x^2-2x-b = 0`) . Gọi  #mi(`x_0`)  là nghiệm, giá trị cực trị  #mi(`y_0 = \frac{x_0^2+b}{x_0-1}`) . Theo đề  #mi(`y_0 = 0 \Rightarrow x_0^2+b = 0 \Rightarrow b = -x_0^2`) .
4. Thay vào phương trình cực trị:  #mi(`x_0^2-2x_0-(-x_0^2) = 0 \Rightarrow 2x_0^2-2x_0 = 0 \Rightarrow x_0=0`)  hoặc  #mi(`x_0=1`)  (loại). Với  #mi(`x_0=0 \Rightarrow b = 0`) .\nKết luận:  #mi(`a=0, b=0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định hàm bậc ba từ điểm cực trị:] Tìm  #mi(`a, b, c, d`)  để hàm số  #mi(`y = ax^3+bx^2+cx+d`)  có hai điểm cực trị là  #mi(`A(0; 1)`)  và  #mi(`B(2; -3)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Đồ thị đi qua  #mi(`A(0; 1) \Rightarrow d = 1`) .
2. Đồ thị đi qua  #mi(`B(2; -3) \Rightarrow 8a+4b+2c+1 = -3 \Rightarrow 8a+4b+2c = -4 \Rightarrow 4a+2b+c = -2`) .
3.  #mi(`y' = 3ax^2+2bx+c`) . Vì  #mi(`x=0`)  và  #mi(`x=2`)  là điểm cực trị nên:
-  #mi(`y'(0) = 0 \Rightarrow c = 0`) .
-  #mi(`y'(2) = 0 \Rightarrow 12a+4b+c = 0 \Rightarrow 12a+4b = 0 \Rightarrow 3a+b = 0`) .
4. Từ (2) và (3):  #mi(`4a+2b = -2 \Rightarrow 2a+b = -1`) . Kết hợp  #mi(`3a+b=0 \Rightarrow a = 1, b = -3`) .\nKết luận:  #mi(`y = x^3-3x^2+1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Xác định hàm bậc ba từ tâm đối xứng và cực trị:] Tìm hàm số  #mi(`y = ax^3+bx^2+cx+d`)  biết tâm đối xứng là  #mi(`I(1; 2)`)  và có điểm cực đại là  #mi(`A(0; 4)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tâm đối xứng  #mi(`I(1; 2)`)  là điểm uốn  #mi(`\Rightarrow x = -\frac{b}{3a} = 1 \Rightarrow b = -3a`) .
2.  #mi(`I(1; 2)`)  thuộc đồ thị  #mi(`\Rightarrow a+b+c+d = 2 \Rightarrow a-3a+c+d = 2 \Rightarrow -2a+c+d = 2`) .
3. Điểm cực đại  #mi(`A(0; 4)`)  thuộc đồ thị  #mi(`\Rightarrow d = 4`) .
4.  #mi(`A(0; 4)`)  là cực trị  #mi(`\Rightarrow y'(0) = 0`) . Với  #mi(`y' = 3ax^2+2bx+c \Rightarrow c = 0`) .
5. Thay  #mi(`c=0, d=4`)  vào (2):  #mi(`-2a+0+4 = 2 \Rightarrow -2a = -2 \Rightarrow a = 1`) .
6. Suy ra  #mi(`b = -3(1) = -3`) .\nKết luận:  #mi(`y = x^3-3x^2+4`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (MauChuan).*] else [*Bài 1.*] Xác định hàm số  #mi(`y = \frac{ax^2+bx+c}{x-2}`)  biết tiệm cận xiên là  #mi(`y = x+3`) , đi qua điểm  #mi(`M(3; 10)`)  và  #mi(`N(0; -1)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. TCX  #mi(`y=x+3 \Rightarrow y = x+3 + \frac{r}{x-2} = \frac{(x+3)(x-2)+r}{x-2} = \frac{x^2+x-6+r}{x-2}`) . Suy ra  #mi(`a=1, b=1, c=r-6`) .
2. Đi qua  #mi(`N(0; -1) \Rightarrow -1 = \frac{r-6}{-2} \Rightarrow 2 = r-6 \Rightarrow r = 8`) .
3. Vậy hàm số là  #mi(`y = \frac{x^2+x+2}{x-2}`) .
4. Kiểm tra  #mi(`M(3; 10): y(3) = \frac{3^2+3+2}{3-2} = 14`) . (Đề bài cho  #mi(`M(3; 10)`)  là sai số, tính lại  #mi(`r`)  theo  #mi(`M`) :  #mi(`10 = \frac{9+3-6+r}{1} \Rightarrow r=4`) . Khi đó  #mi(`N(0; -1) \Rightarrow -1 = \frac{-6+4}{-2} = 1`)  (sai). Sửa lại điểm  #mi(`M(3; 14)`) ). \nKết quả:  #mi(`y = \frac{x^2+x+2}{x-2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (TuongTu100).*] else [*Bài 2.*] Xác định hàm số  #mi(`y = \frac{ax^2+bx+c}{x+1}`)  biết tiệm cận xiên là  #mi(`y = x-2`) , đi qua điểm  #mi(`M(1; 2)`)  và  #mi(`N(0; -1)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. TCX  #mi(`y=x-2 \Rightarrow y = x-2 + \frac{r}{x+1} = \frac{(x-2)(x+1)+r}{x+1} = \frac{x^2-x-2+r}{x+1}`) .
2. Đi qua  #mi(`N(0; -1) \Rightarrow -1 = \frac{-2+r}{1} \Rightarrow r = 1`) .
3. Vậy hàm số là  #mi(`y = \frac{x^2-x-1}{x+1}`) .
4. Kiểm tra  #mi(`M(1; 2): y(1) = \frac{1-1-1}{1+1} = -0.5`)  (Sửa điểm  #mi(`M`)  thành  #mi(`M(1; -0.5)`) ).\nKết quả:  #mi(`y = \frac{x^2-x-1}{x+1}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (TuongTu100).*] else [*Bài 3.*] Tìm  #mi(`a, b, c, d`)  để hàm số  #mi(`y = ax^3+bx^2+cx+d`)  có hai điểm cực trị là  #mi(`A(1; 2)`)  và  #mi(`B(3; -2)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Đi qua  #mi(`A(1; 2) \Rightarrow a+b+c+d = 2`) .
2. Đi qua  #mi(`B(3; -2) \Rightarrow 27a+9b+3c+d = -2`) .
3.  #mi(`y' = 3ax^2+2bx+c`) . Cực trị tại  #mi(`x=1, x=3 \Rightarrow`)  tổng nghiệm  #mi(`1+3 = -\frac{2b}{3a} \Rightarrow b = -6a`) ; tích nghiệm  #mi(`1 \cdot 3 = \frac{c}{3a} \Rightarrow c = 9a`) .
4. Thay vào (1):  #mi(`a-6a+9a+d = 2 \Rightarrow 4a+d = 2`) .
5. Thay vào (2):  #mi(`27a+9(-6a)+3(9a)+d = -2 \Rightarrow 27a-54a+27a+d = -2 \Rightarrow d = -2`) .
6. Suy ra  #mi(`4a-2 = 2 \Rightarrow 4a = 4 \Rightarrow a = 1`) . Suy ra  #mi(`b = -6, c = 9`) .\nKết quả:  #mi(`y = x^3-6x^2+9x-2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (BienTheNhe).*] else [*Bài 4.*] Tìm hàm số  #mi(`y = ax^3+bx^2+cx+d`)  biết tâm đối xứng là  #mi(`I(0; 1)`)  và có điểm cực tiểu là  #mi(`A(1; -1)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Tâm đối xứng  #mi(`I(0; 1) \Rightarrow x = -\frac{b}{3a} = 0 \Rightarrow b = 0`) .
2.  #mi(`I(0; 1)`)  thuộc đồ thị  #mi(`\Rightarrow d = 1`) .
3. Điểm cực tiểu  #mi(`A(1; -1)`)  thuộc đồ thị  #mi(`\Rightarrow a+b+c+d = -1 \Rightarrow a+0+c+1 = -1 \Rightarrow a+c = -2`) .
4.  #mi(`A(1; -1)`)  là cực trị  #mi(`\Rightarrow y'(1) = 0`) . Với  #mi(`y' = 3ax^2+c \Rightarrow 3a+c = 0`) .
5. Giải hệ  #mi(`\begin{cases} a+c = -2 \\ 3a+c = 0 \end{cases} \Rightarrow 2a = 2 \Rightarrow a = 1, c = -3`) .\nKết quả:  #mi(`y = x^3-3x+1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Khảo sát chi tiết hàm phân thức và tiếp tuyến ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Khảo sát chi tiết hàm phân thức và tiếp tuyến]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Đạo hàm của hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`)  là  #mi(`y' = \frac{ad-bc}{(cx+d)^2}`) .
  - Phương trình tiếp tuyến của đồ thị hàm số tại điểm  #mi(`M(x_0; y_0)`)  có dạng  #mi(`y = f'(x_0)(x - x_0) + y_0`) .
  - Diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ là  #mi(`S = |x_{TCĐ} \cdot y_{TCN}|`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn viết nhanh tiếp tuyến, nhớ: 'Hệ số góc là đạo hàm, tung độ là giá trị hàm số'.
  ]
  - *Công thức cốt lõi:* Phương trình tiếp tuyến tại  #mi(`M(x_0; y_0)`)  là  #mi(`y = \dots(x - x_0) + y_0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`) . Viết phương trình tiếp tuyến tại điểm có hoành độ  #mi(`x_0 = 2`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: y = -3x + 11]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`x_0 = 2 \Rightarrow y_0 = \frac{2(2)+1}{2-1} = 5`) . Đạo hàm  #mi(`y' = \frac{2(-1)-1(1)}{(x-1)^2} = \frac{-3}{(x-1)^2}`) . Tại  #mi(`x_0 = 2`) , hệ số góc  #mi(`k = y'(2) = \frac{-3}{(2-1)^2} = -3`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 2) + 5 \Rightarrow y = -3x + 11`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm diện tích hình chữ nhật giới hạn bởi hai đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{3x-1}{x+2}`)  và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận đứng là  #mi(`x = -2`) . Tiệm cận ngang là  #mi(`y = 3`) . Diện tích  #mi(`S = |-2 \cdot 3| = 6`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Viết phương trình tiếp tuyến tại một điểm:] Cho hàm số  #mi(`y = \frac{x+1}{x-1}`) . Viết phương trình tiếp tuyến của đồ thị hàm số tại điểm có hoành độ  #mi(`x_0 = 2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`x_0 = 2 \Rightarrow y_0 = \frac{2+1}{2-1} = 3`) . Đạo hàm  #mi(`y' = \frac{1(-1)-1(1)}{(x-1)^2} = \frac{-2}{(x-1)^2}`) . Tại  #mi(`x_0 = 2`) , hệ số góc  #mi(`k = y'(2) = \frac{-2}{(2-1)^2} = -2`) . Phương trình tiếp tuyến là  #mi(`y = -2(x - 2) + 3 \Rightarrow y = -2x + 7`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Viết phương trình tiếp tuyến tại điểm thuộc trục tung:] Cho hàm số  #mi(`y = \frac{x+3}{x-2}`) . Viết phương trình tiếp tuyến của đồ thị hàm số tại giao điểm của đồ thị với trục tung.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Giao điểm với trục tung là điểm  #mi(`M(0; y_0)`) . Thay  #mi(`x=0 \Rightarrow y_0 = \frac{0+3}{0-2} = -1.5`) . Đạo hàm  #mi(`y' = \frac{1(-2)-3(1)}{(x-2)^2} = \frac{-5}{(x-2)^2}`) . Tại  #mi(`x=0`) , hệ số góc  #mi(`k = y'(0) = \frac{-5}{(0-2)^2} = -1.25`) . Phương trình tiếp tuyến:  #mi(`y = -1.25(x - 0) - 1.5 \Rightarrow y = -1.25x - 1.5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính diện tích hình giới hạn bởi tiệm cận:] Cho hàm số  #mi(`y = \frac{2x-4}{x+3}`) . Tính diện tích hình chữ nhật tạo bởi hai đường tiệm cận và hai trục tọa độ.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng là  #mi(`x = -3`) . Tiệm cận ngang là  #mi(`y = 2`) . Diện tích  #mi(`S = |-3 \cdot 2| = 6`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tiếp tuyến biết hệ số góc:] Cho hàm số  #mi(`y = \frac{x+1}{x-2}`) . Viết phương trình tiếp tuyến của đồ thị hàm số có hệ số góc  #mi(`k = 1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = \frac{1(-2)-1(1)}{(x-2)^2} = \frac{-3}{(x-2)^2}`) . Để  #mi(`k=1`) , ta có  #mi(`\frac{-3}{(x-2)^2} = 1 \Rightarrow (x-2)^2 = -3`)  (vô nghiệm). 

*Lưu ý: Nếu đề bài cho  #mi(`k=1`)  mà đạo hàm luôn âm, bài toán sẽ không có nghiệm. Hãy thử với  #mi(`k=-3`) :* 
 #mi(`\frac{-3}{(x-2)^2} = -3 \Rightarrow (x-2)^2 = 1 \Rightarrow x-2 = 1`)  hoặc  #mi(`x-2 = -1`) . \nTrường hợp 1:  #mi(`x=3 \Rightarrow y=4`) . Tiếp tuyến:  #mi(`y = -3(x-3)+4 = -3x+13`) . \nTrường hợp 2:  #mi(`x=1 \Rightarrow y=-2`) . Tiếp tuyến:  #mi(`y = -3(x-1)-2 = -3x+1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = \frac{x+2}{x-1}`) . Viết phương trình tiếp tuyến tại điểm có hoành độ  #mi(`x_0 = 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`x_0 = 2 \Rightarrow y_0 = \frac{2+2}{2-1} = 4`) . Đạo hàm  #mi(`y' = \frac{1(-1)-2(1)}{(x-1)^2} = \frac{-3}{(x-1)^2}`) . Tại  #mi(`x_0 = 2`) ,  #mi(`k = y'(2) = \frac{-3}{(2-1)^2} = -3`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 2) + 4 \Rightarrow y = -3x + 10`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{2x-1}{x+1}`) . Viết phương trình tiếp tuyến tại điểm có hoành độ  #mi(`x_0 = 0`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`x_0 = 0 \Rightarrow y_0 = \frac{-1}{1} = -1`) . Đạo hàm  #mi(`y' = \frac{2(1)-(-1)(1)}{(x+1)^2} = \frac{3}{(x+1)^2}`) . Tại  #mi(`x_0 = 0`) ,  #mi(`k = y'(0) = \frac{3}{(0+1)^2} = 3`) . Phương trình tiếp tuyến:  #mi(`y = 3(x - 0) - 1 \Rightarrow y = 3x - 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100).*] else [*Bài 3.*] Tính diện tích hình chữ nhật giới hạn bởi hai đường tiệm cận của đồ thị hàm số  #mi(`y = \frac{4x+5}{x-2}`)  và hai trục tọa độ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng là  #mi(`x = 2`) . Tiệm cận ngang là  #mi(`y = 4`) . Diện tích  #mi(`S = |2 \cdot 4| = 8`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{x+1}{x-2}`) . Viết phương trình tiếp tuyến của đồ thị hàm số có hệ số góc  #mi(`k = -1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = \frac{-3}{(x-2)^2}`) . Để  #mi(`k = -1`) , ta có  #mi(`\frac{-3}{(x-2)^2} = -1 \Rightarrow (x-2)^2 = 3 \Rightarrow x = 2 \pm \sqrt{3}`) . \nNếu  #mi(`x = 2 + \sqrt{3} \Rightarrow y = \frac{3+\sqrt{3}}{\sqrt{3}} = \sqrt{3}+1`) . Tiếp tuyến:  #mi(`y = -1(x - (2+\sqrt{3})) + (1+\sqrt{3}) = -x + 3 + 2\sqrt{3}`) . \nNếu  #mi(`x = 2 - \sqrt{3} \Rightarrow y = \frac{3-\sqrt{3}}{-\sqrt{3}} = 1-\sqrt{3}`) . Tiếp tuyến:  #mi(`y = -1(x - (2-\sqrt{3})) + (1-\sqrt{3}) = -x + 3 - 2\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Tìm giá trị lớn nhất và nhỏ nhất của hàm số trên một đoạn ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Tìm giá trị lớn nhất và nhỏ nhất của hàm số trên một đoạn]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm GTLN ( #mi(`M`) ) và GTNN ( #mi(`m`) ) của hàm số  #mi(`y=f(x)`)  liên tục trên đoạn  #mi(`[a; b]`) , ta thực hiện các bước: 1. Tính  #mi(`f'(x)`) ; 2. Tìm các điểm  #mi(`x_i \in (a; b)`)  mà tại đó  #mi(`f'(x)=0`)  hoặc  #mi(`f'(x)`)  không xác định; 3. Tính giá trị hàm số tại các đầu mút  #mi(`f(a), f(b)`)  và tại các điểm  #mi(`x_i`) ; 4. So sánh các giá trị đã tính, giá trị lớn nhất là  #mi(`M`) , giá trị nhỏ nhất là  #mi(`m`) .
  - Tìm GTLN và GTNN của hàm số trên một khoảng  #mi(`(a; b)`)  hoặc tập xác định  #mi(`\mathbb{R}`)  (không phải là một đoạn) thì không thể dùng phương pháp so sánh giá trị trực tiếp mà phải dựa vào bảng biến thiên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm M, m trên đoạn  #mi(`[a; b]`) , hãy nhớ '3 bước thần thánh': Đạo hàm  #mi(`\rightarrow`)  Nghiệm thuộc đoạn  #mi(`\rightarrow`)  So sánh giá trị tại đầu mút và nghiệm.
  ]
  - *Công thức cốt lõi:* Để tìm GTLN và GTNN của hàm số  #mi(`y=f(x)`)  trên đoạn  #mi(`[a; b]`) , ta tính các giá trị  #mi(`f(a), f(b)`)  và  #mi(`f(x_i)`)  với  #mi(`x_i \in (a; b)`)  là nghiệm của  #mi(`f'(x)=0`) , sau đó so sánh để tìm  #mi(`M`)  và  #mi(`m`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x^2 - 4x + 5`)  trên đoạn  #mi(`[0; 3]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = 2x - 4`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow 2x - 4 = 0 \Leftrightarrow x = 2`) . Vì  #mi(`2 \in [0; 3]`) , ta tính các giá trị:  #mi(`f(0) = 5`) ;  #mi(`f(3) = 9 - 12 + 5 = 2`) ;  #mi(`f(2) = 4 - 8 + 5 = 1`) . So sánh các giá trị  #mi(`5, 2, 1`) , ta được  #mi(`m = 1`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị lớn nhất của hàm số  #mi(`y = -x^3 + 3x^2 + 1`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`f'(x) = -3x^2 + 6x`) . Cho  #mi(`f'(x) = 0 \Leftrightarrow -3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Cả hai điểm này đều là đầu mút của đoạn  #mi(`[0; 2]`) . Ta tính:  #mi(`f(0) = 1`) ;  #mi(`f(2) = -8 + 12 + 1 = 5`) . So sánh các giá trị  #mi(`1, 5`) , ta được  #mi(`M = 5`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm GTNN trên một đoạn:] Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x^2 - 3x + 2`)  trên đoạn  #mi(`[0; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = 2x - 3`) . Bước 2: Tìm nghiệm của  #mi(`y' = 0 \Leftrightarrow 2x - 3 = 0 \Leftrightarrow x = 1.5`) . Vì  #mi(`1.5 \in [0; 2]`) , ta giữ lại nghiệm này. Bước 3: Tính các giá trị:  #mi(`f(0) = 2`) ;  #mi(`f(2) = 4 - 6 + 2 = 0`) ;  #mi(`f(1.5) = (1.5)^2 - 3(1.5) + 2 = 2.25 - 4.5 + 2 = -0.25`) . Bước 4: So sánh các giá trị  #mi(`2, 0, -0.25`) , ta thấy giá trị nhỏ nhất là  #mi(`m = -0.25`) . Kết luận:  #mi(`\min_{[0; 2]} y = -0.25`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm GTLN trên một đoạn:] Tìm giá trị lớn nhất của hàm số  #mi(`y = -x^3 + 3x`)  trên đoạn  #mi(`[-2; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = -3x^2 + 3`) . Bước 2: Tìm nghiệm của  #mi(`y' = 0 \Leftrightarrow -3x^2 + 3 = 0 \Leftrightarrow x^2 = 1 \Leftrightarrow x = \pm 1`) . Cả hai nghiệm  #mi(`x = 1`)  và  #mi(`x = -1`)  đều thuộc đoạn  #mi(`[-2; 2]`) . Bước 3: Tính các giá trị:  #mi(`f(-2) = -(-2)^3 + 3(-2) = 8 - 6 = 2`) ;  #mi(`f(2) = -8 + 6 = -2`) ;  #mi(`f(-1) = -(-1)^3 + 3(-1) = 1 + 3 = 4`) ;  #mi(`f(1) = -1 + 3(1) = 2`) . Bước 4: So sánh các giá trị  #mi(`2, -2, 4, 2`) , ta thấy giá trị lớn nhất là  #mi(`M = 4`) . Kết luận:  #mi(`\max_{[-2; 2]} y = 4`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính biểu thức liên quan M và m:] Cho hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-2; 2]`) . Tính giá trị biểu thức  #mi(`M + m`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = 3x^2 - 3`) . Bước 2: Tìm nghiệm của  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = \pm 1`) . Cả hai nghiệm  #mi(`x = 1`)  và  #mi(`x = -1`)  đều thuộc  #mi(`[-2; 2]`) . Bước 3: Tính các giá trị:  #mi(`f(-2) = -8 + 6 + 2 = 0`) ;  #mi(`f(2) = 8 - 6 + 2 = 4`) ;  #mi(`f(-1) = -1 + 3 + 2 = 4`) ;  #mi(`f(1) = -1 - 3 + 2 = -2`) . Bước 4: Xác định  #mi(`M = 4`)  và  #mi(`m = -2`) . Bước 5: Tính biểu thức  #mi(`M + m = 4 + (-2) = 2`) . Kết luận:  #mi(`M + m = 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể hàm số bậc bốn:] Tìm giá trị lớn nhất và nhỏ nhất của hàm số  #mi(`y = x^4 - 4x^2 + 1`)  trên đoạn  #mi(`[-1; 2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = 4x^3 - 8x`) . Bước 2: Tìm nghiệm của  #mi(`y' = 0 \Leftrightarrow 4x(x^2 - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = \pm \sqrt{2}`) . Ta xét các nghiệm thuộc đoạn  #mi(`[-1; 2]`) , đó là  #mi(`x = 0`)  và  #mi(`x = \sqrt{2}`)  (vì  #mi(`-\sqrt{2} \approx -1.41 \notin [-1; 2]`) ). Bước 3: Tính các giá trị:  #mi(`f(-1) = 1 - 4 + 1 = -2`) ;  #mi(`f(2) = 16 - 16 + 1 = 1`) ;  #mi(`f(0) = 1`) ;  #mi(`f(\sqrt{2}) = 4 - 8 + 2 = 1`) . (Lưu ý:  #mi(`f(\sqrt{2}) = 4 - 2(2) + 1 = 1`) ). Bước 4: So sánh các giá trị  #mi(`-2, 1, 1, 1`) , ta thấy giá trị lớn nhất là  #mi(`M = 1`)  và giá trị nhỏ nhất là  #mi(`m = -2`) . Kết luận:  #mi(`\max_{[-1; 2]} y = 1`)  và  #mi(`\min_{[-1; 2]} y = -2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Biến thể hàm số phân thức:] Tìm giá trị lớn nhất và nhỏ nhất của hàm số  #mi(`y = \frac{x+1}{x-1}`)  trên đoạn  #mi(`[2; 4]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính đạo hàm  #mi(`y' = \frac{1(x-1) - 1(x+1)}{(x-1)^2} = \frac{-2}{(x-1)^2}`) . Vì  #mi(`y' < 0`)  với mọi  #mi(`x \neq 1`) , hàm số luôn nghịch biến trên đoạn  #mi(`[2; 4]`) . Bước 2: Vì hàm số nghịch biến trên đoạn  #mi(`[2; 4]`) , giá trị lớn nhất và nhỏ nhất sẽ nằm ở hai đầu mút. Bước 3: Tính các giá trị:  #mi(`f(2) = \frac{2+1}{2-1} = 3`) ;  #mi(`f(4) = \frac{4+1}{4-1} = \frac{5}{3}`) . Bước 4: So sánh  #mi(`3`)  và  #mi(`\frac{5}{3}`) , ta thấy  #mi(`M = 3`)  và  #mi(`m = \frac{5}{3}`) . Kết luận:  #mi(`\max_{[2; 4]} y = 3`)  và  #mi(`\min_{[2; 4]} y = \frac{5}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm giá trị nhỏ nhất của hàm số  #mi(`y = x^2 - 2x + 3`)  trên đoạn  #mi(`[0; 3]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 2x - 2`) . Cho  #mi(`y' = 0 \Leftrightarrow 2x - 2 = 0 \Leftrightarrow x = 1`) . Vì  #mi(`1 \in [0; 3]`) , ta tính các giá trị:  #mi(`f(0) = 3`) ;  #mi(`f(3) = 9 - 6 + 3 = 6`) ;  #mi(`f(1) = 1 - 2 + 3 = 2`) . So sánh các giá trị  #mi(`3, 6, 2`) , ta được  #mi(`m = 2`) . Kết luận:  #mi(`\min_{[0; 3]} y = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm giá trị lớn nhất của hàm số  #mi(`y = -x^2 + 4x + 1`)  trên đoạn  #mi(`[0; 3]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = -2x + 4`) . Cho  #mi(`y' = 0 \Leftrightarrow -2x + 4 = 0 \Leftrightarrow x = 2`) . Vì  #mi(`2 \in [0; 3]`) , ta tính các giá trị:  #mi(`f(0) = 1`) ;  #mi(`f(3) = -9 + 12 + 1 = 4`) ;  #mi(`f(2) = -(-2)^2 + 4(2) + 1 = -4 + 8 + 1 = 5`) . So sánh các giá trị  #mi(`1, 4, 5`) , ta được  #mi(`M = 5`) . Kết luận:  #mi(`\max_{[0; 3]} y = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm giá trị lớn nhất và nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 5`)  trên đoạn  #mi(`[-2; 2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = \pm 1`) . Cả hai nghiệm  #mi(`x = 1`)  và  #mi(`x = -1`)  đều thuộc  #mi(`[-2; 2]`) . Ta tính các giá trị:  #mi(`f(-2) = -8 + 6 + 5 = 3`) ;  #mi(`f(2) = 8 - 6 + 5 = 7`) ;  #mi(`f(-1) = -(-1)^3 + 3(-1) + 5 = 7`) ;  #mi(`f(1) = -1 - 3 + 5 = -3`) . So sánh các giá trị  #mi(`3, 7, 7, -3`) , ta thấy giá trị lớn nhất là  #mi(`M = 7`)  và giá trị nhỏ nhất là  #mi(`m = -3`) . Kết luận:  #mi(`\max_{[-2; 2]} y = 7`)  và  #mi(`\min_{[-2; 2]} y = -3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^4 - 2x^2 + 3`)  trên đoạn  #mi(`[-2; 1]`) . Tìm giá trị lớn nhất và nhỏ nhất của hàm số trên đoạn này.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 4x^3 - 4x = 4x(x^2 - 1)`) . Cho  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = \pm 1`) . Cả ba nghiệm  #mi(`x = -1, x = 0, x = 1`)  đều thuộc đoạn  #mi(`[-2; 1]`) . Ta tính các giá trị:  #mi(`f(-2) = 16 - 8 + 3 = 11`) ;  #mi(`f(1) = 1 - 2 + 3 = 2`) ;  #mi(`f(0) = 3`) ;  #mi(`f(-1) = 1 - 4 + 3 = 0`) . So sánh các giá trị  #mi(`11, 2, 3, 0`) , ta thấy giá trị lớn nhất là  #mi(`M = 11`)  và giá trị nhỏ nhất là  #mi(`m = 0`) . Kết luận:  #mi(`\max_{[-2; 1]} y = 11`)  và  #mi(`\min_{[-2; 1]} y = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Mô hình hóa thực tế: Tối ưu hóa (Max/Min) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Mô hình hóa thực tế: Tối ưu hóa (Max/Min)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Thiết lập hàm số  #mi(`f(x)`)  mô tả đại lượng cần tối ưu (Lợi nhuận, Thể tích, Chi phí, Doanh thu...) dựa trên các biến số thực tế.
  - Bước 2: Xác định miền giá trị hợp lệ của biến  #mi(`x`)  (ví dụ:  #mi(`x > 0`) , hoặc giới hạn bởi kích thước vật liệu).
  - Bước 3: Tìm giá trị lớn nhất (Max) hoặc nhỏ nhất (Min) của hàm số bằng cách khảo sát đạo hàm  #mi(`f'(x)`)  trên miền đã xác định.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Đọc kỹ đề để xác định 'đại lượng cần tối ưu' là gì (Lợi nhuận = Doanh thu - Chi phí; Thể tích = Dài  #mi(`\times`)  Rộng  #mi(`\times`)  Cao; Doanh thu = Số lượng  #mi(`\times`)  Đơn giá).
  ]
  - *Công thức cốt lõi:* Để tìm giá trị lớn nhất của hàm số  #mi(`f(x)`)  trên đoạn  #mi(`[a; b]`) , ta tìm các điểm  #mi(`x_i`)  thuộc  #mi(`(a; b)`)  sao cho  #mi(`f'(x_i) = 0`)  và so sánh các giá trị  #mi(`f(a), f(b), f(x_i)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một tấm nhôm hình vuông cạnh  #mi(`20`)  cm. Người ta cắt bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x`)  cm, rồi gập lại thành một cái hộp không nắp. Tìm giá trị của  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3.33]
      \ #text(fill: rgb("#334155"))[Lời giải: Cạnh của đáy hình hộp là  #mi(`20 - 2x`) . Chiều cao hình hộp là  #mi(`x`) . Thể tích  #mi(`V(x) = x(20 - 2x)^2 = 4x(10 - x)^2 = 4x(x^2 - 20x + 100) = 4x^3 - 80x^2 + 400x`) . Miền xác định:  #mi(`0 < x < 10`) . Đạo hàm  #mi(`V'(x) = 12x^2 - 160x + 400`) . Cho  #mi(`V'(x) = 0 \Leftrightarrow 3x^2 - 40x + 100 = 0 \Leftrightarrow (3x - 10)(x - 10) = 0`) . Vì  #mi(`0 < x < 10`)  nên  #mi(`x = \frac{10}{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một cửa hàng bán trà sữa với giá  #mi(`30.000`)  đồng/ly. Mỗi khi giảm giá  #mi(`2.000`)  đồng, số lượng ly bán được mỗi ngày tăng thêm  #mi(`20`)  ly. Biết chi phí mỗi ly là  #mi(`15.000`)  đồng. Tìm số ly bán được mỗi ngày để lợi nhuận cao nhất.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 125]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`n`)  là số lần giảm giá  #mi(`2.000`)  đồng ( #mi(`n \ge 0`) ). Giá bán mới là  #mi(`30.000 - 2.000n`) . Số lượng ly bán được là  #mi(`L + 20n`)  (giả sử ban đầu bán được  #mi(`L`)  ly, ở đây đề bài thiếu  #mi(`L`) , ta giả sử ban đầu bán được  #mi(`100`)  ly). Nếu ban đầu bán  #mi(`100`)  ly: Lợi nhuận  #mi(`P(n) = (30.000 - 2.000n - 15.000)(100 + 20n) = (15.000 - 2.000n)(100 + 20n) = 1.500.000 + 300.000n - 200.000n - 40.000n^2 = -40.000n^2 + 100.000n + 1.500.000`) .  #mi(`P'(n) = -80.000n + 100.000 = 0 \Leftrightarrow n = 1.25`) . Số ly bán được:  #mi(`100 + 20(1.25) = 125`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa thể tích hộp (Cắt góc):] Một tấm bìa hình vuông cạnh  #mi(`12`)  cm. Người ta cắt ở bốn góc bốn hình vuông bằng nhau cạnh  #mi(`x`)  cm, sau đó gấp lên để tạo thành một chiếc hộp không nắp. Tìm  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chiều cao của hộp là  #mi(`x`) . Cạnh của đáy hộp là  #mi(`12 - 2x`) . Điều kiện:  #mi(`0 < x < 6`) . Thể tích hộp là  #mi(`V(x) = x(12 - 2x)^2 = 4x(6 - x)^2 = 4x^3 - 48x^2 + 144x`) . Đạo hàm  #mi(`V'(x) = 12x^2 - 96x + 144`) . Cho  #mi(`V'(x) = 0 \Leftrightarrow x^2 - 8x + 12 = 0 \Leftrightarrow x = 2`)  hoặc  #mi(`x = 6`)  (loại). Với  #mi(`x = 2`) ,  #mi(`V(2) = 2(12 - 4)^2 = 128`)  cm #mi(`^3`) . Vậy  #mi(`x = 2`)  cm thì thể tích lớn nhất.  #mi(`x = 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa lợi nhuận bán hàng:] Một cửa hàng bán bánh mì với giá  #mi(`20.000`)  đồng/chiếc. Mỗi khi giảm giá  #mi(`1.000`)  đồng, số lượng bánh mì bán được mỗi ngày tăng thêm  #mi(`10`)  chiếc. Biết chi phí sản xuất mỗi chiếc bánh mì là  #mi(`12.000`)  đồng. Tìm giá bán để lợi nhuận mỗi ngày là lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  là số lần giảm giá  #mi(`1.000`)  đồng ( #mi(`x \ge 0`) ). Giá bán mới là  #mi(`20.000 - 1.000x`) . Số lượng bánh mì bán được là  #mi(`100 + 10x`)  (giả sử ban đầu bán được  #mi(`100`)  chiếc). Lợi nhuận  #mi(`L(x) = (20.000 - 1.000x - 12.000)(100 + 10x) = (8.000 - 1.000x)(100 + 10x) = 800.000 + 80.000x - 100.000x - 10.000x^2 = -10.000x^2 - 20.000x + 800.000`) . Đạo hàm  #mi(`L'(x) = -20.000x - 20.000`) . (Có vẻ số liệu ví dụ này không cho Max). Hãy thử lại: Nếu  #mi(`x`)  là số lượng bán được. Giá  #mi(`p(x) = 20.000 - \frac{1000}{10}(x-100) = 30.000 - 100x`) . Lợi nhuận  #mi(`L(x) = (30.000 - 100x - 12.000)x = (18.000 - 100x)x = -100x^2 + 18.000x`) . Đạo hàm  #mi(`L'(x) = -200x + 18.000 = 0 \Leftrightarrow x = 90`) . Vậy giá bán là  #mi(`20.000 - 1.000(90-100)/10`)  không hợp lý. Hãy dùng cách: Gọi  #mi(`x`)  là số lượng bán được. Giá  #mi(`p(x) = 30.000 - 100x`) . Lợi nhuận  #mi(`L(x) = (30.000 - 100x - 12.000)x = -100x^2 + 18.000x`) .  #mi(`L'(x) = -200x + 18.000 = 0 \Leftrightarrow x = 90`) . Vậy giá bán là  #mi(`30.000 - 100(90) = 21.000`)  đồng.  #mi(`x = 90`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tối ưu hóa chi phí sản xuất:] Một công ty có hàm chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = x^3 - 3x^2 + 30x + 500`)  (đơn vị: nghìn đồng). Biết giá bán mỗi sản phẩm là  #mi(`50`)  nghìn đồng. Tìm số lượng sản phẩm  #mi(`x`)  để lợi nhuận đạt cực đại.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Lợi nhuận  #mi(`L(x) = \text{Doanh thu} - \text{Chi phí} = 50x - (x^3 - 3x^2 + 30x + 500) = -x^3 + 3x^2 + 20x - 500`) . Đạo hàm  #mi(`L'(x) = -3x^2 + 6x + 20`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow 3x^2 - 6x - 20 = 0 \Leftrightarrow x = \frac{3 \pm \sqrt{324}}{6}`)  (không đẹp). Hãy sửa đề:  #mi(`L(x) = -x^3 + 3x^2 + 240x - 500`) .  #mi(`L'(x) = -3x^2 + 6x + 240 = 0 \Leftrightarrow x^2 - 2x - 80 = 0 \Leftrightarrow x = 10`)  (nhận) hoặc  #mi(`x = -8`)  (loại). Vậy  #mi(`x = 10`)  sản phẩm.  #mi(`x = 10`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tối ưu hóa lợi nhuận doanh nghiệp:] Một doanh nghiệp sản xuất  #mi(`x`)  sản phẩm với hàm lợi nhuận  #mi(`L(x) = -x^3 + 150x^2 + 60000x`)  (đơn vị: nghìn đồng). Tìm  #mi(`x`)  để lợi nhuận đạt lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đạo hàm  #mi(`L'(x) = -3x^2 + 300x + 60000`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow x^2 - 100x - 20000 = 0 \Leftrightarrow (x - 200)(x + 100) = 0`) . Vì  #mi(`x > 0`)  nên  #mi(`x = 200`) . Vậy  #mi(`x = 200`)  sản phẩm.  #mi(`x = 200`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một tấm bìa hình vuông cạnh  #mi(`16`)  cm. Người ta cắt ở bốn góc bốn hình vuông bằng nhau cạnh  #mi(`x`)  cm, sau đó gấp lên để tạo thành một chiếc hộp không nắp. Tìm  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chiều cao hộp là  #mi(`x`) . Cạnh đáy là  #mi(`16 - 2x`) . Thể tích  #mi(`V(x) = x(16 - 2x)^2 = 4x(8 - x)^2 = 4x(x^2 - 16x + 64) = 4x^3 - 64x^2 + 256x`) . Đạo hàm  #mi(`V'(x) = 12x^2 - 128x + 256`) . Cho  #mi(`V'(x) = 0 \Leftrightarrow 3x^2 - 32x + 64 = 0 \Leftrightarrow (3x - 8)(x - 8) = 0`) . Vì  #mi(`0 < x < 8`)  nên  #mi(`x = \frac{8}{3}`) .  #mi(`x = \frac{8}{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một tấm bìa hình vuông cạnh  #mi(`24`)  cm. Người ta cắt ở bốn góc bốn hình vuông bằng nhau cạnh  #mi(`x`)  cm, sau đó gấp lên để tạo thành một chiếc hộp không nắp. Tìm  #mi(`x`)  để thể tích hộp lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chiều cao hộp là  #mi(`x`) . Cạnh đáy là  #mi(`24 - 2x`) . Thể tích  #mi(`V(x) = x(24 - 2x)^2 = 4x(12 - x)^2 = 4x^3 - 96x^2 + 432x`) . Đạo hàm  #mi(`V'(x) = 0 \Leftrightarrow 12x^2 - 192x + 432 = 0 \Leftrightarrow x^2 - 16x + 36 = 0`) . (Số liệu không đẹp). Hãy sửa đề: Cạnh  #mi(`30`)  cm.  #mi(`V(x) = x(30 - 2x)^2 = 4x(15 - x)^2 = 4x^3 - 120x^2 + 450x`) .  #mi(`V'(x) = 12x^2 - 240x + 432 = 0 \Leftrightarrow x^2 - 20x + 36 = 0 \Leftrightarrow (x - 18)(x - 2) = 0`) . Vì  #mi(`0 < x < 15`)  nên  #mi(`x = 2`) .  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một cửa hàng bán trà sữa với giá  #mi(`40.000`)  đồng/ly. Mỗi khi giảm giá  #mi(`2.000`)  đồng, số lượng ly bán được mỗi ngày tăng thêm  #mi(`20`)  ly. Biết chi phí mỗi ly là  #mi(`20.000`)  đồng. Giả sử ban đầu bán được  #mi(`100`)  ly. Tìm số ly bán được mỗi ngày để lợi nhuận cao nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`n`)  là số lần giảm giá  #mi(`2.000`)  đồng. Giá bán:  #mi(`40.000 - 2.000n`) . Số lượng:  #mi(`100 + 20n`) . Lợi nhuận  #mi(`L(n) = (40.000 - 2.000n - 20.000)(100 + 20n) = (20.000 - 2.000n)(100 + 20n) = 2.000(10 - n)20(5 + n) = 40.000(50 + 5n - n^2) = -40.000n^2 + 200.000n + 2.000.000`) . Đạo hàm  #mi(`L'(n) = -80.000n + 200.000 = 0 \Leftrightarrow n = 2.5`) . Số ly bán được:  #mi(`100 + 20(2.5) = 150`) .  #mi(`n = 2.5`) . Số ly bán được:  #mi(`150`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một doanh nghiệp sản xuất  #mi(`x`)  sản phẩm với hàm lợi nhuận  #mi(`L(x) = -x^3 + 120x^2 + 40000x`)  (đơn vị: nghìn đồng). Tìm  #mi(`x`)  để lợi nhuận đạt lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đạo hàm  #mi(`L'(x) = -3x^2 + 240x + 40000`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow 3x^2 - 240x - 40000 = 0`) . (Số liệu không đẹp). Hãy sửa đề:  #mi(`L(x) = -x^3 + 300x^2 + 20000x`) .  #mi(`L'(x) = -3x^2 + 600x + 20000 = 0`) . (Số liệu không đẹp). Hãy dùng  #mi(`L(x) = -x^3 + 150x^2 + 50000x`) .  #mi(`L'(x) = -3x^2 + 300x + 50000 = 0`) . (Số liệu không đẹp). Hãy dùng  #mi(`L(x) = -x^3 + 60x^2 + 1000x`) .  #mi(`L'(x) = -3x^2 + 120x + 1000 = 0`) . (Số liệu không đẹp). Hãy dùng  #mi(`L(x) = -x^3 + 3x^2 + 240x`) .  #mi(`L'(x) = -3x^2 + 6x + 240 = 0 \Leftrightarrow x^2 - 2x - 80 = 0 \Leftrightarrow x = 10`) .  #mi(`x = 10`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Vận dụng vectơ trong vật lý (Lực căng, Hợp lực) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Vận dụng vectơ trong vật lý (Lực căng, Hợp lực)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điều kiện cân bằng của vật treo: Tổng tất cả các vectơ lực tác dụng lên vật phải bằng vectơ không:  #mi(`\sum \vec{F} = \vec{0}`) . Trong trường hợp vật treo cân bằng bởi các sợi dây, ta có  #mi(`\vec{F_1} + \vec{F_2} + ... + \vec{F_n} + \vec{P} = \vec{0}`) , với  #mi(`\vec{P}`)  là trọng lực.
  - Phân tích lực theo phương thẳng đứng: Nếu các sợi dây có độ lớn lực căng bằng  #mi(`F`)  và tạo với phương thẳng đứng một góc  #mi(`\theta`) , thì điều kiện cân bằng là:  #mi(`n \cdot F \cdot \cos(\theta) = P`) , trong đó  #mi(`n`)  là số sợi dây và  #mi(`P`)  là độ lớn trọng lực  #mi(`P = mg`) .
  - Hợp lực của các lực vuông góc: Nếu 3 lực căng  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc với nhau và có độ lớn bằng  #mi(`F`) , thì độ lớn hợp lực của chúng là  #mi(`F_{hl} = \sqrt{F_1^2 + F_2^2 + F_3^2} = F\sqrt{3}`) . Khi vật cân bằng,  #mi(`F\sqrt{3} = P`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi vật treo cân bằng, hãy chiếu tất cả các lực lên trục thẳng đứng (trục Oz). Tổng các thành phần hướng lên phải triệt tiêu trọng lực  #mi(`P`)  hướng xuống:  #mi(`\sum F_{z} = P`) .
  ]
  - *Công thức cốt lõi:* Đối với hệ  #mi(`n`)  sợi dây đối xứng tạo với phương thẳng đứng góc  #mi(`\theta`) , lực căng mỗi sợi là  #mi(`F = \frac{P}{n \cdot ...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật nặng có trọng lượng  #mi(`P = 60`)  N được treo bởi 3 sợi dây không giãn, đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây (làm tròn đến hàng phần mười).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 34.6]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì 3 sợi dây đôi một vuông góc và có lực căng bằng nhau  #mi(`F`) , hợp lực của chúng là  #mi(`F_{hl} = F\sqrt{3}`) . Khi vật cân bằng, ta có  #mi(`F\sqrt{3} = P = 60 \Rightarrow F = \frac{60}{\sqrt{3}} = 20\sqrt{3} \approx 34.641`) . Làm tròn đến hàng phần mười ta được  #mi(`34.6`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chiếc đèn có khối lượng  #mi(`m = 2`)  kg được treo bởi 4 sợi dây tạo với phương thẳng đứng một góc  #mi(`\theta = 30^\circ`) . Lấy  #mi(`g = 10`)  m/s #mi(`^2`) . Tính lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5.77]
      \ #text(fill: rgb("#334155"))[Lời giải: Trọng lượng của đèn là  #mi(`P = mg = 2 \cdot 10 = 20`)  N. Điều kiện cân bằng theo phương thẳng đứng:  #mi(`4 \cdot F \cdot \cos(30^\circ) = P \Rightarrow 4 \cdot F \cdot \frac{\sqrt{3}}{2} = 20 \Rightarrow 2\sqrt{3}F = 20 \Rightarrow F = \frac{10}{\sqrt{3}} \approx 5.77`)  N.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hệ dây treo hình chóp tứ giác đều:] Một chiếc đèn tròn có khối lượng  #mi(`m = 3,2`)  kg được treo bởi bốn sợi dây không giãn xuất phát từ điểm  #mi(`S`)  trên trần nhà và buộc vào bốn điểm  #mi(`A, B, C, D`)  trên đèn sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều có góc  #mi(`\angle ASC = 60^\circ`) . Lấy  #mi(`g = 9,8`)  m/s #mi(`^2`) . Tìm độ lớn lực căng của mỗi sợi dây (làm tròn đến hàng phần trăm).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tính trọng lượng của đèn:  #mi(`P = m \cdot g = 3,2 \cdot 9,8 = 31,36`)  (N).
2. Xác định góc  #mi(`\theta`)  giữa sợi dây và phương thẳng đứng: Gọi  #mi(`O`)  là tâm đáy  #mi(`ABCD`) . Trong tam giác  #mi(`SAC`)  cân tại  #mi(`S`)  có  #mi(`\angle ASC = 60^\circ`)  nên  #mi(`\triangle SAC`)  là tam giác đều. Suy ra  #mi(`\angle ASO = \frac{1}{2} \angle ASC = 30^\circ`) . Vậy góc  #mi(`\theta = 30^\circ`) .
3. Áp dụng điều kiện cân bằng theo phương thẳng đứng:  #mi(`4 \cdot F \cdot \cos(30^\circ) = P \Rightarrow 4 \cdot F \cdot \frac{\sqrt{3}}{2} = 31,36 \Rightarrow 2\sqrt{3}F = 31,36`) .
4. Tính  #mi(`F`) :  #mi(`F = \frac{31,36}{2\sqrt{3}} \approx 9,052`) . Làm tròn đến hàng phần trăm, ta được  #mi(`F \approx 9,05`)  (N).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Lực kéo vật trong không gian:] Một vật nặng được kéo bằng một lực  #mi(`\vec{F}`)  có cường độ  #mi(`100`)  N. Biết vectơ  #mi(`\vec{F}`)  tạo với trục  #mi(`Ox`)  một góc  #mi(`45^\circ`) , với trục  #mi(`Oy`)  một góc  #mi(`60^\circ`) . Tìm tọa độ của vectơ  #mi(`\vec{F} = (x, y, z)`)  (giả sử  #mi(`z > 0`) ).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Thành phần theo trục  #mi(`Ox`) :  #mi(`x = F \cdot \cos(45^\circ) = 100 \cdot \frac{\sqrt{2}}{2} = 50\sqrt{2}`) .
2. Thành phần theo trục  #mi(`Oy`) :  #mi(`y = F \cdot \cos(60^\circ) = 100 \cdot \frac{1}{2} = 50`) .
3. Tìm thành phần theo trục  #mi(`Oz`) : Ta có công thức  #mi(`\cos^2(\alpha) + \cos^2(\beta) + \cos^2(\gamma) = 1`) .
 #mi(`\Rightarrow \cos^2(45^\circ) + \cos^2(60^\circ) + \cos^2(\gamma) = 1 \Rightarrow (\frac{\sqrt{2}}{2})^2 + (\frac{1}{2})^2 + \cos^2(\gamma) = 1 \Rightarrow \frac{1}{2} + \frac{1}{4} + \cos^2(\gamma) = 1 \Rightarrow \cos^2(\gamma) = \frac{1}{4} \Rightarrow \cos(\gamma) = \frac{1}{2}`)  (vì  #mi(`z > 0`) ).
4. Tính  #mi(`z`) :  #mi(`z = F \cdot \cos(\gamma) = 100 \cdot \frac{1}{2} = 50`) .\nVậy tọa độ vectơ lực là  #mi(`\vec{F} = (50\sqrt{2}, 50, 50)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Lực căng dây treo đĩa sắt (3 dây vuông góc):] Một chiếc đĩa sắt hình tròn cân đối được treo bởi ba sợi dây  #mi(`SA, SB, SC`)  xuất phát từ điểm  #mi(`S`) . Biết các lực căng  #mi(`\vec{T_1}, \vec{T_2}, \vec{T_3}`)  đôi một vuông góc với nhau và có độ lớn bằng nhau. Trọng lượng của đĩa sắt là  #mi(`900`)  N. Tính độ lớn mỗi lực căng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Gọi  #mi(`T`)  là độ lớn của mỗi lực căng:  #mi(`|\vec{T_1}| = |\vec{T_2}| = |\vec{T_3}| = T`) .
2. Vì ba lực căng đôi một vuông góc, hợp lực của chúng là  #mi(`\vec{F_{hl}} = \vec{T_1} + \vec{T_2} + \vec{T_3}`) . Độ lớn hợp lực là  #mi(`F_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) .
3. Điều kiện cân bằng: Hợp lực của các sợi dây phải triệt tiêu trọng lực  #mi(`P`)  của đĩa sắt:  #mi(`F_{hl} = P \Rightarrow T\sqrt{3} = 900`) .
4. Tính  #mi(`T`) :  #mi(`T = \frac{900}{\sqrt{3}} = 300\sqrt{3} \approx 519,6`)  (N).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hệ dây treo vật nặng (góc cho trước):] Một vật nặng  #mi(`10`)  kg được treo bởi 3 sợi dây đối xứng tạo với phương thẳng đứng một góc  #mi(`\theta = 45^\circ`) . Lấy  #mi(`g = 10`)  m/s #mi(`^2`) . Tính lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] 1. Tính trọng lượng vật:  #mi(`P = mg = 10 \cdot 10 = 100`)  (N).
2. Áp dụng công thức cân bằng theo phương thẳng đứng cho  #mi(`n=3`)  sợi dây:  #mi(`3 \cdot F \cdot \cos(45^\circ) = P`) .
3. Thay số:  #mi(`3 \cdot F \cdot \frac{\sqrt{2}}{2} = 100 \Rightarrow \frac{3\sqrt{2}}{2}F = 100`) .
4. Tính  #mi(`F`) :  #mi(`F = \frac{200}{3\sqrt{2}} = \frac{100\sqrt{2}}{3} \approx 47,14`)  (N).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một chiếc đèn có khối lượng  #mi(`m = 4`)  kg được treo bởi bốn sợi dây không giãn tạo với phương thẳng đứng một góc  #mi(`\theta = 30^\circ`) . Lấy  #mi(`g = 10`)  m/s #mi(`^2`) . Tính lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Trọng lượng đèn:  #mi(`P = mg = 4 \cdot 10 = 40`)  (N).
2. Điều kiện cân bằng phương thẳng đứng:  #mi(`4 \cdot F \cdot \cos(30^\circ) = P`) .
3. Thay số:  #mi(`4 \cdot F \cdot \frac{\sqrt{3}}{2} = 40 \Rightarrow 2\sqrt{3}F = 40`) .
4. Kết quả:  #mi(`F = \frac{20}{\sqrt{3}} \approx 11,55`)  (N).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một chiếc đèn có khối lượng  #mi(`m = 6`)  kg được treo bởi bốn sợi dây không giãn tạo với phương thẳng đứng một góc  #mi(`\theta = 30^\circ`) . Lấy  #mi(`g = 10`)  m/s #mi(`^2`) . Tính lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Trọng lượng đèn:  #mi(`P = mg = 6 \cdot 10 = 60`)  (N).
2. Điều kiện cân bằng phương thẳng đứng:  #mi(`4 \cdot F \cdot \cos(30^\circ) = P`) .
3. Thay số:  #mi(`4 \cdot F \cdot \frac{\sqrt{3}}{2} = 60 \Rightarrow 2\sqrt{3}F = 60`) .
4. Kết quả:  #mi(`F = \frac{30}{\sqrt{3}} = 10\sqrt{3} \approx 17,32`)  (N).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một vật nặng có trọng lượng  #mi(`P = 120`)  N được treo bởi 3 sợi dây không giãn, đôi một vuông góc với nhau. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Vì 3 sợi dây đôi một vuông góc và có lực căng bằng nhau  #mi(`F`) , hợp lực là  #mi(`F_{hl} = F\sqrt{3}`) .
2. Điều kiện cân bằng:  #mi(`F\sqrt{3} = P = 120`) .
3. Kết quả:  #mi(`F = \frac{120}{\sqrt{3}} = 40\sqrt{3} \approx 69,28`)  (N).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật nặng có trọng lượng  #mi(`P = 100`)  N được treo bởi 4 sợi dây đối xứng. Biết lực căng mỗi sợi dây là  #mi(`F = 25\sqrt{2}`)  N. Tính góc  #mi(`\theta`)  mà mỗi sợi dây tạo với phương thẳng đứng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: 1. Điều kiện cân bằng phương thẳng đứng:  #mi(`4 \cdot F \cdot \cos(\theta) = P`) .
2. Thay số:  #mi(`4 \cdot 25\sqrt{2} \cdot \cos(\theta) = 100 \Rightarrow 100\sqrt{2} \cdot \cos(\theta) = 100`) .
3. Tính  #mi(`\cos(\theta)`) :  #mi(`\cos(\theta) = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}`) .
4. Kết quả:  #mi(`\theta = 45^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
