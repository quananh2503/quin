#set page(paper: "a4", margin: (x: 1.2cm, top: 1.2cm, bottom: 1.2cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 8.5pt, lang: "vi")
#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/vartable:0.2.4": tabvar

#align(center)[
  #text(size: 15pt, weight: "bold", fill: rgb("#1e3a8a"))[KẾT QUẢ GEMMA 4 VẼ ĐỒ THỊ HÀM SỐ & BẢNG BIẾN THIÊN]
  \ #v(2pt)
  #text(size: 9.5pt, style: "italic", fill: rgb("#475569"))[Nguồn đề: Tài liệu Chuyên đề Đồ thị & Bảng biến thiên THPT (testdothibbt.pdf)]
]
#v(6pt)

#align(center)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[PHẦN 1: 5 ĐỒ THỊ TIÊU BIỂU (BẬC 3, BẬC 4, PHÂN THỨC TIỆM CẬN XIÊN, ĐƯỜNG CONG GAUSS)]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[ĐỒ THỊ 1: Hàm số bậc 3 (a < 0)] \
      #v(4pt)
      #text(size: 8.5pt)[
        - *Dạng hàm số:* cubic \
        - *Miền hiển thị:* $x in [-3.5; 4.5]$, $y in [-2.0; 5.5]$ \
        - *Đường tiệm cận:* Không có \
        - *Điểm đặc biệt (Cực trị / Giao điểm):* \
                + Tọa độ $(-1.0; 1.0)$: (-1; 1)
        + Tọa độ $(2.0; 4.0)$: (2; 4)
        + Tọa độ $(3.0; 0.0)$: (3; 0)
      ]
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
      import cetz-v3.draw: *
      plot.plot(
        size: (5.2, 3.6),
        axis-style: "school-book",
        x-tick-step: 1.0, y-tick-step: 1.0,
        x-label: $x$, y-label: $y$,
        x-min: -3.5, x-max: 4.5, y-min: -2.0, y-max: 5.5,
        {
        plot.add(domain: (-2.20, 3.80), x => -0.222 * calc.pow(x, 3) + 0.333 * calc.pow(x, 2) + 1.333 * x + 1.778, style: (stroke: 1.2pt + rgb("#2563eb")))
        plot.add(((-1.00, 1.00), (2.00, 4.00), (3.00, 0.00),), style: (stroke: none), mark: "o", mark-size: 0.12)
        }
      )
    })
      ]
    ]
  )
]
#v(6pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[ĐỒ THỊ 2: Nhận diện hàm số bậc 3 (a > 0)] \
      #v(4pt)
      #text(size: 8.5pt)[
        - *Dạng hàm số:* cubic \
        - *Miền hiển thị:* $x in [-1.5; 3.5]$, $y in [-4.0; 3.0]$ \
        - *Đường tiệm cận:* Không có \
        - *Điểm đặc biệt (Cực trị / Giao điểm):* \
                + Tọa độ $(0.0; 1.0)$: (0; 1)
        + Tọa độ $(2.0; -3.0)$: (2; -3)
      ]
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
      import cetz-v3.draw: *
      plot.plot(
        size: (5.2, 3.6),
        axis-style: "school-book",
        x-tick-step: 1.0, y-tick-step: 1.0,
        x-label: $x$, y-label: $y$,
        x-min: -1.5, x-max: 3.5, y-min: -4.0, y-max: 3.0,
        {
        plot.add(domain: (-1.20, 3.20), x => calc.pow(x, 3) - 3 * calc.pow(x, 2) + 1, style: (stroke: 1.2pt + rgb("#dc2626")))
        plot.add(((0.00, 1.00), (2.00, -3.00),), style: (stroke: none), mark: "o", mark-size: 0.12)
        }
      )
    })
      ]
    ]
  )
]
#v(6pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[ĐỒ THỊ 3: Hàm phân thức bậc 2/1 (Tiệm cận)] \
      #v(4pt)
      #text(size: 8.5pt)[
        - *Dạng hàm số:* rational_2_1 \
        - *Miền hiển thị:* $x in [-2.5; 4.5]$, $y in [-6.0; 6.0]$ \
        - *Đường tiệm cận:* Đứng $x = 1$, Xiên \
        - *Điểm đặc biệt (Cực trị / Giao điểm):* \
                + Tọa độ $(1.0; 0.0)$: I(1; 0)
      ]
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
      import cetz-v3.draw: *
      plot.plot(
        size: (5.2, 3.6),
        axis-style: "school-book",
        x-tick-step: 1.0, y-tick-step: 2.0,
        x-label: $x$, y-label: $y$,
        x-min: -2.5, x-max: 4.5, y-min: -6.0, y-max: 6.0,
        {
        plot.add(domain: (-2.50, 0.80), x => (calc.pow(x, 2) - 2 * x + 3) / (x - 1), style: (stroke: 1.2pt + rgb("#059669")))
        plot.add(domain: (1.20, 4.50), x => (calc.pow(x, 2) - 2 * x + 3) / (x - 1), style: (stroke: 1.2pt + rgb("#059669")))
        plot.add-vline(1, min: -6.0, max: 6.0, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
        plot.add(domain: (-3.00, 5.00), x => x - 1, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
        plot.add(((1.00, 0.00),), style: (stroke: none), mark: "o", mark-size: 0.12)
        }
      )
    })
      ]
    ]
  )
]
#v(6pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[ĐỒ THỊ 4: Hàm phân thức bậc 2/1 (Xét dấu hệ số)] \
      #v(4pt)
      #text(size: 8.5pt)[
        - *Dạng hàm số:* rational_2_1 \
        - *Miền hiển thị:* $x in [-1.0; 5.0]$, $y in [-2.0; 5.0]$ \
        - *Đường tiệm cận:* Đứng $x = 2$, Xiên \
        - *Điểm đặc biệt (Cực trị / Giao điểm):* \
                + Tọa độ $(1.0; -1.0)$: (1; -1)
        + Tọa độ $(3.0; 3.0)$: (3; 3)
      ]
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
      import cetz-v3.draw: *
      plot.plot(
        size: (5.2, 3.6),
        axis-style: "school-book",
        x-tick-step: 1.0, y-tick-step: 1.0,
        x-label: $x$, y-label: $y$,
        x-min: -1.0, x-max: 5.0, y-min: -2.0, y-max: 5.0,
        {
        plot.add(domain: (-1.00, 1.80), x => (calc.pow(x, 2) - 3 * x + 3) / (x - 2), style: (stroke: 1.2pt + rgb("#7c3aed")))
        plot.add(domain: (2.20, 5.00), x => (calc.pow(x, 2) - 3 * x + 3) / (x - 2), style: (stroke: 1.2pt + rgb("#7c3aed")))
        plot.add-vline(2, min: -2.0, max: 5.0, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
        plot.add(domain: (-2.00, 6.00), x => x - 1, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
        plot.add(((1.00, -1.00), (3.00, 3.00),), style: (stroke: none), mark: "o", mark-size: 0.12)
        }
      )
    })
      ]
    ]
  )
]
#v(6pt)

