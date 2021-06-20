type BOOL* {.size:4.} = enum
  FALSE
  TRUE
converter toBOOL*(b:bool):BOOL = b.BOOL
converter tobool*(b:BOOL):bool = b != FALSE

#-------------------------------------------------------------------------------

template MAKEINTRESOURCE*(i:untyped): untyped = cast[cstring](i and 0xffff)

template MAKEWORD*(a: untyped, b: untyped): uint16 = uint16((b and 0xff) shl 8) or uint16(a and 0xff)
template MAKELONG*(a: untyped, b: untyped): uint32 = cast[uint32](b shl 16) or uint32(a and 0xffff)

template LOWORD*(l: untyped): uint16 = uint16(l and 0xffff)
template HIWORD*(l: untyped): uint16 = uint16((l shr 16) and 0xffff)

template LOBYTE*(w: untyped): uint8 = uint8(w and 0xff)
template HIBYTE*(w: untyped): uint8 = uint8((w shr 8) and 0xff)

#-------------------------------------------------------------------------------

type CS* {.size:4.} = enum
  CS_VREDRAW         = 0x00000001
  CS_HREDRAW         = 0x00000002
  CS_DBLCLKS         = 0x00000008
  CS_OWNDC           = 0x00000020
  CS_CLASSDC         = 0x00000040
  CS_PARENTDC        = 0x00000080
  CS_NOCLOSE         = 0x00000200
  CS_SAVEBITS        = 0x00000800
  CS_BYTEALIGNCLIENT = 0x00001000
  CS_BYTEALIGNWINDOW = 0x00002000
  CS_GLOBALCLASS     = 0x00004000
  CS_IME             = 0x00010000
  CS_DROPSHADOW      = 0x00020000

proc `or`*(a,b:CS):CS = CS(a.uint or b.uint)

#-------------------------------------------------------------------------------

const CW_USEDEFAULT* = cast[int32](0x80000000)

#-------------------------------------------------------------------------------

type HANDLE*    = distinct pointer
type HBRUSH*    = distinct pointer
type HCURSOR*   = distinct pointer
type HDC*       = distinct pointer
type HICON*     = distinct pointer
type HINSTANCE* = distinct pointer
type HMENU*     = distinct pointer
type HMODULE*   = distinct pointer
type HMONITOR*  = distinct pointer
type HWND*      = distinct pointer

#-------------------------------------------------------------------------------

type HRESULT* = int32

#-------------------------------------------------------------------------------

const
  IDC_ARROW*       = MAKEINTRESOURCE(32512)
  IDC_IBEAM*       = MAKEINTRESOURCE(32513)
  IDC_WAIT*        = MAKEINTRESOURCE(32514)
  IDC_CROSS*       = MAKEINTRESOURCE(32515)
  IDC_UPARROW*     = MAKEINTRESOURCE(32516)
  IDC_SIZE*        = MAKEINTRESOURCE(32640)
  IDC_ICON*        = MAKEINTRESOURCE(32641)
  IDC_SIZENWSE*    = MAKEINTRESOURCE(32642)
  IDC_SIZENESW*    = MAKEINTRESOURCE(32643)
  IDC_SIZEWE*      = MAKEINTRESOURCE(32644)
  IDC_SIZENS*      = MAKEINTRESOURCE(32645)
  IDC_SIZEALL*     = MAKEINTRESOURCE(32646)
  IDC_NO*          = MAKEINTRESOURCE(32648)
  IDC_HAND*        = MAKEINTRESOURCE(32649)
  IDC_APPSTARTING* = MAKEINTRESOURCE(32650)
  IDC_HELP*        = MAKEINTRESOURCE(32651)

#-------------------------------------------------------------------------------

