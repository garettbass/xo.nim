import glm
import macros
import span
# import tables
import typeinfo

#===============================================================================

template todo = error("todo")

type Color* = Vec4f # RGBA32f

type Depth* = float32

type Stencil* = uint8

type MeshTopology* {.size:1.} = enum
  Triangles
  Lines
  Points

type IndexFormat* {.size:1.} = enum
  NoIndices
  Uint16
  Uint32

proc indexFormatOf(t:typedesc[uint16]):IndexFormat = Uint16
proc indexFormatOf(t:typedesc[uint32]):IndexFormat = Uint32

type AttributeFormat* {.size:1.} = enum
  NoAttribute
  X32f
  XY32f
  XYZ32f
  XYZW32f
  # XY16f
  # XYZW16f
  # XYZW8n
  # XYZ10W2n

proc attributeFormatOf*(t:typedesc[float32]):AttributeFormat = X32f
proc attributeFormatOf*(t:typedesc[Vec2f]):AttributeFormat = XY32f
proc attributeFormatOf*(t:typedesc[Vec3f]):AttributeFormat = XYZ32f
proc attributeFormatOf*(t:typedesc[Vec4f]):AttributeFormat = XYZW32f
proc attributeFormatOf*[T](t:typedesc[T]):AttributeFormat =
  failedAssertImpl("unsupported attribute type: " & $t)

type Attributes* = array[16,AttributeFormat]

proc attributesOf*[V](v:typedesc[V]):Attributes =
  var i = 0
  for k,v in default(V).fieldPairs:
    result[i] = attributeFormatOf(type(v))
    echo k & ":" & $result[i]
    inc(i)

when isMainModule:
  type Vertex = object
    position  : Vec3f
    normal    : Vec3f
    color     : Color
    scale     : float32
    # sizzle    : int
  discard attributesOf(Vertex)

#-------------------------------------------------------------------------------

type Mesh* = ptr object
  ## A mesh is a single buffer containing vertices and indices

proc release*(mesh:Mesh) {.inline.}

proc mesh*(
  vertexStride : uint,
  vertices     : Span[byte],
  indexFormat  : IndexFormat = NoIndices,
  indices      : Span[byte]  = Span[byte](),
):Mesh {.inline.}

proc mesh*[V,I](vertices:Span[V],indices:Span[I]):Mesh =
  mesh(
    vertexStride = sizeof(V).uint,
    vertices     = vertices.bytes,
    indexFormat  = indexFormatOf(I),
    indices      = indices.bytes,
  )

proc mesh*[V,I](vertices:Span[V]):Mesh =
  mesh(
    vertexStride = sizeof(V).uint,
    vertices     = vertices.bytes,
  )

#-------------------------------------------------------------------------------

# InstanceBuffer?

type Batch* = ptr object
  ## An instance buffer for instanced mesh rendering

type BatchConfig* = object
  attributes* : Attributes
  period*     : uint

#-------------------------------------------------------------------------------

type Texture1D*      = ptr object
type Texture1DArray* = ptr object
type Texture2D*      = ptr object
type Texture2DCube*  = ptr object
type Texture2DArray* = ptr object
type Texture3D*      = ptr object

type TextureFormat* {.size:1.} = enum
  DefaultTextureFormat
  R8n
  RGBA8n
  RGB10A2n
  RGBA32f
  RGBA16f
  R32f
  R16f
  D32f
  D24fS8u

type TextureConfig* = object
  format*  : TextureFormat
  width*   : uint16
  height*  : uint16
  depth*   : uint16
  mipmaps* : uint16
  target*  : bool

type TextureRegion* = object
  offset : Vec4[uint16] # w : mipmap
  extent : Vec4[uint16] # w : mipmap

proc texture[Texture](config:TextureConfig,texels:Span[byte]):Texture =
  todo

proc texture1D*(config:TextureConfig,texels:Span[byte]):Texture1D =
  texture[Texture1D](config,texels)

proc texture1D*[T](width,mipmaps:uint16,texels:Span[T]):Texture1D =
  todo

proc texture1DArray*[T](config:TextureConfig,texels:Span[byte]):Texture1DArray =
  texture[Texture1DArray](config,texels)

proc texture1DArray*[T](width,depth,mipmaps:uint16,texels:Span[T]):Texture1DArray =
  todo

proc texture2D*[T](config:TextureConfig,texels:Span[byte]):Texture2D =
  texture[Texture2D](config,texels)

proc texture2D*[T](width,height,mipmaps:uint16,texels:Span[T]):Texture2D =
  todo

proc texture2DCube*[T](config:TextureConfig,texels:Span[byte]):Texture2DCube =
  texture[Texture2DCube](config,texels)

proc texture2DCube*[T](width,height,mipmaps:uint16,texels:Span[T]):Texture2DCube =
  todo

