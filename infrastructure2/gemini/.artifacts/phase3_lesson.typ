#import "@preview/mitex:0.2.7": mitex, mi

#let IS_TEACHER = sys.inputs.at("teacher", default: "true") == "true"

#set page(paper: "a4", margin: (x: 1.8cm, top: 1.6cm, bottom: 1.8cm))
#set text(font: ("DejaVu Sans", "Liberation Sans"), size: 10pt, lang: "vi")
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
  #text(size: 13pt, weight: "bold")[CHƯƠNG II. VECTƠ VÀ HỆ TỌA ĐỘ TRONG KHÔNG GIAN] \
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Chương này hướng dẫn học sinh từ những khái niệm cơ bản về vectơ trong không gian, các phép toán vectơ, thiết lập hệ trục tọa độ Oxyz, tính toán tọa độ điểm, vectơ và ứng dụng thực tế.]
]
#v(6pt)

// ==================== DẠNG 1: Dạng 1: Nhận diện hướng, độ dài và tính chất vectơ trong không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 1. Dạng 1: Nhận diện hướng, độ dài và tính chất vectơ trong không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_1|theory|0
  - Hai vectơ được gọi là bằng nhau ( #mi(`\vec{a} = \vec{b}`) ) nếu chúng cùng hướng và có cùng độ dài.
// @ANCHOR:dang_1|theory|1
  - Hai vectơ cùng phương khi giá của chúng song song hoặc trùng nhau.
// @ANCHOR:dang_1|theory|2
  - Vectơ-không ( #mi(`\vec{0}`) ) là vectơ có điểm đầu và điểm cuối trùng nhau, có độ dài bằng 0 và cùng phương với mọi vectơ.
// @ANCHOR:dang_1|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Muốn biết 2 vectơ có bằng nhau không? Hãy check 2 bước: 1. Có chỉ cùng một hướng không? 2. Có dài bằng nhau không? Cả hai cùng ĐÚNG thì mới bằng nhau!
  ]
// @ANCHOR:dang_1|cloze

  - *Công thức cốt lõi:* Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  bằng nhau khi và chỉ khi chúng cùng ... và cùng ...
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_1|mcq|0|prompt
    *Câu 1.* Hai vectơ được gọi là bằng nhau khi chúng có đặc điểm nào sau đây?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_1|mcq|0|opt|0
      [A. Cùng phương và cùng độ dài],
// @ANCHOR:dang_1|mcq|0|opt|1
      [B. Cùng hướng và cùng độ dài],
// @ANCHOR:dang_1|mcq|0|opt|2
      [C. Chỉ cần cùng độ dài],
// @ANCHOR:dang_1|mcq|0|opt|3
      [D. Chỉ cần cùng phương],
    )
// @ANCHOR:dang_1|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Hai vectơ bằng nhau khi thỏa mãn đồng thời hai điều kiện: cùng hướng và cùng độ dài.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_1|mcq|1|prompt
    *Câu 2.* Vectơ-không ( #mi(`\vec{0}`) ) có đặc điểm gì?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_1|mcq|1|opt|0
      [A. Có độ dài bằng 1],
// @ANCHOR:dang_1|mcq|1|opt|1
      [B. Chỉ cùng phương với một số vectơ],
// @ANCHOR:dang_1|mcq|1|opt|2
      [C. Có độ dài bằng 0 và cùng phương với mọi vectơ],
// @ANCHOR:dang_1|mcq|1|opt|3
      [D. Không có hướng xác định],
    )
// @ANCHOR:dang_1|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: C] - Vectơ-không là vectơ đặc biệt có độ dài bằng 0 và cùng phương với mọi vectơ.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_1|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Hãy cho biết vectơ  #mi(`\vec{AB}`)  có bằng vectơ  #mi(`\vec{DC}`)  không? Vì sao?
// @ANCHOR:dang_1|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xét hướng. Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB // DC`)  và  #mi(`\vec{AB}`)  cùng hướng với  #mi(`\vec{DC}`) .
Bước 2: Xét độ dài. Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB = DC`) , suy ra  #mi(`|\vec{AB}| = |\vec{DC}|`) .
Kết luận: Vì  #mi(`\vec{AB}`)  và  #mi(`\vec{DC}`)  cùng hướng và cùng độ dài nên  #mi(`\vec{AB} = \vec{DC}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_1|drill|0|prompt
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`) . Áp dụng quy trình (Xét hướng  #mi(`\rightarrow`)  Xét độ dài  #mi(`\rightarrow`)  Kết luận) để kiểm tra xem các cặp vectơ sau có bằng nhau không:
// @ANCHOR:dang_1|drill|0|part|a|question
  - *a)* Cặp vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{A'B'}`) .
// @ANCHOR:dang_1|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Hướng:  #mi(`\vec{AB}`)  và  #mi(`\vec{A'B'}`)  cùng hướng (do  #mi(`ABB'A'`)  là hình chữ nhật). Độ dài:  #mi(`AB = A'B'`)  (cạnh hình lập phương). Vậy  #mi(`\vec{AB} = \vec{A'B'}`) . (Barem: Xét đúng hướng và độ dài: 1đ. Kết luận đúng: 0.5đ.)] \
    ]
// @ANCHOR:dang_1|drill|0|part|b|question
  - *b)* Cặp vectơ  #mi(`\vec{BC}`)  và  #mi(`\vec{AD}`) .
// @ANCHOR:dang_1|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Hướng:  #mi(`\vec{BC}`)  và  #mi(`\vec{AD}`)  cùng hướng (do  #mi(`ABCD`)  là hình vuông). Độ dài:  #mi(`BC = AD`)  (cạnh hình lập phương). Vậy  #mi(`\vec{BC} = \vec{AD}`) . (Barem: Xét đúng hướng và độ dài: 1đ. Kết luận đúng: 0.5đ.)] \
    ]
// @ANCHOR:dang_1|drill|0|part|c|question
  - *c)* Cặp vectơ  #mi(`\vec{CC'}`)  và  #mi(`\vec{BB'}`) .
// @ANCHOR:dang_1|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Hướng:  #mi(`\vec{CC'}`)  và  #mi(`\vec{BB'}`)  cùng hướng (do  #mi(`BCC'B'`)  là hình chữ nhật). Độ dài:  #mi(`CC' = BB'`)  (cạnh hình lập phương). Vậy  #mi(`\vec{CC'} = \vec{BB'}`) . (Barem: Xét đúng hướng và độ dài: 1đ. Kết luận đúng: 0.5đ.)] \
    ]
// @ANCHOR:dang_1|drill|0|part|d|question
  - *d)* Cặp vectơ  #mi(`\vec{DD'}`)  và  #mi(`\vec{A'A}`) .
// @ANCHOR:dang_1|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Hướng:  #mi(`\vec{DD'}`)  hướng lên,  #mi(`\vec{A'A}`)  hướng xuống  #mi(`\rightarrow`)  ngược hướng. Độ dài:  #mi(`DD' = A'A`) . Vì ngược hướng nên  #mi(`\vec{DD'} \neq \vec{A'A}`) . (Barem: Nhận ra ngược hướng: 1đ. Kết luận đúng: 0.5đ.)] \
    ]
// @ANCHOR:dang_1|drill|0|part|e|question
  - *e)* Cặp vectơ  #mi(`\vec{AA'}`)  và  #mi(`\vec{BB'}`) .
// @ANCHOR:dang_1|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Hướng:  #mi(`\vec{AA'}`)  và  #mi(`\vec{BB'}`)  cùng hướng (do  #mi(`ABB'A'`)  là hình chữ nhật). Độ dài:  #mi(`AA' = BB'`)  (cạnh hình lập phương). Vậy  #mi(`\vec{AA'} = \vec{BB'}`) . (Barem: Xét đúng hướng và độ dài: 1đ. Kết luận đúng: 0.5đ.)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 2: Dạng 2: Thao tác cộng, trừ vectơ bằng quy tắc nối đuôi và hình hộp ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 2. Dạng 2: Thao tác cộng, trừ vectơ bằng quy tắc nối đuôi và hình hộp]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_2|theory|0
  - Quy tắc 3 điểm (Nối đuôi):  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) . (Điểm cuối của vectơ này là điểm đầu của vectơ kia).
// @ANCHOR:dang_2|theory|1
  - Quy tắc hình hộp:  #mi(`\vec{AB} + \vec{AD} + \vec{AA'} = \vec{AC'}`) . (Tổng 3 cạnh chung đỉnh là vectơ đường chéo chính).
// @ANCHOR:dang_2|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khẩu quyết nối đuôi: 'Bỏ chữ giữa, lấy đầu cuối'  #mi(`\rightarrow`)   #mi(`\vec{A\underline{B}} + \vec{\underline{B}C} = \vec{AC}`) .
  ]