const
  IDI_APPLICATION* = MAKEINTRESOURCE(32512)
  IDI_HAND*        = MAKEINTRESOURCE(32513)
  IDI_QUESTION*    = MAKEINTRESOURCE(32514)
  IDI_EXCLAMATION* = MAKEINTRESOURCE(32515)
  IDI_ASTERISK*    = MAKEINTRESOURCE(32516)
  IDI_WINLOGO*     = MAKEINTRESOURCE(32517)
  IDI_SHIELD*      = MAKEINTRESOURCE(32518)
  IDI_WARNING*     = IDI_EXCLAMATION
  IDI_ERROR*       = IDI_HAND
  IDI_INFORMATION* = IDI_ASTERISK

#-------------------------------------------------------------------------------

type WCHAR*   = uint16
type LPCWSTR* = ptr UncheckedArray[WCHAR]
type LPWSTR*  = ptr UncheckedArray[WCHAR]

#-------------------------------------------------------------------------------

type PM* {.size:4.} = enum
  PM_NOREMOVE = 0x0000
  PM_REMOVE   = 0x0001
  PM_NOYIELD  = 0x0002

#-------------------------------------------------------------------------------

const
  GWLP_USERDATA*   : int32 = -21
  GWLP_EXSTYLE*    : int32 = -20
  GWLP_STYLE*      : int32 = -16
  GWLP_ID*         : int32 = -12
  GWLP_HWNDPARENT* : int32 = -8
  GWLP_HINSTANCE*  : int32 = -6
  GWLP_WNDPROC*    : int32 = -4

#-------------------------------------------------------------------------------

type SWP* {.size:4.} = enum
  SWP_NOSIZE         = 0x0001
  SWP_NOMOVE         = 0x0002
  SWP_NOZORDER       = 0x0004
  SWP_NOREDRAW       = 0x0008
  SWP_NOACTIVATE     = 0x0010
  SWP_FRAMECHANGED   = 0x0020
  SWP_SHOWWINDOW     = 0x0040
  SWP_HIDEWINDOW     = 0x0080
  SWP_NOCOPYBITS     = 0x0100
  SWP_NOOWNERZORDER  = 0x0200
  SWP_NOSENDCHANGING = 0x0400
  SWP_DEFERERASE     = 0x2000
  SWP_ASYNCWINDOWPOS = 0x4000
const
  SWP_DRAWFRAME*    = SWP_FRAMECHANGED
  SWP_NOREPOSITION* = SWP_NOOWNERZORDER

proc `or`*(a,b:SWP):SWP = SWP(a.uint or b.uint)

#-------------------------------------------------------------------------------

