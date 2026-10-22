// =============================================================================
// ARCHETYPES.TYP - THƯ VIỆN KHUNG MẪU HÌNH HỌC VÀ ĐỒ HỌA TOÁN K-12 (CẤP 1 - 2 - 3)
// =============================================================================

#import "@preview/cetz:0.5.2" as cetz
#import "@preview/cetz:0.3.3" as cetz-v3
#import "@preview/ctz-euclide:0.3.0": *
#import "@preview/vartable:0.2.4": tabvar
#import "@preview/cetz-plot:0.1.1": plot, chart

// -----------------------------------------------------------------------------
// 1. PHÂN HỆ 3D: CÁC KHUNG HÌNH KHÔNG GIAN THPT (CeTZ 3D + NỘI SUY TỌA ĐỘ)
// -----------------------------------------------------------------------------

// Helper giải quyết các điểm phụ và đường vẽ thêm trong không gian 3D
#let _process-3d-elements(pts, derived, lines, vectors, polygons, hidden-segments: (), label-offsets: (:)) = {
  import cetz.draw: *
  let mut-pts = pts

  // Lưu thông tin nguồn gốc của các điểm phụ (để xác định xem đoạn nối có đi qua ruột hình không)
  let derived-info = (:)

  // 1. Tính toán điểm phụ (derived points)
  for d in derived {
    if type(d) == dictionary {
      let name = d.at("name", default: "")
      let dtype = d.at("type", default: "ratio")
      let of = d.at("of", default: ())
      let k = d.at("k", default: 0.5)

      if name != "" and type(of) == array and of.len() >= 2 {
        derived-info.insert(name, (type: dtype, of: of, k: k))
        let p1 = mut-pts.at(of.at(0), default: none)
        let p2 = mut-pts.at(of.at(1), default: none)
        if p1 != none and p2 != none {
          if dtype == "ratio" or dtype == "midpoint" {
            let r = if dtype == "midpoint" { 0.5 } else { k }
            mut-pts.insert(name, (p1.at(0) * (1 - r) + p2.at(0) * r, p1.at(1) * (1 - r) + p2.at(1) * r))
          } else if dtype == "centroid" and of.len() >= 3 {
            let p3 = mut-pts.at(of.at(2), default: none)
            if p3 != none {
              if of.len() >= 4 {
                let p4 = mut-pts.at(of.at(3), default: none)
                if p4 != none {
                  mut-pts.insert(name, ((p1.at(0) + p2.at(0) + p3.at(0) + p4.at(0)) / 4, (p1.at(1) + p2.at(1) + p3.at(1) + p4.at(1)) / 4))
                }
              } else {
                mut-pts.insert(name, ((p1.at(0) + p2.at(0) + p3.at(0)) / 3, (p1.at(1) + p2.at(1) + p3.at(1)) / 3))
              }
            }
          }
        }
      }
    }
  }

  // Hàm kiểm tra một đoạn nối giữa 2 điểm (u, v) có phải là NÉT KHUẤT / NÉT ĐỨT không
  let is-hidden-edge(u, v) = {
    // 1. Kiểm tra trong danh sách hidden-segments của khung
    for seg in hidden-segments {
      if (seg.at(0) == u and seg.at(1) == v) or (seg.at(0) == v and seg.at(1) == u) {
        return true
      }
    }
    // 2. Điểm phụ là trọng tâm khối tứ diện / tâm hộp (centroid của 4 điểm)
    let u-info = derived-info.at(u, default: none)
    let v-info = derived-info.at(v, default: none)
    if u-info != none and u-info.at("type") == "centroid" and u-info.at("of").len() >= 4 {
      return true
    }
    if v-info != none and v-info.at("type") == "centroid" and v-info.at("of").len() >= 4 {
      return true
    }
    // 3. Hai trung điểm thuộc hai cạnh chéo nhau không có đỉnh chung (đi xuyên qua ruột hình)
    if u-info != none and v-info != none {
      let of-u = u-info.at("of", default: ())
      let of-v = v-info.at("of", default: ())
      if of-u.len() >= 2 and of-v.len() >= 2 {
        let disjoint = true
        for p-u in of-u {
          if of-v.contains(p-u) { disjoint = false }
        }
        if disjoint { return true }
      }
    }
    // 4. Nếu trong tham số lines truyền vào đã được định nghĩa là "dashed"
    for l in lines {
      if type(l) == dictionary {
        let f = l.at("from", default: "")
        let t = l.at("to", default: "")
        let style = l.at("style", default: "")
        if ((f == u and t == v) or (f == v and t == u)) and style == "dashed" {
          return true
        }
      }
    }
    return false
  }

  // 2. Tô màu mặt phẳng thiết diện (polygons)
  for poly in polygons {
    if type(poly) == dictionary {
      let names = poly.at("pts", default: ())
      let fcol = poly.at("fill", default: rgb(147, 197, 253, 90))
      let poly-coords = ()
      for n in names {
        let p = mut-pts.at(n, default: none)
        if p != none { poly-coords.push(p) }
      }
      if poly-coords.len() >= 3 {
        line(..poly-coords, close: true, fill: fcol, stroke: none)
      }
    }
  }

  // 3. Kẻ các đường phụ nối thêm (lines)
  for l in lines {
    if type(l) == dictionary {
      let from-n = l.at("from", default: "")
      let to-n = l.at("to", default: "")
      let p1 = mut-pts.at(from-n, default: none)
      let p2 = mut-pts.at(to-n, default: none)
      let style = l.at("style", default: "solid")
      let col = l.at("color", default: black)
      let thk = l.at("stroke", default: 0.8pt)
      if p1 != none and p2 != none {
        if style == "dashed" or is-hidden-edge(from-n, to-n) {
          line(p1, p2, stroke: (paint: col, dash: "dashed", thickness: thk))
        } else {
          line(p1, p2, stroke: thk + col)
        }
      }
    }
  }

  // 4. Mũi tên vectơ màu đỏ
  let safe-vectors = if type(vectors) == array and vectors.len() > 0 and type(vectors.at(0)) == str { (vectors,) } else { vectors }
  for v in safe-vectors {
    if type(v) == array and v.len() >= 2 {
      let vFrom = v.at(0)
      let vTo = v.at(1)
      let vStart = mut-pts.at(vFrom, default: none)
      let vEnd = mut-pts.at(vTo, default: none)
      if vStart != none and vEnd != none {
        if is-hidden-edge(vFrom, vTo) {
          line(vStart, vEnd, mark: (end: ">", fill: rgb("#dc2626")), stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 1.3pt))
        } else {
          line(vStart, vEnd, mark: (end: ">", fill: rgb("#dc2626")), stroke: 1.4pt + rgb("#dc2626"))
        }
      }
    }
  }

  // 5. Chấm tròn và nhãn đỉnh
  for (k, p) in mut-pts {
    circle(p, radius: 1.5pt, fill: black)
    let offset = label-offsets.at(k, default: (-0.2, 0.22))
    content((p.at(0) + offset.at(0), p.at(1) + offset.at(1)), text(size: 8.5pt, weight: "bold")[#k])
  }
}

// 3D Khung 1: Tứ diện / Chóp tam giác thường (ABCD hoặc S.ABC)
#let geo-3d-tetrahedron(labels: ("A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ()) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let l0 = labels.at(0)
    let l1 = labels.at(1)
    let l2 = labels.at(2)
    let l3 = labels.at(3)

    let pts = (
      (l0): (1.8, 3.5),  // Đỉnh trên
      (l1): (0.0, 0.4),  // Đáy trái
      (l2): (1.4, -0.6), // Đáy trước
      (l3): (4.0, 0.4),  // Đáy phải (cạnh l1-l3 là cạnh khuất phía sau)
    )
    let dashed = (stroke: (paint: gray.darken(20%), dash: "dashed", thickness: 0.7pt))
    let solid = (stroke: 0.8pt + black)

    line(pts.at(l1), pts.at(l3), ..dashed) // Cạnh khuất l1-l3 (ví dụ BD)
    line(pts.at(l0), pts.at(l1), ..solid)
    line(pts.at(l0), pts.at(l2), ..solid)
    line(pts.at(l0), pts.at(l3), ..solid)
    line(pts.at(l1), pts.at(l2), ..solid)
    line(pts.at(l2), pts.at(l3), ..solid)

    let hidden-segs = (
      (l1, l3),
    )

    let label-offsets = (
      (l0): (0.0, 0.25),
      (l1): (-0.25, 0.0),
      (l2): (-0.05, -0.25),
      (l3): (0.25, 0.0),
    )

    _process-3d-elements(pts, derived, lines, vectors, polygons, hidden-segments: hidden-segs, label-offsets: label-offsets)
  })
}

