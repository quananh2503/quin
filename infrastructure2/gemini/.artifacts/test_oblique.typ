#import "@preview/vartable:0.2.4": tabvar

#tabvar(
  variable: $x$,
  label: (
    ([Dấu $y'$], "s"),
    ([Chiều biến thiên $y$], "v"),
  ),
  domain: ($-oo$, $0$, $1$, $2$, $+oo$),
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
