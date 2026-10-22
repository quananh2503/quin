#import "@preview/cetz:0.5.2"

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  let O = (0.0, 0.0)
  
  // Trục Oz
  line(O, (0, 3.4), mark: (end: ">"), stroke: 0.8pt + black)
  content((0.2, 3.4), text(weight: "bold", size: 9pt)[$z$])
  
  // Trục Oy
  line(O, (4.5, 0), mark: (end: ">"), stroke: 0.8pt + black)
  content((4.5, -0.3), text(weight: "bold", size: 9pt)[$y$])
  
  // Trục Ox
  line(O, (-2.0, -1.8), mark: (end: ">"), stroke: 0.8pt + black)
  content((-2.2, -1.8), text(weight: "bold", size: 9pt)[$x$])
  content((-0.25, 0.25), text(weight: "bold", size: 8.5pt)[$O$])
  
  // Tọa độ 8 đỉnh
  let X = (-1.1, -0.99)
  let Y = (2.5, 0)
  let Z = (0, 2.0)
  
  let XY = (X.at(0) + Y.at(0), X.at(1) + Y.at(1))
  let XZ = (X.at(0), X.at(1) + Z.at(1))
  let YZ = (Y.at(0), Y.at(1) + Z.at(1))
  let M = (XY.at(0), XY.at(1) + Z.at(1))
  
  let dash-style = (paint: gray, dash: "dashed", thickness: 0.7pt)
  
  // Mặt đáy Oxy
  line(X, XY, stroke: dash-style)
  line(Y, XY, stroke: dash-style)
  
  // Mặt đỉnh qua Z
  line(Z, XZ, stroke: dash-style)
  line(Z, YZ, stroke: dash-style)
  line(XZ, M, stroke: dash-style)
  line(YZ, M, stroke: dash-style)
  
  // 3 cạnh bên đứng (trừ trục Oz đã có)
  line(X, XZ, stroke: dash-style)
  line(Y, YZ, stroke: dash-style)
  line(XY, M, stroke: dash-style)
  
  // Điểm tọa độ trên các trục
  circle(X, radius: 1.2pt, fill: black)
  content((X.at(0) - 0.25, X.at(1) + 0.15), text(size: 8pt)[$x_0$])
  
  circle(Y, radius: 1.2pt, fill: black)
  content((Y.at(0), Y.at(1) - 0.25), text(size: 8pt)[$y_0$])
  
  circle(Z, radius: 1.2pt, fill: black)
  content((Z.at(0) - 0.25, Z.at(1)), text(size: 8pt)[$z_0$])
  
  // Điểm M
  circle(M, radius: 2.2pt, fill: rgb("#dc2626"))
  content((M.at(0) + 0.45, M.at(1) + 0.25), text(weight: "bold", size: 8.5pt, fill: rgb("#dc2626"))[$M(x_0, y_0, z_0)$])
})