proc texture2DArray*[T](config:TextureConfig,texels:Span[byte]):Texture2DArray =
  texture[Texture2DArray](config,texels)

proc texture2DArray*[T](width,height,depth,mipmaps:uint16,texels:Span[T]):Texture2DArray =
  todo

proc texture3D*[T](config:TextureConfig,texels:Span[byte]):Texture3D =
  todo

proc texture3D*[T](width,height,depth,mipmaps:uint16,texels:Span[T]):Texture3D =
  todo

#-------------------------------------------------------------------------------

type TextureSlot[TextureType] = object
  format  : TextureFormat
  texture : TextureType

type Texture1DSlot*      = TextureSlot[Texture1D]
type Texture1DArraySlot* = TextureSlot[Texture1DArray]
type Texture2DSlot*      = TextureSlot[Texture2D]
type Texture2DCubeSlot*  = TextureSlot[Texture2DCube]
type Texture2DArraySlot* = TextureSlot[Texture2DArray]
type Texture3DSlot*      = TextureSlot[Texture3D]

#-------------------------------------------------------------------------------

# Source/TargetTextureSlot?
# RenderTextureSlot?
# OutputTextureSlot?
# WriteTextureSlot?

type Target* = ptr object

type TargetSlot* = object
  format : TextureFormat
  size   : Vec2[uint16]
  scale  : float32
  target : Target
  # image  : TextureImage

proc targetSlot*(
  format = default(TextureFormat),
  size   = default(Vec2[uint16]),
  scale  = default(float32),
):TargetSlot =
  TargetSlot(format:format, size:size, scale:scale)

const color* = targetSlot(RGBA8n)

proc `target=`*(slot:TargetSlot,texture:Texture2D,mipmap:int=0) =
  todo

#-------------------------------------------------------------------------------

## Random access buffer, D3D11 UAV
type Buffer* = ptr object

type BufferAccess* = enum
  Random,
  Append,

#[
  Array   # random access buffer, D3D11 UAV
  Stack   # push/pop (append/consume) D3D11_BUFFER_UAV_FLAG_APPEND
  Counter # inc/dec D3D11_BUFFER_UAV_FLAG_COUNTER
]#

type ArrayBufferSlot* = object
  #format   : BufferFormat
  #capacity : uint
  #buffer   : Buffer

type AppendBufferSlot* = object
  #format : BufferFormat
  #capacity : uint

type ConsumeBufferSlot* = object
  #format   : BufferFormat
  #capacity : uint
  #buffer   : Buffer

#[
proc nextBindingId(sym:NimNode):int {.compileTime.} =
  sym.expectKind(nnkSym)
  let bufferSym  {.global,compileTime.} = quote:Buffer
  let targetSym  {.global,compileTime.} = quote:Target
  let textureSym {.global,compileTime.} = quote:Texture
  let validSyms  {.global,compileTime.} = [
    bufferSym,
    targetSym,
    textureSym,
  ]
  if not validSyms.contains(sym):
    error("Invalid binding type: " & $sym, sym)
  let key = sym.repr
  var idCounters {.global,compileTime.} : Table[string, int]
  if (idCounters.contains(key)):
      result = idCounters[key]
  idCounters[key] = result + 1

type Binding*[T] = object
  id : int

macro binding(ident:untyped, t:typed) =
  ident.expectKind(nnkIdent)
  t.expectKind(nnkStmtListExpr)
  let sym = t[0]
  sym.expectKind(nnkSym)
  let id = nextBindingId(sym)
  let name = $ident
  result = quote do:
    const `ident`* = Binding[`sym`](id:`id`)

binding color        : Target
binding depthStencil : Target
binding buffer       : Buffer

static:
  echo "color:" & $color.id
  echo "depthStencil:" & $depthStencil.id
  echo "buffer:" & $buffer.id
]#

#===============================================================================
# Windows implementation

when defined(windows):

  import api/windows/d3d11gpu as d3d11
  import strformat

  proc mesh*(
    vertexStride : uint,
    vertices     : Span[byte],
    indexFormat  : IndexFormat,
    indices      : Span[byte],
  ):Mesh =
    echo &"mesh({vertexStride=},{vertices.len=},{indexFormat=},{indices.len=})"
    let dxgiFormatMap {.global.} = [
      d3d11.NoIndices,
      d3d11.Uint16,
      d3d11.Uint32,
    ]
    cast[Mesh](d3d11.Mesh.acquire(
      vertexStride = vertexStride,
      vertices     = vertices,
      indexFormat  = dxgiFormatMap[indexFormat.uint],
      indices      = indices,
    ))

  proc release*(mesh:Mesh) =
    cast[ptr d3d11.Mesh](mesh).release()

#===============================================================================

else: {.error:"unsupported platform".}