// 3D Khung 2: Chóp tam giác có cạnh bên vuông góc đáy (SA vuông góc ABC)
#let geo-3d-pyramid-perp(labels: ("S", "A", "B", "C"), derived: (), lines: (), vectors: (), polygons: ()) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lS = labels.at(0)
    let lA = labels.at(1) // A: chân đường cao góc khuất
    let lB = labels.at(2)
    let lC = labels.at(3)

    let pts = (
      (lA): (0.8, 0.6),  // A (chân đường cao góc khuất)
      (lS): (0.8, 3.8),  // S (đỉnh thẳng đứng từ A)
      (lB): (0.0, -0.5), // B
      (lC): (3.8, 0.2),  // C
    )
    let dashed = (stroke: (paint: gray.darken(20%), dash: "dashed", thickness: 0.7pt))
    let solid = (stroke: 0.8pt + black)

    line(pts.at(lS), pts.at(lA), ..dashed) // SA nét đứt
    line(pts.at(lA), pts.at(lB), ..dashed) // AB nét đứt
    line(pts.at(lA), pts.at(lC), ..dashed) // AC nét đứt

    line(pts.at(lS), pts.at(lB), ..solid)  // SB nét liền
    line(pts.at(lS), pts.at(lC), ..solid)  // SC nét liền
    line(pts.at(lB), pts.at(lC), ..solid)  // BC nét liền

    // Ký hiệu vuông góc tại chân đường cao A
    let pA = pts.at(lA)
    line((pA.at(0), pA.at(1) + 0.3), (pA.at(0) - 0.2, pA.at(1) + 0.15), (pA.at(0) - 0.2, pA.at(1) - 0.15), stroke: 0.6pt)

    let hidden-segs = (
      (lS, lA), (lA, lB), (lA, lC),
    )

    let label-offsets = (
      (lS): (0.0, 0.25),
      (lA): (-0.25, 0.15),
      (lB): (-0.25, -0.1),
      (lC): (0.25, 0.0),
    )

    _process-3d-elements(pts, derived, lines, vectors, polygons, hidden-segments: hidden-segs, label-offsets: label-offsets)
  })
}

// 3D Khung 3: Chóp tứ giác đáy hình bình hành (S.ABCD)
#let geo-3d-pyramid4(labels: ("S", "A", "B", "C", "D"), derived: (), lines: (), vectors: (), polygons: ()) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lS = labels.at(0)
    let lA = labels.at(1) // A: góc khuất phía sau
    let lB = labels.at(2)
    let lC = labels.at(3)
    let lD = labels.at(4)

    let pts = (
      (lS): (1.8, 3.8),  // S
      (lA): (0.8, 0.8),  // A (đỉnh góc khuất phía sau)
      (lB): (0.0, -0.2), // B
      (lC): (3.2, -0.2), // C
      (lD): (4.0, 0.8),  // D
    )
    let dashed = (stroke: (paint: gray.darken(20%), dash: "dashed", thickness: 0.7pt))
    let solid = (stroke: 0.8pt + black)

    line(pts.at(lS), pts.at(lA), ..dashed) // SA
    line(pts.at(lA), pts.at(lB), ..dashed) // AB
    line(pts.at(lA), pts.at(lD), ..dashed) // AD

    line(pts.at(lB), pts.at(lC), ..solid)  // BC
    line(pts.at(lC), pts.at(lD), ..solid)  // CD
    line(pts.at(lS), pts.at(lB), ..solid)  // SB
    line(pts.at(lS), pts.at(lC), ..solid)  // SC
    line(pts.at(lS), pts.at(lD), ..solid)  // SD

    let hidden-segs = (
      (lS, lA), (lA, lB), (lA, lD),
      (lA, lC), (lB, lD),
    )

    let label-offsets = (
      (lS): (0.0, 0.25),
      (lA): (-0.22, 0.15),
      (lB): (-0.25, -0.1),
      (lC): (0.2, -0.1),
      (lD): (0.25, 0.1),
    )

    _process-3d-elements(pts, derived, lines, vectors, polygons, hidden-segments: hidden-segs, label-offsets: label-offsets)
  })
}

// 3D Khung 4: Hình hộp chữ nhật / Lập phương (ABCD.A'B'C'D' hoặc ABCD.A1B1C1D1 hoặc ABCD.EFGH)
#let geo-3d-box(labels: ("A", "B", "C", "D", "A'", "B'", "C'", "D'"), derived: (), lines: (), vectors: (), polygons: ()) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    // Chuẩn SGK GDPT 2018:
    // Đáy dưới: ABCD với A là đỉnh khuất ở phía sau bên trái.
    // Đáy trên: A'B'C'D' nâng thẳng đứng lên trên.
    let lA = labels.at(0)
    let lB = labels.at(1)
    let lC = labels.at(2)
    let lD = labels.at(3)
    let lA1 = labels.at(4)
    let lB1 = labels.at(5)
    let lC1 = labels.at(6)
    let lD1 = labels.at(7)

    let pts = (
      (lA):  (1.2, 1.0), // A: Đáy dưới, góc sau bên trái (khuất)
      (lB):  (0.0, 0.0), // B: Đáy dưới, góc trước bên trái (thấy)
      (lC):  (3.4, 0.0), // C: Đáy dưới, góc trước bên phải (thấy)
      (lD):  (4.6, 1.0), // D: Đáy dưới, góc sau bên phải (thấy)
      (lA1): (1.2, 3.8), // A': Đáy trên, góc sau bên trái
      (lB1): (0.0, 2.8), // B': Đáy trên, góc trước bên trái
      (lC1): (3.4, 2.8), // C': Đáy trên, góc trước bên phải
      (lD1): (4.6, 3.8), // D': Đáy trên, góc sau bên phải
    )
    let dashed = (stroke: (paint: gray.darken(20%), dash: "dashed", thickness: 0.7pt))
    let solid = (stroke: 0.8pt + black)

    // 3 cạnh khung khuất xuất phát từ đỉnh A
    line(pts.at(lA), pts.at(lB), ..dashed)
    line(pts.at(lA), pts.at(lD), ..dashed)
    line(pts.at(lA), pts.at(lA1), ..dashed)

    // 9 cạnh khung thấy còn lại
    line(pts.at(lB), pts.at(lC), ..solid)
    line(pts.at(lC), pts.at(lD), ..solid)
    line(pts.at(lB), pts.at(lB1), ..solid)
    line(pts.at(lC), pts.at(lC1), ..solid)
    line(pts.at(lD), pts.at(lD1), ..solid)
    line(pts.at(lA1), pts.at(lB1), ..solid)
    line(pts.at(lB1), pts.at(lC1), ..solid)
    line(pts.at(lC1), pts.at(lD1), ..solid)
    line(pts.at(lD1), pts.at(lA1), ..solid)

    let hidden-segs = (
      // 3 cạnh khung khuất gặp tại đỉnh A:
      (lA, lB), (lA, lD), (lA, lA1),
      // 4 đường chéo không gian xuyên qua lòng khối hộp:
      (lA, lC1), // A -> C'
      (lB, lD1), // B -> D'
      (lC, lA1), // C -> A'
      (lD, lB1), // D -> B'
      // Đường chéo các mặt phẳng khuất phía sau:
      // Mặt sau trái ABB'A':
      (lA, lB1), (lA1, lB),
      // Mặt sau phải ADD'A':
      (lA, lD1), (lA1, lD),
      // Mặt đáy dưới ABCD (khuất dưới khối):
      (lA, lC),  (lB, lD),
    )

    let label-offsets = (
      (lA):  (-0.25, 0.15),
      (lB):  (-0.25, -0.15),
      (lC):  (0.2, -0.15),
      (lD):  (0.22, 0.1),
      (lA1): (-0.2, 0.22),
      (lB1): (-0.25, 0.15),
      (lC1): (0.25, -0.1),
      (lD1): (0.22, 0.2),
    )

    _process-3d-elements(pts, derived, lines, vectors, polygons, hidden-segments: hidden-segs, label-offsets: label-offsets)
  })
}

