import strutils

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

converter tobool*(p:pointer):bool = p != nil

converter tobool*[T](p:ptr T):bool = p != nil

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

template `??`*(a,b:untyped) = (if (let ra = a; ra != nil):ra else:b)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `+`*[I:SomeInteger](p:pointer, i:I):pointer =
  cast[pointer](cast[int](p) + cast[int](i))

proc `+`*[T;I:SomeInteger](p:ptr T, i:I):ptr T =
  cast[ptr T](cast[int](p) + cast[int](i) * sizeof(T))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `-`*[I:SomeInteger](p:pointer, i:I):pointer =
  cast[pointer](cast[int](p) - cast[int](i))

proc `-`*[T;I:SomeInteger](p:ptr T, i:I):ptr T =
  cast[ptr T](cast[int](p) - cast[int](i) * sizeof(T))

proc `-`*(a, b:pointer):int =
  (cast[int](a) - cast[int](b))

proc `-`*[T](a, b:ptr T):int =
  (cast[int](a) - cast[int](b)) div sizeof(T)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc inc*[T](x: var ptr T, y = 1) = x = x + y

proc dec*[T](x: var ptr T, y = 1) = x = x - y

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `>`*(a, b:pointer):bool = cast[uint](a) > cast[uint](b)

proc `>`*[T](a, b:ptr T):bool = cast[uint](a) > cast[uint](b)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `>=`*(a, b:pointer):bool = cast[uint](a) >= cast[uint](b)

proc `>=`*[T](a, b:ptr T):bool = cast[uint](a) >= cast[uint](b)

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `[]`*[T;I:SomeInteger](p:ptr T, i:I):var T =
  (p + i)[]

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc `$`*(p:pointer):string =
  toHex(cast[int](p))

proc `$`*[T](p:ptr T):string =
  toHex(cast[int](p))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc max*(a, b:pointer):pointer =
  cast[pointer](max(cast[int](a), cast[int](b)))

proc max*[T](a, b:ptr T):ptr T =
  cast[ptr T](max(cast[int](a), cast[int](b)))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc min*(a, b:pointer):pointer =
  cast[pointer](min(cast[int](a), cast[int](b)))

proc min*[T](a, b:ptr T):ptr T =
  cast[ptr T](min(cast[int](a), cast[int](b)))

#- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

proc alloc*(initializer:object):auto =
  type T = type(initializer)
  result = cast[ptr T](system.alloc0(sizeof(T))) # must be alloc0 for --gc:orc
  result[] = initializer

template dealloc*(instance:ptr object) =
  reset(instance[])
  system.dealloc(instance.pointer)
