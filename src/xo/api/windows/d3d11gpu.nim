import d3d11
import xo/span
import xo/ptrutils

#===============================================================================

type Mesh* = object
  buffer        : ptr ID3D11Buffer
  vertexStride  : uint32
  indexFormat   : DXGI_FORMAT
  indicesOffset : uint32

proc saferelease*(m:var Mesh) =
  saferelease m.buffer

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

const NoIndices* = DXGI_FORMAT_UNKNOWN
const Uint16*    = DXGI_FORMAT_R16_UINT
const Uint32*    = DXGI_FORMAT_R32_UINT

proc acquire*(
  mesh:typedesc[Mesh],
  vertexStride:uint,
  vertices:Span[byte],
  indexFormat:DXGI_FORMAT,
  indices:Span[byte],
):ptr Mesh =
  let verticesSize = vertices.len.uint32
  assert(verticesSize > 0)
  assert(verticesSize mod 4 == 0)

  let indicesSize = indices.len.uint32
  if (indicesSize > 0):
    assert(indexFormat == Uint16 or indexFormat == Uint32)
    if (indexFormat == Uint16): assert(indicesSize mod 2 == 0)
    if (indexFormat == Uint32): assert(indicesSize mod 4 == 0)
  else:
    assert(indexFormat == NoIndices)

  var bufferDesc = D3D11_BUFFER_DESC(
    ByteWidth : verticesSize + indicesSize,
    Usage     : D3D11_USAGE_IMMUTABLE,
    BindFlags : D3D11_BIND_INDEX_BUFFER or D3D11_BIND_VERTEX_BUFFER,
  )
  var buffer : ptr ID3D11Buffer
  if (vertices.tail == indices.head):
    # data is already contiguous in memory :)
    var data = D3D11_SUBRESOURCE_DATA(pSysMem:vertices.head.pointer)
    checkresult device.CreateBuffer(
      pDesc        = addr bufferDesc,
      pInitialData = addr data,
      ppBuffer     = addr buffer,
    )
  else:
    # must make data contiguous in memory :P
    var tmpMem = alloc(size=bufferDesc.ByteWidth)
    defer: dealloc(tmpMem)
    copyMem(tmpMem,             vertices.head.pointer, verticesSize)
    copyMem(tmpMem+verticesSize, indices.head.pointer,  indicesSize)
    var data = D3D11_SUBRESOURCE_DATA(pSysMem:tmpMem)
    checkresult device.CreateBuffer(
      pDesc        = addr bufferDesc,
      pInitialData = addr data,
      ppBuffer     = addr buffer,
    )
  alloc Mesh(
    buffer        : buffer,
    indexFormat   : indexFormat,
    indicesOffset : verticesSize,
    vertexStride  : vertexStride.uint32,
  )

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc release*(m:ptr Mesh) =
  saferelease m.buffer
  dealloc m

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc set*(m:ptr Mesh) =
  var verticesOffset = 0u32
  context.IASetVertexBuffers(
    StartSlot       = 0,
    NumBuffers      = 1,
    ppVertexBuffers = addr m.buffer,
    pStrides        = addr m.vertexStride,
    pOffsets        = addr verticesOffset,
  )
  if (m.indexFormat == DXGI_FORMAT_UNKNOWN):
    context.IASetIndexBuffer(
      pIndexBuffer = nil,
      Format       = DXGI_FORMAT_R16_UINT,
      Offset       = 0,
    )
  else:
    context.IASetIndexBuffer(
      pIndexBuffer = m.buffer,
      Format       = m.indexFormat,
      Offset       = m.indicesOffset,
    )
