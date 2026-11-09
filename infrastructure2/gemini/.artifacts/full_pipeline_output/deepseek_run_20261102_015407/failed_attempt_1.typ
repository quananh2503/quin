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
  #text(size: 13pt, weight: "bold")[Hệ thống bài tập trọng tâm Giữa học kì I - Toán 12 (Chương trình GDPT 2018)] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Tài liệu tổng hợp và phân loại các dạng toán trọng tâm trong chương trình Giữa học kì I môn Toán lớp 12 theo cấu trúc đề thi mới (Trắc nghiệm, Đúng/Sai, Trả lời ngắn, Tự luận). Nội dung bao gồm các chủ đề: Ứng dụng đạo hàm để khảo sát và vẽ đồ thị hàm số (tính đơn điệu, cực trị, giá trị lớn nhất - nhỏ nhất, tiệm cận, đồ thị), Vectơ trong không gian, và các bài toán ứng dụng thực tế (tối ưu hóa, vật lý). Hệ thống bài tập được phân loại chi tiết theo từng kỹ năng và mục tiêu cụ thể, giúp học sinh nắm vững phương pháp giải và rèn luyện tư duy toán học.]
]
#v(6pt)

// ==================== DẠNG 1: Xét tính đơn điệu của hàm số dựa vào bảng biến thiên hoặc đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Xét tính đơn điệu của hàm số dựa vào bảng biến thiên hoặc đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Định lý: Cho hàm số  #mi(`y=f(x)`)  có đạo hàm trên  #mi(`K`) . Nếu  #mi(`f'(x) > 0, \forall x \in K`)  thì hàm số đồng biến trên  #mi(`K`) . Nếu  #mi(`f'(x) < 0, \forall x \in K`)  thì hàm số nghịch biến trên  #mi(`K`) .
  - Dựa vào bảng biến thiên: Khoảng đồng biến là khoảng mà mũi tên đi lên (dấu của  #mi(`f'(x)`)  là  #mi(`+`) ). Khoảng nghịch biến là khoảng mà mũi tên đi xuống (dấu của  #mi(`f'(x)`)  là  #mi(`-`) ).
  - Dựa vào đồ thị hàm số  #mi(`y=f(x)`) : Khoảng đồng biến là khoảng đồ thị đi lên từ trái sang phải. Khoảng nghịch biến là khoảng đồ thị đi xuống từ trái sang phải.
  - Dựa vào đồ thị hàm số  #mi(`y=f'(x)`) : Hàm số  #mi(`f(x)`)  đồng biến khi đồ thị  #mi(`f'(x)`)  nằm phía trên trục hoành ( #mi(`f'(x) > 0`) ). Hàm số  #mi(`f(x)`)  nghịch biến khi đồ thị  #mi(`f'(x)`)  nằm phía dưới trục hoành ( #mi(`f'(x) < 0`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo nhớ: 'Đồng biến đi lên, nghịch biến đi xuống'. Với đồ thị  #mi(`f'(x)`) : 'Trên Ox là đồng biến, dưới Ox là nghịch biến'.
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) ... 0`)  với mọi  #mi(`x \in K`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:  #mi(`f'(x) > 0`)  trên  #mi(`(-\infty; -1)`)  và  #mi(`(2; 5)`) ,  #mi(`f'(x) < 0`)  trên  #mi(`(-1; 2)`)  và  #mi(`(5; +\infty)`) . Hỏi hàm số có bao nhiêu khoảng đồng biến?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Dựa vào dấu của  #mi(`f'(x)`) , hàm số đồng biến khi  #mi(`f'(x) > 0`) . Theo đề bài,  #mi(`f'(x) > 0`)  trên các khoảng  #mi(`(-\infty; -1)`)  và  #mi(`(2; 5)`) . Vậy hàm số có 2 khoảng đồng biến.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y=f(x)`)  có đồ thị như hình vẽ. Biết đồ thị đi xuống trên khoảng  #mi(`(a; b)`)  với  #mi(`a, b`)  là các số nguyên. Tính  #mi(`a+b`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Quan sát đồ thị, hàm số nghịch biến (đi xuống) trên khoảng  #mi(`(-1; 1)`) . Suy ra  #mi(`a=-1, b=1`) . Vậy  #mi(`a+b = -1+1 = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x)`)  với đồ thị như hình vẽ. Đồ thị  #mi(`f'(x)`)  cắt trục hoành tại các điểm có hoành độ  #mi(`x=-2, x=1, x=4`) . Hỏi hàm số  #mi(`f(x)`)  nghịch biến trên khoảng nào? (Trả lời dạng khoảng  #mi(`(a;b)`)  và tính  #mi(`b-a`) ).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Hàm số  #mi(`f(x)`)  nghịch biến khi  #mi(`f'(x) < 0`) , tức là đồ thị  #mi(`f'(x)`)  nằm dưới trục hoành. Quan sát đồ thị,  #mi(`f'(x) < 0`)  trên khoảng  #mi(`(-2; 1)`)  và  #mi(`(1; 4)`) . Khoảng nghịch biến là  #mi(`(-2; 1)`)  (hoặc  #mi(`(1;4)`) ). Giả sử chọn  #mi(`(-2; 1)`) , khi đó  #mi(`b-a = 1 - (-2) = 3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Dựa vào bảng biến thiên (Biến thể 1):] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-2`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  | |  #mi(`\nearrow`)  | |  #mi(`\searrow`)  | |  #mi(`\nearrow`)  |\nHỏi hàm số đã cho đồng biến trên khoảng nào dưới đây?\nA.  #mi(`(-2; 0)`) \nB.  #mi(`(0; 2)`) \nC.  #mi(`(-\infty; -2)`) \nD.  #mi(`(2; +\infty)`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta thấy dấu của  #mi(`f'(x)`)  là dấu  #mi(`+`)  trên các khoảng  #mi(`(-\infty; -2)`)  và  #mi(`(2; +\infty)`) ; dấu  #mi(`-`)  trên khoảng  #mi(`(-2; 2)`) .\nHàm số đồng biến khi  #mi(`f'(x) > 0`) , tức là trên các khoảng  #mi(`(-\infty; -2)`)  và  #mi(`(2; +\infty)`) .
Đối chiếu đáp án, chỉ có đáp án C thỏa mãn (khoảng  #mi(`(-\infty; -2)`) ).\nChọn C.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Dựa vào đồ thị hàm số (Biến thể 2):] Cho hàm số  #mi(`y=f(x)`)  có đồ thị như hình vẽ bên. Hàm số đã cho nghịch biến trên khoảng nào dưới đây?\nA.  #mi(`(-\infty; -1)`) \nB.  #mi(`(-1; 1)`) \nC.  #mi(`(1; +\infty)`) \nD.  #mi(`(-1; 0)`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị hàm số  #mi(`y=f(x)`) , ta thấy đồ thị đi xuống (từ trái sang phải) trên khoảng  #mi(`(-1; 1)`) .\nDo đó, hàm số nghịch biến trên khoảng  #mi(`(-1; 1)`) .\nChọn B.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Dựa vào đồ thị hàm f'(x) (Biến thể 3):] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x)`)  trên  #mi(`\mathbb{R}`) . Đồ thị của hàm số  #mi(`y=f'(x)`)  như hình vẽ bên. Hàm số  #mi(`y=f(x)`)  đồng biến trên khoảng nào dưới đây?\nA.  #mi(`(-\infty; -1)`) \nB.  #mi(`(-1; 1)`) \nC.  #mi(`(1; 3)`) \nD.  #mi(`(3; +\infty)`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số  #mi(`f(x)`)  đồng biến khi  #mi(`f'(x) > 0`) , tức là đồ thị hàm số  #mi(`f'(x)`)  nằm phía trên trục hoành  #mi(`Ox`) .\nQuan sát đồ thị  #mi(`f'(x)`) , ta thấy đồ thị nằm trên trục  #mi(`Ox`)  trên các khoảng  #mi(`(-1; 1)`)  và  #mi(`(3; +\infty)`) .\nDo đó hàm số  #mi(`f(x)`)  đồng biến trên  #mi(`(-1; 1)`)  và  #mi(`(3; +\infty)`) .
Đối chiếu đáp án, chọn B.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Dựa vào bảng biến thiên của f'(x):] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x)`)  trên  #mi(`\mathbb{R}`)  và bảng xét dấu của  #mi(`f'(x)`)  như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`1`)  |  #mi(`2`)  |  #mi(`3`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |\nHàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng nào dưới đây?\nA.  #mi(`(1; 2)`) \nB.  #mi(`(2; 3)`) \nC.  #mi(`(1; 3)`) \nD.  #mi(`(-\infty; 1)`) 
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng xét dấu của  #mi(`f'(x)`) , ta thấy  #mi(`f'(x) < 0`)  trên các khoảng  #mi(`(-\infty; 1)`)  và  #mi(`(3; +\infty)`) .\nHàm số nghịch biến khi  #mi(`f'(x) < 0`) , tức là trên các khoảng  #mi(`(-\infty; 1)`)  và  #mi(`(3; +\infty)`) .
Đối chiếu đáp án, chọn D.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-1`)  |  #mi(`1`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |
|  #mi(`f(x)`)  | |  #mi(`\nearrow`)  | |  #mi(`\searrow`)  |\nHàm số đã cho đồng biến trên khoảng nào dưới đây?\nA.  #mi(`(-\infty; -1)`) \nB.  #mi(`(-1; 1)`) \nC.  #mi(`(1; +\infty)`) \nD.  #mi(`(-\infty; 1)`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy  #mi(`f'(x) > 0`)  trên khoảng  #mi(`(-\infty; -1)`) .\nDo đó hàm số đồng biến trên  #mi(`(-\infty; -1)`) .\nChọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  | |  #mi(`\searrow`)  | |  #mi(`\nearrow`)  |\nHàm số đã cho nghịch biến trên khoảng nào dưới đây?\nA.  #mi(`(0; 2)`) \nB.  #mi(`(-\infty; 0)`) \nC.  #mi(`(2; +\infty)`) \nD.  #mi(`(-\infty; 2)`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy  #mi(`f'(x) < 0`)  trên khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(0; 2)`) .\nHàm số nghịch biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(0; 2)`) .
Đối chiếu đáp án, chọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y=f(x)`)  có đồ thị như hình vẽ. Hàm số đã cho đồng biến trên khoảng nào dưới đây?\nA.  #mi(`(-\infty; 0)`) \nB.  #mi(`(0; 2)`) \nC.  #mi(`(2; +\infty)`) \nD.  #mi(`(-2; 0)`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quan sát đồ thị, đồ thị hàm số đi lên trên khoảng  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) .\nDo đó hàm số đồng biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) .\nChọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm  #mi(`f'(x)`)  trên  #mi(`\mathbb{R}`) . Đồ thị của hàm số  #mi(`y=f'(x)`)  như hình vẽ (cắt trục hoành tại  #mi(`x=-2, x=0, x=2`) ). Hàm số  #mi(`y=f(x)`)  nghịch biến trên khoảng nào dưới đây?\nA.  #mi(`(-2; 0)`) \nB.  #mi(`(0; 2)`) \nC.  #mi(`(-\infty; -2)`) \nD.  #mi(`(2; +\infty)`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số  #mi(`f(x)`)  nghịch biến khi  #mi(`f'(x) < 0`) , tức là đồ thị  #mi(`f'(x)`)  nằm dưới trục hoành  #mi(`Ox`) .\nQuan sát đồ thị,  #mi(`f'(x) < 0`)  trên các khoảng  #mi(`(-\infty; -2)`)  và  #mi(`(0; 2)`) .\nDo đó hàm số nghịch biến trên  #mi(`(-\infty; -2)`)  và  #mi(`(0; 2)`) .
Đối chiếu đáp án, chọn A.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y=f(x)`)  có bảng xét dấu đạo hàm như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-3`)  |  #mi(`0`)  |  #mi(`3`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  | |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |\nHàm số  #mi(`y=f(x)`)  đồng biến trên khoảng nào dưới đây?\nA.  #mi(`(-3; 0)`) \nB.  #mi(`(0; 3)`) \nC.  #mi(`(-\infty; 0)`) \nD.  #mi(`(-3; 3)`) 
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng xét dấu,  #mi(`f'(x) > 0`)  trên các khoảng  #mi(`(-\infty; -3)`)  và  #mi(`(3; +\infty)`) .\nHàm số đồng biến trên  #mi(`(-\infty; -3)`)  và  #mi(`(3; +\infty)`) .
Đối chiếu đáp án, không có đáp án đúng trong các lựa chọn (đề bài có thể sai, nhưng theo lý thuyết ta chọn khoảng đồng biến). Giả sử câu hỏi là nghịch biến, ta có  #mi(`(-3; 3)`) . Tuy nhiên, theo đúng yêu cầu, ta xác định khoảng đồng biến là  #mi(`(-\infty; -3)`)  và  #mi(`(3; +\infty)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Tìm cực trị của hàm số dựa vào bảng biến thiên hoặc đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Tìm cực trị của hàm số dựa vào bảng biến thiên hoặc đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm  #mi(`x_0`)  là điểm cực đại của hàm số nếu  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  khi  #mi(`x`)  đi qua  #mi(`x_0`) .
  - Điểm  #mi(`x_0`)  là điểm cực tiểu của hàm số nếu  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi  #mi(`x`)  đi qua  #mi(`x_0`) .
  - Nếu  #mi(`f'(x)`)  không đổi dấu khi  #mi(`x`)  đi qua  #mi(`x_0`)  thì  #mi(`x_0`)  không phải là điểm cực trị của hàm số.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo nhớ nhanh: 'Đổi dấu là cực trị, + sang - là cực đại, - sang + là cực tiểu'. Hãy quan sát chiều mũi tên trên bảng biến thiên: đi lên rồi đi xuống là cực đại, đi xuống rồi đi lên là cực tiểu.
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y=f(x)`)  có cực đại tại  #mi(`x_0`)  khi và chỉ khi  #mi(`f'(x)`)  đổi dấu từ ... sang ... khi  #mi(`x`)  đi qua  #mi(`x_0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`-\infty`)  |  #mi(`1`)  | |  #mi(`-3`)  |  #mi(`+\infty`)  |\nHỏi hàm số có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=0`)  là điểm cực đại.
- Tại  #mi(`x=2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=2`)  là điểm cực tiểu.\nVậy hàm số có 2 điểm cực trị.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho đồ thị hàm số  #mi(`y=f(x)`)  như hình vẽ bên dưới. Hỏi hàm số có bao nhiêu điểm cực trị?
[Đồ thị có dạng chữ W, đi lên từ trái sang phải, đạt cực đại tại  #mi(`x=-1`) , cực tiểu tại  #mi(`x=0`)  và  #mi(`x=2`) , cực đại tại  #mi(`x=1`) ]
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Quan sát đồ thị hàm số, ta thấy đồ thị có 2 điểm cực đại và 2 điểm cực tiểu. Vậy hàm số có 4 điểm cực trị.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y=f(x)`)  có đạo hàm liên tục trên  #mi(`\mathbb{R}`) . Đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ bên dưới. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
[Đồ thị  #mi(`f'(x)`)  cắt trục hoành tại 3 điểm  #mi(`x=-1, x=1, x=3`)  và đổi dấu tại cả 3 điểm này]
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Dựa vào đồ thị hàm số  #mi(`y=f'(x)`) , ta thấy  #mi(`f'(x)=0`)  tại  #mi(`x=-1, x=1, x=3`)  và  #mi(`f'(x)`)  đổi dấu khi đi qua cả 3 điểm này. Do đó, hàm số  #mi(`y=f(x)`)  có 3 điểm cực trị.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm số điểm cực trị từ bảng biến thiên:] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-1`)  |  #mi(`0`)  |  #mi(`1`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`+\infty`)  | |  #mi(`-2`)  | |  #mi(`3`)  | |  #mi(`+\infty`)  |\nHỏi hàm số có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x=-1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=-1`)  là điểm cực tiểu.
- Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=0`)  là điểm cực đại.
- Tại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=1`)  là điểm cực tiểu.\nVậy hàm số có 3 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm số điểm cực trị từ đồ thị hàm số:] Cho đồ thị hàm số  #mi(`y=f(x)`)  như hình vẽ bên dưới. Hỏi hàm số có bao nhiêu điểm cực trị?
[Đồ thị hàm số có dạng parabol bậc 4 trùng phương, có 3 điểm cực trị: 1 cực đại tại  #mi(`x=0`)  và 2 cực tiểu tại  #mi(`x=-1, x=1`) ]
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị hàm số, ta thấy đồ thị có 1 điểm cực đại và 2 điểm cực tiểu. Vậy hàm số có 3 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm số điểm cực trị từ đồ thị hàm f'(x):] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm liên tục trên  #mi(`\mathbb{R}`) . Đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ bên dưới. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
[Đồ thị  #mi(`f'(x)`)  cắt trục hoành tại 2 điểm  #mi(`x=-1, x=2`)  và đổi dấu tại cả 2 điểm này]
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào đồ thị hàm số  #mi(`y=f'(x)`) , ta thấy  #mi(`f'(x)=0`)  tại  #mi(`x=-1, x=2`)  và  #mi(`f'(x)`)  đổi dấu khi đi qua cả 2 điểm này. Do đó, hàm số  #mi(`y=f(x)`)  có 2 điểm cực trị.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm số điểm cực đại từ bảng biến thiên:] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`1`)  |  #mi(`3`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`-\infty`)  |  #mi(`4`)  | |  #mi(`-2`)  |  #mi(`+\infty`)  |\nHỏi hàm số có bao nhiêu điểm cực đại?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=1`)  là điểm cực đại.
- Tại  #mi(`x=3`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=3`)  là điểm cực tiểu.\nVậy hàm số có 1 điểm cực đại.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-2`)  |  #mi(`0`)  |  #mi(`2`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`+\infty`)  | |  #mi(`-1`)  | |  #mi(`2`)  | |  #mi(`+\infty`)  |\nHỏi hàm số có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x=-2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=-2`)  là điểm cực tiểu.
- Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=0`)  là điểm cực đại.
- Tại  #mi(`x=2`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=2`)  là điểm cực tiểu.\nVậy hàm số có 3 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`-3`)  |  #mi(`1`)  |  #mi(`4`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |
|  #mi(`f(x)`)  |  #mi(`-\infty`)  | |  #mi(`5`)  | |  #mi(`-2`)  | |  #mi(`3`)  |\nHỏi hàm số có bao nhiêu điểm cực trị?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x=-3`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=-3`)  là điểm cực đại.
- Tại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=1`)  là điểm cực tiểu.
- Tại  #mi(`x=4`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=4`)  là điểm cực đại.\nVậy hàm số có 3 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho đồ thị hàm số  #mi(`y=f(x)`)  như hình vẽ bên dưới. Hỏi hàm số có bao nhiêu điểm cực trị?
[Đồ thị hàm số có dạng parabol bậc 4 trùng phương, có 3 điểm cực trị: 1 cực tiểu tại  #mi(`x=0`)  và 2 cực đại tại  #mi(`x=-2, x=2`) ]
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quan sát đồ thị hàm số, ta thấy đồ thị có 1 điểm cực tiểu và 2 điểm cực đại. Vậy hàm số có 3 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm liên tục trên  #mi(`\mathbb{R}`) . Đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ bên dưới. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực tiểu?
[Đồ thị  #mi(`f'(x)`)  cắt trục hoành tại 3 điểm  #mi(`x=-2, x=0, x=2`)  và đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  tại  #mi(`x=-2`)  và  #mi(`x=2`) , đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  tại  #mi(`x=0`) ]
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào đồ thị hàm số  #mi(`y=f'(x)`) , ta thấy  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  khi đi qua  #mi(`x=-2`)  và  #mi(`x=2`) . Do đó, hàm số  #mi(`y=f(x)`)  có 2 điểm cực tiểu.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y=f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  #mi(`0`)  |  #mi(`1`)  |  #mi(`+\infty`)  |
|---|---|---|---|---|
|  #mi(`f'(x)`)  |  #mi(`+`)  |  #mi(`0`)  |  #mi(`-`)  |  #mi(`0`)  |  #mi(`+`)  |
|  #mi(`f(x)`)  |  #mi(`-\infty`)  |  #mi(`3`)  | |  #mi(`-1`)  |  #mi(`+\infty`)  |\nHỏi hàm số có bao nhiêu điểm cực đại?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào bảng biến thiên, ta thấy:
- Tại  #mi(`x=0`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`+`)  sang  #mi(`-`)  nên  #mi(`x=0`)  là điểm cực đại.
- Tại  #mi(`x=1`) ,  #mi(`f'(x)`)  đổi dấu từ  #mi(`-`)  sang  #mi(`+`)  nên  #mi(`x=1`)  là điểm cực tiểu.\nVậy hàm số có 1 điểm cực đại.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y=f(x)`)  có đạo hàm liên tục trên  #mi(`\mathbb{R}`) . Đồ thị hàm số  #mi(`y=f'(x)`)  như hình vẽ bên dưới. Hỏi hàm số  #mi(`y=f(x)`)  có bao nhiêu điểm cực trị?
[Đồ thị  #mi(`f'(x)`)  cắt trục hoành tại 3 điểm  #mi(`x=-1, x=1, x=3`)  và đổi dấu tại cả 3 điểm này]
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Dựa vào đồ thị hàm số  #mi(`y=f'(x)`) , ta thấy  #mi(`f'(x)=0`)  tại  #mi(`x=-1, x=1, x=3`)  và  #mi(`f'(x)`)  đổi dấu khi đi qua cả 3 điểm này. Do đó, hàm số  #mi(`y=f(x)`)  có 3 điểm cực trị.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Xác định đường tiệm cận của đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Xác định đường tiệm cận của đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tiệm cận đứng: Đường thẳng  #mi(`x = x_0`)  là tiệm cận đứng nếu  #mi(`\lim_{x \to x_0^+} f(x) = \pm\infty`)  hoặc  #mi(`\lim_{x \to x_0^-} f(x) = \pm\infty`) . (Thường là nghiệm của mẫu thức không bị triệt tiêu bởi tử thức).
  - Tiệm cận ngang: Đường thẳng  #mi(`y = y_0`)  là tiệm cận ngang nếu  #mi(`\lim_{x \to +\infty} f(x) = y_0`)  hoặc  #mi(`\lim_{x \to -\infty} f(x) = y_0`) .
  - Tiệm cận xiên: Đường thẳng  #mi(`y = ax + b`)  ( #mi(`a \neq 0`) ) là tiệm cận xiên nếu  #mi(`\lim_{x \to +\infty} [f(x) - (ax+b)] = 0`)  hoặc  #mi(`\lim_{x \to -\infty} [f(x) - (ax+b)] = 0`) . Đối với hàm phân thức, tiệm cận xiên xuất hiện khi bậc tử lớn hơn bậc mẫu đúng 1 bậc.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo nhớ nhanh: 'Mẫu bằng 0, tử khác 0' => Tiệm cận đứng. 'Bậc tử = bậc mẫu' => Tiệm cận ngang (tỉ số hệ số bậc cao nhất). 'Bậc tử = bậc mẫu + 1' => Tiệm cận xiên (chia đa thức).
  ]
  - *Công thức cốt lõi:* Đường thẳng  #mi(`y = ax + b`)  là tiệm cận xiên của đồ thị hàm số  #mi(`y = f(x)`)  nếu  #mi(`\lim_{x \to +\infty} [f(x) - (ax+b)] = ...`)  hoặc  #mi(`\lim_{x \to -\infty} [f(x) - (ax+b)] = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{3x+1}{x-2}`) . Tìm tổng số đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .
- Tiệm cận đứng: Xét mẫu  #mi(`x - 2 = 0 \Leftrightarrow x = 2`) . Tử tại  #mi(`x=2`)  là  #mi(`3(2)+1 = 7 \neq 0`) . Vậy  #mi(`x=2`)  là tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x \to \pm\infty} \frac{3x+1}{x-2} = \lim_{x \to \pm\infty} \frac{3 + 1/x}{1 - 2/x} = 3`) . Vậy  #mi(`y=3`)  là tiệm cận ngang.\nTổng số đường tiệm cận là  #mi(`1 + 1 = 2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{x^2-4x+3}{x-1}`) . Tìm số đường tiệm cận của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`y = \frac{(x-1)(x-3)}{x-1} = x - 3`)  với  #mi(`x \neq 1`) .
- Tiệm cận đứng:  #mi(`\lim_{x \to 1} y = \lim_{x \to 1} (x-3) = -2`)  (hữu hạn). Vậy không có tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x \to \pm\infty} y = \pm\infty`) . Vậy không có tiệm cận ngang.
- Tiệm cận xiên:  #mi(`\lim_{x \to \pm\infty} [y - (x-3)] = \lim_{x \to \pm\infty} 0 = 0`) . Vậy  #mi(`y = x-3`)  là tiệm cận xiên.\nVậy đồ thị hàm số có 1 đường tiệm cận.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên:  #mi(`x \to -\infty`)  thì  #mi(`y \to -1`) ;  #mi(`x \to 2^-`)  thì  #mi(`y \to -\infty`) ;  #mi(`x \to 2^+`)  thì  #mi(`y \to +\infty`) ;  #mi(`x \to +\infty`)  thì  #mi(`y \to -1`) . Tìm tổng số đường tiệm cận của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Từ bảng biến thiên:
-  #mi(`\lim_{x \to 2^-} y = -\infty`)  và  #mi(`\lim_{x \to 2^+} y = +\infty`)  nên  #mi(`x=2`)  là tiệm cận đứng.
-  #mi(`\lim_{x \to -\infty} y = -1`)  và  #mi(`\lim_{x \to +\infty} y = -1`)  nên  #mi(`y=-1`)  là tiệm cận ngang.\nVậy đồ thị có 2 đường tiệm cận.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tiệm cận đứng và tiệm cận ngang của hàm phân thức:] Tìm các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{2x-1}{x+3}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-3\}`) .
- Tiệm cận đứng: Xét mẫu  #mi(`x + 3 = 0 \Leftrightarrow x = -3`) . Tử tại  #mi(`x=-3`)  là  #mi(`2(-3)-1 = -7 \neq 0`) . Do đó  #mi(`\lim_{x \to -3} y = \infty`) , suy ra  #mi(`x = -3`)  là tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x \to \pm\infty} y = \lim_{x \to \pm\infty} \frac{2x-1}{x+3} = \lim_{x \to \pm\infty} \frac{2 - 1/x}{1 + 3/x} = 2`) . Vậy  #mi(`y = 2`)  là tiệm cận ngang.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tiệm cận xiên của hàm phân thức (chia đa thức):] Tìm đường tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2-3x+2}{x+1}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .\nThực hiện phép chia đa thức:  #mi(`x^2 - 3x + 2 = (x+1)(x-4) + 6`) .\nSuy ra  #mi(`y = x - 4 + \frac{6}{x+1}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} [y - (x-4)] = \lim_{x \to \pm\infty} \frac{6}{x+1} = 0`) .\nVậy đường thẳng  #mi(`y = x - 4`)  là tiệm cận xiên của đồ thị hàm số.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tiệm cận xiên của hàm phân thức (dùng công thức):] Tìm đường tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{2x^2+x-1}{x-2}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nTa có  #mi(`y = \frac{2x^2+x-1}{x-2} = 2x + 5 + \frac{9}{x-2}`)  (thực hiện phép chia).\nKhi đó  #mi(`\lim_{x \to \pm\infty} [y - (2x+5)] = \lim_{x \to \pm\infty} \frac{9}{x-2} = 0`) .\nVậy đường thẳng  #mi(`y = 2x + 5`)  là tiệm cận xiên của đồ thị hàm số.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tổng số đường tiệm cận từ bảng biến thiên:] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên như sau:
|  #mi(`x`)  |  #mi(`-\infty`)  |  |  #mi(`1`)  |  |  #mi(`+\infty`)  |
|---|---|---|---|---|---|
|  #mi(`y'`)  |  | - |  | - |  |
|  #mi(`y`)  |  #mi(`2`)  |  |  #mi(`-\infty`)  |  |  #mi(`2`)  |
|  |  |  |  #mi(`+\infty`)  |  |  |\nTìm tổng số đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ bảng biến thiên, ta có:
-  #mi(`\lim_{x \to 1^-} y = -\infty`)  và  #mi(`\lim_{x \to 1^+} y = +\infty`) , suy ra  #mi(`x = 1`)  là tiệm cận đứng.
-  #mi(`\lim_{x \to -\infty} y = 2`)  và  #mi(`\lim_{x \to +\infty} y = 2`) , suy ra  #mi(`y = 2`)  là tiệm cận ngang.\nVậy đồ thị hàm số có tổng cộng 2 đường tiệm cận.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{x+1}{2x-4}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .
- Tiệm cận đứng: Mẫu  #mi(`2x - 4 = 0 \Leftrightarrow x = 2`) . Tử tại  #mi(`x=2`)  là  #mi(`2+1=3 \neq 0`) . Vậy  #mi(`x=2`)  là tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x \to \pm\infty} \frac{x+1}{2x-4} = \frac{1}{2}`) . Vậy  #mi(`y = \frac{1}{2}`)  là tiệm cận ngang.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm các đường tiệm cận đứng và tiệm cận ngang của đồ thị hàm số  #mi(`y = \frac{2x-3}{x+1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .
- Tiệm cận đứng: Mẫu  #mi(`x + 1 = 0 \Leftrightarrow x = -1`) . Tử tại  #mi(`x=-1`)  là  #mi(`2(-1)-3 = -5 \neq 0`) . Vậy  #mi(`x=-1`)  là tiệm cận đứng.
- Tiệm cận ngang:  #mi(`\lim_{x \to \pm\infty} \frac{2x-3}{x+1} = 2`) . Vậy  #mi(`y = 2`)  là tiệm cận ngang.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm đường tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2-2x+3}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`y = \frac{x^2-2x+3}{x-1} = x - 1 + \frac{2}{x-1}`) .\nKhi đó  #mi(`\lim_{x \to \pm\infty} [y - (x-1)] = \lim_{x \to \pm\infty} \frac{2}{x-1} = 0`) .\nVậy  #mi(`y = x - 1`)  là tiệm cận xiên của đồ thị hàm số.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = f(x)`)  có bảng biến thiên:  #mi(`x \to -\infty`)  thì  #mi(`y \to 1`) ;  #mi(`x \to 0^-`)  thì  #mi(`y \to -\infty`) ;  #mi(`x \to 0^+`)  thì  #mi(`y \to +\infty`) ;  #mi(`x \to +\infty`)  thì  #mi(`y \to 1`) . Tìm tổng số đường tiệm cận của đồ thị hàm số.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ bảng biến thiên:
-  #mi(`\lim_{x \to 0^-} y = -\infty`)  và  #mi(`\lim_{x \to 0^+} y = +\infty`)  nên  #mi(`x=0`)  là tiệm cận đứng.
-  #mi(`\lim_{x \to -\infty} y = 1`)  và  #mi(`\lim_{x \to +\infty} y = 1`)  nên  #mi(`y=1`)  là tiệm cận ngang.\nVậy đồ thị có 2 đường tiệm cận.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Tìm đường tiệm cận xiên của đồ thị hàm số  #mi(`y = \frac{x^2+1}{x-1}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`y = \frac{x^2+1}{x-1} = x + 1 + \frac{2}{x-1}`) .\nKhi đó  #mi(`\lim_{x \to \pm\infty} [y - (x+1)] = \lim_{x \to \pm\infty} \frac{2}{x-1} = 0`) .\nVậy  #mi(`y = x + 1`)  là tiệm cận xiên của đồ thị hàm số.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Nhận dạng đồ thị hàm số từ công thức ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Nhận dạng đồ thị hàm số từ công thức]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`) : Dấu của  #mi(`a`)  quyết định chiều đi của đồ thị ở hai đầu mút. Điểm uốn là tâm đối xứng. Số điểm cực trị là 0 hoặc 2.
  - Hàm phân thức bậc nhất/bậc nhất  #mi(`y = \frac{ax+b}{cx+d}`) : Đồ thị có tiệm cận đứng  #mi(`x = -\frac{d}{c}`)  và tiệm cận ngang  #mi(`y = \frac{a}{c}`) . Giao điểm với trục tung là  #mi(`\left(0; \frac{b}{d}\right)`) .
  - Hàm phân thức bậc hai/bậc nhất  #mi(`y = \frac{ax^2+bx+c}{dx+e}`) : Đồ thị có tiệm cận đứng  #mi(`x = -\frac{e}{d}`)  và tiệm cận xiên (hoặc ngang nếu  #mi(`a=0`) ). Số điểm cực trị là 0 hoặc 2.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Bậc ba nhìn đuôi - dấu a; Phân thức nhìn tiệm cận - giao trục.
  ]
  - *Công thức cốt lõi:* Đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có tiệm cận đứng là đường thẳng  #mi(`x = ...`)  và tiệm cận ngang là đường thẳng  #mi(`y = ...`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{2x-1}{x+1}`)  có đồ thị (C). Tìm tọa độ giao điểm của (C) với trục tung.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -1]
      \ #text(fill: rgb("#334155"))[Lời giải: Giao điểm với trục tung có hoành độ  #mi(`x = 0`) . Thay  #mi(`x = 0`)  vào hàm số ta được  #mi(`y = \frac{2(0)-1}{0+1} = -1`) . Vậy tọa độ giao điểm là  #mi(`(0; -1)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x^3 - 3x + 2`)  có đồ thị (C). Tìm số giao điểm của (C) với trục hoành.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Phương trình hoành độ giao điểm:  #mi(`x^3 - 3x + 2 = 0 \Leftrightarrow (x-1)^2(x+2) = 0 \Leftrightarrow x = 1`)  (nghiệm kép) hoặc  #mi(`x = -2`) . Vậy đồ thị cắt trục hoành tại 2 điểm.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Nhận dạng đồ thị hàm bậc ba:] Cho hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có đồ thị như hình vẽ. Xác định dấu của hệ số  #mi(`a`)  và  #mi(`d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, ta thấy  #mi(`\lim_{x \to +\infty} y = +\infty`)  và  #mi(`\lim_{x \to -\infty} y = -\infty`) , suy ra  #mi(`a > 0`) . Đồ thị cắt trục tung tại điểm có tung độ âm, do đó  #mi(`d < 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Nhận dạng đồ thị hàm phân thức bậc nhất/bậc nhất:] Cho hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ với tiệm cận đứng  #mi(`x = 1`) , tiệm cận ngang  #mi(`y = 2`)  và đi qua điểm  #mi(`A(0; 1)`) . Tìm hàm số.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng  #mi(`x = 1 \Rightarrow -\frac{d}{c} = 1 \Rightarrow c = -d`) . Tiệm cận ngang  #mi(`y = 2 \Rightarrow \frac{a}{c} = 2 \Rightarrow a = 2c`) . Đồ thị đi qua  #mi(`A(0; 1) \Rightarrow \frac{b}{d} = 1 \Rightarrow b = d`) . Chọn  #mi(`d = -1 \Rightarrow c = 1, a = 2, b = -1`) . Vậy hàm số là  #mi(`y = \frac{2x-1}{x-1}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Nhận dạng đồ thị hàm phân thức bậc hai/bậc nhất:] Cho hàm số  #mi(`y = \frac{x^2 - 2x + 2}{x - 1}`)  có đồ thị (C). Xác định tiệm cận đứng và tiệm cận xiên của (C).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{1\}`) . Ta có  #mi(`\lim_{x \to 1^+} y = +\infty`) ,  #mi(`\lim_{x \to 1^-} y = -\infty`)  nên tiệm cận đứng là  #mi(`x = 1`) . Viết lại  #mi(`y = x - 1 + \frac{1}{x-1}`) . Khi  #mi(`x \to \pm\infty`) ,  #mi(`y - (x-1) = \frac{1}{x-1} \to 0`)  nên tiệm cận xiên là  #mi(`y = x - 1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Nhận dạng đồ thị hàm bậc ba (tiếp):] Cho hàm số  #mi(`y = -x^3 + 3x^2 - 4`)  có đồ thị (C). Khảo sát sự biến thiên và vẽ đồ thị (C).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = -3x^2 + 6x = -3x(x-2)`) .  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Hàm số nghịch biến trên  #mi(`(-\infty; 0)`)  và  #mi(`(2; +\infty)`) , đồng biến trên  #mi(`(0; 2)`) . Cực trị: CĐ tại  #mi(`x=2, y=0`) ; CT tại  #mi(`x=0, y=-4`) . Đồ thị cắt trục tung tại  #mi(`(0; -4)`) , cắt trục hoành tại  #mi(`x=-1`)  và  #mi(`x=2`)  (nghiệm kép).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị (C). Tìm tọa độ các điểm cực trị của (C).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = 3x^2 - 6x = 3x(x-2)`) .  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Tại  #mi(`x = 0, y = 2`) ; tại  #mi(`x = 2, y = -2`) . Vậy điểm cực đại là  #mi(`(0; 2)`) , điểm cực tiểu là  #mi(`(2; -2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = -x^3 + 3x + 1`)  có đồ thị (C). Tìm tọa độ các điểm cực trị của (C).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) .  #mi(`y' = -3x^2 + 3 = -3(x^2 - 1)`) .  #mi(`y' = 0 \Leftrightarrow x = \pm 1`) . Tại  #mi(`x = 1, y = 3`) ; tại  #mi(`x = -1, y = -1`) . Vậy điểm cực đại là  #mi(`(1; 3)`) , điểm cực tiểu là  #mi(`(-1; -1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{x+2}{x-1}`)  có đồ thị (C). Tìm tiệm cận đứng và tiệm cận ngang của (C).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{1\}`) .  #mi(`\lim_{x \to 1^+} y = +\infty`) ,  #mi(`\lim_{x \to 1^-} y = -\infty`)  nên tiệm cận đứng là  #mi(`x = 1`) .  #mi(`\lim_{x \to \pm\infty} y = 1`)  nên tiệm cận ngang là  #mi(`y = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{2x-1}{x+1}`)  có đồ thị (C). Tìm tọa độ giao điểm của (C) với trục hoành và trục tung.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Giao với trục hoành:  #mi(`y = 0 \Rightarrow 2x - 1 = 0 \Rightarrow x = \frac{1}{2}`) . Điểm  #mi(`\left(\frac{1}{2}; 0\right)`) . Giao với trục tung:  #mi(`x = 0 \Rightarrow y = -1`) . Điểm  #mi(`(0; -1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị (C). Viết phương trình tiếp tuyến của (C) tại điểm có hoành độ  #mi(`x = 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x = 1`) ,  #mi(`y = 0`) .  #mi(`y' = 3x^2 - 6x \Rightarrow y'(1) = -3`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 1) + 0 \Leftrightarrow y = -3x + 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Xác định dấu các hệ số của hàm số từ đồ thị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Xác định dấu các hệ số của hàm số từ đồ thị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm bậc ba  #mi(`y=ax^3+bx^2+cx+d`) : Dựa vào giới hạn  #mi(`\lim_{x\to+\infty} y`)  (nhánh phải đi lên  #mi(`\Rightarrow a>0`) , đi xuống  #mi(`\Rightarrow a<0`) ). Giao điểm với trục tung là  #mi(`(0;d)`) .
  - Hàm bậc ba: Điểm uốn có hoành độ  #mi(`x=-\frac{b}{3a}`) . Dựa vào vị trí điểm uốn so với trục tung để xác định dấu của  #mi(`b`) . Hai điểm cực trị có hoành độ  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1x_2=\frac{c}{3a}`) , dựa vào vị trí 2 điểm cực trị so với trục tung để xác định dấu của  #mi(`c`) .
  - Hàm phân thức  #mi(`y=\frac{ax+b}{cx+d}`) : Tiệm cận đứng  #mi(`x=-\frac{d}{c}`) , tiệm cận ngang  #mi(`y=\frac{a}{c}`) . Giao  #mi(`Oy`)  tại  #mi(`\left(0;\frac{b}{d}\right)`) , giao  #mi(`Ox`)  tại  #mi(`\left(-\frac{b}{a};0\right)`) . Dấu của đạo hàm  #mi(`y'=\frac{ad-bc}{(cx+d)^2}`)  cho biết tính đồng biến/nghịch biến.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhìn dáng đồ thị: Đi lên thì  #mi(`a>0`) , đi xuống thì  #mi(`a<0`) . Giao trục tung tại đâu thì hệ số tự do (hoặc tỉ số) mang dấu đó. Tiệm cận đứng bên phải  #mi(`Ox`)  thì  #mi(`-d/c > 0`) , tiệm cận ngang trên  #mi(`Ox`)  thì  #mi(`a/c > 0`) .
  ]
  - *Công thức cốt lõi:* Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Nhánh cuối cùng của đồ thị đi lên cho ta dấu của hệ số  #mi(`a`)  là ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị đi qua điểm  #mi(`A(0;2)`) , có điểm uốn nằm bên trái trục tung và nhánh phải đi lên. Xác định dấu của các hệ số  #mi(`a, b, d`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: a>0, b>0, d>0]
      \ #text(fill: rgb("#334155"))[Lời giải: Nhánh phải đi lên  #mi(`\Rightarrow a>0`) . Giao  #mi(`Oy`)  tại  #mi(`A(0;2)`)  nằm trên  #mi(`Ox`)   #mi(`\Rightarrow d>0`) . Điểm uốn  #mi(`x=-\frac{b}{3a} < 0`) , mà  #mi(`a>0 \Rightarrow b>0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y=\frac{ax+b}{cx+d}`)  có đồ thị nhận đường thẳng  #mi(`x=2`)  làm tiệm cận đứng và  #mi(`y=-1`)  làm tiệm cận ngang. Xác định dấu của các hệ số  #mi(`a, c, d`)  (biết  #mi(`c>0`) ).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: a<0, d<0]
      \ #text(fill: rgb("#334155"))[Lời giải: Tiệm cận đứng  #mi(`x=-\frac{d}{c}=2 > 0`) , với  #mi(`c>0 \Rightarrow d<0`) . Tiệm cận ngang  #mi(`y=\frac{a}{c}=-1 < 0`) , với  #mi(`c>0 \Rightarrow a<0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Xác định dấu hệ số a, d của hàm bậc ba:] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Biết đồ thị cắt trục tung tại điểm có tung độ âm và nhánh phải của đồ thị đi xuống. Xác định dấu của  #mi(`a`)  và  #mi(`d`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đồ thị, nhánh phải đi xuống nên  #mi(`\lim_{x\to+\infty} y = -\infty \Rightarrow a < 0`) . Đồ thị cắt trục tung tại điểm có tung độ âm nên  #mi(`d < 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Xác định dấu hệ số b của hàm bậc ba:] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  ( #mi(`a \neq 0`) ) có đồ thị như hình vẽ. Biết nhánh phải của đồ thị đi lên và điểm uốn của đồ thị nằm bên phải trục tung. Xác định dấu của hệ số  #mi(`b`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Nhánh phải đi lên  #mi(`\Rightarrow a > 0`) . Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} > 0`) . Vì  #mi(`a > 0`)  nên  #mi(`-b > 0 \Rightarrow b < 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định dấu hệ số c của hàm bậc ba:] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Biết  #mi(`a>0`)  và đồ thị có hai điểm cực trị nằm về hai phía so với trục tung. Xác định dấu của hệ số  #mi(`c`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hai điểm cực trị có hoành độ  #mi(`x_1, x_2`)  là nghiệm của phương trình  #mi(`y'=3ax^2+2bx+c=0`) . Theo định lý Vi-ét,  #mi(`x_1x_2 = \frac{c}{3a}`) . Vì hai điểm cực trị nằm về hai phía trục tung nên  #mi(`x_1x_2 < 0`) . Mà  #mi(`a>0 \Rightarrow \frac{c}{3a} < 0 \Rightarrow c < 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Xác định dấu hệ số của hàm phân thức:] Cho hàm số  #mi(`y=\frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Biết tiệm cận đứng nằm bên phải trục tung, tiệm cận ngang nằm trên trục hoành và đồ thị nghịch biến trên từng khoảng xác định. Xác định dấu của  #mi(`a, c, d`)  (biết  #mi(`c>0`) ).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiệm cận đứng  #mi(`x=-\frac{d}{c} > 0`) , với  #mi(`c>0 \Rightarrow d < 0`) . Tiệm cận ngang  #mi(`y=\frac{a}{c} > 0`) , với  #mi(`c>0 \Rightarrow a > 0`) . Đồ thị nghịch biến  #mi(`\Rightarrow y' = \frac{ad-bc}{(cx+d)^2} < 0 \Rightarrow ad-bc < 0`) . Vì  #mi(`a>0, d<0 \Rightarrow ad < 0`) ,  #mi(`c>0`)  nên  #mi(`bc`)  có thể âm hoặc dương, nhưng không ảnh hưởng đến dấu của  #mi(`a, c, d`)  đã tìm được.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Biết đồ thị cắt trục tung tại điểm có tung độ dương và nhánh phải của đồ thị đi lên. Xác định dấu của  #mi(`a`)  và  #mi(`d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Nhánh phải đi lên  #mi(`\Rightarrow a > 0`) . Đồ thị cắt trục tung tại điểm có tung độ dương  #mi(`\Rightarrow d > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Biết đồ thị cắt trục tung tại điểm có tung độ âm và nhánh trái của đồ thị đi lên. Xác định dấu của  #mi(`a`)  và  #mi(`d`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Nhánh trái đi lên  #mi(`\Rightarrow \lim_{x\to-\infty} y = +\infty \Rightarrow a < 0`) . Đồ thị cắt trục tung tại điểm có tung độ âm  #mi(`\Rightarrow d < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Biết  #mi(`a>0`)  và điểm uốn của đồ thị nằm bên trái trục tung. Xác định dấu của hệ số  #mi(`b`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điểm uốn có hoành độ  #mi(`x = -\frac{b}{3a} < 0`) . Vì  #mi(`a>0`)  nên  #mi(`-b < 0 \Rightarrow b > 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y=ax^3+bx^2+cx+d`)  có đồ thị như hình vẽ. Biết  #mi(`a<0`)  và đồ thị có hai điểm cực trị nằm cùng một phía so với trục tung. Xác định dấu của hệ số  #mi(`c`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hai điểm cực trị có hoành độ  #mi(`x_1, x_2`)  là nghiệm của  #mi(`y'=0`) . Theo Vi-ét,  #mi(`x_1x_2 = \frac{c}{3a}`) . Vì hai điểm cực trị nằm cùng phía so với trục tung nên  #mi(`x_1x_2 > 0`) . Mà  #mi(`a<0 \Rightarrow \frac{c}{3a} > 0 \Rightarrow c < 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y=\frac{ax+b}{cx+d}`)  có đồ thị như hình vẽ. Biết tiệm cận đứng nằm bên trái trục tung, tiệm cận ngang nằm dưới trục hoành và đồ thị đồng biến trên từng khoảng xác định. Xác định dấu của  #mi(`a, c, d`)  (biết  #mi(`c>0`) ).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiệm cận đứng  #mi(`x=-\frac{d}{c} < 0`) , với  #mi(`c>0 \Rightarrow d > 0`) . Tiệm cận ngang  #mi(`y=\frac{a}{c} < 0`) , với  #mi(`c>0 \Rightarrow a < 0`) . Đồ thị đồng biến  #mi(`\Rightarrow y' = \frac{ad-bc}{(cx+d)^2} > 0 \Rightarrow ad-bc > 0`) . Vì  #mi(`a<0, d>0 \Rightarrow ad < 0`) ,  #mi(`c>0`)  nên  #mi(`bc`)  phải âm để  #mi(`ad-bc > 0`) , suy ra  #mi(`b<0`)  (không ảnh hưởng đến dấu  #mi(`a, c, d`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tính khoảng cách từ điểm đến đường tiệm cận ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tính khoảng cách từ điểm đến đường tiệm cận]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Đồ thị hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  ( #mi(`c \neq 0, ad-bc \neq 0`) ) có tiệm cận đứng  #mi(`x = -\frac{d}{c}`)  và tiệm cận ngang  #mi(`y = \frac{a}{c}`) .
  - Đồ thị hàm số  #mi(`y = \frac{ax^2+bx+c}{px+q}`)  ( #mi(`p \neq 0`) , tử không chia hết cho mẫu) có tiệm cận đứng  #mi(`x = -\frac{q}{p}`)  và tiệm cận xiên  #mi(`y = Ax+B`)  (thu được bằng cách chia đa thức tử cho mẫu).
  - Khoảng cách từ điểm  #mi(`M(x_0; y_0)`)  đến đường thẳng  #mi(`\Delta: Ax+By+C=0`)  là  #mi(`d(M, \Delta) = \frac{|Ax_0+By_0+C|}{\sqrt{A^2+B^2}}`) .
  - Khoảng cách từ điểm  #mi(`M(x_0; y_0)`)  đến đường thẳng đứng  #mi(`x = a`)  là  #mi(`|x_0 - a|`)  và đến đường thẳng ngang  #mi(`y = b`)  là  #mi(`|y_0 - b|`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm khoảng cách đến tiệm cận đứng/ngang, chỉ cần lấy trị tuyệt đối hiệu hoành độ (hoặc tung độ) của điểm và đường thẳng. Với tiệm cận xiên, đưa về dạng tổng quát  #mi(`Ax+By+C=0`)  rồi áp dụng công thức khoảng cách.
  ]
  - *Công thức cốt lõi:* Khoảng cách từ điểm  #mi(`M(x_0; y_0)`)  đến đường thẳng  #mi(`\Delta: Ax+By+C=0`)  được tính bởi công thức  #mi(`d(M, \Delta) = \frac{...}{\sqrt{A^2+B^2}}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = \frac{3x-2}{x+1}`)  có đồ thị  #mi(`(C)`) . Tính tổng khoảng cách từ điểm  #mi(`M(1; 2)`)  đến hai đường tiệm cận của đồ thị  #mi(`(C)`)  (kết quả làm tròn đến hàng phần chục).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận đứng  #mi(`x = -1`)  và tiệm cận ngang  #mi(`y = 3`) .\nKhoảng cách từ  #mi(`M(1;2)`)  đến tiệm cận đứng  #mi(`x=-1`)  là  #mi(`d_1 = |1 - (-1)| = 2`) .\nKhoảng cách từ  #mi(`M(1;2)`)  đến tiệm cận ngang  #mi(`y=3`)  là  #mi(`d_2 = |2 - 3| = 1`) .\nTổng khoảng cách là  #mi(`d_1 + d_2 = 2 + 1 = 3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{x^2-3x+3}{x-2}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`A(1; 1)`)  đến đường tiệm cận xiên của đồ thị  #mi(`(C)`)  (kết quả làm tròn đến hàng phần trăm).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.71]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y = \frac{x^2-3x+3}{x-2} = x - 1 + \frac{1}{x-2}`) .\nĐồ thị có tiệm cận xiên là đường thẳng  #mi(`\Delta: y = x - 1 \Leftrightarrow x - y - 1 = 0`) .\nKhoảng cách từ  #mi(`A(1;1)`)  đến  #mi(`\Delta`)  là  #mi(`d(A, \Delta) = \frac{|1 - 1 - 1|}{\sqrt{1^2 + (-1)^2}} = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2} \approx 0.71`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = \frac{2x+1}{x-3}`)  có đồ thị  #mi(`(C)`) . Tìm điểm  #mi(`M`)  thuộc trục hoành sao cho khoảng cách từ  #mi(`M`)  đến tiệm cận đứng của  #mi(`(C)`)  bằng  #mi(`2`)  và  #mi(`M`)  có hoành độ dương.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận đứng  #mi(`x = 3`) .\nĐiểm  #mi(`M`)  thuộc trục hoành nên  #mi(`M(x_0; 0)`)  với  #mi(`x_0 > 0`) .\nKhoảng cách từ  #mi(`M`)  đến tiệm cận đứng là  #mi(`d = |x_0 - 3|`) .\nTheo giả thiết  #mi(`|x_0 - 3| = 2 \Leftrightarrow x_0 - 3 = 2`)  hoặc  #mi(`x_0 - 3 = -2 \Leftrightarrow x_0 = 5`)  hoặc  #mi(`x_0 = 1`) .\nVì  #mi(`x_0 > 0`)  nên cả hai giá trị đều thỏa mãn. Tuy nhiên đề bài yêu cầu tìm điểm  #mi(`M`)  (có thể có 2 điểm). Nếu chỉ xét  #mi(`x_0>0`)  thì có 2 điểm. Nhưng thường bài toán tìm 1 điểm, ta lấy  #mi(`x_0=5`)  hoặc  #mi(`x_0=1`) . Giả sử lấy  #mi(`x_0=5`) , khi đó  #mi(`M(5;0)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Khoảng cách đến tiệm cận đứng và ngang:] Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Tính tổng khoảng cách từ điểm  #mi(`M(3; 0)`)  đến hai đường tiệm cận của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`\lim_{x \to 1^+} y = +\infty`)  và  #mi(`\lim_{x \to 1^-} y = -\infty`)  nên đồ thị có tiệm cận đứng là đường thẳng  #mi(`\Delta_1: x = 1`) .\nTa có  #mi(`\lim_{x \to \pm\infty} y = 2`)  nên đồ thị có tiệm cận ngang là đường thẳng  #mi(`\Delta_2: y = 2`) .\nKhoảng cách từ  #mi(`M(3;0)`)  đến  #mi(`\Delta_1`)  là  #mi(`d_1 = |3 - 1| = 2`) .\nKhoảng cách từ  #mi(`M(3;0)`)  đến  #mi(`\Delta_2`)  là  #mi(`d_2 = |0 - 2| = 2`) .\nVậy tổng khoảng cách là  #mi(`d_1 + d_2 = 2 + 2 = 4`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Khoảng cách đến tiệm cận xiên:] Cho hàm số  #mi(`y = \frac{x^2+x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`M(2; 0)`)  đến đường tiệm cận xiên của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nThực hiện phép chia đa thức:  #mi(`y = \frac{x^2+x+1}{x-1} = x + 2 + \frac{3}{x-1}`) .\nTa có  #mi(`\lim_{x \to \pm\infty} [y - (x+2)] = \lim_{x \to \pm\infty} \frac{3}{x-1} = 0`)  nên đồ thị có tiệm cận xiên là đường thẳng  #mi(`\Delta: y = x + 2 \Leftrightarrow x - y + 2 = 0`) .\nKhoảng cách từ  #mi(`M(2;0)`)  đến  #mi(`\Delta`)  là  #mi(`d(M, \Delta) = \frac{|2 - 0 + 2|}{\sqrt{1^2 + (-1)^2}} = \frac{4}{\sqrt{2}} = 2\sqrt{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Khoảng cách đến tiệm cận đứng và ngang (biến thể):] Cho hàm số  #mi(`y = \frac{2x-1}{x+2}`)  có đồ thị  #mi(`(C)`) . Tính tổng khoảng cách từ điểm  #mi(`M(0; 1)`)  đến hai đường tiệm cận của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-2\}`) .\nĐồ thị có tiệm cận đứng  #mi(`\Delta_1: x = -2`)  và tiệm cận ngang  #mi(`\Delta_2: y = 2`) .\nKhoảng cách từ  #mi(`M(0;1)`)  đến  #mi(`\Delta_1`)  là  #mi(`d_1 = |0 - (-2)| = 2`) .\nKhoảng cách từ  #mi(`M(0;1)`)  đến  #mi(`\Delta_2`)  là  #mi(`d_2 = |1 - 2| = 1`) .\nVậy tổng khoảng cách là  #mi(`d_1 + d_2 = 2 + 1 = 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Khoảng cách đến tiệm cận xiên (biến thể):] Cho hàm số  #mi(`y = \frac{x^2-2x+2}{x-1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`M(2; 1)`)  đến đường tiệm cận xiên của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R} \setminus \{1\}`) .\nTa có  #mi(`y = \frac{x^2-2x+2}{x-1} = x - 1 + \frac{1}{x-1}`) .\nĐồ thị có tiệm cận xiên là đường thẳng  #mi(`\Delta: y = x - 1 \Leftrightarrow x - y - 1 = 0`) .\nKhoảng cách từ  #mi(`M(2;1)`)  đến  #mi(`\Delta`)  là  #mi(`d(M, \Delta) = \frac{|2 - 1 - 1|}{\sqrt{1^2 + (-1)^2}} = 0`) .\n(Điểm  #mi(`M`)  nằm ngay trên đường tiệm cận xiên).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = \frac{3x-2}{x+1}`)  có đồ thị  #mi(`(C)`) . Tính tổng khoảng cách từ điểm  #mi(`M(2; 1)`)  đến hai đường tiệm cận của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .\nĐồ thị có tiệm cận đứng  #mi(`\Delta_1: x = -1`)  và tiệm cận ngang  #mi(`\Delta_2: y = 3`) .\nKhoảng cách từ  #mi(`M(2;1)`)  đến  #mi(`\Delta_1`)  là  #mi(`d_1 = |2 - (-1)| = 3`) .\nKhoảng cách từ  #mi(`M(2;1)`)  đến  #mi(`\Delta_2`)  là  #mi(`d_2 = |1 - 3| = 2`) .\nVậy tổng khoảng cách là  #mi(`d_1 + d_2 = 3 + 2 = 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{4x+3}{x-2}`)  có đồ thị  #mi(`(C)`) . Tính tổng khoảng cách từ điểm  #mi(`M(3; 2)`)  đến hai đường tiệm cận của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nĐồ thị có tiệm cận đứng  #mi(`\Delta_1: x = 2`)  và tiệm cận ngang  #mi(`\Delta_2: y = 4`) .\nKhoảng cách từ  #mi(`M(3;2)`)  đến  #mi(`\Delta_1`)  là  #mi(`d_1 = |3 - 2| = 1`) .\nKhoảng cách từ  #mi(`M(3;2)`)  đến  #mi(`\Delta_2`)  là  #mi(`d_2 = |2 - 4| = 2`) .\nVậy tổng khoảng cách là  #mi(`d_1 + d_2 = 1 + 2 = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{x^2+2x+2}{x+1}`)  có đồ thị  #mi(`(C)`) . Tính khoảng cách từ điểm  #mi(`M(0; 1)`)  đến đường tiệm cận xiên của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{-1\}`) .\nTa có  #mi(`y = \frac{x^2+2x+2}{x+1} = x + 1 + \frac{1}{x+1}`) .\nĐồ thị có tiệm cận xiên là đường thẳng  #mi(`\Delta: y = x + 1 \Leftrightarrow x - y + 1 = 0`) .\nKhoảng cách từ  #mi(`M(0;1)`)  đến  #mi(`\Delta`)  là  #mi(`d(M, \Delta) = \frac{|0 - 1 + 1|}{\sqrt{1^2 + (-1)^2}} = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{2x-1}{x-1}`)  có đồ thị  #mi(`(C)`) . Tìm điểm  #mi(`M`)  thuộc trục tung sao cho khoảng cách từ  #mi(`M`)  đến tiệm cận đứng của  #mi(`(C)`)  bằng  #mi(`3`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận đứng  #mi(`x = 1`) .\nĐiểm  #mi(`M`)  thuộc trục tung nên  #mi(`M(0; y_0)`) .\nKhoảng cách từ  #mi(`M`)  đến tiệm cận đứng là  #mi(`d = |0 - 1| = 1 \neq 3`) .\nVậy không tồn tại điểm  #mi(`M`)  thuộc trục tung thỏa mãn yêu cầu bài toán.\n(Lưu ý: Đề bài có thể có sai sót, nếu  #mi(`M`)  thuộc trục hoành thì  #mi(`M(x_0;0)`) ,  #mi(`|x_0-1|=3 \Rightarrow x_0=4`)  hoặc  #mi(`x_0=-2`) ).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = \frac{x^2-3x+4}{x-2}`)  có đồ thị  #mi(`(C)`) . Tính tổng khoảng cách từ điểm  #mi(`M(3; 1)`)  đến hai đường tiệm cận của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R} \setminus \{2\}`) .\nTa có  #mi(`y = \frac{x^2-3x+4}{x-2} = x - 1 + \frac{2}{x-2}`) .\nĐồ thị có tiệm cận đứng  #mi(`\Delta_1: x = 2`)  và tiệm cận xiên  #mi(`\Delta_2: y = x - 1 \Leftrightarrow x - y - 1 = 0`) .\nKhoảng cách từ  #mi(`M(3;1)`)  đến  #mi(`\Delta_1`)  là  #mi(`d_1 = |3 - 2| = 1`) .\nKhoảng cách từ  #mi(`M(3;1)`)  đến  #mi(`\Delta_2`)  là  #mi(`d_2 = \frac{|3 - 1 - 1|}{\sqrt{1^2 + (-1)^2}} = \frac{1}{\sqrt{2}} = \frac{\sqrt{2}}{2}`) .\nVậy tổng khoảng cách là  #mi(`d_1 + d_2 = 1 + \frac{\sqrt{2}}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Tìm giá trị lớn nhất, giá trị nhỏ nhất của hàm số trên đoạn ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Tìm giá trị lớn nhất, giá trị nhỏ nhất của hàm số trên đoạn]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm giá trị lớn nhất (GTLN) và giá trị nhỏ nhất (GTNN) của hàm số  #mi(`y=f(x)`)  liên tục trên đoạn  #mi(`[a;b]`) , ta thực hiện các bước: 1. Tính đạo hàm  #mi(`f'(x)`)  và tìm các điểm  #mi(`x_i \in (a;b)`)  mà tại đó  #mi(`f'(x)=0`)  hoặc  #mi(`f'(x)`)  không xác định.
  - 2. Tính các giá trị  #mi(`f(a)`) ,  #mi(`f(b)`)  và  #mi(`f(x_i)`) .
  - 3. So sánh các giá trị vừa tìm được. Số lớn nhất trong các giá trị đó là  #mi(`\max_{[a;b]} f(x)`) , số nhỏ nhất là  #mi(`\min_{[a;b]} f(x)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy tắc vàng: 'Đạo hàm - Nghiệm - Đầu mút - So sánh'. Nhớ kỹ: Chỉ lấy nghiệm thuộc khoảng mở  #mi(`(a;b)`) , còn giá trị phải tính cả ở hai đầu mút  #mi(`a`)  và  #mi(`b`) .
  ]
  - *Công thức cốt lõi:* Nếu hàm số  #mi(`y=f(x)`)  liên tục trên  #mi(`[a;b]`)  và có đạo hàm trên  #mi(`(a;b)`) , thì  #mi(`\max_{[a;b]} f(x) = \max \{ f(a); f(b); ... \}`)  với  #mi(`x_i`)  là các nghiệm của phương trình  #mi(`... = 0`)  thuộc  #mi(`(a;b)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Gọi  #mi(`M, m`)  lần lượt là giá trị lớn nhất, giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 2x^2 - 4x + 5`)  trên đoạn  #mi(`[1;3]`) . Tính  #mi(`8M - 300m`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 964]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`y' = 3x^2 - 4x - 4`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 4x - 4 = 0 \Leftrightarrow \left[ \begin{array}{l} x = 2 \in [1;3] \\ x = -\frac{2}{3} \notin [1;3] \end{array} \right.`) \nTính các giá trị:  #mi(`y(1) = 0`) ,  #mi(`y(3) = 8`) ,  #mi(`y(2) = -3`) .\nSuy ra  #mi(`M = 8`) ,  #mi(`m = -3`) .\nVậy  #mi(`8M - 300m = 8.8 - 300.(-3) = 64 + 900 = 964`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Gọi  #mi(`M`)  và  #mi(`n`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 - 9x + 35`)  trên đoạn  #mi(`[-4;4]`) . Tính  #mi(`2M + 3n`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -43]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`y' = 3x^2 - 6x - 9`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 6x - 9 = 0 \Leftrightarrow \left[ \begin{array}{l} x = 3 \in [-4;4] \\ x = -1 \in [-4;4] \end{array} \right.`) \nTính các giá trị:  #mi(`y(-4) = -41`) ,  #mi(`y(4) = 15`) ,  #mi(`y(3) = 8`) ,  #mi(`y(-1) = 40`) .\nSuy ra  #mi(`M = 40`) ,  #mi(`n = -41`) .\nVậy  #mi(`2M + 3n = 2.40 + 3.(-41) = 80 - 123 = -43`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Giá trị nhỏ nhất của hàm số  #mi(`f(x) = x^4 - 12x^2 - 4`)  trên đoạn  #mi(`[0;9]`)  bằng bao nhiêu?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -40]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`f'(x) = 4x^3 - 24x`) .\nCho  #mi(`f'(x) = 0 \Leftrightarrow 4x(x^2 - 6) = 0 \Leftrightarrow \left[ \begin{array}{l} x = 0 \in [0;9] \\ x = \sqrt{6} \in [0;9] \\ x = -\sqrt{6} \notin [0;9] \end{array} \right.`) \nTính các giá trị:  #mi(`f(0) = -4`) ,  #mi(`f(9) = 5585`) ,  #mi(`f(\sqrt{6}) = -40`) .\nSo sánh các giá trị, ta có giá trị nhỏ nhất là  #mi(`-40`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hàm đa thức bậc ba trên đoạn:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-3;2]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`y' = 3x^2 - 3`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x^2 = 1 \Leftrightarrow \left[ \begin{array}{l} x = 1 \in [-3;2] \\ x = -1 \in [-3;2] \end{array} \right.`) \nTính các giá trị:\n #mi(`y(-3) = (-3)^3 - 3(-3) + 2 = -16`) \n #mi(`y(2) = 2^3 - 3(2) + 2 = 4`) \n #mi(`y(1) = 1^3 - 3(1) + 2 = 0`) \n #mi(`y(-1) = (-1)^3 - 3(-1) + 2 = 4`) \nSo sánh các giá trị trên, ta có:\nGiá trị lớn nhất  #mi(`\max_{[-3;2]} y = 4`)  tại  #mi(`x = 2`)  và  #mi(`x = -1`) .\nGiá trị nhỏ nhất  #mi(`\min_{[-3;2]} y = -16`)  tại  #mi(`x = -3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hàm phân thức trên đoạn:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \frac{x^2+3}{x-2}`)  trên đoạn  #mi(`[3;4]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số liên tục trên  #mi(`[3;4]`) .\nĐạo hàm:  #mi(`y' = \frac{2x(x-2) - (x^2+3)}{(x-2)^2} = \frac{x^2-4x-3}{(x-2)^2}`) .\nCho  #mi(`y' = 0 \Leftrightarrow x^2 - 4x - 3 = 0 \Leftrightarrow \left[ \begin{array}{l} x = 2 + \sqrt{7} \approx 4.64 \notin [3;4] \\ x = 2 - \sqrt{7} \approx -0.64 \notin [3;4] \end{array} \right.`) \nDo đó trên đoạn  #mi(`[3;4]`) , hàm số không có điểm tới hạn.\nTính các giá trị ở hai đầu mút:\n #mi(`y(3) = \frac{3^2+3}{3-2} = 12`) \n #mi(`y(4) = \frac{4^2+3}{4-2} = \frac{19}{2} = 9.5`) \nSo sánh, ta có:\nGiá trị lớn nhất  #mi(`\max_{[3;4]} y = 12`)  tại  #mi(`x = 3`) .\nGiá trị nhỏ nhất  #mi(`\min_{[3;4]} y = \frac{19}{2}`)  tại  #mi(`x = 4`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm chứa căn/tham số:] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x + \frac{4}{x}`)  trên đoạn  #mi(`[1;3]`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hàm số liên tục trên  #mi(`[1;3]`) .\nĐạo hàm:  #mi(`y' = 1 - \frac{4}{x^2} = \frac{x^2-4}{x^2}`) .\nCho  #mi(`y' = 0 \Leftrightarrow x^2 - 4 = 0 \Leftrightarrow \left[ \begin{array}{l} x = 2 \in [1;3] \\ x = -2 \notin [1;3] \end{array} \right.`) \nTính các giá trị:\n #mi(`y(1) = 1 + \frac{4}{1} = 5`) \n #mi(`y(3) = 3 + \frac{4}{3} = \frac{13}{3}`) \n #mi(`y(2) = 2 + \frac{4}{2} = 4`) \nSo sánh, ta có:\nGiá trị lớn nhất  #mi(`\max_{[1;3]} y = 5`)  tại  #mi(`x = 1`) .\nGiá trị nhỏ nhất  #mi(`\min_{[1;3]} y = 4`)  tại  #mi(`x = 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Cho đồ thị, tìm GTLN, GTNN trên đoạn:] Cho hàm số  #mi(`y = f(x)`)  liên tục trên đoạn  #mi(`[-1;2]`)  và có đồ thị như hình vẽ bên dưới. Gọi  #mi(`M, m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số đã cho trên đoạn  #mi(`[-1;2]`) . Tính  #mi(`M - 2m`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Quan sát đồ thị hàm số  #mi(`y = f(x)`)  trên đoạn  #mi(`[-1;2]`) :\n- Điểm cao nhất của đồ thị trên đoạn này là đỉnh có tọa độ  #mi(`(1;3)`) , do đó giá trị lớn nhất  #mi(`M = 3`) .\n- Điểm thấp nhất của đồ thị trên đoạn này là điểm có tọa độ  #mi(`(2;-2)`) , do đó giá trị nhỏ nhất  #mi(`m = -2`) .\nVậy  #mi(`M - 2m = 3 - 2(-2) = 3 + 4 = 7`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 + 2`)  trên đoạn  #mi(`[-1;2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`y' = 3x^2 - 6x`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow \left[ \begin{array}{l} x = 0 \in [-1;2] \\ x = 2 \in [-1;2] \end{array} \right.`) \nTính các giá trị:  #mi(`y(-1) = -2`) ,  #mi(`y(2) = -2`) ,  #mi(`y(0) = 2`) .\nVậy  #mi(`\max_{[-1;2]} y = 2`)  tại  #mi(`x = 0`) ;  #mi(`\min_{[-1;2]} y = -2`)  tại  #mi(`x = -1`)  và  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x^2 + 2`)  trên đoạn  #mi(`[0;3]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`y' = 3x^2 - 6x`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow \left[ \begin{array}{l} x = 0 \in [0;3] \\ x = 2 \in [0;3] \end{array} \right.`) \nTính các giá trị:  #mi(`y(0) = 2`) ,  #mi(`y(3) = 2`) ,  #mi(`y(2) = -2`) .\nVậy  #mi(`\max_{[0;3]} y = 2`)  tại  #mi(`x = 0`)  và  #mi(`x = 3`) ;  #mi(`\min_{[0;3]} y = -2`)  tại  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = \frac{x^2+3}{x-2}`)  trên đoạn  #mi(`[3;4]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số liên tục trên  #mi(`[3;4]`) .\nĐạo hàm:  #mi(`y' = \frac{x^2-4x-3}{(x-2)^2}`) .\nCho  #mi(`y' = 0 \Leftrightarrow x^2 - 4x - 3 = 0 \Leftrightarrow x = 2 \pm \sqrt{7}`)  (không có nghiệm thuộc  #mi(`[3;4]`) ).\nTính các giá trị:  #mi(`y(3) = 12`) ,  #mi(`y(4) = \frac{19}{2} = 9.5`) .\nVậy  #mi(`\max_{[3;4]} y = 12`)  tại  #mi(`x = 3`) ;  #mi(`\min_{[3;4]} y = \frac{19}{2}`)  tại  #mi(`x = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x + \frac{4}{x}`)  trên đoạn  #mi(`[1;3]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hàm số liên tục trên  #mi(`[1;3]`) .\nĐạo hàm:  #mi(`y' = 1 - \frac{4}{x^2} = \frac{x^2-4}{x^2}`) .\nCho  #mi(`y' = 0 \Leftrightarrow x^2 - 4 = 0 \Leftrightarrow \left[ \begin{array}{l} x = 2 \in [1;3] \\ x = -2 \notin [1;3] \end{array} \right.`) \nTính các giá trị:  #mi(`y(1) = 5`) ,  #mi(`y(3) = \frac{13}{3}`) ,  #mi(`y(2) = 4`) .\nVậy  #mi(`\max_{[1;3]} y = 5`)  tại  #mi(`x = 1`) ;  #mi(`\min_{[1;3]} y = 4`)  tại  #mi(`x = 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = f(x)`)  liên tục trên đoạn  #mi(`[-1;2]`)  và có đồ thị như hình vẽ bên dưới. Gọi  #mi(`M, m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số đã cho trên đoạn  #mi(`[-1;2]`) . Tính  #mi(`M - 2m`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Quan sát đồ thị hàm số  #mi(`y = f(x)`)  trên đoạn  #mi(`[-1;2]`) :\n- Điểm cao nhất của đồ thị trên đoạn này là đỉnh có tọa độ  #mi(`(1;3)`) , do đó giá trị lớn nhất  #mi(`M = 3`) .\n- Điểm thấp nhất của đồ thị trên đoạn này là điểm có tọa độ  #mi(`(2;-2)`) , do đó giá trị nhỏ nhất  #mi(`m = -2`) .\nVậy  #mi(`M - 2m = 3 - 2(-2) = 3 + 4 = 7`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Tìm giá trị lớn nhất và giá trị nhỏ nhất của hàm số  #mi(`y = x^3 - 3x + 2`)  trên đoạn  #mi(`[-3;2]`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định:  #mi(`D = \mathbb{R}`) .\nĐạo hàm:  #mi(`y' = 3x^2 - 3`) .\nCho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x^2 = 1 \Leftrightarrow \left[ \begin{array}{l} x = 1 \in [-3;2] \\ x = -1 \in [-3;2] \end{array} \right.`) \nTính các giá trị:  #mi(`y(-3) = -16`) ,  #mi(`y(2) = 4`) ,  #mi(`y(1) = 0`) ,  #mi(`y(-1) = 4`) .\nVậy  #mi(`\max_{[-3;2]} y = 4`)  tại  #mi(`x = 2`)  và  #mi(`x = -1`) ;  #mi(`\min_{[-3;2]} y = -16`)  tại  #mi(`x = -3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Tính giá trị biểu thức liên quan đến GTLN, GTNN ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Tính giá trị biểu thức liên quan đến GTLN, GTNN]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để tìm GTLN, GTNN của hàm số  #mi(`y = f(x)`)  trên đoạn  #mi(`[a; b]`) , ta thực hiện các bước: Tính đạo hàm  #mi(`f'(x)`) , tìm các nghiệm  #mi(`x_i \in (a; b)`)  của phương trình  #mi(`f'(x) = 0`) ; Tính các giá trị  #mi(`f(a), f(b), f(x_i)`) ; So sánh và kết luận  #mi(`M = \max_{[a;b]} f(x)`)  và  #mi(`m = \min_{[a;b]} f(x)`) .
  - Khi biểu thức chứa tham số  #mi(`m`) , ta tìm GTLN, GTNN của hàm số theo  #mi(`m`)  (hoặc tìm điểm tới hạn phụ thuộc  #mi(`m`) ), sau đó thiết lập phương trình hoặc bất phương trình theo yêu cầu đề bài để giải tìm  #mi(`m`) .
  - Đối với hàm số bậc ba hoặc hàm phân thức, cần chú ý xét dấu đạo hàm và giá trị tại các điểm tới hạn cũng như tại hai đầu mút của đoạn để xác định chính xác GTLN và GTNN.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi tìm GTLN, GTNN trên đoạn  #mi(`[a;b]`) : 'Tính đạo hàm, tìm nghiệm trong khoảng, tính giá trị tại nghiệm và hai đầu mút, so sánh lớn nhất - nhỏ nhất'. Với bài toán chứa tham số, hãy xét vị trí điểm tới hạn so với đoạn để chia trường hợp.
  ]
  - *Công thức cốt lõi:* Cho hàm số  #mi(`y = f(x)`)  xác định trên đoạn  #mi(`[a;b]`) . Nếu  #mi(`f'(x) = 0`)  có các nghiệm  #mi(`x_1, x_2 \in (a;b)`)  thì  #mi(`\max_{[a;b]} f(x) = \max \{f(a), f(b), ...\}`)  và  #mi(`\min_{[a;b]} f(x) = \min \{f(a), f(b), ...\}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x + 2`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[0; 2]`) . Tính giá trị của biểu thức  #mi(`P = 2M - m`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 8]
      \ #text(fill: rgb("#334155"))[Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 3`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x^2 - 3 = 0 \Leftrightarrow x = 1`)  (nhận) hoặc  #mi(`x = -1`)  (loại).\nTính các giá trị:  #mi(`y(0) = 2`) ,  #mi(`y(1) = 0`) ,  #mi(`y(2) = 4`) .\nSuy ra  #mi(`M = \max_{[0;2]} y = 4`)  và  #mi(`m = \min_{[0;2]} y = 0`) .\nVậy  #mi(`P = 2M - m = 2.4 - 0 = 8`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x + \frac{4}{x}`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[1; 4]`) . Tính giá trị của biểu thức  #mi(`T = M^2 - m^2`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 9]
      \ #text(fill: rgb("#334155"))[Lời giải: Tính đạo hàm:  #mi(`y' = 1 - \frac{4}{x^2} = \frac{x^2 - 4}{x^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x^2 - 4 = 0 \Leftrightarrow x = 2`)  (nhận) hoặc  #mi(`x = -2`)  (loại).\nTính các giá trị:  #mi(`y(1) = 5`) ,  #mi(`y(2) = 4`) ,  #mi(`y(4) = 5`) .\nSuy ra  #mi(`M = \max_{[1;4]} y = 5`)  và  #mi(`m = \min_{[1;4]} y = 4`) .\nVậy  #mi(`T = M^2 - m^2 = 5^2 - 4^2 = 25 - 16 = 9`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = x^3 - 3x^2 + m`) . Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[0; 2]`)  bằng  #mi(`2`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6]
      \ #text(fill: rgb("#334155"))[Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nTính các giá trị:  #mi(`y(0) = m`) ,  #mi(`y(2) = m - 4`) .\nVì  #mi(`m - 4 < m`)  nên giá trị nhỏ nhất của hàm số trên  #mi(`[0; 2]`)  là  #mi(`m - 4`) .\nTheo đề bài, ta có  #mi(`m - 4 = 2 \Leftrightarrow m = 6`) .\nVậy  #mi(`m = 6`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản (Biến thể 1):] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[-1; 2]`) . Tính giá trị của biểu thức  #mi(`P = M - 2m`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tính đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nCác điểm tới hạn thuộc đoạn  #mi(`[-1; 2]`)  là  #mi(`x = 0`)  và  #mi(`x = 2`) .\nTính các giá trị:  #mi(`y(-1) = -2`) ,  #mi(`y(0) = 2`) ,  #mi(`y(2) = -2`) .\nSuy ra  #mi(`M = \max_{[-1;2]} y = 2`)  và  #mi(`m = \min_{[-1;2]} y = -2`) .\nVậy  #mi(`P = M - 2m = 2 - 2(-2) = 6`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng công thức cơ bản (Biến thể 1):] Cho hàm số  #mi(`y = \frac{x^2 + 3}{x - 1}`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[2; 4]`) . Tính giá trị của biểu thức  #mi(`T = M \cdot m`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tính đạo hàm:  #mi(`y' = \frac{2x(x - 1) - (x^2 + 3)}{(x - 1)^2} = \frac{x^2 - 2x - 3}{(x - 1)^2}`) .\nCho  #mi(`y' = 0 \Leftrightarrow x^2 - 2x - 3 = 0 \Leftrightarrow x = 3`)  (nhận) hoặc  #mi(`x = -1`)  (loại).\nTính các giá trị:  #mi(`y(2) = 7`) ,  #mi(`y(3) = 6`) ,  #mi(`y(4) = \frac{19}{3}`) .\nSuy ra  #mi(`M = \max_{[2;4]} y = 7`)  và  #mi(`m = \min_{[2;4]} y = 6`) .\nVậy  #mi(`T = M \cdot m = 7 \cdot 6 = 42`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng công thức cơ bản (Biến thể 1):] Cho hàm số  #mi(`y = x^4 - 2x^2 + 3`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[0; 2]`) . Tính giá trị của biểu thức  #mi(`S = M + m`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tính đạo hàm:  #mi(`y' = 4x^3 - 4x`) . Cho  #mi(`y' = 0 \Leftrightarrow 4x(x^2 - 1) = 0 \Leftrightarrow x = 0`) ,  #mi(`x = 1`)  hoặc  #mi(`x = -1`) .\nCác điểm tới hạn thuộc đoạn  #mi(`[0; 2]`)  là  #mi(`x = 0`)  và  #mi(`x = 1`) .\nTính các giá trị:  #mi(`y(0) = 3`) ,  #mi(`y(1) = 2`) ,  #mi(`y(2) = 11`) .\nSuy ra  #mi(`M = \max_{[0;2]} y = 11`)  và  #mi(`m = \min_{[0;2]} y = 2`) .\nVậy  #mi(`S = M + m = 11 + 2 = 13`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tham số từ điều kiện GTLN, GTNN (Biến thể 2):] Cho hàm số  #mi(`y = x + \frac{m}{x}`)  (với  #mi(`m > 0`) ). Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[1; 3]`)  bằng  #mi(`4`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tính đạo hàm:  #mi(`y' = 1 - \frac{m}{x^2} = \frac{x^2 - m}{x^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x^2 = m \Leftrightarrow x = \sqrt{m}`)  (vì  #mi(`m > 0`) ).\nXét các trường hợp:
- Nếu  #mi(`\sqrt{m} \in [1; 3] \Leftrightarrow 1 \le m \le 9`) : Hàm số đạt GTNN tại  #mi(`x = \sqrt{m}`) , suy ra  #mi(`y(\sqrt{m}) = 2\sqrt{m} = 4 \Leftrightarrow \sqrt{m} = 2 \Leftrightarrow m = 4`)  (thỏa mãn).
- Nếu  #mi(`\sqrt{m} < 1 \Leftrightarrow 0 < m < 1`) : Hàm số đồng biến trên  #mi(`[1; 3]`) , GTNN là  #mi(`y(1) = 1 + m = 4 \Leftrightarrow m = 3`)  (loại).
- Nếu  #mi(`\sqrt{m} > 3 \Leftrightarrow m > 9`) : Hàm số nghịch biến trên  #mi(`[1; 3]`) , GTNN là  #mi(`y(3) = 3 + \frac{m}{3} = 4 \Leftrightarrow m = 3`)  (loại).\nVậy  #mi(`m = 4`)  là giá trị cần tìm.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 1`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[-1; 1]`) . Tính giá trị của biểu thức  #mi(`P = M - m`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`)  (loại).\nTính các giá trị:  #mi(`y(-1) = -3`) ,  #mi(`y(0) = 1`) ,  #mi(`y(1) = -1`) .\nSuy ra  #mi(`M = 1`)  và  #mi(`m = -3`) .\nVậy  #mi(`P = M - m = 1 - (-3) = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 1`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[1; 3]`) . Tính giá trị của biểu thức  #mi(`T = M + m`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = 3x^2 - 6x`) . Cho  #mi(`y' = 0 \Leftrightarrow 3x(x - 2) = 0 \Leftrightarrow x = 0`)  (loại) hoặc  #mi(`x = 2`) .\nTính các giá trị:  #mi(`y(1) = -1`) ,  #mi(`y(2) = -3`) ,  #mi(`y(3) = 1`) .\nSuy ra  #mi(`M = 1`)  và  #mi(`m = -3`) .\nVậy  #mi(`T = M + m = 1 + (-3) = -2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{x^2 + 2}{x - 1}`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[2; 3]`) . Tính giá trị của biểu thức  #mi(`S = M \cdot m`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = \frac{2x(x - 1) - (x^2 + 2)}{(x - 1)^2} = \frac{x^2 - 2x - 2}{(x - 1)^2}`) .\nCho  #mi(`y' = 0 \Leftrightarrow x^2 - 2x - 2 = 0 \Leftrightarrow x = 1 + \sqrt{3}`)  (nhận) hoặc  #mi(`x = 1 - \sqrt{3}`)  (loại).\nTính các giá trị:  #mi(`y(2) = 6`) ,  #mi(`y(1 + \sqrt{3}) = 2 + 2\sqrt{3}`) ,  #mi(`y(3) = \frac{11}{2}`) .\nSuy ra  #mi(`M = 2 + 2\sqrt{3}`)  và  #mi(`m = \frac{11}{2}`) .\nVậy  #mi(`S = M \cdot m = (2 + 2\sqrt{3}) \cdot \frac{11}{2} = 11 + 11\sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x + \frac{m}{x}`)  (với  #mi(`m > 0`) ). Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[1; 2]`)  bằng  #mi(`4`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = 1 - \frac{m}{x^2} = \frac{x^2 - m}{x^2}`) . Cho  #mi(`y' = 0 \Leftrightarrow x = \sqrt{m}`)  (vì  #mi(`m > 0`) ).\nXét các trường hợp:
- Nếu  #mi(`\sqrt{m} \in [1; 2] \Leftrightarrow 1 \le m \le 4`) : GTNN là  #mi(`y(\sqrt{m}) = 2\sqrt{m} = 4 \Leftrightarrow m = 4`)  (thỏa mãn).
- Nếu  #mi(`\sqrt{m} < 1 \Leftrightarrow 0 < m < 1`) : Hàm số đồng biến trên  #mi(`[1; 2]`) , GTNN là  #mi(`y(1) = 1 + m = 4 \Leftrightarrow m = 3`)  (loại).
- Nếu  #mi(`\sqrt{m} > 2 \Leftrightarrow m > 4`) : Hàm số nghịch biến trên  #mi(`[1; 2]`) , GTNN là  #mi(`y(2) = 2 + \frac{m}{2} = 4 \Leftrightarrow m = 4`)  (loại vì  #mi(`m>4`) ).\nVậy  #mi(`m = 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = x^4 - 2x^2 + 3`) . Gọi  #mi(`M`)  và  #mi(`m`)  lần lượt là giá trị lớn nhất và giá trị nhỏ nhất của hàm số trên đoạn  #mi(`[-1; 1]`) . Tính giá trị của biểu thức  #mi(`P = M^2 + m^2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tính đạo hàm:  #mi(`y' = 4x^3 - 4x`) . Cho  #mi(`y' = 0 \Leftrightarrow 4x(x^2 - 1) = 0 \Leftrightarrow x = 0, x = 1, x = -1`) .\nTính các giá trị:  #mi(`y(-1) = 2`) ,  #mi(`y(0) = 3`) ,  #mi(`y(1) = 2`) .\nSuy ra  #mi(`M = 3`)  và  #mi(`m = 2`) .\nVậy  #mi(`P = M^2 + m^2 = 3^2 + 2^2 = 13`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Viết phương trình tiếp tuyến của đồ thị hàm số ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Viết phương trình tiếp tuyến của đồ thị hàm số]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Phương trình tiếp tuyến của đồ thị hàm số  #mi(`y = f(x)`)  tại điểm  #mi(`M(x_0; y_0)`)  thuộc đồ thị là:  #mi(`y = f'(x_0)(x - x_0) + y_0`) .
  - Nếu biết hệ số góc  #mi(`k`)  của tiếp tuyến, ta giải phương trình  #mi(`f'(x_0) = k`)  để tìm hoành độ tiếp điểm  #mi(`x_0`) , sau đó tìm  #mi(`y_0 = f(x_0)`)  và viết phương trình tiếp tuyến.
  - Hai đường thẳng song song có cùng hệ số góc. Tiếp tuyến song song với đường thẳng  #mi(`y = ax + b`)  có hệ số góc  #mi(`k = a`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ nhanh: 'Tiếp điểm đâu, đạo hàm đó, nhân với (x trừ x0) cộng y0'. Nếu cho hệ số góc, giải f'(x) = k để tìm x0.
  ]
  - *Công thức cốt lõi:* Phương trình tiếp tuyến tại điểm  #mi(`M(x_0; y_0)`)  là  #mi(`y = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x + 1`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm có hoành độ  #mi(`x_0 = 2`) . Tính hệ số góc của tiếp tuyến đó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 9]
      \ #text(fill: rgb("#334155"))[Lời giải: Tại  #mi(`x_0 = 2`) , ta có  #mi(`y_0 = 2^3 - 3 \cdot 2 + 1 = 3`) . Đạo hàm  #mi(`y' = 3x^2 - 3`) . Hệ số góc của tiếp tuyến là  #mi(`y'(2) = 3 \cdot 2^2 - 3 = 9`) . Phương trình tiếp tuyến:  #mi(`y = 9(x - 2) + 3 = 9x - 15`) . Hệ số góc là  #mi(`9`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  biết tiếp tuyến có hệ số góc  #mi(`k = -3`) . Tìm tung độ gốc của tiếp tuyến.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`y' = 3x^2 - 6x`) . Giải  #mi(`y'(x_0) = -3 \Leftrightarrow 3x_0^2 - 6x_0 = -3 \Leftrightarrow x_0^2 - 2x_0 + 1 = 0 \Leftrightarrow x_0 = 1`) . Khi đó  #mi(`y_0 = 1^3 - 3 \cdot 1^2 + 2 = 0`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 1) + 0 = -3x + 3`) . Tung độ gốc là  #mi(`3`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Viết phương trình tiếp tuyến tại điểm thuộc đồ thị:] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm  #mi(`M(1; 0)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = 3x^2 - 6x`) . Hệ số góc của tiếp tuyến tại  #mi(`x_0 = 1`)  là  #mi(`y'(1) = 3 \cdot 1^2 - 6 \cdot 1 = -3`) . Phương trình tiếp tuyến tại  #mi(`M(1; 0)`)  là:  #mi(`y = -3(x - 1) + 0 \Leftrightarrow y = -3x + 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Viết phương trình tiếp tuyến tại điểm có hoành độ cho trước:] Cho hàm số  #mi(`y = \frac{2x + 1}{x - 1}`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm có hoành độ  #mi(`x_0 = 2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tại  #mi(`x_0 = 2`) , ta có  #mi(`y_0 = \frac{2 \cdot 2 + 1}{2 - 1} = 5`) . Đạo hàm  #mi(`y' = \frac{2(x - 1) - (2x + 1)}{(x - 1)^2} = \frac{-3}{(x - 1)^2}`) . Hệ số góc  #mi(`y'(2) = \frac{-3}{(2 - 1)^2} = -3`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 2) + 5 \Leftrightarrow y = -3x + 11`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Viết phương trình tiếp tuyến khi biết hệ số góc:] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  biết tiếp tuyến có hệ số góc  #mi(`k = 9`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`y' = 3x^2 - 6x`) . Gọi  #mi(`x_0`)  là hoành độ tiếp điểm. Giải  #mi(`y'(x_0) = 9 \Leftrightarrow 3x_0^2 - 6x_0 = 9 \Leftrightarrow x_0^2 - 2x_0 - 3 = 0 \Leftrightarrow x_0 = 3`)  hoặc  #mi(`x_0 = -1`) .