// 3D Khung 5: Hình lăng trụ tam giác (ABC.A'B'C')
#let geo-3d-prism-triangular(labels: ("A", "B", "C", "A'", "B'", "C'"), derived: (), lines: (), vectors: (), polygons: ()) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lA = labels.at(0)  // Đáy dưới, góc sau (khuất)
    let lB = labels.at(1)  // Đáy dưới, trước trái
    let lC = labels.at(2)  // Đáy dưới, trước phải
    let lA1 = labels.at(3) // Đáy trên, góc sau
    let lB1 = labels.at(4) // Đáy trên, trước trái
    let lC1 = labels.at(5) // Đáy trên, trước phải

    let pts = (
      (lA):  (0.8, 0.8),  // A (khuất)
      (lB):  (0.0, -0.2), // B
      (lC):  (3.2, 0.0),  // C
      (lA1): (0.8, 3.6),  // A'
      (lB1): (0.0, 2.6),  // B'
      (lC1): (3.2, 2.8),  // C'
    )
    let dashed = (stroke: (paint: gray.darken(20%), dash: "dashed", thickness: 0.7pt))
    let solid = (stroke: 0.8pt + black)

    line(pts.at(lA), pts.at(lA1), ..dashed) // AA'
    line(pts.at(lA), pts.at(lB), ..dashed)  // AB
    line(pts.at(lA), pts.at(lC), ..dashed)  // AC

    line(pts.at(lB), pts.at(lC), ..solid)   // BC
    line(pts.at(lB), pts.at(lB1), ..solid)  // BB'
    line(pts.at(lC), pts.at(lC1), ..solid)  // CC'
    line(pts.at(lA1), pts.at(lB1), ..solid) // A'B'
    line(pts.at(lB1), pts.at(lC1), ..solid) // B'C'
    line(pts.at(lC1), pts.at(lA1), ..solid) // C'A'

    let hidden-segs = (
      // 3 cạnh khung khuất gặp tại A:
      (lA, lA1), (lA, lB), (lA, lC),
      // Đường chéo các mặt khuất phía sau:
      // Mặt sau trái ABB'A':
      (lA, lB1), (lA1, lB),
      // Mặt sau phải ACC'A':
      (lA, lC1), (lA1, lC),
    )

    let label-offsets = (
      (lA):  (-0.22, 0.15),
      (lB):  (-0.25, -0.1),
      (lC):  (0.22, 0.0),
      (lA1): (0.0, 0.25),
      (lB1): (-0.25, 0.1),
      (lC1): (0.22, 0.1),
    )

    _process-3d-elements(pts, derived, lines, vectors, polygons, hidden-segments: hidden-segs, label-offsets: label-offsets)
  })
}

// -----------------------------------------------------------------------------
// 2. PHÂN HỆ 2D: CÁC KHUNG HÌNH HỌC PHẲNG CẤP 1 & CẤP 2 (ctz-euclide & CeTZ Declarative)
// -----------------------------------------------------------------------------

#let _dist2d(p1, p2) = {
  calc.sqrt(calc.pow(p1.at(0) - p2.at(0), 2) + calc.pow(p1.at(1) - p2.at(1), 2))
}

#let _circumcenter2d(pA, pB, pC) = {
  let D = 2 * (pA.at(0) * (pB.at(1) - pC.at(1)) + pB.at(0) * (pC.at(1) - pA.at(1)) + pC.at(0) * (pA.at(1) - pB.at(1)))
  if calc.abs(D) < 0.0001 { return (0.0, 0.0) }
  let a2 = calc.pow(pA.at(0), 2) + calc.pow(pA.at(1), 2)
  let b2 = calc.pow(pB.at(0), 2) + calc.pow(pB.at(1), 2)
  let c2 = calc.pow(pC.at(0), 2) + calc.pow(pC.at(1), 2)
  let ox = (a2 * (pB.at(1) - pC.at(1)) + b2 * (pC.at(1) - pA.at(1)) + c2 * (pA.at(1) - pB.at(1))) / D
  let oy = (a2 * (pC.at(0) - pB.at(0)) + b2 * (pA.at(0) - pC.at(0)) + c2 * (pB.at(0) - pA.at(0))) / D
  (ox, oy)
}

#let _project2d(pP, pA, pB) = {
  let dx = pB.at(0) - pA.at(0)
  let dy = pB.at(1) - pA.at(1)
  let L2 = dx * dx + dy * dy
  if L2 < 0.00001 { return pA }
  let t = ((pP.at(0) - pA.at(0)) * dx + (pP.at(1) - pA.at(1)) * dy) / L2
  (pA.at(0) + t * dx, pA.at(1) + t * dy)
}

#let _intersect_lines2d(pA, pB, pC, pD) = {
  let x1 = pA.at(0); let y1 = pA.at(1)
  let x2 = pB.at(0); let y2 = pB.at(1)
  let x3 = pC.at(0); let y3 = pC.at(1)
  let x4 = pD.at(0); let y4 = pD.at(1)
  let det = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
  if calc.abs(det) < 0.00001 { return ((x1 + x3)/2, (y1 + y3)/2) }
  let t = ((x1 - x3) * (y3 - y4) - (y1 - y3) * (x3 - x4)) / det
  (x1 + t * (x2 - x1), y1 + t * (y2 - y1))
}

