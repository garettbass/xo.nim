import comapi

type DXGI_FORMAT* {.size: sizeof(cint).} = enum
  DXGI_FORMAT_UNKNOWN                    = 0
  DXGI_FORMAT_R32G32B32A32_TYPELESS      = 1
  DXGI_FORMAT_R32G32B32A32_FLOAT         = 2
  DXGI_FORMAT_R32G32B32A32_UINT          = 3
  DXGI_FORMAT_R32G32B32A32_SINT          = 4
  DXGI_FORMAT_R32G32B32_TYPELESS         = 5
  DXGI_FORMAT_R32G32B32_FLOAT            = 6
  DXGI_FORMAT_R32G32B32_UINT             = 7
  DXGI_FORMAT_R32G32B32_SINT             = 8
  DXGI_FORMAT_R16G16B16A16_TYPELESS      = 9
  DXGI_FORMAT_R16G16B16A16_FLOAT         = 10
  DXGI_FORMAT_R16G16B16A16_UNORM         = 11
  DXGI_FORMAT_R16G16B16A16_UINT          = 12
  DXGI_FORMAT_R16G16B16A16_SNORM         = 13
  DXGI_FORMAT_R16G16B16A16_SINT          = 14
  DXGI_FORMAT_R32G32_TYPELESS            = 15
  DXGI_FORMAT_R32G32_FLOAT               = 16
  DXGI_FORMAT_R32G32_UINT                = 17
  DXGI_FORMAT_R32G32_SINT                = 18
  DXGI_FORMAT_R32G8X24_TYPELESS          = 19
  DXGI_FORMAT_D32_FLOAT_S8X24_UINT       = 20
  DXGI_FORMAT_R32_FLOAT_X8X24_TYPELESS   = 21
  DXGI_FORMAT_X32_TYPELESS_G8X24_UINT    = 22
  DXGI_FORMAT_R10G10B10A2_TYPELESS       = 23
  DXGI_FORMAT_R10G10B10A2_UNORM          = 24
  DXGI_FORMAT_R10G10B10A2_UINT           = 25
  DXGI_FORMAT_R11G11B10_FLOAT            = 26
  DXGI_FORMAT_R8G8B8A8_TYPELESS          = 27
  DXGI_FORMAT_R8G8B8A8_UNORM             = 28
  DXGI_FORMAT_R8G8B8A8_UNORM_SRGB        = 29
  DXGI_FORMAT_R8G8B8A8_UINT              = 30
  DXGI_FORMAT_R8G8B8A8_SNORM             = 31
  DXGI_FORMAT_R8G8B8A8_SINT              = 32
  DXGI_FORMAT_R16G16_TYPELESS            = 33
  DXGI_FORMAT_R16G16_FLOAT               = 34
  DXGI_FORMAT_R16G16_UNORM               = 35
  DXGI_FORMAT_R16G16_UINT                = 36
  DXGI_FORMAT_R16G16_SNORM               = 37
  DXGI_FORMAT_R16G16_SINT                = 38
  DXGI_FORMAT_R32_TYPELESS               = 39
  DXGI_FORMAT_D32_FLOAT                  = 40
  DXGI_FORMAT_R32_FLOAT                  = 41
  DXGI_FORMAT_R32_UINT                   = 42
  DXGI_FORMAT_R32_SINT                   = 43
  DXGI_FORMAT_R24G8_TYPELESS             = 44
  DXGI_FORMAT_D24_UNORM_S8_UINT          = 45
  DXGI_FORMAT_R24_UNORM_X8_TYPELESS      = 46
  DXGI_FORMAT_X24_TYPELESS_G8_UINT       = 47
  DXGI_FORMAT_R8G8_TYPELESS              = 48
  DXGI_FORMAT_R8G8_UNORM                 = 49
  DXGI_FORMAT_R8G8_UINT                  = 50
  DXGI_FORMAT_R8G8_SNORM                 = 51
  DXGI_FORMAT_R8G8_SINT                  = 52
  DXGI_FORMAT_R16_TYPELESS               = 53
  DXGI_FORMAT_R16_FLOAT                  = 54
  DXGI_FORMAT_D16_UNORM                  = 55
  DXGI_FORMAT_R16_UNORM                  = 56
  DXGI_FORMAT_R16_UINT                   = 57
  DXGI_FORMAT_R16_SNORM                  = 58
  DXGI_FORMAT_R16_SINT                   = 59
  DXGI_FORMAT_R8_TYPELESS                = 60
  DXGI_FORMAT_R8_UNORM                   = 61
  DXGI_FORMAT_R8_UINT                    = 62
  DXGI_FORMAT_R8_SNORM                   = 63
  DXGI_FORMAT_R8_SINT                    = 64
  DXGI_FORMAT_A8_UNORM                   = 65
  DXGI_FORMAT_R1_UNORM                   = 66
  DXGI_FORMAT_R9G9B9E5_SHAREDEXP         = 67
  DXGI_FORMAT_R8G8_B8G8_UNORM            = 68
  DXGI_FORMAT_G8R8_G8B8_UNORM            = 69
  DXGI_FORMAT_BC1_TYPELESS               = 70
  DXGI_FORMAT_BC1_UNORM                  = 71
  DXGI_FORMAT_BC1_UNORM_SRGB             = 72
  DXGI_FORMAT_BC2_TYPELESS               = 73
  DXGI_FORMAT_BC2_UNORM                  = 74
  DXGI_FORMAT_BC2_UNORM_SRGB             = 75
  DXGI_FORMAT_BC3_TYPELESS               = 76
  DXGI_FORMAT_BC3_UNORM                  = 77
  DXGI_FORMAT_BC3_UNORM_SRGB             = 78
  DXGI_FORMAT_BC4_TYPELESS               = 79
  DXGI_FORMAT_BC4_UNORM                  = 80
  DXGI_FORMAT_BC4_SNORM                  = 81
  DXGI_FORMAT_BC5_TYPELESS               = 82
  DXGI_FORMAT_BC5_UNORM                  = 83
  DXGI_FORMAT_BC5_SNORM                  = 84
  DXGI_FORMAT_B5G6R5_UNORM               = 85
  DXGI_FORMAT_B5G5R5A1_UNORM             = 86
  DXGI_FORMAT_B8G8R8A8_UNORM             = 87
  DXGI_FORMAT_B8G8R8X8_UNORM             = 88
  DXGI_FORMAT_R10G10B10_XR_BIAS_A2_UNORM = 89
  DXGI_FORMAT_B8G8R8A8_TYPELESS          = 90
  DXGI_FORMAT_B8G8R8A8_UNORM_SRGB        = 91
  DXGI_FORMAT_B8G8R8X8_TYPELESS          = 92
  DXGI_FORMAT_B8G8R8X8_UNORM_SRGB        = 93
  DXGI_FORMAT_BC6H_TYPELESS              = 94
  DXGI_FORMAT_BC6H_UF16                  = 95
  DXGI_FORMAT_BC6H_SF16                  = 96
  DXGI_FORMAT_BC7_TYPELESS               = 97
  DXGI_FORMAT_BC7_UNORM                  = 98
  DXGI_FORMAT_BC7_UNORM_SRGB             = 99
  DXGI_FORMAT_AYUV                       = 100
  DXGI_FORMAT_Y410                       = 101
  DXGI_FORMAT_Y416                       = 102
  DXGI_FORMAT_NV12                       = 103
  DXGI_FORMAT_P010                       = 104
  DXGI_FORMAT_P016                       = 105
  DXGI_FORMAT_420_OPAQUE                 = 106
  DXGI_FORMAT_YUY2                       = 107
  DXGI_FORMAT_Y210                       = 108
  DXGI_FORMAT_Y216                       = 109
  DXGI_FORMAT_NV11                       = 110
  DXGI_FORMAT_AI44                       = 111
  DXGI_FORMAT_IA44                       = 112
  DXGI_FORMAT_P8                         = 113
  DXGI_FORMAT_A8P8                       = 114
  DXGI_FORMAT_B4G4R4A4_UNORM             = 115
  DXGI_FORMAT_P208                       = 130
  DXGI_FORMAT_V208                       = 131
  DXGI_FORMAT_V408                       = 132

const FACDXGI = 0x0000087A

template MAKE_DXGI_HRESULT*(code: untyped): untyped =
  MAKE_HRESULT(1, FACDXGI, code)

