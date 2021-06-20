import glm
import ptrutils

#===============================================================================

type Window* = ptr object

type Size* = object
  x*,y*:uint16

type State* {.pure,size:1.} = enum
  Default
  Hidden
  Minimized
  Floating
  Maximized
  Fullscreen

type OnClose* = proc(w:Window):bool #{.nimcall.}

type OnRender* = proc(w:Window) #{.nimcall.}

proc window*(
  title    = default(cstring),
  state    = default(State),
  size     = default(Size),
  center   = default(bool),
  onClose  = default(OnClose),
  onRender = default(OnRender),
):Window {.discardable.}

proc close*(w:Window):bool {.discardable.}

proc center*(w:Window)

proc `active`*(w:Window):bool

proc `size`*(w:Window):Size

proc `size=`*(w:Window, size:Size)

proc `state`*(w:Window):State

proc `state=`*(w:Window, state:State)

proc `title=`*(w:Window, title:cstring)

proc `onClose=`*(w:Window, onClose:OnClose)

proc `onRender=`*(w:Window, onRender:OnRender)

#-------------------------------------------------------------------------------

type Windows = distinct pointer

let windows* = cast[Windows](1)

# iterator items*(w:Windows):Window

proc any*(w:Windows):bool

proc len*(w:Windows):int

proc render*(w:Windows)

#===============================================================================

proc defaultOnClose(w:Window):bool = true
proc defaultOnRender(w:Window) = discard

#===============================================================================
# Windows implementation