// @ANCHOR:dang_2|cloze

  - *Công thức cốt lõi:* Quy tắc 3 điểm:  #mi(`\vec{AB} + \vec{BC} = ...`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_2|mcq|0|prompt
    *Câu 1.* Theo quy tắc 3 điểm, tổng của hai vectơ  #mi(`\vec{AB}`)  và  #mi(`\vec{BC}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_2|mcq|0|opt|0
      [A.  #mi(`\vec{AC}`) ],
// @ANCHOR:dang_2|mcq|0|opt|1
      [B.  #mi(`\vec{BA}`) ],
// @ANCHOR:dang_2|mcq|0|opt|2
      [C.  #mi(`\vec{CB}`) ],
// @ANCHOR:dang_2|mcq|0|opt|3
      [D.  #mi(`\vec{AB}`) ],
    )
// @ANCHOR:dang_2|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: A] - Theo quy tắc 3 điểm,  #mi(`\vec{AB} + \vec{BC} = \vec{AC}`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_2|mcq|1|prompt
    *Câu 2.* Kết quả của phép toán  #mi(`\vec{AB} + \vec{BA}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_2|mcq|1|opt|0
      [A.  #mi(`\vec{AA}`) ],
// @ANCHOR:dang_2|mcq|1|opt|1
      [B.  #mi(`\vec{0}`) ],
// @ANCHOR:dang_2|mcq|1|opt|2
      [C.  #mi(`\vec{AB}`) ],
// @ANCHOR:dang_2|mcq|1|opt|3
      [D.  #mi(`\vec{BA}`) ],
    )
// @ANCHOR:dang_2|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Vì  #mi(`\vec{BA}`)  là vectơ đối của  #mi(`\vec{AB}`)  nên tổng của chúng bằng vectơ-không  #mi(`\vec{0}`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_2|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu: Rút gọn chuỗi vectơ:] Rút gọn tổng sau:  #mi(`\vec{MN} + \vec{NP} + \vec{PQ} + \vec{QR}`) 
// @ANCHOR:dang_2|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Nhóm hai vectơ đầu tiên:  #mi(`(\vec{MN} + \vec{NP}) + \vec{PQ} + \vec{QR} = \vec{MP} + \vec{PQ} + \vec{QR}`) .
Bước 2: Tiếp tục nối đuôi  #mi(`\vec{MP}`)  với  #mi(`\vec{PQ}`) :  #mi(`(\vec{MP} + \vec{PQ}) + \vec{QR} = \vec{MQ} + \vec{QR}`) .
Bước 3: Cuối cùng nối đuôi  #mi(`\vec{MQ}`)  với  #mi(`\vec{QR}`) :  #mi(`\vec{MQ} + \vec{QR} = \vec{MR}`) .
Kết luận:  #mi(`\vec{MN} + \vec{NP} + \vec{PQ} + \vec{QR} = \vec{MR}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_2|drill|0|prompt
  Áp dụng quy tắc nối đuôi (bỏ chữ ở giữa) để rút gọn các tổng vectơ sau:
// @ANCHOR:dang_2|drill|0|part|a|question
  - *a)*  #mi(`\vec{AB} + \vec{BC}`) 
// @ANCHOR:dang_2|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{AC}`)  (Barem: Đúng kết quả  #mi(`\vec{AC}`) )] \
    ]
// @ANCHOR:dang_2|drill|0|part|b|question
  - *b)*  #mi(`\vec{CD} + \vec{DE}`) 
// @ANCHOR:dang_2|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{CE}`)  (Barem: Đúng kết quả  #mi(`\vec{CE}`) )] \
    ]
// @ANCHOR:dang_2|drill|0|part|c|question
  - *c)*  #mi(`\vec{MN} + \vec{NP} + \vec{PQ}`) 
// @ANCHOR:dang_2|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{MQ}`)  (Barem: Đúng kết quả  #mi(`\vec{MQ}`) )] \
    ]
// @ANCHOR:dang_2|drill|0|part|d|question
  - *d)*  #mi(`\vec{XY} + \vec{YZ} + \vec{ZW} + \vec{WV}`) 
// @ANCHOR:dang_2|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{XV}`)  (Barem: Đúng kết quả  #mi(`\vec{XV}`) )] \
    ]
// @ANCHOR:dang_2|drill|0|part|e|question
  - *e)*  #mi(`\vec{PQ} + \vec{QR} + \vec{RS} + \vec{ST} + \vec{TU}`) 
// @ANCHOR:dang_2|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{PU}`)  (Barem: Đúng kết quả  #mi(`\vec{PU}`) )] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 3: Dạng 3: Nhân vectơ với một số và điều kiện cùng phương ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 3. Dạng 3: Nhân vectơ với một số và điều kiện cùng phương]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_3|theory|0
  - Tích của số thực  #mi(`k`)  với vectơ  #mi(`\vec{a}`)  là một vectơ  #mi(`k\vec{a}`)  có: Hướng cùng  #mi(`\vec{a}`)  nếu  #mi(`k > 0`) , ngược hướng  #mi(`\vec{a}`)  nếu  #mi(`k < 0`) .
// @ANCHOR:dang_3|theory|1
  - Độ dài của vectơ  #mi(`k\vec{a}`)  được tính bằng công thức:  #mi(`|k\vec{a}| = |k|\cdot|\vec{a}|`) .
// @ANCHOR:dang_3|theory|2
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  ( #mi(`\vec{b} \neq \vec{0}`) ) cùng phương khi và chỉ khi có một số thực  #mi(`k`)  sao cho  #mi(`\vec{a} = k\vec{b}`) .
// @ANCHOR:dang_3|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ nhanh:  #mi(`k`)  Dương  #mi(`\rightarrow`)  Cùng hướng;  #mi(`k`)  Âm  #mi(`\rightarrow`)  Ngược hướng; Độ dài thì luôn lấy giá trị tuyệt đối  #mi(`|k|`)  (không bao giờ âm).
  ]
// @ANCHOR:dang_3|cloze

  - *Công thức cốt lõi:* Vectơ  #mi(`k\vec{a}`)  cùng hướng với  #mi(`\vec{a}`)  khi  #mi(`k > ...`)  và ngược hướng với  #mi(`\vec{a}`)  khi  #mi(`k < ...`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_3|mcq|0|prompt
    *Câu 1.* Nếu  #mi(`k > 0`) , thì vectơ  #mi(`k\vec{a}`)  và vectơ  #mi(`\vec{a}`)  có mối quan hệ gì về hướng?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_3|mcq|0|opt|0
      [A. Ngược hướng],
// @ANCHOR:dang_3|mcq|0|opt|1
      [B. Cùng hướng],
// @ANCHOR:dang_3|mcq|0|opt|2
      [C. Vuông góc],
// @ANCHOR:dang_3|mcq|0|opt|3
      [D. Không cùng phương],
    )
// @ANCHOR:dang_3|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Khi  #mi(`k > 0`) , vectơ  #mi(`k\vec{a}`)  luôn cùng hướng với vectơ  #mi(`\vec{a}`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_3|mcq|1|prompt
    *Câu 2.* Công thức tính độ dài của vectơ  #mi(`k\vec{a}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_3|mcq|1|opt|0
      [A.  #mi(`|k\vec{a}| = k\cdot|\vec{a}|`) ],
// @ANCHOR:dang_3|mcq|1|opt|1
      [B.  #mi(`|k\vec{a}| = -k\cdot|\vec{a}|`) ],
// @ANCHOR:dang_3|mcq|1|opt|2
      [C.  #mi(`|k\vec{a}| = |k|\cdot|\vec{a}|`) ],
// @ANCHOR:dang_3|mcq|1|opt|3
      [D.  #mi(`|k\vec{a}| = |\vec{a}|`) ],
    )
// @ANCHOR:dang_3|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: C] - Độ dài của vectơ  #mi(`k\vec{a}`)  là  #mi(`|k\vec{a}| = |k|\cdot|\vec{a}|`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_3|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Cho vectơ  #mi(`\vec{a}`)  có độ dài  #mi(`|\vec{a}| = 5`) . Xác định hướng và độ dài của vectơ  #mi(`\vec{u} = -3\vec{a}`) .
// @ANCHOR:dang_3|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xét dấu của số  #mi(`k = -3`) . Vì  #mi(`-3 < 0`)  nên vectơ  #mi(`\vec{u} = -3\vec{a}`)  ngược hướng với vectơ  #mi(`\vec{a}`) .
Bước 2: Tính độ dài của  #mi(`\vec{u}`)  theo công thức  #mi(`|\vec{u}| = |-3|\cdot|\vec{a}| = 3 \cdot 5 = 15`) .
Kết luận: Vectơ  #mi(`\vec{u}`)  ngược hướng với  #mi(`\vec{a}`)  và có độ dài bằng  #mi(`15`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_3|drill|0|prompt
  Cho vectơ  #mi(`\vec{a}`)  có độ dài  #mi(`|\vec{a}| = 4`) . Áp dụng khuôn mẫu (xét dấu  #mi(`k \rightarrow`)  xác định hướng; tính  #mi(`|k|\cdot|\vec{a}| \rightarrow`)  xác định độ dài) để hoàn thành các ý sau:
// @ANCHOR:dang_3|drill|0|part|a|question
  - *a)* Xác định hướng và độ dài của vectơ  #mi(`\vec{u} = 2\vec{a}`) 
// @ANCHOR:dang_3|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`2 > 0 \Rightarrow \vec{u}`)  cùng hướng  #mi(`\vec{a}`) . Độ dài  #mi(`|\vec{u}| = |2|\cdot 4 = 8`) . (Barem: Đúng hướng: 0.5đ; Đúng độ dài: 0.5đ)] \
    ]
// @ANCHOR:dang_3|drill|0|part|b|question
  - *b)* Xác định hướng và độ dài của vectơ  #mi(`\vec{v} = -5\vec{a}`) 