template MAKE_DXGI_STATUS*(code: untyped): untyped =
  MAKE_HRESULT(0, FACDXGI, code)

type DXGI_RGB* = object
  Red*   : cfloat
  Green* : cfloat
  Blue*  : cfloat

type D3DCOLORVALUE* = object
  r*: cfloat
  g*: cfloat
  b*: cfloat
  a*: cfloat

type DXGI_RGBA* = D3DCOLORVALUE

type DXGI_GAMMA_CONTROL* = object
  Scale*      : DXGI_RGB
  Offset*     : DXGI_RGB
  GammaCurve* : array[1025, DXGI_RGB]

type DXGI_GAMMA_CONTROL_CAPABILITIES* = object
  ScaleAndOffsetSupported* : BOOL
  MaxConvertedValue*       : cfloat
  MinConvertedValue*       : cfloat
  NumGammaControlPoints*   : uint32
  ControlPointPositions*   : array[1025, cfloat]

type DXGI_RATIONAL* = object
  Numerator*   : uint32
  Denominator* : uint32

type DXGI_MODE_SCANLINE_ORDER* {.size: sizeof(cint).} = enum
  DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED       = 0
  DXGI_MODE_SCANLINE_ORDER_PROGRESSIVE       = 1
  DXGI_MODE_SCANLINE_ORDER_UPPER_FIELD_FIRST = 2
  DXGI_MODE_SCANLINE_ORDER_LOWER_FIELD_FIRST = 3

type DXGI_MODE_SCALING* {.size: sizeof(cint).} = enum
  DXGI_MODE_SCALING_UNSPECIFIED = 0
  DXGI_MODE_SCALING_CENTERED    = 1
  DXGI_MODE_SCALING_STRETCHED   = 2

type DXGI_MODE_ROTATION* {.size: sizeof(cint).} = enum
  DXGI_MODE_ROTATION_UNSPECIFIED = 0
  DXGI_MODE_ROTATION_IDENTITY    = 1
  DXGI_MODE_ROTATION_ROTATE90    = 2
  DXGI_MODE_ROTATION_ROTATE180   = 3
  DXGI_MODE_ROTATION_ROTATE270   = 4

type DXGI_MODE_DESC* = object
  Width*            : uint32
  Height*           : uint32
  RefreshRate*      : DXGI_RATIONAL
  Format*           : DXGI_FORMAT
  ScanlineOrdering* : DXGI_MODE_SCANLINE_ORDER
  Scaling*          : DXGI_MODE_SCALING

type DXGI_SAMPLE_DESC* = object
  Count*   : uint32
  Quality* : uint32

const DXGI_STANDARD_MULTISAMPLE_QUALITY_PATTERN* = 0xffffffff
const DXGI_CENTER_MULTISAMPLE_QUALITY_PATTERN*   = 0xfffffffe

type DXGI_COLOR_SPACE_TYPE* = enum
  DXGI_COLOR_SPACE_RGB_FULL_G22_NONE_P709        = 0
  DXGI_COLOR_SPACE_RGB_FULL_G10_NONE_P709        = 1
  DXGI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P709      = 2
  DXGI_COLOR_SPACE_RGB_STUDIO_G22_NONE_P2020     = 3
  DXGI_COLOR_SPACE_RESERVED                      = 4
  DXGI_COLOR_SPACE_YCBCR_FULL_G22_NONE_P709_X601 = 5
  DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P601    = 6
  DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P601      = 7
  DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P709    = 8
  DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P709      = 9
  DXGI_COLOR_SPACE_YCBCR_STUDIO_G22_LEFT_P2020   = 10
  DXGI_COLOR_SPACE_YCBCR_FULL_G22_LEFT_P2020     = 11
  DXGI_COLOR_SPACE_CUSTOM                        = 0xFFFFFFFF

type DXGI_JPEG_DC_HUFFMAN_TABLE* = object
  CodeCounts*: array[12, uint8]
  CodeValues*: array[12, uint8]

type DXGI_JPEG_AC_HUFFMAN_TABLE* = object
  CodeCounts*: array[16, uint8]
  CodeValues*: array[162, uint8]

type DXGI_JPEG_QUANTIZATION_TABLE* = object
  Elements*: array[64, uint8]

when defined(vcc):
  {.link: "dxgi.lib".}
  {.link: "dxguid.lib".}
else:
  {.passL:"-ldxgi".}
  {.passL:"-ldxguid".}

const DXGI_RESOURCE_PRIORITY_MINIMUM* = 0x28000000
const DXGI_RESOURCE_PRIORITY_LOW*     = 0x50000000
const DXGI_RESOURCE_PRIORITY_NORMAL*  = 0x78000000
const DXGI_RESOURCE_PRIORITY_HIGH*    = 0xa0000000
const DXGI_RESOURCE_PRIORITY_MAXIMUM* = 0xc8000000

const DXGI_CPU_ACCESS_NONE*       = 0
const DXGI_CPU_ACCESS_DYNAMIC*    = 1
const DXGI_CPU_ACCESS_READ_WRITE* = 2
const DXGI_CPU_ACCESS_SCRATCH*    = 3
const DXGI_CPU_ACCESS_FIELD*      = 15

type DXGI_USAGE* = uint32
const DXGI_USAGE_SHADER_INPUT*         = 0x00000010
const DXGI_USAGE_RENDER_TARGET_OUTPUT* = 0x00000020
const DXGI_USAGE_BACK_BUFFER*          = 0x00000040
const DXGI_USAGE_SHARED*               = 0x00000080
const DXGI_USAGE_READ_ONLY*            = 0x00000100
const DXGI_USAGE_DISCARD_ON_PRESENT*   = 0x00000200
const DXGI_USAGE_UNORDERED_ACCESS*     = 0x00000400

type DXGI_FRAME_STATISTICS* = object
  PresentCount*:        uint32
  PresentRefreshCount*: uint32
  SyncRefreshCount*:    uint32
  SyncQPCTime*:         int64
  SyncGPUTime*:         int64

type DXGI_MAPPED_RECT* = object
  Pitch*: int32
  pBits*: ptr uint8

type DXGI_ADAPTER_DESC* = object
  Description*:           array[128, WCHAR]
  VendorId*:              uint32
  DeviceId*:              uint32
  SubSysId*:              uint32
  Revision*:              uint32
  DedicatedVideoMemory*:  uint
  DedicatedSystemMemory*: uint
  SharedSystemMemory*:    uint
  AdapterLuid*:           uint64

type DXGI_OUTPUT_DESC* = object
  DeviceName*:         array[32, WCHAR]
  DesktopCoordinates*: RECT
  AttachedToDesktop*:  BOOL
  Rotation*:           DXGI_MODE_ROTATION
  Monitor*:            HMONITOR

type DXGI_SHARED_RESOURCE* = object
  Handle*: HANDLE

type DXGI_RESIDENCY* {.size: sizeof(cint).} = enum
  DXGI_RESIDENCY_FULLY_RESIDENT            = 1
  DXGI_RESIDENCY_RESIDENT_IN_SHARED_MEMORY = 2
  DXGI_RESIDENCY_EVICTED_TO_DISK           = 3

type DXGI_SURFACE_DESC* = object
  Width*:      uint32
  Height*:     uint32
  Format*:     DXGI_FORMAT
  SampleDesc*: DXGI_SAMPLE_DESC

type DXGI_SWAP_EFFECT* {.size: sizeof(cint).} = enum
  DXGI_SWAP_EFFECT_DISCARD         = 0
  DXGI_SWAP_EFFECT_SEQUENTIAL      = 1
  DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL = 3
  DXGI_SWAP_EFFECT_FLIP_DISCARD    = 4

type DXGI_SWAP_CHAIN_FLAG* {.size: sizeof(cint).} = enum
  DXGI_SWAP_CHAIN_FLAG_NONPREROTATED                   = 1
  DXGI_SWAP_CHAIN_FLAG_ALLOW_MODE_SWITCH               = 2
  DXGI_SWAP_CHAIN_FLAG_GDI_COMPATIBLE                  = 4
  DXGI_SWAP_CHAIN_FLAG_RESTRICTED_CONTENT              = 8
  DXGI_SWAP_CHAIN_FLAG_RESTRICT_SHARED_RESOURCE_DRIVER = 16
  DXGI_SWAP_CHAIN_FLAG_DISPLAY_ONLY                    = 32
  DXGI_SWAP_CHAIN_FLAG_FRAME_LATENCY_WAITABLE_OBJECT   = 64
  DXGI_SWAP_CHAIN_FLAG_FOREGROUND_LAYER                = 128
  DXGI_SWAP_CHAIN_FLAG_FULLSCREEN_VIDEO                = 256
  DXGI_SWAP_CHAIN_FLAG_YUV_VIDEO                       = 512
  DXGI_SWAP_CHAIN_FLAG_HW_PROTECTED                    = 1024