#let _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: (:)) = {
  import cetz.draw: *
  let mut-pts = pts

  // 1. Tính toán điểm phụ
  for d in derived {
    if type(d) == dictionary {
      let name = d.at("name", default: "")
      let dtype = d.at("type", default: "midpoint")
      let of = d.at("of", default: ())
      let k = d.at("k", default: 0.5)

      if name != "" and type(of) == array {
        if dtype == "midpoint" and of.len() >= 2 {
          let p1 = mut-pts.at(of.at(0), default: none)
          let p2 = mut-pts.at(of.at(1), default: none)
          if p1 != none and p2 != none {
            mut-pts.insert(name, ((p1.at(0) + p2.at(0)) / 2, (p1.at(1) + p2.at(1)) / 2))
          }
        } else if dtype == "symmetry" and of.len() >= 2 {
          let pOrig = mut-pts.at(of.at(0), default: none)
          let pCenter = mut-pts.at(of.at(1), default: none)
          if pOrig != none and pCenter != none {
            mut-pts.insert(name, (2 * pCenter.at(0) - pOrig.at(0), 2 * pCenter.at(1) - pOrig.at(1)))
          }
        } else if dtype == "project" and of.len() >= 3 {
          let pP = mut-pts.at(of.at(0), default: none)
          let pA = mut-pts.at(of.at(1), default: none)
          let pB = mut-pts.at(of.at(2), default: none)
          if pP != none and pA != none and pB != none {
            mut-pts.insert(name, _project2d(pP, pA, pB))
          }
        } else if dtype == "intersection" and of.len() >= 4 {
          let p1 = mut-pts.at(of.at(0), default: none)
          let p2 = mut-pts.at(of.at(1), default: none)
          let p3 = mut-pts.at(of.at(2), default: none)
          let p4 = mut-pts.at(of.at(3), default: none)
          if p1 != none and p2 != none and p3 != none and p4 != none {
            mut-pts.insert(name, _intersect_lines2d(p1, p2, p3, p4))
          }
        } else if dtype == "ratio" and of.len() >= 2 {
          let p1 = mut-pts.at(of.at(0), default: none)
          let p2 = mut-pts.at(of.at(1), default: none)
          if p1 != none and p2 != none {
            mut-pts.insert(name, (p1.at(0) * (1 - k) + p2.at(0) * k, p1.at(1) * (1 - k) + p2.at(1) * k))
          }
        }
      }
    }
  }

  // 2. Vẽ polygons (thiết diện, tứ giác/tam giác tô màu nhạt)
  for poly in polygons {
    if type(poly) == dictionary {
      let names = poly.at("pts", default: ())
      let fcol = poly.at("fill", default: rgb(147, 197, 253, 50))
      let poly-coords = ()
      for n in names {
        let p = mut-pts.at(n, default: none)
        if p != none { poly-coords.push(p) }
      }
      if poly-coords.len() >= 3 {
        line(..poly-coords, close: true, fill: fcol, stroke: 0.8pt + black)
      }
    }
  }

  // 3. Vẽ đường tròn (circles)
  for c in circles {
    if type(c) == dictionary {
      let thru = c.at("through", default: ())
      let col = c.at("color", default: rgb("#0369a1"))
      let thk = c.at("stroke", default: 0.8pt)
      if thru.len() >= 3 {
        let p1 = mut-pts.at(thru.at(0), default: none)
        let p2 = mut-pts.at(thru.at(1), default: none)
        let p3 = mut-pts.at(thru.at(2), default: none)
        if p1 != none and p2 != none and p3 != none {
          let O = _circumcenter2d(p1, p2, p3)
          let R = _dist2d(O, p1)
          circle(O, radius: R, stroke: thk + col)
        }
      } else if thru.len() == 2 {
        let p1 = mut-pts.at(thru.at(0), default: none)
        let p2 = mut-pts.at(thru.at(1), default: none)
        if p1 != none and p2 != none {
          let O = ((p1.at(0) + p2.at(0))/2, (p1.at(1) + p2.at(1))/2)
          let R = _dist2d(p1, p2)/2
          circle(O, radius: R, stroke: thk + col)
        }
      } else {
        let cName = c.at("center", default: "")
        let pO = mut-pts.at(cName, default: none)
        let rVal = c.at("radius", default: 2.0)
        if pO != none {
          circle(pO, radius: rVal, stroke: thk + col)
        }
      }
    }
  }

  // 4. Vẽ các đoạn thẳng nối thêm (lines)
  for l in lines {
    if type(l) == dictionary {
      let from-n = l.at("from", default: "")
      let to-n = l.at("to", default: "")
      let p1 = mut-pts.at(from-n, default: none)
      let p2 = mut-pts.at(to-n, default: none)
      let style = l.at("style", default: "solid")
      let col = l.at("color", default: black)
      let thk = l.at("stroke", default: 0.8pt)
      if p1 != none and p2 != none {
        if style == "dashed" {
          line(p1, p2, stroke: (paint: col, dash: "dashed", thickness: thk))
        } else {
          line(p1, p2, stroke: thk + col)
        }
      }
    }
  }

  // 5. Ký hiệu góc vuông (right_angles)
  for ra in right_angles {
    if type(ra) == array and ra.len() >= 3 {
      let p1 = mut-pts.at(ra.at(0), default: none)
      let pA = mut-pts.at(ra.at(1), default: none)
      let p2 = mut-pts.at(ra.at(2), default: none)
      if p1 != none and pA != none and p2 != none {
        let d1 = _dist2d(p1, pA)
        let d2 = _dist2d(p2, pA)
        if d1 > 0.001 and d2 > 0.001 {
          let s = 0.2
          let u1 = ((p1.at(0) - pA.at(0)) / d1 * s, (p1.at(1) - pA.at(1)) / d1 * s)
          let u2 = ((p2.at(0) - pA.at(0)) / d2 * s, (p2.at(1) - pA.at(1)) / d2 * s)
          let ptA1 = (pA.at(0) + u1.at(0), pA.at(1) + u1.at(1))
          let ptA2 = (pA.at(0) + u1.at(0) + u2.at(0), pA.at(1) + u1.at(1) + u2.at(1))
          let ptA3 = (pA.at(0) + u2.at(0), pA.at(1) + u2.at(1))
          line(ptA1, ptA2, ptA3, stroke: 0.6pt + black)
        }
      }
    }
  }

  // 6. Điểm và nhãn
  for (k, p) in mut-pts {
    circle(p, radius: 1.5pt, fill: black)
    let offset = label-offsets.at(k, default: (0.0, 0.25))
    content((p.at(0) + offset.at(0), p.at(1) + offset.at(1)), text(size: 8.5pt, weight: "bold")[#k])
  }
}

// 2D Khung A: Tam giác tổng quát (geo-2d-triangle)
#let geo-2d-triangle(labels: ("A", "B", "C"), derived: (), lines: (), circles: (), right_angles: (), polygons: (), label_offsets: (:)) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lA = labels.at(0); let lB = labels.at(1); let lC = labels.at(2)
    let pts = (
      (lA): (1.8, 3.4),
      (lB): (0.0, 0.0),
      (lC): (5.0, 0.0),
    )
    line(pts.at(lA), pts.at(lB), pts.at(lC), close: true, stroke: 0.9pt + black)
    let default-offsets = ((lA): (0.0, 0.25), (lB): (-0.25, -0.1), (lC): (0.25, -0.1))
    for (k, v) in label_offsets { default-offsets.insert(k, v) }
    _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: default-offsets)
  })
}

// 2D Khung B: Hình bình hành (geo-2d-parallelogram)
#let geo-2d-parallelogram(labels: ("A", "B", "C", "D"), derived: (), lines: (), circles: (), right_angles: (), polygons: (), label_offsets: (:)) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lA = labels.at(0); let lB = labels.at(1); let lC = labels.at(2); let lD = labels.at(3)
    let pts = (
      (lA): (0.0, 0.0),
      (lB): (2.2, 0.0),
      (lC): (4.2, 3.46),
      (lD): (2.0, 3.46),
    )
    line(pts.at(lA), pts.at(lB), pts.at(lC), pts.at(lD), close: true, stroke: 0.9pt + black)
    let default-offsets = ((lA): (-0.25, -0.1), (lB): (0.25, -0.1), (lC): (0.25, 0.15), (lD): (-0.25, 0.15))
    for (k, v) in label_offsets { default-offsets.insert(k, v) }
    _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: default-offsets)
  })
}