// @ANCHOR:dang_3|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`-5 < 0 \Rightarrow \vec{v}`)  ngược hướng  #mi(`\vec{a}`) . Độ dài  #mi(`|\vec{v}| = |-5|\cdot 4 = 20`) . (Barem: Đúng hướng: 0.5đ; Đúng độ dài: 0.5đ)] \
    ]
// @ANCHOR:dang_3|drill|0|part|c|question
  - *c)* Xác định hướng và độ dài của vectơ  #mi(`\vec{w} = \frac{1}{2}\vec{a}`) 
// @ANCHOR:dang_3|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`\frac{1}{2} > 0 \Rightarrow \vec{w}`)  cùng hướng  #mi(`\vec{a}`) . Độ dài  #mi(`|\vec{w}| = |\frac{1}{2}|\cdot 4 = 2`) . (Barem: Đúng hướng: 0.5đ; Đúng độ dài: 0.5đ)] \
    ]
// @ANCHOR:dang_3|drill|0|part|d|question
  - *d)* Xác định hướng và độ dài của vectơ  #mi(`\vec{z} = -\frac{3}{4}\vec{a}`) 
// @ANCHOR:dang_3|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`-\frac{3}{4} < 0 \Rightarrow \vec{z}`)  ngược hướng  #mi(`\vec{a}`) . Độ dài  #mi(`|\vec{z}| = |-\frac{3}{4}|\cdot 4 = 3`) . (Barem: Đúng hướng: 0.5đ; Đúng độ dài: 0.5đ)] \
    ]
// @ANCHOR:dang_3|drill|0|part|e|question
  - *e)* Xác định hướng và độ dài của vectơ  #mi(`\vec{t} = 0\vec{a}`) 
// @ANCHOR:dang_3|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Vì  #mi(`k = 0 \Rightarrow \vec{t} = \vec{0}`) . Vectơ-không cùng phương với mọi vectơ và có độ dài  #mi(`|\vec{t}| = 0`) . (Barem: Đúng kết luận  #mi(`\vec{0}`) : 1đ)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 4: Dạng 4: Tính tích vô hướng và góc giữa hai vectơ (phương pháp hình học) ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 4. Dạng 4: Tính tích vô hướng và góc giữa hai vectơ (phương pháp hình học)]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_4|theory|0
  - Công thức tính tích vô hướng:  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) 
// @ANCHOR:dang_4|theory|1
  - Hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau khi và chỉ khi tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = 0`) .
// @ANCHOR:dang_4|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Nhớ kỹ: Tích vô hướng là một SỐ, không phải một VECTƠ. Nếu thấy kết quả ra  #mi(`\vec{...}`)  là sai!
  ]
// @ANCHOR:dang_4|cloze

  - *Công thức cốt lõi:*  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(...)`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_4|mcq|0|prompt
    *Câu 1.* Công thức nào sau đây dùng để tính tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  theo độ dài và góc?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_4|mcq|0|opt|0
      [A.  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| + |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) ],
// @ANCHOR:dang_4|mcq|0|opt|1
      [B.  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) ],
// @ANCHOR:dang_4|mcq|0|opt|2
      [C.  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \sin(\vec{a}, \vec{b})`) ],
// @ANCHOR:dang_4|mcq|0|opt|3
      [D.  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| + |\vec{b}| + \cos(\vec{a}, \vec{b})`) ],
    )
// @ANCHOR:dang_4|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Theo định nghĩa, tích vô hướng của hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  là  #mi(`\vec{a} \cdot \vec{b} = |\vec{a}| \cdot |\vec{b}| \cdot \cos(\vec{a}, \vec{b})`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_4|mcq|1|prompt
    *Câu 2.* Nếu hai vectơ  #mi(`\vec{a}`)  và  #mi(`\vec{b}`)  vuông góc với nhau thì tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`)  bằng bao nhiêu?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_4|mcq|1|opt|0
      [A.  #mi(`1`) ],
// @ANCHOR:dang_4|mcq|1|opt|1
      [B.  #mi(`-1`) ],
// @ANCHOR:dang_4|mcq|1|opt|2
      [C.  #mi(`0`) ],
// @ANCHOR:dang_4|mcq|1|opt|3
      [D.  #mi(`\pi`) ],
    )
// @ANCHOR:dang_4|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: C] - Vì  #mi(`\cos(90^\circ) = 0`)  nên tích vô hướng của hai vectơ vuông góc luôn bằng  #mi(`0`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_4|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Tính tích vô hướng  #mi(`\vec{AB} \cdot \vec{AD}`) .
// @ANCHOR:dang_4|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định độ dài hai vectơ:  #mi(`|\vec{AB}| = a`)  và  #mi(`|\vec{AD}| = a`) .
Bước 2: Xác định góc giữa hai vectơ: Vì  #mi(`ABCD`)  là hình vuông nên  #mi(`AB \perp AD`) , suy ra  #mi(`(\vec{AB}, \vec{AD}) = 90^\circ`) .
Bước 3: Áp dụng công thức:  #mi(`\vec{AB} \cdot \vec{AD} = |\vec{AB}| \cdot |\vec{AD}| \cdot \cos(90^\circ) = a \cdot a \cdot 0 = 0`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_4|drill|0|prompt
  Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng  #mi(`a`) . Áp dụng quy trình 3 bước (Độ dài  #mi(`\to`)  Góc  #mi(`\to`)  Nhân) để tính các tích vô hướng sau:
// @ANCHOR:dang_4|drill|0|part|a|question
  - *a)* Tính  #mi(`\vec{AB} \cdot \vec{AD}`) 
// @ANCHOR:dang_4|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`|\vec{AB}|=a, |\vec{AD}|=a, (\vec{AB}, \vec{AD})=90^\circ \Rightarrow \vec{AB} \cdot \vec{AD} = a \cdot a \cdot \cos(90^\circ) = 0`)  (Barem: Đúng độ dài và góc: 0.5đ; Kết quả cuối cùng đúng: 0.5đ)] \
    ]
// @ANCHOR:dang_4|drill|0|part|b|question
  - *b)* Tính  #mi(`\vec{AA'} \cdot \vec{AB}`) 
// @ANCHOR:dang_4|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`|\vec{AA'}|=a, |\vec{AB}|=a, (\vec{AA'}, \vec{AB})=90^\circ \Rightarrow \vec{AA'} \cdot \vec{AB} = a \cdot a \cdot \cos(90^\circ) = 0`)  (Barem: Đúng độ dài và góc: 0.5đ; Kết quả cuối cùng đúng: 0.5đ)] \
    ]
// @ANCHOR:dang_4|drill|0|part|c|question
  - *c)* Tính  #mi(`\vec{AB} \cdot \vec{AB}`) 
// @ANCHOR:dang_4|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`|\vec{AB}|=a, |\vec{AB}|=a, (\vec{AB}, \vec{AB})=0^\circ \Rightarrow \vec{AB} \cdot \vec{AB} = a \cdot a \cdot \cos(0^\circ) = a^2 \cdot 1 = a^2`)  (Barem: Đúng độ dài và góc: 0.5đ; Kết quả cuối cùng đúng: 0.5đ)] \
    ]
// @ANCHOR:dang_4|drill|0|part|d|question
  - *d)* Tính  #mi(`\vec{AD} \cdot \vec{AD}`) 
