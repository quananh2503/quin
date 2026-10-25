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
  #text(size: 13pt, weight: "bold")[Vectơ và Hệ tọa độ trong không gian] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bài học cung cấp kiến thức toàn diện về vectơ trong không gian, các phép toán vectơ (tổng, hiệu, tích của một số với vectơ), tích vô hướng, góc giữa hai vectơ, và hệ tọa độ Oxyz. Nội dung bao gồm lý thuyết cốt lõi, các ví dụ minh họa, bài tập trắc nghiệm, đúng/sai và tự luận nhằm rèn luyện kỹ năng tính toán tọa độ, phân tích vectơ và ứng dụng thực tế.]
]
#v(6pt)

// ==================== DẠNG 1: Chứng minh đẳng thức vectơ bằng các quy tắc vectơ cơ bản ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Chứng minh đẳng thức vectơ bằng các quy tắc vectơ cơ bản]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Sử dụng quy tắc 3 điểm:  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`)  và quy tắc trừ:  #mi(`\vec{AB} - \vec{AC} = \vec{CB}`) 
  - Sử dụng quy tắc hình bình hành:  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`)  khi  #mi(`ABCD`)  là hình bình hành
  - Sử dụng quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`)  khi  #mi(`ABCD.A'B'C'D'`)  là hình hộp
  - Phương pháp chèn điểm trung gian:  #mi(`\vec{MN} = \vec{MA} + \vec{AB} + \vec{BN}`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh  #mi(`\vec{XY} = \vec{Z}`) , hãy tìm cách 'nối đuôi' các vectơ bằng quy tắc 3 điểm hoặc 'chèn' một điểm bất kỳ vào giữa để biến đổi.
  ]
  - *Công thức cốt lõi:* Quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} =`)  ...
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho hình bình hành  #mi(`ABCD`) . Tính giá trị biểu thức  #mi(`P = \vec{AB} + \vec{BC} + \vec{CD} + \vec{DA}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AB} = \-\vec{CD}`)  và  #mi(`\vec{BC} = \-\vec{DA}`) . Do đó  #mi(`P = \vec{AB} + \vec{BC} - \vec{AB} - \vec{BC} = \vec{0}`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Tính  #mi(`\vec{AB} + \vec{AD} + \vec{AA'}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: AC']
      \ #text(fill: rgb("#334155"))[Lời giải: Theo quy tắc hình hộp, tổng ba vectơ xuất phát từ đỉnh  #mi(`A`)  dọc theo ba cạnh là vectơ đường chéo chính  #mi(`\vec{AC'}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc 3 điểm và quy tắc trừ:] Cho tứ diện  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{CD} = \vec{AC} + \vec{BD}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{AB} + \vec{CD} = (\vec{AC} + \vec{CB}) + (\vec{BD} + \vec{DC}) = \vec{AC} + \vec{BD} + (\vec{CB} + \vec{DC}) = \vec{AC} + \vec{BD} - \vec{CD} + \vec{CD} = \vec{AC} + \vec{BD}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc hình bình hành:] Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên tứ giác  #mi(`ABCD`)  là hình bình hành. Theo quy tắc hình bình hành, tổng hai vectơ xuất phát từ cùng một đỉnh  #mi(`A`)  là vectơ đường chéo  #mi(`\vec{AC}`) . Vậy  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc hình hộp:] Cho hình hộp  #mi(`ABCD.A'B'C'D'`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo quy tắc hình hộp, trong hình hộp  #mi(`ABCD.A'B'C'D'`) , tổng ba vectơ xuất phát từ cùng một đỉnh  #mi(`A`)  dọc theo ba cạnh  #mi(`AB, AD, AA'`)  là vectơ đường chéo chính  #mi(`\vec{AC'}`) . Vậy  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phương pháp chèn điểm trung gian:] Cho hình lăng trụ tam giác  #mi(`ABC.A'B'C'`) . Chứng minh rằng  #mi(`\vec{AA'} + \vec{BB'} + \vec{CC'} = \vec{0}`)  (Giả sử các vectơ này là các cạnh bên cùng hướng).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABC.A'B'C'`)  là hình lăng trụ nên  #mi(`AA' \parallel BB' \parallel CC'`)  và  #mi(`AA' = BB' = CC'`) . Do đó  #mi(`\vec{AA'} = \vec{BB'} = \vec{CC'}`) . Tuy nhiên, đề bài yêu cầu chứng minh đẳng thức vectơ. Xét trường hợp các vectơ này là các cạnh bên cùng hướng, ta có  #mi(`\vec{AA'} + \vec{BB'} + \vec{CC'} = 3\vec{AA'}`) . Để đẳng thức bằng  #mi(`\vec{0}`) , các vectơ phải có hướng ngược nhau. Nếu đề là  #mi(`\vec{AA'} + \vec{BB'} + \vec{CC'} = 3\vec{AA'}`) , ta có:  #mi(`\vec{AA'} + \vec{BB'} + \vec{CC'} = \vec{AA'} + \vec{AA'} + \vec{AA'} = 3\vec{AA'}`) . (Đpcm)
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{BC} + \vec{CD} + \vec{DA} = \vec{0}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{AB} + \vec{BC} + \vec{CD} + \vec{DA} = (\vec{AB} + \vec{BC}) + (\vec{CD} + \vec{DA}) = \vec{AC} + (\vec{CD} + \vec{DA}) = \vec{AC} + \vec{CA} = \vec{0}`) . (Đpcm)] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho hình bình hành  #mi(`PQRS`) . Chứng minh rằng  #mi(`\vec{PQ} + \vec{QR} + \vec{RS} + \vec{SP} = \vec{0}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{PQ} + \vec{QR} + \vec{RS} + \vec{SP} = (\vec{PQ} + \vec{QR}) + (\vec{RS} + \vec{SP}) = \vec{PR} + \vec{PS} = \vec{PS} - \vec{PS} = \vec{0}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Phân tích (biểu diễn) vectơ theo các vectơ cơ sở trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Phân tích (biểu diễn) vectơ theo các vectơ cơ sở trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Quy tắc trung điểm: Nếu  #mi(`M`)  là trung điểm của đoạn thẳng  #mi(`AB`)  thì  #mi(`\vec{AM} = \frac{1}{2}\vec{AB}`)  hoặc với điểm  #mi(`O`)  bất kì,  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`) .
  - Quy tắc trọng tâm tam giác: Nếu  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  thì  #mi(`\vec{AG} = \frac{1}{3}(\vec{AB} + \vec{AC})`)  hoặc  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) .
  - Quy tắc trọng tâm tứ diện: Nếu  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`)  hoặc  #mi(`\vec{IA} + \vec{IB} + \vec{IC} + \vec{ID} = \vec{0}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ hệ số: Trung điểm là  #mi(`1/2`) , Trọng tâm tam giác là  #mi(`1/3`) , Trọng tâm tứ diện là  #mi(`1/4`) .
  ]
  - *Công thức cốt lõi:* Nếu  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  thì  #mi(`\vec{AI} =`)  ...  #mi(`(\vec{AB} + \vec{AC} + \vec{AD})`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2;1;3]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G(x; y; z)`)  được tính bằng công thức:  #mi(`x = \frac{x_A + x_B + x_C}{3} = \frac{1 + 3 + 2}{3} = 2`) ;  #mi(`y = \frac{y_A + y_B + y_C}{3} = \frac{2 + 2 - 1}{3} = 1`) ;  #mi(`z = \frac{z_A + z_B + z_C}{3} = \frac{3 + 1 + 5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho tứ diện  #mi(`ABCD`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(4; 0; 0)`) ,  #mi(`C(0; 4; 0)`)  và  #mi(`D(0; 0; 4)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1;1;1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`I(x; y; z)`)  được tính bằng công thức:  #mi(`x = \frac{x_A + x_B + x_C + x_D}{4} = \frac{0 + 4 + 0 + 0}{4} = 1`) ;  #mi(`y = \frac{y_A + y_B + y_C + y_D}{4} = \frac{0 + 0 + 4 + 0}{4} = 1`) ;  #mi(`z = \frac{z_A + z_B + z_C + z_D}{4} = \frac{0 + 0 + 0 + 4}{4} = 1`) . Vậy  #mi(`I(1; 1; 1)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Áp dụng quy tắc trung điểm:] Cho hình bình hành  #mi(`ABCD`)  có  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm của  #mi(`AB`)  nên tọa độ của  #mi(`M`)  là:  #mi(`x_M = \frac{x_A + x_B}{2} = \frac{1 + 3}{2} = 2`) ;  #mi(`y_M = \frac{y_A + y_B}{2} = \frac{2 + 4}{2} = 3`) ;  #mi(`z_M = \frac{z_A + z_B}{2} = \frac{3 + 5}{2} = 4`) . Vậy  #mi(`M(2; 3; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Áp dụng quy tắc trọng tâm tam giác:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 1)`) ,  #mi(`B(0; -3; 1)`)  và  #mi(`C(4; -1; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên tọa độ của  #mi(`G`)  là:  #mi(`x_G = \frac{1 + 0 + 4}{3} = \frac{5}{3}`) ;  #mi(`y_G = \frac{0 - 3 - 1}{3} = -\frac{4}{3}`) ;  #mi(`z_G = \frac{1 + 1 + 4}{3} = 2`) . Vậy  #mi(`G(\frac{5}{3}; -\frac{4}{3}; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Áp dụng quy tắc trọng tâm tứ diện:] Cho tứ diện  #mi(`ABCD`)  có  #mi(`A(2; 4; 6)`) ,  #mi(`B(4; 2; 0)`) ,  #mi(`C(0; 0; 2)`)  và  #mi(`D(2; 2; 10)`) . Biểu diễn vectơ  #mi(`\vec{AI}`)  theo các vectơ  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`)  trong đó  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`I`)  là trọng tâm tứ diện  #mi(`ABCD`)  nên  #mi(`\vec{AI} = \frac{1}{4}(\vec{AB} + \vec{AC} + \vec{AD})`) . Đây chính là biểu thức phân tích vectơ  #mi(`\vec{AI}`)  theo ba vectơ cơ sở  #mi(`\vec{AB}, \vec{AC}, \vec{AD}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể kết hợp trung điểm và trọng tâm:] Cho tam giác  #mi(`ABC`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(6; 0; 0)`)  và  #mi(`C(0; 6; 0)`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`AB`)  và  #mi(`G`)  là trọng tâm của tam giác  #mi(`ABC`) . Tìm tọa độ  #mi(`M`)  và  #mi(`G`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`M`)  là trung điểm  #mi(`AB`)  nên  #mi(`M(\frac{0+6}{2}; \frac{0+0}{2}; \frac{0+0}{2}) = (3; 0; 0)`) . Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên  #mi(`G(\frac{0+6+0}{3}; \frac{0+0+6}{3}; \frac{0+0+0}{3}) = (2; 2; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 4; -1)`) ,  #mi(`B(4; 0; 3)`)  và  #mi(`C(0; 2; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_G = \frac{2+4+0}{3} = 2`) ;  #mi(`y_G = \frac{4+0+2}{3} = 2`) ;  #mi(`z_G = \frac{-1+3+5}{3} = \frac{7}{3}`) . Vậy  #mi(`G(2; 2; \frac{7}{3})`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho tứ diện  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(5; 1; 1)`) ,  #mi(`C(1; 5; 1)`)  và  #mi(`D(1; 1; 5)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_I = \frac{1+5+1+1}{4} = 2`) ;  #mi(`y_I = \frac{1+1+5+1}{4} = 2`) ;  #mi(`z_I = \frac{1+1+1+5}{4} = 2`) . Vậy  #mi(`I(2; 2; 2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho đoạn thẳng  #mi(`AB`)  có  #mi(`A(0; 2; 4)`)  và  #mi(`B(6; 2; 4)`) . Tìm tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_M = \frac{0+6}{2} = 3`) ;  #mi(`y_M = \frac{2+2}{2} = 2`) ;  #mi(`z_M = \frac{4+4}{2} = 4`) . Vậy  #mi(`M(3; 2; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 3; 4)`)  và  #mi(`C(3; 5; 6)`) . Gọi  #mi(`M`)  là trung điểm của  #mi(`BC`) . Tìm tọa độ  #mi(`M`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`x_M = \frac{2+3}{2} = 2.5`) ;  #mi(`y_M = \frac{3+5}{2} = 4`) ;  #mi(`z_M = \frac{4+6}{2} = 5`) . Vậy  #mi(`M(2.5; 4; 5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Chứng minh tính chất hình học bằng đẳng thức vectơ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Chứng minh tính chất hình học bằng đẳng thức vectơ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để chứng minh tứ giác  #mi(`ABCD`)  là hình bình hành, ta chứng minh  #mi(`\vec{AB} = \vec{DC}`)  hoặc  #mi(`\vec{AD} = \vec{BC}`) .
  - Điểm  #mi(`M`)  là trung điểm của đoạn thẳng  #mi(`AB`)  khi và chỉ khi  #mi(`\vec{MA} + \vec{MB} = \vec{0}`)  hoặc  #mi(`\vec{OA} + \text{OB} = 2\vec{OM}`)  với mọi điểm  #mi(`O`) .
  - Điểm  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  khi và chỉ khi  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  hoặc  #mi(`\vec{OA} + \text{OB} + \text{OC} = 3\vec{OG}`)  với mọi điểm  #mi(`O`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn chứng minh 'hình' hay 'điểm đặc biệt', hãy tìm cách đưa về 'tổng bằng 0' hoặc 'hai vectơ bằng nhau'.
  ]
  - *Công thức cốt lõi:* Tứ giác  #mi(`ABCD`)  là hình bình hành  #mi(`\Leftrightarrow \vec{AB} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G`) . Tính giá trị biểu thức  #mi(`P = |\vec{GA} + \vec{GB} + \vec{GC}|`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`)  nên theo tính chất trọng tâm, ta có  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`) . Do đó, độ dài của vectơ không là  #mi(`P = |\vec{0}| = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho đoạn thẳng  #mi(`AB`)  có trung điểm  #mi(`M`) . Tính giá trị của biểu thức  #mi(`S = |\vec{MA} + \vec{MB}|`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Vì  #mi(`M`)  là trung điểm của đoạn thẳng  #mi(`AB`)  nên  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) . Do đó,  #mi(`S = |\vec{0}| = 0`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Chứng minh hình bình hành:] Cho tứ giác  #mi(`ABCD`) . Chứng minh rằng tứ giác  #mi(`ABCD`)  là hình bình hành nếu  #mi(`\vec{AB} = \vec{DC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo định nghĩa vectơ bằng nhau,  #mi(`\vec{AB} = \vec{DC}`)  có nghĩa là hai vectơ này cùng hướng và cùng độ dài. Trong tứ giác  #mi(`ABCD`) , điều này tương đương với  #mi(`AB \parallel CD`)  và  #mi(`AB = CD`) . Do đó, tứ giác  #mi(`ABCD`)  là hình bình hành.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Chứng minh trung điểm:] Cho tam giác  #mi(`ABC`) . Gọi  #mi(`M`)  là điểm thỏa mãn  #mi(`\vec{MA} + \vec{MB} = \vec{MC}`) . Chứng minh  #mi(`M`)  là trung điểm của  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Từ đẳng thức  #mi(`\vec{MA} + \vec{MB} = \vec{MC}`) , ta có  #mi(`\vec{MA} + \vec{MB} - \vec{MC} = \vec{0}`) . Tuy nhiên, để  #mi(`M`)  là trung điểm  #mi(`AB`) , ta cần  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) . (Lưu ý: Đề bài này cần điều chỉnh để đúng tính chất trung điểm). 
