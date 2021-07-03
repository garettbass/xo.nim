import glm
import ./texture

#===============================================================================

type Target* = ptr object

proc target*(
  format   : TextureFormat = default(TextureFormat),
  readable : bool          = default(bool),
  scale    : Vec2f         = default(Vec2f),
  size     : Vec2ui        = default(Vec2ui),
):Target =
  discard

proc release*(target:Target) =
  discard

proc `format`*(target:Target):TextureFormat =
  discard

proc `format=`*(target:Target, format:TextureFormat) =
  discard

proc `readable`*(target:Target):bool =
  discard

proc `readable=`*(target:Target,readable:bool) =
  discard

proc `scale`*(target:Target):Vec2f =
  discard

proc `scale=`*(target:Target, scale:Vec2f) =
  discard

proc `size`*(target:Target):Vec2ui =
  discard

proc `size=`*(target:Target, size:Vec2ui) =
  discard

proc `texture`*(target:Target):Texture2D =
  discard

proc `texture=`*(target:Target,texture:Texture2D):Texture2D =
  discard

#-------------------------------------------------------------------------------

let defaultTarget* = target(RGBA8n_D24f_S8u,scale=vec2f(1f))

#===============================================================================