- Với  #mi(`x_0 = 3`) ,  #mi(`y_0 = 3^3 - 3 \cdot 3^2 + 2 = 2`) . Phương trình tiếp tuyến:  #mi(`y = 9(x - 3) + 2 = 9x - 25`) .
- Với  #mi(`x_0 = -1`) ,  #mi(`y_0 = (-1)^3 - 3(-1)^2 + 2 = -2`) . Phương trình tiếp tuyến:  #mi(`y = 9(x + 1) - 2 = 9x + 7`) .\nVậy có hai tiếp tuyến:  #mi(`y = 9x - 25`)  và  #mi(`y = 9x + 7`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Viết phương trình tiếp tuyến song song với đường thẳng cho trước:] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  biết tiếp tuyến song song với đường thẳng  #mi(`d: y = -3x + 1`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tiếp tuyến song song với  #mi(`d`)  nên có hệ số góc  #mi(`k = -3`) . Ta có  #mi(`y' = 3x^2 - 6x`) . Giải  #mi(`y'(x_0) = -3 \Leftrightarrow 3x_0^2 - 6x_0 = -3 \Leftrightarrow x_0^2 - 2x_0 + 1 = 0 \Leftrightarrow x_0 = 1`) . Khi đó  #mi(`y_0 = 1^3 - 3 \cdot 1^2 + 2 = 0`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 1) + 0 = -3x + 3`) . (Tiếp tuyến này song song với  #mi(`d`)  vì có cùng hệ số góc và khác tung độ gốc).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = x^3 - 3x + 1`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm  #mi(`M(2; 3)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 - 3`) . Hệ số góc của tiếp tuyến tại  #mi(`x_0 = 2`)  là  #mi(`y'(2) = 3 \cdot 2^2 - 3 = 9`) . Phương trình tiếp tuyến tại  #mi(`M(2; 3)`)  là:  #mi(`y = 9(x - 2) + 3 \Leftrightarrow y = 9x - 15`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = x^3 - 3x + 1`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm có hoành độ  #mi(`x_0 = 1`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x_0 = 1`) , ta có  #mi(`y_0 = 1^3 - 3 \cdot 1 + 1 = -1`) . Đạo hàm  #mi(`y' = 3x^2 - 3`) . Hệ số góc  #mi(`y'(1) = 3 \cdot 1^2 - 3 = 0`) . Phương trình tiếp tuyến:  #mi(`y = 0(x - 1) - 1 \Leftrightarrow y = -1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = \frac{x + 1}{x - 1}`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  tại điểm có hoành độ  #mi(`x_0 = 2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tại  #mi(`x_0 = 2`) , ta có  #mi(`y_0 = \frac{2 + 1}{2 - 1} = 3`) . Đạo hàm  #mi(`y' = \frac{1(x - 1) - (x + 1)}{(x - 1)^2} = \frac{-2}{(x - 1)^2}`) . Hệ số góc  #mi(`y'(2) = \frac{-2}{(2 - 1)^2} = -2`) . Phương trình tiếp tuyến:  #mi(`y = -2(x - 2) + 3 \Leftrightarrow y = -2x + 7`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^3 - 3x + 1`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  biết tiếp tuyến có hệ số góc  #mi(`k = 9`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = 3x^2 - 3`) . Gọi  #mi(`x_0`)  là hoành độ tiếp điểm. Giải  #mi(`y'(x_0) = 9 \Leftrightarrow 3x_0^2 - 3 = 9 \Leftrightarrow x_0^2 = 4 \Leftrightarrow x_0 = 2`)  hoặc  #mi(`x_0 = -2`) .
- Với  #mi(`x_0 = 2`) ,  #mi(`y_0 = 2^3 - 3 \cdot 2 + 1 = 3`) . Phương trình tiếp tuyến:  #mi(`y = 9(x - 2) + 3 = 9x - 15`) .
- Với  #mi(`x_0 = -2`) ,  #mi(`y_0 = (-2)^3 - 3(-2) + 1 = -1`) . Phương trình tiếp tuyến:  #mi(`y = 9(x + 2) - 1 = 9x + 17`) .\nVậy có hai tiếp tuyến:  #mi(`y = 9x - 15`)  và  #mi(`y = 9x + 17`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho hàm số  #mi(`y = x^3 - 3x + 1`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  biết tiếp tuyến song song với đường thẳng  #mi(`d: y = 9x + 2024`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tiếp tuyến song song với  #mi(`d`)  nên có hệ số góc  #mi(`k = 9`) . Ta có  #mi(`y' = 3x^2 - 3`) . Giải  #mi(`y'(x_0) = 9 \Leftrightarrow 3x_0^2 - 3 = 9 \Leftrightarrow x_0^2 = 4 \Leftrightarrow x_0 = 2`)  hoặc  #mi(`x_0 = -2`) .
- Với  #mi(`x_0 = 2`) ,  #mi(`y_0 = 3`) . Phương trình tiếp tuyến:  #mi(`y = 9(x - 2) + 3 = 9x - 15`)  (thỏa mãn song song vì  #mi(`-15 \neq 2024`) ).
- Với  #mi(`x_0 = -2`) ,  #mi(`y_0 = -1`) . Phương trình tiếp tuyến:  #mi(`y = 9(x + 2) - 1 = 9x + 17`)  (thỏa mãn song song).\nVậy có hai tiếp tuyến:  #mi(`y = 9x - 15`)  và  #mi(`y = 9x + 17`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y = \frac{2x + 1}{x - 1}`)  có đồ thị  #mi(`(C)`) . Viết phương trình tiếp tuyến của  #mi(`(C)`)  biết tiếp tuyến có hệ số góc  #mi(`k = -3`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`y' = \frac{-3}{(x - 1)^2}`) . Gọi  #mi(`x_0`)  là hoành độ tiếp điểm. Giải  #mi(`y'(x_0) = -3 \Leftrightarrow \frac{-3}{(x_0 - 1)^2} = -3 \Leftrightarrow (x_0 - 1)^2 = 1 \Leftrightarrow x_0 - 1 = 1`)  hoặc  #mi(`x_0 - 1 = -1 \Leftrightarrow x_0 = 2`)  hoặc  #mi(`x_0 = 0`) .
- Với  #mi(`x_0 = 2`) ,  #mi(`y_0 = 5`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 2) + 5 = -3x + 11`) .
- Với  #mi(`x_0 = 0`) ,  #mi(`y_0 = -1`) . Phương trình tiếp tuyến:  #mi(`y = -3(x - 0) - 1 = -3x - 1`) .\nVậy có hai tiếp tuyến:  #mi(`y = -3x + 11`)  và  #mi(`y = -3x - 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Tìm tham số m để hàm số đơn điệu trên một khoảng ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Tìm tham số m để hàm số đơn điệu trên một khoảng]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hàm số  #mi(`y = f(x)`)  có đạo hàm trên  #mi(`K`) . Hàm số đồng biến trên  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) \ge 0, \forall x \in K`)  (dấu bằng xảy ra tại hữu hạn điểm). Hàm số nghịch biến trên  #mi(`K`)  khi và chỉ khi  #mi(`f'(x) \le 0, \forall x \in K`)  (dấu bằng xảy ra tại hữu hạn điểm).
  - Đối với hàm bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`) : Đồng biến trên  #mi(`\mathbb{R} \Leftrightarrow \begin{cases} a > 0 \\ \Delta' \le 0 \end{cases}`) ; Nghịch biến trên  #mi(`\mathbb{R} \Leftrightarrow \begin{cases} a < 0 \\ \Delta' \le 0 \end{cases}`) .
  - Đối với hàm phân thức  #mi(`y = \frac{ax+b}{cx+d}`) : Đồng biến trên từng khoảng xác định  #mi(`\Leftrightarrow ad - bc > 0`) ; Nghịch biến trên từng khoảng xác định  #mi(`\Leftrightarrow ad - bc < 0`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Bậc ba đơn điệu trên R: Nhớ nhanh 'Cùng dấu a, Delta' (a > 0 đồng biến, a < 0 nghịch biến,  #mi(`\Delta \le 0`) ). Phân thức: 'Tử mẫu nhân chéo' (ad - bc > 0 đồng biến, < 0 nghịch biến).
  ]
  - *Công thức cốt lõi:* Hàm số  #mi(`y = \frac{ax+b}{cx+d}`)  đồng biến trên từng khoảng xác định khi và chỉ khi  #mi(`... > 0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a = 3 > 0 \\ \Delta' = (-3)^2 - 3m \le 0 \end{cases} \Leftrightarrow 9 - 3m \le 0 \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx + 1}{x - 2}`)  đồng biến trên từng khoảng xác định của nó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -0.5]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{2\}`) . Đạo hàm  #mi(`y' = \frac{-2m - 1}{(x-2)^2}`) . Hàm số đồng biến trên từng khoảng xác định khi và chỉ khi  #mi(`y' > 0, \forall x \ne 2 \Leftrightarrow -2m - 1 > 0 \Leftrightarrow m < -\frac{1}{2}`) . Vậy  #mi(`m < -\frac{1}{2}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hàm bậc ba đồng biến trên R:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a = 3 > 0 \\ \Delta' = (-3)^2 - 3m \le 0 \end{cases} \Leftrightarrow 9 - 3m \le 0 \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hàm bậc ba nghịch biến trên R:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = -x^3 + 3x^2 - mx + 2`)  nghịch biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = -3x^2 + 6x - m`) . Hàm số nghịch biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \le 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a = -3 < 0 \\ \Delta' = 3^2 - (-3)(-m) \le 0 \end{cases} \Leftrightarrow 9 - 3m \le 0 \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hàm phân thức đồng biến trên từng khoảng xác định:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx + 1}{x - 2}`)  đồng biến trên từng khoảng xác định của nó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{2\}`) . Đạo hàm  #mi(`y' = \frac{-2m - 1}{(x-2)^2}`) . Hàm số đồng biến trên từng khoảng xác định khi và chỉ khi  #mi(`y' > 0, \forall x \ne 2 \Leftrightarrow -2m - 1 > 0 \Leftrightarrow m < -\frac{1}{2}`) . Vậy  #mi(`m < -\frac{1}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hàm phân thức nghịch biến trên từng khoảng xác định:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{x - m}{x + 1}`)  nghịch biến trên từng khoảng xác định của nó.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{-1\}`) . Đạo hàm  #mi(`y' = \frac{1 + m}{(x+1)^2}`) . Hàm số nghịch biến trên từng khoảng xác định khi và chỉ khi  #mi(`y' < 0, \forall x \ne -1 \Leftrightarrow 1 + m < 0 \Leftrightarrow m < -1`) . Vậy  #mi(`m < -1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Cô lập m tìm điều kiện đơn điệu trên khoảng:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  đồng biến trên khoảng  #mi(`(0; +\infty)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`(0; +\infty)`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x > 0 \Leftrightarrow 3x^2 - 6x + m \ge 0, \forall x > 0 \Leftrightarrow m \ge -3x^2 + 6x, \forall x > 0`) . Xét hàm số  #mi(`g(x) = -3x^2 + 6x`)  trên  #mi(`(0; +\infty)`) . Ta có  #mi(`g'(x) = -6x + 6 = 0 \Leftrightarrow x = 1`) . Bảng biến thiên cho thấy  #mi(`\max_{(0; +\infty)} g(x) = g(1) = 3`) . Do đó  #mi(`m \ge \max_{(0; +\infty)} g(x) = 3`) . Vậy  #mi(`m \ge 3`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 2`)  đồng biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số đồng biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \ge 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a = 3 > 0 \\ \Delta' = 9 - 3m \le 0 \end{cases} \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = -x^3 + 3x^2 - mx + 1`)  nghịch biến trên  #mi(`\mathbb{R}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = -3x^2 + 6x - m`) . Hàm số nghịch biến trên  #mi(`\mathbb{R}`)  khi và chỉ khi  #mi(`y' \le 0, \forall x \in \mathbb{R} \Leftrightarrow \begin{cases} a = -3 < 0 \\ \Delta' = 9 - 3m \le 0 \end{cases} \Leftrightarrow m \ge 3`) . Vậy  #mi(`m \ge 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{mx - 2}{x + 1}`)  nghịch biến trên từng khoảng xác định của nó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{-1\}`) . Đạo hàm  #mi(`y' = \frac{m + 2}{(x+1)^2}`) . Hàm số nghịch biến trên từng khoảng xác định khi và chỉ khi  #mi(`y' < 0, \forall x \ne -1 \Leftrightarrow m + 2 < 0 \Leftrightarrow m < -2`) . Vậy  #mi(`m < -2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  nghịch biến trên khoảng  #mi(`(-\infty; 0)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Đạo hàm  #mi(`y' = 3x^2 - 6x + m`) . Hàm số nghịch biến trên  #mi(`(-\infty; 0)`)  khi và chỉ khi  #mi(`y' \le 0, \forall x < 0 \Leftrightarrow 3x^2 - 6x + m \le 0, \forall x < 0 \Leftrightarrow m \le -3x^2 + 6x, \forall x < 0`) . Xét  #mi(`g(x) = -3x^2 + 6x`)  trên  #mi(`(-\infty; 0)`) . Ta có  #mi(`g'(x) = -6x + 6 > 0, \forall x < 0`)  nên  #mi(`g(x)`)  đồng biến trên  #mi(`(-\infty; 0)`) . Do đó  #mi(`\min_{(-\infty; 0)} g(x) = \lim_{x \to -\infty} g(x) = -\infty`) . Vậy không tồn tại  #mi(`m`)  thỏa mãn.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = \frac{x - m}{x + 2}`)  đồng biến trên từng khoảng xác định của nó.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{-2\}`) . Đạo hàm  #mi(`y' = \frac{2 + m}{(x+2)^2}`) . Hàm số đồng biến trên từng khoảng xác định khi và chỉ khi  #mi(`y' > 0, \forall x \ne -2 \Leftrightarrow 2 + m > 0 \Leftrightarrow m > -2`) . Vậy  #mi(`m > -2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 11: Tìm tham số m để hàm số có cực trị thỏa mãn điều kiện ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 11. Tìm tham số m để hàm số có cực trị thỏa mãn điều kiện]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số  #mi(`y = ax^3 + bx^2 + cx + d`)  có 2 điểm cực trị khi và chỉ khi phương trình  #mi(`y' = 0`)  có 2 nghiệm phân biệt (hay  #mi(`\Delta_{y'} > 0`) ).
  - Hàm số  #mi(`y = ax^4 + bx^2 + c`)  có 3 điểm cực trị khi và chỉ khi phương trình  #mi(`y' = 0`)  có 3 nghiệm phân biệt (hay  #mi(`a.b < 0`) ).
  - Khi hàm số có 2 điểm cực trị  #mi(`x_1, x_2`) , ta có thể dùng định lý Vi-ét cho phương trình  #mi(`y' = 0`)  để giải các điều kiện liên quan đến  #mi(`x_1, x_2`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Bậc 3 có cực trị:  #mi(`\Delta_{y'} > 0`) . Trùng phương có 3 cực trị:  #mi(`a.b < 0`) . Nhớ nhanh: 'Bậc 3 hai nghiệm, trùng phương ba nghiệm'.
  ]
  - *Công thức cốt lõi:* Để hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  có hai điểm cực trị, điều kiện là phương trình  #mi(`y' = 0`)  có ... nghiệm phân biệt.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  có hai điểm cực trị.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: m < 3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có hai nghiệm phân biệt. Điều kiện là  #mi(`\Delta' = (-3)^2 - 3m > 0 \Leftrightarrow 9 - 3m > 0 \Leftrightarrow m < 3`) . Vậy  #mi(`m < 3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^4 - 2(m+1)x^2 + m^2`)  có ba điểm cực trị.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: m > -1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 4x^3 - 4(m+1)x = 4x(x^2 - (m+1))`) . Phương trình  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x^2 = m+1`) . Để hàm số có ba điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có ba nghiệm phân biệt, tức là  #mi(`m+1 > 0 \Leftrightarrow m > -1`) . Vậy  #mi(`m > -1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm m để hàm số có cực trị:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 1`)  có hai điểm cực trị.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có hai nghiệm phân biệt. Điều kiện là  #mi(`\Delta' = (-3)^2 - 3m > 0 \Leftrightarrow 9 - 3m > 0 \Leftrightarrow m < 3`) . Vậy  #mi(`m < 3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm m để hàm số có cực trị thỏa mãn điều kiện về tọa độ điểm cực trị:] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2-1)x + 1`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 10`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2-1)`) . Phương trình  #mi(`y' = 0`)  có  #mi(`\Delta' = 9m^2 - 9(m^2-1) = 9 > 0`)  với mọi  #mi(`m`) , nên hàm số luôn có hai điểm cực trị  #mi(`x_1, x_2`) . Theo định lý Vi-ét, ta có  #mi(`x_1 + x_2 = 2m`)  và  #mi(`x_1x_2 = m^2 - 1`) . Theo đề bài:  #mi(`x_1^2 + x_2^2 = 10 \Leftrightarrow (x_1+x_2)^2 - 2x_1x_2 = 10 \Leftrightarrow (2m)^2 - 2(m^2-1) = 10 \Leftrightarrow 4m^2 - 2m^2 + 2 = 10 \Leftrightarrow 2m^2 = 8 \Leftrightarrow m^2 = 4 \Leftrightarrow m = \pm 2`) . Vậy  #mi(`m = \pm 2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm m để hàm trùng phương có 3 cực trị:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^4 - 2(m+1)x^2 + m^2`)  có ba điểm cực trị.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 4x^3 - 4(m+1)x = 4x(x^2 - (m+1))`) . Phương trình  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x^2 = m+1`) . Để hàm số có ba điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có ba nghiệm phân biệt, tức là  #mi(`m+1 > 0 \Leftrightarrow m > -1`) . Vậy  #mi(`m > -1`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm m để phương trình f(x) = m có số nghiệm cho trước:] Cho hàm số  #mi(`y = x^3 - 3x^2 + m`) . Tìm  #mi(`m`)  để phương trình  #mi(`x^3 - 3x^2 + m = 0`)  có ba nghiệm phân biệt.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét hàm số  #mi(`y = x^3 - 3x^2 + m`) . Ta có  #mi(`y' = 3x^2 - 6x = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Giá trị cực đại  #mi(`y_{CĐ} = y(0) = m`) , giá trị cực tiểu  #mi(`y_{CT} = y(2) = m - 4`) . Để phương trình có ba nghiệm phân biệt thì  #mi(`y_{CT} < 0 < y_{CĐ} \Leftrightarrow m - 4 < 0 < m \Leftrightarrow 0 < m < 4`) . Vậy  #mi(`0 < m < 4`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx + 2`)  có hai điểm cực trị.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có hai nghiệm phân biệt. Điều kiện là  #mi(`\Delta' = (-3)^2 - 3m > 0 \Leftrightarrow 9 - 3m > 0 \Leftrightarrow m < 3`) . Vậy  #mi(`m < 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^3 - 3x^2 + mx - 1`)  có hai điểm cực trị.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x + m`) . Để hàm số có hai điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có hai nghiệm phân biệt. Điều kiện là  #mi(`\Delta' = (-3)^2 - 3m > 0 \Leftrightarrow 9 - 3m > 0 \Leftrightarrow m < 3`) . Vậy  #mi(`m < 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2-1)x + 2`) . Tìm  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`x_1, x_2`)  thỏa mãn  #mi(`x_1^2 + x_2^2 = 10`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2-1)`) . Phương trình  #mi(`y' = 0`)  có  #mi(`\Delta' = 9m^2 - 9(m^2-1) = 9 > 0`)  với mọi  #mi(`m`) , nên hàm số luôn có hai điểm cực trị  #mi(`x_1, x_2`) . Theo định lý Vi-ét, ta có  #mi(`x_1 + x_2 = 2m`)  và  #mi(`x_1x_2 = m^2 - 1`) . Theo đề bài:  #mi(`x_1^2 + x_2^2 = 10 \Leftrightarrow (x_1+x_2)^2 - 2x_1x_2 = 10 \Leftrightarrow (2m)^2 - 2(m^2-1) = 10 \Leftrightarrow 4m^2 - 2m^2 + 2 = 10 \Leftrightarrow 2m^2 = 8 \Leftrightarrow m^2 = 4 \Leftrightarrow m = \pm 2`) . Vậy  #mi(`m = \pm 2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số  #mi(`y = x^4 - 2(m-1)x^2 + m^2`)  có ba điểm cực trị.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 4x^3 - 4(m-1)x = 4x(x^2 - (m-1))`) . Phương trình  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x^2 = m-1`) . Để hàm số có ba điểm cực trị thì phương trình  #mi(`y' = 0`)  phải có ba nghiệm phân biệt, tức là  #mi(`m-1 > 0 \Leftrightarrow m > 1`) . Vậy  #mi(`m > 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + m`) . Tìm  #mi(`m`)  để phương trình  #mi(`x^3 - 3x^2 + m = 0`)  có ba nghiệm phân biệt.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hàm số  #mi(`y = x^3 - 3x^2 + m`) . Ta có  #mi(`y' = 3x^2 - 6x = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) . Giá trị cực đại  #mi(`y_{CĐ} = y(0) = m`) , giá trị cực tiểu  #mi(`y_{CT} = y(2) = m - 4`) . Để phương trình có ba nghiệm phân biệt thì  #mi(`y_{CT} < 0 < y_{CĐ} \Leftrightarrow m - 4 < 0 < m \Leftrightarrow 0 < m < 4`) . Vậy  #mi(`0 < m < 4`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 12: Tính giá trị biểu thức liên quan đến cực trị ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 12. Tính giá trị biểu thức liên quan đến cực trị]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điểm cực trị của hàm số  #mi(`y=f(x)`)  là điểm  #mi(`M(x_0; y_0)`)  trong đó  #mi(`x_0`)  là nghiệm của phương trình  #mi(`f'(x)=0`)  (và  #mi(`f'(x)`)  đổi dấu qua  #mi(`x_0`) ),  #mi(`y_0 = f(x_0)`) .
  - Đối với hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`) , nếu có hai điểm cực trị  #mi(`A(x_1; y_1)`)  và  #mi(`B(x_2; y_2)`)  thì  #mi(`x_1, x_2`)  là hai nghiệm của phương trình  #mi(`y'=0`) . Khi đó, theo định lý Vi-ét:  #mi(`x_1 + x_2 = -\frac{2b}{3a}`)  và  #mi(`x_1 x_2 = \frac{c}{3a}`) .
  - Đối với hàm phân thức  #mi(`y = \frac{ax^2+bx+c}{dx+e}`) , nếu có hai điểm cực trị thì phương trình  #mi(`y'=0`)  có hai nghiệm phân biệt  #mi(`x_1, x_2`) . Đường thẳng đi qua hai điểm cực trị có phương trình  #mi(`y = \frac{2ax+b}{d}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nắm chắc Vi-ét cho phương trình  #mi(`y'=0`)  để tính tổng, tích các hoành độ cực trị. Với hàm bậc ba, đường thẳng nối hai điểm cực trị có phương trình  #mi(`y = \frac{2}{3}\left(c - \frac{b^2}{3a}\right)x + d - \frac{bc}{9a}`) . Với hàm phân thức, đường thẳng nối hai điểm cực trị là  #mi(`y = \frac{2ax+b}{d}`) .
  ]
  - *Công thức cốt lõi:* Cho hàm số bậc ba  #mi(`y = ax^3 + bx^2 + cx + d`)  có hai điểm cực trị  #mi(`x_1, x_2`) . Theo định lý Vi-ét, ta có  #mi(`x_1 + x_2 = ...`)  và  #mi(`x_1 x_2 = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có hai điểm cực trị  #mi(`A`)  và  #mi(`B`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{5}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) .  #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nVới  #mi(`x = 0 \Rightarrow y = 2`) , ta có điểm cực đại  #mi(`A(0; 2)`) .\nVới  #mi(`x = 2 \Rightarrow y = -2`) , ta có điểm cực tiểu  #mi(`B(2; -2)`) .\nĐộ dài đoạn thẳng  #mi(`AB = \sqrt{(2 - 0)^2 + (-2 - 2)^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hàm số  #mi(`y = \frac{x^2 + x + 1}{x + 1}`)  có hai điểm cực trị  #mi(`A`)  và  #mi(`B`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`2\sqrt{5}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{-1\}`) . Ta có  #mi(`y' = \frac{(2x+1)(x+1) - (x^2+x+1)}{(x+1)^2} = \frac{x^2+2x}{(x+1)^2}`) .\n #mi(`y' = 0 \Leftrightarrow x^2 + 2x = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = -2`) .\nVới  #mi(`x = 0 \Rightarrow y = 1`) , ta có điểm  #mi(`A(0; 1)`) .\nVới  #mi(`x = -2 \Rightarrow y = -3`) , ta có điểm  #mi(`B(-2; -3)`) .\nĐộ dài đoạn thẳng  #mi(`AB = \sqrt{(-2 - 0)^2 + (-3 - 1)^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x + 1`) . Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`A, B`)  thỏa mãn tổng tung độ của chúng bằng  #mi(`2`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`1; -\frac{1}{2}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) .\n #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0`) . Ta có  #mi(`\Delta' = m^2 - (m^2 - 1) = 1 > 0`)  nên phương trình luôn có hai nghiệm phân biệt  #mi(`x_1 = m - 1`)  và  #mi(`x_2 = m + 1`) .\nDo đó hàm số luôn có hai điểm cực trị.\nTung độ của các điểm cực trị là  #mi(`y_1 = y(m-1) = -2m^3 + 3m^2 + 3m - 1`)  và  #mi(`y_2 = y(m+1) = -2m^3 + 3m^2 + 3m + 1`) .\nTheo giả thiết, tổng tung độ bằng  #mi(`2`) :  #mi(`y_1 + y_2 = 2 \Leftrightarrow -4m^3 + 6m^2 + 6m = 2 \Leftrightarrow 2m^3 - 3m^2 - 3m + 1 = 0`) .\n #mi(`\Leftrightarrow (m - 1)(2m^2 - m - 1) = 0 \Leftrightarrow (m - 1)^2(2m + 1) = 0 \Leftrightarrow m = 1`)  hoặc  #mi(`m = -\frac{1}{2}`) .\nVậy có hai giá trị  #mi(`m`)  thỏa mãn là  #mi(`m = 1`)  và  #mi(`m = -\frac{1}{2}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính độ dài đoạn thẳng nối hai điểm cực trị của hàm bậc ba:] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A`)  và  #mi(`B`)  là hai điểm cực trị của  #mi(`(C)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) .\n #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nVới  #mi(`x = 0 \Rightarrow y = 2`) , ta có điểm cực đại  #mi(`A(0; 2)`) .\nVới  #mi(`x = 2 \Rightarrow y = -2`) , ta có điểm cực tiểu  #mi(`B(2; -2)`) .\nĐộ dài đoạn thẳng  #mi(`AB = \sqrt{(2 - 0)^2 + (-2 - 2)^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính độ dài đoạn thẳng nối hai điểm cực trị của hàm phân thức:] Cho hàm số  #mi(`y = \frac{x^2 + x + 1}{x + 1}`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A`)  và  #mi(`B`)  là hai điểm cực trị của  #mi(`(C)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{-1\}`) . Ta có  #mi(`y' = \frac{(2x+1)(x+1) - (x^2+x+1)}{(x+1)^2} = \frac{x^2+2x}{(x+1)^2}`) .\n #mi(`y' = 0 \Leftrightarrow x^2 + 2x = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = -2`) .\nVới  #mi(`x = 0 \Rightarrow y = 1`) , ta có điểm  #mi(`A(0; 1)`) .\nVới  #mi(`x = -2 \Rightarrow y = -3`) , ta có điểm  #mi(`B(-2; -3)`) .\nĐộ dài đoạn thẳng  #mi(`AB = \sqrt{(-2 - 0)^2 + (-3 - 1)^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tham số từ điều kiện về tổng tung độ các điểm cực trị:] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x + 1`) . Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`A, B`)  thỏa mãn tổng tung độ của chúng bằng  #mi(`2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) .\n #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0`) . Ta có  #mi(`\Delta' = m^2 - (m^2 - 1) = 1 > 0`)  nên phương trình luôn có hai nghiệm phân biệt  #mi(`x_1 = m - 1`)  và  #mi(`x_2 = m + 1`) .\nDo đó hàm số luôn có hai điểm cực trị.\nTung độ của các điểm cực trị là  #mi(`y_1 = y(m-1) = -2m^3 + 3m^2 + 3m - 1`)  và  #mi(`y_2 = y(m+1) = -2m^3 + 3m^2 + 3m + 1`) .\nTheo giả thiết, tổng tung độ bằng  #mi(`2`) :  #mi(`y_1 + y_2 = 2 \Leftrightarrow -4m^3 + 6m^2 + 6m = 2 \Leftrightarrow 2m^3 - 3m^2 - 3m + 1 = 0`) .\n #mi(`\Leftrightarrow (m - 1)(2m^2 - m - 1) = 0 \Leftrightarrow (m - 1)^2(2m + 1) = 0 \Leftrightarrow m = 1`)  hoặc  #mi(`m = -\frac{1}{2}`) .\nVậy có hai giá trị  #mi(`m`)  thỏa mãn là  #mi(`m = 1`)  và  #mi(`m = -\frac{1}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính diện tích tam giác tạo bởi đường thẳng nối hai điểm cực trị và các trục tọa độ:] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A, B`)  là hai điểm cực trị của  #mi(`(C)`) . Đường thẳng  #mi(`AB`)  cắt trục tung tại  #mi(`M`)  và trục hoành tại  #mi(`N`) . Tính diện tích tam giác  #mi(`OMN`)  với  #mi(`O`)  là gốc tọa độ.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ Ví dụ 1, ta có  #mi(`A(0; 2)`)  và  #mi(`B(2; -2)`) .\nPhương trình đường thẳng  #mi(`AB`) :  #mi(`\frac{x - 0}{2 - 0} = \frac{y - 2}{-2 - 2} \Leftrightarrow \frac{x}{2} = \frac{y - 2}{-4} \Leftrightarrow -2x = y - 2 \Leftrightarrow y = -2x + 2`) .\nĐường thẳng  #mi(`AB`)  cắt trục tung tại  #mi(`M(0; 2)`)  và cắt trục hoành tại  #mi(`N(1; 0)`) .\nTam giác  #mi(`OMN`)  vuông tại  #mi(`O`)  có  #mi(`OM = 2`)  và  #mi(`ON = 1`) .\nDiện tích tam giác  #mi(`OMN`)  là  #mi(`S = \frac{1}{2} \cdot OM \cdot ON = \frac{1}{2} \cdot 2 \cdot 1 = 1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hàm số  #mi(`y = x^3 - 3x + 2`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A`)  và  #mi(`B`)  là hai điểm cực trị của  #mi(`(C)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 3 = 3(x^2 - 1)`) .\n #mi(`y' = 0 \Leftrightarrow x = 1`)  hoặc  #mi(`x = -1`) .\nVới  #mi(`x = 1 \Rightarrow y = 0`) , ta có điểm cực tiểu  #mi(`A(1; 0)`) .\nVới  #mi(`x = -1 \Rightarrow y = 4`) , ta có điểm cực đại  #mi(`B(-1; 4)`) .\nĐộ dài đoạn thẳng  #mi(`AB = \sqrt{(-1 - 1)^2 + (4 - 0)^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hàm số  #mi(`y = \frac{x^2 - x + 1}{x - 1}`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A`)  và  #mi(`B`)  là hai điểm cực trị của  #mi(`(C)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{1\}`) . Ta có  #mi(`y' = \frac{(2x-1)(x-1) - (x^2-x+1)}{(x-1)^2} = \frac{x^2-2x}{(x-1)^2}`) .\n #mi(`y' = 0 \Leftrightarrow x^2 - 2x = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nVới  #mi(`x = 0 \Rightarrow y = -1`) , ta có điểm  #mi(`A(0; -1)`) .\nVới  #mi(`x = 2 \Rightarrow y = 3`) , ta có điểm  #mi(`B(2; 3)`) .\nĐộ dài đoạn thẳng  #mi(`AB = \sqrt{(2 - 0)^2 + (3 - (-1))^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hàm số  #mi(`y = x^3 - 3mx^2 + 3(m^2 - 1)x + 1`) . Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để hàm số có hai điểm cực trị  #mi(`A, B`)  thỏa mãn tổng tung độ của chúng bằng  #mi(`-2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6mx + 3(m^2 - 1)`) .\n #mi(`y' = 0 \Leftrightarrow x^2 - 2mx + m^2 - 1 = 0`) . Ta có  #mi(`\Delta' = 1 > 0`)  nên phương trình luôn có hai nghiệm phân biệt  #mi(`x_1 = m - 1`)  và  #mi(`x_2 = m + 1`) .\nDo đó hàm số luôn có hai điểm cực trị.\nTung độ của các điểm cực trị là  #mi(`y_1 = y(m-1) = -2m^3 + 3m^2 + 3m - 1`)  và  #mi(`y_2 = y(m+1) = -2m^3 + 3m^2 + 3m + 1`) .\nTheo giả thiết, tổng tung độ bằng  #mi(`-2`) :  #mi(`y_1 + y_2 = -2 \Leftrightarrow -4m^3 + 6m^2 + 6m = -2 \Leftrightarrow 2m^3 - 3m^2 - 3m - 1 = 0`) .\n #mi(`\Leftrightarrow (m + 1)(2m^2 - 5m - 1) = 0 \Leftrightarrow m = -1`)  hoặc  #mi(`m = \frac{5 \pm \sqrt{33}}{4}`) .\nVậy có ba giá trị  #mi(`m`)  thỏa mãn.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A, B`)  là hai điểm cực trị của  #mi(`(C)`) . Đường thẳng  #mi(`AB`)  cắt trục tung tại  #mi(`M`)  và trục hoành tại  #mi(`N`) . Tính diện tích tam giác  #mi(`OMN`)  với  #mi(`O`)  là gốc tọa độ.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) .\n #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nTọa độ các điểm cực trị là  #mi(`A(0; 2)`)  và  #mi(`B(2; -2)`) .\nPhương trình đường thẳng  #mi(`AB`) :  #mi(`\frac{x - 0}{2 - 0} = \frac{y - 2}{-2 - 2} \Leftrightarrow y = -2x + 2`) .\nĐường thẳng  #mi(`AB`)  cắt trục tung tại  #mi(`M(0; 2)`)  và cắt trục hoành tại  #mi(`N(1; 0)`) .\nTam giác  #mi(`OMN`)  vuông tại  #mi(`O`)  có  #mi(`OM = 2`)  và  #mi(`ON = 1`) .\nDiện tích tam giác  #mi(`OMN`)  là  #mi(`S = \frac{1}{2} \cdot OM \cdot ON = \frac{1}{2} \cdot 2 \cdot 1 = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A, B`)  là hai điểm cực trị của  #mi(`(C)`) . Tìm tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) .\n #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nTọa độ các điểm cực trị là  #mi(`A(0; 2)`)  và  #mi(`B(2; -2)`) .\nGọi  #mi(`I`)  là trung điểm của  #mi(`AB`) , ta có  #mi(`x_I = \frac{0 + 2}{2} = 1`)  và  #mi(`y_I = \frac{2 + (-2)}{2} = 0`) .\nVậy  #mi(`I(1; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Cho hàm số  #mi(`y = x^3 - 3x^2 + 2`)  có đồ thị  #mi(`(C)`) . Gọi  #mi(`A, B`)  là hai điểm cực trị của  #mi(`(C)`) . Tính khoảng cách từ gốc tọa độ  #mi(`O`)  đến đường thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R}`) . Ta có  #mi(`y' = 3x^2 - 6x = 3x(x - 2)`) .\n #mi(`y' = 0 \Leftrightarrow x = 0`)  hoặc  #mi(`x = 2`) .\nTọa độ các điểm cực trị là  #mi(`A(0; 2)`)  và  #mi(`B(2; -2)`) .\nPhương trình đường thẳng  #mi(`AB`) :  #mi(`\frac{x - 0}{2 - 0} = \frac{y - 2}{-2 - 2} \Leftrightarrow y = -2x + 2 \Leftrightarrow 2x + y - 2 = 0`) .\nKhoảng cách từ  #mi(`O(0; 0)`)  đến đường thẳng  #mi(`AB`)  là  #mi(`d = \frac{|2 \cdot 0 + 0 - 2|}{\sqrt{2^2 + 1^2}} = \frac{2}{\sqrt{5}} = \frac{2\sqrt{5}}{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 13: Tìm giá trị của tham số để hàm số có tiệm cận ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 13. Tìm giá trị của tham số để hàm số có tiệm cận]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm số  #mi(`y = \frac{P(x)}{Q(x)}`)  có tiệm cận đứng  #mi(`x = x_0`)  nếu  #mi(`x_0`)  là nghiệm của mẫu  #mi(`Q(x)=0`)  nhưng không là nghiệm của tử  #mi(`P(x)=0`)  (hoặc là nghiệm bội cao hơn của mẫu).
  - Để đồ thị hàm số có đúng 2 tiệm cận đứng, phương trình mẫu  #mi(`Q(x)=0`)  phải có đúng 2 nghiệm phân biệt và cả 2 nghiệm này đều không là nghiệm của tử  #mi(`P(x)=0`) .
  - Với mẫu là tam thức bậc hai  #mi(`ax^2+bx+c=0`)  ( #mi(`a \neq 0`) ), điều kiện có 2 nghiệm phân biệt là  #mi(`\Delta > 0`)  (hoặc  #mi(`\Delta' > 0`) ).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẫu có 2 nghiệm phân biệt (Delta > 0) và tử KHÔNG triệt tiêu tại 2 nghiệm đó (thay nghiệm mẫu vào tử, tử khác 0).
  ]
  - *Công thức cốt lõi:* Để hàm số  #mi(`y = \frac{P(x)}{Q(x)}`)  có 2 tiệm cận đứng, phương trình  #mi(`Q(x)=0`)  phải có ... nghiệm phân biệt và không có nghiệm nào là nghiệm của phương trình  #mi(`P(x)=0`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x+1}{x^2 - 2x + m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: m < 1 và m != -3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 2x + m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - 2x + m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq -1`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`\Delta' = 1 - m > 0 \Leftrightarrow m < 1`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = -1`)  vào mẫu ta được  #mi(`(-1)^2 - 2(-1) + m \neq 0 \Leftrightarrow 3 + m \neq 0 \Leftrightarrow m \neq -3`) .\nVậy  #mi(`m < 1`)  và  #mi(`m \neq -3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x-2}{x^2 - m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: m > 0 và m != 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq 2`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`m > 0`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = 2`)  vào mẫu ta được  #mi(`2^2 - m \neq 0 \Leftrightarrow m \neq 4`) .\nVậy  #mi(`m > 0`)  và  #mi(`m \neq 4`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x^2 - 1}{x^2 - 2mx + m^2 - 1}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: m != 0, m != 2, m != -2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 2mx + m^2 - 1 = 0\}`) .\nPhương trình mẫu có  #mi(`\Delta' = m^2 - (m^2 - 1) = 1 > 0`)  nên luôn có 2 nghiệm phân biệt  #mi(`x_1 = m+1, x_2 = m-1`) .