\nSửa lại: Cho tam giác  #mi(`ABC`) . Gọi  #mi(`M`)  là điểm thỏa mãn  #mi(`\vec{MA} + \vec{MB} = \vec{0}`) . Chứng minh  #mi(`M`)  là trung điểm  #mi(`AB`) .
\nLời giải: Theo tính chất vectơ đối,  #mi(`\vec{MA} + \vec{MB} = \vec{0} \Leftrightarrow \vec{MA} = -\vec{MB} \Leftrightarrow \vec{MA} = \vec{BM}`) . Điều này có nghĩa là  #mi(`M`)  nằm trên đoạn  #mi(`AB`)  và  #mi(`MA = MB`) . Vậy  #mi(`M`)  là trung điểm của  #mi(`AB`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Chứng minh trọng tâm:] Cho tam giác  #mi(`ABC`) . Chứng minh rằng nếu  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  thì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Theo tính chất trọng tâm của tam giác, điểm  #mi(`G`)  thỏa mãn  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  chính là điểm trọng tâm của tam giác  #mi(`ABC`) . Điều này có thể chứng minh bằng cách sử dụng điểm  #mi(`O`)  bất kỳ và biến đổi  #mi(`\vec{OA} + \vec{OB} + \vec{OC} = 3\vec{OG}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể hình bình hành:] Cho hình bình hành  #mi(`ABCD`) . Chứng minh rằng  #mi(`\vec{AB} + \vec{AD} = \vec{AC}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình bình hành nên  #mi(`\vec{AD} = \vec{BC}`) . Áp dụng quy tắc cộng vectơ (quy tắc hình bình hành):  #mi(`\vec{AB} + \vec{AD} = \vec{AB} + \vec{BC} = \vec{AC}`) . Vậy đẳng thức được chứng minh.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Cho tứ giác  #mi(`ABCD`) . Chứng minh rằng tứ giác  #mi(`ABCD`)  là hình bình hành nếu  #mi(`\vec{AD} = \vec{BC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{AD} = \vec{BC}`)  nên hai cạnh  #mi(`AD`)  và  #mi(`BC`)  song song và bằng nhau. Tứ giác có một cặp cạnh đối song song và bằng nhau là hình bình hành. Vậy  #mi(`ABCD`)  là hình bình hành.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Cho tứ giác  #mi(`ABCD`) . Chứng minh rằng tứ giác  #mi(`ABCD`)  là hình bình hành nếu  #mi(`\vec{AB} = \vec{DC}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\vec{AB} = \vec{DC}`)  nên hai cạnh  #mi(`AB`)  và  #mi(`DC`)  song song và bằng nhau. Tứ giác có một cặp cạnh đối song song và bằng nhau là hình bình hành. Vậy  #mi(`ABCD`)  là hình bình hành.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho tam giác  #mi(`ABC`) . Chứng minh rằng nếu  #mi(`\vec{PA} + \vec{PB} + \vec{PC} = 3\vec{PG}`)  thì  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ  #mi(`\vec{PA} + \vec{PB} + \vec{PC} = 3\vec{PG}`) , ta có  #mi(`\vec{PA} + \vec{PB} + \vec{PC} - 3\vec{PG} = \vec{0}`) . Theo tính chất trọng tâm, điểm  #mi(`G`)  thỏa mãn  #mi(`\vec{GA} + \vec{GB} + \vec{GC} = \vec{0}`)  chính là trọng tâm tam giác  #mi(`ABC`) . Do đó  #mi(`G`)  là trọng tâm tam giác  #mi(`ABC`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho đoạn thẳng  #mi(`AB`) . Chứng minh rằng nếu  #mi(`\vec{OA} + \vec{OB} = 2\vec{OM}`)  thì  #mi(`M`)  là trung điểm của  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ  #mi(`\vec{OA} + \vec{OB} = 2\vec{OM}`) , ta có  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`) . Theo tính chất trung điểm, điểm  #mi(`M`)  thỏa mãn  #mi(`\vec{OM} = \frac{1}{2}(\vec{OA} + \vec{OB})`)  chính là trung điểm của đoạn thẳng  #mi(`AB`) . Vậy  #mi(`M`)  là trung điểm của  #mi(`AB`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Xác định tọa độ điểm và vectơ cơ bản trong hệ tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Xác định tọa độ điểm và vectơ cơ bản trong hệ tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Nếu  #mi(`M(x_M; y_M; z_M)`)  và  #mi(`N(x_N; y_N; z_N)`)  là hai điểm trong không gian, tọa độ của vectơ  #mi(`\vec{MN}`)  được tính bởi:  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) 
  - Nếu  #mi(`\vec{u} = (a; b; c)`)  là một vectơ và  #mi(`M(x_M; y_M; z_M)`)  là một điểm, tọa độ điểm  #mi(`P`)  sao cho  #mi(`\vec{MP} = \vec{u}`)  được xác định bởi:  #mi(`x_P = x_M + a; y_P = y_M + b; z_P = z_M + c`) 
  - Trong hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có gốc  #mi(`A(0;0;0)`) , các cạnh  #mi(`AB, AD, AA'`)  nằm trên các trục tọa độ, thì tọa độ các đỉnh được xác định bởi các tổ hợp của các độ dài cạnh tương ứng.
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tìm tọa độ vectơ từ 2 điểm: Lấy 'Sau' trừ 'Trước' ( #mi(`x_{sau} - x_{truoc}`) )
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{MN}`)  được tính bằng công thức  #mi(`\vec{MN} = (\dots; \dots; \dots)`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(4; 5; 6)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (3;3;3)]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng cách lấy tọa độ điểm  #mi(`B`)  trừ đi tọa độ điểm  #mi(`A`) :  #mi(`\vec{AB} = (4 - 1; 5 - 2; 6 - 3) = (3; 3; 3)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Cho điểm  #mi(`M(2; -1; 4)`)  và vectơ  #mi(`\vec{u} = (3; 2; -1)`) . Tìm tọa độ điểm  #mi(`P`)  sao cho  #mi(`\vec{MP} = \vec{u}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (5;1;5)]
      \ #text(fill: rgb("#334155"))[Lời giải: Gọi tọa độ điểm  #mi(`P`)  là  #mi(`(x; y; z)`) . Theo công thức tọa độ vectơ, ta có:  #mi(`\vec{MP} = (x - 2; y - (-1); z - 4) = (x - 2; y + 1; z - 4)`) . Vì  #mi(`\vec{MP} = \vec{u} = (3; 2; -1)`) , nên ta có hệ phương trình:  #mi(`x - 2 = 3 \rightarrow x = 5`) ;  #mi(`y + 1 = 2 \rightarrow y = 1`) ;  #mi(`z - 4 = -1 \rightarrow z = 5`) . Vậy  #mi(`P(5; 1; 5)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ vectơ từ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 0; 2)`)  và  #mi(`B(5; -2; 4)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng công thức:  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) . Thay số vào ta được:  #mi(`\vec{AB} = (5 - 1; -2 - 0; 4 - 2) = (4; -2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ điểm khi biết vectơ:] Cho điểm  #mi(`M(3; 4; -1)`)  và vectơ  #mi(`\vec{u} = (-1; 2; 5)`) . Tìm tọa độ điểm  #mi(`N`)  sao cho  #mi(`\vec{MN} = \vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi tọa độ điểm  #mi(`N`)  là  #mi(`(x; y; z)`) . Vì  #mi(`\vec{MN} = (x - 3; y - 4; z - (-1)) = (x - 3; y - 4; z + 1)`) . Theo giả thiết  #mi(`\vec{MN} = (-1; 2; 5)`) , ta có:  #mi(`\begin{cases} x - 3 = -1 \\ y - 4 = 2 \\\ z + 1 = 5 \end{cases} \Rightarrow \begin{cases} x = 2 \\ y = 6 \\ z = 4 \end{cases}`) . Vậy  #mi(`N(2; 6; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Xác định tọa độ đỉnh hình hộp chữ nhật:] Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có đỉnh  #mi(`A`)  trùng với gốc tọa độ  #mi(`O(0;0;0)`) . Biết  #mi(`B(3; 0; 0)`) ,  #mi(`D(0; 4; 0)`)  và  #mi(`A'(0; 0; 5)`) . Tìm tọa độ đỉnh  #mi(`C`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì  #mi(`ABCD`)  là hình chữ nhật nằm trong mặt phẳng  #mi(`(Oxy)`)  với  #mi(`A(0;0;0)`) ,  #mi(`B(3;0;0)`)  và  #mi(`D(0;4;0)`) , nên tọa độ đỉnh  #mi(`C`)  phải thỏa mãn  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) . Ta có  #mi(`\vec{AB} = (3; 0; 0)`)  và  #mi(`\vec{AD} = (0; 4; 0)`) . Suy ra  #mi(`\vec{AC} = (3+0; 0+4; 0+0) = (3; 4; 0)`) . Vì  #mi(`A`)  là gốc tọa độ nên  #mi(`C`)  có tọa độ  #mi(`(3; 4; 0)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tìm tọa độ điểm khi biết vectơ và điểm đầu:] Cho điểm  #mi(`A(1; 2; 3)`)  và vectơ  #mi(`\vec{u} = (2; -1; 4)`) . Tìm tọa độ điểm  #mi(`B`)  sao cho  #mi(`\vec{AB} = \vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Tọa độ điểm  #mi(`B(x; y; z)`)  được xác định bởi:  #mi(`x = x_A + u_x = 1 + 2 = 3`) ;  #mi(`y = y_A + u_y = 2 + (-1) = 1`) ;  #mi(`z = z_A + u_z = 3 + 4 = 7`) . Vậy  #mi(`B(3; 1; 7)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(2; 3; 1)`)  và  #mi(`B(5; 0; -2)`) . Tìm tọa độ vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A) = (5 - 2; 0 - 3; -2 - 1) = (3; -3; -3)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`M(1; -2; 5)`)  và  #mi(`N(4; 1; 0)`) . Tìm tọa độ vectơ  #mi(`\vec{MN}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ vectơ  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M) = (4 - 1; 1 - (-2); 0 - 5) = (3; 3; -5)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho điểm  #mi(`P(0; 5; -3)`)  và vectơ  #mi(`\vec{u} = (2; -2; 1)`) . Tìm tọa độ điểm  #mi(`Q`)  sao cho  #mi(`\vec{PQ} = \vec{u}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Tọa độ điểm  #mi(`Q(x; y; z)`)  thỏa mãn:  #mi(`x = 0 + 2 = 2`) ;  #mi(`y = 5 + (-2) = 3`) ;  #mi(`z = -3 + 1 = -2`) . Vậy  #mi(`Q(2; 3; -2)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Cho hình hộp chữ nhật  #mi(`ABCD.A'B'C'D'`)  có  #mi(`A(0;0;0)`) ,  #mi(`B(4;0;0)`) ,  #mi(`D(0;2;0)`)  và  #mi(`A'(0;0;3)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`ABCD`)  là hình chữ nhật trong mặt phẳng  #mi(`(Oxy)`)  nên  #mi(`\vec{AC} = \vec{AB} + \vec{AD}`) . Ta có  #mi(`\vec{AB} = (4; 0; 0)`)  và  #mi(`\vec{AD} = (0; 2; 0)`) . Suy ra  #mi(`\vec{AC} = (4; 2; 0)`) . Vì  #mi(`A`)  là gốc tọa độ nên  #mi(`C(4; 2; 0)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Thực hiện phép toán đại số trên tọa độ vectơ (Cộng, trừ, nhân số thực) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Thực hiện phép toán đại số trên tọa độ vectơ (Cộng, trừ, nhân số thực)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho  #mi(`\vec{u} = (x_u; y_u; z_u)`)  và  #mi(`\vec{v} = (x_v; y_v; z_v)`) , ta có:  #mi(`\vec{u} + \vec{v} = (x_u + x_v; y_u + y_v; z_u + z_v)`)  và  #mi(`\vec{u} - \vec{v} = (x_u - x_v; y_u - y_v; z_u - z_v)`) .
  - Cho  #mi(`\vec{u} = (x_u; y_u; z_u)`)  và số thực  #mi(`k`) , ta có:  #mi(`k\vec{u} = (k x_u; k y_u; k z_u)`) .
  - Biểu thức tổ hợp tuyến tính:  #mi(`m\vec{u} + n\vec{v} = (m x_u + n x_v; m y_u + n y_v; m z_u + n z_v)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn cộng, trừ hay nhân tọa độ, chỉ cần thực hiện phép tính tương ứng trên từng thành phần (hoành độ, tung độ, cao độ) một cách độc lập.
  ]
  - *Công thức cốt lõi:* Tọa độ của vectơ  #mi(`\vec{u} + \vec{v}`)  là  #mi(`(...; ...; ...)`)  với  #mi(`\vec{u}=(x_u;y_u;z_u)`)  và  #mi(`\vec{v}=(x_v;y_v;z_v)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 0; 5)`)  và  #mi(`\vec{b} = (1; 3; 9)`) . Tính tọa độ của vectơ  #mi(`\vec{a} + \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (2;3;14)]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`\vec{a} + \vec{b} = (1 + 1; 0 + 3; 5 + 9) = (2; 3; 14)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 1; 5)`)  và  #mi(`\vec{b} = (2; 2; 1)`) . Tính tọa độ của vectơ  #mi(`3\vec{a} + 2\vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: (10;7;17)]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có:  #mi(`3\vec{a} = (3\cdot 2; 3\cdot 1; 3\cdot 5) = (6; 3; 15)`) .\n #mi(`2\vec{b} = (2\cdot 2; 2\cdot 2; 2\cdot 1) = (4; 4; 2)`) .\n #mi(`3\vec{a} + 2\vec{b} = (6 + 4; 3 + 4; 15 + 2) = (10; 7; 17)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Phép cộng và phép trừ vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 2; 3)`)  và  #mi(`\vec{b} = (4; 5; 6)`) . Tính  #mi(`\vec{a} + \vec{b}`)  và  #mi(`\vec{a} - \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`\vec{a} + \vec{b} = (1 + 4; 2 + 5; 3 + 6) = (5; 7; 9)`) .\n #mi(`\vec{a} - \vec{b} = (1 - 4; 2 - 5; 3 - 6) = (-3; -3; -3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Phép nhân vectơ với một số thực:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (-1; 2; 4)`) . Tính tọa độ của vectơ  #mi(`3\vec{u}`)  và  #mi(`-2\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`3\vec{u} = (3\cdot(-1); 3\cdot 2; 3\cdot 4) = (-3; 6; 12)`) .\n #mi(`-2\vec{u} = (-2\cdot(-1); -2\cdot 2; -2\cdot 4) = (2; -4; -8)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Biểu thức tổ hợp tuyến tính:] Cho  #mi(`\vec{a} = (1; -2; 2)`)  và  #mi(`\vec{b} = (-2; 0; 3)`) . Tính tọa độ của vectơ  #mi(`\vec{u} = 2\vec{a} - \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`2\vec{a} = (2\cdot 1; 2\cdot(-2); 2\cdot 2) = (2; -4; 4)`) .\n #mi(`\vec{u} = 2\vec{a} - \vec{b} = (2 - (-2); -4 - 0; 4 - 3) = (4; -4; 1)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Phép toán kết hợp nhiều bước:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 8; 6)`) ,  #mi(`\vec{b} = (-1; 3; -2)`)  và  #mi(`\vec{c} = (0; 5; 4)`) . Tính  #mi(`\vec{u} = 2\vec{a} + \vec{b} - \vec{c}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`2\vec{a} = (2; 16; 12)`) .\n #mi(`\vec{u} = (2 + (-1) - 0; 16 + 3 - 5; 12 + (-2) - 4) = (1; 14; 6)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (2; -3; 1)`)  và  #mi(`\vec{v} = (4; 1; -5)`) . Tính  #mi(`\vec{u} + \vec{v}`)  và  #mi(`\vec{u} - \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{u} + \vec{v} = (2 + 4; -3 + 1; 1 + (-5)) = (6; -2; -4)`) .\n #mi(`\vec{u} - \vec{v} = (2 - 4; -3 - 1; 1 - (-5)) = (-2; -4; 6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (5; 0; -2)`)  và  #mi(`\vec{b} = (-1; 3; 4)`) . Tính  #mi(`\vec{a} + \vec{b}`)  và  #mi(`2\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`\vec{a} + \vec{b} = (5 - 1; 0 + 3; -2 + 4) = (4; 3; 2)`) .\n #mi(`2\vec{a} = (2\cdot 5; 2\cdot 0; 2\cdot(-2)) = (10; 0; -4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Cho  #mi(`\vec{m} = (1; 4; -2)`)  và  #mi(`\vec{n} = (3; -1; 5)`) . Tính tọa độ của vectơ  #mi(`\vec{u} = 3\vec{m} - 2\vec{n}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`3\vec{m} = (3; 12; -6)`) .\n #mi(`2\vec{n} = (6; -2; 10)`) .\n #mi(`\vec{u} = (3 - 6; 12 - (-2); -6 - 10) = (-3; 14; -16)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (x; 2; 1)`)  và  #mi(`\vec{b} = (3; y; -2)`) . Biết  #mi(`\vec{a} + \vec{b} = (5; 5; -1)`) . Tìm  #mi(`x`)  và  #mi(`y`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Từ  #mi(`\vec{a} + \vec{b} = (x + 3; 2 + y; 1 - 2) = (5; 5; -1)`) .\nSo sánh các thành phần:  #mi(`x + 3 = 5 \Rightarrow x = 2`) .\n #mi(`2 + y = 5 \Rightarrow y = 3`) .\nKiểm tra:  #mi(`1 - 2 = -1`)  (đúng).\nVậy  #mi(`x = 2`)  và  #mi(`y = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Tìm tọa độ các điểm đặc biệt (Trung điểm, Trọng tâm) trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Tìm tọa độ các điểm đặc biệt (Trung điểm, Trọng tâm) trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`)  là  #mi(`M\big(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\big)`) .
  - Cho tam giác  #mi(`ABC`)  với  #mi(`A(x_A; y_A; z_A)`) ,  #mi(`B(x_B; y_B; z_B)`)  và  #mi(`C(x_C; y_C; z_C)`) , tọa độ trọng tâm  #mi(`G`)  là  #mi(`G\big(\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3}\big)`) .
  - Cho tứ diện  #mi(`ABCD`)  với  #mi(`A(x_A; y_A; z_A)`) ,  #mi(`B(x_B; y_B; z_B)`) ,  #mi(`C(x_C; y_C; z_C)`)  và  #mi(`D(x_D; y_D; z_D)`) , tọa độ trọng tâm  #mi(`I`)  là  #mi(`I\big(\frac{x_A+x_B+x_C+x_D}{4}; \frac{y_A+y_B+y_C+y_D}{4}; \frac{z_A+z_B+z_C+z_D}{4}\big)`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Trung điểm là 'Chia đôi tổng', Trọng tâm tam giác là 'Chia ba tổng', Trọng tâm tứ diện là 'Chia bốn tổng'.
  ]
  - *Công thức cốt lõi:* Tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`)  được tính bằng công thức  #mi(`G = (...)`)  với  #mi(`A, B, C`)  là ba đỉnh của tam giác.
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(1; 2; 3)`)  và  #mi(`B(3; 4; 5)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 2; 3; 4]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trung điểm  #mi(`M`)  là:  #mi(`x_M = \frac{1+3}{2} = 2`) ;  #mi(`y_M = \frac{2+4}{2} = 3`) ;  #mi(`z_M = \frac{3+5}{2} = 4`) . Vậy  #mi(`M(2; 3; 4)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 0; 1)`) ,  #mi(`B(0; -3; 1)`)  và  #mi(`C(4; -1; 4)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 5/3; -4/3; 2]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`G`)  là:  #mi(`x_G = \frac{1+0+4}{3} = \frac{5}{3}`) ;  #mi(`y_G = \frac{0-3-1}{3} = -\frac{4}{3}`) ;  #mi(`z_G = \frac{1+1+4}{3} = 2`) . Vậy  #mi(`G(\frac{5}{3}; -\frac{4}{3}; 2)`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 3.* Trong không gian  #mi(`Oxyz`) , cho tứ diện  #mi(`ABCD`)  có  #mi(`A(0; 0; 0)`) ,  #mi(`B(4; 0; 0)`) ,  #mi(`C(0; 4; 0)`)  và  #mi(`D(0; 0; 4)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 1; 1; 1]
      \ #text(fill: rgb("#334155"))[Lời giải: Tọa độ trọng tâm  #mi(`I`)  là:  #mi(`x_I = \frac{0+4+0+0}{4} = 1`) ;  #mi(`y_I = \frac{0+0+4+0}{4} = 1`) ;  #mi(`z_I = \frac{0+0+0+4}{4} = 1`) . Vậy  #mi(`I(1; 1; 1)`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tìm tọa độ trung điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; -4; 6)`)  và  #mi(`B(4; 0; -2)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trung điểm:  #mi(`M\big(\frac{x_A+x_B}{2}; \frac{y_A+y_B}{2}; \frac{z_A+z_B}{2}\big)`) . Ta có:  #mi(`x_M = \frac{2+4}{2} = 3`) ;  #mi(`y_M = \frac{-4+0}{2} = -2`) ;  #mi(`z_M = \frac{6-2}{2} = 2`) . Vậy  #mi(`M(3; -2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tìm tọa độ trọng tâm tam giác:] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 2; 1)`)  và  #mi(`C(2; -1; 5)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trọng tâm tam giác:  #mi(`G\big(\frac{x_A+x_B+x_C}{3}; \frac{y_A+y_B+y_C}{3}; \frac{z_A+z_B+z_C}{3}\big)`) . Ta có:  #mi(`x_G = \frac{1+3+2}{3} = 2`) ;  #mi(`y_G = \frac{2+2-1}{3} = 1`) ;  #mi(`z_G = \frac{3+1+5}{3} = 3`) . Vậy  #mi(`G(2; 1; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tọa độ trọng tâm tứ diện:] Trong không gian  #mi(`Oxyz`) , cho tứ diện  #mi(`ABCD`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(5; 1; 1)`) ,  #mi(`C(1; 5; 1)`)  và  #mi(`D(1; 1; 5)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tọa độ trọng tâm tứ diện:  #mi(`I\big(\frac{x_A+x_B+x_C+x_D}{4}; \frac{y_A+y_B+y_C+y_D}{4}; \frac{z_A+z_B+z_C+z_D}{4}\big)`) . Ta có:  #mi(`x_I = \frac{1+5+1+1}{4} = 2`) ;  #mi(`y_I = \frac{1+1+5+1}{4} = 2`) ;  #mi(`z_I = \frac{1+1+1+5}{4} = 2`) . Vậy  #mi(`I(2; 2; 2)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán ngược (Tìm tọa độ một đỉnh):] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G(2; 2; 2)`)  và  #mi(`A(1; 1; 1)`) ,  #mi(`B(3; 3; 3)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Gọi tọa độ điểm  #mi(`C`)  là  #mi(`(x; y; z)`) . Theo công thức trọng tâm tam giác:  #mi(`x_G = \frac{x_A+x_B+x_C}{3} \Rightarrow 2 = \frac{1+3+x}{3} \Rightarrow 6 = 4+x \Rightarrow x = 2`) . Tương tự:  #mi(`y_G = \frac{y_A+y_B+y_C}{3} \Rightarrow 2 = \frac{1+1+y}{3} \Rightarrow 6 = 2+y \Rightarrow y = 4`) . Và  #mi(`z_G = \frac{z_A+z_B+z_C}{3} \Rightarrow 2 = \frac{1+1+z}{3} \Rightarrow 6 = 2+z \Rightarrow z = 4`) . Vậy  #mi(`C(2; 4; 4)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`A(0; 4; -2)`)  và  #mi(`B(6; -2; 10)`) . Tìm tọa độ trung điểm  #mi(`M`)  của đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức trung điểm:  #mi(`x_M = \frac{0+6}{2} = 3`) ;  #mi(`y_M = \frac{4-2}{2} = 1`) ;  #mi(`z_M = \frac{-2+10}{2} = 4`) . Vậy  #mi(`M(3; 1; 4)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(2; 4; 6)`) ,  #mi(`B(4; 6; 8)`)  và  #mi(`C(6; 8; 10)`) . Tìm tọa độ trọng tâm  #mi(`G`)  của tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức trọng tâm tam giác:  #mi(`x_G = \frac{2+4+6}{3} = 4`) ;  #mi(`y_G = \frac{4+6+8}{3} = 6`) ;  #mi(`z_G = \frac{6+8+10}{3} = 8`) . Vậy  #mi(`G(4; 6; 8)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho tứ diện  #mi(`ABCD`)  có  #mi(`A(1; 2; 3)`) ,  #mi(`B(3; 4; 5)`) ,  #mi(`C(5; 6; 7)`)  và  #mi(`D(7; 8; 9)`) . Tìm tọa độ trọng tâm  #mi(`I`)  của tứ diện  #mi(`ABCD`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức trọng tâm tứ diện:  #mi(`x_I = \frac{1+3+5+7}{4} = 4`) ;  #mi(`y_I = \frac{2+4+6+8}{4} = 5`) ;  #mi(`z_I = \frac{3+5+7+9}{4} = 6`) . Vậy  #mi(`I(4; 5; 6)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có trọng tâm  #mi(`G(1; 1; 1)`)  và  #mi(`A(0; 0; 0)`) ,  #mi(`B(2; 2; 2)`) . Tìm tọa độ điểm  #mi(`C`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Gọi tọa độ điểm  #mi(`C`)  là  #mi(`(x; y; z)`) . Ta có:  #mi(`x_G = \frac{x_A+x_B+x_C}{3} \Rightarrow 1 = \frac{0+2+x}{3} \Rightarrow 3 = 2+x \Rightarrow x = 1`) . Tương tự:  #mi(`y_G = \frac{0+2+y}{3} \Rightarrow 1 = \frac{2+y}{3} \Rightarrow y = 1`) . Và  #mi(`z_G = \frac{0+2+z}{3} \Rightarrow 1 = \frac{2+z}{3} \Rightarrow z = 1`) . Vậy  #mi(`C(1; 1; 1)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Tính độ dài của vectơ và khoảng cách giữa hai điểm trong Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Tính độ dài của vectơ và khoảng cách giữa hai điểm trong Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Độ dài của vectơ  #mi(`\vec{a} = (x; y; z)`)  được tính bằng công thức:  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
  - Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là:  #mi(`AB = \sqrt{(x_B - x_A)^2 + (y_B - y_A)^2 + (z_B - z_A)^2}`) .
  - Chu vi tam giác  #mi(`ABC`)  là tổng độ dài các cạnh:  #mi(`P = AB + BC + CA`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Độ dài vectơ chính là khoảng cách từ gốc tọa độ đến điểm cuối của vectơ đó. Khi tính khoảng cách giữa hai điểm, hãy nhớ lấy tọa độ điểm sau trừ điểm trước rồi mới bình phương.
  ]
  - *Công thức cốt lõi:* Độ dài của vectơ  #mi(`\vec{a} = (x; y; z)`)  là  #mi(`|\vec{a}| = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{a} = (2; -3; 6)`) . Tính độ dài của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 7]
      \ #text(fill: rgb("#334155"))[Lời giải: Độ dài của vectơ  #mi(`\vec{a}`)  là:  #mi(`|\vec{a}| = \sqrt{2^2 + (-3)^2 + 6^2} = \sqrt{4 + 9 + 36} = \sqrt{49} = 7`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , tính khoảng cách giữa hai điểm  #mi(`A(1; 2; -1)`)  và  #mi(`B(4; -2; 5)`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: sqrt(61)]
      \ #text(fill: rgb("#334155"))[Lời giải: Khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`)  là:  #mi(`AB = \sqrt{(4 - 1)^2 + (-2 - 2)^2 + (5 - (-1))^2} = \sqrt{3^2 + (-4)^2 + 6^2} = \sqrt{9 + 16 + 36} = \sqrt{61}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính độ dài vectơ cho trước:] Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{u} = (3; 4; -12)`) . Tính độ dài của vectơ  #mi(`\vec{u}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Độ dài của vectơ  #mi(`\vec{u}`)  là:  #mi(`|\vec{u}| = \sqrt{3^2 + 4^2 + (-12)^2} = \sqrt{9 + 16 + 144} = \sqrt{169} = 13`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính khoảng cách giữa hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; 1; 1)`)  và  #mi(`B(3; 5; 1)`) . Tính độ dài đoạn thẳng  #mi(`AB`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Độ dài đoạn thẳng  #mi(`AB`)  là:  #mi(`AB = \sqrt{(3 - 1)^2 + (5 - 1)^2 + (1 - 1)^2} = \sqrt{2^2 + 4^2 + 0^2} = \sqrt{4 + 16} = \sqrt{20} = 2\sqrt{5}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính chu vi tam giác:] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  với  #mi(`A(1; 0; 0)`) ,  #mi(`B(0; 2; 0)`)  và  #mi(`C(0; 0; 3)`) . Tính chu vi tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có:  #mi(`AB = \sqrt{(0-1)^2 + (2-0)^2 + (0-0)^2} = \sqrt{1+4} = \sqrt{5}`) .<br/> #mi(`BC = \sqrt{(0-0)^2 + (0-2)^2 + (3-0)^2} = \sqrt{4+9} = \sqrt{13}`) .<br/> #mi(`CA = \sqrt{(1-0)^2 + (0-0)^2 + (0-3)^2} = \sqrt{1+9} = \sqrt{10}`) .<br/>Chu vi tam giác  #mi(`ABC`)  là:  #mi(`P = \sqrt{5} + \sqrt{13} + \sqrt{10}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể tính độ dài vectơ từ hai điểm:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(2; -1; 4)`)  và  #mi(`B(5; 3; 4)`) . Tính độ dài của vectơ  #mi(`\vec{AB}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ  #mi(`\vec{AB}`)  có tọa độ là:  #mi(`\vec{AB} = (5-2; 3-(-1); 4-4) = (3; 4; 0)`) .<br/>Độ dài của vectơ  #mi(`\vec{AB}`)  là:  #mi(`|\vec{AB}| = \sqrt{3^2 + 4^2 + 0^2} = \sqrt{25} = 5`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{v} = (-5; 12; 0)`) . Tính độ dài của vectơ  #mi(`\vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài của vectơ  #mi(`\vec{v}`)  là:  #mi(`|\vec{v}| = \sqrt{(-5)^2 + 12^2 + 0^2} = \sqrt{25 + 144} = \sqrt{169} = 13`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho vectơ  #mi(`\vec{a} = (8; -6; 0)`) . Tính độ dài của vectơ  #mi(`\vec{a}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Độ dài của vectơ  #mi(`\vec{a}`)  là:  #mi(`|\vec{a}| = \sqrt{8^2 + (-6)^2 + 0^2} = \sqrt{64 + 36} = 10`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(0; 0; 0)`)  và  #mi(`B(1; 2; 2)`) . Tính khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách giữa hai điểm  #mi(`A`)  và  #mi(`B`)  là:  #mi(`AB = \sqrt{(1-0)^2 + (2-0)^2 + (2-0)^2} = \sqrt{1+4+4} = \sqrt{9} = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho tam giác  #mi(`ABC`)  có  #mi(`A(1; 1; 1)`) ,  #mi(`B(2; 3; 1)`)  và  #mi(`C(1; 1; 3)`) . Tính chu vi tam giác  #mi(`ABC`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có:  #mi(`AB = \sqrt{(2-1)^2 + (3-1)^2 + (1-1)^2} = \sqrt{1+4+0} = \sqrt{5}`) .<br/> #mi(`BC = \sqrt{(1-2)^2 + (1-3)^2 + (3-1)^2} = \sqrt{1+4+4} = 3`) .<br/> #mi(`CA = \sqrt{(1-1)^2 + (1-1)^2 + (3-1)^2} = 2`) .<br/>Chu vi tam giác  #mi(`ABC`)  là:  #mi(`P = \sqrt{5} + 3 + 2 = 5 + \sqrt{5}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Tính tích vô hướng của hai vectơ trong không gian Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Tính tích vô hướng của hai vectơ trong không gian Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Cho hai vectơ  #mi(`\vec{a} = (x; y; z)`)  và  #mi(`\vec{b} = (x'; y'; z')`) , tích vô hướng của chúng được xác định bởi công thức:  #mi(`\vec{a} \cdot \vec{b} = x x' + y y' + z z'`) 
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi tích vô hướng của chúng bằng  #mi(`0`) :  #mi(`\vec{a} \cdot \vec{b} = 0`) 
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn tính tích vô hướng, hãy lấy 'từng cặp nhân từng cặp rồi cộng lại'. Muốn kiểm tra vuông góc, hãy xem tổng các tích đó có bằng  #mi(`0`)  không.
  ]
  - *Công thức cốt lõi:* Tích vô hướng của hai vectơ  #mi(`\vec{a} = (x; y; z)`)  và  #mi(`\vec{b} = (x'; y'; z')`)  là  #mi(`\vec{a} \cdot \vec{b} = \dots`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 2; 3)`)  và  #mi(`\vec{b} = (4; -1; 2)`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 8]
      \ #text(fill: rgb("#334155"))[Lời giải: Áp dụng công thức tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 4 + 2 \cdot (-1) + 3 \cdot 2 = 4 - 2 + 6 = 8`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; m; 1)`)  và  #mi(`\vec{b} = (3; 2; -4)`) . Tìm  #mi(`m`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: -1]
      \ #text(fill: rgb("#334155"))[Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a} \cdot \vec{b} = 0`) . Ta có:  #mi(`2 \cdot 3 + m \cdot 2 + 1 \cdot (-4) = 0 \Leftrightarrow 6 + 2m - 4 = 0 \Leftrightarrow 2m + 2 = 0 \Leftrightarrow m = -1`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính tích vô hướng trực tiếp:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 2; -3)`)  và  #mi(`\vec{b} = (4; 0; 5)`) . Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 4 + 2 \cdot 0 + (-3) \cdot 5 = 4 + 0 - 15 = -11`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Chứng minh hai vectơ vuông góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (2; -1; 4)`)  và  #mi(`\vec{v} = (2; 4; 0)`) . Chứng minh rằng  #mi(`\vec{u} \perp \vec{v}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta tính tích vô hướng của hai vectơ:  #mi(`\vec{u} \cdot \vec{v} = 2 \cdot 2 + (-1) \cdot 4 + 4 \cdot 0 = 4 - 4 + 0 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\vec{u} \perp \vec{v}`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tìm tham số để hai vectơ vuông góc:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; m; 2)`)  và  #mi(`\vec{b} = (2; 4; -2)`) . Tìm giá trị của  #mi(`m`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a} \cdot \vec{b} = 0`) . Ta có:  #mi(`1 \cdot 2 + m \cdot 4 + 2 \cdot (-2) = 0 \Leftrightarrow 2 + 4m - 4 = 0 \Leftrightarrow 4m - 2 = 0 \Leftrightarrow m = 0.5`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Tính tích vô hướng của tổng hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (1; 1; 1)`)  và  #mi(`\vec{b} = (2; -1; 0)`) . Tính  #mi(`\vec{a} \cdot (\vec{a} + \vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Trước hết, tìm tọa độ vectơ  #mi(`\vec{a} + \vec{b} = (1+2; 1-1; 1+0) = (3; 0; 1)`) . Khi đó,  #mi(`\vec{a} \cdot (\vec{a} + \vec{b}) = 1 \cdot 3 + 1 \cdot 0 + 1 \cdot 1 = 3 + 0 + 1 = 4`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (3; 4; 1)`)  và  #mi(`\vec{b} = (2; -2; 5)`) . Tính  #mi(`\vec{a} \cdot \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{a} \cdot \vec{b} = 3 \cdot 2 + 4 \cdot (-2) + 1 \cdot 5 = 6 - 8 + 5 = 3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{u} = (5; 1; -2)`)  và  #mi(`\vec{v} = (1; 3; 4)`) . Tính  #mi(`\vec{u} \cdot \vec{v}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Áp dụng công thức:  #mi(`\vec{u} \cdot \vec{v} = 5 \cdot 1 + 1 \cdot 3 + (-2) \cdot 4 = 5 + 3 - 8 = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 3; m)`)  và  #mi(`\vec{b} = (1; -2; 4)`) . Tìm  #mi(`m`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a} \cdot \vec{b} = 0`) . Ta có:  #mi(`2 \cdot 1 + 3 \cdot (-2) + m \cdot 4 = 0 \Leftrightarrow 2 - 6 + 4m = 0 \Leftrightarrow 4m - 4 = 0 \Leftrightarrow m = 1`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (x; 1; 2)`)  và  #mi(`\vec{b} = (3; -3; 1)`) . Tìm  #mi(`x`)  để  #mi(`\vec{a} \perp \vec{b}`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Để  #mi(`\vec{a} \perp \vec{b}`)  thì  #mi(`\vec{a} \cdot \vec{b} = 0`) . Ta có:  #mi(`x \cdot 3 + 1 \cdot (-3) + 2 \cdot 1 = 0 \Leftrightarrow 3x - 3 + 2 = 0 \Leftrightarrow 3x - 1 = 0 \Leftrightarrow x = 1/3`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Tính góc và cosin góc giữa hai vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Tính góc và cosin góc giữa hai vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  được tính theo công thức:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) .
  - Góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  (ký hiệu là  #mi(`(\vec{a}, \vec{b})`) ) thỏa mãn:  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) .
  - Góc giữa hai đường thẳng  #mi(`d_1`)  và  #mi(`d_2`)  trong không gian là góc  #mi(`\theta`)  thỏa mãn:  #mi(`\cos \theta = |\cos(\vec{u_1}, \vec{u_2})|`) , với  #mi(`\vec{u_1}, \vec{u_2}`)  là các vectơ chỉ phương của  #mi(`d_1, d_2`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để tính góc giữa hai vectơ, hãy nhớ: 'Tích vô hướng chia cho tích độ dài'. Để tính góc giữa hai đường thẳng, đừng quên lấy 'Trị tuyệt đối' của cosin!
  ]
  - *Công thức cốt lõi:* Công thức tính cosin góc giữa hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\cos(\vec{a}, \vec{b}) = \ ...`) 
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 2; 2)`)  và  #mi(`\vec{b} = (2; -2; 1)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 2 + 2 \cdot (-2) + 2 \cdot 1 = 2 - 4 + 2 = 0`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{9} = 3`) . Độ dài  #mi(`|\vec{b}| = \sqrt{2^2 + (-2)^2 + 1^2} = \sqrt{9} = 3`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{0}{3 \cdot 3} = 0`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{u} = (1; 1; 0)`)  và  #mi(`\vec{v} = (0; 1; 1)`) . Tính  #mi(`\cos(\vec{u}, \vec{v})`) .
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 0.5]
      \ #text(fill: rgb("#334155"))[Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 1 \cdot 0 + 1 \cdot 1 + 0 \cdot 1 = 1`) . Độ dài  #mi(`|\vec{u}| = \sqrt{1^2 + 1^2 + 0^2} = \sqrt{2}`) . Độ dài  #mi(`|\vec{v}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . Vậy  #mi(`\cos(\vec{u}, \vec{v}) = \frac{1}{\sqrt{2} \cdot \sqrt{2}} = \frac{1}{2}`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Tính cosin góc giữa hai vectơ bằng tọa độ:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 1; 1)`)  và  #mi(`\vec{b} = (1; 0; -1)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 1 + 1 \cdot 0 + 1 \cdot (-1) = 1 + 0 - 1 = 0`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{1^2 + 0^2 + (-1)^2} = \sqrt{2}`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{0}{\sqrt{3} \cdot \sqrt{2}} = 0`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Tính số đo góc giữa hai vectơ:] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (2; 1; -2)`)  và  #mi(`\vec{b} = (1; 2; 2)`) . Tính số đo góc  #mi(`(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{a} \cdot \vec{b} = 2 \cdot 1 + 1 \cdot 2 + (-2) \cdot 2 = 2 + 2 - 4 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\cos(\vec{a}, \vec{b}) = 0`) , suy ra  #mi(`(\vec{a}, \vec{b}) = 90^\circ`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Tính góc giữa hai đường thẳng:] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  có vectơ chỉ phương  #mi(`\vec{u_1} = (1; 2; -1)`)  và  #mi(`d_2`)  có vectơ chỉ phương  #mi(`\vec{u_2} = (2; -1; 1)`) . Tính góc giữa hai đường thẳng  #mi(`d_1`)  và  #mi(`d_2`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Ta có  #mi(`\vec{u_1} \cdot \vec{u_2} = 1 \cdot 2 + 2 \cdot (-1) + (-1) \cdot 1 = 2 - 2 - 1 = -1`) . Độ dài  #mi(`|\vec{u_1}| = \sqrt{1^2 + 2^2 + (-1)^2} = \sqrt{6}`) . Độ dài  #mi(`|\vec{u_2}| = \sqrt{2^2 + (-1)^2 + 1^2} = \sqrt{6}`) . Gọi  #mi(`\theta`)  là góc giữa hai đường thẳng, ta có  #mi(`\cos \theta = |\frac{-1}{\sqrt{6} \cdot \sqrt{6}}| = |\frac{-1}{6}| = \frac{1}{6}`) . Vậy  #mi(`\theta = \arccos(\frac{1}{6})`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Biến thể: Tính góc giữa hai vectơ khi biết độ dài và tích vô hướng:] Cho hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  có  #mi(`|\vec{a}| = 3`) ,  #mi(`|\vec{b}| = 4`)  và  #mi(`\vec{a} \cdot \vec{b} = 6`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Áp dụng công thức  #mi(`\cos(\vec{a}, \vec{b}) = \frac{\vec{a} \cdot \vec{b}}{|\vec{a}| \cdot |\vec{b}|}`) , ta có  #mi(`\cos(\vec{a}, \vec{b}) = \frac{6}{3 \cdot 4} = \frac{6}{12} = 0.5`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 0; 1)`)  và  #mi(`\vec{b} = (0; 1; 1)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 0 + 0 \cdot 1 + 1 \cdot 1 = 1`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1^2 + 0^2 + 1^2} = \sqrt{2}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{0^2 + 1^2 + 1^2} = \sqrt{2}`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{1}{\sqrt{2} \cdot \sqrt{2}} = 0.5`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{u} = (2; 2; 1)`)  và  #mi(`\vec{v} = (1; -2; 2)`) . Tính  #mi(`\cos(\vec{u}, \vec{v})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u} \cdot \vec{v} = 2 \cdot 1 + 2 \cdot (-2) + 1 \cdot 2 = 2 - 4 + 2 = 0`) . Vậy  #mi(`\cos(\vec{u}, \vec{v}) = 0`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Trong không gian  #mi(`Oxyz`) , cho hai vectơ  #mi(`\vec{a} = (1; 2; 3)`)  và  #mi(`\vec{b} = (3; 2; 1)`) . Tính  #mi(`\cos(\vec{a}, \vec{b})`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 3 + 2 \cdot 2 + 3 \cdot 1 = 3 + 4 + 3 = 10`) . Độ dài  #mi(`|\vec{a}| = \sqrt{1+4+9} = \sqrt{14}`) . Độ dài  #mi(`|\vec{b}| = \sqrt{9+4+1} = \sqrt{14}`) . Vậy  #mi(`\cos(\vec{a}, \vec{b}) = \frac{10}{\sqrt{14} \cdot \sqrt{14}} = \frac{10}{14} = \frac{5}{7}`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Trong không gian  #mi(`Oxyz`) , cho hai đường thẳng  #mi(`d_1`)  có vectơ chỉ phương  #mi(`\vec{u_1} = (1; 1; 1)`)  và  #mi(`d_2`)  có vectơ chỉ phương  #mi(`\vec{u_2} = (1; -1; 0)`) . Tính góc giữa hai đường thẳng  #mi(`d_1`)  và  #mi(`d_2`) .
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Ta có  #mi(`\vec{u_1} \cdot \vec{u_2} = 1 \cdot 1 + 1 \cdot (-1) + 1 \cdot 0 = 0`) . Vì tích vô hướng bằng  #mi(`0`)  nên  #mi(`\cos \theta = 0`) , suy ra góc giữa hai đường thẳng là  #mi(`90^\circ`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Mô hình hóa toán học bài toán thực tế bằng vectơ và hệ tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Mô hình hóa toán học bài toán thực tế bằng vectơ và hệ tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
  - Để mô hình hóa thực tế, chọn hệ trục  #mi(`Oxyz`)  sao cho gốc  #mi(`O`)  là điểm mốc (vị trí xuất phát, góc phòng) và các trục  #mi(`Ox, Oy, Oz`)  trùng với các hướng chuyển động hoặc các cạnh vật thể.
  - Vectơ dịch chuyển của vật thể từ  #mi(`A`)  đến  #mi(`B`)  được biểu diễn bởi  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
  - Hợp lực  #mi(`\vec{F}`)  của các lực  #mi(`\vec{F_1}, \vec{F_2}, \dots, \vec{F_n}`)  tác dụng lên một vật được tính bằng tổng vectơ:  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} + \dots + \vec{F_n}`) .
  - Khoảng cách giữa hai điểm  #mi(`M(x_M; y_M; z_M)`)  và  #mi(`N(x_N; y_N; z_N)`)  là  #mi(`d = \sqrt{(x_N - x_M)^2 + (y_N - y_M)^2 + (z_N - z_M)^2}`) .
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khi làm bài thực tế: 1. Chọn gốc  #mi(`O`)  thật khéo (thường là góc phòng hoặc điểm xuất phát). 2. Xác định hướng các trục  #mi(`x, y, z`)  theo đề bài (Đông, Tây, Nam, Bắc, Cao, Thấp). 3. Chuyển đổi đơn vị về cùng một chuẩn.
  ]
  - *Công thức cốt lõi:* Vectơ dịch chuyển của một vật từ điểm  #mi(`A(x_A; y_A; z_A)`)  đến điểm  #mi(`B(x_B; y_B; z_B)`)  là  #mi(`\vec{AB} = (\dots; y_B - y_A; z_B - z_A)`) .
]
#v(4pt)
#card(title: "II. Câu hỏi tự luận trả lời ngắn (Điền số kết quả)")[
  #block(width: 100%, breakable: false)[
    *Câu 1.* Một chiếc máy bay bay từ điểm  #mi(`A(10; 20; 0)`)  đến điểm  #mi(`B(30; 40; 10)`)  trong 2 giờ. Tính độ dài quãng đường máy bay đã bay (đơn vị: km).
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 30]
      \ #text(fill: rgb("#334155"))[Lời giải: Vectơ dịch chuyển là  #mi(`\vec{AB} = (30-10; 40-20; 10-0) = (20; 20; 10)`) . Độ dài quãng đường là  #mi(`|\vec{AB}| = \sqrt{20^2 + 20^2 + 10^2} = \sqrt{400 + 400 + 100} = \sqrt{900} = 30`) .]
    ] else [
      #v(3pt)
      #align(right)[#rect(stroke: 1pt + rgb("#0369a1"), radius: 3pt, inset: (x: 12pt, y: 6pt))[
        #text(size: 9pt, weight: "bold", fill: rgb("#0369a1"))[Đáp số: ..............]
      ]]
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
    *Câu 2.* Một vật chịu tác dụng của hai lực  #mi(`\vec{F_1} = (3; 4; 0)`)  N và  #mi(`\vec{F_2} = (1; -2; 5)`)  N. Tính độ lớn của hợp lực tác dụng lên vật.
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp số: 6.71]
      \ #text(fill: rgb("#334155"))[Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} = (3+1; 4-2; 0+5) = (4; 2; 5)`) . Độ lớn hợp lực  #mi(`|\vec{F}| = \sqrt{4^2 + 2^2 + 5^2} = \sqrt{16 + 4 + 25} = \sqrt{45} \approx 6.71`) .]
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
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 1 - Bài toán di chuyển của máy bay:] Một chiếc máy bay di chuyển từ điểm  #mi(`A(800; 500; 7)`)  đến điểm  #mi(`B(940; 550; 8)`)  trong 10 phút. Nếu máy bay tiếp tục giữ nguyên vận tốc và hướng bay, hãy tìm tọa độ của máy bay sau 5 phút tiếp theo (tính từ thời điểm ở  #mi(`B`) ).
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vectơ dịch chuyển trong 10 phút là  #mi(`\vec{AB} = (940-800; 550-500; 8-7) = (140; 50; 1)`) . Vì thời gian bay tiếp theo là 5 phút (bằng một nửa thời gian ban đầu), nên vectơ dịch chuyển mới là  #mi(`\vec{BC} = \frac{1}{2}\vec{AB} = (70; 25; 0.5)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (940+70; 550+25; 8+0.5) = (1010; 575; 8.5)`) .
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 2 - Bài toán tổng hợp lực trong vật lý:] Một chiếc tàu thủy chịu tác động của hai lực: lực đẩy động cơ  #mi(`\vec{F_1} = (10; 0; 0)`)  kN và lực cản của dòng nước  #mi(`\vec{F_2} = (-2; 3; 0)`)  kN. Tính độ lớn của hợp lực tác dụng lên tàu.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Hợp lực tác dụng lên tàu là  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} = (10 + (-2); 0 + 3; 0 + 0) = (8; 3; 0)`) . Độ lớn của hợp lực là  #mi(`|\vec{F}| = \sqrt{8^2 + 3^2 + 0^2} = \sqrt{64 + 9} = \sqrt{73} \approx 8.54`)  kN.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 3 - Bài toán đo đạc vị trí (Radar):] Một trạm radar đặt tại gốc tọa độ  #mi(`O(0; 0; 0)`) . Một tàu thám hiểm được phát hiện tại vị trí có tọa độ  #mi(`(25; 15; -10)`)  (đơn vị km). Tính khoảng cách từ tàu đến trạm radar.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Khoảng cách từ tàu đến trạm radar chính là độ dài vectơ nối từ  #mi(`O`)  đến điểm tàu.  #mi(`d = \sqrt{25^2 + 15^2 + (-10)^2} = \sqrt{625 + 225 + 100} = \sqrt{950} \approx 30.82`)  km.
    ] else [ \ #v(16pt) ]
  ]
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ 4 - Bài toán xác định tọa độ vật thể trong phòng:] Một căn phòng hình hộp chữ nhật có chiều dài 8m, chiều rộng 6m và chiều cao 3m. Chọn hệ trục tọa độ  #mi(`Oxyz`)  có gốc  #mi(`O`)  trùng với một góc sàn nhà, các trục  #mi(`Ox, Oy, Oz`)  lần lượt trùng với các cạnh đáy và cạnh đứng. Tìm tọa độ của một chiếc đèn treo tại chính giữa trần nhà.
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Vì đèn treo ở chính giữa trần nhà, nên tọa độ của nó sẽ có hoành độ bằng nửa chiều dài, tung độ bằng nửa chiều rộng và cao độ bằng chiều cao của phòng. Tọa độ đèn là  #mi(`I(8/2; 6/2; 3) = (4; 3; 3)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập tự luyện")[
  #if IS_TEACHER [*Bài 1 (Chuẩn mẫu).*] else [*Bài 1.*] Một chiếc tàu thủy di chuyển từ  #mi(`A(2; 3; 0)`)  đến  #mi(`B(10; 11; 6)`)  trong 4 giờ. Tìm tọa độ của tàu sau khi di chuyển thêm 2 giờ nữa với cùng vận tốc và hướng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong 4 giờ là  #mi(`\vec{AB} = (10-2; 11-3; 6-0) = (8; 8; 6)`) . Vì 2 giờ bằng một nửa 4 giờ, nên vectơ dịch chuyển thêm là  #mi(`\vec{BC} = \frac{1}{2}\vec{AB} = (4; 4; 3)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (10+4; 11+4; 6+3) = (14; 15; 9)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 2 (Tương tự 100%).*] else [*Bài 2.*] Một chiếc máy bay bay từ  #mi(`A(100; 100; 10)`)  đến  #mi(`B(200; 300; 30)`)  trong 1 giờ. Tìm tọa độ của máy bay sau khi bay thêm 30 phút nữa với cùng vận tốc và hướng.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Vectơ dịch chuyển trong 1 giờ là  #mi(`\vec{AB} = (200-100; 300-100; 30-10) = (100; 200; 20)`) . Vì 30 phút bằng một nửa 1 giờ, nên vectơ dịch chuyển thêm là  #mi(`\vec{BC} = \frac{1}{2}\vec{AB} = (50; 100; 10)`) . Tọa độ điểm  #mi(`C`)  là  #mi(`B + \vec{BC} = (200+50; 300+100; 30+10) = (250; 400; 40)`) .] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 3 (Tương tự 100%).*] else [*Bài 3.*] Một vật chịu tác động của hai lực  #mi(`\vec{F_1} = (5; -2; 1)`)  N và  #mi(`\vec{F_2} = (-3; 4; 2)`)  N. Tính độ lớn của hợp lực.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Hợp lực  #mi(`\vec{F} = \vec{F_1} + \vec{F_2} = (5-3; -2+4; 1+2) = (2; 2; 3)`) . Độ lớn hợp lực  #mi(`|\vec{F}| = \sqrt{2^2 + 2^2 + 3^2} = \sqrt{4 + 4 + 9} = \sqrt{17} \approx 4.12`)  N.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
  #if IS_TEACHER [*Bài 4 (Biến thể nhẹ).*] else [*Bài 4.*] Một trạm radar đặt tại  #mi(`O(0; 0; 0)`) . Một tàu thám hiểm ở vị trí  #mi(`M(12; 16; 21)`) . Tính khoảng cách từ tàu đến trạm radar.
    #if IS_TEACHER [
      #v(2pt) #text(fill: rgb("#15803d"))[→ Lời giải: Khoảng cách  #mi(`d = \sqrt{12^2 + 16^2 + 21^2} = \sqrt{144 + 256 + 441} = \sqrt{841} = 29`)  km.] \
    ] else [
      #v(2pt)
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 50pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