type WM* {.size:4.} = enum
  WM_NULL                           = 0x0000
  WM_CREATE                         = 0x0001
  WM_DESTROY                        = 0x0002
  WM_MOVE                           = 0x0003
  WM_SIZE                           = 0x0005
  WM_ACTIVATE                       = 0x0006
  WM_SETFOCUS                       = 0x0007
  WM_KILLFOCUS                      = 0x0008
  WM_ENABLE                         = 0x000A
  WM_SETREDRAW                      = 0x000B
  WM_SETTEXT                        = 0x000C
  WM_GETTEXT                        = 0x000D
  WM_GETTEXTLENGTH                  = 0x000E
  WM_PAINT                          = 0x000F
  WM_CLOSE                          = 0x0010
  WM_QUERYENDSESSION                = 0x0011
  WM_QUIT                           = 0x0012
  WM_QUERYOPEN                      = 0x0013
  WM_ERASEBKGND                     = 0x0014
  WM_SYSCOLORCHANGE                 = 0x0015
  WM_ENDSESSION                     = 0x0016
  WM_SHOWWINDOW                     = 0x0018
  WM_WININICHANGE                   = 0x001A
  WM_DEVMODECHANGE                  = 0x001B
  WM_ACTIVATEAPP                    = 0x001C
  WM_FONTCHANGE                     = 0x001D
  WM_TIMECHANGE                     = 0x001E
  WM_CANCELMODE                     = 0x001F
  WM_SETCURSOR                      = 0x0020
  WM_MOUSEACTIVATE                  = 0x0021
  WM_CHILDACTIVATE                  = 0x0022
  WM_QUEUESYNC                      = 0x0023
  WM_GETMINMAXINFO                  = 0x0024
  WM_PAINTICON                      = 0x0026
  WM_ICONERASEBKGND                 = 0x0027
  WM_NEXTDLGCTL                     = 0x0028
  WM_SPOOLERSTATUS                  = 0x002A
  WM_DRAWITEM                       = 0x002B
  WM_MEASUREITEM                    = 0x002C
  WM_DELETEITEM                     = 0x002D
  WM_VKEYTOITEM                     = 0x002E
  WM_CHARTOITEM                     = 0x002F
  WM_SETFONT                        = 0x0030
  WM_GETFONT                        = 0x0031
  WM_SETHOTKEY                      = 0x0032
  WM_GETHOTKEY                      = 0x0033
  WM_QUERYDRAGICON                  = 0x0037
  WM_COMPAREITEM                    = 0x0039
  WM_GETOBJECT                      = 0x003D
  WM_COMPACTING                     = 0x0041
  WM_COMMNOTIFY                     = 0x0044
  WM_WINDOWPOSCHANGING              = 0x0046
  WM_WINDOWPOSCHANGED               = 0x0047
  WM_POWER                          = 0x0048
  WM_COPYDATA                       = 0x004A
  WM_CANCELJOURNAL                  = 0x004B
  WM_NOTIFY                         = 0x004E
  WM_INPUTLANGCHANGEREQUEST         = 0x0050
  WM_INPUTLANGCHANGE                = 0x0051
  WM_TCARD                          = 0x0052
  WM_HELP                           = 0x0053
  WM_USERCHANGED                    = 0x0054
  WM_NOTIFYFORMAT                   = 0x0055
  WM_CONTEXTMENU                    = 0x007B
  WM_STYLECHANGING                  = 0x007C
  WM_STYLECHANGED                   = 0x007D
  WM_DISPLAYCHANGE                  = 0x007E
  WM_GETICON                        = 0x007F
  WM_SETICON                        = 0x0080
  WM_NCCREATE                       = 0x0081
  WM_NCDESTROY                      = 0x0082
  WM_NCCALCSIZE                     = 0x0083
  WM_NCHITTEST                      = 0x0084
  WM_NCPAINT                        = 0x0085
  WM_NCACTIVATE                     = 0x0086
  WM_GETDLGCODE                     = 0x0087
  WM_SYNCPAINT                      = 0x0088
  WM_NCMOUSEMOVE                    = 0x00A0
  WM_NCLBUTTONDOWN                  = 0x00A1
  WM_NCLBUTTONUP                    = 0x00A2
  WM_NCLBUTTONDBLCLK                = 0x00A3
  WM_NCRBUTTONDOWN                  = 0x00A4
  WM_NCRBUTTONUP                    = 0x00A5
  WM_NCRBUTTONDBLCLK                = 0x00A6
  WM_NCMBUTTONDOWN                  = 0x00A7
  WM_NCMBUTTONUP                    = 0x00A8
  WM_NCMBUTTONDBLCLK                = 0x00A9
  WM_NCXBUTTONDOWN                  = 0x00AB
  WM_NCXBUTTONUP                    = 0x00AC
  WM_NCXBUTTONDBLCLK                = 0x00AD
  WM_INPUT_DEVICE_CHANGE            = 0x00FE
  WM_INPUT                          = 0x00FF
  WM_KEYDOWN                        = 0x0100
  WM_KEYUP                          = 0x0101
  WM_CHAR                           = 0x0102
  WM_DEADCHAR                       = 0x0103
  WM_SYSKEYDOWN                     = 0x0104
  WM_SYSKEYUP                       = 0x0105
  WM_SYSCHAR                        = 0x0106
  WM_SYSDEADCHAR                    = 0x0107
  WM_UNICHAR                        = 0x0109
  WM_IME_STARTCOMPOSITION           = 0x010D
  WM_IME_ENDCOMPOSITION             = 0x010E
  WM_IME_COMPOSITION                = 0x010F
  WM_INITDIALOG                     = 0x0110
  WM_COMMAND                        = 0x0111
  WM_SYSCOMMAND                     = 0x0112
  WM_TIMER                          = 0x0113
  WM_HSCROLL                        = 0x0114
  WM_VSCROLL                        = 0x0115
  WM_INITMENU                       = 0x0116
  WM_INITMENUPOPUP                  = 0x0117
  WM_GESTURE                        = 0x0119
  WM_GESTURENOTIFY                  = 0x011A
  WM_MENUSELECT                     = 0x011F
  WM_MENUCHAR                       = 0x0120
  WM_ENTERIDLE                      = 0x0121
  WM_MENURBUTTONUP                  = 0x0122
  WM_MENUDRAG                       = 0x0123
  WM_MENUGETOBJECT                  = 0x0124
  WM_UNINITMENUPOPUP                = 0x0125
  WM_MENUCOMMAND                    = 0x0126
  WM_CHANGEUISTATE                  = 0x0127
  WM_UPDATEUISTATE                  = 0x0128
  WM_QUERYUISTATE                   = 0x0129
  WM_CTLCOLORMSGBOX                 = 0x0132
  WM_CTLCOLOREDIT                   = 0x0133
  WM_CTLCOLORLISTBOX                = 0x0134
  WM_CTLCOLORBTN                    = 0x0135
  WM_CTLCOLORDLG                    = 0x0136
  WM_CTLCOLORSCROLLBAR              = 0x0137
  WM_CTLCOLORSTATIC                 = 0x0138
  WM_MOUSEMOVE                      = 0x0200
  WM_LBUTTONDOWN                    = 0x0201
  WM_LBUTTONUP                      = 0x0202
  WM_LBUTTONDBLCLK                  = 0x0203
  WM_RBUTTONDOWN                    = 0x0204
  WM_RBUTTONUP                      = 0x0205
  WM_RBUTTONDBLCLK                  = 0x0206
  WM_MBUTTONDOWN                    = 0x0207
  WM_MBUTTONUP                      = 0x0208
  WM_MBUTTONDBLCLK                  = 0x0209
  WM_MOUSEWHEEL                     = 0x020A
  WM_XBUTTONDOWN                    = 0x020B
  WM_XBUTTONUP                      = 0x020C
  WM_XBUTTONDBLCLK                  = 0x020D
  WM_MOUSEHWHEEL                    = 0x020E
  WM_PARENTNOTIFY                   = 0x0210
  WM_ENTERMENULOOP                  = 0x0211
  WM_EXITMENULOOP                   = 0x0212
  WM_NEXTMENU                       = 0x0213
  WM_SIZING                         = 0x0214
  WM_CAPTURECHANGED                 = 0x0215
  WM_MOVING                         = 0x0216
  WM_POWERBROADCAST                 = 0x0218
  WM_DEVICECHANGE                   = 0x0219
  WM_MDICREATE                      = 0x0220
  WM_MDIDESTROY                     = 0x0221
  WM_MDIACTIVATE                    = 0x0222
  WM_MDIRESTORE                     = 0x0223
  WM_MDINEXT                        = 0x0224
  WM_MDIMAXIMIZE                    = 0x0225
  WM_MDITILE                        = 0x0226
  WM_MDICASCADE                     = 0x0227
  WM_MDIICONARRANGE                 = 0x0228
  WM_MDIGETACTIVE                   = 0x0229
  WM_MDISETMENU                     = 0x0230
  WM_ENTERSIZEMOVE                  = 0x0231
  WM_EXITSIZEMOVE                   = 0x0232
  WM_DROPFILES                      = 0x0233
  WM_MDIREFRESHMENU                 = 0x0234
  WM_POINTERDEVICECHANGE            = 0x0238
  WM_POINTERDEVICEINRANGE           = 0x0239
  WM_POINTERDEVICEOUTOFRANGE        = 0x023A
  WM_TOUCH                          = 0x0240
  WM_NCPOINTERUPDATE                = 0x0241
  WM_NCPOINTERDOWN                  = 0x0242
  WM_NCPOINTERUP                    = 0x0243
  WM_POINTERUPDATE                  = 0x0245
  WM_POINTERDOWN                    = 0x0246
  WM_POINTERUP                      = 0x0247
  WM_POINTERENTER                   = 0x0249
  WM_POINTERLEAVE                   = 0x024A
  WM_POINTERACTIVATE                = 0x024B
  WM_POINTERCAPTURECHANGED          = 0x024C
  WM_TOUCHHITTESTING                = 0x024D
  WM_POINTERWHEEL                   = 0x024E
  WM_POINTERHWHEEL                  = 0x024F
  WM_IME_SETCONTEXT                 = 0x0281
  WM_IME_NOTIFY                     = 0x0282
  WM_IME_CONTROL                    = 0x0283
  WM_IME_COMPOSITIONFULL            = 0x0284
  WM_IME_SELECT                     = 0x0285
  WM_IME_CHAR                       = 0x0286
  WM_IME_REQUEST                    = 0x0288
  WM_IME_KEYDOWN                    = 0x0290
  WM_IME_KEYUP                      = 0x0291
  WM_NCMOUSEHOVER                   = 0x02A0
  WM_MOUSEHOVER                     = 0x02A1
  WM_NCMOUSELEAVE                   = 0x02A2
  WM_MOUSELEAVE                     = 0x02A3
  WM_WTSSESSION_CHANGE              = 0x02B1
  WM_TABLET_FIRST                   = 0x02C0
  WM_TABLET_LAST                    = 0x02DF
  WM_CUT                            = 0x0300
  WM_COPY                           = 0x0301
  WM_PASTE                          = 0x0302
  WM_CLEAR                          = 0x0303
  WM_UNDO                           = 0x0304
  WM_RENDERFORMAT                   = 0x0305
  WM_RENDERALLFORMATS               = 0x0306
  WM_DESTROYCLIPBOARD               = 0x0307
  WM_DRAWCLIPBOARD                  = 0x0308
  WM_PAINTCLIPBOARD                 = 0x0309
  WM_VSCROLLCLIPBOARD               = 0x030A
  WM_SIZECLIPBOARD                  = 0x030B
  WM_ASKCBFORMATNAME                = 0x030C
  WM_CHANGECBCHAIN                  = 0x030D
  WM_HSCROLLCLIPBOARD               = 0x030E
  WM_QUERYNEWPALETTE                = 0x030F
  WM_PALETTEISCHANGING              = 0x0310
  WM_PALETTECHANGED                 = 0x0311
  WM_HOTKEY                         = 0x0312
  WM_PRINT                          = 0x0317
  WM_PRINTCLIENT                    = 0x0318
  WM_APPCOMMAND                     = 0x0319
  WM_THEMECHANGED                   = 0x031A
  WM_CLIPBOARDUPDATE                = 0x031D
  WM_DWMCOMPOSITIONCHANGED          = 0x031E
  WM_DWMNCRENDERINGCHANGED          = 0x031F
  WM_DWMCOLORIZATIONCOLORCHANGED    = 0x0320
  WM_DWMWINDOWMAXIMIZEDCHANGE       = 0x0321
  WM_DWMSENDICONICTHUMBNAIL         = 0x0323
  WM_DWMSENDICONICLIVEPREVIEWBITMAP = 0x0326
  WM_GETTITLEBARINFOEX              = 0x033F
  WM_HANDHELDFIRST                  = 0x0358
  WM_HANDHELDLAST                   = 0x035F
  WM_AFXFIRST                       = 0x0360
  WM_AFXLAST                        = 0x037F
  WM_PENWINFIRST                    = 0x0380
  WM_PENWINLAST                     = 0x038F
  WM_USER                           = 0x0400
  WM_APP                            = 0x8000
