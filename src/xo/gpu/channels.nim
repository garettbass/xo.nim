import glm

#-------------------------------------------------------------------------------

type Color* = object
  r*,g*,b*,a* : float32

proc `+`*(a,b:Color):Color =
  Color(r:a.r+b.r,g:a.g+b.g,b:a.b+b.b,a:a.a+b.a)

proc color*(rgb:float32,a:float32 = 1f):Color =
  Color(r:rgb,g:rgb,b:rgb,a:a)

proc color*(r,g,b:float32,a:float32 = 1f):Color =
  Color(r:r,g:g,b:b,a:a)

converter color*(t:(float32,float32,float32)):Color =
  Color(r:t[0],g:t[1],b:t[2],a:1f)

converter color*(t:(float32,float32,float32,float32)):Color =
  cast[Color](t)

converter color*(v:Vec4f):Color =
  cast[Color](v)

#-------------------------------------------------------------------------------

type Depth* = float32

#-------------------------------------------------------------------------------

type Stencil* = uint8