// 2D Khung C: Tứ giác lồi tổng quát (geo-2d-quadrilateral)
#let geo-2d-quadrilateral(labels: ("A", "B", "C", "D"), derived: (), lines: (), circles: (), right_angles: (), polygons: (), label_offsets: (:)) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lA = labels.at(0); let lB = labels.at(1); let lC = labels.at(2); let lD = labels.at(3)
    let pts = (
      (lA): (0.8, 3.4),
      (lB): (0.0, 0.0),
      (lC): (4.8, 0.0),
      (lD): (4.0, 2.8),
    )
    line(pts.at(lA), pts.at(lB), pts.at(lC), pts.at(lD), close: true, stroke: 0.9pt + black)
    let default-offsets = ((lA): (-0.1, 0.25), (lB): (-0.25, -0.1), (lC): (0.25, -0.1), (lD): (0.25, 0.15))
    for (k, v) in label_offsets { default-offsets.insert(k, v) }
    _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: default-offsets)
  })
}

// 2D Khung D: Tam giác nội tiếp đường tròn (geo-2d-circle-triangle)
#let geo-2d-circle-triangle(labels: ("A", "B", "C", "O"), derived: (), lines: (), circles: (), right_angles: (), polygons: (), label_offsets: (:)) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lA = labels.at(0); let lB = labels.at(1); let lC = labels.at(2)
    let lO = if labels.len() >= 4 { labels.at(3) } else { "O" }
    let pA = (1.5, 3.3)
    let pB = (0.0, 0.0)
    let pC = (4.5, 0.0)
    let pO = _circumcenter2d(pA, pB, pC)
    let R = _dist2d(pO, pA)

    circle(pO, radius: R, stroke: 0.8pt + rgb("#0369a1"))
    line(pA, pB, pC, close: true, stroke: 0.9pt + black)

    let pts = (
      (lA): pA,
      (lB): pB,
      (lC): pC,
      (lO): pO,
    )
    let default-offsets = ((lA): (0.0, 0.25), (lB): (-0.25, -0.1), (lC): (0.25, -0.1), (lO): (0.25, 0.0))
    for (k, v) in label_offsets { default-offsets.insert(k, v) }
    _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: default-offsets)
  })
}

// 2D Khung E: Tứ giác nội tiếp đường tròn đường kính AD (geo-2d-circle-quadrilateral)
#let geo-2d-circle-quadrilateral(labels: ("A", "B", "C", "D", "O"), derived: (), lines: (), circles: (), right_angles: (), polygons: (), label_offsets: (:)) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lA = labels.at(0); let lB = labels.at(1); let lC = labels.at(2); let lD = labels.at(3)
    let lO = if labels.len() >= 5 { labels.at(4) } else { "O" }
    let R = 2.2
    let pO = (2.2, 2.2)
    let pA = (0.0, 2.2)  // Trái
    let pD = (4.4, 2.2)  // Phải (AD là đường kính)
    let pB = (2.2 + R * calc.cos(125deg), 2.2 + R * calc.sin(125deg))
    let pC = (2.2 + R * calc.cos(45deg), 2.2 + R * calc.sin(45deg))

    circle(pO, radius: R, stroke: 0.8pt + rgb("#0369a1"))
    line(pA, pB, pC, pD, close: true, stroke: 0.9pt + black)
    line(pA, pD, stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))

    let pts = (
      (lA): pA,
      (lB): pB,
      (lC): pC,
      (lD): pD,
      (lO): pO,
    )
    let default-offsets = ((lA): (-0.25, 0.0), (lB): (-0.2, 0.2), (lC): (0.2, 0.2), (lD): (0.25, 0.0), (lO): (0.0, -0.25))
    for (k, v) in label_offsets { default-offsets.insert(k, v) }
    _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: default-offsets)
  })
}

// 2D Khung F: Đường tròn đường kính BC có các tiếp tuyến (geo-2d-circle-tangent)
#let geo-2d-circle-tangent(labels: ("B", "C", "A", "O"), derived: (), lines: (), circles: (), right_angles: (), polygons: (), label_offsets: (:)) = {
  cetz.canvas(length: 0.85cm, {
    import cetz.draw: *
    let lB = labels.at(0); let lC = labels.at(1); let lA = labels.at(2)
    let lO = if labels.len() >= 4 { labels.at(3) } else { "O" }
    let R = 2.0
    let pO = (2.0, 0.0)
    let pB = (0.0, 0.0)
    let pC = (4.0, 0.0)
    let pA = (2.0 + R * calc.cos(120deg), R * calc.sin(120deg)) // BA = R

    arc(pB, radius: R, start: 180deg, stop: 0deg, stroke: 0.8pt + rgb("#0369a1"))
    line(pB, pC, stroke: 0.9pt + black)
    line(pB, pA, pC, stroke: 0.9pt + black)

    let pts = (
      (lB): pB,
      (lC): pC,
      (lA): pA,
      (lO): pO,
    )
    let default-offsets = ((lB): (-0.25, -0.1), (lC): (0.25, -0.1), (lA): (-0.2, 0.2), (lO): (0.0, -0.25))
    for (k, v) in label_offsets { default-offsets.insert(k, v) }
    _process-2d-elements(pts, derived, lines, circles, right_angles, polygons, label-offsets: default-offsets)
  })
}

// 2D Khung 1: Tam giác nhọn nội tiếp (O) có 3 đường cao đồng quy tại trực tâm H
#let geo-2d-acute-triangle-altitudes(labels: ("A", "B", "C", "O", "H", "D", "E", "F")) = {
  ctz-canvas({
    ctz-init()
    ctz-def-points(A: (1.2, 3.6), B: (0.0, 0.0), C: (4.2, 0.0))
    ctz-def-circumcenter("O", "A", "B", "C")
    ctz-def-orthocenter("H", "A", "B", "C")

    // Chân 3 đường cao
    ctz-def-project("D", "A", "B", "C")
    ctz-def-project("E", "B", "A", "C")
    ctz-def-project("F", "C", "A", "B")

    // Vẽ tam giác và đường tròn ngoại tiếp
    ctz-draw-polygon("A", "B", "C")
    ctz-draw-circumcircle("A", "B", "C", stroke: 0.6pt + rgb("#0369a1"))

    // Kẻ 3 đường cao
    ctz-draw-segment("A", "D", stroke: 0.7pt + rgb("#dc2626"))
    ctz-draw-segment("B", "E", stroke: 0.7pt + rgb("#dc2626"))
    ctz-draw-segment("C", "F", stroke: 0.7pt + rgb("#dc2626"))

    // Ký hiệu góc vuông
    ctz-draw-mark-right-angle("A", "D", "C")
    ctz-draw-mark-right-angle("B", "E", "C")
    ctz-draw-mark-right-angle("C", "F", "A")

    // Điểm và nhãn chống đè chữ
    ctz-draw-points("A", "B", "C", "O", "H", "D", "E", "F")
    ctz-draw-labels(
      A: "above", B: "below left", C: "below right",
      O: "center", H: "below", D: "below", E: "above right", F: "above left"
    )
  })
}

