
#===============================================================================

type TextureFormat* {.size:1.} = enum
  DefaultTextureFormat
  R8n
  RGBA8n
  RGB10A2n
  RGBA32f
  RGBA16f
  R32f
  R16f
  D32f     = 0b10000000u
  D24f_S8u
  RGBA8n_D32f
  RGBA8n_D24f_S8u

type TextureLayout* {.size:1.} = enum
  Texture1D
  Texture2D
  TextureCube
  Texture3D

# type Texture1D*      = ptr object
# type Texture2D*      = ptr object
# type TextureCube*    = ptr object
# type Texture3D*      = ptr object

# proc texture1D*(
#   format  : TextureFormat = default(TextureFormat),
#   width   : uint16,
#   mipmaps : uint16 = default(uint16),
# ):Texture1D =
#   discard

# proc texture2D*(
#   format  : TextureFormat = default(TextureFormat),
#   width   : uint16,
#   height  : uint16 = default(uint16),
#   mipmaps : uint16 = default(uint16),
# ):Texture2D =
#   discard

#===============================================================================
