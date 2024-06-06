import test
import std/text/parse


type exp
  IntE(n: int)
  IdE(s: string)
  PlusE(l: exp, r: exp)
  MultE(l: exp, r: exp)
  AppE(s: string, arg: exp)

type fun-def
  Fd(name: string, arg: string, body: exp)

// An EXP is either
// - 'NUMBER'
// - 'SYMBOL'
// - 'EXP' + 'EXP'
// - 'EXP' * 'EXP'
// - 'SYMBOL(EXP)'
// - '(EXP)'

fun pident()
  val start = alpha().string
  val rest = many(alpha-num).string
  start ++ rest

fun pinte()
  IntE(pint())

fun pide()
  IdE(pident())

fun pplus()
  val p = pexp()
  whitespace()
  char('+')
  whitespace()
  PlusE(p, pexp())

fun pmult()
  val p = pexp()
  whitespace()
  char('*')
  whitespace()
  MultE(p, pexp())

fun papp()
  AppE(pident(), pexp())

fun pparen()
  char('(')
  val exp = pexp()
  char(')')
  exp

fun pexp()
  val res = choose([pparen, pinte, pide, papp, pplus, pmult])
  optional("")
    whitespace()
  res

fun pfundef()
  pstring("fun")
  whitespace()
  val name = pident()
  char('(')
  val arg = pident()
  char(')')
  char(':')
  char('\n')
  pstring("  ")
  val body = pexp()
  Fd(name, arg, body)

fun parse-exp(s: string): pure exp
  match parse(s.slice, pexp)
    ParseOk(v) -> v
    ParseError(e) -> throw("parse error: " ++ e)

fun exp/(==)(e1: exp, e2: exp)
  match (e1, e2)
    (IntE(n1), IntE(n2)) -> n1 == n2
    (IdE(s1), IdE(s2)) -> s1 == s2
    (PlusE(l1, r1), PlusE(l2, r2)) -> l1 == l2 && r1 == r2
    (MultE(l1, r1), MultE(l2, r2)) -> l1 == l2 && r1 == r2
    (AppE(s1, a1), AppE(s2, a2)) -> s1 == s2 && a1 == a2
    _ -> False

fun exp/show(e: exp)
  match e
    IntE(n) -> n.show
    IdE(s) -> s
    PlusE(l, r) -> "(" ++ l.show ++ " + " ++ r.show ++ ")"
    MultE(l, r) -> "(" ++ l.show ++ " * " ++ r.show ++ ")"
    AppE(s, a) -> s ++ "(" ++ a.show ++ ")"

fun test-parse()
  test("expressions")
    check(IntE(2))
      parse-exp("2")
    check(IdE("x"))
      parse-exp("x")
    // check(PlusE(IntE(2), IntE(3)))
    //   parse-exp("2 + 3")
    // check(MultE(IntE(2), IntE(3)))
    //   parse-exp("2 * 3")
    // check(AppE("f", IntE(2)))
    //   parse-exp("f(2)")
    // check(AppE("f", PlusE(IntE(2), IntE(3))))
    //   parse-exp("f(2 + 3)")
    // check(PlusE(IntE(1), AppE("double", IntE(9))))
    //   parse-exp("1 + double(9)")
    // check(MultE(IntE(3), PlusE(IntE(2), IntE(5))))
    //   parse-exp("3 * (2 + 5)")
    // check-exn("parse error")
    //   parse-exp("2 +")