Để đồ thị có đúng 2 tiệm cận đứng thì nghiệm của mẫu không được trùng với nghiệm của tử (tử có nghiệm  #mi(`x = 1, x = -1`) ).\nTa có hệ điều kiện:
 #mi(`\begin{cases} m+1 \neq 1 \\ m+1 \neq -1 \\ m-1 \neq 1 \\ m-1 \neq -1 \end{cases} \Leftrightarrow \begin{cases} m \neq 0 \\ m \neq -2 \\ m \neq 2 \\ m \neq 0 \end{cases}`) \nVậy  #mi(`m \neq 0, m \neq 2, m \neq -2`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng công thức cơ bản tìm m để có 2 tiệm cận đứng:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x+1}{x^2 - 2x + m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 2x + m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - 2x + m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq -1`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`\Delta' = 1 - m > 0 \Leftrightarrow m < 1`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = -1`)  vào mẫu ta được  #mi(`(-1)^2 - 2(-1) + m \neq 0 \Leftrightarrow 3 + m \neq 0 \Leftrightarrow m \neq -3`) .\nVậy  #mi(`m < 1`)  và  #mi(`m \neq -3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Biến thể mẫu thiếu hệ số bậc nhất:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x-2}{x^2 - m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq 2`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`m > 0`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = 2`)  vào mẫu ta được  #mi(`2^2 - m \neq 0 \Leftrightarrow m \neq 4`) .\nVậy  #mi(`m > 0`)  và  #mi(`m \neq 4`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tử thức là bậc hai:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x^2 - 1}{x^2 - 2mx + m^2 - 1}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 2mx + m^2 - 1 = 0\}`) .\nPhương trình mẫu có  #mi(`\Delta' = m^2 - (m^2 - 1) = 1 > 0`)  nên luôn có 2 nghiệm phân biệt  #mi(`x_1 = m+1, x_2 = m-1`) .
Để đồ thị có đúng 2 tiệm cận đứng thì nghiệm của mẫu không được trùng với nghiệm của tử (tử có nghiệm  #mi(`x = 1, x = -1`) ).\nTa có hệ điều kiện:
 #mi(`\begin{cases} m+1 \neq 1 \\ m+1 \neq -1 \\ m-1 \neq 1 \\ m-1 \neq -1 \end{cases} \Leftrightarrow \begin{cases} m \neq 0 \\ m \neq -2 \\ m \neq 2 \\ m \neq 0 \end{cases}`) \nVậy  #mi(`m \neq 0, m \neq 2, m \neq -2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Mẫu thức có tham số ở hệ số bậc hai:] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x+2}{mx^2 - 2x + 1}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để hàm số có 2 tiệm cận đứng thì mẫu thức  #mi(`mx^2 - 2x + 1 = 0`)  phải có 2 nghiệm phân biệt và khác  #mi(`-2`) .\nTrường hợp  #mi(`m = 0`) : mẫu là  #mi(`-2x + 1 = 0`)  có 1 nghiệm, không thỏa mãn.\nTrường hợp  #mi(`m \neq 0`) : Điều kiện có 2 nghiệm phân biệt là  #mi(`\Delta' = 1 - m > 0 \Leftrightarrow m < 1`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = -2`)  vào mẫu ta được  #mi(`m(-2)^2 - 2(-2) + 1 \neq 0 \Leftrightarrow 4m + 5 \neq 0 \Leftrightarrow m \neq -\frac{5}{4}`) .\nKết hợp lại ta được  #mi(`m < 1, m \neq 0, m \neq -\frac{5}{4}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x-1}{x^2 - 4x + m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 4x + m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - 4x + m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq 1`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`\Delta' = 4 - m > 0 \Leftrightarrow m < 4`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = 1`)  vào mẫu ta được  #mi(`1^2 - 4(1) + m \neq 0 \Leftrightarrow m - 3 \neq 0 \Leftrightarrow m \neq 3`) .\nVậy  #mi(`m < 4`)  và  #mi(`m \neq 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x+3}{x^2 - 2x + m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 2x + m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - 2x + m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq -3`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`\Delta' = 1 - m > 0 \Leftrightarrow m < 1`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = -3`)  vào mẫu ta được  #mi(`(-3)^2 - 2(-3) + m \neq 0 \Leftrightarrow 15 + m \neq 0 \Leftrightarrow m \neq -15`) .\nVậy  #mi(`m < 1`)  và  #mi(`m \neq -15`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x-1}{x^2 - m}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - m = 0\}`) .
Để đồ thị có đúng 2 tiệm cận đứng thì phương trình  #mi(`x^2 - m = 0`)  phải có 2 nghiệm phân biệt  #mi(`x_1, x_2`)  và  #mi(`x_1, x_2 \neq 1`) .
Điều kiện có 2 nghiệm phân biệt:  #mi(`m > 0`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = 1`)  vào mẫu ta được  #mi(`1^2 - m \neq 0 \Leftrightarrow m \neq 1`) .\nVậy  #mi(`m > 0`)  và  #mi(`m \neq 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x^2 - 4}{x^2 - 2mx + m^2 - 9}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tập xác định  #mi(`D = \mathbb{R} \setminus \{x | x^2 - 2mx + m^2 - 9 = 0\}`) .\nPhương trình mẫu có  #mi(`\Delta' = m^2 - (m^2 - 9) = 9 > 0`)  nên luôn có 2 nghiệm phân biệt  #mi(`x_1 = m+3, x_2 = m-3`) .
Để đồ thị có đúng 2 tiệm cận đứng thì nghiệm của mẫu không được trùng với nghiệm của tử (tử có nghiệm  #mi(`x = 2, x = -2`) ).\nTa có hệ điều kiện:
 #mi(`\begin{cases} m+3 \neq 2 \\ m+3 \neq -2 \\ m-3 \neq 2 \\ m-3 \neq -2 \end{cases} \Leftrightarrow \begin{cases} m \neq -1 \\ m \neq -5 \\ m \neq 5 \\ m \neq 1 \end{cases}`) \nVậy  #mi(`m \neq \pm 1, m \neq \pm 5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Tìm tất cả các giá trị thực của tham số  #mi(`m`)  để đồ thị hàm số  #mi(`y = \frac{x+1}{mx^2 - 2x + 1}`)  có đúng hai tiệm cận đứng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để hàm số có 2 tiệm cận đứng thì mẫu thức  #mi(`mx^2 - 2x + 1 = 0`)  phải có 2 nghiệm phân biệt và khác  #mi(`-1`) .\nTrường hợp  #mi(`m = 0`) : mẫu là  #mi(`-2x + 1 = 0`)  có 1 nghiệm, không thỏa mãn.\nTrường hợp  #mi(`m \neq 0`) : Điều kiện có 2 nghiệm phân biệt là  #mi(`\Delta' = 1 - m > 0 \Leftrightarrow m < 1`) .
Điều kiện nghiệm không trùng với tử: Thay  #mi(`x = -1`)  vào mẫu ta được  #mi(`m(-1)^2 - 2(-1) + 1 \neq 0 \Leftrightarrow m + 3 \neq 0 \Leftrightarrow m \neq -3`) .\nKết hợp lại ta được  #mi(`m < 1, m \neq 0, m \neq -3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 14: Biểu diễn vectơ theo các vectơ cơ sở ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 14. Biểu diễn vectơ theo các vectơ cơ sở]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc ba điểm: Với ba điểm  #mi(`A, B, C`)  bất kỳ, ta có  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và  #mi(`\vec{AC} - \vec{AB} = \vec{BC}`) .
  - Quy tắc hình bình hành: Nếu  #mi(`ABCD`)  là hình bình hành thì  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
  - Quy tắc trung điểm: Nếu  #mi(`I`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì  #mi(`\vec{IA} + \vec{IB} = \vec{0}`)  và với mọi điểm  #mi(`M`) , ta có  #mi(`\vec{MA} + \vec{MB} = 2\vec{MI}`) .
  - Quy tắc trọng tâm: Nếu  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  thì  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  và với mọi điểm  #mi(`M`) , ta có  #mi(`\vec{MA} + \vec{MB} + \vec{MC} = 3\vec{MG}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy tắc cộng vectơ: 'Điểm cuối vectơ này trùng điểm đầu vectơ kia'. Quy tắc hình bình hành: 'Cùng gốc, tổng là đường chéo'. Quy tắc trung điểm: 'Tổng hai vectơ bằng 2 lần vectơ trung tuyến'. Quy tắc trọng tâm: 'Tổng ba vectơ bằng 3 lần vectơ trọng tuyến'.
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`I`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì với mọi điểm  #mi(`M`) , ta có  #mi(`\vec{MA} + \vec{MB} = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo ba vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AD}`) ,  #mi(`\vec{AA'}`) .
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
    *Câu 2.* Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Biểu diễn vectơ  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD}`)  theo vectơ  #mi(`\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`4\vec{SO}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của  #mi(`AC`)  và  #mi(`BD`) . Theo quy tắc trung điểm, ta có  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`)  và  #mi(`\vec{SB} + \vec{SD} = 2\vec{SO}`) . Do đó,  #mi(`\vec{SA} + \vec{SB} + \vec{SC} + \vec{SD} = 2\vec{SO} + 2\vec{SO} = 4\vec{SO}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn vectơ  #mi(`\vec{AB} + \vec{AC}`)  theo vectơ  #mi(`\vec{AG}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`3\vec{AG}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc ba điểm, ta có  #mi(`\vec{AB} = \vec{AG} + \vec{GB}`)  và  #mi(`\vec{AC} = \vec{AG} + \vec{GC}`) . Suy ra  #mi(`\vec{AB} + \vec{AC} = 2\vec{AG} + \vec{GB} + \vec{GC}`) . Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) , suy ra  #mi(`\vec{GB} + \vec{GC} = -\vec{GA} = \vec{AG}`) . Vậy  #mi(`\vec{AB} + \vec{AC} = 2\vec{AG} + \vec{AG} = 3\vec{AG}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Hãy biểu diễn vectơ  #mi(`\vec{AC'}`)  theo ba vectơ  #mi(`\vec{AB}`) ,  #mi(`\vec{AD}`) ,  #mi(`\vec{AA'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc trung điểm:] Cho đoạn thẳng  #mi(`AB`)  có trung điểm  #mi(`I`) . Với điểm  #mi(`M`)  bất kỳ, hãy biểu diễn vectơ  #mi(`\vec{MA} + \vec{MB}`)  theo vectơ  #mi(`\vec{MI}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`I`)  là trung điểm của  #mi(`AB`)  nên  #mi(`\vec{IA} + \vec{IB} = \vec{0}`) . Theo quy tắc ba điểm, ta có  #mi(`\vec{MA} = \vec{MI} + \vec{IA}`)  và  #mi(`\vec{MB} = \vec{MI} + \vec{IB}`) . Suy ra  #mi(`\vec{MA} + \vec{MB} = (\vec{MI} + \vec{IA}) + (\vec{MI} + \vec{IB}) = 2\vec{MI} + (\vec{IA} + \vec{IB}) = 2\vec{MI}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc trọng tâm:] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Hãy biểu diễn vectơ  #mi(`\vec{AB} + \vec{AC}`)  theo vectơ  #mi(`\vec{AG}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc ba điểm, ta có  #mi(`\vec{AB} = \vec{AG} + \vec{GB}`)  và  #mi(`\vec{AC} = \vec{AG} + \vec{GC}`) . Suy ra  #mi(`\vec{AB} + \vec{AC} = 2\vec{AG} + \vec{GB} + \vec{GC}`) . Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) , suy ra  #mi(`\vec{GB} + \vec{GC} = -\vec{GA} = \vec{AG}`) . Vậy  #mi(`\vec{AB} + \vec{AC} = 2\vec{AG} + \vec{AG} = 3\vec{AG}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`)  tâm  #mi(`O`) . Hãy biểu diễn vectơ  #mi(`\vec{AB} + \vec{AD}`)  theo vectơ  #mi(`\vec{AO}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình bình hành, ta có  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . Vì  #mi(`O`)  là tâm hình bình hành nên  #mi(`O`)  là trung điểm của  #mi(`AC`) , do đó  #mi(`\vec{AC} = 2\vec{AO}`) . Vậy  #mi(`\vec{AB} + \vec{AD} = 2\vec{AO}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AB'}`)  theo hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình bình hành trong mặt bên  #mi(`ABB'A'`) , ta có  #mi(`\vec{AB'} = \vec{AB} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Biểu diễn vectơ  #mi(`\vec{AD'}`)  theo hai vectơ  #mi(`\vec{AD}`)  và  #mi(`\vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình bình hành trong mặt bên  #mi(`ADD'A'`) , ta có  #mi(`\vec{AD'} = \vec{AD} + \vec{AA'}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho đoạn thẳng  #mi(`AB`)  có trung điểm  #mi(`I`) . Với điểm  #mi(`M`)  bất kỳ, hãy biểu diễn vectơ  #mi(`\vec{MA} + \vec{MB}`)  theo vectơ  #mi(`\vec{MI}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`I`)  là trung điểm của  #mi(`AB`)  nên  #mi(`\vec{IA} + \vec{IB} = \vec{0}`) . Theo quy tắc ba điểm, ta có  #mi(`\vec{MA} = \vec{MI} + \vec{IA}`)  và  #mi(`\vec{MB} = \vec{MI} + \vec{IB}`) . Suy ra  #mi(`\vec{MA} + \vec{MB} = (\vec{MI} + \vec{IA}) + (\vec{MI} + \vec{IB}) = 2\vec{MI} + (\vec{IA} + \vec{IB}) = 2\vec{MI}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Biểu diễn vectơ  #mi(`\vec{BA} + \vec{BC}`)  theo vectơ  #mi(`\vec{BG}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc ba điểm, ta có  #mi(`\vec{BA} = \vec{BG} + \vec{GA}`)  và  #mi(`\vec{BC} = \vec{BG} + \vec{GC}`) . Suy ra  #mi(`\vec{BA} + \vec{BC} = 2\vec{BG} + \vec{GA} + \vec{GC}`) . Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) , suy ra  #mi(`\vec{GA} + \vec{GC} = -\vec{GB} = \vec{BG}`) . Vậy  #mi(`\vec{BA} + \vec{BC} = 2\vec{BG} + \vec{BG} = 3\vec{BG}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình bình hành tâm  #mi(`O`) . Biểu diễn vectơ  #mi(`\vec{SA} + \vec{SC}`)  theo vectơ  #mi(`\vec{SO}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`O`)  là tâm hình bình hành  #mi(`ABCD`)  nên  #mi(`O`)  là trung điểm của  #mi(`AC`) . Theo quy tắc trung điểm, ta có  #mi(`\vec{SA} + \vec{SC} = 2\vec{SO}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 15: Tính tích vô hướng và góc giữa hai vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 15. Tính tích vô hướng và góc giữa hai vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Định nghĩa tích vô hướng:  #mi(`\vec{a}\cdot\vec{b} = |\vec{a}|\cdot|\vec{b}|\cdot\cos(\vec{a},\vec{b})`) .
  - Bình phương vô hướng:  #mi(`\vec{a}^2 = |\vec{a}|^2`) . Tích vô hướng của hai vectơ vuông góc bằng  #mi(`0`) :  #mi(`\vec{a} \perp \vec{b} \Leftrightarrow \vec{a}\cdot\vec{b} = 0`) .
  - Công thức tính góc:  #mi(`\cos(\vec{a},\vec{b}) = \frac{\vec{a}\cdot\vec{b}}{|\vec{a}|\cdot|\vec{b}|}`) . Công thức tính độ dài:  #mi(`|\vec{a}| = \sqrt{\vec{a}^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tích vô hướng: Độ dài nhân độ dài nhân cos góc. Vuông góc thì tích bằng 0. Bình phương vô hướng bằng bình phương độ dài.
  ]
  - *Công thức cốt lõi:* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  khác  #mi(`\vec{0}`) , ta có  #mi(`\cos(\vec{a},\vec{b}) = \frac{...}{|\vec{a}|\cdot|\vec{b}|}`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác đều  #mi(`ABC`)  có cạnh bằng  #mi(`2`) . Tính tích vô hướng  #mi(`\vec{AB}\cdot\vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -2]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{BC}`)  là  #mi(`180^\circ - 60^\circ = 120^\circ`) . Do đó  #mi(`\vec{AB}\cdot\vec{BC} = |\vec{AB}|\cdot|\vec{BC}|\cdot\cos 120^\circ = 2\cdot 2\cdot \left(-\frac{1}{2}\right) = -2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  thỏa mãn  #mi(`|\vec{a}|=1, |\vec{b}|=2`)  và  #mi(`\vec{a}\cdot\vec{b}=-1`) . Tính góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 120]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\cos(\vec{a},\vec{b}) = \frac{\vec{a}\cdot\vec{b}}{|\vec{a}|\cdot|\vec{b}|} = \frac{-1}{1\cdot 2} = -\frac{1}{2}`) . Suy ra góc giữa hai vectơ là  #mi(`120^\circ`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hình vuông  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính độ dài của vectơ  #mi(`\vec{u} = \vec{AB} + \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a\sqrt{5}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`|\vec{u}|^2 = (\vec{AB} + \vec{AC})^2 = \vec{AB}^2 + \vec{AC}^2 + 2\vec{AB}\cdot\vec{AC}`) . Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`\vec{AB}\cdot\vec{AC} = |\vec{AB}|\cdot|\vec{AC}|\cdot\cos 45^\circ = a\cdot a\sqrt{2}\cdot \frac{\sqrt{2}}{2} = a^2`) . Do đó  #mi(`|\vec{u}|^2 = a^2 + 2a^2 + 2a^2 = 5a^2`) . Vậy  #mi(`|\vec{u}| = a\sqrt{5}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng cơ bản:] Cho tam giác đều  #mi(`ABC`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB}\cdot\vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì tam giác  #mi(`ABC`)  đều nên góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{AC}`)  là  #mi(`\widehat{BAC} = 60^\circ`) . Áp dụng công thức tích vô hướng:  #mi(`\vec{AB}\cdot\vec{AC} = |\vec{AB}|\cdot|\vec{AC}|\cdot\cos(\vec{AB},\vec{AC}) = a\cdot a\cdot\cos 60^\circ = a^2\cdot \frac{1}{2} = \frac{a^2}{2}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tích vô hướng có góc tù:] Cho hình vuông  #mi(`ABCD`)  cạnh  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB}\cdot\vec{BD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`BD`)  là đường chéo hình vuông nên  #mi(`BD = a\sqrt{2}`) . Góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{BD}`)  là  #mi(`180^\circ - \widehat{ABD} = 180^\circ - 45^\circ = 135^\circ`) . Do đó  #mi(`\vec{AB}\cdot\vec{BD} = |\vec{AB}|\cdot|\vec{BD}|\cdot\cos 135^\circ = a\cdot a\sqrt{2}\cdot \left(-\frac{\sqrt{2}}{2}\right) = -a^2`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính độ dài vectơ tổng, hiệu:] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=2, |\vec{b}|=3`)  và góc giữa chúng bằng  #mi(`60^\circ`) . Tính độ dài các vectơ  #mi(`\vec{a}+\vec{b}`)  và  #mi(`\vec{a}-\vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{a}\cdot\vec{b} = |\vec{a}|\cdot|\vec{b}|\cdot\cos 60^\circ = 2\cdot 3\cdot \frac{1}{2} = 3`) .