// 2D Khung 2: Điểm ngoài đường tròn + 2 tiếp tuyến MA, MB + Cát tuyến MCD
#let geo-2d-two-tangents-secant() = {
  ctz-canvas({
    ctz-init()
    let O = (0.0, 0.0)
    let R = 2.0
    let M = (-4.2, 0.0)

    ctz-def-points(O: O, M: M)
    ctz-def-circle("C1", "O", radius: R)

    // Tính tiếp điểm A, B từ M
    ctz-def-circle-diameter("C_diam", "M", "O")
    ctz-def-cc(("A", "B"), "C1", "C_diam")

    // Cát tuyến MCD
    ctz-def-points(C: (calc.cos(40deg)*R, calc.sin(40deg)*R))
    ctz-def-lc(("C", "D"), ("M", "C"), "C1")
    ctz-def-midpoint("I", "C", "D")

    // Vẽ hình
    ctz-draw-circle("C1", stroke: 0.8pt + black)
    ctz-draw-segment("M", "A", stroke: 0.8pt + black)
    ctz-draw-segment("M", "B", stroke: 0.8pt + black)
    ctz-draw-segment("M", "D", stroke: 0.8pt + black)
    ctz-draw-segment("O", "A", stroke: (paint: gray, dash: "dashed"))
    ctz-draw-segment("O", "B", stroke: (paint: gray, dash: "dashed"))
    ctz-draw-segment("O", "I", stroke: (paint: gray, dash: "dashed"))
    ctz-draw-segment("M", "O", stroke: (paint: gray, dash: "dashed"))

    // Ký hiệu vuông góc tiếp tuyến & trung điểm dây cung
    ctz-draw-mark-right-angle("M", "A", "O")
    ctz-draw-mark-right-angle("M", "B", "O")
    ctz-draw-mark-right-angle("O", "I", "M")

    ctz-draw-points("M", "O", "A", "B", "C", "D", "I")
    ctz-draw-labels(
      M: "left", O: "right", A: "above", B: "below",
      C: "above right", D: "below right", I: "above"
    )
  })
}

// 2D Khung 3: Tam giác vuông tại A + Đường cao AH
#let geo-2d-right-triangle-altitude(labels: ("A", "B", "C", "H")) = {
  ctz-canvas({
    ctz-init()
    ctz-def-points(B: (0.0, 0.0), C: (5.0, 0.0), A: (1.5, 2.29))
    ctz-def-project("H", "A", "B", "C")

    ctz-draw-polygon("A", "B", "C")
    ctz-draw-segment("A", "H", stroke: 0.8pt + rgb("#dc2626"))

    // Góc vuông kép tại A và H
    ctz-draw-mark-right-angle("B", "A", "C")
    ctz-draw-mark-right-angle("A", "H", "C")

    ctz-draw-points("A", "B", "C", "H")
    ctz-draw-labels(A: "above", B: "below left", C: "below right", H: "below")
  })
}

// 2D Khung 4 (Tiểu học): Hình chữ nhật có đường gióng kích thước thước đo
#let geo-primary-rect-measure(width-cm: 5, height-cm: 3) = {
  ctz-canvas({
    ctz-init()
    ctz-def-points(A: (0.0, height-cm), B: (width-cm, height-cm), C: (width-cm, 0.0), D: (0.0, 0.0))
    ctz-draw-polygon("A", "B", "C", "D", fill: rgb("#f0fdf4"))
    ctz-draw-measure-segment("A", "B", label: [#width-cm cm])
    ctz-draw-measure-segment("B", "C", label: [#height-cm cm])
    ctz-draw-labels(A: "above left", B: "above right", C: "below right", D: "below left")
  })
}

// -----------------------------------------------------------------------------
// 3. PHÂN HỆ GIẢI TÍCH: BẢNG BIẾN THIÊN (vartable) & ĐỒ THỊ Oxy (cetz-plot)
// -----------------------------------------------------------------------------

// BBT Mẫu Khảo sát Hàm Phân thức có Tiệm cận đứng nét đôi ||
#let demo-tabvar-rational() = {
  tabvar(
    variable: $x$,
    label: (
      ([Dấu $y'$], "s"),
      ([Chiều biến thiên $y$], "v"),
    ),
    domain: ($-oo$, $1$, $+oo$),
    contents: (
      ($-$, ("||", $-$)),
      (
        (top, $2$),
        (bottom, top, "||", $-oo$, $+oo$),
        (bottom, $2$),
      ),
    ),
  )
}

// Đồ thị Hàm Bậc 3 Chuẩn SGK (Hệ trục school-book Oxy có mũi tên cắt nhau tại (0,0))
#let demo-function-plot-cubic() = {
  cetz-v3.canvas({
    import cetz-v3.draw: *
    plot.plot(
      size: (6, 4.5),
      axis-style: "school-book",
      x-tick-step: 1, y-tick-step: 2,
      x-label: $x$, y-label: $y$,
      x-min: -2.5, x-max: 2.5, y-min: -3, y-max: 4,
      {
        plot.add(domain: (-2.1, 2.1), x => calc.pow(x, 3) - 3*x + 1, style: (stroke: 1.2pt + blue))
        plot.add-vline(-1, min: 0, max: 3, style: (stroke: (dash: "dashed", paint: gray)))
        plot.add-hline(3, min: -1, max: 0, style: (stroke: (dash: "dashed", paint: gray)))
        plot.add-vline(1, min: -1, max: 0, style: (stroke: (dash: "dashed", paint: gray)))
        plot.add-hline(-1, min: 0, max: 1, style: (stroke: (dash: "dashed", paint: gray)))
        plot.add(((-1, 3), (1, -1)), style: (stroke: none), mark: "o", mark-size: 0.12)
      }
    )
  })
}

// -----------------------------------------------------------------------------
// 4. PHÂN HỆ MỞ RỘNG TOÀN DIỆN K-12 (GDPT 2018: LỚP 6 - 12)
// -----------------------------------------------------------------------------

// Lớp 6: Đoạn thẳng, điểm nằm giữa & thanh đo kích thước
#let geo-line-midpoint-measure() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    line((-0.8, 0), (7.8, 0), stroke: 0.8pt + black)
    content((7.6, 0.3), text(style: "italic", size: 9pt)[$d$])
    
    let pA = (0.5, 0.0)
    let pC = (3.5, 0.0)
    let pB = (7.0, 0.0)
    
    for (pt, name) in ((pA, "A"), (pC, "C"), (pB, "B")) {
      circle(pt, radius: 2pt, fill: black)
      content((pt.at(0), pt.at(1) + 0.35), text(weight: "bold", size: 9pt)[#name])
    }
    
    line((pA.at(0), -0.6), (pB.at(0), -0.6), mark: (start: "<", end: ">"), stroke: 0.7pt + rgb("#2563eb"))
    content(((pA.at(0) + pB.at(0))/2, -0.95), text(fill: rgb("#2563eb"), size: 8.5pt)[$A B = 7 "cm"$])
    
    line((pA.at(0), -1.4), (pC.at(0), -1.4), mark: (start: "<", end: ">"), stroke: 0.6pt + rgb("#059669"))
    content(((pA.at(0) + pC.at(0))/2, -1.75), text(fill: rgb("#059669"), size: 8pt)[$A C = 3 "cm"$])
    
    line((pC.at(0), -1.4), (pB.at(0), -1.4), mark: (start: "<", end: ">"), stroke: 0.6pt + rgb("#d97706"))
    content(((pC.at(0) + pB.at(0))/2, -1.75), text(fill: rgb("#d97706"), size: 8pt)[$C B = 4 "cm"$])
  })
}

// Lớp 6 - 7: Biểu đồ cột kép so sánh kết quả học tập
#let chart-k12-column-double() = {
  cetz-v3.canvas({
    chart.columnchart(
      (( [Toán], 8.0, 9.0 ), ( [Văn], 7.0, 8.5 ), ( [Anh], 9.0, 9.5 ), ( [KHTN], 7.5, 8.5 )),
      mode: "clustered",
      size: (6.5, 3.8),
      labels: ([Học kỳ 1], [Học kỳ 2]),
      legend: "inner-north-west"
    )
  })
}

// Lớp 7: Biểu đồ hình quạt tròn (Pie Chart) cơ cấu tỉ lệ %
#let chart-k12-pie() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let C = (0.0, 0.0)
    let r = 1.6
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
      
      // Nhãn phần trăm bên trong từng múi quạt
      let p_txt = (C.at(0) + (r * 0.65) * calc.cos(mid_angle), C.at(1) + (r * 0.65) * calc.sin(mid_angle))
      content(p_txt, text(size: 8pt, weight: "bold", fill: black)[#str(val)%])
      
      cur_angle = next_angle
    }
    
    // Legend chú giải bên dưới
    let leg_y = -2.1
    let leg_items = (
      (-2.5, rgb("#60a5fa"), [Thể thao]),
      (-1.1, rgb("#4ade80"), [Đọc sách]),
      (0.35, rgb("#facc15"), [Nghệ thuật]),
      (1.9, rgb("#f87171"), [Khác]),
    )
    for leg in leg_items {
      let lx = leg.at(0)
      let lcol = leg.at(1)
      let ltxt = leg.at(2)
      rect((lx, leg_y), (lx + 0.22, leg_y + 0.2), fill: lcol, stroke: none)
      content((lx + 0.3, leg_y + 0.1), anchor: "west", text(size: 6.8pt)[#ltxt])
    }
  })
}

// Lớp 7: Hai đường thẳng song song bị cắt bởi cát tuyến (Góc so le trong & đồng vị)
#let geo-parallel-transversal() = {
  cetz.canvas(length: 1cm, {
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
    
    let r_arc = 0.55
    // Cung góc so le trong tại A: từ -54.5deg đến 0deg (nằm giữa cát tuyến c và tia a sang phải)
    let a_start_A = -54.5deg
    let a_stop_A = 0deg
    let pos_A = (pA.at(0) + r_arc * calc.cos(a_start_A), pA.at(1) + r_arc * calc.sin(a_start_A))
    arc(pos_A, radius: r_arc, start: a_start_A, stop: a_stop_A, stroke: 1.2pt + rgb("#dc2626"))
    content((pA.at(0) + 0.45, pA.at(1) - 0.25), text(size: 8.5pt, fill: rgb("#dc2626"))[$hat(A)_1$])
    
    // Cung góc so le trong tại B: từ 125.5deg đến 180deg (nằm giữa cát tuyến c và tia b sang trái)
    let a_start_B = 125.5deg
    let a_stop_B = 180deg
    let pos_B = (pB.at(0) + r_arc * calc.cos(a_start_B), pB.at(1) + r_arc * calc.sin(a_start_B))
    arc(pos_B, radius: r_arc, start: a_start_B, stop: a_stop_B, stroke: 1.2pt + rgb("#dc2626"))
    content((pB.at(0) - 0.45, pB.at(1) + 0.25), text(size: 8.5pt, fill: rgb("#dc2626"))[$hat(B)_2$])
    
    content((5.0, 1.5), text(size: 8.5pt, fill: rgb("#dc2626"))[$a \/\/ b arrow.r hat(A)_1 = hat(B)_2$ \ (so le trong)])
  })
}

