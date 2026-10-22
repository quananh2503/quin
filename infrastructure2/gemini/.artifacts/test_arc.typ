#import "@preview/cetz:0.5.2"

#cetz.canvas(length: 1cm, {
  import cetz.draw: *
  // Let center be (0,0), radius be (2, 0.6)
  // If position is center: what if anchor: "center"?
  // Or what if we use bezier / bezier-through?
  
  // Test bezier for ellipse bottom half (from (-2,0) to (2,0) passing through (0, -0.6))
  // For standard ellipse semi-axes a, b:
  // Cubic bezier for semi-ellipse:
  // from (-a, 0) via (-a, -4/3*(sqrt(2)-1)*b)... standard is:
  // k = 4/3 * (sqrt(2) - 1) approx 0.5522847
  let a = 2.0
  let b = 0.6
  let k = 0.5522847
  
  // Right half of bottom: (0, -b) to (a, 0)
  // Left half of bottom: (-a, 0) to (0, -b)
  // Full bottom half with two bezier curves:
  bezier((-a, 0), (0, -b), (-a, -k * b), (-k * a, -b), stroke: blue)
  bezier((0, -b), (a, 0), (k * a, -b), (a, -k * b), stroke: blue)
  
  // Full top half with two bezier curves (dashed):
  bezier((-a, 0), (0, b), (-a, k * b), (-k * a, b), stroke: (paint: red, dash: "dashed"))
  bezier((0, b), (a, 0), (k * a, b), (a, k * b), stroke: (paint: red, dash: "dashed"))
  
  circle((0,0), radius: 0.05, fill: black)
  circle((-a,0), radius: 0.05, fill: black)
  circle((a,0), radius: 0.05, fill: black)
})