- Tính  #mi(`|\vec{a}+\vec{b}|`) :  #mi(`(\vec{a}+\vec{b})^2 = \vec{a}^2 + \vec{b}^2 + 2\vec{a}\cdot\vec{b} = 4 + 9 + 2\cdot 3 = 19`) . Vậy  #mi(`|\vec{a}+\vec{b}| = \sqrt{19}`) .
- Tính  #mi(`|\vec{a}-\vec{b}|`) :  #mi(`(\vec{a}-\vec{b})^2 = \vec{a}^2 + \vec{b}^2 - 2\vec{a}\cdot\vec{b} = 4 + 9 - 2\cdot 3 = 7`) . Vậy  #mi(`|\vec{a}-\vec{b}| = \sqrt{7}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai vectơ:] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=1, |\vec{b}|=2`)  và góc giữa chúng bằng  #mi(`120^\circ`) . Gọi  #mi(`\vec{u} = \vec{a} + \vec{b}`)  và  #mi(`\vec{v} = \vec{a} - \vec{b}`) . Tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{a}\cdot\vec{b} = 1\cdot 2\cdot\cos 120^\circ = -1`) .
 #mi(`\vec{u}\cdot\vec{v} = (\vec{a}+\vec{b})(\vec{a}-\vec{b}) = \vec{a}^2 - \vec{b}^2 = 1 - 4 = -3`) .
 #mi(`|\vec{u}|^2 = \vec{a}^2 + \vec{b}^2 + 2\vec{a}\cdot\vec{b} = 1 + 4 - 2 = 3 \Rightarrow |\vec{u}| = \sqrt{3}`) .
 #mi(`|\vec{v}|^2 = \vec{a}^2 + \vec{b}^2 - 2\vec{a}\cdot\vec{b} = 1 + 4 + 2 = 7 \Rightarrow |\vec{v}| = \sqrt{7}`) .\nGọi  #mi(`\alpha`)  là góc giữa  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) , ta có  #mi(`\cos\alpha = \frac{\vec{u}\cdot\vec{v}}{|\vec{u}||\vec{v}|} = \frac{-3}{\sqrt{3}\cdot\sqrt{7}} = -\frac{\sqrt{21}}{7}`) . Vậy góc  #mi(`\alpha`)  thỏa mãn  #mi(`\cos\alpha = -\frac{\sqrt{21}}{7}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 5 - Ứng dụng trong hình học không gian:] Cho hình chóp  #mi(`S.ABC`)  có  #mi(`SA, SB, SC`)  đôi một vuông góc với nhau và  #mi(`SA=SB=SC=a`) . Tính góc giữa hai vectơ  #mi(`\vec{SA}`)  và  #mi(`\vec{BC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{BC} = \vec{SC} - \vec{SB}`) . Khi đó  #mi(`\vec{SA}\cdot\vec{BC} = \vec{SA}\cdot(\vec{SC} - \vec{SB}) = \vec{SA}\cdot\vec{SC} - \vec{SA}\cdot\vec{SB}`) .\nVì  #mi(`SA \perp SC`)  và  #mi(`SA \perp SB`)  nên  #mi(`\vec{SA}\cdot\vec{SC} = 0`)  và  #mi(`\vec{SA}\cdot\vec{SB} = 0`) .\nSuy ra  #mi(`\vec{SA}\cdot\vec{BC} = 0 - 0 = 0`) . Vậy góc giữa hai vectơ  #mi(`\vec{SA}`)  và  #mi(`\vec{BC}`)  là  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tam giác đều  #mi(`MNP`)  có cạnh bằng  #mi(`2a`) . Tính tích vô hướng  #mi(`\vec{MN}\cdot\vec{MP}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì tam giác  #mi(`MNP`)  đều nên góc giữa hai vectơ  #mi(`\vec{MN}`)  và  #mi(`\vec{MP}`)  là  #mi(`\widehat{NMP} = 60^\circ`) . Áp dụng công thức tích vô hướng:  #mi(`\vec{MN}\cdot\vec{MP} = |\vec{MN}|\cdot|\vec{MP}|\cdot\cos 60^\circ = 2a\cdot 2a\cdot \frac{1}{2} = 2a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình vuông  #mi(`MNPQ`)  cạnh  #mi(`2a`) . Tính tích vô hướng  #mi(`\vec{MN}\cdot\vec{NQ}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`NQ`)  là đường chéo hình vuông nên  #mi(`NQ = 2a\sqrt{2}`) . Góc giữa hai vectơ  #mi(`\vec{MN}`)  và  #mi(`\vec{NQ}`)  là  #mi(`180^\circ - \widehat{MNQ} = 180^\circ - 45^\circ = 135^\circ`) . Do đó  #mi(`\vec{MN}\cdot\vec{NQ} = |\vec{MN}|\cdot|\vec{NQ}|\cdot\cos 135^\circ = 2a\cdot 2a\sqrt{2}\cdot \left(-\frac{\sqrt{2}}{2}\right) = -4a^2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho hai vectơ  #mi(`\vec{x}`)  và  #mi(`\vec{y}`)  có  #mi(`|\vec{x}|=3, |\vec{y}|=4`)  và góc giữa chúng bằng  #mi(`30^\circ`) . Tính độ dài các vectơ  #mi(`\vec{x}+\vec{y}`)  và  #mi(`\vec{x}-\vec{y}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{x}\cdot\vec{y} = |\vec{x}|\cdot|\vec{y}|\cdot\cos 30^\circ = 3\cdot 4\cdot \frac{\sqrt{3}}{2} = 6\sqrt{3}`) .
