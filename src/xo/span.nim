import ptrutils

type Span*[T] = object
  head, tail : ptr T

proc span*(p, q: pointer):Span[byte] =
  Span[byte](head:cast[ptr byte](min(p,q)), tail:cast[ptr byte](max(p,q)))

proc span*[T](p, q:ptr T):Span[T] =
  Span[T](head:min(p,q), tail:max(p,q))

proc span*[T](p:ptr T, n:int):Span[T] =
  let q : ptr T = p + n
  Span[T](head:min(p,q), tail:max(p,q))

proc span*[T](a:varargs[T]):Span[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  Span[T](head:p, tail:p + a.len)

converter span*[T](a:openarray[T]):Span[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  Span[T](head:p, tail:p + a.len)

converter span*[N:static[int],T](a:array[N,T]):Span[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  Span[T](head:p, tail:p + a.len)

converter span*[T](a:seq[T]):Span[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  Span[T](head:p, tail:p + a.len)

proc `[]`*[T;I:SomeInteger](s:Span[T], i:I):T =
  let q = s.head + i
  assert(q >= s.head)
  assert(q <  s.tail)
  result = q[]

proc bytes*[T](s:Span[T]):Span[byte] =
  span(s.head.pointer, s.tail.pointer)

proc len*[T](s:Span[T]):int =
  s.tail - s.head

iterator items*[T](s:Span[T]):T =
  var p = s.head
  while p < s.tail:
    yield p[]
    p = p + 1

iterator pairs*[T](s:Span[T]):(int,T) =
  var i = 0
  var p = s.head
  while p < s.tail:
    yield (i, p[])
    i = i + 1
    p = p + 1

proc pull*[T](s:var Span[T]):T =
  ## remove the first element from the span
  if s.head < s.tail:
    result = s.head[0]
    s.head += 1

proc pop*[T](s:var Span[T]):T =
  ## remove the last element from the span
  if s.head < s.tail:
    result = s.tail[-1]
    s.tail -= 1

proc collectionToString[T](x: T, prefix, separator, suffix: string): string =
  result = prefix
  var firstElement = true
  for value in items(x):
    if firstElement:
      firstElement = false
    else:
      result.add(separator)

    when value isnot string and value isnot seq and compiles(value.isNil):
      # this branch should not be necessary
      if value.isNil:
        result.add "nil"
      else:
        result.addQuoted(value)
    else:
      result.addQuoted(value)
  result.add(suffix)

proc `$`*[T](s:Span[T]):string =
  collectionToString(s, "[", ", ", "]")

proc `head`*[T](s:Span[T]):ptr T = s.head

proc `tail`*[T](s:Span[T]):ptr T = s.tail

when isMainModule:
  var a = [1, 2, 3]
  var s = span[int](a)
  assert(a[0] == 1); assert(s[0] == 1)
  assert(a[1] == 2); assert(s[1] == 2)
  assert(a[2] == 3); assert(s[2] == 3)

  echo $span[var int]([1, 2, 3])
  echo $[1,2,3]
  echo $span(@[4, 5, 6])