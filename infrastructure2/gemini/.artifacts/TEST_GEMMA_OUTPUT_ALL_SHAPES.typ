#set page(paper: "a4", margin: (x: 1.5cm, top: 1.5cm, bottom: 1.5cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 9pt, lang: "vi")
#import "../archetypes.typ": *

#align(center)[
  #text(size: 16pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ THỰC TẾ GEMMA 4 SINH ĐỒ HỌA TOÁN K-12]
  \ #v(2pt)
  #text(size: 10pt, style: "italic", fill: rgb("#475569"))[Kiểm thử độ chính xác 16 Dạng toán: Tùy biến Cạnh, Điểm phụ, Nét đứt, Vectơ, Thiết diện, BBT & Oxy]
]
#v(8pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 1: 3D - Cạnh bên vuông góc đáy - Hình chóp S.ABC có SA vuông góc đáy, M trung điểm SC] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho hình chóp $S.A B C$ có cạnh bên $S A perp (A B C)$, đáy $A B C$ vuông tại $B$. Gọi $M$ là trung điểm cạnh $S C$. Kẻ đoạn thẳng $A M$ nét đứt màu xanh.] \ #v(4pt)
  #align(center)[
#geo-3d-pyramid-perp(labels: ("S", "A", "B", "C"), derived: ((name: "M", type: "midpoint", of: ("S", "C"), k: 0.5),), lines: ((from: "A", to: "M", style: "dashed", color: rgb("#2563eb")),), vectors: (), polygons: ())
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 2: 3D - Tứ diện & Vectơ - Tứ diện S.ABC, M, N trung điểm SA, BC] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho tứ diện $S.A B C$. Gọi $M$ là trung điểm của $S A$, $N$ là trung điểm của $B C$. Kẻ đoạn nối $M N$ nét đứt và vẽ vectơ $arrow(M N)$ màu đỏ.] \ #v(4pt)
  #align(center)[
#geo-3d-tetrahedron(labels: ("S", "A", "B", "C"), derived: ((name: "M", type: "midpoint", of: ("S", "A"), k: 0.5), (name: "N", type: "midpoint", of: ("B", "C"), k: 0.5),), lines: ((from: "M", to: "N", style: "dashed", color: rgb("#2563eb")),), vectors: (("M", "N"),), polygons: ())
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 3: 3D - Chóp tứ giác & Thiết diện - Hình chóp S.ABCD, thiết diện MNCD] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho hình chóp $S.A B C D$ có đáy là hình bình hành. Gọi $M, N$ lần lượt là trung điểm của $S A$ và $S B$. Thiết diện cắt hình chóp qua mặt phẳng $(M N C D)$ được tô màu xanh nhạt.] \ #v(4pt)
  #align(center)[
#geo-3d-pyramid4(labels: ("S", "A", "B", "C", "D"), derived: ((name: "M", type: "midpoint", of: ("S", "A"), k: 0.5), (name: "N", type: "midpoint", of: ("S", "B"), k: 0.5),), lines: (), vectors: (), polygons: ((pts: ("M", "N", "C", "D"), fill: rgb("#93c5fd5a")),))
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 4: 3D - Hình hộp & Đường chéo - Hình hộp ABCD.A'B'C'D', đường chéo AC'] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho hình hộp chữ nhật $A B C D.A' B' C' D'$. Kẻ đường chéo không gian $A C'$ nét liền màu đỏ.] \ #v(4pt)
  #align(center)[
#geo-3d-box(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: ((from: "A", to: "C'", style: "solid", color: rgb("#dc2626")),), vectors: (), polygons: ())
  ]
]
#v(4pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 5: 3D - Lăng trụ tam giác - Lăng trụ tam giác ABC.A'B'C', M trung điểm BB'] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho hình lăng trụ tam giác $A B C.A' B' C'$. Gọi $M$ là trung điểm của cạnh bên $B B'$. Kẻ đoạn thẳng $A' M$ nét đứt.] \ #v(4pt)
  #align(center)[