#pagebreak()


#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 8pt, radius: 4pt, width: 100%)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 12pt,
    [
      #text(weight: "bold", size: 10pt, fill: rgb("#0f766e"))[ĐỒ THỊ 5: So sánh hàm Gauss và Parabol] \
      #v(4pt)
      #text(size: 8.5pt)[
        - *Dạng hàm số:* comparison \
        - *Miền hiển thị:* $x in [-3.0; 3.0]$, $y in [-1.0; 1.5]$ \
        - *Đường tiệm cận:* Ngang $y = 0$ \
        - *Điểm đặc biệt (Cực trị / Giao điểm):* \
                + Tọa độ $(0.0; 1.0)$: (0; 1)
      ]
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
      import cetz-v3.draw: *
      plot.plot(
        size: (5.2, 3.6),
        axis-style: "school-book",
        x-tick-step: 1.0, y-tick-step: 0.5,
        x-label: $x$, y-label: $y$,
        x-min: -3.0, x-max: 3.0, y-min: -1.0, y-max: 1.5,
        {
        plot.add(domain: (-3.00, 3.00), x => calc.exp(-calc.pow(x, 2) / 2), style: (stroke: 1.2pt + rgb("#ea580c")))
        plot.add(domain: (-2.00, 2.00), x => 1 - calc.pow(x, 2) / 2, style: (stroke: 1.2pt + rgb("#4b5563")))
        plot.add-hline(0, min: -3.0, max: 3.0, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
        plot.add(((0.00, 1.00),), style: (stroke: none), mark: "o", mark-size: 0.12)
        }
      )
    })
      ]
    ]
  )
]
#v(6pt)

