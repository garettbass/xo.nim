import glm
import xo
# import xo/gpu
# import xo/window
import xo/span
import xo/ptrutils
import strformat

# type CubeVertex = Vec3f

type Vertex = object
  position* : Vec2f
  color*    : Vec4f

converter toVec2f(v:(float32,float32)):Vec2f =
  vec2f(v[0],v[1])
converter toVec4f(v:(float32,float32,float32,float32)):Vec4f =
  vec4f(v[0],v[1],v[2],v[3])

proc vertex(position:Vec2f, color:Vec4f):Vertex =
  Vertex(position:position, color:color)

(proc()=
  let triangle = mesh(
    vertices = [
        vertex((+0.0f, +0.5f), (0f, 1f, 0f, 1f)),
        vertex((+0.5f, -0.5f), (1f, 0f, 0f, 1f)),
        vertex((-0.5f, -0.5f), (0f, 0f, 1f, 1f)),
    ],
    indices = span[uint16](0, 1, 2)
  )
  defer: release(triangle)

  #[
  struct Vertex {
      float2 position : position;
      float4 color    : color;
  };

  struct Fragment {
      float4 position : SV_POSITION;
      float4 color    : color;
  };

  Fragment vert(Vertex v) {
      Fragment f;
      f.position = float4(v.position, 0.0f, 1.0f);
      f.color    = v.color;
      return f;
  }

  float4 frag(Fragment f) : SV_TARGET {
      return f.color;
  }
  ]#

  echo "triangle:" & $triangle

  window(
    title = "triangle",
    size = Size(x:640,y:480),
    onRender = proc(w:Window) =
      discard
  )
  while windows.any: windows.render()
)()