#geo-3d-prism-triangular(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: ((name: "M", type: "midpoint", of: ("B", "B'"), k: 0.5),), lines: ((from: "A'", to: "M", style: "dashed", color: rgb("#2563eb")),), vectors: (), polygons: ())
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 6: 3D - Tỉ số đoạn thẳng - Hình chóp S.ABC, H trên SB sao cho SH=2/3 SB] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho hình chóp $S.A B C$ có $S A perp (A B C)$. Lấy điểm $H$ trên cạnh $S B$ sao cho $S H = 2/3 S B$. Kẻ đường cao $A H$ nét đứt.] \ #v(4pt)
  #align(center)[
#geo-3d-pyramid-perp(labels: ("S", "A", "B", "C"), derived: ((name: "H", type: "ratio", of: ("S", "B"), k: 0.6666666666666666),), lines: ((from: "A", to: "H", style: "dashed", color: rgb("#2563eb")),), vectors: (), polygons: ())
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 7: 2D - Tam giác nội tiếp & 3 đường cao - Tam giác nhọn ABC nội tiếp, 3 đường cao] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho tam giác nhọn $A B C$ nội tiếp đường tròn $(O)$. Dựng 3 đường cao $A D, B E, C F$ cắt nhau tại trực tâm $H$.] \ #v(4pt)
  #align(center)[
#geo-2d-acute-triangle-altitudes()
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 8: 2D - Tiếp tuyến & Cát tuyến - Tiếp tuyến và cát tuyến từ điểm M] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Từ điểm $M$ ngoài $(O)$, kẻ hai tiếp tuyến $M A, M B$ và cát tuyến $M C D$. Gọi $I$ là trung điểm của dây cung $C D$.] \ #v(4pt)
  #align(center)[
#geo-2d-two-tangents-secant()
  ]
]
#v(4pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 9: 2D - Tam giác vuông & Đường cao - Tam giác vuông ABC, đường cao AH] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Cho tam giác $A B C$ vuông tại $A$, có đường cao $A H$ hạ từ đỉnh $A$ xuống cạnh huyền $B C$.] \ #v(4pt)
  #align(center)[
#geo-2d-right-triangle-altitude()
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 10: Tiểu học - Thước đo hình chữ nhật - Hình chữ nhật 8m x 5m] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Một mảnh đất hình chữ nhật có chiều dài 8 m và chiều rộng 5 m. Hãy vẽ hình kèm thanh thước đo hai cạnh.] \ #v(4pt)
  #align(center)[
#geo-primary-rect-measure(width-cm: 8, height-cm: 3)
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 11: Tiểu học - Đo đạc diện tích - Hình chữ nhật 12m x 6m] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Một thửa ruộng hình chữ nhật có chiều dài 12 m và chiều rộng 6 m. Hãy vẽ hình chữ nhật có kích thước.] \ #v(4pt)
  #align(center)[
#geo-primary-rect-measure(width-cm: 12, height-cm: 3)
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 12: BBT - Hàm bậc ba - BBT hàm bậc ba y = x^3 - 3x^2 + 2] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Lập bảng biến thiên của hàm số bậc ba $y = x^3 - 3x^2 + 2$ với 2 điểm cực trị tại $x = 0$ (cực đại $y = 2$) và $x = 2$ (cực tiểu $y = -2$).] \ #v(4pt)
  #align(center)[
#tabvar(
  variable: $x$,
  label: (([Dấu $y'$], "s"), ([Chiều biến thiên $y$], "v")),
  domain: ($-oo$, $0$, $2$, $+oo$),
  contents: (
    ($+$, ("0", $-$), ("0", $+$)),
    (
      (bottom, $-oo$),
      (top, $2$),
      (bottom, $-2$),
      (top, $+oo$),
    ),
  ),
)
  ]
]
#v(4pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 13: BBT - Hàm phân thức hữu tỉ - BBT hàm phân thức y = (2x-1)/(x-1)] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Lập bảng biến thiên của hàm số phân thức $y = frac(2x - 1, x - 1)$ có tiệm cận đứng $x = 1$, giới hạn $y = 2$ tại vô cực, luôn nghịch biến.] \ #v(4pt)
  #align(center)[
