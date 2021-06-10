import glm
export glm

type
  Box*[N:static[int], T:SomeNumber] = object
    origin* : Vec[N, T]
    extent* : Vec[N, T]
  Box2*[T:SomeNumber] = Box[2,T]
  Box2f* = Box2[float32]
  Box2i* = Box2[int32]
  Box3*[T:SomeNumber] = Box[3,T]
  Box3f* = Box3[float32]
  Box3i* = Box3[int32]
  Box4*[T:SomeNumber] = Box[4,T]
  Box4f* = Box4[float32]
  Box4i* = Box4[int32]

proc box2*[T:SomeNumber](x,y,w,h:T):Box2[T] =
  Box2[T](origin:vec2(x,y), extent:vec2(w,h))
proc box2f*(x,y,w,h:float32):Box2f = box2[float32](x, y, w, h)
proc box2i*(x,y,w,h:int32  ):Box2i = box2[int32  ](x, y, w, h)

proc box2*[T:SomeNumber](origin,extent:Vec2[T]):Box2[T] =
  Box2[T](origin:origin, extent:extent)
proc box2f*(origin,extent:Vec2f):Box2f = box2[float32](origin,extent)
proc box2i*(origin,extent:Vec2i):Box2i = box2[int32  ](origin,extent)

proc box3*[T:SomeNumber](origin,extent:Vec3[T]):Box3[T] =
  Box3[T](origin:origin, extent:extent)
proc box3f*(origin,extent:Vec3f):Box3f = box3[float32](origin,extent)
proc box3i*(origin,extent:Vec3i):Box3i = box3[int32  ](origin,extent)

proc box4*[T:SomeNumber](origin,extent:Vec4[T]):Box4[T] =
  Box4[T](origin:origin, extent:extent)
proc box4f*(origin,extent:Vec4f):Box4f = box4[float32](origin,extent)
proc box4i*(origin,extent:Vec4i):Box4i = box4[int32  ](origin,extent)

proc min*[N:static[int], T:SomeNumber](box:Box[N,T]):Vec[N,T] =
  min(box.origin, box.origin + box.extent)

proc max*[N:static[int], T:SomeNumber](box:Box[N,T]):Vec[N,T] =
  max(box.origin, box.origin + box.extent)

proc center*[N:static[int], T:SomeNumber](box:Box[N,T]):Vec[N,T] =
  (box.min + box.max) / cast[T](2)

proc area*[T:SomeNumber](box:Box2[T]):T =
  box.extent.x * box.extent.y

proc volume*[T:SomeNumber](box:Box3[T]):T =
  box.extent.x * box.extent.y * box.extent.z

proc contains*[N:static[int], T:SomeNumber](box:Box[N,T], p:Vec[N,T]):bool =
  let lo : Vec[N,T] = min(box)
  let hi : Vec[N,T] = max(box)
  for i in 0..<N:
    if p[i] < lo[i]:
      return false
    if p[i] > hi[i]:
      return false
  return true

assert(box2i(0,0,2,2).contains(vec2i(1,1)))