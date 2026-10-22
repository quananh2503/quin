#import "@preview/cetz:0.5.2"

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  // Test dashed arrow
  let p1 = (0, 0)
  let p2 = (4, 3)
  line(p1, p2, mark: (end: ">", fill: rgb("#dc2626")), stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 1.3pt))
})
