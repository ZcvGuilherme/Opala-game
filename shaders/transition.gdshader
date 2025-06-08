shader_type canvas_item;

uniform float radius : hint_range(0.0, 1.5) = 1.5;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    vec2 uv = UV;
    float dist = distance(uv, center);
    if (dist < radius) {
        discard;
    } else {
        COLOR = vec4(0.0, 0.0, 0.0, 1.0);
    }
}