const
  WM_SETTINGCHANGE*                 = WM_WININICHANGE
  WM_KEYFIRST*                      = WM_KEYDOWN
  WM_KEYLAST*                       = WM_UNICHAR
  WM_IME_KEYLAST*                   = WM_IME_COMPOSITION
  WM_MOUSEFIRST*                    = WM_MOUSEMOVE
  WM_MOUSELAST*                     = WM_MOUSEHWHEEL

#-------------------------------------------------------------------------------

type WS* {.size:4.} = enum
  WS_OVERLAPPED       = 0x00000000
  WS_MAXIMIZEBOX      = 0x00010000
  WS_MINIMIZEBOX      = 0x00020000
  WS_THICKFRAME       = 0x00040000
  WS_SYSMENU          = 0x00080000
  WS_HSCROLL          = 0x00100000
  WS_VSCROLL          = 0x00200000
  WS_DLGFRAME         = 0x00400000
  WS_BORDER           = 0x00800000
  WS_CAPTION          = 0x00C00000
  WS_OVERLAPPEDWINDOW = WS_CAPTION.uint32 or
                        WS_SYSMENU.uint32 or
                        WS_THICKFRAME.uint32 or
                        WS_MINIMIZEBOX.uint32 or
                        WS_MAXIMIZEBOX.uint32
  WS_MAXIMIZE         = 0x01000000
  WS_CLIPCHILDREN     = 0x02000000
  WS_CLIPSIBLINGS     = 0x04000000
  WS_DISABLED         = 0x08000000
  WS_VISIBLE          = 0x10000000
  WS_MINIMIZE         = 0x20000000
  WS_CHILD            = 0x40000000
  WS_POPUP            = 0x80000000
  WS_POPUPWINDOW      = WS_POPUP.uint32 or
                        WS_BORDER.uint32 or
                        WS_SYSMENU.uint32