#tabvar(
  variable: $x$,
  label: (([Dấu $y'$], "s"), ([Chiều biến thiên $y$], "v")),
  domain: ($-oo$, $1$, $+oo$),
  contents: (
    ($-$, ("||", $-$)),
    (
      (top, $2$),
      (bottom, top, "||", $-oo$, $+oo$),
      (bottom, $2$),
    ),
  ),
)
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 14: BBT - Hàm trùng phương - BBT hàm trùng phương y = -x^4 + 2x^2 + 1] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Lập bảng biến thiên hàm số trùng phương $y = -x^4 + 2x^2 + 1$ có 3 điểm cực trị tại $x = -1, 0, 1$.] \ #v(4pt)
  #align(center)[
#tabvar(
  variable: $x$,
  label: (([Dấu $y'$], "s"), ([Chiều biến thiên $y$], "v")),
  domain: ($-oo$, $-1$, $0$, $1$, $+oo$),
  contents: (
    ($+$, ("0", $-$), ("0", $+$), ("0", $-$)),
    (
      (bottom, $-oo$),
      (top, $2$),
      (bottom, $1$),
      (top, $2$),
      (bottom, $-oo$),
    ),
  ),
)
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 15: Đồ thị - Hàm số bậc ba - Đồ thị hàm số bậc ba y = x^3 - 3x + 1] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Vẽ đồ thị hàm số bậc ba $y = x^3 - 3x + 1$ trên hệ trục school-book Oxy với điểm cực đại $(-1, 3)$ và cực tiểu $(1, -1)$ có nét gióng đứt đoạn.] \ #v(4pt)
  #align(center)[
#cetz-v3.canvas({
  import cetz-v3.draw: *
  plot.plot(
    size: (5.5, 3.8),
    axis-style: "school-book",
    x-tick-step: 1, y-tick-step: 2,
    x-label: $x$, y-label: $y$,
    x-min: -2.5, x-max: 2.5, y-min: -3, y-max: 4,
    {
      plot.add(domain: (-2.1, 2.1), x => calc.pow(x, 3) - 3*x + 1, style: (stroke: 1.2pt + blue))
      plot.add-vline(-1, min: 0, max: 3, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add-hline(3, min: -1, max: 0, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add-vline(1, min: -1, max: 0, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add-hline(-1, min: 0, max: 1, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add(((-1, 3), (1, -1)), style: (stroke: none), mark: "o", mark-size: 0.12)
    }
  )
})
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 10.5pt, fill: rgb("#0f766e"))[Bài 16: Đồ thị - Parabol - Đồ thị Parabol y = -x^2 + 4x - 3] \
  #text(style: "italic", size: 8.5pt)[Đề bài: Vẽ parabol $y = -x^2 + 4x - 3$ có đỉnh $I(2, 1)$, cắt trục hoành tại $x = 1$ và $x = 3$.] \ #v(4pt)
  #align(center)[
#cetz-v3.canvas({
  import cetz-v3.draw: *
  plot.plot(
    size: (5.5, 3.8),
    axis-style: "school-book",
    x-tick-step: 1, y-tick-step: 1,
    x-label: $x$, y-label: $y$,
    x-min: -0.5, x-max: 4.5, y-min: -2, y-max: 2.2,
    {
      plot.add(domain: (0.3, 3.7), x => -calc.pow(x, 2) + 4*x - 3, style: (stroke: 1.2pt + blue))
      plot.add-vline(2, min: 0, max: 1, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add-hline(1, min: 0, max: 2, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add(((2, 1),), style: (stroke: none), mark: "o", mark-size: 0.12)
    }
  )
})
  ]
]
#v(4pt)