// @ANCHOR:dang_4|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`|\vec{AD}|=a, |\vec{AD}|=a, (\vec{AD}, \vec{AD})=0^\circ \Rightarrow \vec{AD} \cdot \vec{AD} = a \cdot a \cdot \cos(0^\circ) = a^2 \cdot 1 = a^2`)  (Barem: Đúng độ dài và góc: 0.5đ; Kết quả cuối cùng đúng: 0.5đ)] \
    ]
// @ANCHOR:dang_4|drill|0|part|e|question
  - *e)* Tính  #mi(`\vec{AB} \cdot \vec{BA}`) 
// @ANCHOR:dang_4|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`|\vec{AB}|=a, |\vec{BA}|=a, (\vec{AB}, \vec{BA})=180^\circ \Rightarrow \vec{AB} \cdot \vec{BA} = a \cdot a \cdot \cos(180^\circ) = a^2 \cdot (-1) = -a^2`)  (Barem: Đúng độ dài và góc: 0.5đ; Kết quả cuối cùng đúng: 0.5đ)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 5: Dạng 5: Thiết lập và nhận diện hệ trục tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 5. Dạng 5: Thiết lập và nhận diện hệ trục tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_5|theory|0
  - Hệ trục tọa độ  #mi(`Oxyz`)  gồm 3 trục  #mi(`Ox, Oy, Oz`)  đôi một vuông góc tại gốc  #mi(`O`) .
// @ANCHOR:dang_5|theory|1
  - Ba vectơ đơn vị  #mi(`\vec{i}, \vec{j}, \vec{k}`)  nằm trên các trục  #mi(`Ox, Oy, Oz`)  và có độ dài bằng 1.
// @ANCHOR:dang_5|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Để lập được hệ  #mi(`Oxyz`)  tại một đỉnh: Đỉnh đó làm gốc  #mi(`O`) , 3 cạnh xuất phát từ nó phải VUÔNG GÓC với nhau và ĐỘ DÀI bằng 1.
  ]
// @ANCHOR:dang_5|cloze

  - *Công thức cốt lõi:* Hệ trục tọa độ  #mi(`Oxyz`)  được gọi là hệ trục tọa độ Descartes vuông góc khi ba trục  #mi(`Ox, Oy, Oz`)  ... vuông góc với nhau tại gốc  #mi(`O`) .
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_5|mcq|0|prompt
    *Câu 1.* Trong hệ trục tọa độ  #mi(`Oxyz`) , điểm  #mi(`O`)  được gọi là gì?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_5|mcq|0|opt|0
      [A. Gốc tọa độ],
// @ANCHOR:dang_5|mcq|0|opt|1
      [B. Tâm tọa độ],
// @ANCHOR:dang_5|mcq|0|opt|2
      [C. Điểm đơn vị],
// @ANCHOR:dang_5|mcq|0|opt|3
      [D. Gốc trục  #mi(`Ox`) ],
    )
// @ANCHOR:dang_5|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: A] - Theo định nghĩa, điểm  #mi(`O`)  là gốc tọa độ của hệ trục  #mi(`Oxyz`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_5|mcq|1|prompt
    *Câu 2.* Ba trục  #mi(`Ox, Oy, Oz`)  trong hệ tọa độ  #mi(`Oxyz`)  có đặc điểm gì về góc giữa chúng?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_5|mcq|1|opt|0
      [A. Song song với nhau],
// @ANCHOR:dang_5|mcq|1|opt|1
      [B. Cùng phương],
// @ANCHOR:dang_5|mcq|1|opt|2
      [C. Đôi một vuông góc],
// @ANCHOR:dang_5|mcq|1|opt|3
      [D. Tạo với nhau góc  #mi(`45^\circ`) ],
    )
// @ANCHOR:dang_5|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: C] - Đặc điểm cốt lõi của hệ trục  #mi(`Oxyz`)  là ba trục đôi một vuông góc với nhau.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_5|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Cho hình lập phương  #mi(`ABCD.A'B'C'D'`)  có cạnh bằng 1. Có thể lập hệ trục tọa độ  #mi(`Oxyz`)  có gốc  #mi(`O`)  trùng với đỉnh  #mi(`B'`)  và các vectơ đơn vị  #mi(`\vec{i}, \vec{j}, \vec{k}`)  lần lượt là  #mi(`\vec{B'A'}, \vec{B'C'}, \vec{B'B}`)  không? Vì sao?
// @ANCHOR:dang_5|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xét 3 cạnh xuất phát từ đỉnh  #mi(`B'`)  là  #mi(`B'A', B'C'`)  và  #mi(`B'B`) .
Bước 2: Vì  #mi(`ABCD.A'B'C'D'`)  là hình lập phương nên  #mi(`B'A' \perp B'C', B'A' \perp B'B`)  và  #mi(`B'C' \perp B'B`)  (ba cạnh đôi một vuông góc).
Bước 3: Độ dài các cạnh của hình lập phương là 1, nên  #mi(`|\vec{B'A'}| = |\vec{B'C'}| = |\vec{B'B}| = 1`) .
Kết luận: Vì 3 vectơ  #mi(`\vec{B'A'}, \vec{B'C'}, \vec{B'B}`)  đôi một vuông góc và có độ dài bằng 1 nên có thể lập hệ trục tọa độ  #mi(`Oxyz`)  như yêu cầu.
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_5|drill|0|prompt
  Cho hình lập phương  #mi(`PQRS.P'Q'R'S'`)  có cạnh bằng 1. Hãy kiểm tra xem có thể lập hệ trục tọa độ  #mi(`Oxyz`)  với các thông số sau hay không (Trả lời Có/Không và giải thích ngắn gọn):
// @ANCHOR:dang_5|drill|0|part|a|question
  - *a)* Gốc  #mi(`O`)  trùng với đỉnh  #mi(`P`) , các vectơ đơn vị là  #mi(`\vec{PQ}, \vec{PS}, \vec{PP'}`) .
// @ANCHOR:dang_5|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Có. Vì  #mi(`PQ, PS, PP'`)  đôi một vuông góc và có độ dài bằng 1. (Barem: Đúng kết luận và nêu được lý do vuông góc + độ dài 1: 1 điểm)] \
    ]
// @ANCHOR:dang_5|drill|0|part|b|question
  - *b)* Gốc  #mi(`O`)  trùng với đỉnh  #mi(`Q`) , các vectơ đơn vị là  #mi(`\vec{QP}, \vec{QR}, \vec{QQ'}`) .
// @ANCHOR:dang_5|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Có. Vì  #mi(`QP, QR, QQ'`)  đôi một vuông góc và có độ dài bằng 1. (Barem: Đúng kết luận và nêu được lý do vuông góc + độ dài 1: 1 điểm)] \
    ]
// @ANCHOR:dang_5|drill|0|part|c|question
  - *c)* Gốc  #mi(`O`)  trùng với đỉnh  #mi(`R`) , các vectơ đơn vị là  #mi(`\vec{RQ}, \vec{RS}, \vec{RR'}`) .
// @ANCHOR:dang_5|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Có. Vì  #mi(`RQ, RS, RR'`)  đôi một vuông góc và có độ dài bằng 1. (Barem: Đúng kết luận và nêu được lý do vuông góc + độ dài 1: 1 điểm)] \
    ]
// @ANCHOR:dang_5|drill|0|part|d|question
  - *d)* Gốc  #mi(`O`)  trùng với đỉnh  #mi(`S`) , các vectơ đơn vị là  #mi(`\vec{SP}, \vec{SR}, \vec{SS'}`) .
// @ANCHOR:dang_5|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Có. Vì  #mi(`SP, SR, SS'`)  đôi một vuông góc và có độ dài bằng 1. (Barem: Đúng kết luận và nêu được lý do vuông góc + độ dài 1: 1 điểm)] \
    ]
// @ANCHOR:dang_5|drill|0|part|e|question
  - *e)* Gốc  #mi(`O`)  trùng với đỉnh  #mi(`P'`) , các vectơ đơn vị là  #mi(`\vec{P'Q'}, \vec{P'S'}, \vec{P'P}`) .
// @ANCHOR:dang_5|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải: Có. Vì  #mi(`P'Q', P'S', P'P`)  đôi một vuông góc và có độ dài bằng 1. (Barem: Đúng kết luận và nêu được lý do vuông góc + độ dài 1: 1 điểm)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 6: Dạng 6: Tính tọa độ vectơ bằng quy tắc 'Ngọn trừ Gốc' và tọa độ điểm đặc biệt ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 6. Dạng 6: Tính tọa độ vectơ bằng quy tắc 'Ngọn trừ Gốc' và tọa độ điểm đặc biệt]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_6|theory|0
  - Tọa độ vectơ  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) .
