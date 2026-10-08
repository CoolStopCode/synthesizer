shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float start : hint_range(0.0, 360.0) = 0.0;
uniform vec2 size = vec2(200.0, 100.0);

float edge_position(vec2 point) {
	vec2 half_size = size * 0.5;

	if (abs(point.y) * half_size.x > abs(point.x) * half_size.y) {
		float intersection_horizontal = point.x * half_size.y / abs(point.y);
		if (point.y < 0.0) {
			return half_size.x + intersection_horizontal;                         // top
		} else {
			return size.x + size.y + half_size.x - intersection_horizontal;       // bottom
		}
	} else {
		float intersection_vertical = point.y * half_size.x / max(abs(point.x), 0.000001);
		if (point.x > 0.0) {
			return size.x + half_size.y + intersection_vertical;                  // right
		} else {
			return 2.0 * size.x + size.y + half_size.y - intersection_vertical;   // left
		}
	}
}

void fragment() {
	if (progress == 0.0) {
		discard;
	}
	
	vec4 texture_color = texture(TEXTURE, UV);
	
	float perimeter = 2.0 * (size.x + size.y);
	
	vec2 texel_center = floor(UV * size) + 0.5;
	vec2 pixel_offset_from_center = texel_center - size * 0.5;
	
	float start_angle_radians = radians(start);
	vec2 start_direction = vec2(sin(start_angle_radians), -cos(start_angle_radians));
	
	float pixel_edge_position = edge_position(pixel_offset_from_center) / perimeter;
	float start_edge_position = edge_position(start_direction) / perimeter;
	
	float tie_break_bias = 0.01 / perimeter;
	float sweep_position = fract(pixel_edge_position - start_edge_position + tie_break_bias);
	
	COLOR.a *= step(sweep_position, progress);
}