import d3d11

#===============================================================================

type Surface* = object
  swapChain : ptr IDXGISwapChain1
  rtv       : ptr ID3D11RenderTargetView
  dsv       : ptr ID3D11DepthStencilView

proc saferelease*(s:var Surface) =
  saferelease s.swapChain
  saferelease s.rtv
  saferelease s.dsv

proc `=destroy`*(s:var Surface) =
  echo "`=destroy`*(s:var Surface)"
  # writeStackTrace()
  saferelease s

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc init*(s:var Surface, hwnd:HWND) =
  assert(s == default(Surface))

  block: # create swapChain
    var tmpDevice : ptr IDXGIDevice1
    defer: saferelease tmpDevice
    checkresult device.QueryInterface(
      addr IID_IDXGIDevice1,
      cast[ptr pointer](addr tmpDevice),
    )
    var tmpAdapter : ptr IDXGIAdapter
    defer: saferelease tmpAdapter
    checkresult tmpDevice.GetAdapter(
      addr tmpAdapter,
    )
    var tmpFactory : ptr IDXGIFactory2
    defer: saferelease tmpFactory
    checkresult tmpAdapter.GetParent(
      addr IID_IDXGIFactory2,
      cast[ptr pointer](addr tmpFactory),
    )
    var swapChainDesc = DXGI_SWAP_CHAIN_DESC1(
      Width       : 0,
      Height      : 0,
      Format      : DXGI_FORMAT_R8G8B8A8_UNORM,
      Stereo      : false,
      SampleDesc  : DXGI_SAMPLE_DESC(Count: 1, Quality: 0),
      BufferUsage : DXGI_USAGE_RENDER_TARGET_OUTPUT,
      BufferCount : 2,
      Scaling     : DXGI_SCALING_STRETCH,
      SwapEffect  : DXGI_SWAP_EFFECT_FLIP_SEQUENTIAL,
      AlphaMode   : DXGI_ALPHA_MODE_UNSPECIFIED,
      Flags       : 0,
    )
    checkresult tmpFactory.CreateSwapChainForHwnd(
      pDevice           = cast[ptr IUnknown](device),
      hWnd              = hwnd,
      pDesc             = addr swapChainDesc,
      pFullscreenDesc   = cast[ptr DXGI_SWAP_CHAIN_FULLSCREEN_DESC](nil),
      pRestrictToOutput = cast[ptr IDXGIOutput](nil),
      ppSwapChain       = addr s.swapChain,
    )

  var texDesc : D3D11_TEXTURE2D_DESC

  block: # create rtv
    var tmpTexture : ptr ID3D11Texture2D
    defer: saferelease tmpTexture
    checkresult s.swapChain.GetBuffer(
      Buffer    = 0,
      riid      = addr IID_ID3D11Texture2D,
      ppSurface = cast[ptr pointer](addr tmpTexture),
    )
    tmpTexture.GetDesc(addr texDesc)
    var rtvDesc = D3D11_RENDER_TARGET_VIEW_DESC(
      Format        : DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
      ViewDimension : D3D11_RTV_DIMENSION_TEXTURE2D,
    )
    checkresult device.CreateRenderTargetView(
      pResource = tmpTexture,
      pDesc     = addr rtvDesc,
      ppRTView  = addr s.rtv,
    )

  block: # create dsv
    texDesc.Format    = DXGI_FORMAT_D24_UNORM_S8_UINT;
    texDesc.BindFlags = D3D11_BIND_DEPTH_STENCIL;
    var tmpTexture : ptr ID3D11Texture2D
    defer: saferelease tmpTexture
    checkresult device.CreateTexture2D(addr texDesc, nil, addr tmpTexture)
    checkresult device.CreateDepthStencilView(tmpTexture, nil, addr s.dsv)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc resize*(s:var Surface) =
  assert(s.swapChain != nil)
  context.OMSetRenderTargets(0, nil, nil)
  saferelease s.rtv
  saferelease s.dsv
  checkresult s.swapChain.ResizeBuffers(
    BufferCount    = 0, # preserve existing buffer count
    Width          = 0, # use width of window client area
    Height         = 0, # use height of window client area
    NewFormat      = DXGI_FORMAT_UNKNOWN, # preserve existing buffer format
    SwapChainFlags = 0,
  )

  var texDesc : D3D11_TEXTURE2D_DESC

  block: # resize rtv
    var tmpTexture : ptr ID3D11Texture2D
    defer: saferelease tmpTexture
    checkresult s.swapChain.GetBuffer(
      Buffer    = 0,
      riid      = addr IID_ID3D11Texture2D,
      ppSurface = cast[ptr pointer](addr tmpTexture),
    )
    tmpTexture.GetDesc(addr texDesc)
    var rtvDesc = D3D11_RENDER_TARGET_VIEW_DESC(
      Format        : DXGI_FORMAT_R8G8B8A8_UNORM_SRGB,
      ViewDimension : D3D11_RTV_DIMENSION_TEXTURE2D,
    )
    checkresult device.CreateRenderTargetView(
      pResource = tmpTexture,
      pDesc     = addr rtvDesc,
      ppRTView  = addr s.rtv,
    )

  block: # resize dsv
    texDesc.Format    = DXGI_FORMAT_D24_UNORM_S8_UINT;
    texDesc.BindFlags = D3D11_BIND_DEPTH_STENCIL;
    var tmpTexture : ptr ID3D11Texture2D
    defer: saferelease tmpTexture
    checkresult device.CreateTexture2D(addr texDesc, nil, addr tmpTexture)
    checkresult device.CreateDepthStencilView(tmpTexture, nil, addr s.dsv)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc clear*(s:Surface, color:array[4,cfloat], depth:float, stencil:uint8) =
  assert(s.swapChain != nil)
  context.ClearRenderTargetView(s.rtv, color)
  context.ClearDepthStencilView(s.dsv,D3D11_CLEAR_DEPTH_STENCIL,depth,stencil)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc present*(s:var Surface, vsync:bool) =
  assert(s.swapChain != nil)
  checkresult s.swapChain.Present(SyncInterval = vsync.uint32, Flags = 0)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `fullscreen`*(s:Surface):bool =
  assert(s.swapChain != nil)
  var fullscreen : BOOL
  var target : ptr IDXGIOutput
  checkresult s.swapChain.GetFullscreenState(addr fullscreen, addr target)
  return fullscreen

proc `fullscreen=`*(s:var Surface, fullscreen:bool) =
  assert(s.swapChain != nil)
  var fullscreen : BOOL = fullscreen
  var target : ptr IDXGIOutput = nil
  checkresult s.swapChain.SetFullscreenState(fullscreen, target)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