// @ANCHOR:dang_6|theory|1
  - Tọa độ trung điểm  #mi(`M`)  của  #mi(`AB`) :  #mi(`x_M = \frac{x_A + x_B}{2}, y_M = \frac{y_A + y_B}{2}, z_M = \frac{z_A + z_B}{2}`) .
// @ANCHOR:dang_6|theory|2
  - Tọa độ trọng tâm  #mi(`G`)  của  #mi(`\triangle ABC`) :  #mi(`x_G = \frac{x_A + x_B + x_C}{3}, y_G = \frac{y_A + y_B + y_C}{3}, z_G = \frac{z_A + z_B + z_C}{3}`) .
// @ANCHOR:dang_6|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khẩu quyết tính vectơ: 'LẤY NGỌN TRỪ GỐC' (Lấy tọa độ điểm cuối trừ tọa độ điểm đầu).
  ]
// @ANCHOR:dang_6|cloze

  - *Công thức cốt lõi:*  #mi(`\vec{MN} = (x_{\text{...}} - x_{\text{...}}; y_{\text{...}} - y_{\text{...}}; z_{\text{...}} - z_{\text{...}})`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_6|mcq|0|prompt
    *Câu 1.* Để tính tọa độ vectơ  #mi(`\vec{AB}`)  khi biết  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`) , ta thực hiện phép tính nào?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_6|mcq|0|opt|0
      [A.  #mi(`(x_A + x_B; y_A + y_B; z_A + z_B)`) ],
// @ANCHOR:dang_6|mcq|0|opt|1
      [B.  #mi(`(x_B - x_A; y_B - y_A; z_B - z_A)`) ],
// @ANCHOR:dang_6|mcq|0|opt|2
      [C.  #mi(`(x_A - x_B; y_A - y_B; z_A - z_B)`) ],
// @ANCHOR:dang_6|mcq|0|opt|3
      [D.  #mi(`(x_B \cdot x_A; y_B \cdot y_A; z_B \cdot z_A)`) ],
    )
// @ANCHOR:dang_6|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Áp dụng quy tắc 'Ngọn trừ Gốc', tọa độ  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_6|mcq|1|prompt
    *Câu 2.* Cho  #mi(`M(1; 2; 3)`)  và  #mi(`N(4; 6; 8)`) . Tọa độ vectơ  #mi(`\vec{MN}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_6|mcq|1|opt|0
      [A.  #mi(`(3; 4; 5)`) ],
// @ANCHOR:dang_6|mcq|1|opt|1
      [B.  #mi(`(-3; -4; -5)`) ],
// @ANCHOR:dang_6|mcq|1|opt|2
      [C.  #mi(`(5; 8; 11)`) ],
// @ANCHOR:dang_6|mcq|1|opt|3
      [D.  #mi(`(3; 2; 1)`) ],
    )
// @ANCHOR:dang_6|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: A] -  #mi(`\vec{MN} = (4 - 1; 6 - 2; 8 - 3) = (3; 4; 5)`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_6|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`A(1; -2; 4)`)  và  #mi(`B(3; 5; -1)`) . Tính tọa độ vectơ  #mi(`\vec{AB}`) .
// @ANCHOR:dang_6|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định điểm 'Ngọn' là  #mi(`B(3; 5; -1)`)  và điểm 'Gốc' là  #mi(`A(1; -2; 4)`) .
Bước 2: Áp dụng công thức 'Ngọn trừ Gốc':
 #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) 
Bước 3: Thay số vào tính toán:
 #mi(`\vec{AB} = (3 - 1; 5 - (-2); -1 - 4)`) 
Bước 4: Tính kết quả cuối cùng (lưu ý dấu trừ):
 #mi(`\vec{AB} = (2; 7; -5)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_6|drill|0|prompt
  Cho bốn điểm  #mi(`P(2; 1; -3)`) ,  #mi(`Q(0; 4; 5)`) ,  #mi(`R(-1; -2; 0)`)  và  #mi(`S(3; 0; 2)`) . Áp dụng quy tắc 'Ngọn trừ Gốc' để tính tọa độ các vectơ sau:
// @ANCHOR:dang_6|drill|0|part|a|question
  - *a)* Tính  #mi(`\vec{PQ}`) 
// @ANCHOR:dang_6|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{PQ} = (0 - 2; 4 - 1; 5 - (-3)) = (-2; 3; 8)`)  (Barem: Đúng công thức trừ và đúng kết quả: 1 điểm)] \
    ]
// @ANCHOR:dang_6|drill|0|part|b|question
  - *b)* Tính  #mi(`\vec{QR}`) 
// @ANCHOR:dang_6|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{QR} = (-1 - 0; -2 - 4; 0 - 5) = (-1; -6; -5)`)  (Barem: Đúng công thức trừ và đúng kết quả: 1 điểm)] \
    ]
// @ANCHOR:dang_6|drill|0|part|c|question
  - *c)* Tính  #mi(`\vec{RS}`) 
// @ANCHOR:dang_6|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{RS} = (3 - (-1); 0 - (-2); 2 - 0) = (4; 2; 2)`)  (Barem: Đúng công thức trừ và đúng kết quả: 1 điểm)] \
    ]
// @ANCHOR:dang_6|drill|0|part|d|question
  - *d)* Tính  #mi(`\vec{SP}`) 
// @ANCHOR:dang_6|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{SP} = (2 - 3; 1 - 0; -3 - 2) = (-1; 1; -5)`)  (Barem: Đúng công thức trừ và đúng kết quả: 1 điểm)] \
    ]
// @ANCHOR:dang_6|drill|0|part|e|question
  - *e)* Tính  #mi(`\vec{PR}`) 
// @ANCHOR:dang_6|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{PR} = (-1 - 2; -2 - 1; 0 - (-3)) = (-3; -3; 3)`)  (Barem: Đúng công thức trừ và đúng kết quả: 1 điểm)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 7: Dạng 7: Cộng, trừ và nhân tọa độ vectơ theo từng thành phần ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 7. Dạng 7: Cộng, trừ và nhân tọa độ vectơ theo từng thành phần]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_7|theory|0
  - Cộng/Trừ: Cộng hoặc trừ các hoành độ với nhau, tung độ với nhau, cao độ với nhau.
// @ANCHOR:dang_7|theory|1
  - Nhân số thực: Nhân số đó vào cả 3 thành phần của vectơ.
// @ANCHOR:dang_7|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khẩu quyết: 'X đi với X, Y đi với Y, Z đi với Z' - Cứ đúng vị trí mà tính, không được râu ông nọ cắm cằm bà kia!
  ]
