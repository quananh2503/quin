#import "@preview/cetz:0.5.2"

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  line((0, 2.4), (6.5, 2.4), stroke: 0.8pt + black)
  content((6.3, 2.7), text(style: "italic", size: 9pt)[$a$])
  
  line((0, 0.6), (6.5, 0.6), stroke: 0.8pt + black)
  content((6.3, 0.9), text(style: "italic", size: 9pt)[$b$])
  
  line((1.5, 3.6), (4.5, -0.6), stroke: 0.8pt + rgb("#2563eb"))
  content((1.3, 3.8), text(style: "italic", size: 9pt, fill: rgb("#2563eb"))[$c$])
  
  let pA = (2.36, 2.4)
  let pB = (3.64, 0.6)
  circle(pA, radius: 2pt, fill: black)
  circle(pB, radius: 2pt, fill: black)
  content((pA.at(0) - 0.35, pA.at(1) + 0.3), text(weight: "bold")[A])
  content((pB.at(0) + 0.35, pB.at(1) - 0.3), text(weight: "bold")[B])
  
  let r_arc = 0.6
  // Góc so le trong tại A: từ -54.5deg đến 0deg
  let a_start_A = -54.5deg
  let a_stop_A = 0deg
  let pos_A = (pA.at(0) + r_arc * calc.cos(a_start_A), pA.at(1) + r_arc * calc.sin(a_start_A))
  arc(pos_A, radius: r_arc, start: a_start_A, stop: a_stop_A, stroke: 1.2pt + rgb("#dc2626"))
  content((pA.at(0) + 0.5, pA.at(1) - 0.3), text(size: 8.5pt, fill: rgb("#dc2626"))[$hat(A)_1$])
  
  // Góc so le trong tại B: từ 125.5deg đến 180deg
  let a_start_B = 125.5deg
  let a_stop_B = 180deg
  let pos_B = (pB.at(0) + r_arc * calc.cos(a_start_B), pB.at(1) + r_arc * calc.sin(a_start_B))
  arc(pos_B, radius: r_arc, start: a_start_B, stop: a_stop_B, stroke: 1.2pt + rgb("#dc2626"))
  content((pB.at(0) - 0.5, pB.at(1) + 0.3), text(size: 8.5pt, fill: rgb("#dc2626"))[$hat(B)_2$])
  
  content((5.0, 1.5), text(size: 8.5pt, fill: rgb("#dc2626"))[$a \/\/ b arrow.r hat(A)_1 = hat(B)_2$ \ (so le trong)])
})
