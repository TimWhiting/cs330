import test


type exp
  IntE(n: int)
  IdE(s: string)
  PlusE(l: exp, r: exp)
  MultE(l: exp, r: exp)