// Lớp 8: Định lý Thalès & Tam giác đồng dạng (kèm đường phân giác)
#let geo-thales-similar() = {
  ctz-canvas({
    ctz-init()
    ctz-def-points(A: (2.0, 3.6), B: (0.0, 0.0), C: (4.5, 0.0))
    let k = 0.55
    ctz-def-points(
      D: (2.0 * (1 - k), 3.6 * (1 - k)),
      E: (2.0 * (1 - k) + 4.5 * k, 3.6 * (1 - k))
    )
    
    ctz-draw-polygon("A", "B", "C", stroke: 0.8pt + black)
    ctz-draw-segment("D", "E", stroke: 1pt + rgb("#2563eb"))
    
    // Phân giác trong AK
    ctz-def-incenter("I", "A", "B", "C")
    ctz-def-ll("K", ("A", "I"), ("B", "C"))
    ctz-draw-segment("A", "K", stroke: 0.8pt + rgb("#dc2626"))
    
    ctz-draw-points("A", "B", "C", "D", "E", "K")
    ctz-draw-labels(A: "above", B: "below left", C: "below right", D: "left", E: "right", K: "below")
  })
}

// Lớp 9: Đường tròn, Tiếp tuyến & Tứ giác nội tiếp
#let geo-circle-cyclic-tangent() = {
  ctz-canvas({
    ctz-init()
    let O = (0.0, 0.0)
    let R = 2.2
    ctz-def-points(O: O)
    ctz-def-circle("C1", "O", radius: R)
    
    ctz-def-points(
      A: (0.0, 2.2),
      B: (-2.1, -0.65),
      C: (0.5, -2.14),
      D: (2.15, 0.45)
    )
    
    ctz-def-points(Ax1: (-2.5, 2.2), Ax2: (2.5, 2.2))
    
    ctz-draw-circle("C1", stroke: 0.8pt + black)
    ctz-draw-polygon("A", "B", "C", "D", stroke: 0.8pt + black, fill: rgb(219, 234, 254, 40))
    ctz-draw-segment("A", "C", stroke: (paint: gray, dash: "dashed"))
    ctz-draw-segment("B", "D", stroke: (paint: gray, dash: "dashed"))
    ctz-draw-segment("Ax1", "Ax2", stroke: 0.9pt + rgb("#dc2626"))
    
    ctz-draw-points("A", "B", "C", "D", "O")
    ctz-draw-labels(A: "above", B: "below left", C: "below", D: "right", O: "center")
  })
}