// @ANCHOR:dang_7|cloze

  - *Công thức cốt lõi:* Nếu  #mi(`\vec{a} = (x; y; z)`)  và  #mi(`\vec{b} = (x'; y'; z')`)  thì  #mi(`\vec{a} + \vec{b} = (... + x'; ... + y'; ... + z')`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_7|mcq|0|prompt
    *Câu 1.* Cho  #mi(`\vec{a} = (1; 2; 3)`)  và  #mi(`\vec{b} = (0; 1; 1)`) . Tọa độ của vectơ  #mi(`\vec{a} + \vec{b}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_7|mcq|0|opt|0
      [A.  #mi(`(1; 3; 4)`) ],
// @ANCHOR:dang_7|mcq|0|opt|1
      [B.  #mi(`(1; 1; 2)`) ],
// @ANCHOR:dang_7|mcq|0|opt|2
      [C.  #mi(`(2; 3; 4)`) ],
// @ANCHOR:dang_7|mcq|0|opt|3
      [D.  #mi(`(1; 3; 3)`) ],
    )
// @ANCHOR:dang_7|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: A] - Cộng từng thành phần tương ứng:  #mi(`(1+0; 2+1; 3+1) = (1; 3; 4)`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_7|mcq|1|prompt
    *Câu 2.* Cho  #mi(`\vec{a} = (2; -1; 4)`)  và số  #mi(`k = 2`) . Tọa độ của vectơ  #mi(`k\vec{a}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_7|mcq|1|opt|0
      [A.  #mi(`(4; -1; 8)`) ],
// @ANCHOR:dang_7|mcq|1|opt|1
      [B.  #mi(`(4; -2; 8)`) ],
// @ANCHOR:dang_7|mcq|1|opt|2
      [C.  #mi(`(2; -2; 8)`) ],
// @ANCHOR:dang_7|mcq|1|opt|3
      [D.  #mi(`(4; 2; 8)`) ],
    )
// @ANCHOR:dang_7|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Nhân số  #mi(`k=2`)  vào từng thành phần của  #mi(`\vec{a}`) :  #mi(`(2\cdot 2; -1\cdot 2; 4\cdot 2) = (4; -2; 8)`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_7|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a} = (2; 1; 5)`)  và  #mi(`\vec{b} = (2; 2; 1)`) . Tính tọa độ vectơ  #mi(`\vec{u} = 3\vec{a} + 2\vec{b}`) .
// @ANCHOR:dang_7|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính  #mi(`3\vec{a}`) :  #mi(`3\vec{a} = (3\cdot 2; 3\cdot 1; 3\cdot 5) = (6; 3; 15)`) .
Bước 2: Tính  #mi(`2\vec{b}`) :  #mi(`2\vec{b} = (2\cdot 2; 2\cdot 2; 2\cdot 1) = (4; 4; 2)`) .
Bước 3: Cộng hai kết quả trên:  #mi(`\vec{u} = (6+4; 3+4; 15+2) = (10; 7; 17)`) .
Vậy  #mi(`\vec{u} = (10; 7; 17)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_7|drill|0|prompt
  Áp dụng quy tắc tính theo từng thành phần, hãy tìm tọa độ các vectơ sau:
// @ANCHOR:dang_7|drill|0|part|a|question
  - *a)* Cho  #mi(`\vec{a} = (1; 3; 2)`)  và  #mi(`\vec{b} = (2; 1; 4)`) . Tính  #mi(`\vec{a} + \vec{b}`) .
// @ANCHOR:dang_7|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} + \vec{b} = (1+2; 3+1; 2+4) = (3; 4; 6)`)  (Barem: Tính đúng 3 thành phần: 1đ)] \
    ]
// @ANCHOR:dang_7|drill|0|part|b|question
  - *b)* Cho  #mi(`\vec{a} = (5; 0; -1)`)  và  #mi(`\vec{b} = (-2; 4; 3)`) . Tính  #mi(`\vec{a} + \vec{b}`) .
// @ANCHOR:dang_7|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} + \vec{b} = (5+(-2); 0+4; -1+3) = (3; 4; 2)`)  (Barem: Tính đúng 3 thành phần: 1đ)] \
    ]
// @ANCHOR:dang_7|drill|0|part|c|question
  - *c)* Cho  #mi(`\vec{a} = (1; 1; 1)`)  và  #mi(`\vec{b} = (2; 2; 2)`) . Tính  #mi(`\vec{a} - \vec{b}`) .
// @ANCHOR:dang_7|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} - \vec{b} = (1-2; 1-2; 1-2) = (-1; -1; -1)`)  (Barem: Tính đúng 3 thành phần: 1đ)] \
    ]
// @ANCHOR:dang_7|drill|0|part|d|question
  - *d)* Cho  #mi(`\vec{a} = (3; -2; 4)`)  và  #mi(`\vec{b} = (1; 5; -2)`) . Tính  #mi(`\vec{a} - \vec{b}`) .
// @ANCHOR:dang_7|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} - \vec{b} = (3-1; -2-5; 4-(-2)) = (2; -7; 6)`)  (Barem: Tính đúng 3 thành phần: 1đ)] \
    ]
// @ANCHOR:dang_7|drill|0|part|e|question
  - *e)* Cho  #mi(`\vec{a} = (2; -3; 1)`)  và số  #mi(`k = 3`) . Tính  #mi(`k\vec{a}`) .
// @ANCHOR:dang_7|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`3\vec{a} = (3\cdot 2; 3\cdot(-3); 3\cdot 1) = (6; -9; 3)`)  (Barem: Tính đúng 3 thành phần: 1đ)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 8: Dạng 8: Tính tích vô hướng và độ dài vectơ bằng tọa độ ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 8. Dạng 8: Tính tích vô hướng và độ dài vectơ bằng tọa độ]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_8|theory|0
  - Tích vô hướng của hai vectơ  #mi(`\vec{a}(x; y; z)`)  và  #mi(`\vec{b}(x'; y'; z')`)  là:  #mi(`\vec{a} \cdot \vec{b} = x \cdot x' + y \cdot y' + z \cdot z'`) .
// @ANCHOR:dang_8|theory|1
  - Độ dài của vectơ  #mi(`\vec{a}(x; y; z)`)  là:  #mi(`|\vec{a}| = \sqrt{x^2 + y^2 + z^2}`) .
// @ANCHOR:dang_8|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Tích vô hướng: 'Nhân ngang, cộng hết'. Độ dài: 'Bình phương hết, cộng lại rồi căn'.
  ]
// @ANCHOR:dang_8|cloze

  - *Công thức cốt lõi:* Tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = ... + ... + ...`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_8|mcq|0|prompt
    *Câu 1.* Cho hai vectơ  #mi(`\vec{a}(x; y; z)`)  và  #mi(`\vec{b}(x'; y'; z')`) . Công thức tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`)  là gì?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_8|mcq|0|opt|0
      [A.  #mi(`x+x' + y+y' + z+z'`) ],
// @ANCHOR:dang_8|mcq|0|opt|1
      [B.  #mi(`x \cdot x' + y \cdot y' + z \cdot z'`) ],
// @ANCHOR:dang_8|mcq|0|opt|2
      [C.  #mi(`\sqrt{x^2+x'^2 + y^2+y'^2 + z^2+z'^2}`) ],
// @ANCHOR:dang_8|mcq|0|opt|3
      [D.  #mi(`x \cdot z' + y \cdot y' + z \cdot x'`) ],
    )
// @ANCHOR:dang_8|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Theo định nghĩa, tích vô hướng của hai vectơ là tổng tích các tọa độ tương ứng:  #mi(`x \cdot x' + y \cdot y' + z \cdot z'`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_8|mcq|1|prompt
    *Câu 2.* Cho vectơ  #mi(`\vec{a}(x; y; z)`) . Công thức tính độ dài  #mi(`|\vec{a}|`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_8|mcq|1|opt|0
      [A.  #mi(`x+y+z`) ],
// @ANCHOR:dang_8|mcq|1|opt|1
      [B.  #mi(`\sqrt{x+y+z}`) ],
// @ANCHOR:dang_8|mcq|1|opt|2
      [C.  #mi(`\sqrt{x^2 + y^2 + z^2}`) ],
// @ANCHOR:dang_8|mcq|1|opt|3
      [D.  #mi(`x^2 + y^2 + z^2`) ],
    )
// @ANCHOR:dang_8|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: C] - Độ dài vectơ  #mi(`\vec{a}`)  được tính bằng căn bậc hai của tổng bình phương các tọa độ của nó.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_8|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Trong không gian  #mi(`Oxyz`) , cho  #mi(`\vec{a}(1; 2; -3)`)  và  #mi(`\vec{b}(4; -1; 2)`) . Tính  #mi(`\vec{a} \cdot \vec{b}`)  và  #mi(`|\vec{a}|`) .
// @ANCHOR:dang_8|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Tính tích vô hướng  #mi(`\vec{a} \cdot \vec{b}`)  bằng cách nhân tương ứng các tọa độ rồi cộng lại:
 #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 4 + 2 \cdot (-1) + (-3) \cdot 2 = 4 - 2 - 6 = -4`) .

Bước 2: Tính độ dài vectơ  #mi(`\vec{a}`)  bằng cách bình phương các tọa độ, cộng lại rồi lấy căn:
 #mi(`|\vec{a}| = \sqrt{1^2 + 2^2 + (-3)^2} = \sqrt{1 + 4 + 9} = \sqrt{14}`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_8|drill|0|prompt
  Áp dụng công thức tích vô hướng  #mi(`\vec{a} \cdot \vec{b} = x \cdot x' + y \cdot y' + z \cdot z'`) , hãy tính các tích sau:
// @ANCHOR:dang_8|drill|0|part|a|question
  - *a)*  #mi(`\vec{a}(1; 0; 2)`)  và  #mi(`\vec{b}(3; 1; 4)`) 
// @ANCHOR:dang_8|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} \cdot \vec{b} = 1 \cdot 3 + 0 \cdot 1 + 2 \cdot 4 = 3 + 0 + 8 = 11`)  (Barem: Tính đúng từng tích thành phần: 0.25đ, Kết quả cuối cùng đúng: 0.25đ)] \
    ]
// @ANCHOR:dang_8|drill|0|part|b|question
  - *b)*  #mi(`\vec{a}(-2; 3; 1)`)  và  #mi(`\vec{b}(1; -1; 5)`) 
// @ANCHOR:dang_8|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} \cdot \vec{b} = (-2) \cdot 1 + 3 \cdot (-1) + 1 \cdot 5 = -2 - 3 + 5 = 0`)  (Barem: Tính đúng từng tích thành phần: 0.25đ, Kết quả cuối cùng đúng: 0.25đ)] \
    ]
// @ANCHOR:dang_8|drill|0|part|c|question
  - *c)*  #mi(`\vec{a}(0; -4; 3)`)  và  #mi(`\vec{b}(-2; 2; 0)`) 
// @ANCHOR:dang_8|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} \cdot \vec{b} = 0 \cdot (-2) + (-4) \cdot 2 + 3 \cdot 0 = 0 - 8 + 0 = -8`)  (Barem: Tính đúng từng tích thành phần: 0.25đ, Kết quả cuối cùng đúng: 0.25đ)] \
    ]
// @ANCHOR:dang_8|drill|0|part|d|question
  - *d)*  #mi(`\vec{a}(5; 2; -1)`)  và  #mi(`\vec{b}(-1; 3; 2)`) 
