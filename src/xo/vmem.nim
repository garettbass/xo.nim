import tables
import ptrutils
import strformat
import ./span
import ./mspan

#===============================================================================

const PAGESIZE* : uint = 4096u

type Page* = array[PAGESIZE, byte]

#-------------------------------------------------------------------------------

proc pageAlign*(size:SomeInteger):uint =
  ## Round `size` up to the next multiple of `PAGESIZE`
  assert(size.uint <= (high(uint) - (PAGESIZE-1)))
  result = cast[uint]((size.uint + PAGESIZE - 1) and cast[uint](-PAGESIZE.int))
  assert(result >= size.uint)

proc pageAlign*(p:pointer):pointer =
  ## Round `p` up to the next page-aligned address
  cast[pointer](pageAlign(cast[uint](p)))

proc pageAlign*[T](p:ptr T):ptr T =
  ## Round `p` up to the next page-aligned address
  cast[ptr T](pageAlign(cast[uint](p)))

#-------------------------------------------------------------------------------

proc isPageAligned*(size:SomeInteger):bool =
  size.uint mod PAGESIZE == 0

proc isPageAligned*(p:pointer):bool =
  cast[pointer](isPageAligned(cast[uint](p)))

proc isPageAligned*[T](p:ptr T):bool =
  cast[ptr T](isPageAligned(cast[uint](p)))

#-------------------------------------------------------------------------------

proc pageTrunc*(size:SomeInteger):uint =
  ## Round `size` down to the previous multiple of `PAGESIZE`
  result = size.uint and cast[uint](-PAGESIZE.int)
  assert(result.isPageAligned)

proc pageTrunc*(p:pointer):pointer =
  ## Round `p` down to the previous page-aligned address
  cast[pointer](pageTrunc(cast[uint](p)))

proc pageTrunc*[T](p:ptr T):ptr T =
  ## Round `p` down to the previous page-aligned address
  cast[ptr T](pageTrunc(cast[uint](p)))

#-------------------------------------------------------------------------------

static:
  assert(pageAlign(0)          == 0)
  assert(pageTrunc(0)          == 0)
  assert(pageAlign(1)          == PAGESIZE)
  assert(pageTrunc(1)          == 0)
  assert(pageAlign(PAGESIZE-1) == PAGESIZE)
  assert(pageTrunc(PAGESIZE-1) == 0)
  assert(pageAlign(PAGESIZE-0) == PAGESIZE)
  assert(pageTrunc(PAGESIZE-0) == PAGESIZE)
  assert(pageAlign(PAGESIZE+1) == PAGESIZE*2)
  assert(pageTrunc(PAGESIZE+1) == PAGESIZE)

#-------------------------------------------------------------------------------

proc reserve*[T](capacity:uint):MSpan[T]

proc commit*[T](span:MSpan[T])

proc release*[T](span:MSpan[T])

#===============================================================================

type Buffer*[T] = object
  data      : MSpan[T]
  dataCount : uint32
  pageCount : uint32

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `=destroy`*[T](buf:var Buffer[T]) =
  if (buf.data.head != nil):
    vmem.release(buf.data)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# Buffer[T] is not copyable
proc `=copy`*[T](dst:var Buffer[T], src:Buffer[T]) {.error.}

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc buffer*[T](capacity:uint32):Buffer[T] =
  result.data = reserve[T](capacity.uint)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc capacity*[T](buf:Buffer[T]):uint32 =
  buf.data.len.uint32

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc len*[T](buf:Buffer[T]):uint32 =
  buf.dataCount

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

## O(1)
proc grow*[T](buf:var Buffer[T], dataCount:uint32):MSpan[T] =
  let oldLen = buf.dataCount
  let oldTailItem = addr buf.data[oldLen]
  if (dataCount > 0):
    let newLen = oldLen + dataCount
    doAssert(newLen <= buf.capacity)
    proc page[T](buf:Buffer[T], pageIndex:uint32):ptr Page =
      cast[ptr Page](buf.data.head) + pageIndex
    let newTailItem = addr buf.data[newLen]
    let oldTailPage = buf.page(buf.pageCount)
    let newTailPage = cast[ptr Page](pageAlign(newTailItem))
    if (newTailPage > oldTailPage):
      # commit additional pages
      commit(mspan(oldTailPage, newTailPage))
      buf.pageCount = (newTailPage - buf.page(0)).uint32
    buf.dataCount = newLen
    result = mspan(oldTailItem, newTailItem)
  else:
    result = mspan(oldTailItem, oldTailItem)

## O(1)
proc grow*[T](buf:var Buffer[T]):ptr T =
  grow(buf, dataCount=1).head

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc head*[T](buf:Buffer[T]):ptr T =
  buf.data.head

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc tail*[T](buf:Buffer[T]):ptr T =
  buf.data.head + buf.dataCount

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `[]`*[T;I:SomeInteger](buf:Buffer[T], i:I):var T =
  assert(i.uint < buf.dataCount.uint)
  buf.data[i]

proc `[]=`*[T;I:SomeInteger](buf:Buffer[T], i:I, t:T) =
  (addr buf[i])[] = t

#===============================================================================

when defined(windows):

  const MEM_COMMIT  = 0x00001000u32
  const MEM_RESERVE = 0x00002000u32
  const MEM_RELEASE = 0x00008000u32

  const PAGE_NOACCESS  = 0x01u32
  const PAGE_READWRITE = 0x04u32

  proc VirtualAlloc(lpAddress:pointer, dwSize:uint, flAllocationType:uint32, flProtect:uint32):pointer {.stdcall,importc,discardable.}
  proc VirtualFree(lpAddress:pointer, dwSize:uint, dwFreeType:uint32):int32 {.stdcall,importc,discardable.}

  proc reserve[T](capacity:uint):MSpan[T] =
    let size = pageAlign(capacity * sizeof(T).uint)
    let head = VirtualAlloc(nil, size + PAGESIZE, MEM_RESERVE, PAGE_NOACCESS);
    echo &"VirtualAlloc(size:{size}):{head}"
    assert(head != nil)
    assert(head.isPageAligned)
    assert(size.isPageAligned)
    let p = cast[ptr T](head)
    let n = size.uint div sizeof(T).uint
    result = mspan[T](p, n)

  proc commit[T](span:MSpan[T]) =
    assert(span.head != nil)
    assert(span.tail != nil)
    var head = pageTrunc(span.head).pointer
    let tail = pageAlign(span.tail).pointer
    let size = tail - head
    head = VirtualAlloc(head, size.uint, MEM_COMMIT, PAGE_READWRITE)
    assert(head != nil)
    assert(head.isPageAligned)

  proc release[T](span:MSpan[T])=
    assert(span.head != nil)
    assert(span.tail != nil)
    let head = pageTrunc(span.head).pointer
    let tail = pageAlign(span.tail).pointer
    let size = tail - head
    let freed = VirtualFree(head, 0, MEM_RELEASE) != 0
    echo &"VirtualFree(size:{size}, {head}):{freed}"

#===============================================================================

else: {.error:"unsupported platform".}

#===============================================================================