// Lớp 9 - 11 - 12: Khối nón tròn xoay
#let geo-round-body-cone() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let S = (0.0, 3.2)
    let O = (0.0, 0.0)
    let rx = 1.6
    let ry = 0.45
    let k = 0.5522847
    
    // Nửa elip phía sau (nét đứt)
    bezier((-rx, 0), (0, ry), (-rx, k * ry), (-k * rx, ry), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    bezier((0, ry), (rx, 0), (k * rx, ry), (rx, k * ry), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    
    // Nửa elip phía trước (nét liền)
    bezier((-rx, 0), (0, -ry), (-rx, -k * ry), (-k * rx, -ry), stroke: 0.8pt + black)
    bezier((0, -ry), (rx, 0), (k * rx, -ry), (rx, -k * ry), stroke: 0.8pt + black)
    
    // Đường sinh hai bên
    line(S, (-rx, 0), stroke: 0.8pt + black)
    line(S, (rx, 0), stroke: 0.8pt + black)
    
    // Đường cao và bán kính
    line(S, O, stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    line(O, (rx, 0), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    
    circle(S, radius: 1.5pt, fill: black)
    circle(O, radius: 1.5pt, fill: black)
    content((S.at(0), S.at(1) + 0.3), text(weight: "bold", size: 8.5pt)[S])
    content((O.at(0) - 0.25, O.at(1) - 0.25), text(weight: "bold", size: 8.5pt)[O])
    content((rx/2, -0.22), text(size: 8pt, fill: rgb("#059669"))[$r$])
    content((-0.25, 1.6), text(size: 8pt, fill: rgb("#2563eb"))[$h$])
    content((rx/2 + 0.5, 1.8), text(size: 8pt, fill: rgb("#dc2626"))[$l$])
  })
}

// Lớp 9 - 11 - 12: Khối trụ tròn xoay
#let geo-round-body-cylinder() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let rx = 1.3
    let ry = 0.4
    let h = 2.6
    let O1 = (0.0, h)
    let O2 = (0.0, 0.0)
    let k = 0.5522847
    
    // Đáy trên: Elip nét liền trọn vẹn
    circle(O1, radius: (rx, ry), stroke: 0.8pt + black)
    
    // Đáy dưới: Nửa sau nét đứt, nửa trước nét liền
    bezier((-rx, 0), (0, ry), (-rx, k * ry), (-k * rx, ry), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    bezier((0, ry), (rx, 0), (k * rx, ry), (rx, k * ry), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    bezier((-rx, 0), (0, -ry), (-rx, -k * ry), (-k * rx, -ry), stroke: 0.8pt + black)
    bezier((0, -ry), (rx, 0), (k * rx, -ry), (rx, -k * ry), stroke: 0.8pt + black)
    
    // Hai đường sinh thành trụ
    line((-rx, h), (-rx, 0), stroke: 0.8pt + black)
    line((rx, h), (rx, 0), stroke: 0.8pt + black)
    
    // Trục và bán kính
    line(O1, O2, stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    line(O2, (rx, 0), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    
    circle(O1, radius: 1.5pt, fill: black)
    circle(O2, radius: 1.5pt, fill: black)
    content((O1.at(0), O1.at(1) + 0.3), text(weight: "bold", size: 8.5pt)[O'])
    content((O2.at(0) - 0.25, O2.at(1) - 0.25), text(weight: "bold", size: 8.5pt)[O])
    content((rx/2, -0.22), text(size: 8pt, fill: rgb("#059669"))[$r$])
    content((-0.25, h/2), text(size: 8pt, fill: rgb("#2563eb"))[$h$])
  })
}

// Lớp 9 - 11 - 12: Khối cầu
#let geo-round-body-sphere() = {
  cetz.canvas(length: 1cm, {
    import cetz.draw: *
    let O = (0.0, 0.0)
    let R = 1.5
    let ry = 0.42
    let k = 0.5522847
    
    // Vòng tròn bao ngoài
    circle(O, radius: R, stroke: 0.8pt + black)
    
    // Đường xích đạo: Nửa sau nét đứt, nửa trước nét liền
    bezier((-R, 0), (0, ry), (-R, k * ry), (-k * R, ry), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    bezier((0, ry), (R, 0), (k * R, ry), (R, k * ry), stroke: (paint: gray, dash: "dashed", thickness: 0.7pt))
    bezier((-R, 0), (0, -ry), (-R, -k * ry), (-k * R, -ry), stroke: 0.8pt + black)
    bezier((0, -ry), (R, 0), (k * R, -ry), (R, -k * ry), stroke: 0.8pt + black)
    
    // Bán kính R
    line(O, (R, 0), stroke: (paint: rgb("#dc2626"), dash: "dashed", thickness: 0.8pt))
    circle(O, radius: 1.5pt, fill: black)
    content((O.at(0) - 0.25, O.at(1) - 0.25), text(weight: "bold", size: 8.5pt)[O])
    content((R/2, 0.22), text(size: 8.5pt, fill: rgb("#dc2626"))[$R$])
  })
}

// Lớp 10: Đường Conic (Elip với 2 tiêu điểm F1, F2 trong Oxy)
#let geo-conic-ellipse() = {
  cetz-v3.canvas({
    import cetz-v3.draw: *
    plot.plot(
      name: "plot",
      size: (6, 3.4),
      axis-style: "school-book",
      x-tick-step: 1, y-tick-step: 1,
      x-label: $x$, y-label: $y$,
      x-min: -3.5, x-max: 3.5, y-min: -2.2, y-max: 2.2,
      {
        let a = 2.5
        let b = 1.5
        let c = calc.sqrt(a*a - b*b)
        plot.add(
          domain: (-calc.pi, calc.pi),
          t => (a * calc.cos(t * 1rad), b * calc.sin(t * 1rad)),
          style: (stroke: 1.2pt + rgb("#2563eb"))
        )
        plot.add(((-c, 0), (c, 0)), style: (stroke: none), mark: "o", mark-size: 0.12)
        plot.add-anchor("F1", (-c, -0.3))
        plot.add-anchor("F2", (c, -0.3))
      }
    )
    content("plot.F1", text(size: 8pt, weight: "bold")[$F_1$])
    content("plot.F2", text(size: 8pt, weight: "bold")[$F_2$])
  })
}

// Lớp 10: Biểu đồ hộp (Box-whisker Plot) cho Thống kê mô tả
#let chart-box-whisker() = {
  cetz-v3.canvas({
    chart.boxwhisker(
      size: (6, 3.2),
      label-key: none,
      y-min: 0, y-max: 10, y-tick-step: 2,
      y-label: [Điểm số],
      (x: 1, min: 2.0, max: 9.5, q1: 5.5, q2: 7.0, q3: 8.0)
    )
  })
}

// Lớp 12: Hệ trục tọa độ không gian Oxyz
#let geo-3d-oxyz-coords() = {
  cetz.canvas(length: 1cm, {
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
    
    // Tọa độ 8 đỉnh của khối hộp chữ nhật hình chiếu vuông góc
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
    
    // 3 cạnh bên đứng (trụ thẳng đứng song song với trục Oz)
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
    
    // Điểm M(x0, y0, z0)
    circle(M, radius: 2.2pt, fill: rgb("#dc2626"))
    content((M.at(0) + 0.45, M.at(1) + 0.25), text(weight: "bold", size: 8.5pt, fill: rgb("#dc2626"))[$M(x_0, y_0, z_0)$])
  })
}

// Lớp 12: Bảng biến thiên có tiệm cận xiên (Hàm phân thức bậc 2 trên bậc 1)
#let tabvar-oblique-deg2() = {
  tabvar(
    variable: $x$,
    label: (
      ([Dấu $y'$], "s"),
      ([Chiều biến thiên $y$], "v"),
    ),
    domain: ($-oo$, $0$, $1$, $2$, $+oo$),
    line-style: (stroke: none),
    arrow-mark: (end: ">"),
    arrow-style: (stroke: 0.8pt + black),
    table-style: (stroke: 0.7pt + black),
    contents: (
      ($+$, ("0", $-$), ("||", $-$), ("0", $+$)),
      (
        (bottom, $-oo$),
        (top, $-2$),
        (bottom, top, "||", $-oo$, $+oo$),
        (bottom, $2$),
        (top, $+oo$),
      ),
    ),
  )
}

// Lớp 12: Đồ thị hàm phân thức bậc 2 trên bậc 1 có tiệm cận xiên & đứng
#let plot-rational-oblique() = {
  cetz-v3.canvas({
    import cetz-v3.draw: *
    plot.plot(
      size: (5.8, 3.8),
      axis-style: "school-book",
      x-tick-step: 1, y-tick-step: 2,
      x-label: $x$, y-label: $y$,
      x-min: -3, x-max: 5, y-min: -6, y-max: 6,
      {
        plot.add(domain: (-2.8, 0.8), x => (x*x - 2*x + 2)/(x - 1), style: (stroke: 1.2pt + rgb("#2563eb")))
        plot.add(domain: (1.2, 4.8), x => (x*x - 2*x + 2)/(x - 1), style: (stroke: 1.2pt + rgb("#2563eb")))
        plot.add-vline(1, min: -6, max: 6, style: (stroke: (dash: "dashed", paint: rgb("#dc2626"))))
        plot.add(domain: (-3, 5), x => x - 1, style: (stroke: (dash: "dashed", paint: rgb("#16a34a"))))
        plot.add(((0, -2), (2, 2)), style: (stroke: none), mark: "o", mark-size: 0.12)
      }
    )
  })
}

// =============================================================================
// ALIASES FOR PIPELINE INTEGRATION
// =============================================================================
#let draw-cube = geo-3d-box
#let draw-tetrahedron = geo-3d-tetrahedron
#let draw-prism-tri = geo-3d-prism-triangular
#let draw-pyramid-quad = geo-3d-pyramid4
#let draw-pyramid-tri = geo-3d-pyramid-perp
#let draw-parallelepiped = geo-3d-box
#let draw-cylinder = geo-round-body-cylinder
#let draw-cone = geo-round-body-cone
#let draw-sphere = geo-round-body-sphere
#let draw-oxyz = geo-3d-oxyz-coords

