import ptrutils

type MSpan*[T] = object
  head, tail : ptr T

proc mspan*(p, q: pointer):MSpan[byte] =
  MSpan[byte](head:cast[ptr byte](min(p,q)), tail:cast[ptr byte](max(p,q)))

proc mspan*[T](p, q:ptr T):MSpan[T] =
  MSpan[T](head:min(p,q), tail:max(p,q))

proc mspan*[T](p:ptr T, n:int):MSpan[T] =
  let q : ptr T = p + n
  MSpan[T](head:min(p,q), tail:max(p,q))

converter mspan*[T](a:openarray[T]):MSpan[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  MSpan[T](head:p, tail:p + a.len)

converter mspan*[N:static[int],T](a:array[N,T]):MSpan[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  MSpan[T](head:p, tail:p + a.len)

converter mspan*[T](a:seq[T]):MSpan[T] =
  let p : ptr T = unsafeaddr system.`[]`(a,0)
  MSpan[T](head:p, tail:p + a.len)

proc `[]`*[T;I:SomeInteger](s:MSpan[T], i:I):var T =
  let q = s.head + i
  assert(q >= s.head)
  assert(q <  s.tail)
  result = q[]

proc len*[T](s:MSpan[T]):int =
  s.tail - s.head

iterator items*[T](s:MSpan[T]):T =
  var p = s.head
  while p < s.tail:
    yield p[]
    p = p + 1

iterator pairs*[T](s:MSpan[T]):(int,T) =
  var i = 0
  var p = s.head
  while p < s.tail:
    yield (i, p[])
    i = i + 1
    p = p + 1

iterator mitems*[T](s:MSpan[T]):var T =
  var p = s.head
  while p < s.tail:
    yield p[]
    p = p + 1

iterator mpairs*[T](s:MSpan[T]):(int,var T) =
  var i = 0
  var p = s.head
  while p < s.tail:
    yield (i, p[])
    i = i + 1
    p = p + 1

proc pull*[T](s:var MSpan[T]):var T =
  ## remove the first element from the span
  if s.head < s.tail:
    result = s.head[0]
    s.head += 1

proc pop*[T](s:var MSpan[T]):var T =
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

proc `$`*[T](s:MSpan[T]):string =
  collectionToString(s, "[", ", ", "]")

when isMainModule:
  var a = [1, 2, 3]
  var s = mspan[int](a)
  s[0] += 1
  s[1] += 1
  s[2] += 1
  assert(a[0] == 2); assert(s[0] == 2)
  assert(a[1] == 3); assert(s[1] == 3)
  assert(a[2] == 4); assert(s[2] == 4)

  for v in mitems(s):
    v += 1
  assert(a[0] == 3); assert(s[0] == 3)
  assert(a[1] == 4); assert(s[1] == 4)
  assert(a[2] == 5); assert(s[2] == 5)

  echo $mspan[var int]([1, 2, 3])
  echo $[1,2,3]
  echo $mspan(@[4, 5, 6])