// @ANCHOR:dang_8|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{a} \cdot \vec{b} = 5 \cdot (-1) + 2 \cdot 3 + (-1) \cdot 2 = -5 + 6 - 2 = -1`)  (Barem: Tính đúng từng tích thành phần: 0.25đ, Kết quả cuối cùng đúng: 0.25đ)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 9: Dạng 9: Mô hình hóa bài toán thực tế sang tọa độ Oxyz ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 9. Dạng 9: Mô hình hóa bài toán thực tế sang tọa độ Oxyz]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_9|theory|0
  - Bước 1: Chọn gốc tọa độ  #mi(`O`)  (thường là góc phòng, điểm xuất phát).
// @ANCHOR:dang_9|theory|1
  - Bước 2: Gán 3 trục  #mi(`Ox, Oy, Oz`)  vuông góc với nhau (thường là các cạnh tường, sàn nhà, hướng Đông-Tây-Nam-Bắc).
// @ANCHOR:dang_9|theory|2
  - Bước 3: Tọa độ điểm  #mi(`M(x; y; z)`)  chính là khoảng cách từ điểm đó đến 3 mặt phẳng tọa độ  #mi(`(Oyz), (Oxz), (Oxy)`) .
// @ANCHOR:dang_9|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Mẹo gán tọa độ: 'Chiều dài  #mi(`\rightarrow x`) , Chiều rộng  #mi(`\rightarrow y`) , Chiều cao  #mi(`\rightarrow z`) '. Khoảng cách giữa 2 điểm: 'Ngọn trừ gốc, bình phương hết, cộng lại, căn bậc hai'.
  ]
// @ANCHOR:dang_9|cloze

  - *Công thức cốt lõi:* Khoảng cách giữa hai điểm  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  là  #mi(`AB = \sqrt{(x_B - ...)^2 + (y_B - ...)^2 + (z_B - ...)^2}`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_9|mcq|0|prompt
    *Câu 1.* Trong hệ tọa độ  #mi(`Oxyz`) , điểm  #mi(`M`)  cách mặt phẳng  #mi(`(Oyz)`)  một khoảng bằng  #mi(`2`) , cách mặt phẳng  #mi(`(Oxz)`)  một khoảng bằng  #mi(`3`)  và cách mặt phẳng  #mi(`(Oxy)`)  một khoảng bằng  #mi(`4`) . Tọa độ của điểm  #mi(`M`)  (giả sử  #mi(`M`)  nằm trong góc phần tư thứ nhất) là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_9|mcq|0|opt|0
      [A.  #mi(`M(2; 3; 4)`) ],
// @ANCHOR:dang_9|mcq|0|opt|1
      [B.  #mi(`M(3; 2; 4)`) ],
// @ANCHOR:dang_9|mcq|0|opt|2
      [C.  #mi(`M(4; 3; 2)`) ],
// @ANCHOR:dang_9|mcq|0|opt|3
      [D.  #mi(`M(2; 4; 3)`) ],
    )
// @ANCHOR:dang_9|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: A] - Theo định nghĩa, khoảng cách từ điểm đến các mặt phẳng tọa độ tương ứng với các thành phần  #mi(`x, y, z`)  của tọa độ điểm đó.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_9|mcq|1|prompt
    *Câu 2.* Công thức tính khoảng cách giữa hai điểm  #mi(`A(1; 0; 0)`)  và  #mi(`B(0; 1; 0)`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_9|mcq|1|opt|0
      [A.  #mi(`\sqrt{1+0+0}`) ],
// @ANCHOR:dang_9|mcq|1|opt|1
      [B.  #mi(`\sqrt{(0-1)^2 + (1-0)^2 + (0-0)^2}`) ],
// @ANCHOR:dang_9|mcq|1|opt|2
      [C.  #mi(`1 + 1 + 0`) ],
// @ANCHOR:dang_9|mcq|1|opt|3
      [D.  #mi(`\sqrt{1^2 + 0^2 + 0^2}`) ],
    )
// @ANCHOR:dang_9|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Áp dụng đúng công thức tính khoảng cách giữa hai điểm trong không gian.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_9|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu: Tính khoảng cách bóng đèn:] Một chiếc bóng đèn được treo trong phòng. Gốc tọa độ  #mi(`O`)  đặt tại một góc phòng. Bóng đèn lúc đầu ở vị trí  #mi(`A(1,2; 1,6; 0,5)`)  và sau khi di chuyển đến vị trí  #mi(`B(1,5; 1,5; 0,4)`) . Tính khoảng cách giữa hai vị trí của bóng đèn.
// @ANCHOR:dang_9|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định tọa độ hai điểm  #mi(`A(1,2; 1,6; 0,5)`)  và  #mi(`B(1,5; 1,5; 0,4)`) .
Bước 2: Áp dụng công thức tính khoảng cách:
 #mi(`AB = \sqrt{(1,5 - 1,2)^2 + (1,5 - 1,6)^2 + (0,4 - 0,5)^2}`) 
Bước 3: Tính toán chi tiết:
 #mi(`AB = \sqrt{(0,3)^2 + (-0,1)^2 + (-0,1)^2} = \sqrt{0,09 + 0,01 + 0,01} = \sqrt{0,11} \approx 0,33 \text{ (m)}.`) 
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_9|drill|0|prompt
  Áp dụng công thức 'Ngọn trừ gốc  #mi(`\rightarrow`)  Bình phương  #mi(`\rightarrow`)  Cộng  #mi(`\rightarrow`)  Căn' để tính khoảng cách giữa các cặp điểm sau:
// @ANCHOR:dang_9|drill|0|part|a|question
  - *a)* Điểm  #mi(`M(1; 2; 3)`)  và  #mi(`N(2; 4; 5)`) 
// @ANCHOR:dang_9|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`MN = \sqrt{(2-1)^2 + (4-2)^2 + (5-3)^2} = \sqrt{1^2 + 2^2 + 2^2} = \sqrt{9} = 3`)  (Barem: Thay đúng số vào công thức: 0.5đ; Tính đúng kết quả: 0.5đ)] \
    ]
// @ANCHOR:dang_9|drill|0|part|b|question
  - *b)* Điểm  #mi(`P(0; 1; 2)`)  và  #mi(`Q(3; 4; 2)`) 
// @ANCHOR:dang_9|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`PQ = \sqrt{(3-0)^2 + (4-1)^2 + (2-2)^2} = \sqrt{3^2 + 3^2 + 0^2} = \sqrt{18} = 3\sqrt{2}`)  (Barem: Thay đúng số vào công thức: 0.5đ; Tính đúng kết quả: 0.5đ)] \
    ]
// @ANCHOR:dang_9|drill|0|part|c|question
  - *c)* Điểm  #mi(`R(-1; 0; 2)`)  và  #mi(`S(1; 2; 0)`) 
// @ANCHOR:dang_9|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`RS = \sqrt{(1-(-1))^2 + (2-0)^2 + (0-2)^2} = \sqrt{2^2 + 2^2 + (-2)^2} = \sqrt{12} = 2\sqrt{3}`)  (Barem: Thay đúng số vào công thức: 0.5đ; Tính đúng kết quả: 0.5đ)] \
    ]
// @ANCHOR:dang_9|drill|0|part|d|question
  - *d)* Điểm  #mi(`A(2; 2; 1)`)  và  #mi(`B(5; 5; 5)`) 
// @ANCHOR:dang_9|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`AB = \sqrt{(5-2)^2 + (5-2)^2 + (5-1)^2} = \sqrt{3^2 + 3^2 + 4^2} = \sqrt{34}`)  (Barem: Thay đúng số vào công thức: 0.5đ; Tính đúng kết quả: 0.5đ)] \
    ]
