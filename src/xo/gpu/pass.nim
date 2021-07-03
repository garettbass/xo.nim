import glm
import typeinfo
import ./channels
import ./target
import ../span

#===============================================================================

type Fill* = object
  color       : Color
  depth       : float
  stencil     : uint8
  fillColor   : bool
  fillDepth   : bool
  fillStencil : bool

converter fill*(color:Color):Fill =
  Fill(color:color,fillColor:true)

converter fill*(depth:Depth):Fill =
  Fill(depth:depth,fillDepth:true)

converter fill*(stencil:Stencil):Fill =
  Fill(stencil:stencil,fillStencil:true)

proc fill*(depth:Depth,stencil:Stencil):Fill =
  Fill(
    depth       : depth,
    stencil     : stencil,
    fillDepth   : true,
    fillStencil : true)

proc fill*(color:Color,depth:Depth,stencil:Stencil):Fill =
  Fill(
    color       : color,
    depth       : depth,
    stencil     : stencil,
    fillColor   : true,
    fillDepth   : true,
    fillStencil : true)

#-------------------------------------------------------------------------------

type Load* {.size:1.} = enum
  Fill
  Restore
  Undefined

#-------------------------------------------------------------------------------

type Store* {.size:1.} = enum
  Preserve
  Discard

#-------------------------------------------------------------------------------

type Action* = object
  target* : Target
  fill*   : Fill
  load*   : Load
  store*  : Store

#-------------------------------------------------------------------------------

converter actions*(t:tuple):Action =
  proc set(a:var Action, target:Target)  = a.target = target
  proc set(a:var Action, fill:Fill)      = a.fill   = fill
  proc set(a:var Action, load:Load)      = a.load   = load
  proc set(a:var Action, store:Store)    = a.store  = store
  for v in fields(t): set(result, v)

#-------------------------------------------------------------------------------

type Texture* = distinct uint32

type RenderTarget* = distinct uint32

proc renderTarget*(
  texture : Texture,
  mipmap  : uint32 = 0,
  offset  : uint32 = 0,
  layers  : uint32 = 0,
):RenderTarget =
  discard

type TargetPass* = object
  target*  : Target
  clear*   : bool
  color*   : Color
  depth*   : float32
  stencil* : uint8

type RenderPass = array[8,TargetPass]

type Pass = ptr object

proc pass*(actions:Span[Action]):Pass =
  discard

proc pass*(action:Action):Pass =
  var actions : array[1,Action]
  actions[0] = action
  pass(span(actions))

proc pass*(fill:Fill):Pass =
  var actions : array[1,Action]
  actions[0].fill = fill
  pass(span(actions))

proc release*(pass:Pass) =
  discard

proc begin*(pass:Pass) =
  discard

proc begin*() =
  let pass {.global.} =
    pass(
      fill(
        default(Color),
        default(Depth),
        default(Stencil)))
  begin(pass)

#===============================================================================