- Tính  #mi(`|\vec{x}+\vec{y}|`) :  #mi(`(\vec{x}+\vec{y})^2 = \vec{x}^2 + \vec{y}^2 + 2\vec{x}\cdot\vec{y} = 9 + 16 + 12\sqrt{3} = 25 + 12\sqrt{3}`) . Vậy  #mi(`|\vec{x}+\vec{y}| = \sqrt{25 + 12\sqrt{3}}`) .
- Tính  #mi(`|\vec{x}-\vec{y}|`) :  #mi(`(\vec{x}-\vec{y})^2 = \vec{x}^2 + \vec{y}^2 - 2\vec{x}\cdot\vec{y} = 9 + 16 - 12\sqrt{3} = 25 - 12\sqrt{3}`) . Vậy  #mi(`|\vec{x}-\vec{y}| = \sqrt{25 - 12\sqrt{3}}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}|=2, |\vec{b}|=1`)  và góc giữa chúng bằng  #mi(`60^\circ`) . Gọi  #mi(`\vec{u} = \vec{a} - \vec{b}`)  và  #mi(`\vec{v} = \vec{a} + 2\vec{b}`) . Tính góc giữa hai vectơ  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a}\cdot\vec{b} = 2\cdot 1\cdot\cos 60^\circ = 1`) .
 #mi(`\vec{u}\cdot\vec{v} = (\vec{a}-\vec{b})(\vec{a}+2\vec{b}) = \vec{a}^2 + 2\vec{a}\cdot\vec{b} - \vec{a}\cdot\vec{b} - 2\vec{b}^2 = \vec{a}^2 + \vec{a}\cdot\vec{b} - 2\vec{b}^2 = 4 + 1 - 2 = 3`) .
 #mi(`|\vec{u}|^2 = \vec{a}^2 + \vec{b}^2 - 2\vec{a}\cdot\vec{b} = 4 + 1 - 2 = 3 \Rightarrow |\vec{u}| = \sqrt{3}`) .
 #mi(`|\vec{v}|^2 = \vec{a}^2 + 4\vec{b}^2 + 4\vec{a}\cdot\vec{b} = 4 + 4 + 4 = 12 \Rightarrow |\vec{v}| = 2\sqrt{3}`) .\nGọi  #mi(`\alpha`)  là góc giữa  #mi(`\vec{u}`)  và  #mi(`\vec{v}`) , ta có  #mi(`\cos\alpha = \frac{\vec{u}\cdot\vec{v}}{|\vec{u}||\vec{v}|} = \frac{3}{\sqrt{3}\cdot 2\sqrt{3}} = \frac{3}{6} = \frac{1}{2}`) . Vậy góc  #mi(`\alpha = 60^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{B'C'}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{B'C'} = \vec{BC}`) . Do  #mi(`ABCD`)  là hình vuông nên  #mi(`\vec{AB} \perp \vec{BC}`) , suy ra  #mi(`\vec{AB} \perp \vec{B'C'}`) . Vậy góc giữa hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{B'C'}`)  là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 16: Tìm tọa độ điểm và vectơ trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 16. Tìm tọa độ điểm và vectơ trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Trong không gian  #mi(`Oxyz`) , một điểm  #mi(`M`)  có tọa độ  #mi(`(x; y; z)`)  được viết là  #mi(`M(x; y; z)`)  hay  #mi(`M = (x; y; z)`) , trong đó  #mi(`x, y, z`)  lần lượt là hoành độ, tung độ và cao độ của điểm  #mi(`M`) .
  - Cho hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  - Hình chiếu vuông góc của điểm  #mi(`M(x; y; z)`)  lên các trục tọa độ  #mi(`Ox, Oy, Oz`)  lần lượt là  #mi(`M_1(x; 0; 0)`) ,  #mi(`M_2(0; y; 0)`) ,  #mi(`M_3(0; 0; z)`) . Hình chiếu lên mặt phẳng tọa độ  #mi(`(Oxy), (Oyz), (Oxz)`)  lần lượt là  #mi(`M_{xy}(x; y; 0)`) ,  #mi(`M_{yz}(0; y; z)`) ,  #mi(`M_{xz}(x; 0; z)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tọa độ vectơ: 'Đầu trừ đuôi' (Ngọn trừ gốc). Hình chiếu lên trục nào thì giữ nguyên tọa độ trục đó, các tọa độ còn lại bằng 0. Hình chiếu lên mặt phẳng nào thì cho tọa độ trục vuông góc với mặt phẳng đó bằng 0.
  ]
  - *Công thức cốt lõi:* Cho hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , ta có  #mi(`\vec{AB} = (...; ...; ...)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; -2; 3)`)  và  #mi(`B(3; 0; -1)`) . Tính tổng các tọa độ của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AB} = (3 - 1; 0 - (-2); -1 - 3) = (2; 2; -4)`) . Tổng các tọa độ là  #mi(`2 + 2 + (-4) = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M(2; -3; 5)`) . Gọi  #mi(`H`)  là hình chiếu vuông góc của  #mi(`M`)  lên mặt phẳng  #mi(`(Oxy)`) . Tính tổng các tọa độ của điểm  #mi(`H`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -1]
      \ #text(fill: rgb("#334155"))[Lời giải: Hình chiếu vuông góc của  #mi(`M(2; -3; 5)`)  lên mặt phẳng  #mi(`(Oxy)`)  là  #mi(`H(2; -3; 0)`) . Tổng các tọa độ của  #mi(`H`)  là  #mi(`2 + (-3) + 0 = -1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ vectơ từ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; -1; 2)`) . Tìm tọa độ của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo công thức tọa độ vectơ, ta có:
 #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) 
 #mi(`\vec{AB} = (3 - 1; -1 - 2; 2 - 3)`) 
 #mi(`\vec{AB} = (2; -3; -1)`) .\nVậy  #mi(`\vec{AB} = (2; -3; -1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ hình chiếu của điểm:] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M(-1; 4; 2)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`M`)  lên các trục tọa độ  #mi(`Ox, Oy, Oz`)  và lên mặt phẳng  #mi(`(Oxy)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hình chiếu vuông góc của  #mi(`M(-1; 4; 2)`)  lên trục  #mi(`Ox`)  là  #mi(`M_1(-1; 0; 0)`) .\nHình chiếu vuông góc của  #mi(`M`)  lên trục  #mi(`Oy`)  là  #mi(`M_2(0; 4; 0)`) .\nHình chiếu vuông góc của  #mi(`M`)  lên trục  #mi(`Oz`)  là  #mi(`M_3(0; 0; 2)`) .\nHình chiếu vuông góc của  #mi(`M`)  lên mặt phẳng  #mi(`(Oxy)`)  là  #mi(`M_4(-1; 4; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ trung điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; 1; -3)`)  và  #mi(`B(0; -2; 1)`) . Tìm tọa độ trung điểm  #mi(`I`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`I(x_I; y_I; z_I)`)  là trung điểm của đoạn thẳng  #mi(`AB`) . Ta có:
 #mi(`x_I = \frac{x_A + x_B}{2} = \frac{2 + 0}{2} = 1`) 
 #mi(`y_I = \frac{y_A + y_B}{2} = \frac{1 + (-2)}{2} = -\frac{1}{2}`) 
 #mi(`z_I = \frac{z_A + z_B}{2} = \frac{-3 + 1}{2} = -1`) \nVậy  #mi(`I(1; -\frac{1}{2}; -1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biểu thức tọa độ của vectơ:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{u} = (1; 2; -1)`)  và  #mi(`\vec{v} = (3; 0; 4)`) . Tìm tọa độ của vectơ  #mi(`\vec{w} = 2\vec{u} - 3\vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:
 #mi(`2\vec{u} = 2(1; 2; -1) = (2; 4; -2)`) 
 #mi(`3\vec{v} = 3(3; 0; 4) = (9; 0; 12)`) \nSuy ra  #mi(`\vec{w} = 2\vec{u} - 3\vec{v} = (2 - 9; 4 - 0; -2 - 12) = (-7; 4; -14)`) .\nVậy  #mi(`\vec{w} = (-7; 4; -14)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; -1; 4)`)  và  #mi(`B(-1; 3; 2)`) . Tìm tọa độ của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (-1 - 2; 3 - (-1); 2 - 4) = (-3; 4; -2)`) .\nVậy  #mi(`\vec{AB} = (-3; 4; -2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`C(0; 2; -3)`)  và  #mi(`D(4; -1; 1)`) . Tìm tọa độ của vectơ  #mi(`\vec{CD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{CD} = (x_D - x_C; y_D - y_C; z_D - z_C) = (4 - 0; -1 - 2; 1 - (-3)) = (4; -3; 4)`) .\nVậy  #mi(`\vec{CD} = (4; -3; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`P(3; -2; 1)`) . Tìm tọa độ hình chiếu vuông góc của điểm  #mi(`P`)  lên trục  #mi(`Oy`)  và lên mặt phẳng  #mi(`(Oxz)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của  #mi(`P(3; -2; 1)`)  lên trục  #mi(`Oy`)  là  #mi(`P_1(0; -2; 0)`) .\nHình chiếu vuông góc của  #mi(`P`)  lên mặt phẳng  #mi(`(Oxz)`)  là  #mi(`P_2(3; 0; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho điểm  #mi(`M(1; 2; -3)`) . Gọi  #mi(`H`)  là hình chiếu vuông góc của  #mi(`M`)  lên trục  #mi(`Oz`) . Tìm tọa độ của vectơ  #mi(`\vec{OM} + \vec{OH}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hình chiếu vuông góc của  #mi(`M(1; 2; -3)`)  lên trục  #mi(`Oz`)  là  #mi(`H(0; 0; -3)`) .\nTa có  #mi(`\vec{OM} = (1; 2; -3)`)  và  #mi(`\vec{OH} = (0; 0; -3)`) .\nSuy ra  #mi(`\vec{OM} + \vec{OH} = (1 + 0; 2 + 0; -3 + (-3)) = (1; 2; -6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (2; -1; 3)`)  và  #mi(`\vec{b} = (-1; 4; 0)`) . Tìm tọa độ của vectơ  #mi(`\vec{x} = 3\vec{a} + 2\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`3\vec{a} = 3(2; -1; 3) = (6; -3; 9)`)  và  #mi(`2\vec{b} = 2(-1; 4; 0) = (-2; 8; 0)`) .\nSuy ra  #mi(`\vec{x} = 3\vec{a} + 2\vec{b} = (6 - 2; -3 + 8; 9 + 0) = (4; 5; 9)`) .\nVậy  #mi(`\vec{x} = (4; 5; 9)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 17: Tính khoảng cách giữa hai điểm, khoảng cách từ điểm đến mặt phẳng ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 17. Tính khoảng cách giữa hai điểm, khoảng cách từ điểm đến mặt phẳng]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  trong không gian:  #mi(`AB = \sqrt{(x_B-x_A)^2 + (y_B-y_A)^2 + (z_B-z_A)^2}`) .
  - Khoảng cách từ điểm  #mi(`M(x_0; y_0; z_0)`)  đến mặt phẳng  #mi(`(P): ax+by+cz+d=0`) :  #mi(`d(M, (P)) = \frac{|ax_0+by_0+cz_0+d|}{\sqrt{a^2+b^2+c^2}}`) .
  - Khoảng cách từ điểm đến đường tiệm cận: Khoảng cách từ  #mi(`M(x_0; y_0)`)  đến tiệm cận đứng  #mi(`x=a`)  là  #mi(`|x_0-a|`) ; đến tiệm cận ngang  #mi(`y=b`)  là  #mi(`|y_0-b|`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tính khoảng cách điểm-điểm: Trừ tọa độ tương ứng, bình phương, cộng lại, lấy căn. Tính khoảng cách điểm-mặt phẳng: Thay tọa độ vào phương trình, lấy trị tuyệt đối, chia cho độ dài vectơ pháp tuyến.
  ]
  - *Công thức cốt lõi:* Khoảng cách từ  #mi(`M(x_0; y_0; z_0)`)  đến  #mi(`(P): ax+by+cz+d=0`)  là  #mi(`d(M, (P)) = \frac{|ax_0+by_0+cz_0+d|}{...}`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 6; 3)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{AB} = (3; 4; 0)`) . Do đó  #mi(`AB = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9+16} = 5`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , tính khoảng cách từ điểm  #mi(`M(1; 2; 3)`)  đến mặt phẳng  #mi(`(P): 2x - y + 2z - 4 = 0`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2/3]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức khoảng cách:  #mi(`d(M, (P)) = \frac{|2(1) - 1(2) + 2(3) - 4|}{\sqrt{2^2 + (-1)^2 + 2^2}} = \frac{|2 - 2 + 6 - 4|}{\sqrt{4+1+4}} = \frac{2}{3}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho hàm số  #mi(`y = \frac{x+1}{x-2}`)  có đồ thị  #mi(`(C)`) . Điểm  #mi(`M`)  thuộc  #mi(`(C)`)  có hoành độ  #mi(`x=3`) . Tính khoảng cách từ  #mi(`M`)  đến đường tiệm cận đứng của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận đứng là đường thẳng  #mi(`x = 2`) . Với  #mi(`x=3`) , tung độ của  #mi(`M`)  là  #mi(`y = \frac{3+1}{3-2} = 4`) , vậy  #mi(`M(3;4)`) . Khoảng cách từ  #mi(`M`)  đến đường thẳng  #mi(`x=2`)  là  #mi(`|3 - 2| = 1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Khoảng cách giữa hai điểm trong không gian:] Trong không gian với hệ tọa độ  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 6; 3)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{AB} = (4-1; 6-2; 3-3) = (3; 4; 0)`) .
Độ dài đoạn thẳng  #mi(`AB`)  là  #mi(`AB = |\vec{AB}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{9+16} = 5`) .\nVậy  #mi(`AB = 5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Khoảng cách từ điểm đến mặt phẳng:] Trong không gian  #mi(`Oxyz`) , tính khoảng cách từ điểm  #mi(`M(1; 2; -1)`)  đến mặt phẳng  #mi(`(P): 2x - 2y + z + 3 = 0`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức khoảng cách từ điểm đến mặt phẳng:
 #mi(`d(M, (P)) = \frac{|2(1) - 2(2) + 1(-1) + 3|}{\sqrt{2^2 + (-2)^2 + 1^2}} = \frac{|2 - 4 - 1 + 3|}{\sqrt{4+4+1}} = \frac{0}{3} = 0`) .\nVậy  #mi(`d(M, (P)) = 0`)  (điểm  #mi(`M`)  thuộc mặt phẳng  #mi(`(P)`) ).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Khoảng cách từ điểm đến mặt phẳng (biến thể):] Trong không gian  #mi(`Oxyz`) , tính khoảng cách từ điểm  #mi(`A(2; -1; 3)`)  đến mặt phẳng  #mi(`(Q): x + 2y - 2z + 5 = 0`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách từ  #mi(`A`)  đến  #mi(`(Q)`)  là:
 #mi(`d(A, (Q)) = \frac{|1(2) + 2(-1) - 2(3) + 5|}{\sqrt{1^2 + 2^2 + (-2)^2}} = \frac{|2 - 2 - 6 + 5|}{\sqrt{1+4+4}} = \frac{|-1|}{3} = \frac{1}{3}`) .\nVậy  #mi(`d(A, (Q)) = \frac{1}{3}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Khoảng cách từ điểm đến đường tiệm cận:] Cho hàm số  #mi(`y = \frac{2x+1}{x-1}`)  có đồ thị  #mi(`(C)`) . Tìm điểm  #mi(`M`)  thuộc  #mi(`(C)`)  có hoành độ  #mi(`x=2`)  và tính khoảng cách từ  #mi(`M`)  đến đường tiệm cận đứng của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đồ thị  #mi(`(C)`)  có tiệm cận đứng là đường thẳng  #mi(`x = 1`) .\nVới  #mi(`x=2`) , ta có  #mi(`y = \frac{2(2)+1}{2-1} = 5`) . Suy ra  #mi(`M(2; 5)`) .\nKhoảng cách từ  #mi(`M(2; 5)`)  đến đường thẳng  #mi(`x = 1`)  là  #mi(`|2 - 1| = 1`) .\nVậy khoảng cách cần tìm là  #mi(`1`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 0; 2)`)  và  #mi(`B(2; -1; 3)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = (1; -1; 1)`) .
Độ dài  #mi(`AB = \sqrt{1^2 + (-1)^2 + 1^2} = \sqrt{3}`) .\nVậy  #mi(`AB = \sqrt{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , tính khoảng cách từ điểm  #mi(`M(1; 1; 1)`)  đến mặt phẳng  #mi(`(P): 2x - y + 2z - 3 = 0`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách từ  #mi(`M`)  đến  #mi(`(P)`)  là:
 #mi(`d(M, (P)) = \frac{|2(1) - 1(1) + 2(1) - 3|}{\sqrt{2^2 + (-1)^2 + 2^2}} = \frac{|2 - 1 + 2 - 3|}{\sqrt{4+1+4}} = \frac{0}{3} = 0`) .\nVậy  #mi(`d(M, (P)) = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , tính khoảng cách từ điểm  #mi(`N(0; 0; 1)`)  đến mặt phẳng  #mi(`(Q): x - 2y + 2z - 1 = 0`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách từ  #mi(`N`)  đến  #mi(`(Q)`)  là:
 #mi(`d(N, (Q)) = \frac{|1(0) - 2(0) + 2(1) - 1|}{\sqrt{1^2 + (-2)^2 + 2^2}} = \frac{|2 - 1|}{\sqrt{1+4+4}} = \frac{1}{3}`) .\nVậy  #mi(`d(N, (Q)) = \frac{1}{3}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hàm số  #mi(`y = \frac{x+2}{x-1}`)  có đồ thị  #mi(`(C)`) . Điểm  #mi(`M`)  thuộc  #mi(`(C)`)  có hoành độ  #mi(`x=3`) . Tính khoảng cách từ  #mi(`M`)  đến đường tiệm cận đứng của đồ thị  #mi(`(C)`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đồ thị  #mi(`(C)`)  có tiệm cận đứng  #mi(`x = 1`) .\nVới  #mi(`x=3`) ,  #mi(`y = \frac{3+2}{3-1} = \frac{5}{2}`) . Suy ra  #mi(`M(3; \frac{5}{2})`) .\nKhoảng cách từ  #mi(`M`)  đến đường thẳng  #mi(`x=1`)  là  #mi(`|3 - 1| = 2`) .\nVậy khoảng cách cần tìm là  #mi(`2`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(1; 2; -5)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{AB} = (0; 0; -8)`) .
