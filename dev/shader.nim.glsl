/*-- vert --*/
#version 330

struct Transforms {
  mat4 mvp;
  float counter;
};

uniform Transforms transforms;

struct Vertex {
  vec4 position;
  vec4 color;
};

struct Fragment {
  vec4 position;
  vec4 color;
};

Fragment vert(Vertex v, uint vertId, uint instId) {
  Fragment result;
  result.position = transforms.mvp * v.position.xyzw;
  result.color = v.color;
  return result;
}

layout(location=0) in vec4 vertex_position;
layout(location=1) in vec4 vertex_color;

out vec4 fragment_position;
out vec4 fragment_color;

void main() {
  Vertex v;
  v.position = vertex_position;
  v.color = vertex_color;
  Fragment result = vert(v, gl_VertexId, gl_InstanceId);
  gl_Position = result.position;
  fragment_position = result.position;
  fragment_color = result.color;
}

/*-- frag --*/
#version 330

uniform Transforms transforms;

struct Sample {
  vec4 rgba;
};

Sample frag(Fragment f) {
  Sample result;
  result.rgba = f.color;
  return result;
}

in vec4 fragment_position;
in vec4 fragment_color;

out vec4 sample_rgba;

void main() {
  Fragment f;
  f.position = fragment_position;
  f.color = fragment_color;
  Sample result = frag(f);
  sample_rgba = result.rgba;
}
