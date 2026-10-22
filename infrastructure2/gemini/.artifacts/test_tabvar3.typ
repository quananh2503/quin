#import "@preview/vartable:0.2.4": tabvar

#tabvar(
  variable: $x$,
  label: (
    ([$y'$], "s"),
    ([$y$], "v"),
  ),
  domain: ($-oo$, $3$, $+oo$),
  nocadre: true,
  line-style: (stroke: none),
  arrow-mark: (end: ">"),
  arrow-style: (stroke: 0.8pt + black),
  table-style: (stroke: 0.6pt + black),
  contents: (
    ($-$, ("||", $-$)),
    (
      (top, $2$),
      (bottom, top, "||", $-oo$, $+oo$),
      (bottom, $2$),
    ),
  ),
)
