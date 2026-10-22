#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/cetz-plot:0.1.1": plot

#cetz-v3.canvas({
  import cetz-v3.draw: *
  plot.plot(
    size: (6, 4.5),
    axis-style: "school-book",
    x-tick-step: 1, y-tick-step: 1,
    x-label: $x$, y-label: $y$,
    x-min: -0.5, x-max: 4.5, y-min: -2, y-max: 2.5,
    {
      plot.add(domain: (0.2, 3.8), x => -calc.pow(x, 2) + 4*x - 3, style: (stroke: 1.2pt + blue))
      plot.add-vline(2, min: 0, max: 1, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add-hline(1, min: 0, max: 2, style: (stroke: (dash: "dashed", paint: gray)))
      plot.add(((2, 1),), style: (stroke: none), mark: "o", mark-size: 0.12)
    }
  )
})
