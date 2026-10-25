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
  #text(size: 13pt, weight: "bold")[Hệ bất phương trình bậc nhất hai ẩn] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp kiến thức lý thuyết về định nghĩa hệ bất phương trình bậc nhất hai ẩn, cách biểu diễn miền nghiệm hình học, và các bài toán tối ưu (quy hoạch tuyến tính). Nội dung bao gồm các ví dụ minh họa, bài tập trắc nghiệm, đúng/sai và bài tập thực tế về tối ưu hóa lợi nhuận, chi phí và sản lượng.]
]
#v(6pt)

// ==================== DẠNG 1: Kiểm tra điểm thuộc/không thuộc miền nghiệm của hệ bất phương trình ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Kiểm tra điểm thuộc/không thuộc miền nghiệm của hệ bất phương trình]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Một điểm  #mi(`M(x_0; y_0)`)  được gọi là nghiệm của hệ bất phương trình bậc nhất hai ẩn nếu tọa độ  #mi(`(x_0; y_0)`)  thỏa mãn tất cả các bất phương trình trong hệ đó.
  - Để kiểm tra điểm  #mi(`M(x_0; y_0)`)  có thuộc miền nghiệm của hệ hay không, ta thay  #mi(`x = x_0`)  và  #mi(`y = y_0`)  vào từng bất phương trình của hệ. Nếu tất cả các bất phương trình đều trở thành mệnh đề đúng, thì  #mi(`M`)  thuộc miền nghiệm. Nếu có ít nhất một bất phương trình sai, thì  #mi(`M`)  không thuộc miền nghiệm.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Thuộc miền nghiệm  #mi(`\Leftrightarrow`)  Tất cả đều ĐÚNG. Không thuộc miền nghiệm  #mi(`\Leftrightarrow`)  Chỉ cần một cái SAI.
  ]
  - *Công thức cốt lõi:* Điểm  #mi(`M(x_0; y_0)`)  thuộc miền nghiệm của hệ bất phương trình khi và chỉ khi tọa độ  #mi(`(x_0; y_0)`)  ... tất cả các bất phương trình trong hệ.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hệ bất phương trình  #mi(`\begin{cases} x+y \le 3 \ 2x-y \ge 0 \end{cases}`) . Điểm  #mi(`M(1; 1)`)  có thuộc miền nghiệm của hệ không? (Trả lời 1 nếu có, 0 nếu không).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Thay  #mi(`x=1, y=1`)  vào hệ:
1)  #mi(`1+1 = 2 \le 3`)  (Đúng)
2)  #mi(`2(1)-1 = 1 \ge 0`)  (Đúng)\nVì cả hai bất phương trình đều đúng nên  #mi(`M(1; 1)`)  thuộc miền nghiệm.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hệ bất phương trình  #mi(`\begin{cases} x-y > 3 \ x+y < 2 \end{cases}`) . Điểm  #mi(`M(2; -1)`)  có thuộc miền nghiệm của hệ không? (Trả lời 1 nếu có, 0 nếu không).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Thay  #mi(`x=2, y=-1`)  vào hệ:
1)  #mi(`2-(-1) = 3 > 3`)  (Sai)\nVì có ít nhất một bất phương trình sai nên  #mi(`M(2; -1)`)  không thuộc miền nghiệm.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Kiểm tra điểm không thuộc miền nghiệm:] Cho hệ bất phương trình  #mi(`\begin{cases} x+y > 3 \ x-y < 0 \end{cases}`) . Điểm  #mi(`M(1; 2)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thay  #mi(`x=1, y=2`)  vào từng bất phương trình của hệ:
- Với  #mi(`x+y > 3`) , ta có  #mi(`1+2 = 3`) . Vì  #mi(`3 > 3`)  là mệnh đề sai nên điểm  #mi(`M(1; 2)`)  không thỏa mãn bất phương trình này.\nKết luận: Vì có ít nhất một bất phương trình không thỏa mãn nên điểm  #mi(`M(1; 2)`)  không thuộc miền nghiệm của hệ bất phương trình đã cho.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Kiểm tra điểm thuộc miền nghiệm:] Cho hệ bất phương trình  #mi(`\begin{cases} 2x+y \le 1 \ x-y \le -2 \end{cases}`) . Điểm  #mi(`M(-1; 1)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thay  #mi(`x=-1, y=1`)  vào từng bất phương trình của hệ:
- Với  #mi(`2x+y \le 1`) , ta có  #mi(`2(-1)+1 = -1`) . Vì  #mi(`-1 \le 1`)  là mệnh đề đúng.
- Với  #mi(`x-y \le -2`) , ta có  #mi(`-1-1 = -2`) . Vì  #mi(`-2 \le -2`)  là mệnh đề đúng.\nKết luận: Vì tọa độ điểm  #mi(`M(-1; 1)`)  thỏa mãn tất cả các bất phương trình trong hệ nên  #mi(`M(-1; 1)`)  thuộc miền nghiệm của hệ bất phương trình đã cho.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hệ có 3 bất phương trình:] Cho hệ bất phương trình  #mi(`\begin{cases} x-y < 2 \ 2x+y > -1 \ x+y \le 5 \end{cases}`) . Điểm  #mi(`M(0; 0)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thay  #mi(`x=0, y=0`)  vào từng bất phương trình của hệ:
- Với  #mi(`x-y < 2`) , ta có  #mi(`0-0 = 0 < 2`)  (Đúng).
- Với  #mi(`2x+y > -1`) , ta có  #mi(`0+0 = 0 > -1`)  (Đúng).
- Với  #mi(`x+y \le 5`) , ta có  #mi(`0+0 = 0 \le 5`)  (Đúng).\nKết luận: Vì tọa độ điểm  #mi(`M(0; 0)`)  thỏa mãn tất cả các bất phương trình trong hệ nên  #mi(`M(0; 0)`)  thuộc miền nghiệm của hệ bất phương trình đã cho.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kiểm tra điểm với dấu bằng:] Cho hệ bất phương trình  #mi(`\begin{cases} x+y \ge 4 \ x-y \le 1 \end{cases}`) . Điểm  #mi(`M(2; 1)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thay  #mi(`x=2, y=1`)  vào từng bất phương trình của hệ:
- Với  #mi(`x+y \ge 4`) , ta có  #mi(`2+1 = 3`) . Vì  #mi(`3 \ge 4`)  là mệnh đề sai.\nKết luận: Vì có ít nhất một bất phương trình không thỏa mãn nên điểm  #mi(`M(2; 1)`)  không thuộc miền nghiệm của hệ bất phương trình đã cho.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hệ bất phương trình  #mi(`\begin{cases} x+y \le 4 \ x-y \le 0 \end{cases}`) . Điểm  #mi(`M(1; 2)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thay  #mi(`x=1, y=2`)  vào hệ:
-  #mi(`1+2 = 3 \le 4`)  (Đúng)
-  #mi(`1-2 = -1 \le 0`)  (Đúng)\nVì cả hai bất phương trình đều đúng nên điểm  #mi(`M(1; 2)`)  thuộc miền nghiệm của hệ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hệ bất phương trình  #mi(`\begin{cases} x+y \le 6 \ x-y \le 0 \end{cases}`) . Điểm  #mi(`M(2; 3)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thay  #mi(`x=2, y=3`)  vào hệ:
-  #mi(`2+3 = 5 \le 6`)  (Đúng)
-  #mi(`2-3 = -1 \le 0`)  (Đúng)\nVì cả hai bất phương trình đều đúng nên điểm  #mi(`M(2; 3)`)  thuộc miền nghiệm của hệ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hệ bất phương trình  #mi(`\begin{cases} 2x+y > 0 \ x-y < 1 \end{cases}`) . Điểm  #mi(`M(0; 1)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thay  #mi(`x=0, y=1`)  vào hệ:
-  #mi(`2(0)+1 = 1 > 0`)  (Đúng)
-  #mi(`0-1 = -1 < 1`)  (Đúng)\nVì cả hai bất phương trình đều đúng nên điểm  #mi(`M(0; 1)`)  thuộc miền nghiệm của hệ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hệ bất phương trình  #mi(`\begin{cases} 2x+y > 0 \ x-y < 1 \end{cases}`) . Điểm  #mi(`M(1; 0)`)  có thuộc miền nghiệm của hệ không?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thay  #mi(`x=1, y=0`)  vào hệ:
-  #mi(`2(1)+0 = 2 > 0`)  (Đúng)
-  #mi(`1-0 = 1 < 1`)  (Sai)\nVì có một bất phương trình không thỏa mãn nên điểm  #mi(`M(1; 0)`)  không thuộc miền nghiệm của hệ.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Biểu diễn miền nghiệm của hệ bất phương trình trên mặt phẳng tọa độ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Biểu diễn miền nghiệm của hệ bất phương trình trên mặt phẳng tọa độ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Miền nghiệm của hệ bất phương trình bậc nhất hai ẩn là giao của các miền nghiệm của từng bất phương trình trong hệ.
  - Để biểu diễn miền nghiệm, ta vẽ các đường thẳng biên  #mi(`ax + by = c`) , xác định nửa mặt phẳng nghiệm của mỗi bất phương trình bằng cách thử một điểm (thường là gốc tọa độ  #mi(`O(0;0)`)  nếu đường thẳng không đi qua  #mi(`O`) ), sau đó gạch bỏ phần không thuộc miền nghiệm.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo: Nếu đường thẳng đi qua gốc tọa độ  #mi(`O(0;0)`) , hãy chọn một điểm khác như  #mi(`M(1;0)`)  hoặc  #mi(`M(0;1)`)  để thử nghiệm.
  ]
  - *Công thức cốt lõi:* Miền nghiệm của hệ bất phương trình là '...' của các miền nghiệm của từng bất phương trình trong hệ.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Xác định số đỉnh của miền nghiệm là một tam giác cho hệ bất phương trình:  #mi(`\{x \ge 0; y \ge 0; x + y \le 5\}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Các đường thẳng biên là  #mi(`x=0`) ,  #mi(`y=0`) , và  #mi(`x+y=5`) . Các giao điểm của các đường thẳng này là  #mi(`O(0;0)`) ,  #mi(`A(5;0)`) , và  #mi(`B(0;5)`) . Vì đây là 3 giao điểm tạo thành một tam giác nên miền nghiệm có 3 đỉnh.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hệ bất phương trình  #mi(`\{x \ge 0; y \ge 0; x + y \le 2\}`) . Tính tổng tọa độ các đỉnh của miền nghiệm.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Các đường thẳng biên là  #mi(`x=0`) ,  #mi(`y=0`) , và  #mi(`x+y=2`) . Các giao điểm là  #mi(`O(0;0)`) ,  #mi(`A(2;0)`) , và  #mi(`B(0;2)`) . Tổng tọa độ các là  #mi(`0+0+2+0+0+2 = 4`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc gạch bỏ cơ bản:] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x \ge 0; y \ge 0; x + y \le 4\}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Vẽ các đường thẳng biên  #mi(`d_1: x=0`)  (trục  #mi(`Oy`) ),  #mi(`d_2: y=0`)  (trục  #mi(`Ox`) ), và  #mi(`d_3: x+y=4`) .\nBước 2: Xác định miền nghiệm của từng bất phương trình:\n- Với  #mi(`x \ge 0`)  và  #mi(`y \ge 0`) , miền nghiệm là góc phần tư thứ nhất.\n- Với  #mi(`x+y \le 4`) , thử điểm  #mi(`O(0;0)`) :  #mi(`0+0 \le 4`)  (đúng). Vậy miền nghiệm chứa gốc tọa độ  #mi(`O(0;0)`) .\nBước 3: Gạch bỏ phần không chứa  #mi(`O(0;0)`)  đối với đường thẳng  #mi(`x+y=4`) .\nKết luận: Miền nghiệm của hệ là miền tam giác  #mi(`OAB`)  kể cả các cạnh, với  #mi(`O(0;0)`) ,  #mi(`A(4;0)`) ,  #mi(`B(0;4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hệ có đường thẳng đi qua gốc tọa độ:] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x - y \le 0; x + y \le 2; x \ge 0\}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Vẽ các đường thẳng biên  #mi(`d_1: x-y=0`) ,  #mi(`d_2: x+y=2`) , và  #mi(`d_3: x=0`) .\nBước 2: Xác định miền nghiệm:\n- Với  #mi(`x \ge 0`) , miền nghiệm là nửa mặt phẳng bên phải trục  #mi(`Oy`) .\n- Với  #mi(`x - y \le 0`) , thử điểm  #mi(`M(1;0)`) :  #mi(`1-0 \le 0`)  (sai). Vậy miền nghiệm không chứa  #mi(`M(1;0)`) , ta gạch bỏ phần chứa  #mi(`M(1;0)`) .\n- Với  #mi(`x + y \le 2`) , thử điểm  #mi(`O(0;0)`) :  #mi(`0+0 \le 2`)  (đúng). Vậy miền nghiệm chứa  #mi(`O(0;0)`) .\nBước 3: Miền nghiệm là phần không bị gạch. Kết luận: Miền nghiệm là tam giác có các đỉnh là  #mi(`O(0;0)`) ,  #mi(`A(2;0)`) , và  #mi(`B(1;1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biến thể với dấu bằng:] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x + y > 2; x - y < 0; y \le 3\}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Vẽ các đường thẳng biên  #mi(`d_1: x+y=2`) ,  #mi(`d_2: x-y=0`) , và  #mi(`d_3: y=3`) .\nBước 2: Xác định miền nghiệm:\n- Với  #mi(`x+y > 2`) , thử  #mi(`O(0;0)`) :  #mi(`0+0 > 2`)  (sai). Ta gạch bỏ phần chứa  #mi(`O(0;0)`) . Lưu ý: đường biên  #mi(`x+y=2`)  không thuộc miền nghiệm.\n- Với  #mi(`x-y < 0`) , thử  #mi(`O(1;0)`) :  #mi(`1-0 < 0`)  (sai). Ta gạch bỏ phần chứa  #mi(`O(1;0)`) .\n- Với  #mi(`y \le 3`) , miền nghiệm chứa điểm  #mi(`M(0;0)`) .\nBước 3: Miền nghiệm là phần giao của các nửa mặt phẳng trên. Kết luận: Miền nghiệm là một đa giác không kể các cạnh biên  #mi(`x+y=2`)  và  #mi(`x-y=0`) .\n
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Xác định miền nghiệm qua hình vẽ:] Cho hình vẽ sau đây, hãy xác định một hệ bất phương trình bậc nhất hai ẩn có miền nghiệm là tam giác  #mi(`OAB`)  với  #mi(`O(0;0)`) ,  #mi(`A(4;0)`) ,  #mi(`B(0;3)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định các đường thẳng biên từ hình vẽ: Đường thẳng qua  #mi(`O`)  và  #mi(`A`)  là  #mi(`y=0`) ; đường thẳng qua  #mi(`O`)  và  #mi(`B`)  là  #mi(`x=0`) ; đường thẳng qua  #mi(`A`)  và  #mi(`B`)  là  #mi(`\frac{x}{4} + \frac{y}{3} = 1 \Leftrightarrow 3x + 4y = 12`) .\nBước 2: Thiết lập các bất phương trình:\n- Miền tam giác chứa  #mi(`O(0;0)`) , nên ta có  #mi(`x \ge 0`) ,  #mi(`y \ge 0`) , và  #mi(`3x+4y \le 12`) .\nKết luận: Hệ bất phương trình là  #mi(`\{x \ge 0; y \ge 0; 3x + 4y \le 12\}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x \ge 0; y \ge 0; x + y \le 3\}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vẽ các đường thẳng  #mi(`x=0`) ,  #mi(`y=0`) , và  #mi(`x+y=3`) . Thử điểm  #mi(`O(0;0)`)  cho  #mi(`x+y \le 3`)  ta được  #mi(`0 \le 3`)  (đúng). Miền nghiệm là tam giác  #mi(`OAB`)  với  #mi(`A(3;0)`) ,  #mi(`B(0;3)`)  kể cả các cạnh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x \ge 0; y \ge 0; 2x + y \le 4\}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vẽ các đường thẳng  #mi(`x=0`) ,  #mi(`y=0`) , và  #mi(`2x+y=4`) . Thử điểm  #mi(`O(0;0)`)  cho  #mi(`2x+y \le 4`)  ta được  #mi(`0 \le 4`)  (đúng). Miền nghiệm là tam giác  #mi(`OAB`)  với  #mi(`A(2;0)`) ,  #mi(`B(0;4)`)  kể cả các cạnh.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x \ge 0; y \le 2; x - y \le 2\}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vẽ các đường thẳng  #mi(`x=0`) ,  #mi(`y=0`) ,  #mi(`x-y=2`) , và  #mi(`y=2`) . Thử điểm  #mi(`O(0;0)`)  cho  #mi(`x-y \le 2`)  ta được  #mi(`0 \le 2`)  (đúng). Miền nghiệm là đa giác có các đỉnh là  #mi(`O(0;0)`) ,  #mi(`A(2;0)`) ,  #mi(`B(4;2)`) , và  #mi(`C(0;2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Biểu diễn hình học miền nghiệm của hệ bất phương trình:  #mi(`\{x + y \ge 2; x \ge 0; y \ge 0\}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vẽ các đường thẳng  #mi(`x+y=2`) ,  #mi(`x=0`) , và  #mi(`y=0`) . Thử điểm  #mi(`O(0;0)`)  cho  #mi(`x+y \ge 2`)  ta được  #mi(`0 \ge 2`)  (sai). Vậy miền nghiệm là nửa mặt phẳng chứa điểm  #mi(`M(2,2)`)  và không chứa  #mi(`O(0;0)`) . Miền nghiệm là phần mặt phẳng phía trên đường thẳng  #mi(`x+y=2`)  trong góc phần tư thứ nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Xác định hình dạng và tính chất đại số/hình học của miền nghiệm ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Xác định hình dạng và tính chất đại số/hình học của miền nghiệm]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Miền nghiệm của hệ bất phương trình bậc nhất hai ẩn là giao của các miền nghiệm của từng bất phương trình thành phần.
  - Hình dạng miền nghiệm thường là một đa giác (tam giác, tứ giác, ngũ giác...) hoặc một miền không bị chặn.
  - Các đỉnh của đa giác miền nghiệm là giao điểm của các đường thẳng biên.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn biết miền nghiệm là hình gì, hãy tìm tất cả các giao điểm của các đường thẳng biên và đếm số đỉnh tạo thành đa giác kín.
  ]
  - *Công thức cốt lõi:* Miền nghiệm của hệ bất phương trình là '...' của các miền nghiệm của từng bất phương trình thành phần.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Xác định số cạnh của đa giác là miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 5 \\ x-y \le 1 \end{cases}`) 
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Các đường thẳng biên là  #mi(`x=0, y=0, x+y=5, x-y=1`) . Các giao điểm là  #mi(`O(0;0), A(1;0), B(3;2), C(0;5)`) . Miền nghiệm là tứ giác  #mi(`OABC`) . Vậy số cạnh là 4.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 2 \end{cases}`) . Miền nghiệm là hình gì?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: tam giác]
      \ #text(fill: rgb("#334155"))[Lời giải: Các đường thẳng biên là  #mi(`x=0, y=0, x+y=2`) . Các giao điểm là  #mi(`O(0;0), A(2;0), B(0;2)`) . Miền nghiệm là tam giác  #mi(`OAB`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm tọa độ giao điểm của hai đường thẳng  #mi(`x+y=4`)  và  #mi(`x-y=0`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2;2)]
      \ #text(fill: rgb("#334155"))[Lời giải: Cộng hai phương trình:  #mi(`2x=4 \Rightarrow x=2`) . Thay vào  #mi(`x-y=0 \Rightarrow y=2`) . Giao điểm là  #mi(`(2;2)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận diện hình dạng tam giác:] Xác định hình dạng miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 3 \end{cases}`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vẽ các đường thẳng  #mi(`x=0, y=0, x+y=3`) . Các giao điểm là  #mi(`O(0;0), A(3;0), B(0;3)`) . Miền nghiệm là phần không bị gạch trong hình vẽ, là tam giác  #mi(`OAB`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận diện hình dạng tứ giác:] Xác định hình dạng miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 4 \\ x-y \le 2 \end{\end{cases}`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Các đường thẳng biên là  #mi(`x=0, y=0, x+y=4, x-y=2`) . Các giao điểm là  #mi(`O(0;0), A(2;0), B(3;1), C(0;4)`) . Miền nghiệm là tứ giác  #mi(`OABC`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Nhận diện hình dạng ngũ giác:] Xác định hình dạng miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 5 \\ x-y \le 3 \\ 2x+y \le 8 \\end{cases}`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Các đường thẳng biên là  #mi(`x=0, y=0, x+y=5, x-y=3, 2x+y=8`) . Các giao điểm là  #mi(`A(0;5), B(2;6)`)  (không thuộc miền),  #mi(`C(3;2), D(5;0), E(0;0)`) . Sau khi kiểm tra các điểm, miền nghiệm là ngũ giác  #mi(`OACDE`)  (với  #mi(`O(0;0), A(0;5), C(3;2), D(5;0)`) ).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Kiểm tra tính chất điểm thuộc miền nghiệm:] Cho hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 2 \end{cases}`) . Điểm  #mi(`M(1;1)`)  có thuộc miền nghiệm không?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thay  #mi(`x=1, y=1`)  vào hệ:  #mi(`1 \ge 0`)  (đúng),  #mi(`1 \ge 0`)  (đúng),  #mi(`1+1=2 \le 2`)  (đúng). Vậy  #mi(`M(1;1)`)  thuộc miền nghiệm.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Xác định hình dạng miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 6 \end{\end{cases}`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các đường thẳng biên là  #mi(`x=0, y=0, x+y=6`) . Các giao điểm là  #mi(`O(0;0), A(6;0), B(0;6)`) . Miền nghiệm là tam giác  #mi(`OAB`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Xác định hình dạng miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 10 \\end{cases}`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các đường thẳng biên là  #mi(`x=0, y=0, x+y=10`) . Các giao điểm là  #mi(`O(0;0), A(10;0), B(0;10)`) . Miền nghiệm là tam giác  #mi(`OAB`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Xác định hình dạng miền nghiệm của hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 4 \\ x-y \le 2 \\end{cases}`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các</code>] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hệ  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x+y \le 5 \\ x-y \le 1 \\end{cases}`) . Miền nghiệm là hình gì?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Các đường thẳng biên là  #mi(`x=0, y=0, x+y=5, x-y=1`) . Các giao điểm là  #mi(`O(0;0), A(1;0), B(3;2), C(0;5)`) . Miền nghiệm là tứ giác  #mi(`OABC`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Tìm giá trị lớn nhất và giá trị nhỏ nhất của biểu thức F(x, y) = ax + by trên miền nghiệm ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Tìm giá trị lớn nhất và giá trị nhỏ nhất của biểu thức F(x, y) = ax + by trên miền nghiệm]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Giá trị lớn nhất (GTLN) và giá trị nhỏ nhất (GTNN) của biểu thức  #mi(`F(x, y) = ax + by`)  trên một miền nghiệm là một đa giác sẽ đạt được tại một trong các đỉnh của đa giác đó.
  - Quy trình giải: 1. Xác định miền nghiệm của hệ bất phương trình (vẽ đa giác); 2. Tìm tọa độ tất cả các đỉnh của đa giác; 3. Tính giá trị của  #mi(`F`)  tại mỗi đỉnh; 4. So sánh các giá trị để kết luận GTLN hoặc GTNN.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm cực trị của  #mi(`F = ax + by`)  trên đa giác  #mi(`\rightarrow`)  Chỉ cần 'quét' qua các đỉnh!
  ]
  - *Công thức cốt lõi:* Giá trị lớn nhất và nhỏ nhất của biểu thức  #mi(`F(x, y) = ax + by`)  trên miền đa giác đạt được tại một trong các ... của đa giác đó.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm giá trị lớn nhất của biểu thức  #mi(`F(x, y) = x + y`)  trên miền nghiệm là tam giác có các đỉnh  #mi(`A(0, 0), B(4, 0), C(0, 3)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Tính giá trị  #mi(`F`)  tại các đỉnh:
- Tại  #mi(`A(0, 0): F = 0 + 0 = 0`) 
- Tại  #mi(`B(4, 0): F = 4 + 0 = 4`) 
- Tại  #mi(`C(0, 3): F = 0 + 3 = 3`) \nSo sánh các giá trị, ta thấy GTLN là 4.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm giá trị nhỏ nhất của biểu thức  #mi(`F(x, y) = 2x - y`)  trên miền nghiệm là tứ giác có các đỉnh  #mi(`A(1, 1), B(3, 1), C(3, 4), D(1, 4)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tính giá trị  #mi(`F`)  tại các đỉnh:
- Tại  #mi(`A(1, 1): F = 2(1) - 1 = 1`) 
- Tại  #mi(`B(3, 1): F = 2(3) - 1 = 5`) 
- Tại  #mi(`C(3, 4): F = 2(3) - 4 = 2`) 
- Tại  #mi(`D(1, 4): F = 2(1) - 4 = -2`) \nSo sánh các giá trị, ta thấy GTNN là -2.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm GTLN trên miền đa giác:] Tìm giá trị lớn nhất của biểu thức  #mi(`F(x, y) = x + 2y`)  trên miền nghiệm của hệ bất phương trình:  #mi(`\begin{cases} 0 \le y \le 4 \\ x \ge 0 \\ x - y \le 1 \\ x + 2y \le 10 \end{cases}`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định các đỉnh của miền nghiệm.\nMiền nghiệm là đa giác với các đỉnh:
- Giao của  #mi(`x=0`)  và  #mi(`y=0`)  là  #mi(`O(0, 0)`) .
- Giao của  #mi(`x-y=1`)  và  #mi(`y=0`)  là  #mi(`A(1, 0)`) .
- Giao của  #mi(`x-y=1`)  và  #mi(`x+2y=10`)  giải hệ  #mi(`\begin{cases} x-y=1 \\ x+2y=10 \end{cases} \Rightarrow \begin{cases} x=4 \\ y=3 \end{cases}`) , ta được  #mi(`B(4, 3)`) .
- Giao của  #mi(`x+2y=10`)  và  #mi(`y=4`)  giải hệ  #mi(`\begin{cases} x+2y=10 \\ y=4 \end{cases} \Rightarrow \begin{cases} x=2 \\ y=4 \end{cases}`) , ta được  #mi(`C(2, 4)`) .
- Giao của  #mi(`x=0`)  và  #mi(`y=4`)  là  #mi(`D(0, 4)`) .
\nBước 2: Tính giá trị  #mi(`F(x, y) = x + 2y`)  tại các đỉnh:
-  #mi(`F(0, 0) = 0 + 2(0) = 0`) 
-  #mi(`F(1, 0) = 1 + 2(0) = 1`) 
-  #mi(`F(4, 3) = 4 + 2(3) = 10`) 
-  #mi(`F(2, 4) = 2 + 2(4) = 10`) 
-  #mi(`F(0, 4) = 0 + 2(4) = 8`) 
\nBước 3: Kết luận\nGiá trị lớn nhất của  #mi(`F`)  là 10, đạt được tại  #mi(`(4, 3)`)  và  #mi(`(2, 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm cặp (x, y) để đạt cực trị:] Tìm cặp số  #mi(`(x, y)`)  để biểu thức  #mi(`F(x, y) = 2x - 3y`)  đạt giá trị nhỏ nhất trên miền nghiệm là tam giác có các đỉnh  #mi(`O(0, 0), A(3, 0), B(0, 2)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính giá trị  #mi(`F(x, y) = 2x - 3y`)  tại các đỉnh của tam giác:
- Tại  #mi(`O(0, 0): F = 2(0) - 3(0) = 0`) 
- Tại  #mi(`A(3, 0): F = 2(3) - 3(0) = 6`) 
- Tại  #mi(`B(0, 2): F = 2(0) - 3(2) = -6`) 
\nBước 2: So sánh các giá trị:\nTa thấy  #mi(`-6 < 0 < 6`) .
\nBước 3: Kết luận\nGiá trị nhỏ nhất của  #mi(`F`)  là  #mi(`-6`) , đạt được khi  #mi(`(x, y) = (0, 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Mệnh đề Đúng/Sai về cực trị:] Cho miền nghiệm của hệ bất phương trình  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x + y \le 5 \end{cases}`) . Xét mệnh đề sau: "Giá trị nhỏ nhất của biểu thức  #mi(`F(x, y) = x - y`)  trên miền nghiệm này là  #mi(`-5`) ". Mệnh đề này Đúng hay Sai? Vì sao?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định các đỉnh của miền nghiệm.\nMiền nghiệm là tam giác với các đỉnh:  #mi(`O(0, 0), A(5, 0), B(0, 5)`) .
\nBước 2: Tính giá trị  #mi(`F(x, y) = x - y`)  tại các đỉnh:
-  #mi(`F(0, 0) = 0 - 0 = 0`) 
-  #mi(`F(5, 0) = 5 - 0 = 5`) 
-  #mi(`F(0, 5) = 0 - 5 = -5`) 
\nBước 3: So sánh và kết luận\nGiá trị nhỏ nhất tìm được là  #mi(`-5`) . Vậy mệnh đề trên là Đúng.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán tối ưu thực tế:] Một xưởng sản xuất hai loại sản phẩm I và II. Lợi nhuận từ một đơn vị sản phẩm I là 3 nghìn đồng, sản phẩm II là 5 nghìn đồng. Các điều kiện ràng buộc về nguồn lực là:  #mi(`\begin{cases} 2x + 2y \le 10 \\ 2y \le 4 \\ 2x + 4y \le 12 \\ x, y \ge 0 \end{cases}`)  (với  #mi(`x, y`)  là số lượng sản phẩm). Tìm phương án sản xuất để lợi nhuận  #mi(`F = 3x + 5y`)  đạt giá trị lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tìm tọa độ các đỉnh của miền nghiệm.\nGiải các hệ phương trình giao điểm, ta tìm được các đỉnh của đa giác là:  #mi(`O(0, 0), A(5, 0), B(4, 1), C(2, 2), D(0, 2)`) .
\nBước 2: Tính giá trị lợi nhuận  #mi(`F(x, y) = 3x + 5y`)  tại các đỉnh:
-  #mi(`F(0, 0) = 3(0) + 5(0) = 0`) 
-  #mi(`F(5, 0) = 3(5) + 5(0) = 15`) 
-  #mi(`F(4, 1) = 3(4) + 5(1) = 17`) 
-  #mi(`F(2, 2) = 3(2) + 5(2) = 16`) 
-  #mi(`F(0, 2) = 3(0) + 5(2) = 10`) 
\nBước 3: Kết luận\nLợi nhuận lớn nhất là 17 nghìn đồng, đạt được khi sản xuất  #mi(`x = 4`)  đơn vị sản phẩm I và  #mi(`y = 1`)  đơn vị sản phẩm II.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm giá trị lớn nhất của biểu thức  #mi(`F(x, y) = x + 2y`)  trên miền nghiệm của hệ bất phương trình:  #mi(`\begin{cases} 0 \le y \le 3 \\ x \ge 0 \\ x - y \le 2 \\ x + 2y \le 8 \end{cases}`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bước 1: Tìm các đỉnh của miền nghiệm.
- Giao  #mi(`x=0, y=0 \rightarrow O(0, 0)`) .
- Giao  #mi(`x-y=2, y=0 \rightarrow A(2, 0)`) .
- Giao  #mi(`x-y=2, x+2y=8 \rightarrow 3y=6 \rightarrow y=2, x=4 \rightarrow B(4, 2)`) .
- Giao  #mi(`x+2y=8, y=3 \rightarrow x=2 \rightarrow C(2, 3)`) .
- Giao  #mi(`x=0, y=3 \rightarrow D(0, 3)`) .
\nBước 2: Tính  #mi(`F = x + 2y`)  tại các đỉnh:
-  #mi(`F(0, 0) = 0`) 
-  #mi(`F(2, 0) = 2`) 
-  #mi(`F(4, 2) = 4 + 4 = 8`) 
-  #mi(`F(2, 3) = 2 + 6 = 8`) 
-  #mi(`F(0, 3) = 6`) 
\nKết luận: GTLN của  #mi(`F`)  là 8.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm giá trị nhỏ nhất của biểu thức  #mi(`F(x, y) = 2x - y`)  trên miền nghiệm là tam giác có các đỉnh  #mi(`A(0, 0), B(5, 0), C(0, 4)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bước 1: Tính giá trị  #mi(`F`)  tại các đỉnh:
-  #mi(`F(0, 0) = 2(0) - 0 = 0`) 
-  #mi(`F(5, 0) = 2(5) - 0 = 10`) 
-  #mi(`F(0, 4) = 2(0) - 4 = -4`) 
\nBước 2: So sánh các giá trị:  #mi(`-4 < 0 < 10`) .
\nKết luận: GTNN của  #mi(`F`)  là -4.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho miền nghiệm của hệ bất phương trình  #mi(`\begin{cases} x \ge 0 \\ y \ge 0 \\ x + 2y \le 6 \end{cases}`) . Tìm cặp số  #mi(`(x, y)`)  để biểu thức  #mi(`F(x, y) = 3x + y`)  đạt giá trị lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bước 1: Xác định các đỉnh của miền nghiệm.\nMiền nghiệm là tam giác với các đỉnh:  #mi(`O(0, 0), A(6, 0), B(0, 3)`) .
\nBước 2: Tính giá trị  #mi(`F`)  tại các đỉnh:
-  #mi(`F(0, 0) = 0`) 
-  #mi(`F(6, 0) = 3(6) + 0 = 18`) 
-  #mi(`F(0, 3) = 3(0) + 3 = 3`) 
\nBước 3: Kết luận\nGiá trị lớn nhất là 18, đạt được khi  #mi(`(x, y) = (6, 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Xét mệnh đề: "Giá trị nhỏ nhất của biểu thức  #mi(`F(x, y) = x + y`)  trên miền nghiệm của hệ  #mi(`\begin{cases} x + y \ge 4 \\ x \ge 0 \\ y \ge 0 \end{cases}`)  là 4". Mệnh đề này Đúng hay Sai? Vì sao?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Bước 1: Miền nghiệm là miền không bị gạch (phần mặt phẳng phía trên đường thẳng  #mi(`x+y=4`)  trong góc phần tư thứ nhất).\nBước 2: Miền nghiệm này không phải là đa giác đóng (miền hở), tuy nhiên giá trị  #mi(`F = x + y`)  đạt giá trị nhỏ nhất trên đoạn thẳng nối hai điểm  #mi(`A(4, 0)`)  và  #mi(`B(0, 4)`) .\nBước 3: Tính giá trị  #mi(`F`)  tại các điểm biên:
-  #mi(`F(4, 0) = 4 + 0 = 4`) 
-  #mi(`F(0, 4) = 0 + 4 = 4`) \nVì  #mi(`x+y \ge 4`)  nên  #mi(`F \ge 4`)  với mọi  #mi(`(x, y)`)  thuộc miền nghiệm.
\nKết luận: Mệnh đề Đúng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Mô hình hóa toán học và giải bài toán tối ưu thực tế (Quy hoạch tuyến tính) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Mô hình hóa toán học và giải bài toán tối ưu thực tế (Quy hoạch tuyến tính)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Chọn ẩn số  #mi(`x, y`)  và thiết lập điều kiện thực tế (thường là  #mi(`x \ge 0, y \ge 0`) ).
  - Bước 2: Lập hệ bất phương trình bậc nhất hai ẩn biểu diễn các điều kiện ràng buộc về nguồn lực, kỹ thuật hoặc yêu cầu tối thiểu.
  - Bước 3: Xác định hàm mục tiêu  #mi(`F(x, y) = ax + by`)  cần tìm giá trị lớn nhất (GTLN) hoặc giá trị nhỏ nhất (GTNN).
  - Bước 4: Biểu diễn miền nghiệm của hệ bất phương trình (thường là một đa giác). Giá trị tối ưu của  #mi(`F(x, y)`)  luôn đạt được tại một trong các đỉnh của đa giác này.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm GTLN/GTNN của  #mi(`F(x, y)`) , chỉ cần tính giá trị  #mi(`F`)  tại tất cả các đỉnh của miền nghiệm đa giác rồi so sánh.
  ]
  - *Công thức cốt lõi:* Giá trị tối ưu của hàm mục tiêu  #mi(`F(x, y) = ax + by`)  trên miền nghiệm đa giác đạt được tại một trong các ... của đa giác đó.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một xưởng sản xuất hai loại sản phẩm  #mi(`A`)  và  #mi(`B`) . Để sản xuất 1 đơn vị  #mi(`A`)  cần 2 giờ máy, 1 đơn vị  #mi(`B`)  cần 1 giờ máy. Tổng số giờ máy không quá 10 giờ. Lợi nhuận mỗi đơn vị  #mi(`A`)  là 5 triệu,  #mi(`B`)  là 3 triệu. Tìm lợi nhuận lớn nhất có thể đạt được.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 30]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`x, y`)  lần lượt là số đơn vị sản phẩm  #mi(`A, B`)  ( #mi(`x, y \ge 0`) ). Hệ ràng buộc:  #mi(`2x + y \le 10`) . Hàm mục tiêu:  #mi(`F = 5x + 3y`) . Miền nghiệm là tam giác với các đỉnh  #mi(`(0,0), (5,0), (0,10)`) . Giá trị  #mi(`F`)  tại các đỉnh:  #mi(`F(0,0)=0, F(5,0)=25, F(0,10)=30`) . Vậy GTLN là 30.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chế độ ăn cần ít nhất 12 đơn vị protein và 10 đơn vị canxi. Thực phẩm  #mi(`X`)  cung cấp 2 protein, 1 canxi. Thực phẩm  #mi(`Y`)  cung cấp 1 protein, 2 canxi. Tìm chi phí thấp nhất nếu giá  #mi(`X`)  là 20 nghìn,  #mi(`Y`)  là 30 nghìn.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 180]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`x, y`)  là số đơn vị  #mi(`X, Y`)  ( #mi(`x, y \ge 0`) ). Hệ ràng buộc:  #mi(`\begin{cases} 2x + y \ge 12 \\ x + 2y \ge 10 \end{cases}`) . Miền nghiệm là miền không giới hạn với các đỉnh  #mi(`(0,12), (3.33, 3.33)`)  - sai, giao điểm là  #mi(`x=3.33`)  không đẹp. Tính lại:  #mi(`2x+y=12`)  và  #mi(`x+2y=10 \implies x=14/3, y=8/3`) . Đỉnh  #mi(`(0,12) \to 360`) ;  #mi(`(14/3, 8/3) \to 280/3 + 240/3 = 520/3 \approx 173`) ;  #mi(`(10,0) \to 200`) . Min là  #mi(`173.33`) . Thử số nguyên:  #mi(`x=5, y=2 \to 100+60=160`) . Thử  #mi(`x=4, y=4 \to 80+120=200`) . Thử  #mi(`x=6, y=0 \to 120`) . Sai,  #mi(`x+2y \ge 10 \implies 6+0 \ge 10`)  (sai). Thử  #mi(`x=10, y=0 \to 200`) . Thử  #mi(`x=0, y=12 \to 360`) . Giao điểm  #mi(`(14/3, 8/3)`) . Với  #mi(`x=5, y=2`)  thỏa mãn:  #mi(`10+2=12 \ge 12`)  và  #mi(`5+4=9 < 10`)  (sai). Với  #mi(`x=6, y=2`)  thỏa mãn:  #mi(`12+2=14 \ge 12`)  và  #mi(`6+4=10 \ge 10`) . Chi phí  #mi(`120+60=180`) . Với  #mi(`x=4, y=4`)  thỏa mãn:  #mi(`8+4=12 \ge 12`)  và  #mi(`4+8=12 \ge 10`) . Chi phí  #mi(`80+120=200`) . Min là 180.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa lợi nhuận sản xuất:] Một xưởng may sản xuất hai loại áo  #mi(`A`)  và  #mi(`B`) . Để may một chiếc áo  #mi(`A`)  cần 2m vải và 1 giờ công. Để may một chiếc áo  #mi(`B`)  cần 3m vải và 2 giờ công. Xưởng có tối đa 12m vải và 7 giờ công. Lợi nhuận mỗi chiếc áo  #mi(`A`)  là 50 nghìn đồng, áo  #mi(`B`)  là 40 nghìn đồng. Tìm phương án sản xuất để lợi nhuận cao nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x, y`)  lần lượt là số chiếc áo  #mi(`A`)  và  #mi(`B`)  sản xuất ( #mi(`x, y \in \mathbb{N}, x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} 2x + 3y \le 12 \\ x + 2y \le 7 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F(x, y) = 50x + 40y`) .\n3. Miền nghiệm là tứ giác với các đỉnh:  #mi(`O(0,0), A(6,0), B(3,2), C(0, 3.5)`) . Vì  #mi(`y \in \mathbb{N}`)  nên ta xét các điểm nguyên gần  #mi(`C`)  là  #mi(`(0,3)`) .\n4. Tính giá trị  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(6,0) = 50(6) + 40(0) = 300`) \n-  #mi(`F(3,2) = 50(3) + 40(2) = 150 + 80 = 230`) \n-  #mi(`F(0,3) = 50(0) + 40(3) = 120`) .\nVậy lợi nhuận cao nhất là 300 nghìn đồng khi sản xuất 6 chiếc áo  #mi(`A`)  và 0 chiếc áo  #mi(`B`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối thiểu hóa chi phí nguyên liệu:] Một loại thức ăn cho gia súc cần ít nhất 10 đơn vị chất khoáng  #mi(`M`)  và 15 đơn vị chất khoáng  #mi(`N`) . Loại nguyên liệu  #mi(`X`)  cung cấp 1 đơn vị  #mi(`M`)  và 1 đơn vị  #mi(`N`) . Loại nguyên liệu  #mi(`Y`)  cung cấp 2 đơn vị  #mi(`M`)  và 1 đơn vị  #mi(`N`) . Giá mỗi đơn vị  #mi(`X`)  là 2 nghìn đồng,  #mi(`Y`)  là 3 nghìn đồng. Tìm lượng  #mi(`X, Y`)  để chi phí thấp nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x, y`)  lần lượt là số đơn vị nguyên liệu  #mi(`X`)  và  #mi(`Y`)  ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} x + 2y \ge 10 \\ x + y \ge 15 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`C(x, y) = 2x + 3y`) .\n3. Miền nghiệm là miền không giới hạn với các đỉnh:  #mi(`A(0,15), B(5,10), C(20,0)`)  - tính lại giao điểm:  #mi(`x+2y=10`)  và  #mi(`x+y=15 \implies y=-5`)  (vô lý). Kiểm tra lại hệ:  #mi(`x+2y \ge 10`)  và  #mi(`x+y \ge 15`) . Giao điểm của  #mi(`x+2y=10`)  và  #mi(`x+y=15`)  không nằm trong miền nghiệm. Các đỉnh thực tế là  #mi(`A(0,15)`)  và  #mi(`B(15,0)`) .\n4. Tính giá trị  #mi(`C`)  tại các đỉnh:\n-  #mi(`C(0,15) = 2(0) + 3(15) = 45`) \n-  #mi(`C(15,0) = 2(15) + 3(0) = 30`) .\nVậy chi phí thấp nhất là 30 nghìn đồng khi dùng 15 đơn vị  #mi(`X`)  và 0 đơn vị  #mi(`Y`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Lập khẩu phần ăn tối ưu:] Một người cần ít nhất 12 đơn vị protein và 14 đơn vị canxi mỗi ngày. Thực phẩm  #mi(`A`)  cung cấp 1 protein và 1 canxi. Thực phẩm  #mi(`B`)  cung cấp 1 protein và 2 canxi. Giá mỗi đơn vị  #mi(`A`)  là 20 nghìn,  #mi(`B`)  là 25 nghìn. Tìm chi phí thấp nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x, y`)  là số đơn vị thực phẩm  #mi(`A`)  và  #mi(`B`)  ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} x + y \ge 12 \\ x + 2y \ge 14 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`T(x, y) = 20x + 25y`) .\n3. Miền nghiệm có các đỉnh:  #mi(`A(0,14), B(10,2), C(12,0)`) .\n4. Tính giá trị  #mi(`T`)  tại các đỉnh:\n-  #mi(`T(0,14) = 20(0) + 25(14) = 350`) \n-  #mi(`T(10,2) = 20(10) + 25(2) = 200 + 50 = 250`) \n-  #mi(`T(12,0) = 20(12) + 25(0) = 240`) .\nVậy chi phí thấp nhất là 240 nghìn đồng khi dùng 12 đơn vị  #mi(`A`)  và 0 đơn vị  #mi(`B`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phân bổ diện tích trồng trọt:] Một nông dân có 8 ha đất và 180 ngày công. Trồng ngô cần 20 ngày công/ha và thu lãi 3 triệu/ha. Trồng đậu cần 30 ngày công/ha và thu lãi 4 triệu/ha. Tìm diện tích trồng mỗi loại để lãi cao nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x, y`)  lần lượt là diện tích trồng ngô và đậu ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} x + y \le 8 \\ 20x + 30y \le 180 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F(x, y) = 3x + 4y`) .\n3. Miền nghiệm là tứ giác với các đỉnh:  #mi(`O(0,0), A(8,0), B(6,2), C(0,6)`) .\n4. Tính giá trị  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(8,0) = 3(8) + 4(0) = 24`) \n-  #mi(`F(6,2) = 3(6) + 4(2) = 18 + 8 = 26`) \n-  #mi(`F(0,6) = 3(0) + 4(6) = 24`) .\nVậy lãi cao nhất là 26 triệu đồng khi trồng 6 ha ngô và 2 ha đậu.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Tối ưu hóa nguồn lực máy móc:] Một xưởng có 2 máy  #mi(`M_1, M_2`) . Sản phẩm  #mi(`X`)  cần 1 giờ trên  #mi(`M_1`)  và 2 giờ trên  #mi(`M_2`) . Sản phẩm  #mi(`Y`)  cần 2 giờ trên  #mi(`M_1`)  và 1 giờ trên  #mi(`M_2`) . Tổng thời gian hoạt động của  #mi(`M_1`)  là 8 giờ,  #mi(`M_2`)  là 10 giờ. Lợi nhuận  #mi(`X`)  là 40 nghìn,  #mi(`Y`)  là 30 nghìn. Tìm lợi nhuận lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x, y`)  là số sản phẩm  #mi(`X, Y`)  ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} x + 2y \le 8 \\ 2x + y \le 10 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F(x, y) = 40x + 30y`) .\n3. Miền nghiệm là tứ giác với các đỉnh:  #mi(`O(0,0), A(5,0), B(4,2), C(0,4)`) .\n4. Tính giá trị  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(5,0) = 40(5) + 30(0) = 200`) \n-  #mi(`F(4,2) = 40(4) + 30(2) = 160 + 60 = 220`) \n-  #mi(`F(0,4) = 40(0) + 30(4) = 120`) .\nVậy lợi nhuận lớn nhất là 220 nghìn đồng khi sản xuất 4 sản phẩm  #mi(`X`)  và 2 sản phẩm  #mi(`Y`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một xưởng may sản xuất hai loại áo  #mi(`A`)  và  #mi(`B`) . Để may một chiếc áo  #mi(`A`)  cần 2m vải và 1 giờ công. Để may một chiếc áo  #mi(`B`)  cần 3m vải và 2 giờ công. Xưởng có tối đa 15m vải và 8 giờ công. Lợi nhuận mỗi chiếc áo  #mi(`A`)  là 60 nghìn đồng, áo  #mi(`B`)  là 50 nghìn đồng. Tìm lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x, y`)  là số áo  #mi(`A, B`)  ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} 2x + 3y \le 15 \\ x + 2y \le 8 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F = 60x + 50y`) .\n3. Các đỉnh miền nghiệm:  #mi(`O(0,0), A(7.5, 0), B(3, 2.5), C(0, 4)`) .\n4. Tính  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(7.5, 0) = 60(7.5) = 450`) \n-  #mi(`F(3, 2.5) = 60(3) + 50(2.5) = 180 + 125 = 305`) \n-  #mi(`F(0, 4) = 50(4) = 200`) .\nVậy GTLN là 450 nghìn đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một xưởng may sản xuất hai loại áo  #mi(`A`)  và  #mi(`B`) . Để may một chiếc áo  #mi(`A`)  cần 2m vải và 1 giờ công. Để may một chiếc áo  #mi(`B`)  cần 3m vải và 2 giờ công. Xưởng có tối đa 18m vải và 10 giờ công. Lợi nhuận mỗi chiếc áo  #mi(`A`)  là 70 nghìn đồng, áo  #mi(`B`)  là 60 nghìn đồng. Tìm lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x, y`)  là số áo  #mi(`A, B`)  ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} 2x + 3y \le 18 \\ x + 2y \le 10 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F = 70x + 60y`) .\n3. Các đỉnh miền nghiệm:  #mi(`O(0,0), A(9, 0), B(6, 2), C(0, 5)`) .\n4. Tính  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(9, 0) = 70(9) = 630`) \n-  #mi(`F(6, 2) = 70(6) + 60(2) = 420 + 120 = 540`) \n-  #mi(`F(0, 5) = 60(5) = 300`) .\nVậy GTLN là 630 nghìn đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một nông dân có 10 ha đất và 200 ngày công. Trồng ngô cần 20 ngày công/ha và thu lãi 5 triệu/ha. Trồng đậu cần 30 ngày công/ha và thu lãi 6 triệu/ha. Tìm diện tích trồng mỗi loại để lãi cao nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x, y`)  là diện tích trồng ngô và đậu ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} x + y \le 10 \\ 20x + 30y \le 200 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F = 5x + 6y`) .\n3. Các đỉnh miền nghiệm:  #mi(`O(0,0), A(10, 0), B(5, 3.33), C(0, 6.67)`) .\n4. Tính  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(10, 0) = 5(10) = 50`) \n-  #mi(`F(5, 3.33) = 5(5) + 6(3.33) = 25 + 20 = 45`) \n-  #mi(`F(0, 6.67) = 6(6.67) = 40`) .\nVậy GTLN là 50 triệu đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một xưởng sản xuất hai loại sản phẩm  #mi(`X`)  và  #mi(`Y`) . Lợi nhuận mỗi đơn vị  #mi(`X`)  là 40 nghìn,  #mi(`Y`)  là 30 nghìn. Để sản xuất  #mi(`X`)  cần 1 giờ máy  #mi(`M_1`)  và 2 giờ máy  #mi(`M_2`) . Để sản xuất  #mi(`Y`)  cần 2 giờ máy  #mi(`M_1`)  và 1 giờ máy  #mi(`M_2`) . Tổng thời gian máy  #mi(`M_1`)  không quá 12 giờ,  #mi(`M_2`)  không quá 14 giờ. Tìm lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x, y`)  là số sản phẩm  #mi(`X, Y`)  ( #mi(`x, y \ge 0`) ).\n1. Hệ ràng buộc:  #mi(`\begin{cases} x + 2y \le 12 \\ 2x + y \le 14 \\ x \ge 0, y \ge 0 \end{cases}`) .\n2. Hàm mục tiêu:  #mi(`F = 40x + 30y`) .\n3. Các đỉnh miền nghiệm:  #mi(`O(0,0), A(7, 0), B(5.33, 3.33), C(0, 6)`) .\n4. Tính  #mi(`F`)  tại các đỉnh:\n-  #mi(`F(0,0) = 0`) \n-  #mi(`F(7, 0) = 40(7) = 280`) \n-  #mi(`F(5.33, 3.33) = 40(5.33) + 30(3.33) = 213.2 + 99.9 = 313.1`) \n-  #mi(`F(0, 6) = 30(6) = 180`) .\nVậy GTLN là 313.1 nghìn đồng.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
