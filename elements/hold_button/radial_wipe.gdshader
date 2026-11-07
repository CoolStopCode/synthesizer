shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float start : hint_range(0.0, 360.0) = 0.0;
uniform vec2 size = vec2(200.0, 100.0);

float ray_to_perimeter(vec2 direction) {
    vec2 half_size = size * 0.5;

    float horizontal_scale = half_size.x / max(abs(direction.x), 0.000001);
    float vertical_scale = half_size.y / max(abs(direction.y), 0.000001);

    vec2 intersection = direction * min(horizontal_scale, vertical_scale);

    if (horizontal_scale < vertical_scale) {
        if (direction.x > 0.0) {
            return size.x + half_size.y + intersection.y;
        } else {
            return 2.0 * size.x + size.y + half_size.y - intersection.y;
        }
    } else {
        if (direction.y < 0.0) {
            return half_size.x + intersection.x;
        } else {
            return size.x + size.y + half_size.x - intersection.x;
        }
    }
}

vec2 perimeter_to_point(float distance_along_perimeter) {
    vec2 half_size = size * 0.5;
    float perimeter = 2.0 * (size.x + size.y);

    distance_along_perimeter = mod(distance_along_perimeter, perimeter);

    if (distance_along_perimeter < size.x) {
        return vec2(-half_size.x + distance_along_perimeter, -half_size.y);
    } else if (distance_along_perimeter < size.x + size.y) {
        return vec2(half_size.x, -half_size.y + distance_along_perimeter - size.x);
    } else if (distance_along_perimeter < 2.0 * size.x + size.y) {
        return vec2(
            half_size.x - (distance_along_perimeter - size.x - size.y),
            half_size.y
        );
    } else {
        return vec2(
            -half_size.x,
            half_size.y - (distance_along_perimeter - 2.0 * size.x - size.y)
        );
    }
}

void fragment() {
    if (progress <= 0.0) {
        discard;
    }

    if (progress < 1.0) {
        float perimeter = 2.0 * (size.x + size.y);
        float start_angle = radians(start);

        vec2 start_direction = vec2(sin(start_angle), -cos(start_angle));
        float start_distance = ray_to_perimeter(start_direction);

        float arm_distance = start_distance + progress * perimeter;
        vec2 arm_point = perimeter_to_point(arm_distance);

        float arm_angle = atan(arm_point.x, -arm_point.y);
        float arm_sweep = mod(arm_angle - start_angle + TAU, TAU);

        vec2 pixel_position = (UV - vec2(0.5)) * size;
        float pixel_angle = atan(pixel_position.x, -pixel_position.y);
        float pixel_sweep = mod(pixel_angle - start_angle + TAU, TAU);

        COLOR.a *= step(pixel_sweep, arm_sweep);
    }
}