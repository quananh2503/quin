#set page(paper: "a4", margin: (x: 1.5cm, y: 1.5cm))
#set text(font: ("Arial", "Segoe UI", "DejaVu Sans"), size: 9pt, lang: "vi")

#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/cetz-plot:0.1.1": plot
#import "@preview/vartable:0.2.4": tabvar

#align(center)[
  #text(size: 14pt, weight: "bold", fill: rgb("#1e3a8a"))[TEST TỔNG HỢP: ĐỒ THỊ Oxy (cetz-plot) & BẢNG BIẾN THIÊN (tabvar)]
]
#v(10pt)

// 1. Đồ thị hàm bậc 3
#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 10pt, radius: 4pt)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #text(weight: "bold", size: 10pt)[1. Đồ thị hàm bậc 3: $y = x^3 - 3x^2 + 1$] \
      - Cực đại: $(0; 1)$ \
      - Cực tiểu: $(2; -3)$
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
          import cetz-v3.draw: *
          plot.plot(
            size: (5.0, 3.5),
            axis-style: "school-book",
            x-tick-step: 1, y-tick-step: 1,
            x-label: $x$, y-label: $y$,
            x-min: -1.5, x-max: 3.5, y-min: -4, y-max: 3,
            {
              plot.add(domain: (-1.1, 3.1), x => calc.pow(x, 3) - 3 * calc.pow(x, 2) + 1, style: (stroke: 1.2pt + rgb("#2563eb")))
              plot.add(((0, 1), (2, -3)), style: (stroke: none), mark: "o", mark-size: 0.12)
            }
          )
        })
      ]
    ]
  )
]

#v(10pt)

// 2. Bảng biến thiên hàm bậc 4 trùng phương
#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 10pt, radius: 4pt)[
  #text(weight: "bold", size: 10pt)[2. Bảng biến thiên hàm bậc 4 trùng phương: $y = f(x)$ có 3 cực trị] \
  #v(5pt)
  #align(center)[
    #tabvar(
      variable: $x$,
      label: (
        ([$f'(x)$], "s"),
        ([$f(x)$], "v"),
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
        ),
      ),
    )
  ]
]

#v(10pt)

// 3. Đồ thị hàm phân thức có tiệm cận xiên & đứng
#block(stroke: 0.8pt + rgb("#cbd5e1"), inset: 10pt, radius: 4pt)[
  #grid(
    columns: (1fr, 1fr),
    gutter: 15pt,
    [
      #text(weight: "bold", size: 10pt)[3. Đồ thị phân thức bậc 2/1: $y = (x^2 - 2x + 3)/(x - 1)$] \
      - Tiệm cận đứng: $x = 1$ \
      - Tiệm cận xiên: $y = x - 1$
    ],
    [
      #align(center)[
        #cetz-v3.canvas({
          import cetz-v3.draw: *
          plot.plot(
            size: (5.0, 3.5),
            axis-style: "school-book",
            x-tick-step: 2, y-tick-step: 2,
            x-label: $x$, y-label: $y$,
            x-min: -3, x-max: 5, y-min: -6, y-max: 6,
            {
              plot.add(domain: (-2.8, 0.8), x => (x*x - 2*x + 3)/(x - 1), style: (stroke: 1.2pt + rgb("#2563eb")))
              plot.add(domain: (1.2, 4.8), x => (x*x - 2*x + 3)/(x - 1), style: (stroke: 1.2pt + rgb("#2563eb")))
              plot.add-vline(1, min: -6, max: 6, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
              plot.add(domain: (-3, 5), x => x - 1, style: (stroke: (dash: "dashed", paint: rgb("#16a34a"))))
            }
          )
        })
      ]
    ]
  )
]