#pagebreak()
#align(center)[
  #text(size: 12pt, weight: "bold", fill: rgb("#0f766e"))[PHẦN 2: 3 BẢNG BIẾN THIÊN TIÊU BIỂU (GIÁN ĐOẠN TIỆM CẬN, TRÙNG PHƯƠNG, HÀM PHÂN THỨC ĐƠN ĐIỆU)]
]
#v(6pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 6pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 9.5pt, fill: rgb("#0f766e"))[BBT 1: Hàm phân thức bậc 2/1 có tiệm cận đứng] \
  #v(2pt)
  #align(center)[
    #tabvar(
    variable: $x$,
    label: (
      ([$y'$], "s"),
      ([$y$], "v"),
    ),
    domain: ($-oo$, $-4$, $-1$, $2$, $+oo$),
    nocadre: true,
    line-style: (stroke: none),
    arrow-mark: (end: ">"),
    arrow-style: (stroke: 0.8pt + black),
    table-style: (stroke: 0.6pt + black),
    contents: (
      ($+$, ("0", $-$), ("||", $-$), ("0", $+$)),
      (
        (bottom, $-oo$),
        (top, $-11$),
        (bottom, top, "||", $-oo$, $+oo$),
        (bottom, $1$),
        (top, $+oo$),
      )
    ),
  )
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 6pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 9.5pt, fill: rgb("#0f766e"))[BBT 2: Hàm số bậc 4 trùng phương] \
  #v(2pt)
  #align(center)[
    #tabvar(
    variable: $x$,
    label: (
      ([$y'$], "s"),
      ([$y$], "v"),
    ),
    domain: ($-oo$, $-1$, $0$, $1$, $+oo$),
    nocadre: true,
    line-style: (stroke: none),
    arrow-mark: (end: ">"),
    arrow-style: (stroke: 0.8pt + black),
    table-style: (stroke: 0.6pt + black),
    contents: (
      ($-$, ("0", $+$), ("0", $-$), ("0", $+$)),
      (
        (top, $+oo$),
        (bottom, $-3$),
        (top, $0$),
        (bottom, $-3$),
        (top, $+oo$),
      )
    ),
  )
  ]
]
#v(4pt)

#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 6pt, radius: 4pt, width: 100%)[
  #text(weight: "bold", size: 9.5pt, fill: rgb("#0f766e"))[BBT 3: Hàm phân thức bậc 1/1] \
  #v(2pt)
  #align(center)[
    #tabvar(
    variable: $x$,
    label: (
      ([$y'$], "s"),
      ([$y$], "v"),
    ),
    domain: ($-oo$, $3$, $+oo$),
    nocadre: true,
    line-style: (stroke: none),
    arrow-mark: (end: ">"),
    arrow-style: (stroke: 0.8pt + black),
    table-style: (stroke: 0.6pt + black),
    contents: (
      ($-$, ("||", $-$)),
      (
        (top, $2$),
        (bottom, top, "||", $-oo$, $+oo$),
        (bottom, $2$),
      )
    ),
  )
  ]
]
#v(4pt)