const
  WS_TILED*           = WS_OVERLAPPED
  WS_ICONIC*          = WS_MINIMIZE
  WS_SIZEBOX*         = WS_THICKFRAME
  WS_TILEDWINDOW*     = WS_OVERLAPPEDWINDOW
  WS_CHILDWINDOW*     = WS_CHILD
  WS_GROUP*           = WS_MINIMIZEBOX
  WS_TABSTOP*         = WS_MAXIMIZEBOX

proc `or`*(a,b:WS):WS = WS(a.uint or b.uint)

#-------------------------------------------------------------------------------

type WS_EX* {.size:4.} = enum
  WS_EX_LEFT                = 0x00000000
  WS_EX_DLGMODALFRAME       = 0x00000001
  WS_EX_NOPARENTNOTIFY      = 0x00000004
  WS_EX_TOPMOST             = 0x00000008
  WS_EX_ACCEPTFILES         = 0x00000010
  WS_EX_TRANSPARENT         = 0x00000020
  WS_EX_MDICHILD            = 0x00000040
  WS_EX_TOOLWINDOW          = 0x00000080
  WS_EX_WINDOWEDGE          = 0x00000100
  WS_EX_PALETTEWINDOW       = WS_EX_WINDOWEDGE.uint32 or
                              WS_EX_TOOLWINDOW.uint32 or
                              WS_EX_TOPMOST.uint32
  WS_EX_CLIENTEDGE          = 0x00000200
  WS_EX_OVERLAPPEDWINDOW    = WS_EX_WINDOWEDGE.uint32 or
                              WS_EX_CLIENTEDGE.uint32
  WS_EX_CONTEXTHELP         = 0x00000400
  WS_EX_RIGHT               = 0x00001000
  WS_EX_RTLREADING          = 0x00002000
  WS_EX_LEFTSCROLLBAR       = 0x00004000
  WS_EX_CONTROLPARENT       = 0x00010000
  WS_EX_STATICEDGE          = 0x00020000
  WS_EX_APPWINDOW           = 0x00040000
  WS_EX_LAYERED             = 0x00080000
  WS_EX_NOINHERITLAYOUT     = 0x00100000
  WS_EX_NOREDIRECTIONBITMAP = 0x00200000
  WS_EX_LAYOUTRTL           = 0x00400000
  WS_EX_COMPOSITED          = 0x02000000
  WS_EX_NOACTIVATE          = 0x08000000