type DXGI_SWAP_CHAIN_DESC* = object
  BufferDesc*:   DXGI_MODE_DESC
  SampleDesc*:   DXGI_SAMPLE_DESC
  BufferUsage*:  DXGI_USAGE
  BufferCount*:  uint32
  OutputWindow*: HWND
  Windowed*:     BOOL
  SwapEffect*:   DXGI_SWAP_EFFECT
  Flags*:        uint32

const DXGI_MAP_READ*:    culong = 1
const DXGI_MAP_WRITE*:   culong = 2
const DXGI_MAP_DISCARD*: culong = 4

const DXGI_ENUM_MODES_INTERLACED*: culong = 1
const DXGI_ENUM_MODES_SCALING*:    culong = 2

const DXGI_MAX_SWAP_CHAIN_BUFFERS*  = 16

const DXGI_PRESENT_TEST*:                  culong = 0x00000001
const DXGI_PRESENT_DO_NOT_SEQUENCE*:       culong = 0x00000002
const DXGI_PRESENT_RESTART*:               culong = 0x00000004
const DXGI_PRESENT_DO_NOT_WAIT*:           culong = 0x00000008
const DXGI_PRESENT_STEREO_PREFER_RIGHT*:   culong = 0x00000010
const DXGI_PRESENT_STEREO_TEMPORARY_MONO*: culong = 0x00000020
const DXGI_PRESENT_RESTRICT_TO_OUTPUT*:    culong = 0x00000040
const DXGI_PRESENT_USE_DURATION*:          culong = 0x00000100

const DXGI_MWA_NO_WINDOW_CHANGES* = 1
const DXGI_MWA_NO_ALT_ENTER*      = 2
const DXGI_MWA_NO_PRINT_SCREEN*   = 4
const DXGI_MWA_VALID*             = 7

proc CreateDXGIFactory*(riid: ptr IID; ppFactory: ptr pointer): HRESULT {.stdcall, importc.}

proc CreateDXGIFactory1*(riid: ptr IID; ppFactory: ptr pointer): HRESULT {.stdcall, importc.}

type DXGI_ADAPTER_FLAG* {.size: sizeof(cint).} = enum
  DXGI_ADAPTER_FLAG_NONE     = 0
  DXGI_ADAPTER_FLAG_REMOTE   = 1
  DXGI_ADAPTER_FLAG_SOFTWARE = 2

type DXGI_ADAPTER_DESC1* = object
  Description*:           array[128, WCHAR]
  VendorId*:              uint32
  DeviceId*:              uint32
  SubSysId*:              uint32
  Revision*:              uint32
  DedicatedVideoMemory*:  uint
  DedicatedSystemMemory*: uint
  SharedSystemMemory*:    uint
  AdapterLuid*:           uint64
  Flags*:                 uint32

type DXGI_DISPLAY_COLOR_SPACE* = object
  PrimaryCoordinates*: array[2, array[8,  cfloat]]
  WhitePoints*:        array[2, array[16, cfloat]]

comapi IDXGIObject of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT

comapi IDXGIDeviceSubObject of IDXGIObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT

comapi IDXGIResource of IDXGIDeviceSubObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc GetSharedHandle(pSharedHandle: ptr HANDLE): HRESULT
  proc GetUsage(pUsage: ptr DXGI_USAGE): HRESULT
  proc SetEvictionPriority(EvictionPriority: uint32): HRESULT
  proc GetEvictionPriority(pEvictionPriority: ptr uint32): HRESULT

comapi IDXGIKeyedMutex of IDXGIDeviceSubObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc AcquireSync(Key: uint64; dwMilliseconds: int32): HRESULT
  proc ReleaseSync(Key: uint64): HRESULT

comapi IDXGISurface of IDXGIDeviceSubObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SURFACE_DESC): HRESULT
  proc Map(pLockedRect: ptr DXGI_MAPPED_RECT; MapFlags: uint32): HRESULT
  proc Unmap(): HRESULT

comapi IDXGISurface1 of IDXGISurface:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SURFACE_DESC): HRESULT
  proc Map(pLockedRect: ptr DXGI_MAPPED_RECT; MapFlags: uint32): HRESULT
  proc Unmap(): HRESULT
  proc GetDC(`Discard`: BOOL; phdc: ptr HDC): HRESULT
  proc ReleaseDC(pDirtyRect: ptr RECT): HRESULT

comapi IDXGIOutput of IDXGIObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_OUTPUT_DESC): HRESULT
  proc GetDisplayModeList(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC): HRESULT
  proc FindClosestMatchingMode(pModeToMatch: ptr DXGI_MODE_DESC; pClosestMatch: ptr DXGI_MODE_DESC; pConcernedDevice: ptr IUnknown): HRESULT
  proc WaitForVBlank(): HRESULT
  proc TakeOwnership(pDevice: ptr IUnknown; Exclusive: BOOL): HRESULT
  proc ReleaseOwnership()
  proc GetGammaControlCapabilities(pGammaCaps: ptr DXGI_GAMMA_CONTROL_CAPABILITIES): HRESULT
  proc SetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc GetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc SetDisplaySurface(pScanoutSurface: ptr IDXGISurface): HRESULT
  proc GetDisplaySurfaceData(pDestination: ptr IDXGISurface): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT

comapi IDXGIAdapter of IDXGIObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumOutputs(Output: uint32; ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_ADAPTER_DESC): HRESULT
  proc CheckInterfaceSupport(InterfaceName: ptr GUID; pUMDVersion: ptr int64): HRESULT

