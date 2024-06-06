import test

type tree
  Leaf(v: int)
  Node(v: int, left: tree, right: tree)

fun sum(t: tree): int
  match t
    Leaf(n) -> n
    Node(n, l, r) -> n + l.sum + r.sum

fun negate(t: tree)
  match t
    Leaf(n) -> Leaf(0 - n)
    Node(n, l, r) -> Node(0 - n, l.negate, r.negate)

fun contains(t: tree, i: int)
  match t
    Leaf(n) -> n == i
    Node(n, l, r) -> n == i || l.contains(i) || r.contains(i)

fun acc/big-leaves(t: tree, length: int): bool
  match t
    Leaf(n) -> n > length
    Node(n, l, r) -> l.big-leaves(length + n) && r.big-leaves(length + n)

fun do/big-leaves(t: tree): bool
  acc/big-leaves(t, 0)

fun positive-trees(t: list<tree>): bool
  match t
    Nil -> True
    Cons(t, rst) -> t.sum > 0 && rst.positive-trees

fun acc/flatten(t: tree, acc: list<int>): list<int>
  match t
    Leaf(n) -> Cons(n, acc)
    Node(n, l, r) -> l.flatten(Cons(n, r.flatten(acc)))

fun do/flatten(t: tree): list<int>
  acc/flatten(t, Nil)


fun (==)(t1: tree, t2: tree)
  match (t1, t2)
    (Leaf(n1), Leaf(n2)) -> n1 == n2
    (Node(n1, l1, r1), Node(n2, l2, r2)) -> n1 == n2 && l1 == l2 && r1 == r2
    _ -> False

fun show(t: tree): string
  match t
    Leaf(n) -> "Leaf(" ++ n.show ++ ")"
    Node(n, l, r) -> "Node(" ++ n.show ++ ", " ++ l.show ++ ", " ++ r.show ++ ")"

fun test-hw1()
  test("sum")
    check(16)
      sum(Node(10, Leaf(5), Leaf(1)))
    check(0)
      sum(Node(10, Node(-5, Leaf(-2), Leaf(-3)), Node(6, Leaf(-4), Leaf(-2))))
  
  test("negate")
    check(Node(-10, Leaf(-5), Leaf(-1)))
      negate(Node(10, Leaf(5), Leaf(1)))
    check(Node(-10, Node(5, Leaf(2), Leaf(3)), Node(-6, Leaf(4), Leaf(2))))
      negate(Node(10, Node(-5, Leaf(-2), Leaf(-3)), Node(6, Leaf(-4), Leaf(-2))))
  
  test("contains")
    check(True)
      contains(Node(10, Leaf(5), Leaf(1)), 5)
    check(False)
      contains(Node(10, Leaf(5), Leaf(1)), -1)
    
  test("big-leaves")
    check(True)
      big-leaves(Node(5, Leaf(9), Leaf(6)))
    check(False)
      big-leaves(Node(10, Leaf(5), Leaf(1)))
  
  test("positive-trees")
    check(True)
      positive-trees([Node(10, Leaf(5), Leaf(1)), Node(5, Leaf(9), Leaf(6))])
    check(False)
      positive-trees([Node(10, Leaf(5), Leaf(1)), Node(-5, Leaf(9), Leaf(-6))])
  
  test("flatten")
    check([5, 10, 1])
      flatten(Node(10, Leaf(5), Leaf(1)))
    check([-2, -5, -3, 10, -4, 6, -2])
      flatten(Node(10, Node(-5, Leaf(-2), Leaf(-3)), Node(6, Leaf(-4), Leaf(-2))))