import test

fun to-the3rd(n: int)
  n * n * n

fun to-the-nth(x: int, n: int)
  if n == 1 then
    x
  else x * to-the-nth(x, n - 1)

fun to-the42nd(n: int)
  to-the-nth(n, 42)

fun plural(s: string)
  if s.ends-with("y").bool then
    s.slice.extend(-1).string ++ "ies"
  else
    s ++ "s"

type light
  Bulb(watts: int, technology: string)
  Candle(inches: int)

fun electricity-usage(l: light)
  match l
    Bulb(watts) -> watts*24
    Candle -> 0

fun use-for-one-hour(l: light)
  match l
    Bulb -> l
    Candle(0) -> Candle(0)
    Candle(n) -> Candle(n - 1)

fun (==)(l1: light, l2: light)
  match (l1, l2)
    (Bulb(w1, t1), Bulb(w2, t2)) -> w1 == w2 && t1 == t2
    (Candle(i1), Candle(i2)) -> i1 == i2
    _ -> False

fun show(l: light)
  match l
    Bulb(w, t) -> "Bulb(" ++ w.show ++ ", " ++ t ++ ")"
    Candle(i) -> "Candle(" ++ i.show ++ ")"

pub fun test-hw1()
  test("to-the-3rd")
    check(27)
      to-the3rd(3)
    check(64)
      to-the3rd(4)
    check(4913)
      to-the3rd(17)

  test("to-the-42nd")
    check(1)
      to-the42nd(1)
    check(0)
      to-the42nd(0)
    check(4398046511104)
      to-the42nd(2)
    check(4773695331839566234818968439734627784374274207965089)
      to-the42nd(17)

  test("plural")
    check("babies")
      plural("baby")
    check("fishs")
      plural("fish")
    
  test("electricity-usage")
    check(0)
      electricity-usage(Candle(1))
    check(15*24)
      electricity-usage(Bulb(15, "LED"))
    check(2400)
      electricity-usage(Bulb(100, "incandescent"))
    
  test("use-for-one-hour")
    check(Candle(9))
      use-for-one-hour(Candle(10))
    check(Candle(0))
      use-for-one-hour(Candle(0))
  