comapi IDXGISwapChain of IDXGIDeviceSubObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc Present(SyncInterval: uint32; Flags: uint32): HRESULT
  proc GetBuffer(Buffer: uint32; riid: ptr IID; ppSurface: ptr pointer): HRESULT
  proc SetFullscreenState(Fullscreen: BOOL; pTarget: ptr IDXGIOutput): HRESULT
  proc GetFullscreenState(pFullscreen: ptr BOOL; ppTarget: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SWAP_CHAIN_DESC): HRESULT
  proc ResizeBuffers(BufferCount: uint32; Width: uint32; Height: uint32; NewFormat: DXGI_FORMAT; SwapChainFlags: uint32): HRESULT
  proc ResizeTarget(pNewTargetParameters: ptr DXGI_MODE_DESC): HRESULT
  proc GetContainingOutput(ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetLastPresentCount(pLastPresentCount: ptr uint32): HRESULT

comapi IDXGIFactory of IDXGIObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumAdapters(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc MakeWindowAssociation(WindowHandle: HWND; Flags: uint32): HRESULT
  proc GetWindowAssociation(pWindowHandle: ptr HWND): HRESULT
  proc CreateSwapChain(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC; ppSwapChain: ptr ptr IDXGISwapChain): HRESULT
  proc CreateSoftwareAdapter(Module: HMODULE; ppAdapter: ptr ptr IDXGIAdapter): HRESULT

comapi IDXGIDevice of IDXGIObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetAdapter(pAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc CreateSurface(pDesc: ptr DXGI_SURFACE_DESC; NumSurfaces: uint32; Usage: DXGI_USAGE; pSharedResource: ptr DXGI_SHARED_RESOURCE; ppSurface: ptr ptr IDXGISurface): HRESULT
  proc QueryResourceResidency(ppResources: ptr ptr IUnknown; pResidencyStatus: ptr DXGI_RESIDENCY; NumResources: uint32): HRESULT
  proc SetGPUThreadPriority(Priority: int32): HRESULT
  proc GetGPUThreadPriority(pPriority: ptr int32): HRESULT

comapi IDXGIAdapter1 of IDXGIAdapter:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumOutputs(Output: uint32; ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_ADAPTER_DESC): HRESULT
  proc CheckInterfaceSupport(InterfaceName: ptr GUID; pUMDVersion: ptr int64): HRESULT
  proc GetDesc1(pDesc: ptr DXGI_ADAPTER_DESC1): HRESULT

comapi IDXGIFactory1 of IDXGIFactory:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumAdapters(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc MakeWindowAssociation(WindowHandle: HWND; Flags: uint32): HRESULT
  proc GetWindowAssociation(pWindowHandle: ptr HWND): HRESULT
  proc CreateSwapChain(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC; ppSwapChain: ptr ptr IDXGISwapChain): HRESULT
  proc CreateSoftwareAdapter(Module: HMODULE; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc EnumAdapters1(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter1): HRESULT
  proc IsCurrent(): BOOL

comapi IDXGIDevice1 of IDXGIDevice:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetAdapter(pAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc CreateSurface(pDesc: ptr DXGI_SURFACE_DESC; NumSurfaces: uint32; Usage: DXGI_USAGE; pSharedResource: ptr DXGI_SHARED_RESOURCE; ppSurface: ptr ptr IDXGISurface): HRESULT
  proc QueryResourceResidency(ppResources: ptr ptr IUnknown; pResidencyStatus: ptr DXGI_RESIDENCY; NumResources: uint32): HRESULT
  proc SetGPUThreadPriority(Priority: int32): HRESULT
  proc GetGPUThreadPriority(pPriority: ptr int32): HRESULT
  proc SetMaximumFrameLatency(MaxLatency: uint32): HRESULT
  proc GetMaximumFrameLatency(pMaxLatency: ptr uint32): HRESULT

var
  IID_IDXGIAdapter*         {.importc.}: IID
  IID_IDXGIAdapter1*        {.importc.}: IID
  IID_IDXGIDevice*          {.importc.}: IID
  IID_IDXGIDevice1*         {.importc.}: IID
  IID_IDXGIDeviceSubObject* {.importc.}: IID
  IID_IDXGIFactory*         {.importc.}: IID
  IID_IDXGIFactory1*        {.importc.}: IID
  IID_IDXGIKeyedMutex*      {.importc.}: IID
  IID_IDXGIObject*          {.importc.}: IID
  IID_IDXGIOutput*          {.importc.}: IID
  IID_IDXGIResource*        {.importc.}: IID
  IID_IDXGISurface*         {.importc.}: IID
  IID_IDXGISurface1*        {.importc.}: IID
  IID_IDXGISwapChain*       {.importc.}: IID

# DXGI 1.2 =====================================================================

const DXGI_ENUM_MODES_STEREO*          = 4
const DXGI_ENUM_MODES_DISABLED_STEREO* = 8

const DXGI_SHARED_RESOURCE_READ*  = 0x80000000
const DXGI_SHARED_RESOURCE_WRITE* = 0x00000001

comapi IDXGIDisplayControl of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc IsStereoEnabled(): BOOL
  proc SetStereoEnabled(enabled: BOOL)

type DXGI_OUTDUPL_MOVE_RECT* = object
  SourcePoint*:     POINT
  DestinationRect*: RECT

type DXGI_OUTDUPL_DESC* = object
  ModeDesc*:                   DXGI_MODE_DESC
  Rotation*:                   DXGI_MODE_ROTATION
  DesktopImageInSystemMemory*: BOOL

type DXGI_OUTDUPL_POINTER_POSITION* = object
  Position*: POINT
  Visible*:  BOOL

type DXGI_OUTDUPL_POINTER_SHAPE_TYPE* {.size: sizeof(cint).} = enum
  DXGI_OUTDUPL_POINTER_SHAPE_TYPE_MONOCHROME   = 0x00000001
  DXGI_OUTDUPL_POINTER_SHAPE_TYPE_COLOR        = 0x00000002
  DXGI_OUTDUPL_POINTER_SHAPE_TYPE_MASKED_COLOR = 0x00000004

type DXGI_OUTDUPL_POINTER_SHAPE_INFO* = object
  `Type`*:  uint32
  Width*:   uint32
  Height*:  uint32
  Pitch*:   uint32
  HotSpot*: POINT

type DXGI_OUTDUPL_FRAME_INFO* = object
  LastPresentTime*:           int64
  LastMouseUpdateTime*:       int64
  AccumulatedFrames*:         uint32
  RectsCoalesced*:            BOOL
  ProtectedContentMaskedOut*: BOOL
  PointerPosition*:           DXGI_OUTDUPL_POINTER_POSITION
  TotalMetadataBufferSize*:   uint32
  PointerShapeBufferSize*:    uint32

comapi IDXGIOutputDuplication of IDXGIObject:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_OUTDUPL_DESC)
  proc AcquireNextFrame(TimeoutInMilliseconds: uint32; pFrameInfo: ptr DXGI_OUTDUPL_FRAME_INFO; ppDesktopResource: ptr ptr IDXGIResource): HRESULT
  proc GetFrameDirtyRects(DirtyRectsBufferSize: uint32; pDirtyRectsBuffer: ptr RECT; pDirtyRectsBufferSizeRequired: ptr uint32): HRESULT
  proc GetFrameMoveRects(MoveRectsBufferSize: uint32; pMoveRectBuffer: ptr DXGI_OUTDUPL_MOVE_RECT; pMoveRectsBufferSizeRequired: ptr uint32): HRESULT
  proc GetFramePointerShape(PointerShapeBufferSize: uint32; pPointerShapeBuffer: pointer; pPointerShapeBufferSizeRequired: ptr uint32; pPointerShapeInfo: ptr DXGI_OUTDUPL_POINTER_SHAPE_INFO): HRESULT
  proc MapDesktopSurface(pLockedRect: ptr DXGI_MAPPED_RECT): HRESULT
  proc UnMapDesktopSurface(): HRESULT
  proc ReleaseFrame(): HRESULT

type DXGI_ALPHA_MODE* {.size: sizeof(cint).} = enum
  DXGI_ALPHA_MODE_UNSPECIFIED   = 0
  DXGI_ALPHA_MODE_PREMULTIPLIED = 1
  DXGI_ALPHA_MODE_STRAIGHT      = 2
  DXGI_ALPHA_MODE_IGNORE        = 3

comapi IDXGISurface2 of IDXGISurface1:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SURFACE_DESC): HRESULT
  proc Map(pLockedRect: ptr DXGI_MAPPED_RECT; MapFlags: uint32): HRESULT
  proc Unmap(): HRESULT
  proc GetDC(`Discard`: BOOL; phdc: ptr HDC): HRESULT
  proc ReleaseDC(pDirtyRect: ptr RECT): HRESULT
  proc GetResource(riid: ptr IID; ppParentResource: ptr pointer; pSubresourceIndex: ptr uint32): HRESULT

comapi IDXGIResource1 of IDXGIResource:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc GetSharedHandle(pSharedHandle: ptr HANDLE): HRESULT
  proc GetUsage(pUsage: ptr DXGI_USAGE): HRESULT
  proc SetEvictionPriority(EvictionPriority: uint32): HRESULT
  proc GetEvictionPriority(pEvictionPriority: ptr uint32): HRESULT
  proc CreateSubresourceSurface(index: uint32; ppSurface: ptr ptr IDXGISurface2): HRESULT
  proc CreateSharedHandle(pAttributes: ptr SECURITY_ATTRIBUTES; dwAccess: uint32; lpName: LPCWSTR; pHandle: ptr HANDLE): HRESULT

type DXGI_OFFER_RESOURCE_PRIORITY* {.size: sizeof(cint).} = enum
  DXGI_OFFER_RESOURCE_PRIORITY_LOW    = 1
  DXGI_OFFER_RESOURCE_PRIORITY_NORMAL = 2
  DXGI_OFFER_RESOURCE_PRIORITY_HIGH   = 3

comapi IDXGIDevice2 of IDXGIDevice1:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetAdapter(pAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc CreateSurface(pDesc: ptr DXGI_SURFACE_DESC; NumSurfaces: uint32; Usage: DXGI_USAGE; pSharedResource: ptr DXGI_SHARED_RESOURCE; ppSurface: ptr ptr IDXGISurface): HRESULT
  proc QueryResourceResidency(ppResources: ptr ptr IUnknown; pResidencyStatus: ptr DXGI_RESIDENCY; NumResources: uint32): HRESULT
  proc SetGPUThreadPriority(Priority: int32): HRESULT
  proc GetGPUThreadPriority(pPriority: ptr int32): HRESULT
  proc SetMaximumFrameLatency(MaxLatency: uint32): HRESULT
  proc GetMaximumFrameLatency(pMaxLatency: ptr uint32): HRESULT
  proc OfferResources(NumResources: uint32; ppResources: ptr ptr IDXGIResource; Priority: DXGI_OFFER_RESOURCE_PRIORITY): HRESULT
  proc ReclaimResources(NumResources: uint32; ppResources: ptr ptr IDXGIResource; pDiscarded: ptr BOOL): HRESULT
  proc EnqueueSetEvent(hEvent: HANDLE): HRESULT

type DXGI_MODE_DESC1* = object
  Width*            : uint32
  Height*           : uint32
  RefreshRate*      : DXGI_RATIONAL
  Format*           : DXGI_FORMAT
  ScanlineOrdering* : DXGI_MODE_SCANLINE_ORDER
  Scaling*          : DXGI_MODE_SCALING
  Stereo*           : BOOL

type DXGI_SCALING* {.size: sizeof(cint).} = enum
  DXGI_SCALING_STRETCH              = 0
  DXGI_SCALING_NONE                 = 1
  DXGI_SCALING_ASPECT_RATIO_STRETCH = 2

type DXGI_SWAP_CHAIN_DESC1* = object
  Width*       : uint32
  Height*      : uint32
  Format*      : DXGI_FORMAT
  Stereo*      : BOOL
  SampleDesc*  : DXGI_SAMPLE_DESC
  BufferUsage* : DXGI_USAGE
  BufferCount* : uint32
  Scaling*     : DXGI_SCALING
  SwapEffect*  : DXGI_SWAP_EFFECT
  AlphaMode*   : DXGI_ALPHA_MODE
  Flags*       : uint32

type DXGI_SWAP_CHAIN_FULLSCREEN_DESC* = object
  RefreshRate*      : DXGI_RATIONAL
  ScanlineOrdering* : DXGI_MODE_SCANLINE_ORDER
  Scaling*          : DXGI_MODE_SCALING
  Windowed*         : BOOL

type DXGI_PRESENT_PARAMETERS* = object
  DirtyRectsCount* : uint32
  pDirtyRects*     : ptr RECT
  pScrollRect*     : ptr RECT
  pScrollOffset*   : ptr POINT

comapi IDXGISwapChain1 of IDXGISwapChain:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc Present(SyncInterval: uint32; Flags: uint32): HRESULT
  proc GetBuffer(Buffer: uint32; riid: ptr IID; ppSurface: ptr pointer): HRESULT
  proc SetFullscreenState(Fullscreen: BOOL; pTarget: ptr IDXGIOutput): HRESULT
  proc GetFullscreenState(pFullscreen: ptr BOOL; ppTarget: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SWAP_CHAIN_DESC): HRESULT
  proc ResizeBuffers(BufferCount: uint32; Width: uint32; Height: uint32; NewFormat: DXGI_FORMAT; SwapChainFlags: uint32): HRESULT
  proc ResizeTarget(pNewTargetParameters: ptr DXGI_MODE_DESC): HRESULT
  proc GetContainingOutput(ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetLastPresentCount(pLastPresentCount: ptr uint32): HRESULT
  proc GetDesc1(pDesc: ptr DXGI_SWAP_CHAIN_DESC1): HRESULT
  proc GetFullscreenDesc(pDesc: ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC): HRESULT
  proc GetHwnd(pHwnd: ptr HWND): HRESULT
  proc GetCoreWindow(refiid: ptr IID; ppUnk: ptr pointer): HRESULT
  proc Present1(SyncInterval: uint32; PresentFlags: uint32; pPresentParameters: ptr DXGI_PRESENT_PARAMETERS): HRESULT
  proc IsTemporaryMonoSupported(): BOOL
  proc GetRestrictToOutput(ppRestrictToOutput: ptr ptr IDXGIOutput): HRESULT
  proc SetBackgroundColor(pColor: ptr DXGI_RGBA): HRESULT
  proc GetBackgroundColor(pColor: ptr DXGI_RGBA): HRESULT
  proc SetRotation(Rotation: DXGI_MODE_ROTATION): HRESULT
  proc GetRotation(pRotation: ptr DXGI_MODE_ROTATION): HRESULT

comapi IDXGIFactory2 of IDXGIFactory1:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumAdapters(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc MakeWindowAssociation(WindowHandle: HWND; Flags: uint32): HRESULT
  proc GetWindowAssociation(pWindowHandle: ptr HWND): HRESULT
  proc CreateSwapChain(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC; ppSwapChain: ptr ptr IDXGISwapChain): HRESULT
  proc CreateSoftwareAdapter(Module: HMODULE; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc EnumAdapters1(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter1): HRESULT
  proc IsCurrent(): BOOL
  proc IsWindowedStereoEnabled(): BOOL
  proc CreateSwapChainForHwnd(pDevice: ptr IUnknown; hWnd: HWND; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pFullscreenDesc: ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc CreateSwapChainForCoreWindow(pDevice: ptr IUnknown; pWindow: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc GetSharedResourceAdapterLuid(hResource: HANDLE; pLuid: ptr uint64): HRESULT
  proc RegisterStereoStatusWindow(WindowHandle: HWND; wMsg: uint32; pdwCookie: ptr uint32): HRESULT
  proc RegisterStereoStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterStereoStatus(dwCookie: uint32)
  proc RegisterOcclusionStatusWindow(WindowHandle: HWND; wMsg: uint32; pdwCookie: ptr uint32): HRESULT
  proc RegisterOcclusionStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterOcclusionStatus(dwCookie: uint32)
  proc CreateSwapChainForComposition(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT

type DXGI_GRAPHICS_PREEMPTION_GRANULARITY* {.size: sizeof(cint).} = enum
  DXGI_GRAPHICS_PREEMPTION_DMA_BUFFER_BOUNDARY  = 0
  DXGI_GRAPHICS_PREEMPTION_PRIMITIVE_BOUNDARY   = 1
  DXGI_GRAPHICS_PREEMPTION_TRIANGLE_BOUNDARY    = 2
  DXGI_GRAPHICS_PREEMPTION_PIXEL_BOUNDARY       = 3
  DXGI_GRAPHICS_PREEMPTION_INSTRUCTION_BOUNDARY = 4

type DXGI_COMPUTE_PREEMPTION_GRANULARITY* {.size: sizeof(cint).} = enum
  DXGI_COMPUTE_PREEMPTION_DMA_BUFFER_BOUNDARY   = 0
  DXGI_COMPUTE_PREEMPTION_DISPATCH_BOUNDARY     = 1
  DXGI_COMPUTE_PREEMPTION_THREAD_GROUP_BOUNDARY = 2
  DXGI_COMPUTE_PREEMPTION_THREAD_BOUNDARY       = 3
  DXGI_COMPUTE_PREEMPTION_INSTRUCTION_BOUNDARY  = 4

type DXGI_ADAPTER_DESC2* = object
  Description*                   : array[128, WCHAR]
  VendorId*                      : uint32
  DeviceId*                      : uint32
  SubSysId*                      : uint32
  Revision*                      : uint32
  DedicatedVideoMemory*          : uint
  DedicatedSystemMemory*         : uint
  SharedSystemMemory*            : uint
  AdapterLuid*                   : uint64
  Flags*                         : uint32
  GraphicsPreemptionGranularity* : DXGI_GRAPHICS_PREEMPTION_GRANULARITY
  ComputePreemptionGranularity*  : DXGI_COMPUTE_PREEMPTION_GRANULARITY

comapi IDXGIAdapter2 of IDXGIAdapter1:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumOutputs(Output: uint32; ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_ADAPTER_DESC): HRESULT
  proc CheckInterfaceSupport(InterfaceName: ptr GUID; pUMDVersion: ptr int64): HRESULT
  proc GetDesc1(pDesc: ptr DXGI_ADAPTER_DESC1): HRESULT
  proc GetDesc2(pDesc: ptr DXGI_ADAPTER_DESC2): HRESULT

comapi IDXGIOutput1 of IDXGIOutput:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_OUTPUT_DESC): HRESULT
  proc GetDisplayModeList(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC): HRESULT
  proc FindClosestMatchingMode(pModeToMatch: ptr DXGI_MODE_DESC; pClosestMatch: ptr DXGI_MODE_DESC; pConcernedDevice: ptr IUnknown): HRESULT
  proc WaitForVBlank(): HRESULT
  proc TakeOwnership(pDevice: ptr IUnknown; Exclusive: BOOL): HRESULT
  proc ReleaseOwnership()
  proc GetGammaControlCapabilities(pGammaCaps: ptr DXGI_GAMMA_CONTROL_CAPABILITIES): HRESULT
  proc SetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc GetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc SetDisplaySurface(pScanoutSurface: ptr IDXGISurface): HRESULT
  proc GetDisplaySurfaceData(pDestination: ptr IDXGISurface): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetDisplayModeList1(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC1): HRESULT
  proc FindClosestMatchingMode1(pModeToMatch: ptr DXGI_MODE_DESC1; pClosestMatch: ptr DXGI_MODE_DESC1; pConcernedDevice: ptr IUnknown): HRESULT
  proc GetDisplaySurfaceData1(pDestination: ptr IDXGIResource): HRESULT
  proc DuplicateOutput(pDevice: ptr IUnknown; ppOutputDuplication: ptr ptr IDXGIOutputDuplication): HRESULT

var
  IID_IDXGIAdapter2*          {.importc.} : IID
  IID_IDXGIDevice2*           {.importc.} : IID
  IID_IDXGIDisplayControl*    {.importc.} : IID
  IID_IDXGIFactory2*          {.importc.} : IID
  IID_IDXGIOutput1*           {.importc.} : IID
  IID_IDXGIOutputDuplication* {.importc.} : IID
  IID_IDXGIResource1*         {.importc.} : IID
  IID_IDXGISurface2*          {.importc.} : IID
  IID_IDXGISwapChain1*        {.importc.} : IID

# DXGI 1.3 =====================================================================

comapi IDXGIDevice3 of IDXGIDevice2:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetAdapter(pAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc CreateSurface(pDesc: ptr DXGI_SURFACE_DESC; NumSurfaces: uint32; Usage: DXGI_USAGE; pSharedResource: ptr DXGI_SHARED_RESOURCE; ppSurface: ptr ptr IDXGISurface): HRESULT
  proc QueryResourceResidency(ppResources: ptr ptr IUnknown; pResidencyStatus: ptr DXGI_RESIDENCY; NumResources: uint32): HRESULT
  proc SetGPUThreadPriority(Priority: int32): HRESULT
  proc GetGPUThreadPriority(pPriority: ptr int32): HRESULT
  proc SetMaximumFrameLatency(MaxLatency: uint32): HRESULT
  proc GetMaximumFrameLatency(pMaxLatency: ptr uint32): HRESULT
  proc OfferResources(NumResources: uint32; ppResources: ptr ptr IDXGIResource; Priority: DXGI_OFFER_RESOURCE_PRIORITY): HRESULT
  proc ReclaimResources(NumResources: uint32; ppResources: ptr ptr IDXGIResource; pDiscarded: ptr BOOL): HRESULT
  proc EnqueueSetEvent(hEvent: HANDLE): HRESULT
  proc Trim()

type
  DXGI_MATRIX_3X2_F* = object
    u11*: cfloat
    u12*: cfloat
    u21*: cfloat
    u22*: cfloat
    u31*: cfloat
    u32*: cfloat

comapi IDXGISwapChain2 of IDXGISwapChain1:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc Present(SyncInterval: uint32; Flags: uint32): HRESULT
  proc GetBuffer(Buffer: uint32; riid: ptr IID; ppSurface: ptr pointer): HRESULT
  proc SetFullscreenState(Fullscreen: BOOL; pTarget: ptr IDXGIOutput): HRESULT
  proc GetFullscreenState(pFullscreen: ptr BOOL; ppTarget: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SWAP_CHAIN_DESC): HRESULT
  proc ResizeBuffers(BufferCount: uint32; Width: uint32; Height: uint32; NewFormat: DXGI_FORMAT; SwapChainFlags: uint32): HRESULT
  proc ResizeTarget(pNewTargetParameters: ptr DXGI_MODE_DESC): HRESULT
  proc GetContainingOutput(ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetLastPresentCount(pLastPresentCount: ptr uint32): HRESULT
  proc GetDesc1(pDesc: ptr DXGI_SWAP_CHAIN_DESC1): HRESULT
  proc GetFullscreenDesc(pDesc: ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC): HRESULT
  proc GetHwnd(pHwnd: ptr HWND): HRESULT
  proc GetCoreWindow(refiid: ptr IID; ppUnk: ptr pointer): HRESULT
  proc Present1(SyncInterval: uint32; PresentFlags: uint32; pPresentParameters: ptr DXGI_PRESENT_PARAMETERS): HRESULT
  proc IsTemporaryMonoSupported(): BOOL
  proc GetRestrictToOutput(ppRestrictToOutput: ptr ptr IDXGIOutput): HRESULT
  proc SetBackgroundColor(pColor: ptr DXGI_RGBA): HRESULT
  proc GetBackgroundColor(pColor: ptr DXGI_RGBA): HRESULT
  proc SetRotation(Rotation: DXGI_MODE_ROTATION): HRESULT
  proc GetRotation(pRotation: ptr DXGI_MODE_ROTATION): HRESULT
  proc SetSourceSize(Width: uint32; Height: uint32): HRESULT
  proc GetSourceSize(pWidth: ptr uint32; pHeight: ptr uint32): HRESULT
  proc SetMaximumFrameLatency(MaxLatency: uint32): HRESULT
  proc GetMaximumFrameLatency(pMaxLatency: ptr uint32): HRESULT
  proc GetFrameLatencyWaitableObject(): HANDLE
  proc SetMatrixTransform(pMatrix: ptr DXGI_MATRIX_3X2_F): HRESULT
  proc GetMatrixTransform(pMatrix: ptr DXGI_MATRIX_3X2_F): HRESULT

comapi IDXGIOutput2 of IDXGIOutput1:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_OUTPUT_DESC): HRESULT
  proc GetDisplayModeList(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC): HRESULT
  proc FindClosestMatchingMode(pModeToMatch: ptr DXGI_MODE_DESC; pClosestMatch: ptr DXGI_MODE_DESC; pConcernedDevice: ptr IUnknown): HRESULT
  proc WaitForVBlank(): HRESULT
  proc TakeOwnership(pDevice: ptr IUnknown; Exclusive: BOOL): HRESULT
  proc ReleaseOwnership()
  proc GetGammaControlCapabilities(pGammaCaps: ptr DXGI_GAMMA_CONTROL_CAPABILITIES): HRESULT
  proc SetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc GetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc SetDisplaySurface(pScanoutSurface: ptr IDXGISurface): HRESULT
  proc GetDisplaySurfaceData(pDestination: ptr IDXGISurface): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetDisplayModeList1(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC1): HRESULT
  proc FindClosestMatchingMode1(pModeToMatch: ptr DXGI_MODE_DESC1; pClosestMatch: ptr DXGI_MODE_DESC1; pConcernedDevice: ptr IUnknown): HRESULT
  proc GetDisplaySurfaceData1(pDestination: ptr IDXGIResource): HRESULT
  proc DuplicateOutput(pDevice: ptr IUnknown; ppOutputDuplication: ptr ptr IDXGIOutputDuplication): HRESULT
  proc SupportsOverlays(): BOOL

comapi IDXGIFactory3 of IDXGIFactory2:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumAdapters(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc MakeWindowAssociation(WindowHandle: HWND; Flags: uint32): HRESULT
  proc GetWindowAssociation(pWindowHandle: ptr HWND): HRESULT
  proc CreateSwapChain(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC; ppSwapChain: ptr ptr IDXGISwapChain): HRESULT
  proc CreateSoftwareAdapter(Module: HMODULE; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc EnumAdapters1(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter1): HRESULT
  proc IsCurrent(): BOOL
  proc IsWindowedStereoEnabled(): BOOL
  proc CreateSwapChainForHwnd(pDevice: ptr IUnknown; hWnd: HWND; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pFullscreenDesc: ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc CreateSwapChainForCoreWindow(pDevice: ptr IUnknown; pWindow: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc GetSharedResourceAdapterLuid(hResource: HANDLE; pLuid: ptr uint64): HRESULT
  proc RegisterStereoStatusWindow(WindowHandle: HWND; wMsg: uint32; pdwCookie: ptr uint32): HRESULT
  proc RegisterStereoStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterStereoStatus(dwCookie: uint32)
  proc RegisterOcclusionStatusWindow(WindowHandle: HWND; wMsg: uint32; pdwCookie: ptr uint32): HRESULT
  proc RegisterOcclusionStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterOcclusionStatus(dwCookie: uint32)
  proc CreateSwapChainForComposition(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc GetCreationFlags(): uint32

type DXGI_DECODE_SWAP_CHAIN_DESC* = object
  Flags* : uint32

type DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS* = enum
  DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_NOMINAL_RANGE = 0x00000001
  DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_BT709         = 0x00000002
  DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAG_xvYCC         = 0x00000004

comapi IDXGIDecodeSwapChain of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc PresentBuffer(BufferToPresent: uint32; SyncInterval: uint32; Flags: uint32): HRESULT
  proc SetSourceRect(pRect: ptr RECT): HRESULT
  proc SetTargetRect(pRect: ptr RECT): HRESULT
  proc SetDestSize(Width: uint32; Height: uint32): HRESULT
  proc GetSourceRect(pRect: ptr RECT): HRESULT
  proc GetTargetRect(pRect: ptr RECT): HRESULT
  proc GetDestSize(pWidth: ptr uint32; pHeight: ptr uint32): HRESULT
  proc SetColorSpace(ColorSpace: DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS): HRESULT
  proc GetColorSpace(): DXGI_MULTIPLANE_OVERLAY_YCbCr_FLAGS

comapi IDXGIFactoryMedia of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc CreateSwapChainForCompositionSurfaceHandle(pDevice: ptr IUnknown; hSurface: HANDLE; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc CreateDecodeSwapChainForCompositionSurfaceHandle(pDevice: ptr IUnknown; hSurface: HANDLE; pDesc: ptr DXGI_DECODE_SWAP_CHAIN_DESC; pYuvDecodeBuffers: ptr IDXGIResource; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGIDecodeSwapChain): HRESULT

type DXGI_FRAME_PRESENTATION_MODE* = enum
  DXGI_FRAME_PRESENTATION_MODE_COMPOSED            = 0
  DXGI_FRAME_PRESENTATION_MODE_OVERLAY             = 1
  DXGI_FRAME_PRESENTATION_MODE_NONE                = 2
  DXGI_FRAME_PRESENTATION_MODE_COMPOSITION_FAILURE = 3

type DXGI_FRAME_STATISTICS_MEDIA* = object
  PresentCount*            : uint32
  PresentRefreshCount*     : uint32
  SyncRefreshCount*        : uint32
  SyncQPCTime*             : int64
  SyncGPUTime*             : int64
  CompositionMode*         : DXGI_FRAME_PRESENTATION_MODE
  ApprovedPresentDuration* : uint32

comapi IDXGISwapChainMedia of IUnknown:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc GetFrameStatisticsMedia(pStats: ptr DXGI_FRAME_STATISTICS_MEDIA): HRESULT
  proc SetPresentDuration(Duration: uint32): HRESULT
  proc CheckPresentDurationSupport(DesiredPresentDuration: uint32; pClosestSmallerPresentDuration: ptr uint32; pClosestLargerPresentDuration: ptr uint32): HRESULT

type DXGI_OVERLAY_SUPPORT_FLAG* = enum
  DXGI_OVERLAY_SUPPORT_FLAG_DIRECT  = 0x00000001
  DXGI_OVERLAY_SUPPORT_FLAG_SCALING = 0x00000002

comapi IDXGIOutput3 of IDXGIOutput2:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_OUTPUT_DESC): HRESULT
  proc GetDisplayModeList(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC): HRESULT
  proc FindClosestMatchingMode(pModeToMatch: ptr DXGI_MODE_DESC; pClosestMatch: ptr DXGI_MODE_DESC; pConcernedDevice: ptr IUnknown): HRESULT
  proc WaitForVBlank(): HRESULT
  proc TakeOwnership(pDevice: ptr IUnknown; Exclusive: BOOL): HRESULT
  proc ReleaseOwnership()
  proc GetGammaControlCapabilities(pGammaCaps: ptr DXGI_GAMMA_CONTROL_CAPABILITIES): HRESULT
  proc SetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc GetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc SetDisplaySurface(pScanoutSurface: ptr IDXGISurface): HRESULT
  proc GetDisplaySurfaceData(pDestination: ptr IDXGISurface): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetDisplayModeList1(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC1): HRESULT
  proc FindClosestMatchingMode1(pModeToMatch: ptr DXGI_MODE_DESC1; pClosestMatch: ptr DXGI_MODE_DESC1; pConcernedDevice: ptr IUnknown): HRESULT
  proc GetDisplaySurfaceData1(pDestination: ptr IDXGIResource): HRESULT
  proc DuplicateOutput(pDevice: ptr IUnknown; ppOutputDuplication: ptr ptr IDXGIOutputDuplication): HRESULT
  proc SupportsOverlays(): BOOL
  proc CheckOverlaySupport(EnumFormat: DXGI_FORMAT; pConcernedDevice: ptr IUnknown; pFlags: ptr uint32): HRESULT

proc CreateDXGIFactory2*(Flags: uint32; riid: ptr IID; ppFactory: ptr pointer): HRESULT {.stdcall, importc.}

proc DXGIGetDebugInterface1*(Flags: uint32; riid: ptr IID; pDebug: ptr pointer): HRESULT {.stdcall, importc.}

var
  IID_IDXGIDecodeSwapChain* {.importc.}: IID
  IID_IDXGIDevice3*         {.importc.}: IID
  IID_IDXGIFactory3*        {.importc.}: IID
  IID_IDXGIFactoryMedia*    {.importc.}: IID
  IID_IDXGIOutput2*         {.importc.}: IID
  IID_IDXGIOutput3*         {.importc.}: IID
  IID_IDXGISwapChain2*      {.importc.}: IID
  IID_IDXGISwapChainMedia*  {.importc.}: IID

# DXGI 1.4 =====================================================================

type DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG* {.size: sizeof(cint).} = enum
  DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_PRESENT         = 0x00000001
  DXGI_SWAP_CHAIN_COLOR_SPACE_SUPPORT_FLAG_OVERLAY_PRESENT = 0x00000002

comapi IDXGISwapChain3 of IDXGISwapChain2:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDevice(riid: ptr IID; ppDevice: ptr pointer): HRESULT
  proc Present(SyncInterval: uint32; Flags: uint32): HRESULT
  proc GetBuffer(Buffer: uint32; riid: ptr IID; ppSurface: ptr pointer): HRESULT
  proc SetFullscreenState(Fullscreen: BOOL; pTarget: ptr IDXGIOutput): HRESULT
  proc GetFullscreenState(pFullscreen: ptr BOOL; ppTarget: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_SWAP_CHAIN_DESC): HRESULT
  proc ResizeBuffers(BufferCount: uint32; Width: uint32; Height: uint32; NewFormat: DXGI_FORMAT; SwapChainFlags: uint32): HRESULT
  proc ResizeTarget(pNewTargetParameters: ptr DXGI_MODE_DESC): HRESULT
  proc GetContainingOutput(ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetLastPresentCount(pLastPresentCount: ptr uint32): HRESULT
  proc GetDesc1(pDesc: ptr DXGI_SWAP_CHAIN_DESC1): HRESULT
  proc GetFullscreenDesc(pDesc: ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC): HRESULT
  proc GetHwnd(pHwnd: ptr HWND): HRESULT
  proc GetCoreWindow(refiid: ptr IID; ppUnk: ptr pointer): HRESULT
  proc Present1(SyncInterval: uint32; PresentFlags: uint32; pPresentParameters: ptr DXGI_PRESENT_PARAMETERS): HRESULT
  proc IsTemporaryMonoSupported(): BOOL
  proc GetRestrictToOutput(ppRestrictToOutput: ptr ptr IDXGIOutput): HRESULT
  proc SetBackgroundColor(pColor: ptr DXGI_RGBA): HRESULT
  proc GetBackgroundColor(pColor: ptr DXGI_RGBA): HRESULT
  proc SetRotation(Rotation: DXGI_MODE_ROTATION): HRESULT
  proc GetRotation(pRotation: ptr DXGI_MODE_ROTATION): HRESULT
  proc SetSourceSize(Width: uint32; Height: uint32): HRESULT
  proc GetSourceSize(pWidth: ptr uint32; pHeight: ptr uint32): HRESULT
  proc SetMaximumFrameLatency(MaxLatency: uint32): HRESULT
  proc GetMaximumFrameLatency(pMaxLatency: ptr uint32): HRESULT
  proc GetFrameLatencyWaitableObject(): HANDLE
  proc SetMatrixTransform(pMatrix: ptr DXGI_MATRIX_3X2_F): HRESULT
  proc GetMatrixTransform(pMatrix: ptr DXGI_MATRIX_3X2_F): HRESULT
  proc GetCurrentBackBufferIndex(): uint32
  proc CheckColorSpaceSupport(ColorSpace: DXGI_COLOR_SPACE_TYPE; pColorSpaceSupport: ptr uint32): HRESULT
  proc SetColorSpace1(ColorSpace: DXGI_COLOR_SPACE_TYPE): HRESULT
  proc ResizeBuffers1(BufferCount: uint32; Width: uint32; Height: uint32; Format: DXGI_FORMAT; SwapChainFlags: uint32; pCreationNodeMask: ptr uint32; ppPresentQueue: ptr ptr IUnknown): HRESULT

type DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG* {.size: sizeof(cint).} = enum
  DXGI_OVERLAY_COLOR_SPACE_SUPPORT_FLAG_PRESENT = 0x00000001

comapi IDXGIOutput4 of IDXGIOutput3:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc GetDesc(pDesc: ptr DXGI_OUTPUT_DESC): HRESULT
  proc GetDisplayModeList(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC): HRESULT
  proc FindClosestMatchingMode(pModeToMatch: ptr DXGI_MODE_DESC; pClosestMatch: ptr DXGI_MODE_DESC; pConcernedDevice: ptr IUnknown): HRESULT
  proc WaitForVBlank(): HRESULT
  proc TakeOwnership(pDevice: ptr IUnknown; Exclusive: BOOL): HRESULT
  proc ReleaseOwnership()
  proc GetGammaControlCapabilities(pGammaCaps: ptr DXGI_GAMMA_CONTROL_CAPABILITIES): HRESULT
  proc SetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc GetGammaControl(pArray: ptr DXGI_GAMMA_CONTROL): HRESULT
  proc SetDisplaySurface(pScanoutSurface: ptr IDXGISurface): HRESULT
  proc GetDisplaySurfaceData(pDestination: ptr IDXGISurface): HRESULT
  proc GetFrameStatistics(pStats: ptr DXGI_FRAME_STATISTICS): HRESULT
  proc GetDisplayModeList1(EnumFormat: DXGI_FORMAT; Flags: uint32; pNumModes: ptr uint32; pDesc: ptr DXGI_MODE_DESC1): HRESULT
  proc FindClosestMatchingMode1(pModeToMatch: ptr DXGI_MODE_DESC1; pClosestMatch: ptr DXGI_MODE_DESC1; pConcernedDevice: ptr IUnknown): HRESULT
  proc GetDisplaySurfaceData1(pDestination: ptr IDXGIResource): HRESULT
  proc DuplicateOutput(pDevice: ptr IUnknown; ppOutputDuplication: ptr ptr IDXGIOutputDuplication): HRESULT
  proc SupportsOverlays(): BOOL
  proc CheckOverlaySupport(EnumFormat: DXGI_FORMAT; pConcernedDevice: ptr IUnknown; pFlags: ptr uint32): HRESULT
  proc CheckOverlayColorSpaceSupport(Format: DXGI_FORMAT; ColorSpace: DXGI_COLOR_SPACE_TYPE; pConcernedDevice: ptr IUnknown; pFlags: ptr uint32): HRESULT

comapi IDXGIFactory4 of IDXGIFactory3:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumAdapters(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc MakeWindowAssociation(WindowHandle: HWND; Flags: uint32): HRESULT
  proc GetWindowAssociation(pWindowHandle: ptr HWND): HRESULT
  proc CreateSwapChain(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC; ppSwapChain: ptr ptr IDXGISwapChain): HRESULT
  proc CreateSoftwareAdapter(Module: HMODULE; ppAdapter: ptr ptr IDXGIAdapter): HRESULT
  proc EnumAdapters1(Adapter: uint32; ppAdapter: ptr ptr IDXGIAdapter1): HRESULT
  proc IsCurrent(): BOOL
  proc IsWindowedStereoEnabled(): BOOL
  proc CreateSwapChainForHwnd(pDevice: ptr IUnknown; hWnd: HWND; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pFullscreenDesc: ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc CreateSwapChainForCoreWindow(pDevice: ptr IUnknown; pWindow: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc GetSharedResourceAdapterLuid(hResource: HANDLE; pLuid: ptr uint64): HRESULT
  proc RegisterStereoStatusWindow(WindowHandle: HWND; wMsg: uint32; pdwCookie: ptr uint32): HRESULT
  proc RegisterStereoStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterStereoStatus(dwCookie: uint32)
  proc RegisterOcclusionStatusWindow(WindowHandle: HWND; wMsg: uint32; pdwCookie: ptr uint32): HRESULT
  proc RegisterOcclusionStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterOcclusionStatus(dwCookie: uint32)
  proc CreateSwapChainForComposition(pDevice: ptr IUnknown; pDesc: ptr DXGI_SWAP_CHAIN_DESC1; pRestrictToOutput: ptr IDXGIOutput; ppSwapChain: ptr ptr IDXGISwapChain1): HRESULT
  proc GetCreationFlags(): uint32
  proc EnumAdapterByLuid(AdapterLuid: uint64; riid: ptr IID; ppvAdapter: ptr pointer): HRESULT
  proc EnumWarpAdapter(riid: ptr IID; ppvAdapter: ptr pointer): HRESULT

type DXGI_MEMORY_SEGMENT_GROUP* {.size: sizeof(cint).} = enum
  DXGI_MEMORY_SEGMENT_GROUP_LOCAL     = 0
  DXGI_MEMORY_SEGMENT_GROUP_NON_LOCAL = 1

type DXGI_QUERY_VIDEO_MEMORY_INFO* = object
  Budget*                  : uint64
  CurrentUsage*            : uint64
  AvailableForReservation* : uint64
  CurrentReservation*      : uint64

comapi IDXGIAdapter3 of IDXGIAdapter2:
  proc QueryInterface(riid: ptr IID; ppvObject: ptr pointer): HRESULT
  proc AddRef(): uint32
  proc Release(): uint32
  proc SetPrivateData(Name: ptr GUID; DataSize: uint32; pData: pointer): HRESULT
  proc SetPrivateDataInterface(Name: ptr GUID; pUnknown: ptr IUnknown): HRESULT
  proc GetPrivateData(Name: ptr GUID; pDataSize: ptr uint32; pData: pointer): HRESULT
  proc GetParent(riid: ptr IID; ppParent: ptr pointer): HRESULT
  proc EnumOutputs(Output: uint32; ppOutput: ptr ptr IDXGIOutput): HRESULT
  proc GetDesc(pDesc: ptr DXGI_ADAPTER_DESC): HRESULT
  proc CheckInterfaceSupport(InterfaceName: ptr GUID; pUMDVersion: ptr int64): HRESULT
  proc GetDesc1(pDesc: ptr DXGI_ADAPTER_DESC1): HRESULT
  proc GetDesc2(pDesc: ptr DXGI_ADAPTER_DESC2): HRESULT
  proc RegisterHardwareContentProtectionTeardownStatusEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterHardwareContentProtectionTeardownStatus(dwCookie: uint32)
  proc QueryVideoMemoryInfo(NodeIndex: uint32; MemorySegmentGroup: DXGI_MEMORY_SEGMENT_GROUP; pVideoMemoryInfo: ptr DXGI_QUERY_VIDEO_MEMORY_INFO): HRESULT
  proc SetVideoMemoryReservation(NodeIndex: uint32; MemorySegmentGroup: DXGI_MEMORY_SEGMENT_GROUP; Reservation: uint64): HRESULT
  proc RegisterVideoMemoryBudgetChangeNotificationEvent(hEvent: HANDLE; pdwCookie: ptr uint32): HRESULT
  proc UnregisterVideoMemoryBudgetChangeNotification(dwCookie: uint32)

var
  IID_IDXGIAdapter3*   {.importc.}: IID
  IID_IDXGIFactory4*   {.importc.}: IID
  IID_IDXGIOutput4*    {.importc.}: IID
  IID_IDXGISwapChain3* {.importc.}: IID