Độ dài  #mi(`AB = \sqrt{0^2 + 0^2 + (-8)^2} = 8`) .\nVậy  #mi(`AB = 8`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Trong không gian  #mi(`Oxyz`) , tính khoảng cách từ điểm  #mi(`P(2; -1; 0)`)  đến mặt phẳng  #mi(`(R): 2x + 2y - z + 1 = 0`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách từ  #mi(`P`)  đến  #mi(`(R)`)  là:
 #mi(`d(P, (R)) = \frac{|2(2) + 2(-1) - 1(0) + 1|}{\sqrt{2^2 + 2^2 + (-1)^2}} = \frac{|4 - 2 + 1|}{\sqrt{4+4+1}} = \frac{3}{3} = 1`) .\nVậy  #mi(`d(P, (R)) = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 18: Bài toán về áp lực, lực căng dây trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 18. Bài toán về áp lực, lực căng dây trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Điều kiện cân bằng của chất điểm: Tổng các vectơ lực tác dụng lên chất điểm bằng vectơ không:  #mi(`\vec{F}_1 + \vec{F}_2 + \dots + \vec{F}_n = \vec{0}`) .
  - Trọng lực:  #mi(`\vec{P} = m\vec{g}`) , độ lớn  #mi(`P = mg`)  (với  #mi(`g \approx 9.8`)  hoặc  #mi(`10 \, m/s^2`) ).
  - Phương pháp giải: Phân tích lực hoặc sử dụng hình học vectơ (hình bình hành, đa giác lực) để tìm mối liên hệ giữa các lực. Trong không gian, thường dùng hệ trục tọa độ Oxyz hoặc các tính chất đối xứng của hình chóp đều, hình hộp.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Gặp hệ lực không gian: 'Ba lực vuông góc -> Hợp lực bình phương', 'Chóp đều -> Chiếu lên trục thẳng đứng'.
  ]
  - *Công thức cốt lõi:* Điều kiện cân bằng của chất điểm dưới tác dụng của ba lực  #mi(`\vec{F}_1, \vec{F}_2, \vec{F}_3`)  là:  #mi(`\vec{F}_1 + \vec{F}_2 + \vec{F}_3 = ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một vật có trọng lượng  #mi(`P = 60\sqrt{3} \, N`)  được treo bởi ba sợi dây giống hệt nhau, đôi một vuông góc với nhau tại điểm treo. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 60]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là lực căng của ba sợi dây. Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T`) . Ba lực này đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Điều kiện cân bằng:  #mi(`T_{hl} = P \Rightarrow T\sqrt{3} = 60\sqrt{3} \Rightarrow T = 60 \, N`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một chiếc đèn tròn có khối lượng  #mi(`m = 3.2 \, kg`)  được treo song song với mặt phẳng nằm ngang bởi bốn sợi dây không dãn xuất phát từ điểm  #mi(`S`)  trên trần nhà và lần lượt buộc vào bốn điểm  #mi(`A, B, C, D`)  trên đèn tròn sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều có góc  #mi(`ASC = 60^\circ`) . Biết trọng lượng của chiếc đèn được tính theo công thức  #mi(`P = mg`)  (lấy  #mi(`g = 9.8 \, m/s^2`) ). Tính độ lớn lực căng cho mỗi sợi dây xích (làm tròn kết quả đến hàng phần mười).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 15.7]
      \ #text(fill: rgb("#334155"))[Lời giải: Trọng lượng của đèn:  #mi(`P = mg = 3.2 \cdot 9.8 = 31.36 \, N`) . Gọi  #mi(`O`)  là tâm của hình vuông  #mi(`ABCD`) . Do  #mi(`S.ABCD`)  là hình chóp đều nên  #mi(`SO \perp (ABCD)`) . Gọi  #mi(`T`)  là độ lớn lực căng mỗi dây. Hợp lực của bốn lực căng hướng thẳng đứng lên và có độ lớn  #mi(`4T\cos\alpha`) , với  #mi(`\alpha = \widehat{ASO}`) . Tam giác  #mi(`ASC`)  có  #mi(`SA = SC`)  và  #mi(`\widehat{ASC} = 60^\circ`)  nên là tam giác đều, suy ra  #mi(`AC = SA`) . Trong hình vuông  #mi(`ABCD`) ,  #mi(`AC = 2AO`) , do đó  #mi(`SA = 2AO`) . Xét tam giác vuông  #mi(`SAO`) :  #mi(`\cos\alpha = \frac{AO}{SA} = \frac{1}{2}`) . Điều kiện cân bằng:  #mi(`4T\cos\alpha = P \Rightarrow 4T \cdot \frac{1}{2} = 31.36 \Rightarrow 2T = 31.36 \Rightarrow T = 15.68 \approx 15.7 \, N`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Hệ ba lực đôi một vuông góc:] Một vật có trọng lượng  #mi(`P = 60 \, N`)  được treo bởi ba sợi dây giống hệt nhau, đôi một vuông góc với nhau tại điểm treo. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là lực căng của ba sợi dây. Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T`) . Ba lực này đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Điều kiện cân bằng:  #mi(`T_{hl} = P \Rightarrow T\sqrt{3} = 60 \Rightarrow T = \frac{60}{\sqrt{3}} = 20\sqrt{3} \approx 34.6 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Hình chóp tứ giác đều:] Một chiếc đèn tròn có khối lượng  #mi(`m = 3.2 \, kg`)  được treo song song với mặt phẳng nằm ngang bởi bốn sợi dây không dãn xuất phát từ điểm  #mi(`S`)  trên trần nhà và lần lượt buộc vào bốn điểm  #mi(`A, B, C, D`)  trên đèn tròn sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều có góc  #mi(`ASC = 60^\circ`) . Biết trọng lượng của chiếc đèn được tính theo công thức  #mi(`P = mg`)  (lấy  #mi(`g = 9.8 \, m/s^2`) ). Tính độ lớn lực căng cho mỗi sợi dây xích (làm tròn kết quả đến hàng phần mười).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trọng lượng của đèn:  #mi(`P = mg = 3.2 \cdot 9.8 = 31.36 \, N`) . Gọi  #mi(`O`)  là tâm của hình vuông  #mi(`ABCD`) . Do  #mi(`S.ABCD`)  là hình chóp đều nên  #mi(`SO \perp (ABCD)`) . Gọi  #mi(`T`)  là độ lớn lực căng mỗi dây. Hợp lực của bốn lực căng hướng thẳng đứng lên và có độ lớn  #mi(`4T\cos\alpha`) , với  #mi(`\alpha = \widehat{ASO}`) . Tam giác  #mi(`ASC`)  có  #mi(`SA = SC`)  và  #mi(`\widehat{ASC} = 60^\circ`)  nên là tam giác đều, suy ra  #mi(`AC = SA`) . Trong hình vuông  #mi(`ABCD`) ,  #mi(`AC = 2AO`) , do đó  #mi(`SA = 2AO`) . Xét tam giác vuông  #mi(`SAO`) :  #mi(`\cos\alpha = \frac{AO}{SA} = \frac{1}{2}`) . Điều kiện cân bằng:  #mi(`4T\cos\alpha = P \Rightarrow 4T \cdot \frac{1}{2} = 31.36 \Rightarrow 2T = 31.36 \Rightarrow T = 15.68 \approx 15.7 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Hệ ba lực đôi một vuông góc (biến thể):] Một vật có trọng lượng  #mi(`P = 300 \, N`)  được treo bởi ba sợi dây cáp không dãn, đôi một vuông góc với nhau tại điểm treo. Tính độ lớn lực căng của mỗi sợi dây cáp.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là lực căng của ba sợi dây. Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T`) . Ba lực này đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Điều kiện cân bằng:  #mi(`T_{hl} = P \Rightarrow T\sqrt{3} = 300 \Rightarrow T = \frac{300}{\sqrt{3}} = 100\sqrt{3} \approx 173.2 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Hình chóp tam giác đều:] Một chiếc đĩa sắt hình tròn cân đối đồng chất được treo song song với mặt phẳng nằm ngang bởi ba sợi dây không giãn  #mi(`SA, SB, SC`)  xuất phát từ điểm  #mi(`S`) . Các lực căng  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  lần lượt trên mỗi dây  #mi(`SA, SB, SC`)  sao cho  #mi(`ASB = BSC = CSA = 60^\circ`)  và trọng lượng của đĩa sắt là  #mi(`900 \, N`) . Tính độ lớn các lực căng  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  (làm tròn kết quả đến hàng đơn vị).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`T`)  là độ lớn lực căng của mỗi dây. Do  #mi(`ASB = BSC = CSA = 60^\circ`)  và  #mi(`SA=SB=SC`)  nên  #mi(`S.ABC`)  là hình chóp tam giác đều, các mặt bên là tam giác đều. Gọi  #mi(`H`)  là tâm tam giác đều  #mi(`ABC`) ,  #mi(`SH`)  là trục của hình chóp. Góc giữa  #mi(`SA`)  và  #mi(`SH`)  là  #mi(`\beta`) . Ta có  #mi(`\cos\beta = \sqrt{1 - \frac{R^2}{l^2}}`) , với  #mi(`R`)  là bán kính đường tròn ngoại tiếp tam giác  #mi(`ABC`) ,  #mi(`l = SA`) . Tam giác  #mi(`ABC`)  đều cạnh  #mi(`a = l`)  (vì tam giác  #mi(`SAB`)  đều), nên  #mi(`R = \frac{l\sqrt{3}}{3}`) . Suy ra  #mi(`\cos\beta = \sqrt{1 - \frac{l^2/3}{l^2}} = \sqrt{\frac{2}{3}}`) . Hợp lực của ba lực căng hướng thẳng đứng lên có độ lớn  #mi(`3T\cos\beta`) . Điều kiện cân bằng:  #mi(`3T\cos\beta = P \Rightarrow 3T\sqrt{\frac{2}{3}} = 900 \Rightarrow T\sqrt{6} = 900 \Rightarrow T = \frac{900}{\sqrt{6}} = 150\sqrt{6} \approx 367 \, N`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một vật có trọng lượng  #mi(`P = 120 \, N`)  được treo bởi ba sợi dây giống hệt nhau, đôi một vuông góc với nhau tại điểm treo. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là lực căng của ba sợi dây. Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T`) . Ba lực này đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Điều kiện cân bằng:  #mi(`T_{hl} = P \Rightarrow T\sqrt{3} = 120 \Rightarrow T = \frac{120}{\sqrt{3}} = 40\sqrt{3} \approx 69.3 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một vật có trọng lượng  #mi(`P = 90 \, N`)  được treo bởi ba sợi dây giống hệt nhau, đôi một vuông góc với nhau tại điểm treo. Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là lực căng của ba sợi dây. Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T`) . Ba lực này đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Điều kiện cân bằng:  #mi(`T_{hl} = P \Rightarrow T\sqrt{3} = 90 \Rightarrow T = \frac{90}{\sqrt{3}} = 30\sqrt{3} \approx 52.0 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một chiếc đèn tròn có khối lượng  #mi(`m = 4 \, kg`)  được treo song song với mặt phẳng nằm ngang bởi bốn sợi dây không dãn xuất phát từ điểm  #mi(`S`)  trên trần nhà và lần lượt buộc vào bốn điểm  #mi(`A, B, C, D`)  trên đèn tròn sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều có góc  #mi(`ASC = 60^\circ`) . Biết trọng lượng của chiếc đèn được tính theo công thức  #mi(`P = mg`)  (lấy  #mi(`g = 10 \, m/s^2`) ). Tính độ lớn lực căng cho mỗi sợi dây xích.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trọng lượng của đèn:  #mi(`P = mg = 4 \cdot 10 = 40 \, N`) . Gọi  #mi(`O`)  là tâm của hình vuông  #mi(`ABCD`) . Do  #mi(`S.ABCD`)  là hình chóp đều nên  #mi(`SO \perp (ABCD)`) . Gọi  #mi(`T`)  là độ lớn lực căng mỗi dây. Hợp lực của bốn lực căng hướng thẳng đứng lên và có độ lớn  #mi(`4T\cos\alpha`) , với  #mi(`\alpha = \widehat{ASO}`) . Tam giác  #mi(`ASC`)  có  #mi(`SA = SC`)  và  #mi(`\widehat{ASC} = 60^\circ`)  nên là tam giác đều, suy ra  #mi(`AC = SA`) . Trong hình vuông  #mi(`ABCD`) ,  #mi(`AC = 2AO`) , do đó  #mi(`SA = 2AO`) . Xét tam giác vuông  #mi(`SAO`) :  #mi(`\cos\alpha = \frac{AO}{SA} = \frac{1}{2}`) . Điều kiện cân bằng:  #mi(`4T\cos\alpha = P \Rightarrow 4T \cdot \frac{1}{2} = 40 \Rightarrow 2T = 40 \Rightarrow T = 20 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật có trọng lượng  #mi(`P`)  được treo bởi ba sợi dây giống hệt nhau, đôi một vuông góc với nhau tại điểm treo. Biết lực căng của mỗi sợi dây là  #mi(`T = 50\sqrt{3} \, N`) . Tính trọng lượng  #mi(`P`)  của vật.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là lực căng của ba sợi dây. Do tính đối xứng,  #mi(`T_1 = T_2 = T_3 = T = 50\sqrt{3} \, N`) . Ba lực này đôi một vuông góc nên hợp lực của chúng có độ lớn  #mi(`T_{hl} = \sqrt{T^2 + T^2 + T^2} = T\sqrt{3}`) . Điều kiện cân bằng:  #mi(`T_{hl} = P \Rightarrow P = T\sqrt{3} = 50\sqrt{3} \cdot \sqrt{3} = 150 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một chiếc đèn tròn có khối lượng  #mi(`m = 2 \, kg`)  được treo song song với mặt phẳng nằm ngang bởi bốn sợi dây không dãn xuất phát từ điểm  #mi(`S`)  trên trần nhà và lần lượt buộc vào bốn điểm  #mi(`A, B, C, D`)  trên đèn tròn sao cho  #mi(`S.ABCD`)  là hình chóp tứ giác đều có góc  #mi(`ASC = 60^\circ`) . Biết trọng lượng của chiếc đèn được tính theo công thức  #mi(`P = mg`)  (lấy  #mi(`g = 9.8 \, m/s^2`) ). Tính độ lớn lực căng cho mỗi sợi dây xích (làm tròn kết quả đến hàng phần mười).
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Trọng lượng của đèn:  #mi(`P = mg = 2 \cdot 9.8 = 19.6 \, N`) . Gọi  #mi(`O`)  là tâm của hình vuông  #mi(`ABCD`) . Do  #mi(`S.ABCD`)  là hình chóp đều nên  #mi(`SO \perp (ABCD)`) . Gọi  #mi(`T`)  là độ lớn lực căng mỗi dây. Hợp lực của bốn lực căng hướng thẳng đứng lên và có độ lớn  #mi(`4T\cos\alpha`) , với  #mi(`\alpha = \widehat{ASO}`) . Tam giác  #mi(`ASC`)  có  #mi(`SA = SC`)  và  #mi(`\widehat{ASC} = 60^\circ`)  nên là tam giác đều, suy ra  #mi(`AC = SA`) . Trong hình vuông  #mi(`ABCD`) ,  #mi(`AC = 2AO`) , do đó  #mi(`SA = 2AO`) . Xét tam giác vuông  #mi(`SAO`) :  #mi(`\cos\alpha = \frac{AO}{SA} = \frac{1}{2}`) . Điều kiện cân bằng:  #mi(`4T\cos\alpha = P \Rightarrow 4T \cdot \frac{1}{2} = 19.6 \Rightarrow 2T = 19.6 \Rightarrow T = 9.8 \, N`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 19: Bài toán ứng dụng vectơ trong không gian (lực, hình học) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 19. Bài toán ứng dụng vectơ trong không gian (lực, hình học)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc cộng, trừ vectơ:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) ,  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) .
  - Tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| |\vec{b}| \cos(\vec{a}, \vec{b})`) . Góc giữa hai vectơ:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| |\vec{b}|}`) .
  - Điều kiện đồng phẳng: Ba vectơ  #mi(`\vec{a}, \vec{b}, \vec{c}`)  đồng phẳng nếu tồn tại  #mi(`m, n`)  sao cho  #mi(`\vec{c} = m\vec{a} + n\vec{b}`)  (với  #mi(`\vec{a}, \vec{b}`)  không cùng phương).
  - Phân tích lực: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + ... + \vec{F_n}`) . Độ lớn hợp lực tính bằng  #mi(`|\vec{F}| = \sqrt{F_1^2 + F_2^2 + 2F_1F_2\cos\alpha}`)  (nếu có 2 lực) hoặc dùng hình học.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Quy tắc hình hộp: Tổng ba vectơ cạnh xuất phát từ một đỉnh bằng vectơ đường chéo xuất phát từ đỉnh đó. Tích vô hướng bằng 0 khi hai vectơ vuông góc.
  ]
  - *Công thức cốt lõi:* Cho hình hộp  #mi(`ABCD.A'B'C'D'`) , ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{A'C'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`a^2`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{A'C'} = \vec{AC} = \vec{AB} + \vec{AD}`) . Do đó  #mi(`\vec{AB} \cdot \vec{A'C'} = \vec{AB} \cdot (\vec{AB} + \vec{AD}) = \vec{AB}^2 + \vec{AB} \cdot \vec{AD}`) . Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`\vec{AB} \perp \vec{AD} \Rightarrow \vec{AB} \cdot \vec{AD} = 0`) . Vậy  #mi(`\vec{AB} \cdot \vec{A'C'} = a^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc và có độ lớn bằng nhau  #mi(`|\vec{F_1}| = |\vec{F_2}| = |\vec{F_3}| = 20\text{ N}`) . Tính độ lớn hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số:  #mi(`20\sqrt{3}`) ]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc nên  #mi(`|\vec{F}|^2 = |\vec{F_1}|^2 + |\vec{F_2}|^2 + |\vec{F_3}|^2 = 20^2 + 20^2 + 20^2 = 1200`) . Suy ra  #mi(`|\vec{F}| = \sqrt{1200} = 20\sqrt{3}\text{ N}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{CD}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{CD} = \vec{AD} - \vec{AC}`) . Do đó  #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC}`) . Vì  #mi(`ABCD`)  là tứ diện đều nên  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`)  và  #mi(`\vec{AB} \cdot \vec{AC} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) . Vậy  #mi(`\vec{AB} \cdot \vec{CD} = \frac{a^2}{2} - \frac{a^2}{2} = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Biểu diễn vectơ theo các vectơ cơ sở:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Hãy biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, ta có  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'}`) . Thay  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) , ta được  #mi(`\vec{AC'} = \vec{a} + \vec{b} + \vec{c}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính tích vô hướng, góc, độ dài:] Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{CD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{CD} = \vec{AD} - \vec{AC}`) . Do đó  #mi(`\vec{AB} \cdot \vec{CD} = \vec{AB} \cdot (\vec{AD} - \vec{AC}) = \vec{AB} \cdot \vec{AD} - \vec{AB} \cdot \vec{AC}`) . Vì  #mi(`ABCD`)  là tứ diện đều nên  #mi(`\vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`)  và  #mi(`\vec{AB} \cdot \vec{AC} = a \cdot a \cdot \cos 60^\circ = \frac{a^2}{2}`) . Vậy  #mi(`\vec{AB} \cdot \vec{CD} = \frac{a^2}{2} - \frac{a^2}{2} = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán cân bằng lực:] Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc và có độ lớn bằng nhau  #mi(`|\vec{F_1}| = |\vec{F_2}| = |\vec{F_3}| = 10\text{ N}`) . Tính độ lớn hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc nên  #mi(`|\vec{F}|^2 = |\vec{F_1}|^2 + |\vec{F_2}|^2 + |\vec{F_3}|^2 = 10^2 + 10^2 + 10^2 = 300`) . Suy ra  #mi(`|\vec{F}| = \sqrt{300} = 10\sqrt{3}\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính góc giữa hai đường thẳng:] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA`)  vuông góc với mặt phẳng đáy và  #mi(`SA = a`) . Tính góc giữa hai đường thẳng  #mi(`SC`)  và  #mi(`BD`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{SC} = \vec{AC} - \vec{AS}`)  và  #mi(`\vec{BD} = \vec{AD} - \vec{AB}`) . Do đó  #mi(`\vec{SC} \cdot \vec{BD} = (\vec{AC} - \vec{AS}) \cdot (\vec{AD} - \vec{AB}) = \vec{AC} \cdot \vec{AD} - \vec{AC} \cdot \vec{AB} - \vec{AS} \cdot \vec{AD} + \vec{AS} \cdot \vec{AB}`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`\vec{AS} \cdot \vec{AD} = 0`)  và  #mi(`\vec{AS} \cdot \vec{AB} = 0`) . Mặt khác  #mi(`\vec{AC} \cdot \vec{AD} = a\sqrt{2} \cdot a \cdot \cos 45^\circ = a^2`)  và  #mi(`\vec{AC} \cdot \vec{AB} = a\sqrt{2} \cdot a \cdot \cos 45^\circ = a^2`) . Suy ra  #mi(`\vec{SC} \cdot \vec{BD} = a^2 - a^2 - 0 + 0 = 0`) . Vậy  #mi(`SC \perp BD`) , góc giữa chúng bằng  #mi(`90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Đặt  #mi(`\vec{AB} = \vec{a}, \vec{AD} = \vec{b}, \vec{AA'} = \vec{c}`) . Biểu diễn vectơ  #mi(`\vec{AC'}`)  theo  #mi(`\vec{a}, \vec{b}, \vec{c}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Theo quy tắc hình hộp,  #mi(`\vec{AC'} = \vec{AB} + \vec{AD} + \vec{AA'} = \vec{a} + \vec{b} + \vec{c}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB \perp AD`) , do đó  #mi(`\vec{AB} \cdot \vec{AD} = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc và có độ lớn bằng nhau  #mi(`|\vec{F_1}| = |\vec{F_2}| = |\vec{F_3}| = 5\text{ N}`) . Tính độ lớn hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc nên  #mi(`|\vec{F}|^2 = |\vec{F_1}|^2 + |\vec{F_2}|^2 + |\vec{F_3}|^2 = 5^2 + 5^2 + 5^2 = 75`) . Suy ra  #mi(`|\vec{F}| = \sqrt{75} = 5\sqrt{3}\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tứ diện đều  #mi(`ABCD`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là tứ diện đều nên tam giác  #mi(`ABC`)  đều, do đó  #mi(`\vec{AB} \cdot \vec{AC} = |\vec{AB}| |\vec{AC}| \cos 60^\circ = a \cdot a \cdot \frac{1}{2} = \frac{a^2}{2}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Biến thể nhẹ).*] else [*Bài 5.*] Cho hình chóp  #mi(`S.ABCD`)  có đáy  #mi(`ABCD`)  là hình vuông cạnh  #mi(`a`) ,  #mi(`SA`)  vuông góc với mặt phẳng đáy và  #mi(`SA = a`) . Tính góc giữa hai đường thẳng  #mi(`SB`)  và  #mi(`CD`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{SB} = \vec{AB} - \vec{AS}`)  và  #mi(`\vec{CD} = -\vec{AB}`) . Do đó  #mi(`\vec{SB} \cdot \vec{CD} = (\vec{AB} - \vec{AS}) \cdot (-\vec{AB}) = -\vec{AB}^2 + \vec{AS} \cdot \vec{AB}`) . Vì  #mi(`SA \perp (ABCD)`)  nên  #mi(`\vec{AS} \cdot \vec{AB} = 0`) . Suy ra  #mi(`\vec{SB} \cdot \vec{CD} = -a^2`) . Mặt khác  #mi(`|\vec{SB}| = a\sqrt{2}`) ,  #mi(`|\vec{CD}| = a`) . Gọi  #mi(`\alpha`)  là góc giữa  #mi(`SB`)  và  #mi(`CD`) , ta có  #mi(`\cos\alpha = \frac{|\vec{SB} \cdot \vec{CD}|}{|\vec{SB}| |\vec{CD}|} = \frac{a^2}{a\sqrt{2} \cdot a} = \frac{1}{\sqrt{2}}`) . Vậy  #mi(`\alpha = 45^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 6 (Củng cố).*] else [*Bài 6.*] Ba lực  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc và có độ lớn bằng nhau  #mi(`|\vec{F_1}| = |\vec{F_2}| = |\vec{F_3}| = 10\text{ N}`) . Tính độ lớn hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \vec{F_3}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{F_1}, \vec{F_2}, \vec{F_3}`)  đôi một vuông góc nên  #mi(`|\vec{F}|^2 = |\vec{F_1}|^2 + |\vec{F_2}|^2 + |\vec{F_3}|^2 = 10^2 + 10^2 + 10^2 = 300`) . Suy ra  #mi(`|\vec{F}| = \sqrt{300} = 10\sqrt{3}\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 20: Bài toán tối ưu hóa trong kinh tế ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 20. Bài toán tối ưu hóa trong kinh tế]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Hàm doanh thu:  #mi(`R(x) = x \cdot p(x)`) , trong đó  #mi(`x`)  là sản lượng và  #mi(`p(x)`)  là giá bán mỗi sản phẩm.
  - Hàm lợi nhuận:  #mi(`P(x) = R(x) - C(x)`) , với  #mi(`C(x)`)  là hàm chi phí sản xuất.
  - Để tối đa hóa lợi nhuận, ta tìm  #mi(`x`)  sao cho  #mi(`P'(x) = 0`)  và  #mi(`P''(x) < 0`)  (hoặc lập bảng biến thiên).
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lợi nhuận = Doanh thu - Chi phí. Đạo hàm bằng 0, lập bảng, nhìn dấu để chốt cực đại.
  ]
  - *Công thức cốt lõi:* Hàm lợi nhuận được xác định bởi công thức  #mi(`P(x) = ... - C(x)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một công ty sản xuất và bán  #mi(`x`)  sản phẩm. Hàm chi phí là  #mi(`C(x) = x^2 + 10x + 100`)  (nghìn đồng) và giá bán mỗi sản phẩm là  #mi(`p = 50 - x`)  (nghìn đồng). Tính lợi nhuận tối đa.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 100]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = x(50 - x) = 50x - x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (50x - x^2) - (x^2 + 10x + 100) = -2x^2 + 40x - 100`) . Đạo hàm:  #mi(`P'(x) = -4x + 40`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 10`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Khi đó  #mi(`P(10) = -2(100) + 400 - 100 = 100`)  (nghìn đồng).]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một cửa hàng bán  #mi(`x`)  sản phẩm với giá  #mi(`p = 100 - 2x`)  (nghìn đồng). Chi phí sản xuất là  #mi(`C(x) = 20x + 50`)  (nghìn đồng). Hỏi cửa hàng nên bán bao nhiêu sản phẩm để lợi nhuận lớn nhất?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 20]
      \ #text(fill: rgb("#334155"))[Lời giải: Doanh thu:  #mi(`R(x) = x(100 - 2x) = 100x - 2x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = -2x^2 + 80x - 50`) . Đạo hàm:  #mi(`P'(x) = -4x + 80`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 20`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 20`) . Vậy cửa hàng nên bán 20 sản phẩm.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tối ưu hóa lợi nhuận theo giá bán:] Một công ty bán  #mi(`x`)  sản phẩm với giá bán mỗi sản phẩm là  #mi(`p = 100 - 2x`)  (nghìn đồng). Chi phí sản xuất là  #mi(`C(x) = 20x + 50`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để lợi nhuận đạt lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu:  #mi(`R(x) = x \cdot p = x(100 - 2x) = 100x - 2x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (100x - 2x^2) - (20x + 50) = -2x^2 + 80x - 50`) . Đạo hàm:  #mi(`P'(x) = -4x + 80`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 20`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 20`) . Vậy sản lượng cần bán là 20 sản phẩm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa lợi nhuận theo sản lượng:] Một doanh nghiệp sản xuất  #mi(`x`)  sản phẩm. Hàm chi phí là  #mi(`C(x) = x^2 + 10x + 100`)  (nghìn đồng). Giá bán mỗi sản phẩm là  #mi(`p = 50 - x`)  (nghìn đồng). Tính lợi nhuận tối đa.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Doanh thu:  #mi(`R(x) = x(50 - x) = 50x - x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = (50x - x^2) - (x^2 + 10x + 100) = -2x^2 + 40x - 100`) . Đạo hàm:  #mi(`P'(x) = -4x + 40`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 10`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Khi đó  #mi(`P(10) = -2(100) + 400 - 100 = 100`)  (nghìn đồng).
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tối ưu hóa lợi nhuận với hàm bậc ba:] Lợi nhuận của một công ty khi sản xuất  #mi(`x`)  sản phẩm được cho bởi công thức  #mi(`P(x) = -x^3 + 300x^2 - 1000`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Đạo hàm:  #mi(`P'(x) = -3x^2 + 600x = -3x(x - 200)`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 0`)  hoặc  #mi(`x = 200`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 200`) . Vậy sản lượng cần sản xuất là 200 sản phẩm.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tối ưu hóa chi phí trung bình:] Chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = x^2 + 10x + 100`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là nhỏ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Chi phí trung bình:  #mi(`\bar{C}(x) = \frac{C(x)}{x} = x + 10 + \frac{100}{x}`) . Đạo hàm:  #mi(`\bar{C}'(x) = 1 - \frac{100}{x^2}`) . Cho  #mi(`\bar{C}'(x) = 0 \Rightarrow x^2 = 100 \Rightarrow x = 10`)  (vì  #mi(`x > 0`) ). Lập bảng biến thiên,  #mi(`\bar{C}(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = 10`) . Khi đó  #mi(`\bar{C}(10) = 10 + 10 + 10 = 30`)  (nghìn đồng).
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một công ty bán  #mi(`x`)  sản phẩm với giá  #mi(`p = 120 - 3x`)  (nghìn đồng). Chi phí sản xuất là  #mi(`C(x) = 30x + 60`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(120 - 3x) = 120x - 3x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = -3x^2 + 90x - 60`) . Đạo hàm:  #mi(`P'(x) = -6x + 90`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 15`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 15`) . Vậy sản lượng cần bán là 15 sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một cửa hàng bán  #mi(`x`)  sản phẩm với giá  #mi(`p = 80 - 2x`)  (nghìn đồng). Chi phí sản xuất là  #mi(`C(x) = 10x + 40`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(80 - 2x) = 80x - 2x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = -2x^2 + 70x - 40`) . Đạo hàm:  #mi(`P'(x) = -4x + 70`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 17.5`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 17.5`) . Vậy sản lượng cần bán là 17.5 sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một doanh nghiệp sản xuất  #mi(`x`)  sản phẩm. Hàm chi phí là  #mi(`C(x) = x^2 + 20x + 200`)  (nghìn đồng). Giá bán mỗi sản phẩm là  #mi(`p = 60 - x`)  (nghìn đồng). Tính lợi nhuận tối đa.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Doanh thu:  #mi(`R(x) = x(60 - x) = 60x - x^2`) . Lợi nhuận:  #mi(`P(x) = R(x) - C(x) = -2x^2 + 40x - 200`) . Đạo hàm:  #mi(`P'(x) = -4x + 40`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 10`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) . Khi đó  #mi(`P(10) = -2(100) + 400 - 200 = 0`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Lợi nhuận của một công ty khi sản xuất  #mi(`x`)  sản phẩm được cho bởi công thức  #mi(`P(x) = -x^3 + 150x^2 - 2000`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để lợi nhuận lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Đạo hàm:  #mi(`P'(x) = -3x^2 + 300x = -3x(x - 100)`) . Cho  #mi(`P'(x) = 0 \Rightarrow x = 0`)  hoặc  #mi(`x = 100`) . Lập bảng biến thiên,  #mi(`P(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 100`) . Vậy sản lượng cần sản xuất là 100 sản phẩm.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Chi phí sản xuất  #mi(`x`)  sản phẩm là  #mi(`C(x) = x^2 + 20x + 400`)  (nghìn đồng). Tìm sản lượng  #mi(`x`)  để chi phí trung bình mỗi sản phẩm là nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Chi phí trung bình:  #mi(`\bar{C}(x) = \frac{C(x)}{x} = x + 20 + \frac{400}{x}`) . Đạo hàm:  #mi(`\bar{C}'(x) = 1 - \frac{400}{x^2}`) . Cho  #mi(`\bar{C}'(x) = 0 \Rightarrow x^2 = 400 \Rightarrow x = 20`)  (vì  #mi(`x > 0`) ). Lập bảng biến thiên,  #mi(`\bar{C}(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = 20`) . Khi đó  #mi(`\bar{C}(20) = 20 + 20 + 20 = 60`)  (nghìn đồng).] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 21: Bài toán tối ưu hóa trong hình học và vật lý ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 21. Bài toán tối ưu hóa trong hình học và vật lý]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Bước 1: Xác định đại lượng cần tối ưu (thể tích, diện tích, chi phí, lực...) và biến số  #mi(`x`)  (kích thước hình học hoặc đại lượng vật lý) kèm điều kiện xác định  #mi(`x \in D`) .
  - Bước 2: Biểu diễn đại lượng cần tối ưu thành hàm số  #mi(`f(x)`)  dựa trên các công thức hình học hoặc vật lý đã biết.
  - Bước 3: Tính đạo hàm  #mi(`f'(x)`) , tìm các điểm tới hạn trên  #mi(`D`) . Lập bảng biến thiên hoặc sử dụng quy tắc tìm GTLN, GTNN để kết luận.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Lập hàm - Tìm đạo hàm - Lập bảng biến thiên - Kết luận. Nhớ kiểm tra điều kiện của biến số thực tế (ví dụ: độ dài, khối lượng phải dương).
  ]
  - *Công thức cốt lõi:* Để tìm giá trị lớn nhất, nhỏ nhất của hàm số  #mi(`f(x)`)  trên khoảng  #mi(`(a;b)`) , ta tính  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = ...`)  để tìm các điểm tới hạn, sau đó lập ... và kết luận.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một hình chữ nhật có chu vi là  #mi(`20\text{ cm}`) . Tìm diện tích lớn nhất của hình chữ nhật đó.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 25]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi chiều dài là  #mi(`x`)  ( #mi(`0 < x < 10`) ), chiều rộng là  #mi(`10 - x`) . Diện tích  #mi(`S(x) = x(10 - x) = 10x - x^2`) . Ta có  #mi(`S'(x) = 10 - 2x = 0 \Leftrightarrow x = 5`) . Lập bảng biến thiên,  #mi(`S(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 5`) . Khi đó  #mi(`S_{max} = 5 \cdot 5 = 25\text{ cm}^2`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật có khối lượng  #mi(`m = 2\text{ kg}`)  chịu tác dụng của trọng lực. Lấy  #mi(`g = 9.8\text{ m/s}^2`) . Tính độ lớn trọng lực  #mi(`P`)  (làm tròn đến hàng phần chục).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 19.6]
      \ #text(fill: rgb("#334155"))[Lời giải: Trọng lực được tính theo công thức  #mi(`P = mg`) . Thay số:  #mi(`P = 2 \cdot 9.8 = 19.6\text{ N}`) . Vậy độ lớn trọng lực là  #mi(`19.6\text{ N}`) .]
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
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điều kiện:  #mi(`0 < x < 6`) . Cạnh đáy hộp là  #mi(`12 - 2x`) , chiều cao là  #mi(`x`) . Thể tích hộp:  #mi(`V(x) = x(12 - 2x)^2 = 4x^3 - 48x^2 + 144x`) . Đạo hàm:  #mi(`V'(x) = 12x^2 - 96x + 144 = 12(x^2 - 8x + 12)`) .  #mi(`V'(x) = 0 \Leftrightarrow x = 2`)  hoặc  #mi(`x = 6`)  (loại). Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 2`) . Vậy  #mi(`x = 2\text{ cm}`)  thì thể tích hộp lớn nhất.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tối ưu hóa chi phí xây dựng:] Người ta muốn xây một bể chứa nước dạng hình hộp chữ nhật không nắp có thể tích  #mi(`100\text{ m}^3`) . Đáy bể là hình vuông cạnh  #mi(`x\text{ (m)}`) , chiều cao  #mi(`h\text{ (m)}`) . Chi phí xây dựng đáy là  #mi(`200`)  nghìn đồng/m #mi(`^2`) , chi phí xây dựng mặt bên là  #mi(`100`)  nghìn đồng/m #mi(`^2`) . Tìm  #mi(`x`)  để chi phí xây dựng là nhỏ nhất.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Thể tích  #mi(`V = x^2h = 100 \Rightarrow h = \frac{100}{x^2}`) . Diện tích đáy:  #mi(`x^2`) , diện tích xung quanh:  #mi(`4xh = \frac{400}{x}`) . Tổng chi phí:  #mi(`C(x) = 200x^2 + 100 \cdot \frac{400}{x} = 200x^2 + \frac{40000}{x}`)  (nghìn đồng). Đạo hàm:  #mi(`C'(x) = 400x - \frac{40000}{x^2} = \frac{400(x^3 - 100)}{x^2}`) .  #mi(`C'(x) = 0 \Leftrightarrow x = \sqrt[3]{100}`) . Lập bảng biến thiên,  #mi(`C(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = \sqrt[3]{100}`) . Vậy  #mi(`x = \sqrt[3]{100}\text{ m}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán vật lý (lực căng dây):] Một vật có trọng lượng  #mi(`60\text{ N}`)  được treo bởi ba sợi dây giống hệt nhau, các sợi dây đôi một tạo với nhau một góc  #mi(`90^\circ`) . Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là các lực căng của ba sợi dây. Do tính đối xứng, độ lớn các lực căng bằng nhau:  #mi(`T_1 = T_2 = T_3 = T`) . Hợp lực của ba lực căng cân bằng với trọng lực  #mi(`\vec{P}`) :  #mi(`\vec{T}_1 + \vec{T}_2 + \vec{T}_3 + \vec{P} = \vec{0}`) . Vì ba vectơ  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  đôi một vuông góc và có cùng độ lớn  #mi(`T`) , hợp lực của chúng có độ lớn  #mi(`T\sqrt{3}`) . Do đó  #mi(`T\sqrt{3} = P = 60 \Rightarrow T = \frac{60}{\sqrt{3}} = 20\sqrt{3} \approx 34.6\text{ N}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tối ưu hóa chi phí sản xuất:] Một nhà sản xuất quạt điện nghiên cứu chi phí sản xuất thấy rằng để sản xuất  #mi(`x`)  cái quạt mỗi ngày, chi phí cho mỗi quạt là  #mi(`C(x) = 72\ln x + \left(\frac{30 - x}{2}\right)^2`)  (tính bằng trăm nghìn đồng) với công suất sản xuất tối thiểu là  #mi(`5`)  cái quạt mỗi ngày. Hỏi cần sản xuất bao nhiêu cái quạt mỗi ngày để giá thành của mỗi quạt ở mức tối thiểu?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Xét hàm số  #mi(`C(x) = 72\ln x + \frac{(30 - x)^2}{4}`)  với  #mi(`x \ge 5`) . Đạo hàm:  #mi(`C'(x) = \frac{72}{x} - \frac{30 - x}{2} = \frac{144 - x(30 - x)}{2x} = \frac{x^2 - 30x + 144}{2x}`) .  #mi(`C'(x) = 0 \Leftrightarrow x^2 - 30x + 144 = 0 \Leftrightarrow x = 6`)  hoặc  #mi(`x = 24`) . Lập bảng biến thiên trên  #mi(`[5; +\infty)`) , ta thấy  #mi(`C(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = 6`) . Vậy cần sản xuất  #mi(`6`)  cái quạt mỗi ngày.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một tấm nhôm hình vuông cạnh  #mi(`10\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện:  #mi(`0 < x < 5`) . Cạnh đáy hộp là  #mi(`10 - 2x`) , chiều cao là  #mi(`x`) . Thể tích:  #mi(`V(x) = x(10 - 2x)^2 = 4x^3 - 40x^2 + 100x`) . Đạo hàm:  #mi(`V'(x) = 12x^2 - 80x + 100 = 4(3x^2 - 20x + 25)`) .  #mi(`V'(x) = 0 \Leftrightarrow x = 5`)  (loại) hoặc  #mi(`x = \frac{5}{3}`) . Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = \frac{5}{3}\text{ cm}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một tấm nhôm hình vuông cạnh  #mi(`8\text{ cm}`) . Người ta cắt ở bốn góc bốn hình vuông bằng nhau, mỗi hình vuông có cạnh  #mi(`x\text{ (cm)}`) , rồi gập tấm nhôm lại để được một cái hộp không nắp. Tìm  #mi(`x`)  để thể tích của hộp là lớn nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện:  #mi(`0 < x < 4`) . Cạnh đáy hộp là  #mi(`8 - 2x`) , chiều cao là  #mi(`x`) . Thể tích:  #mi(`V(x) = x(8 - 2x)^2 = 4x^3 - 32x^2 + 64x`) . Đạo hàm:  #mi(`V'(x) = 12x^2 - 64x + 64 = 4(3x^2 - 16x + 16)`) .  #mi(`V'(x) = 0 \Leftrightarrow x = 4`)  (loại) hoặc  #mi(`x = \frac{4}{3}`) . Lập bảng biến thiên,  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = \frac{4}{3}\text{ cm}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Người ta muốn xây một bể chứa nước dạng hình hộp chữ nhật không nắp có thể tích  #mi(`500\text{ m}^3`) . Đáy bể là hình vuông cạnh  #mi(`x\text{ (m)}`) , chiều cao  #mi(`h\text{ (m)}`) . Chi phí xây dựng đáy là  #mi(`200`)  nghìn đồng/m #mi(`^2`) , chi phí xây dựng mặt bên là  #mi(`100`)  nghìn đồng/m #mi(`^2`) . Tìm  #mi(`x`)  để chi phí xây dựng là nhỏ nhất.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Thể tích  #mi(`V = x^2h = 500 \Rightarrow h = \frac{500}{x^2}`) . Diện tích đáy:  #mi(`x^2`) , diện tích xung quanh:  #mi(`4xh = \frac{2000}{x}`) . Tổng chi phí:  #mi(`C(x) = 200x^2 + 100 \cdot \frac{2000}{x} = 200x^2 + \frac{200000}{x}`)  (nghìn đồng). Đạo hàm:  #mi(`C'(x) = 400x - \frac{200000}{x^2} = \frac{400(x^3 - 500)}{x^2}`) .  #mi(`C'(x) = 0 \Leftrightarrow x = \sqrt[3]{500}`) . Lập bảng biến thiên,  #mi(`C(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = \sqrt[3]{500}\text{ m}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một vật có trọng lượng  #mi(`P = 30\text{ N}`)  được treo bởi ba sợi dây giống hệt nhau, các sợi dây đôi một tạo với nhau một góc  #mi(`90^\circ`) . Tính độ lớn lực căng của mỗi sợi dây.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  là các lực căng của ba sợi dây. Do tính đối xứng, độ lớn các lực căng bằng nhau:  #mi(`T_1 = T_2 = T_3 = T`) . Hợp lực của ba lực căng cân bằng với trọng lực  #mi(`\vec{P}`) :  #mi(`\vec{T}_1 + \vec{T}_2 + \vec{T}_3 + \vec{P} = \vec{0}`) . Vì ba vectơ  #mi(`\vec{T}_1, \vec{T}_2, \vec{T}_3`)  đôi một vuông góc và có cùng độ lớn  #mi(`T`) , hợp lực của chúng có độ lớn  #mi(`T\sqrt{3}`) . Do đó  #mi(`T\sqrt{3} = P = 30 \Rightarrow T = \frac{30}{\sqrt{3}} = 10\sqrt{3} \approx 17.3\text{ N}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một nhà sản xuất quạt điện nghiên cứu chi phí sản xuất thấy rằng để sản xuất  #mi(`x`)  cái quạt mỗi ngày, chi phí cho mỗi quạt là  #mi(`C(x) = 72\ln x + \left(\frac{30 - x}{2}\right)^2`)  (tính bằng trăm nghìn đồng) với công suất sản xuất tối thiểu là  #mi(`5`)  cái quạt mỗi ngày. Hỏi cần sản xuất bao nhiêu cái quạt mỗi ngày để giá thành của mỗi quạt ở mức tối thiểu?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Xét hàm số  #mi(`C(x) = 72\ln x + \frac{(30 - x)^2}{4}`)  với  #mi(`x \ge 5`) . Đạo hàm:  #mi(`C'(x) = \frac{72}{x} - \frac{30 - x}{2} = \frac{144 - x(30 - x)}{2x} = \frac{x^2 - 30x + 144}{2x}`) .  #mi(`C'(x) = 0 \Leftrightarrow x^2 - 30x + 144 = 0 \Leftrightarrow x = 6`)  hoặc  #mi(`x = 24`) . Lập bảng biến thiên trên  #mi(`[5; +\infty)`) , ta thấy  #mi(`C(x)`)  đạt giá trị nhỏ nhất tại  #mi(`x = 6`) . Vậy cần sản xuất  #mi(`6`)  cái quạt mỗi ngày.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 22: Bài toán thực tế tối ưu hóa (GTLN, GTNN) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 22. Bài toán thực tế tối ưu hóa (GTLN, GTNN)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - **Bước 1 - Đặt biến:** Gọi  #mi(`x`)  là đại lượng cần tìm (thường là số sản phẩm, giá bán, kích thước hình học, thời gian...). Đặt điều kiện cho  #mi(`x`)  dựa trên ngữ cảnh bài toán (ví dụ:  #mi(`x > 0`) ,  #mi(`x \in \mathbb{N}^*`) ,  #mi(`0 < x < a`) ...).
  - **Bước 2 - Thiết lập hàm số mục tiêu:** Biểu diễn đại lượng cần tối ưu (doanh thu, lợi nhuận, thể tích, diện tích, vận tốc...) theo biến  #mi(`x`) . Gọi hàm số đó là  #mi(`f(x)`) .
  - **Bước 3 - Tìm GTLN/GTNN:** Tính đạo hàm  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = 0`)  để tìm các điểm tới hạn. Lập bảng biến thiên hoặc sử dụng các quy tắc tìm GTLN/GTNN trên khoảng/nửa khoảng xác định của  #mi(`x`) .
  - **Bước 4 - Kết luận:** Dựa vào bảng biến thiên để kết luận giá trị lớn nhất hoặc nhỏ nhất của hàm số, từ đó trả lời câu hỏi thực tế.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ nhanh: 'Đặt biến - Lập hàm - Đạo hàm - Kết luận'. Luôn kiểm tra điều kiện thực tế của biến trước khi kết luận!
  ]
  - *Công thức cốt lõi:* Để tìm giá trị lớn nhất của hàm số  #mi(`f(x)`)  trên khoảng  #mi(`(a;b)`) , ta tính  #mi(`f'(x)`) , giải phương trình  #mi(`f'(x) = ...`)  để tìm các điểm tới hạn, sau đó lập ... và dựa vào đó để kết luận.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một cửa hàng bán áo với giá  #mi(`100`)  nghìn đồng/chiếc thì bán được  #mi(`100`)  chiếc mỗi ngày. Biết rằng cứ tăng giá thêm  #mi(`1`)  nghìn đồng thì số áo bán ra giảm đi  #mi(`1`)  chiếc. Hỏi cửa hàng nên bán với giá bao nhiêu nghìn đồng để doanh thu mỗi ngày là lớn nhất?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 100]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`x`)  (nghìn đồng) là giá bán mới của mỗi chiếc áo ( #mi(`x > 0`) ).\nSố áo bán được tương ứng là:  #mi(`100 - (x - 100) = 200 - x`)  (chiếc).\nDoanh thu mỗi ngày là:  #mi(`R(x) = x(200 - x) = -x^2 + 200x`) .\nXét hàm số  #mi(`R(x) = -x^2 + 200x`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`R'(x) = -2x + 200`) . Cho  #mi(`R'(x) = 0 \Leftrightarrow x = 100`) .\nBảng biến thiên cho thấy  #mi(`R(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 100`) .\nVậy cửa hàng nên bán với giá  #mi(`100`)  nghìn đồng/chiếc.]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một tấm bìa hình chữ nhật có chu vi  #mi(`40`)  cm. Người ta cắt bỏ bốn góc của tấm bìa đó để tạo thành một hình hộp chữ nhật không nắp. Hỏi thể tích lớn nhất của hình hộp có thể tạo thành là bao nhiêu cm #mi(`^3`) ? (Làm tròn đến hàng phần trăm).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 74.07]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi  #mi(`x`)  (cm) là độ dài cạnh hình vuông bị cắt bỏ ( #mi(`0 < x < 10`) ).\nNửa chu vi tấm bìa là  #mi(`20`)  cm. Gọi chiều dài và chiều rộng ban đầu là  #mi(`a, b`)  với  #mi(`a+b=20`) . Để thể tích lớn nhất, tấm bìa ban đầu phải là hình vuông cạnh  #mi(`10`)  cm (do thể tích hình hộp là  #mi(`V = x(10-2x)^2`) ).\nThể tích hình hộp là:  #mi(`V(x) = x(10 - 2x)^2 = 4x^3 - 40x^2 + 100x`) .\nXét hàm số  #mi(`V(x)`)  trên  #mi(`(0; 5)`) .
 #mi(`V'(x) = 12x^2 - 80x + 100 = 4(3x^2 - 20x + 25)`) .
 #mi(`V'(x) = 0 \Leftrightarrow 3x^2 - 20x + 25 = 0 \Leftrightarrow x = 5`)  (loại) hoặc  #mi(`x = \frac{5}{3}`) .\nLập bảng biến thiên, ta thấy  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = \frac{5}{3}`) .
 #mi(`V_{max} = \frac{5}{3} \left(10 - \frac{10}{3}\right)^2 = \frac{5}{3} \cdot \left(\frac{20}{3}\right)^2 = \frac{2000}{27} \approx 74.07`)  cm #mi(`^3`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Một vật chuyển động theo quy luật  #mi(`s(t) = -\frac{1}{3}t^3 + 4t^2 + 9t`) , với  #mi(`t`)  (giây) là khoảng thời gian tính từ khi vật bắt đầu chuyển động và  #mi(`s`)  (mét) là quãng đường vật di chuyển được trong khoảng thời gian đó. Hỏi vận tốc lớn nhất của vật đạt được là bao nhiêu m/s?
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 25]
      \ #text(fill: rgb("#334155"))[Lời giải: Vận tốc của vật tại thời điểm  #mi(`t`)  là:  #mi(`v(t) = s'(t) = -t^2 + 8t + 9`)  (m/s).\nXét hàm số  #mi(`v(t) = -t^2 + 8t + 9`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`v'(t) = -2t + 8`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow t = 4`) .\nBảng biến thiên cho thấy  #mi(`v(t)`)  đạt giá trị lớn nhất tại  #mi(`t = 4`) .
 #mi(`v_{max} = v(4) = -16 + 32 + 9 = 25`)  m/s.]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Bài toán doanh thu:] Một cửa hàng bán quần áo nhập một loại áo với giá  #mi(`20`)  nghìn đồng/chiếc. Hiện tại cửa hàng đang bán với giá  #mi(`30`)  nghìn đồng/chiếc và bán được  #mi(`100`)  chiếc mỗi ngày. Theo khảo sát, nếu cửa hàng giảm giá bán mỗi chiếc  #mi(`1`)  nghìn đồng thì số áo bán ra sẽ tăng thêm  #mi(`2`)  chiếc mỗi ngày. Hỏi cửa hàng nên bán với giá bao nhiêu để doanh thu mỗi ngày là lớn nhất?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  (nghìn đồng) là giá bán mới của mỗi chiếc áo ( #mi(`20 \le x \le 50`) ).\nSố tiền giảm giá là  #mi(`30 - x`)  (nghìn đồng).\nSố áo bán ra tương ứng là:  #mi(`100 + 2(30 - x) = 160 - 2x`)  (chiếc).\nDoanh thu mỗi ngày là:  #mi(`R(x) = x(160 - 2x) = -2x^2 + 160x`) .\nXét hàm số  #mi(`R(x) = -2x^2 + 160x`)  trên  #mi(`[20; 50]`) .\nTa có  #mi(`R'(x) = -4x + 160`) . Cho  #mi(`R'(x) = 0 \Leftrightarrow x = 40`) .\nTính các giá trị:  #mi(`R(20) = 2400`) ,  #mi(`R(40) = 3200`) ,  #mi(`R(50) = 3000`) .\nVậy doanh thu lớn nhất là  #mi(`3200`)  nghìn đồng khi  #mi(`x = 40`) .\nCửa hàng nên bán với giá  #mi(`40`)  nghìn đồng/chiếc.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Bài toán lợi nhuận:] Một công ty sản xuất và bán một loại sản phẩm. Chi phí để sản xuất  #mi(`x`)  sản phẩm được cho bởi công thức  #mi(`C(x) = x^2 + 10x + 100`)  (nghìn đồng). Giá bán của mỗi sản phẩm được xác định bởi hàm cầu  #mi(`p = 50 - x`)  (nghìn đồng). Hỏi công ty cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận thu được là lớn nhất?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi  #mi(`x`)  là số sản phẩm công ty sản xuất và bán ra ( #mi(`x > 0`) ).\nDoanh thu khi bán  #mi(`x`)  sản phẩm là:  #mi(`R(x) = x \cdot p = x(50 - x) = 50x - x^2`) .\nLợi nhuận thu được là:  #mi(`L(x) = R(x) - C(x) = (50x - x^2) - (x^2 + 10x + 100) = -2x^2 + 40x - 100`) .\nXét hàm số  #mi(`L(x) = -2x^2 + 40x - 100`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`L'(x) = -4x + 40`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow x = 10`) .\nBảng biến thiên cho thấy  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) .\nVậy công ty cần sản xuất và bán  #mi(`10`)  sản phẩm để lợi nhuận lớn nhất.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán tối ưu hình học (Thể tích):] Một tấm nhôm hình vuông cạnh  #mi(`12`)  cm. Người ta cắt ở bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh bằng  #mi(`x`)  (cm), rồi gập tấm nhôm lại như hình vẽ để được một cái hộp không nắp. Tính thể tích lớn nhất của cái hộp.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Điều kiện:  #mi(`0 < x < 6`) .\nCạnh đáy của hình hộp là:  #mi(`12 - 2x`)  (cm).\nThể tích của hình hộp là:  #mi(`V(x) = x(12 - 2x)^2 = x(144 - 48x + 4x^2) = 4x^3 - 48x^2 + 144x`) .\nXét hàm số  #mi(`V(x) = 4x^3 - 48x^2 + 144x`)  trên  #mi(`(0; 6)`) .\nTa có  #mi(`V'(x) = 12x^2 - 96x + 144 = 12(x^2 - 8x + 12)`) .\nCho  #mi(`V'(x) = 0 \Leftrightarrow x^2 - 8x + 12 = 0 \Leftrightarrow x = 2`)  hoặc  #mi(`x = 6`)  (loại).\nBảng biến thiên cho thấy  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 2`) .
 #mi(`V_{max} = V(2) = 2(12 - 4)^2 = 2 \cdot 64 = 128`)  cm #mi(`^3`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán vật lý (Vận tốc):] Một vật chuyển động theo quy luật  #mi(`s(t) = -t^3 + 6t^2 + 15t`) , với  #mi(`t`)  (giây) là khoảng thời gian tính từ khi vật bắt đầu chuyển động và  #mi(`s`)  (mét) là quãng đường vật di chuyển được trong khoảng thời gian đó. Hỏi vận tốc của vật đạt giá trị lớn nhất tại thời điểm nào?
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vận tốc của vật tại thời điểm  #mi(`t`)  là:  #mi(`v(t) = s'(t) = -3t^2 + 12t + 15`)  (m/s).\nXét hàm số  #mi(`v(t) = -3t^2 + 12t + 15`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`v'(t) = -6t + 12`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow t = 2`) .\nBảng biến thiên cho thấy  #mi(`v(t)`)  đạt giá trị lớn nhất tại  #mi(`t = 2`) .\nVậy vận tốc của vật đạt giá trị lớn nhất tại thời điểm  #mi(`t = 2`)  giây.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một cửa hàng bán trà sữa với giá  #mi(`40`)  nghìn đồng/ly thì bán được  #mi(`200`)  ly mỗi ngày. Biết rằng cứ tăng giá thêm  #mi(`2`)  nghìn đồng thì số ly bán ra giảm đi  #mi(`10`)  ly. Hỏi cửa hàng nên bán với giá bao nhiêu nghìn đồng để doanh thu mỗi ngày là lớn nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  (nghìn đồng) là giá bán mới của mỗi ly trà sữa ( #mi(`x > 0`) ).\nSố tiền tăng giá là  #mi(`x - 40`)  (nghìn đồng).\nSố ly trà sữa bán ra tương ứng là:  #mi(`200 - 10 \cdot \frac{x - 40}{2} = 200 - 5(x - 40) = 400 - 5x`)  (ly).\nDoanh thu mỗi ngày là:  #mi(`R(x) = x(400 - 5x) = -5x^2 + 400x`) .\nXét hàm số  #mi(`R(x) = -5x^2 + 400x`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`R'(x) = -10x + 400`) . Cho  #mi(`R'(x) = 0 \Leftrightarrow x = 40`) .\nBảng biến thiên cho thấy  #mi(`R(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 40`) .\nVậy cửa hàng nên bán với giá  #mi(`40`)  nghìn đồng/ly.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một cửa hàng bán bánh mì với giá  #mi(`20`)  nghìn đồng/chiếc thì bán được  #mi(`150`)  chiếc mỗi ngày. Biết rằng cứ tăng giá thêm  #mi(`1`)  nghìn đồng thì số bánh bán ra giảm đi  #mi(`5`)  chiếc. Hỏi cửa hàng nên bán với giá bao nhiêu nghìn đồng để doanh thu mỗi ngày là lớn nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  (nghìn đồng) là giá bán mới của mỗi chiếc bánh mì ( #mi(`x > 0`) ).\nSố tiền tăng giá là  #mi(`x - 20`)  (nghìn đồng).\nSố bánh mì bán ra tương ứng là:  #mi(`150 - 5(x - 20) = 250 - 5x`)  (chiếc).\nDoanh thu mỗi ngày là:  #mi(`R(x) = x(250 - 5x) = -5x^2 + 250x`) .\nXét hàm số  #mi(`R(x) = -5x^2 + 250x`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`R'(x) = -10x + 250`) . Cho  #mi(`R'(x) = 0 \Leftrightarrow x = 25`) .\nBảng biến thiên cho thấy  #mi(`R(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 25`) .\nVậy cửa hàng nên bán với giá  #mi(`25`)  nghìn đồng/chiếc.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một công ty sản xuất và bán một loại sản phẩm. Chi phí để sản xuất  #mi(`x`)  sản phẩm được cho bởi công thức  #mi(`C(x) = 2x^2 + 20x + 50`)  (nghìn đồng). Giá bán của mỗi sản phẩm được xác định bởi hàm cầu  #mi(`p = 100 - 2x`)  (nghìn đồng). Hỏi công ty cần sản xuất và bán bao nhiêu sản phẩm để lợi nhuận thu được là lớn nhất?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi  #mi(`x`)  là số sản phẩm công ty sản xuất và bán ra ( #mi(`x > 0`) ).\nDoanh thu khi bán  #mi(`x`)  sản phẩm là:  #mi(`R(x) = x \cdot p = x(100 - 2x) = 100x - 2x^2`) .\nLợi nhuận thu được là:  #mi(`L(x) = R(x) - C(x) = (100x - 2x^2) - (2x^2 + 20x + 50) = -4x^2 + 80x - 50`) .\nXét hàm số  #mi(`L(x) = -4x^2 + 80x - 50`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`L'(x) = -8x + 80`) . Cho  #mi(`L'(x) = 0 \Leftrightarrow x = 10`) .\nBảng biến thiên cho thấy  #mi(`L(x)`)  đạt giá trị lớn nhất tại  #mi(`x = 10`) .\nVậy công ty cần sản xuất và bán  #mi(`10`)  sản phẩm để lợi nhuận lớn nhất.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một tấm nhôm hình vuông cạnh  #mi(`20`)  cm. Người ta cắt ở bốn góc của tấm nhôm đó bốn hình vuông bằng nhau, mỗi hình vuông có cạnh bằng  #mi(`x`)  (cm), rồi gập tấm nhôm lại để được một cái hộp không nắp. Tính thể tích lớn nhất của cái hộp.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Điều kiện:  #mi(`0 < x < 10`) .\nCạnh đáy của hình hộp là:  #mi(`20 - 2x`)  (cm).\nThể tích của hình hộp là:  #mi(`V(x) = x(20 - 2x)^2 = x(400 - 80x + 4x^2) = 4x^3 - 80x^2 + 400x`) .\nXét hàm số  #mi(`V(x) = 4x^3 - 80x^2 + 400x`)  trên  #mi(`(0; 10)`) .\nTa có  #mi(`V'(x) = 12x^2 - 160x + 400 = 4(3x^2 - 40x + 100)`) .\nCho  #mi(`V'(x) = 0 \Leftrightarrow 3x^2 - 40x + 100 = 0 \Leftrightarrow x = 10`)  (loại) hoặc  #mi(`x = \frac{10}{3}`) .\nBảng biến thiên cho thấy  #mi(`V(x)`)  đạt giá trị lớn nhất tại  #mi(`x = \frac{10}{3}`) .
 #mi(`V_{max} = V\left(\frac{10}{3}\right) = \frac{10}{3}\left(20 - \frac{20}{3}\right)^2 = \frac{10}{3} \cdot \left(\frac{40}{3}\right)^2 = \frac{16000}{27} \approx 592.59`)  cm #mi(`^3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 5 (Củng cố).*] else [*Bài 5.*] Một vật chuyển động theo quy luật  #mi(`s(t) = -\frac{1}{2}t^3 + 3t^2 + 10t`) , với  #mi(`t`)  (giây) là khoảng thời gian tính từ khi vật bắt đầu chuyển động và  #mi(`s`)  (mét) là quãng đường vật di chuyển được trong khoảng thời gian đó. Hỏi vận tốc của vật đạt giá trị lớn nhất tại thời điểm nào?
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vận tốc của vật tại thời điểm  #mi(`t`)  là:  #mi(`v(t) = s'(t) = -\frac{3}{2}t^2 + 6t + 10`)  (m/s).\nXét hàm số  #mi(`v(t) = -\frac{3}{2}t^2 + 6t + 10`)  trên  #mi(`(0; +\infty)`) .\nTa có  #mi(`v'(t) = -3t + 6`) . Cho  #mi(`v'(t) = 0 \Leftrightarrow t = 2`) .\nBảng biến thiên cho thấy  #mi(`v(t)`)  đạt giá trị lớn nhất tại  #mi(`t = 2`) .\nVậy vận tốc của vật đạt giá trị lớn nhất tại thời điểm  #mi(`t = 2`)  giây.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
