#import "@preview/cetz:0.5.2" as cetz

#cetz.canvas({
  import cetz.draw: *
  // Dashed red vector
  line((0, 0), (3, 2), mark: (end: ">", fill: rgb("#dc2626")), stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 1.3pt))
  // Solid red vector
  line((0, 0), (3, 0), mark: (end: ">", fill: rgb("#dc2626")), stroke: 1.3pt + rgb("#dc2626"))
})
