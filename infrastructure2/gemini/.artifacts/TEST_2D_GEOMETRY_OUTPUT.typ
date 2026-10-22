#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#import "../archetypes.typ": *

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ GEMMA 4 VẼ HÌNH HỌC PHẲNG 2D (LỚP 8 & LỚP 9)]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Nguồn đề: Đề cương ôn tập Toán 8 & Chuyên đề Hình học Tuyển sinh 10 Toán 9]
]
#v(6pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 10pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 1 (LỚP 8): Hình bình hành & Trung điểm] \
      #v(3pt)
      #text(size: 8pt)[Cho hình bình hành ABCD có BC = 2AB và hat(A) = 60^°. Gọi E, F theo thứ tự là trung điểm của BC và AD. \
        a) Tứ giác ECDF là hình gì? \
        b) Tứ giác ABED là hình gì? Vì sao? \
        c) Tính số đo của góc hat(AED).]
    ],
    [
      #align(center)[
        #geo-2d-parallelogram(labels: ("A", "B", "C", "D"), derived: ((name: "E", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "F", type: "midpoint", of: ("A", "D"), k: 0.5),), lines: ((from: "E", to: "D", style: "solid", color: rgb("#2563eb")), (from: "F", to: "C", style: "solid", color: rgb("#2563eb")), (from: "A", to: "E", style: "solid", color: rgb("#2563eb")), (from: "D", to: "E", style: "solid", color: rgb("#2563eb")),), circles: (), right_angles: (), polygons: ((pts: ("E", "C", "D", "F"), fill: rgb("#93c5fd40")), (pts: ("A", "B", "E", "D"), fill: rgb("#fde04740")),))
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 2 (LỚP 8): Tam giác & Đối xứng] \
      #v(3pt)
      #text(size: 8pt)[Cho Delta ABC. Gọi M, N lần lượt là trung điểm của BC, AC. Gọi H là điểm đối xứng của N qua M. \
        a) Chứng minh tứ giác BNCH và ABHN là hình bình hành. \
        b) Delta ABC thỏa mãn điều kiện gì thì tứ giác BNCH là hình chữ nhật.]
    ],
    [
      #align(center)[
        #geo-2d-triangle(labels: ("A", "B", "C"), derived: ((name: "M", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "N", type: "midpoint", of: ("A", "C"), k: 0.5), (name: "H", type: "symmetry", of: ("N", "M"), k: 0.5),), lines: ((from: "B", to: "N", style: "solid", color: rgb("#2563eb")), (from: "C", to: "H", style: "solid", color: rgb("#2563eb")), (from: "B", to: "H", style: "solid", color: rgb("#2563eb")), (from: "N", to: "H", style: "solid", color: rgb("#2563eb")),), circles: (), right_angles: (), polygons: ((pts: ("B", "N", "C", "H"), fill: rgb("#93c5fd40")), (pts: ("A", "B", "H", "N"), fill: rgb("#fde04740")),))
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 3 (LỚP 8): Tứ giác & Đối xứng] \
      #v(3pt)
      #text(size: 8pt)[Cho tứ giác ABCD. Gọi O là giao điểm của 2 đường chéo (không vuông góc), I và K lần lượt là trung điểm của BC và CD. Gọi M và N theo thứ tự là điểm đối xứng của điểm O qua tâm I và K. \
        a) Chứng minh rằng tứ giác BMND là hình bình hành. \
        b) Với điều kiện nào của hai đường chéo AC và BD thì tứ giác BMND là hình chữ nhật. \
        c) Chứng minh 3 điểm M, C, N thẳng hàng.]
    ],
    [
      #align(center)[
        #geo-2d-quadrilateral(labels: ("A", "B", "C", "D"), derived: ((name: "O", type: "intersection", of: ("A", "C", "B", "D"), k: 0.5), (name: "I", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "K", type: "midpoint", of: ("C", "D"), k: 0.5), (name: "M", type: "symmetry", of: ("O", "I"), k: 0.5), (name: "N", type: "symmetry", of: ("O", "K"), k: 0.5),), lines: ((from: "B", to: "M", style: "solid", color: rgb("#2563eb")), (from: "M", to: "N", style: "solid", color: rgb("#2563eb")), (from: "N", to: "D", style: "solid", color: rgb("#2563eb")), (from: "M", to: "C", style: "solid", color: rgb("#2563eb")), (from: "N", to: "C", style: "solid", color: rgb("#2563eb")),), circles: (), right_angles: (), polygons: ((pts: ("B", "M", "N", "D"), fill: rgb("#93c5fd40")),))
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 4 (LỚP 8): Hình bình hành & Trung điểm] \
      #v(3pt)
      #text(size: 8pt)[Cho hình bình hành ABCD. Gọi E và F lần lượt là trung điểm của AD và BC. Đường chéo AC cắt các đoạn thẳng BE và DF theo thứ tự tại P và Q. \
        a) Chứng minh tứ giác BEDF là hình bình hành. \
        b) Chứng minh AP = PQ = QC. \
        c) Gọi R là trung điểm của BP. Chứng minh tứ giác ARQE là hình bình hành.]
    ],
    [
      #align(center)[
        #geo-2d-parallelogram(labels: ("A", "B", "C", "D"), derived: ((name: "E", type: "midpoint", of: ("A", "D"), k: 0.5), (name: "F", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "P", type: "intersection", of: ("A", "C", "B", "E"), k: 0.5), (name: "Q", type: "intersection", of: ("A", "C", "D", "F"), k: 0.5), (name: "R", type: "midpoint", of: ("B", "P"), k: 0.5),), lines: ((from: "B", to: "E", style: "solid", color: rgb("#2563eb")), (from: "D", to: "F", style: "solid", color: rgb("#2563eb")), (from: "A", to: "R", style: "solid", color: rgb("#2563eb")), (from: "R", to: "Q", style: "solid", color: rgb("#2563eb")), (from: "Q", to: "E", style: "solid", color: rgb("#2563eb")), (from: "E", to: "A", style: "solid", color: rgb("#2563eb")),), circles: (), right_angles: (), polygons: ((pts: ("B", "E", "D", "F"), fill: rgb("#93c5fd40")), (pts: ("A", "R", "Q", "E"), fill: rgb("#fde04740")),))
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 5 (LỚP 8): Tứ giác & Trung điểm] \
      #v(3pt)
      #text(size: 8pt)[Cho tứ giác ABCD. Gọi M, N, P, Q lần lượt là trung điểm của AB, BC, CD, DA. \
        a) Tứ giác MNPQ là hình gì? Vì sao? \
        b) Tìm điều kiện của tứ giác ABCD để tứ giác MNPQ là hình vuông? \
        c) Với điều kiện câu b) hãy tính tỉ số diện tích của tứ giác ABCD và MNPQ.]
    ],
    [
      #align(center)[
        #geo-2d-quadrilateral(labels: ("A", "B", "C", "D"), derived: ((name: "M", type: "midpoint", of: ("A", "B"), k: 0.5), (name: "N", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "P", type: "midpoint", of: ("C", "D"), k: 0.5), (name: "Q", type: "midpoint", of: ("D", "A"), k: 0.5),), lines: ((from: "M", to: "N", style: "solid", color: rgb("#2563eb")), (from: "N", to: "P", style: "solid", color: rgb("#2563eb")), (from: "P", to: "Q", style: "solid", color: rgb("#2563eb")), (from: "Q", to: "M", style: "solid", color: rgb("#2563eb")),), circles: (), right_angles: (), polygons: ((pts: ("M", "N", "P", "Q"), fill: rgb("#93c5fd40")),))
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 1 (LỚP 9): Tam giác nội tiếp & Đường cao] \
      #v(3pt)
      #text(size: 8pt)[Cho tam giác ABC nhọn (AB < AC) nội tiếp đường tròn (O). Hai đường cao BE và CF của tam giác ABC cắt nhau tại điểm H. Gọi K là trung điểm BC. \
        - a) Chứng minh Delta AEF đồng dạng Delta ABC. \
        - b) Chứng minh đường thẳng OA vuông góc với đường thẳng EF. \
        - c) Đường phân giác góc FHB cắt AB và AC lần lượt tại M và N. Gọi I là trung điểm của MN, J là trung điểm của AH. Chứng minh tứ giác AFHI nội tiếp và ba điểm I, J, K thẳng hàng.]
    ],
    [
      #align(center)[
        #geo-2d-circle-triangle(labels: ("A", "B", "C"), derived: ((name: "E", type: "project", of: ("B", "A", "C"), k: 0.5), (name: "F", type: "project", of: ("C", "A", "B"), k: 0.5), (name: "H", type: "intersection", of: ("B", "E", "C", "F"), k: 0.5), (name: "K", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "M", type: "intersection", of: ("F", "H", "A", "B"), k: 0.5), (name: "N", type: "intersection", of: ("F", "H", "A", "C"), k: 0.5), (name: "I", type: "midpoint", of: ("M", "N"), k: 0.5), (name: "J", type: "midpoint", of: ("A", "H"), k: 0.5),), lines: ((from: "B", to: "E", style: "solid", color: rgb("#2563eb")), (from: "C", to: "F", style: "solid", color: rgb("#2563eb")), (from: "E", to: "F", style: "solid", color: rgb("#2563eb")), (from: "O", to: "A", style: "solid", color: rgb("#2563eb")), (from: "M", to: "N", style: "solid", color: rgb("#2563eb")), (from: "I", to: "J", style: "solid", color: rgb("#2563eb")), (from: "J", to: "K", style: "solid", color: rgb("#2563eb")),), circles: ((center: "", radius: 2, through: ("A", "B", "C")),), right_angles: (("B", "E", "C"), ("C", "F", "A"), ("O", "A", "E"), ("I", "J", "K"),), polygons: ())
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 2 (LỚP 9): Đường tròn & Cung] \
      #v(3pt)
      #text(size: 8pt)[Cho đường tròn (O), dây CD cố định. Gọi B là điểm chính giữa cung nhỏ CD, kẻ đường kính AB cắt CD tại I. Lấy điểm H bất kỳ trên cung lớn CD, HB cắt CD tại E. Đường thẳng AH cắt đường thẳng CD tại P. \
        - a) Chứng minh: Tứ giác PHIB nội tiếp. \
        - b) Chứng minh: AH.AP = AI.AB. \
        - c) Gọi K là giao điểm của đường thẳng AE và BP. Kẻ KM perp AB cắt AB tại M, cắt đường tròn (O) tại N. Chứng minh N, I, H thẳng hàng.]
    ],
    [
      #align(center)[
        #geo-2d-circle-triangle(labels: ("A", "B", "C", "D"), derived: ((name: "I", type: "intersection", of: ("A", "B", "C", "D"), k: 0.5), (name: "E", type: "intersection", of: ("H", "B", "C", "D"), k: 0.5), (name: "P", type: "intersection", of: ("A", "H", "C", "D"), k: 0.5), (name: "K", type: "intersection", of: ("A", "E", "B", "P"), k: 0.5), (name: "M", type: "project", of: ("K", "A", "B"), k: 0.5), (name: "N", type: "intersection", of: ("K", "M", "A", "B"), k: 0.5),), lines: ((from: "A", to: "B", style: "solid", color: rgb("#2563eb")), (from: "H", to: "B", style: "solid", color: rgb("#2563eb")), (from: "A", to: "H", style: "solid", color: rgb("#2563eb")), (from: "A", to: "E", style: "solid", color: rgb("#2563eb")), (from: "K", to: "M", style: "solid", color: rgb("#2563eb")), (from: "N", to: "I", style: "solid", color: rgb("#2563eb")), (from: "N", to: "H", style: "solid", color: rgb("#2563eb")),), circles: ((center: "", radius: 2, through: ("A", "B", "C")),), right_angles: (("K", "M", "A"),), polygons: ())
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 3 (LỚP 9): Đường tròn & Hình chiếu] \
      #v(3pt)
      #text(size: 8pt)[Cho đường tròn tâm (O) và dây BC cố định không đi qua O. Trên cung lớn BC lấy điểm A sao cho AB < AC. Kẻ đường kính AK, E là hình chiếu của C trên AK. M là trung điểm của BC. \
        - a) Chứng minh bốn điểm C, E, M, O cùng thuộc một đường tròn. \
        - b) Kẻ AD perp BC tại D. Chứng minh AD.AK = AB.AC và Delta MDE cân. \
        - c) Gọi F là hình chiếu của B trên AK. Chứng minh khi A di chuyển trên cung lớn BC thì tâm đường tròn ngoại tiếp Delta DEF là 1 điểm cố định.]
    ],
    [
      #align(center)[
        #geo-2d-circle-triangle(labels: ("A", "B", "C"), derived: ((name: "K", type: "symmetry", of: ("A", "O"), k: 0.5), (name: "E", type: "project", of: ("C", "A", "K"), k: 0.5), (name: "M", type: "midpoint", of: ("B", "C"), k: 0.5), (name: "D", type: "project", of: ("A", "B", "C"), k: 0.5), (name: "F", type: "project", of: ("B", "A", "K"), k: 0.5),), lines: ((from: "A", to: "K", style: "solid", color: rgb("#2563eb")), (from: "C", to: "E", style: "solid", color: rgb("#2563eb")), (from: "A", to: "D", style: "solid", color: rgb("#2563eb")), (from: "B", to: "F", style: "solid", color: rgb("#2563eb")),), circles: ((center: "", radius: 2, through: ("A", "B", "C")),), right_angles: (("C", "E", "A"), ("A", "D", "B"),), polygons: ())
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 4 (LỚP 9): Tứ giác nội tiếp & Đường kính] \
      #v(3pt)
      #text(size: 8pt)[Tứ giác ABCD nội tiếp đường tròn tâm O đường kính AD. Hai đường chéo AC, BD cắt nhau tại E. Từ E kẻ EF vuông góc với AD (F in AD). Đường thẳng CF cắt đường tròn tại điểm thứ hai là M. Giao điểm của BD và CF là N. Chứng minh: \
        - a) CEFD là tứ giác nội tiếp. \
        - b) FA là tia phân giác của hat(BFM). \
        - c) BE.DN = EN.BD.]
    ],
    [
      #align(center)[
        #geo-2d-circle-quadrilateral(labels: ("A", "B", "C", "D"), derived: ((name: "E", type: "intersection", of: ("A", "C", "B", "D"), k: 0.5), (name: "F", type: "project", of: ("E", "A", "D"), k: 0.5), (name: "M", type: "intersection", of: ("C", "F", "A", "B"), k: 0.5), (name: "N", type: "intersection", of: ("B", "D", "C", "F"), k: 0.5),), lines: ((from: "A", to: "C", style: "solid", color: rgb("#2563eb")), (from: "B", to: "D", style: "solid", color: rgb("#2563eb")), (from: "E", to: "F", style: "solid", color: rgb("#2563eb")), (from: "C", to: "F", style: "solid", color: rgb("#2563eb")), (from: "B", to: "F", style: "solid", color: rgb("#2563eb")), (from: "F", to: "M", style: "solid", color: rgb("#2563eb")),), circles: ((center: "", radius: 2, through: ("A", "B", "C")),), right_angles: (("E", "F", "A"),), polygons: ())
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
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[BÀI 5 (LỚP 9): Tiếp tuyến & Nửa đường tròn] \
      #v(3pt)
      #text(size: 8pt)[Trên nửa đường tròn (O; R) đường kính BC, lấy điểm A sao cho BA = R. \
        - a) Chứng minh tam giác ABC vuông tại A và tính số đo các góc B, C của tam giác vuông ABC. \
        - b) Qua B kẻ tiếp tuyến với nửa đường tròn (O), nó cắt tia CA tại D. Qua D kẻ tiếp tuyến DE với nửa đường tròn (O) (E là tiếp điểm). Gọi I là giao điểm của OD và BE. Chứng minh rằng OD perp BE và DI.DO = DA.DC. \
        - c) Kẻ EH vuông góc với BC tại H. EH cắt CD tại G. Chứng minh IG song song với BC.]
    ],
    [
      #align(center)[
        #geo-2d-circle-tangent(labels: ("B", "C", "A"), derived: ((name: "D", type: "intersection", of: ("B", "B", "C", "A"), k: 0.5), (name: "E", type: "project", of: ("D", "O", "B"), k: 0.5), (name: "I", type: "intersection", of: ("O", "D", "B", "E"), k: 0.5), (name: "H", type: "project", of: ("E", "B", "C"), k: 0.5), (name: "G", type: "intersection", of: ("E", "H", "C", "D"), k: 0.5),), lines: ((from: "B", to: "D", style: "solid", color: rgb("#2563eb")), (from: "D", to: "E", style: "solid", color: rgb("#2563eb")), (from: "O", to: "D", style: "solid", color: rgb("#2563eb")), (from: "B", to: "E", style: "solid", color: rgb("#2563eb")), (from: "I", to: "G", style: "solid", color: rgb("#2563eb")),), circles: ((center: "O", radius: 2, through: ("B", "C")),), right_angles: (("B", "A", "C"), ("O", "B", "D"), ("O", "E", "D"), ("O", "D", "B"), ("E", "H", "B"),), polygons: ())
      ]
    ]
  )
]
#v(4pt)
