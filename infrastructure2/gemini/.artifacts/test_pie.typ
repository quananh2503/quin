#import "@preview/cetz:0.5.2"

#let test-pie() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let C = (0.0, 0.0)
    let r = 1.8
    let slices = (
      (40, [Thể thao], rgb("#60a5fa")),
      (30, [Đọc sách], rgb("#4ade80")),
      (20, [Nghệ thuật], rgb("#facc15")),
      (10, [Khác], rgb("#f87171")),
    )
    
    let cur_angle = 90deg
    for item in slices {
      let val = item.at(0)
      let label = item.at(1)
      let col = item.at(2)
      let delta = val * 3.6deg
      let next_angle = cur_angle + delta
      let mid_angle = cur_angle + delta / 2
      
      let p_start = (C.at(0) + r * calc.cos(cur_angle), C.at(1) + r * calc.sin(cur_angle))
      let p_stop = (C.at(0) + r * calc.cos(next_angle), C.at(1) + r * calc.sin(next_angle))
      
      merge-path(close: true, fill: col, stroke: 0.8pt + white, {
        line(C, p_start)
        arc(p_start, radius: r, start: cur_angle, stop: next_angle)
        line(p_stop, C)
      })
      
      // Label bên trong lát quạt
      let p_txt = (C.at(0) + (r * 0.65) * calc.cos(mid_angle), C.at(1) + (r * 0.65) * calc.sin(mid_angle))
      content(p_txt, text(size: 8.5pt, weight: "bold", fill: black)[#str(val)%])
      
      cur_angle = next_angle
    }
    
    // Legend bên dưới
    let leg_y = -2.3
    let leg_items = (
      (-2.4, rgb("#60a5fa"), [Thể thao]),
      (-1.0, rgb("#4ade80"), [Đọc sách]),
      (0.5, rgb("#facc15"), [Nghệ thuật]),
      (2.0, rgb("#f87171"), [Khác]),
    )
    for leg in leg_items {
      let lx = leg.at(0)
      let lcol = leg.at(1)
      let ltxt = leg.at(2)
      rect((lx, leg_y), (lx + 0.3, leg_y + 0.25), fill: lcol, stroke: none)
      content((lx + 0.45, leg_y + 0.12), anchor: "west", text(size: 7.5pt)[#ltxt])
    }
  })
}

#test-pie()
