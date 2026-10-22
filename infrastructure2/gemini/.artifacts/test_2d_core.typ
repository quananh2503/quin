#import "@preview/cetz:0.5.2" as cetz

#let _dist(p1, p2) = {
  calc.sqrt(calc.pow(p1.at(0) - p2.at(0), 2) + calc.pow(p1.at(1) - p2.at(1), 2))
}

#let _circumcenter(pA, pB, pC) = {
  let D = 2 * (pA.at(0) * (pB.at(1) - pC.at(1)) + pB.at(0) * (pC.at(1) - pA.at(1)) + pC.at(0) * (pA.at(1) - pB.at(1)))
  if calc.abs(D) < 0.0001 { return (0.0, 0.0) }
  let a2 = calc.pow(pA.at(0), 2) + calc.pow(pA.at(1), 2)
  let b2 = calc.pow(pB.at(0), 2) + calc.pow(pB.at(1), 2)
  let c2 = calc.pow(pC.at(0), 2) + calc.pow(pC.at(1), 2)
  let ox = (a2 * (pB.at(1) - pC.at(1)) + b2 * (pC.at(1) - pA.at(1)) + c2 * (pA.at(1) - pB.at(1))) / D
  let oy = (a2 * (pC.at(0) - pB.at(0)) + b2 * (pA.at(0) - pC.at(0)) + c2 * (pB.at(0) - pA.at(0))) / D
  (ox, oy)
}

#let _project(pP, pA, pB) = {
  let dx = pB.at(0) - pA.at(0)
  let dy = pB.at(1) - pA.at(1)
  let L2 = dx * dx + dy * dy
  if L2 < 0.00001 { return pA }
  let t = ((pP.at(0) - pA.at(0)) * dx + (pP.at(1) - pA.at(1)) * dy) / L2
  (pA.at(0) + t * dx, pA.at(1) + t * dy)
}

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let A = (1.5, 3.2)
  let B = (0.0, 0.0)
  let C = (4.5, 0.0)
  let O = _circumcenter(A, B, C)
  let R = _dist(O, A)
  let H = _project(A, B, C)

  circle(O, radius: R, stroke: 0.8pt + rgb("#0369a1"))
  line(A, B, C, close: true, stroke: 0.9pt + black)
  line(A, H, stroke: 0.8pt + rgb("#dc2626"))

  // Vẽ góc vuông tại H
  line((H.at(0), H.at(1) + 0.25), (H.at(0) + 0.25, H.at(1) + 0.25), (H.at(0) + 0.25, H.at(1)), stroke: 0.6pt)

  circle(A, radius: 1.5pt, fill: black)
  circle(B, radius: 1.5pt, fill: black)
  circle(C, radius: 1.5pt, fill: black)
  circle(H, radius: 1.5pt, fill: black)
  circle(O, radius: 1.5pt, fill: black)

  content((A.at(0), A.at(1) + 0.28), text(weight: "bold")[A])
  content((B.at(0) - 0.25, B.at(1)), text(weight: "bold")[B])
  content((C.at(0) + 0.25, C.at(1)), text(weight: "bold")[C])
  content((H.at(0), H.at(1) - 0.28), text(weight: "bold")[H])
  content((O.at(0) + 0.25, O.at(1)), text(weight: "bold")[O])
})
