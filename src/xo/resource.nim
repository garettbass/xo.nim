import ptrutils
import mspan
import span
import vmem

#===============================================================================

type Id*[T] = object
  issue {.align:4.}, index : uint16

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `nil`*(t:typedesc[Id]):Id = Id()

proc `u32`*(id:Id):uint32 = cast[uint32](id)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `isEven`(n:SomeInteger):bool = n.uint mod 2u == 0u

proc `isOdd`(n:SomeInteger):bool = n.uint mod 2u == 1u

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

template `isFree`(n:SomeInteger):bool = n.isEven

template `isLive`(n:SomeInteger):bool = n.isOdd

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

template `isFree`(id:Id):bool = id.issue.isEven

template `isLive`(id:Id):bool = id.issue.isOdd

#===============================================================================

type FreeList[T] = object
  head : ptr T
  len  : uint

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc push[T](f:var FreeList[T], p:ptr T)=
  assert(p != nil)
  p.next = f.head
  f.head = p
  f.len.inc

## O(1)
proc push[T](f:var FreeList[T], t:var T)=
  push(f, addr t)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc pop[T](f:var FreeList[T]):ptr T=
  result = f.head
  if (f.len > 0):
    f.head = result.next
    f.len.dec
  else:
    assert(result == nil)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

iterator items[T](f:FreeList[T]):T=
  var q = f.head
  while (q != nil):
    yield q[]
    q = q.next

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

when isMainModule:
  import strformat
  type Node = object
    index:uint
    next:ptr Node
  var nodes = [Node(index:0),Node(index:1),Node(index:2),Node(index:3)]
  var free : FreeList[Node]
  free.push(nodes[0])
  free.push(nodes[1])
  free.push(nodes[2])
  free.push(nodes[3])
  assert(free.len == 4)
  for p in free:
    echo &"{p.index=}"
  assert(free.pop == addr nodes[3])
  assert(free.pop == addr nodes[2])
  assert(free.pop == addr nodes[1])
  assert(free.pop == addr nodes[0])
  assert(free.pop == nil)

#===============================================================================

type
  SparsePoolNode[T] {.union.} = object
    next : ptr SparsePoolNode[T]
    data : T

#===============================================================================

type SparsePool*[T] = object
  issues    : Buffer[uint16]
  entries   : Buffer[SparsePoolNode[T]]
  freeList  : FreeList[SparsePoolNode[T]]
  liveCount : uint32

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc sparsePool*[T](capacity:uint16 = high(uint16)):SparsePool[T] =
  result.issues  = vmem.buffer[uint16](capacity)
  result.entries = vmem.buffer[SparsePoolNode[T]](capacity)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc capacity*[T](pool:SparsePool[T]):uint32 =
  pool.entries.capacity

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc len*[T](pool:SparsePool[T]):uint32 =
  pool.liveCount

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc add*[T](pool:var SparsePool[T], data:T):Id[T] =
  var entry = pool.freeList.pop()
  if (entry == nil):
    pool.issues.grow()[] = 0
    entry = pool.entries.grow()
  let index = entry - pool.entries.head
  var issue = pool.issues[index]
  assert(issue.isFree)
  issue.inc
  pool.issues[index] = issue
  assert(issue.isLive)
  entry.data = data
  assert(index < high(uint16).int)
  assert(index.uint32 < pool.entries.len)
  result.index = index.uint16
  result.issue = issue
  pool.liveCount.inc

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc del*[T](pool:var SparsePool[T], id:Id[T]) =
  let index = id.index
  var issue = pool.issues[index]
  doAssert(id.isLive, &"invalid id: {id}")
  doAssert(id.issue == issue, &"invalid id: {id}")
  let entry = addr pool.entries[index]
  assert(entry < pool.entries.tail)
  reset(entry.data)
  assert(issue.isLive)
  issue.inc
  pool.issues[index] = issue
  assert(issue.isFree)
  pool.freeList.push(entry)
  pool.liveCount.dec

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc `[]`*[T](pool:SparsePool[T], id:Id[T]):var T =
  let index = id.index
  var issue = pool.issues[index]
  doAssert(id.isLive, &"invalid id: {id}")
  doAssert(id.issue == issue, &"invalid id: {id}")
  let entry = addr pool.entries[index]
  assert(entry < pool.entries.tail)
  entry.data

proc `[]=`*[T](pool:SparsePool[T], id:Id[T], t:T) =
  (addr pool[id])[] = t

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc contains*[T](pool:SparsePool[T], id:Id[T]):bool =
  if (id.isLive):
    let entry = pool.entries.head + id.index
    (entry < pool.entries.tail) and # entry in reserved span
    (entry < pool.nextEntry) and # entry in committed span
    (entry.isLive) and
    (id.issue == entry.issue)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

iterator items*[T](pool:SparsePool[T]):T =
  var count = 0u
  var index = 0u16
  var issue = addr pool.issues[index]
  var entry = addr pool.entries[index]
  while (count < pool.liveCount):
    if (issue[].isLive):
      yield entry.data
      count.inc
    index.inc
    issue.inc
    entry.inc

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

iterator mitems*[T](pool:SparsePool[T]):var T =
  var count = 0u
  var index = 0u16
  var issue = addr pool.issues[index]
  var entry = addr pool.entries[index]
  while (count < pool.liveCount):
    if (issue[].isLive):
      yield entry.data
      count.inc
    index.inc
    issue.inc
    entry.inc

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

iterator mpairs*[T](pool:SparsePool[T]):(Id[T],var T) =
  var count = 0u
  var index = 0u16
  var issue = addr pool.issues[index]
  var entry = addr pool.entries[index]
  while (count < pool.liveCount):
    if (issue[].isLive):
      let id = Id[T](index:index, issue:issue[])
      yield (id, entry.data)
      count.inc
    index.inc
    issue.inc
    entry.inc

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

iterator pairs*[T](pool:SparsePool[T]):(Id[T],T) =
  var count = 0u
  var index = 0u16
  var issue = addr pool.issues[index]
  var entry = addr pool.entries[index]
  while (count < pool.liveCount):
    if (issue[].isLive):
      let id = Id[T](index:index, issue:issue[])
      yield (id, entry.data)
      count.inc
    index.inc
    issue.inc
    entry.inc

#===============================================================================

when isMainModule:
  import ./sugar
  echo &"{((1 == 2) ? ('t','f'))=}"
  type Data = object
    next : pointer
    data : uint
  echo &"{sizeof(Data)=}, {alignof(Data)=}"
  echo &"{sizeof(SparsePoolNode[Data])=}, {alignof(SparsePoolNode[Data])=}"
  var dataPool = sparsePool[Data](1024)
  echo &"{dataPool.capacity=}"
  let id0 = dataPool.add(Data(data:0))
  let id1 = dataPool.add(Data(data:1))
  echo &"{dataPool.len=}, {dataPool.entries.len=}"
  for k,v in dataPool.pairs:
    echo &"{k}:{v}"
  dataPool.del(id0)
  echo &"{dataPool.len=}, {dataPool.freeList.len=}"
  for v in dataPool.freeList.items:
    echo &"{v}"
  for k,v in dataPool.pairs:
    echo &"{k}:{v}"
  let id2 = dataPool.add(Data(data:2))
  echo &"{dataPool.len=}, {dataPool.entries.len=}"
  for k,v in dataPool.pairs:
    echo &"{k}:{v}"
  dataPool.del(id2)
  dataPool.del(id1)
  echo &"{dataPool.len=}, {dataPool.entries.len=}"
  for v in dataPool.freeList.items:
    echo &"{v}"

#===============================================================================
