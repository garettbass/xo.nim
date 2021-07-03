import glm
import xo
# import xo/gpu
# import xo/window
import xo/span
import xo/ptrutils
import strformat

# type CubeVertex = Vec3f

(proc()=
  let cube = mesh(
    vertices = [
      vec3f(-0.5f,-0.5f, -0.5f),
      vec3f(-0.5f,-0.5f,  0.5f),
      vec3f(-0.5f, 0.5f, -0.5f),
      vec3f(-0.5f, 0.5f,  0.5f),
      vec3f(+0.5f,-0.5f, -0.5f),
      vec3f(+0.5f,-0.5f,  0.5f),
      vec3f(+0.5f, 0.5f, -0.5f),
      vec3f(+0.5f, 0.5f,  0.5f),
    ],
    indices = span[uint16](
      0, 6, 4,
      0, 2, 6,
      0, 3, 2,
      0, 1, 3,
      2, 7, 6,
      2, 3, 7,
      4, 6, 7,
      4, 7, 5,
      0, 4, 5,
      0, 5, 1,
      1, 5, 7,
      1, 7, 3
    )
  )
  defer: release(cube)

  type Vertex = object
    position  : Vec3f
    normal    : Vec3f
    color     : Color
    scale     : float32
    # sizzle    : int # unsupported attribute type: int
  discard attributesOf(Vertex)

  #[
  cbuffer constants : register(b0) {
    float4x4 modelViewProj;
  };

  struct Vertex {
    float3 pos : POS;
  };

  struct Fragment {
    float4 pos   : SV_POSITION;
    float3 color : COLOR;
  };

  Fragment vs_main(Vertex input) {
    Fragment output;
    output.pos = mul(float4(input.pos, 1.0f), modelViewProj);
    output.color = input.pos + float3(0.5f, 0.5f, 0.5f);
    return output;
  }

  float4 ps_main(Fragment input) : SV_Target {
      return float4(abs(input.color), 1.0);
  }
  ]#

  echo "cube:" & $cube

  window(
    title = "cube",
    size = Size(x:480,y:640),
    # onRender = proc(w:Window) =
    #   echo &"{w.size = }"
  )
  while windows.any:
    windows.render()
)()
