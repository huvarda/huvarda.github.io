#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;
uniform vec2 u_mouse;
uniform float u_time;

#define SPIKE_WIDTH 0.01
#define CORE_SIZE 0.4

float parabola( float x, float k ){
  return pow( 4.0*x*(1.0-x), k );
}

float cubicPulse( float c, float w, float x ){
  x = abs(x - c);
  if( x>w ) return 0.0;
  x /= w;
  return 1.0 - x*x*(3.0-2.0*x);
}

vec3 starWithSpikes(vec2 uv, vec3 starColor){
  float d = 1.0 - length(uv - 0.5);

  float spikeV = cubicPulse(0.5, SPIKE_WIDTH, uv.x) * parabola(uv.y, 2.0) * 0.5;
  float spikeH = cubicPulse(0.5, SPIKE_WIDTH, uv.y) * parabola(uv.x, 2.0) * 0.5;
  float core = pow(d, 20.0) * CORE_SIZE;
  float corona = pow(d, 6.0);

  float val = spikeV + spikeH + core + corona;
  return vec3(val * (starColor + val));
}

void main() {
  // To normalized pixel coordinates [0,1].
  vec2 uv = gl_FragCoord.xy / u_resolution.x;

  vec3 starColor = vec3(abs(sin(u_time)), 0.1, abs(cos(u_time)));
  vec3 col = starWithSpikes(uv, starColor);

  gl_FragColor = vec4(col,1.0);
}
