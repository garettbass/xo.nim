import ../span

#===============================================================================

type IndexFormat* {.size:1.} = enum
  NoIndices
  Uint16
  Uint32

proc indexFormatOf(t:typedesc[uint16]):IndexFormat = Uint16
proc indexFormatOf(t:typedesc[uint32]):IndexFormat = Uint32

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

proc mesh*[V,I](vertices:Span[V],indices:Span[I]):Mesh {.inline.} =
  mesh(
    vertexStride = sizeof(V).uint,
    vertices     = vertices.bytes,
    indexFormat  = indexFormatOf(I),
    indices      = indices.bytes,
  )

proc mesh*[V,I](vertices:Span[V]):Mesh {.inline.} =
  mesh(
    vertexStride = sizeof(V).uint,
    vertices     = vertices.bytes,
  )

#===============================================================================
# Windows implementation

when defined(windows):

  import ../platform/windows/d3d11
  import ../platform/windows/d3d11mesh
  import strformat

  converter toDXGI_FORMAT(indexFormat:IndexFormat):DXGI_FORMAT =
    case indexFormat:
      of NoIndices: return DXGI_FORMAT_UNKNOWN
      of Uint16:    return DXGI_FORMAT_R16_UINT
      of Uint32:    return DXGI_FORMAT_R32_UINT

  proc mesh*(
    vertexStride : uint,
    vertices     : Span[byte],
    indexFormat  : IndexFormat,
    indices      : Span[byte],
  ):Mesh =
    echo &"mesh({vertexStride=},{vertices.len=},{indexFormat=},{indices.len=})"
    cast[Mesh](D3D11Mesh.acquire(
      vertexStride = vertexStride,
      vertices     = vertices,
      indexFormat  = indexFormat,
      indices      = indices,
    ))

  proc release*(mesh:Mesh) =
    cast[ptr D3D11Mesh](mesh).release()

#===============================================================================

else: {.error:"unsupported platform".}
