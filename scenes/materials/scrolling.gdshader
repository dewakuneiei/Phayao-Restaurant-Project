shader_type canvas_item;

uniform float speed = 1.0;

void vertex() {
    // Calculate the rotation angle based on time
    float angle = TIME * speed;
    
    // Create a rotation matrix
    mat2 rotation_matrix = mat2(
        vec2(cos(angle), -sin(angle)),
        vec2(sin(angle), cos(angle))
    );
    
    // Center the UV coordinates
    vec2 centered_uv = UV - 0.5;
    
    // Apply rotation
    centered_uv = rotation_matrix * centered_uv;
    
    // Move the UV coordinates back
    UV = centered_uv + 0.5;
}