#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/cetz-plot:0.1.1": chart

#cetz-v3.canvas({
  chart.columnchart(
    (( [Toán], 8, 9 ), ( [Văn], 7, 8.5 ), ( [Anh], 9, 9.5 )),
    mode: "clustered",
    size: (7, 4),
    labels: ([Học kỳ 1], [Học kỳ 2]),
    legend: "inner-north-west"
  )
})

#v(1cm)

#cetz-v3.canvas({
  chart.piechart(
    (( 40, [Bóng đá] ), ( 30, [Bơi lội] ), ( 20, [Cầu lông] ), ( 10, [Khác] )),
    value-key: 0,
    label-key: 1,
    radius: 1.8,
    slice-style: (rgb("#93c5fd"), rgb("#86efac"), rgb("#fde047"), rgb("#fca5a5")),
    outer-label: (content: "%")
  )
})