when defined(windows):

  import api/windows/surface
  import api/windows/winapi

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

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
    hwnd     : HWND
    onClose  : OnClose
    onRender : OnRender
    surface  : Surface

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  type WindowDataPtrs = seq[ptr WindowData]

  var windowDataPtrs : WindowDataPtrs

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc asWindowData(w:Window):ptr WindowData {.inline.} =
    cast[ptr WindowData](w)

  proc asWindow(p:ptr WindowData):Window {.inline.} =
    cast[Window](p)

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `windowData`(hwnd:HWND):ptr WindowData =
    cast[ptr WindowData](GetWindowLongPtrA(hwnd, 0))

  proc `windowData=`(hwnd:HWND, p:ptr WindowData) =
    SetWindowLongPtrA(hwnd, 0, cast[uint](p))

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc renderAndPresentWindows() =
    var foregroundFullscreenWindowData : ptr WindowData = nil
    for windowData in ritems(windowDataPtrs):
      windowData.surface.clear(color=[1f,1f,1f,1f],depth=0f,stencil=0u8)
      windowData.onRender(windowData.asWindow)
      if (foregroundFullscreenWindowData == nil and
          windowData != nil and
          windowData.surface.fullscreen and
          windowData.hwnd.pointer == GetForegroundWindow().pointer):
        foregroundFullscreenWindowData = windowData
    if (foregroundFullscreenWindowData):
      # when a single window is active and fullscreen,
      # present only that window to avoid dropping out of fullscreen
      foregroundFullscreenWindowData.surface.present(vsync = true)
    else:
      # present all windows, vsync on last window presented
      for i,windowData in rpairs(windowDataPtrs):
        windowData.surface.present(vsync = i == 0)

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc wndProc(hwnd:HWND, msg:WM, wp, lp:int):int {.stdcall.} =
    case msg
      of WM_CREATE:
        let windowData = alloc WindowData(
          hwnd     : hwnd,
          onClose  : defaultOnClose,
          onRender : defaultOnRender,
        )
        windowDataPtrs.add(windowData)
        hwnd.windowData = windowData
        windowData.surface.init(hwnd)
        return 0
      of WM_DESTROY:
        let windowData = hwnd.windowData
        windowDataPtrs.delete(windowDataPtrs.find(windowData))
        dealloc windowData
        hwnd.windowData = nil
        return 0
      of WM_CLOSE:
        let windowData = hwnd.windowData
        let window = windowData.asWindow
        window.close()
        return 0
      of WM_SIZE:
        let windowData = hwnd.windowData
        windowData.surface.resize()
        return 0
      of WM_ERASEBKGND:
        return 0
      of WM_PAINT:
        renderAndPresentWindows()
        return 0
      else:
        # echo msg
        return DefWindowProcA(hwnd, msg, wp, lp)

  let wndClass = (proc():cstring =
    var wndClassExA = WNDCLASSEXA(
      cbSize        : sizeof(WNDCLASSEXA).uint32,
      style         : default(CS),#CS_HREDRAW or CS_VREDRAW,
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

  proc window(
    title    : cstring,
    state    : State,
    size     : Size,
    center   : bool,
    onClose  : OnClose,
    onRender : OnRender,
  ):Window {.discardable.} =
    let hwnd = CreateWindowExA(
      exStyle = (WS_EX_OVERLAPPEDWINDOW or
                 WS_EX_NOREDIRECTIONBITMAP), # avoid black fill during resize
      class   = wndClass,
      title   = title,
      style   = WS_OVERLAPPEDWINDOW or WS_VISIBLE,
      x       = CW_USEDEFAULT,
      y       = CW_USEDEFAULT,
      w       = 640,
      h       = 480,
    )
    let windowData = hwnd.windowData
    let window = windowData.asWindow
    block:
      window.state = state
      if (size.x > 0 and size.y > 0):
          window.size = size
      if (center):
          window.center
      window.onClose  = onClose
      window.onRender = onRender
    return window

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc close(w:Window):bool =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    if (windowData.onClose(w)):
      DestroyWindow(windowData.hwnd)
      result = true

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc center(w:Window) =
    assert(w.pointer != nil)
    discard # todo

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `active`(w:Window):bool =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    GetActiveWindow().pointer == windowData.hwnd.pointer

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `size`(w:Window):Size =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    let hwnd = windowData.hwnd
    var rect : RECT
    GetClientRect(hwnd, addr rect)
    result.x = (rect.right - rect.left).uint16
    result.y = (rect.bottom - rect.top).uint16

  proc `size=`(w:Window, size:Size) =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    let hwnd = windowData.hwnd
    var rect = RECT(left:0, top:0, right:size.x.int32, bottom:size.y.int32)
    let style = GetWindowStyle(hwnd)
    let exStyle = GetWindowExStyle(hwnd)
    AdjustWindowRectEx(addr rect, style, bMenu=false, exStyle)
    SetWindowPos(
      hwnd            = hwnd,
      hwndInsertAfter = nil.HWND,
      x               = 0i32,
      y               = 0i32,
      w               = rect.right - rect.left,
      h               = rect.bottom - rect.top,
      uFlags          = SWP_NOMOVE or SWP_NOZORDER or SWP_NOACTIVATE,
    )
    discard # todo

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `state`*(w:Window):State =
    assert(w.pointer != nil)
    discard # todo

  proc `state=`*(w:Window, state:State) =
    assert(w.pointer != nil)
    discard # todo

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `title=`*(w:Window, title:cstring) =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    let hwnd = windowData.hwnd
    SetWindowTextA(hwnd, title)

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `onClose=`*(w:Window, onClose:OnClose) =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    let onClose = onClose or defaultOnClose
    if (windowData.onClose != onClose):
        windowData.onClose = onClose

  #- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  proc `onRender=`*(w:Window, onRender:OnRender) =
    assert(w.pointer != nil)
    let windowData = w.asWindowData
    let onRender = onRender or defaultOnRender
    if (windowData.onRender != onRender):
        windowData.onRender = onRender

  #-----------------------------------------------------------------------------

  iterator items*(w:Windows):Window =
    assert(w.pointer == windows.pointer)
    for windowData in ritems(windowDataPtrs):
      yield windowData.asWindow

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
    window(
      title = $id,
      onClose = proc(w:Window):bool =
        echo "close " & $d.id
        true,
      onRender = proc(w:Window) =
        # echo "render " & $d.id
        discard
    )
  createWindow(1)
  createWindow(2)
  while windows.any:
    windows.render()