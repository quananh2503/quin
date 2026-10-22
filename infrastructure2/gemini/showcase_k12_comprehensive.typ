#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#set par(justify: true)

#import "archetypes.typ": *

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[HỆ THỐNG TRỰC QUAN HÓA TOÁN HỌC K-12 TOÀN DIỆN (GDPT 2018)]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Bộ sưu tập 16 Kịch bản Tích hợp Đa mục tiêu: Từ Lớp 6 đến Lớp 12 (Hình học, Đại số, Giải tích & Thống kê)]
]
#v(6pt)

// =============================================================================
// TRANG 1: LỚP 6 & LỚP 7 (NỀN TẢNG HÌNH HỌC PHẲNG & BIỂU ĐỒ THỐNG KÊ)
// =============================================================================
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[I. NỀN TẢNG HÌNH HỌC PHẲNG & THỐNG KÊ (LỚP 6 & LỚP 7)]
  \ #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    [
      #text(weight: "bold")[1. [Lớp 6] Đoạn thẳng, điểm nằm giữa & thanh đo kích thước:] \
      #text(size: 7.5pt, style: "italic")[$C$ nằm giữa $A, B$; đo độ dài $A C = 3 "cm", C B = 4 "cm", A B = 7 "cm"$] \ #v(2pt)
      #align(center)[#geo-line-midpoint-measure()]
    ],
    [
      #text(weight: "bold")[2. [Lớp 6 - 7] Biểu đồ cột kép so sánh kết quả học tập:] \
      #text(size: 7.5pt, style: "italic")[So sánh điểm kiểm tra 4 môn giữa Học kỳ 1 và Học kỳ 2] \ #v(2pt)
      #align(center)[#chart-k12-column-double()]
    ],
    [
      #text(weight: "bold")[3. [Lớp 7] Biểu đồ quạt tròn (Pie Chart) cơ cấu %:] \
      #text(size: 7.5pt, style: "italic")[Tỉ lệ phần trăm tham gia các hoạt động ngoại khóa của học sinh] \ #v(2pt)
      #align(center)[#chart-k12-pie()]
    ],
    [
      #text(weight: "bold")[4. [Lớp 7] Góc & Hai đường thẳng song song bị cắt bởi cát tuyến:] \
      #text(size: 7.5pt, style: "italic")[Thể hiện cặp góc so le trong $hat(A)_1 = hat(B)_2$, cung đo góc màu đỏ] \ #v(2pt)
      #align(center)[#geo-parallel-transversal()]
    ]
  )
]

#pagebreak()

// =============================================================================
// TRANG 2: LỚP 7, 8 & 9 (TAM GIÁC, ĐỊNH LÝ THALÈS, HỆ THỨC LƯỢNG & ĐƯỜNG TRÒN)
// =============================================================================
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[II. HÌNH HỌC PHẲNG NÂNG CAO & ĐƯỜNG TRÒN (LỚP 7 - 8 - 9)]
  \ #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    [
      #text(weight: "bold")[5. [Lớp 7 - 8] Tam giác nhọn nội tiếp $(O)$ + 3 đường cao đồng quy:] \
      #text(size: 7.5pt, style: "italic")[Trực tâm $H$, tâm ngoại tiếp $O$, góc vuông tự động né đè nhãn] \ #v(2pt)
      #align(center)[#geo-2d-acute-triangle-altitudes()]
    ],
    [
      #text(weight: "bold")[6. [Lớp 8] Định lý Thalès & Tam giác đồng dạng:] \
      #text(size: 7.5pt, style: "italic")[$D E \/\/ B C arrow.r Delta A D E tilde Delta A B C$ + Đường phân giác trong $A K$] \ #v(2pt)
      #align(center)[#geo-thales-similar()]
    ],
    [
      #text(weight: "bold")[7. [Lớp 9] Hệ thức lượng trong tam giác vuông:] \
      #text(size: 7.5pt, style: "italic")[$Delta A B C$ vuông tại $A$, đường cao $A H$, hệ thức $h^2 = b' c'$, góc vuông kép] \ #v(2pt)
      #align(center)[#geo-2d-right-triangle-altitude()]
    ],
    [
      #text(weight: "bold")[8. [Lớp 9] Đường tròn, Tiếp tuyến & Tứ giác nội tiếp:] \
      #text(size: 7.5pt, style: "italic")[Tứ giác $A B C D$ nội tiếp $(O)$, tiếp tuyến $A x$, đường chéo nét đứt] \ #v(2pt)
      #align(center)[#geo-circle-cyclic-tangent()]
    ]
  )
]

#pagebreak()