// @ANCHOR:dang_9|drill|0|part|e|question
  - *e)* Điểm  #mi(`C(0; 0; 0)`)  và  #mi(`D(1; 1; 1)`) 
// @ANCHOR:dang_9|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`CD = \sqrt{(1-0)^2 + (1-0)^2 + (1-0)^2} = \sqrt{1^2 + 1^2 + 1^2} = \sqrt{3}`)  (Barem: Thay đúng số vào công thức: 0.5đ; Tính đúng kết quả: 0.5đ)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)

// ==================== DẠNG 10: Dạng 10: Tổng hợp kỹ năng vectơ và tọa độ không gian ====================
#v(8pt)
#text(size: 13pt, weight: "bold", fill: rgb("#1e3a8a"))[Dạng 10. Dạng 10: Tổng hợp kỹ năng vectơ và tọa độ không gian]
#v(3pt)
#card(title: "I. Lý thuyết & Ghi nhớ")[
// @ANCHOR:dang_10|theory|0
  - Tọa độ vectơ  #mi(`\vec{AB}`)  được tính bằng cách lấy tọa độ điểm cuối (B) trừ tọa độ điểm đầu (A).
// @ANCHOR:dang_10|theory|1
  - Công thức tổng quát: Với  #mi(`A(x_A; y_A; z_A)`)  và  #mi(`B(x_B; y_B; z_B)`)  thì  #mi(`\vec{AB} = (x_B - x_A; y_B - y_A; z_B - z_A)`) .
// @ANCHOR:dang_10|callout
  #v(4pt)
  #block(fill: rgb("#f0fdf4"), stroke: (left: 4pt + rgb("#22c55e")), inset: 8pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#15803d"))[💡 Mẹo giải nhanh:] Khẩu quyết: 'NGỌN TRỪ GỐC' (Điểm cuối trừ điểm đầu). Nhớ: X trừ X, Y trừ Y, Z trừ Z.
  ]
// @ANCHOR:dang_10|cloze

  - *Công thức cốt lõi:*  #mi(`\vec{AB} = (... - x_A; ... - y_A; ... - z_A)`) 
]
#v(4pt)
#card(title: "II. Khởi động nhanh (Nhận biết cơ bản)")[
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_10|mcq|0|prompt
    *Câu 1.* Để tính tọa độ của vectơ  #mi(`\vec{MN}`) , ta thực hiện phép toán nào sau đây?
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_10|mcq|0|opt|0
      [A. Lấy tọa độ M trừ tọa độ N],
// @ANCHOR:dang_10|mcq|0|opt|1
      [B. Lấy tọa độ N trừ tọa độ M],
// @ANCHOR:dang_10|mcq|0|opt|2
      [C. Cộng tọa độ M và tọa độ N],
// @ANCHOR:dang_10|mcq|0|opt|3
      [D. Nhân tọa độ M với tọa độ N],
    )
// @ANCHOR:dang_10|mcq|0|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: B] - Để tìm tọa độ vectơ, ta lấy tọa độ điểm cuối trừ tọa độ điểm đầu.
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
  #block(width: 100%, breakable: false)[
// @ANCHOR:dang_10|mcq|1|prompt
    *Câu 2.* Cho điểm  #mi(`A(1; 2; 3)`)  và  #mi(`B(2; 3; 4)`) . Tọa độ của vectơ  #mi(`\vec{AB}`)  là:
    #v(2pt)
    #grid(columns: (1fr, 1fr), row-gutter: 4pt,
// @ANCHOR:dang_10|mcq|1|opt|0
      [A.  #mi(`(1; 1; 1)`) ],
// @ANCHOR:dang_10|mcq|1|opt|1
      [B.  #mi(`(-1; -1; -1)`) ],
// @ANCHOR:dang_10|mcq|1|opt|2
      [C.  #mi(`(3; 5; 7)`) ],
// @ANCHOR:dang_10|mcq|1|opt|3
      [D.  #mi(`(0; 0; 0)`) ],
    )
// @ANCHOR:dang_10|mcq|1|solution
    #if IS_TEACHER [
      #v(2pt)
      #text(weight: "bold", fill: rgb("#15803d"))[Đáp án: A] - Áp dụng ngọn trừ gốc:  #mi(`\vec{AB} = (2-1; 3-2; 4-3) = (1; 1; 1)`) .
    ] else [
      #v(3pt)
      #table(columns: (35pt, 35pt, 35pt, 35pt), align: center + horizon, [*A*], [*B*], [*C*], [*D*])
    ]
  ]
  #v(6pt)
]
#v(4pt)
#card(title: "III. Ví dụ minh họa")[
// @ANCHOR:dang_10|example|0|problem
  #block(fill: rgb("#f1f5f9"), stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
    #text(weight: "bold", fill: rgb("#0369a1"))[Ví dụ mẫu 1:] Trong không gian  #mi(`Oxyz`) , cho hai điểm  #mi(`M(2; -1; 5)`)  và  #mi(`N(4; 3; -2)`) . Tính tọa độ vectơ  #mi(`\vec{MN}`) .
// @ANCHOR:dang_10|example|0|solution
    #if IS_TEACHER [
      \ #v(3pt) #text(weight: "bold", fill: rgb("#15803d"))[Lời giải:] Bước 1: Xác định điểm đầu là  #mi(`M(2; -1; 5)`)  và điểm cuối là  #mi(`N(4; 3; -2)`) .
Bước 2: Áp dụng công thức 'Ngọn trừ Gốc':  #mi(`\vec{MN} = (x_N - x_M; y_N - y_M; z_N - z_M)`) .
Bước 3: Thay số cụ thể:
 #mi(`\vec{MN} = (4 - 2; 3 - (-1); -2 - 5)`) 
 #mi(`\vec{MN} = (2; 3 + 1; -7)`) 
 #mi(`\vec{MN} = (2; 4; -7)`) .
Vậy tọa độ vectơ  #mi(`\vec{MN}`)  là  #mi(`(2; 4; -7)`) .
    ] else [ \ #v(16pt) ]
  ]
]
#v(4pt)
#card(title: "IV. Bài tập thực hành lặp lại (Rèn phản xạ cơ bắp)")[
// @ANCHOR:dang_10|drill|0|prompt
  Áp dụng quy tắc 'Ngọn trừ Gốc' để tính tọa độ các vectơ sau (Cho các điểm:  #mi(`A(1; 0; 2), B(3; 2; 5), C(0; 4; 1), D(2; -1; 3)`) ):
// @ANCHOR:dang_10|drill|0|part|a|question
  - *a)* Tính tọa độ  #mi(`\vec{AB}`) 
// @ANCHOR:dang_10|drill|0|part|a|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{AB} = (3-1; 2-0; 5-2) = (2; 2; 3)`)  (Barem: Thay đúng số, kết quả đúng: 1đ)] \
    ]
// @ANCHOR:dang_10|drill|0|part|b|question
  - *b)* Tính tọa độ  #mi(`\vec{BC}`) 
// @ANCHOR:dang_10|drill|0|part|b|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{BC} = (0-3; 4-2; 1-5) = (-3; 2; -4)`)  (Barem: Thay đúng số, kết quả đúng: 1đ)] \
    ]
// @ANCHOR:dang_10|drill|0|part|c|question
  - *c)* Tính tọa độ  #mi(`\vec{CD}`) 
// @ANCHOR:dang_10|drill|0|part|c|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{CD} = (2-0; -1-4; 3-1) = (2; -5; 2)`)  (Barem: Thay đúng số, kết quả đúng: 1đ)] \
    ]
// @ANCHOR:dang_10|drill|0|part|d|question
  - *d)* Tính tọa độ  #mi(`\vec{DA}`) 
// @ANCHOR:dang_10|drill|0|part|d|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{DA} = (1-2; 0-(-1); 2-3) = (-1; 1; -1)`)  (Barem: Thay đúng số, kết quả đúng: 1đ)] \
    ]
// @ANCHOR:dang_10|drill|0|part|e|question
  - *e)* Tính tọa độ  #mi(`\vec{AC}`) 
// @ANCHOR:dang_10|drill|0|part|e|solution
    #if IS_TEACHER [
      #text(fill: rgb("#15803d"))[→ Lời giải:  #mi(`\vec{AC} = (0-1; 4-0; 1-2) = (-1; 4; -1)`)  (Barem: Thay đúng số, kết quả đúng: 1đ)] \
    ]
    #if not IS_TEACHER [
      #block(stroke: (paint: rgb("#94a3b8"), dash: "dashed"), inset: 6pt, height: 45pt, width: 100%)[
        #text(size: 8.5pt, fill: rgb("#94a3b8"))[✍️ Bài làm:]
      ]
    ]
]
#v(6pt)