const
  WS_EX_LTRREADING*         = WS_EX_LEFT
  WS_EX_RIGHTSCROLLBAR*     = WS_EX_LEFT

proc `or`*(a,b:WS_EX):WS_EX = WS_EX(a.uint or b.uint)

#-------------------------------------------------------------------------------

type GUID* = object
  Data1*: int32
  Data2*: uint16
  Data3*: uint16
  Data4*: array[8, uint8]

type IID* = GUID

#-------------------------------------------------------------------------------

type POINT* = object
  x* : int32
  y* : int32

#-------------------------------------------------------------------------------

type RECT* = object
  left*   : int32
  top*    : int32
  right*  : int32
  bottom* : int32

#-------------------------------------------------------------------------------

type SECURITY_ATTRIBUTES* = object
  nLength              : uint32
  lpSecurityDescriptor : pointer
  bInheritHandle       : BOOL

#-------------------------------------------------------------------------------

type SIZE* = object
  cx* : int32
  cy* : int32

#-------------------------------------------------------------------------------

type MSG* = object
  hwnd*    : HWND
  message* : WM
  wParam*  : int
  lParam*  : int
  time*    : uint32
  pt*      : POINT

#-------------------------------------------------------------------------------

type WNDPROC* = proc(hwnd:HWND,msg:WM,wp,lp:int):int {.stdcall.}

