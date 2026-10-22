#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#import "../archetypes.typ": *

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ GEMMA 4 VẼ HÌNH TOÁN KHÔNG GIAN TỪ FILE PDF THỰC TẾ]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Tài liệu nguồn: "ÔN VEC TƠ KG 10T10.pdf" (Chương trình GDPT 2018)]
]
#v(6pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 1 (Phần C): Vectơ trong tứ diện] \
      #v(3pt)
      #text(size: 8pt)[Cho tứ diện ABCD. Hỏi có bao nhiêu vectơ khác vectơ 0 mà mỗi vectơ có điểm đầu, điểm cuối là hai đỉnh của tứ diện ABCD? \
        A. 12. \
        B. 4. \
        C. 10. \
        D. 8.]
    ],
    [
      #align(center)[
        #geo-3d-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (("A", "B"), ("A", "C"), ("A", "D"), ("B", "C"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 2 (Phần C): Vectơ trong hình lập phương] \
      #v(3pt)
      #text(size: 8pt)[Cho hình lập phương ABCD.A'B'C'D'. Mệnh đề nào sau đây sai? \
        A. vec(AB) + vec(AD) + vec(AA') = vec(AC'). \
        B. vec(AC) = vec(AB) + vec(AD). \
        C. |vec(AB)| = |vec(CD)|. \
        D. vec(AB) = vec(CD).]
    ],
    [
      #align(center)[
        #geo-3d-box(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (("A", "B"), ("A", "D"), ("A", "A'"), ("A", "C'"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 3 (Phần C): Trọng tâm tứ diện] \
      #v(3pt)
      #text(size: 8pt)[Cho hình tứ diện ABCD có trọng tâm G. Mệnh đề nào sau đây sai? \
        A. vec(GA) + vec(GB) + vec(GC) + vec(GD) = vec(0). \
        B. vec(OG) = frac(1)(4)(vec(OA) + vec(OB) + vec(OC) + vec(OD)). \
        C. vec(AG) = frac(2)(3)(vec(AB) + vec(AC) + vec(AD)). \
        D. vec(AG) = frac(1)(4)(vec(AB) + vec(AC) + vec(AD)).]
    ],
    [
      #align(center)[
        #geo-3d-tetrahedron(labels: ("A", "B", "C", "D"), derived: ((name: "G", type: "centroid", of: ("A", "B", "C", "D"), k: 0.5),), lines: (), vectors: (("G", "A"), ("G", "B"), ("G", "C"), ("G", "D"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 4 (Phần C): Trung điểm trong tứ diện] \
      #v(3pt)
      #text(size: 8pt)[Cho tứ diện ABCD, gọi I, J lần lượt là trung điểm của AB và CD; Đẳng thức nào sai? \
        A. vec(IJ) = frac(1)(2)(vec(AC) + vec(BD)). \
        B. vec(IJ) = frac(1)(2)(vec(AD) + vec(BC)). \
        C. vec(IJ) = frac(1)(2)(vec(DC) + vec(AD) + vec(BD)). \
        D. vec(IJ) = frac(1)(2)(vec(AB) + vec(CD)).]
    ],
    [
      #align(center)[
        #geo-3d-tetrahedron(labels: ("A", "B", "C", "D"), derived: ((name: "I", type: "midpoint", of: ("A", "B"), k: 0.5), (name: "J", type: "midpoint", of: ("C", "D"), k: 0.5),), lines: ((from: "I", to: "J", style: "dashed", color: rgb("#2563eb")),), vectors: (("I", "J"), ("A", "C"), ("B", "D"), ("A", "D"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 6 (Phần C): Quy tắc hình hộp] \
      #v(3pt)
      #text(size: 8pt)[Cho hình hộp ABCD.A'B'C'D'. Chọn đẳng thức vectơ đúng: \
        A. vec(AC') = vec(AB) + vec(AB') + vec(AD). \
        B. vec(DB') = vec(DA) + vec(DD') + vec(DC'). \
        C. vec(AC') = vec(AC) + vec(AB) + vec(AD). \
        D. vec(DB) = vec(DA) + vec(DD') + vec(DC).]
    ],
    [
      #align(center)[
        #geo-3d-box(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (("A", "C'"), ("A", "B"), ("A", "B'"), ("A", "D"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 8 (Phần C): Trung điểm trong tứ diện] \
      #v(3pt)
      #text(size: 8pt)[Cho tứ diện ABCD. Gọi M, N lần lượt là trung điểm của AD và BC. Khẳng định nào sau đây sai? \
        A. vec(AB) + vec(CD) = vec(CB) + vec(AD). \
        B. 2vec(MN) = vec(AB) + vec(DC). \
        C. vec(AD) + 2vec(MN) = vec(AB) + vec(AC). \
        D. 2vec(MN) = vec(AB) + vec(AC) + vec(AD).]
    ],
    [
      #align(center)[
        #geo-3d-tetrahedron(labels: ("A", "B", "C", "D"), derived: ((name: "M", type: "midpoint", of: ("A", "D"), k: 0.5), (name: "N", type: "midpoint", of: ("B", "C"), k: 0.5),), lines: ((from: "M", to: "N", style: "dashed", color: rgb("#2563eb")),), vectors: (("M", "N"), ("A", "B"), ("C", "D"), ("C", "B"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 9 (Phần C): Vectơ trong hình chóp] \
      #v(3pt)
      #text(size: 8pt)[Cho hình chóp S.ABCD có đáy ABCD là hình bình hành. Khẳng định nào sau đây đúng? \
        A. vec(SA) + vec(SD) = vec(SB) + vec(SC). \
        B. vec(SA) + vec(SB) + vec(SC) + vec(SD) = vec(0). \
        C. vec(SA) + vec(SC) = vec(SB) + vec(SD). \
        D. vec(SA) + vec(SB) = vec(SC) + vec(SD).]
    ],
    [
      #align(center)[
        #geo-3d-pyramid4(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (("S", "A"), ("S", "B"), ("S", "C"), ("S", "D"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 10 (Phần C): Vectơ trong lăng trụ tam giác] \
      #v(3pt)
      #text(size: 8pt)[Cho hình lăng trụ tam giác ABC.A'B'C'. Vectơ nào sau đây là vectơ chỉ phương của đường thẳng AB? \
        A. vec(A'B'). \
        B. vec(A'C). \
        C. vec(A'C'). \
        D. vec(A'B).]
    ],
    [
      #align(center)[
        #geo-3d-prism-triangular(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (("A", "B"), ("A'", "B'"), ("A'", "C"), ("A'", "C'"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 13 (Phần C): Vectơ trong lăng trụ tam giác] \
      #v(3pt)
      #text(size: 8pt)[Cho hình lăng trụ tam giác ABCA'B'C'. Đặt vec(AA') = vec(a), vec(AB) = vec(b), vec(AC) = vec(c), vec(BC) = vec(d). Trong các biểu thức véctơ sau đây, biểu thức nào đúng. \
        A. vec(a) + vec(b) + vec(c) = vec(d). \
        B. vec(a) = vec(b) + vec(c). \
        C. vec(a) + vec(b) + vec(c) + vec(d) = vec(0). \
        D. vec(b) - vec(c) + vec(d) = vec(0).]
    ],
    [
      #align(center)[
        #geo-3d-prism-triangular(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (("A", "A'"), ("A", "B"), ("A", "C"), ("B", "C"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 1 (Phần D): Vectơ trong hình hộp] \
      #v(3pt)
      #text(size: 8pt)[Cho hình hộp ABCD.A'B'C'D'. Các mệnh đề sau đúng hay sai? \
        a) vec(BD) - vec(D'D) - vec(B'D') = vec(BB') \
        b) vec(AC) - vec(BA') + vec(DB) + vec(C'D) = vec(0) \
        c) vec(AC) + vec(BA') + vec(DB) + vec(C'D) = vec(0) \
        d) vec(AB) + vec(B'C') + vec(DD') = vec(AC')]
    ],
    [
      #align(center)[
        #geo-3d-box(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (("B", "D"), ("D'", "D"), ("B'", "D'"), ("B", "B'"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 2 (Phần D): Vectơ trong hình hộp] \
      #v(3pt)
      #text(size: 8pt)[Cho hình hộp ABCD.A1B1C1D1. Các mệnh đề sau đúng hay sai? \
        a) vec(AC_1) + vec(A_1C) = 2vec(AC) \
        b) vec(AC_1) + vec(CA_1) + 2vec(C_1C) = vec(0) \
        c) vec(CA_1) + vec(AC) = vec(CC_1) \
        d) vec(AC_1) + vec(CD) = vec(A_1D_1)]
    ],
    [
      #align(center)[
        #geo-3d-box(labels: ("A", "B", "C", "D", "A1", "B1", "C1", "D1"), derived: (), lines: (), vectors: (("A", "C1"), ("A1", "C"), ("A", "C"), ("C", "A1"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[Câu 5 (Phần D): Tích vô hướng trong hình lập phương] \
      #v(3pt)
      #text(size: 8pt)[Cho hình lập phương ABCD.A'B'C'D', có cạnh a. Các mệnh đề sau đúng hay sai? \
        a) vec(AD').vec(CC') = a^2 \
        b) vec(AD').vec(AB') = a^2 \
        c) vec(AB').vec(CD') = 0 \
        d) |vec(AC')| = asqrt(3)]
    ],
    [
      #align(center)[
        #geo-3d-box(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (("A", "D'"), ("C", "C'"), ("A", "B'"), ("A", "B'"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)