// =============================================================================
// TRANG 3: LỚP 9, 10 & 11 (KHỐI TRÒN XOAY, BA ĐƯỜNG CONIC & HỘP BOX-PLOT)
// =============================================================================
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[III. KHỐI TRÒN XOAY, ĐƯỜNG CONIC & THỐNG KÊ MÔ TẢ (LỚP 9 - 10 - 11)]
  \ #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 10pt,
    [
      #text(weight: "bold")[9. [Lớp 9 - 11] Khối tròn xoay: Khối nón & Khối trụ:] \
      #text(size: 7.5pt, style: "italic")[Trục, đường sinh $l$, chiều cao $h$, bán kính đáy $r$, elip phối cảnh] \ #v(2pt)
      #grid(
        columns: (1fr, 1fr),
        align(center)[#geo-round-body-cone()],
        align(center)[#geo-round-body-cylinder()]
      )
    ],
    [
      #text(weight: "bold")[10. [Lớp 9 - 11] Khối tròn xoay: Khối cầu & Đường tròn xích đạo:] \
      #text(size: 7.5pt, style: "italic")[Tâm $O$, bán kính $R$, kinh tuyến nét đứt] \ #v(2pt)
      #align(center)[#geo-round-body-sphere()]
    ],
    [
      #text(weight: "bold")[11. [Lớp 10] Ba đường Conic: Đường Elip trong hệ trục $O x y$:] \
      #text(size: 7.5pt, style: "italic")[Phương trình $x^2/a^2 + y^2/b^2 = 1$, hai tiêu điểm $F_1, F_2$] \ #v(2pt)
      #align(center)[#geo-conic-ellipse()]
    ],
    [
      #text(weight: "bold")[12. [Lớp 10] Biểu đồ hộp (Box Plot) Thống kê mô tả (GDPT 2018):] \
      #text(size: 7.5pt, style: "italic")[Thể hiện Tứ phân vị ($Q_1, Q_2, Q_3$), điểm Min, điểm Max] \ #v(2pt)
      #align(center)[#chart-box-whisker()]
    ]
  )
]

#pagebreak()

// =============================================================================
// TRANG 4: LỚP 11 & LỚP 12 (KHÔNG GIAN, TIỆM CẬN XIÊN & HỆ TRỤC Oxyz)
// =============================================================================
#block(stroke: 1pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(size: 11pt, weight: "bold", fill: rgb("#0f766e"))[IV. HÌNH KHÔNG GIAN NÂNG CAO, GIẢI TÍCH 12 & HỆ TỌA ĐỘ Oxyz]
  \ #v(4pt)
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold")[13. [Lớp 11] Hình không gian: Thiết diện cắt chóp tứ giác:] \
      #text(size: 7.5pt, style: "italic")[Thiết diện $(M N C D)$ tô màu xuyên qua chóp $S.A B C D$] \ #v(2pt)
      #align(center)[
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
      ]
    ],
    [
      #text(weight: "bold")[14. [Lớp 12] Hệ trục toạ độ không gian $O x y z$:] \
      #text(size: 7.5pt, style: "italic")[Điểm $M(x_0, y_0, z_0)$ với khối hộp hình chiếu vuông góc xuống các mặt tọa độ] \ #v(2pt)
      #align(center)[#geo-3d-oxyz-coords()]
    ]
  )

  #v(6pt)
  #line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
  #v(4pt)

  #text(weight: "bold")[15. [Lớp 12] Bảng biến thiên hàm phân thức có Tiệm cận xiên (GDPT 2018):] \
  #text(size: 7.5pt, style: "italic")[Hàm số $y = frac(x^2 - 2x + 2, x - 1)$, điểm gián đoạn $x = 1$ nét đôi $||$, cực đại $(0; -2)$, cực tiểu $(2; 2)$] \ #v(2pt)
  #align(center)[#tabvar-oblique-deg2()]

  #v(6pt)
  #line(length: 100%, stroke: 0.5pt + rgb("#e2e8f0"))
  #v(4pt)

  #grid(
    columns: (1.2fr, 0.8fr),
    gutter: 12pt,
    [
      #text(weight: "bold")[16. [Lớp 12] Đồ thị hàm phân thức 2 nhánh & Tiệm cận xiên:] \
      #text(size: 7.5pt, style: "italic")[Đồ thị 2 nhánh, tiệm cận đứng $x = 1$ (đỏ), tiệm cận xiên $y = x - 1$ (xanh lá)] \ #v(2pt)
      #align(center)[#plot-rational-oblique()]
    ],
    [
      #v(6pt)
      #block(fill: rgb("#f8fafc"), stroke: 0.5pt + rgb("#cbd5e1"), inset: 6pt, radius: 4pt)[
        #text(weight: "bold", size: 8.5pt, fill: rgb("#1e3a8a"))[Phân tích hàm phân thức GDPT 2018:] \
        #v(3pt)
        #text(size: 7.8pt)[
          - Dạng hàm: $y = frac(a x^2 + b x + c, d x + e) = (x - 1) + frac(1, x - 1)$.
          - Tiệm cận đứng: $x = 1$ (đường đỏ đứt đoạn).
          - Tiệm cận xiên: $y = x - 1$ (đường xanh lá đứt đoạn).
          - Hai nhánh hyperbol đối xứng qua giao điểm của hai tiệm cận $I(1; 0)$.
          - Hai điểm cực trị: Điểm cực đại $A(0; -2)$ và điểm cực tiểu $B(2; 2)$.
        ]
      ]
    ]
  )
]