#-------------------------------------------------------------------------------

type WNDCLASSEXA* = object
  cbSize*        : uint32
  style*         : CS
  lpfnWndProc*   : WNDPROC
  cbClsExtra*    : uint32
  cbWndExtra*    : uint32
  hInstance*     : pointer
  hIcon*         : pointer
  hCursor*       : pointer
  hbrBackground* : pointer
  lpszMenuName*  : cstring
  lpszClassName* : cstring
  hIconSm*       : pointer

#-------------------------------------------------------------------------------

{.push stdcall,importc,discardable.}

proc AdjustWindowRectEx*(lpRect:ptr RECT,style:WS,bMenu:BOOL,exStyle:WS_EX):BOOL
proc CreateWindowExA*(exStyle:WS_EX,class,title:cstring,style:WS,x,y,w,h:int32,parent:HWND=nil,menu:HMENU=nil,inst:HINSTANCE=nil,param:pointer=nil):HWND
proc DefWindowProcA*(hwnd:HWND,msg:WM,wp,lp:int):int
proc DestroyWindow*(hwnd:HWND):BOOL
proc DispatchMessageA*(lpMsg:ptr MSG):int
proc GetActiveWindow*():HWND
proc GetClientRect*(hWnd:HWND,lpRect:ptr RECT):BOOL
proc GetForegroundWindow*():HWND
proc GetWindowLongPtrA*(hwnd:HWND,nIndex:int32):uint
proc InvalidateRect*(hwnd:HWND, lpRect:ptr RECT, bErase:BOOL ):BOOL
proc LoadCursorA*(hInst:pointer, lpCursorName:cstring):pointer
proc LoadIconA*(hInst:pointer,lpIconName:cstring):pointer
proc PeekMessageA*(lpMsg:ptr MSG,hwnd:HWND,wmin,wmax:WM,remove:PM):BOOL
proc RegisterClassExA*(wndClass:ptr WNDCLASSEXA):uint16
proc SetWindowLongPtrA*(hwnd:HWND,nIndex:int32,value:uint):uint
proc SetWindowTextA*(hWnd:HWND, lpString:cstring):BOOL
proc TranslateMessage*(lpMsg:ptr MSG):BOOL
proc SetWindowPos*(hWnd:HWND,hWndInsertAfter:HWND,x,y,w,h:int32,uFlags:SWP):BOOL

{.pop #[stdcall,importc,discardable]#.}

#-------------------------------------------------------------------------------

proc GetWindowExStyle*(hwnd:HWND):WS_EX {.inline.} =
  WS_EX(GetWindowLongPtrA(hwnd,GWLP_EXSTYLE))

proc GetWindowStyle*(hwnd:HWND):WS {.inline.} =
  WS(GetWindowLongPtrA(hwnd,GWLP_STYLE))