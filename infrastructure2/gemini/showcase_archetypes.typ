#set page(paper: "a4", margin: (x: 1.5cm, top: 1.5cm, bottom: 1.5cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 10pt, lang: "vi")
#set par(justify: true)

#import "archetypes.typ": *

#align(center)[
  #text(size: 18pt, weight: "bold", fill: rgb("#1e3a8a"))[BỘ SƯU TẬP KHUNG HÌNH HỌC VÀ ĐỒ HỌA TOÁN K-12]
  \ #v(2pt)
  #text(size: 11pt, style: "italic", fill: rgb("#475569"))[Thử nghiệm Thực tế Hệ sinh thái Typst: CeTZ 3D + ctz-euclide 2D + vartable BBT + cetz-plot Oxy]
]
#v(10pt)

// -----------------------------------------------------------------------------
// PHẦN 1: HÌNH HỌC KHÔNG GIAN 3D (THPT LỚP 11 - 12)
// -----------------------------------------------------------------------------
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 10pt, radius: 4pt, width: 100%)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[I. HÌNH HỌC KHÔNG GIAN 3D (Tùy biến Điểm phụ, Nét vẽ, Vectơ & Thiết diện)]
  \ #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold")[1. Tứ diện $S.A B C$ + Trung điểm $M, N$ + Vectơ $arrow(M N)$:] \ #v(2pt)
      #geo-3d-tetrahedron(
        labels: ("S", "A", "B", "C"),
        derived: (
          (name: "M", type: "midpoint", of: ("S", "A")),
          (name: "N", type: "midpoint", of: ("B", "C")),
        ),
        lines: (
          (from: "M", to: "N", style: "dashed", stroke: 1pt, color: rgb("#dc2626")),
        ),
        vectors: (("M", "N"),),
      )
    ],
    [
      #text(weight: "bold")[2. Chóp $S.A B C$ có cạnh bên $S A perp (A B C)$:] \ #v(2pt)
      #geo-3d-pyramid-perp(
        labels: ("S", "A", "B", "C"),
        derived: (
          (name: "H", type: "ratio", of: ("S", "B"), k: 0.6),
        ),
        lines: (
          (from: "A", to: "H", style: "dashed", stroke: 0.8pt, color: rgb("#2563eb")),
        ),
      )
    ],
    [
      #text(weight: "bold")[3. Chóp tứ giác $S.A B C D$ + Tô màu thiết diện $(M N C D)$:] \ #v(2pt)
      #geo-3d-pyramid4(
        labels: ("S", "A", "B", "C", "D"),
        derived: (
          (name: "M", type: "midpoint", of: ("S", "A")),
          (name: "N", type: "midpoint", of: ("S", "B")),
        ),
        lines: (
          (from: "M", to: "N", style: "dashed", stroke: 1pt, color: rgb("#2563eb")),
          (from: "M", to: "D", style: "dashed", stroke: 0.8pt, color: rgb("#2563eb")),
          (from: "N", to: "C", style: "solid", stroke: 0.8pt, color: rgb("#2563eb")),
        ),
        polygons: (
          (pts: ("M", "N", "C", "D"), fill: rgb(147, 197, 253, 90)),
        ),
      )
    ],
    [
      #text(weight: "bold")[4. Hình hộp $A B C D.A' B' C' D'$ + Đường chéo $A C'$:] \ #v(2pt)
      #geo-3d-box(
        labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"),
        vectors: (("A", "C'"),),
      )
    ]
  )
]

#pagebreak()

// -----------------------------------------------------------------------------
// PHẦN 2: HÌNH HỌC PHẲNG 2D (THCS LỚP 6 - 9 & TIỂU HỌC)
// -----------------------------------------------------------------------------
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 10pt, radius: 4pt, width: 100%)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[II. HÌNH HỌC PHẲNG 2D (`@preview/ctz-euclide:0.3.0` - Tự động né đè nhãn & chuẩn xác Euclid)]
  \ #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold")[1. $Delta A B C$ nhọn nội tiếp $(O)$ + 3 đường cao $A D, B E, C F$:] \ #v(2pt)
      #align(center)[#geo-2d-acute-triangle-altitudes()]
    ],
    [
      #text(weight: "bold")[2. Điểm $M$ ngoài $(O)$ + 2 tiếp tuyến $M A, M B$ + Cát tuyến $M C D$:] \ #v(2pt)
      #align(center)[#geo-2d-two-tangents-secant()]
    ],
    [
      #text(weight: "bold")[3. Tam giác vuông tại $A$ + Đường cao $A H$:] \ #v(2pt)
      #align(center)[#geo-2d-right-triangle-altitude()]
    ],
    [
      #text(weight: "bold")[4. Hình chữ nhật có thước đo kích thước (Tiểu học):] \ #v(2pt)
      #align(center)[#geo-primary-rect-measure(width-cm: 5, height-cm: 3)]
    ]
  )
]

#pagebreak()

// -----------------------------------------------------------------------------
// PHẦN 3: GIẢI TÍCH - BẢNG BIẾN THIÊN & ĐỒ THỊ Oxy CHUẨN SGK
// -----------------------------------------------------------------------------
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 10pt, radius: 4pt, width: 100%)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[III. BẢNG BIẾN THIÊN (`@preview/vartable:0.2.4`) & ĐỒ THỊ Oxy (`@preview/cetz-plot`)]
  \ #v(8pt)
  #text(weight: "bold")[1. Bảng biến thiên hàm phân thức có Tiệm cận đứng nét đôi $||$:] \ #v(4pt)
  #align(center)[#demo-tabvar-rational()]
  #v(10pt)
  #text(weight: "bold")[2. Đồ thị Hàm số bậc ba $y = x^3 - 3x + 1$ (Hệ trục school-book Oxy mũi tên chuẩn SGK):] \ #v(4pt)
  #align(center)[#demo-function-plot-cubic()]
]
