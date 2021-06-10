import glm
import ptrutils

#===============================================================================

type Window* = ptr object

type Size* = Vec2[uint16]

type State* {.pure,size:1.} = enum
  Default
  Hidden
  Minimized
  Floating
  Maximized
  Fullscreen

type Close* = proc(w:Window):bool #{.nimcall.}

type Render* = proc(w:Window) #{.nimcall.}

proc open*(
  title   = default(cstring),
  state   = default(State),
  size    = default(Size),
  center  = default(bool),
  close   = default(Close),
  render  = default(Render),
):Window {.discardable.}

proc close*(w:Window):bool {.discardable.}

proc center*(w:Window)

proc `size`*(w:Window):Size

proc `size=`*(w:Window, size:Size)

proc `state`*(w:Window):State

proc `state=`*(w:Window, state:State)

proc `title=`*(w:Window, title:cstring)

proc `close=`*(w:Window, close:Close)

proc `render=`*(w:Window, render:Render)

#-------------------------------------------------------------------------------

type Windows = distinct pointer

let windows* = cast[Windows](1)

# iterator items*(w:Windows):Window

proc any*(w:Windows):bool

proc len*(w:Windows):int

proc render*(w:Windows)

#===============================================================================
# Windows implementation

when defined(windows):

  import api/windows/surface
  import api/windows/winapi

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc defaultClose(w:Window):bool = true

  proc defaultRender(w:Window) = discard

  proc `or`[T](a,b:T):T = (if (a != nil): a else: b)

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  iterator rpairs[T](a:openarray[T]):tuple[key:int,val:T] {.inline.} =
    var i = len(a)
    while (dec(i); i >= 0):
      yield (i, a[i])

  iterator ritems[T](a:openarray[T]):T {.inline.} =
    var i = len(a)
    while (dec(i); i >= 0):
      yield a[i]

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  type WindowData = object
    hwnd    : HWND
    close   : Close
    render  : Render
    surface : Surface

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  type WindowDataPtrs = seq[ptr WindowData]

  var windowDataPtrs : WindowDataPtrs

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc asWin32Window(w:Window):ptr WindowData =
    cast[ptr WindowData](w)

  proc asWindow(p:ptr WindowData):Window =
    cast[Window](p)

  proc asWindow(p:ref WindowData):Window =
    cast[Window](p)

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `windowData`(hwnd:HWND):ptr WindowData =
    cast[ptr WindowData](GetWindowLongPtrA(hwnd, 0))

  proc `windowData=`(hwnd:HWND, p:ptr WindowData) =
    SetWindowLongPtrA(hwnd, 0, cast[uint](p))

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc render() =
    for windowDataPtr in ritems(windowDataPtrs):
      windowDataPtr.surface.clear(color=[1f,1f,1f,1f],depth=0f,stencil=0u8)
      windowDataPtr.render(windowDataPtr.asWindow)
    for i,windowDataPtr in rpairs(windowDataPtrs):
      windowDataPtr.surface.present(vsync = i == 0)

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc wndProc(hwnd:HWND, msg:WM, wp, lp:int):int {.stdcall.} =
    case msg
      of WM_DESTROY:
        let windowData = hwnd.windowData
        assert(windowData != nil)
        windowDataPtrs.delete(windowDataPtrs.find(windowData))
        dealloc(windowData)
        hwnd.windowData = nil
      of WM_CLOSE:
        let windowData = hwnd.windowData
        let window = windowData.asWindow
        window.close()
        return 0
      of WM_SIZE:
        let windowData = hwnd.windowData
        if (windowData):
            # WM_SIZE is invoked during CreateWindowExA()
            windowData.surface.resize()
      of WM_ERASEBKGND:
        return 0 # do nothing
      of WM_PAINT:
        render() # render ALL windows
        return 0
      else: discard
    return DefWindowProcA(hwnd, msg, wp, lp)

  let wndClass = (proc():cstring =
    var wndClassExA = WNDCLASSEXA(
      cbSize        : sizeof(WNDCLASSEXA).uint32,
      style         : CS_HREDRAW or CS_VREDRAW,
      lpfnWndProc   : wndProc,
      cbClsExtra    : 0,
      cbWndExtra    : sizeof(ptr WindowData).uint32,
      hInstance     : nil,
      hIcon         : LoadIconA(nil, IDI_APPLICATION),
      hCursor       : LoadCursorA(nil, IDC_ARROW),
      hbrBackground : nil,
      lpszMenuName  : nil,
      lpszClassName : "xo.window.WindowData",
      hIconSm       : LoadIconA(nil, IDI_APPLICATION))
    let wndClassAtom = RegisterClassExA(addr wndClassExA)
    assert(wndClassAtom != 0)
    MAKEINTRESOURCE(wndClassAtom)
  )()

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc open*(
    title  : cstring,
    state  : State,
    size   : Size,
    center : bool,
    close  : Close,
    render : Render,
  ):Window {.discardable.} =
    let hwnd = CreateWindowExA(
      stylex = WS_EX_OVERLAPPEDWINDOW,
      class  = wndClass,
      title  = title,
      style  = WS_OVERLAPPEDWINDOW or WS_VISIBLE,
      x      = CW_USEDEFAULT,
      y      = CW_USEDEFAULT,
      w      = 640,
      h      = 480,
    )
    let windowData = alloc WindowData(
      hwnd   : hwnd,
      close  : defaultClose,
      render : defaultRender,
    )
    windowDataPtrs.add(windowData)
    hwnd.windowData = windowData
    windowData.surface.init(hwnd)
    let window = windowData.asWindow
    block:
      window.title = title
      window.state = state
      if (size.x > 0 and size.y > 0):
          window.size = size
      if (center):
          window.center
      window.close = close
      window.render = render
    return window

  proc close*(w:Window):bool =
    assert(w.pointer != nil)
    let windowData = w.asWin32Window
    if (windowData.close(w)):
      DestroyWindow(windowData.hwnd)
      result = true

  proc center*(w:Window) =
    assert(w.pointer != nil)
    discard # todo

  proc `size`*(w:Window):Size =
    assert(w.pointer != nil)
    discard # todo

  proc `size=`*(w:Window, size:Size) =
    assert(w.pointer != nil)
    discard # todo

  proc `state`*(w:Window):State =
    assert(w.pointer != nil)
    discard # todo

  proc `state=`*(w:Window, state:State) =
    assert(w.pointer != nil)
    discard # todo

  proc `title=`*(w:Window, title:cstring) =
    assert(w.pointer != nil)
    discard # todo

  proc `close=`*(w:Window, close:Close) =
    assert(w.pointer != nil)
    let windowData = w.asWin32Window
    let close = close or defaultClose
    if (windowData.close != close):
        windowData.close = close

  proc `render=`*(w:Window, render:Render) =
    assert(w.pointer != nil)
    let windowData = w.asWin32Window
    let render = render or defaultRender
    if (windowData.render != render):
        windowData.render = render

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  iterator items*(w:Windows):Window =
    assert(w.pointer == windows.pointer)
    for windowDataPtr in ritems(windowDataPtrs):
      yield windowDataPtr.asWindow

  proc any*(w:Windows):bool =
    assert(w.pointer == windows.pointer)
    return windowDataPtrs.len > 0

  proc len*(w:Windows):int =
    assert(w.pointer == windows.pointer)
    return windowDataPtrs.len

  proc render*(w:Windows) =
    assert(w.pointer == windows.pointer)
    var msg : MSG
    while PeekMessageA(addr msg, nil, WM_NULL, WM_NULL, PM_REMOVE):
      TranslateMessage(addr msg)
      DispatchMessageA(addr msg)
      if (msg.message == WM_PAINT):
        # The system sends this message when there are no other
        # messages in the application's message queue. - MSDN
        break

#===============================================================================

else: {.error:"unsupported platform".}

#===============================================================================

when isMainModule:
  import strformat

  type Destructible = object
    id : int

  proc `=destroy`(d:var Destructible)=
    echo &"`=destroy`({d.id=})"
    d.id = 0

  proc `=copy`(d:var Destructible, s:Destructible) {.error.}

  proc newDestructible(id:int):ref Destructible=
    new result
    result.id = id

  proc createWindow(id:int) =
    let d = newDestructible(id)
    window.open(
      title = $id,
      close = proc(w:Window):bool =
        echo "close " & $d.id
        true,
      render = proc(w:Window) =
        # echo "render " & $d.id
        discard
    )
  createWindow(1)
  createWindow(2)
  while windows.any:
    windows.render()