shader_type spatial;

uniform vec4 line_color : source_color = vec4(0.8, 0.8, 0.8, 1.0);
uniform vec4 bg_color : source_color = vec4(0.95, 0.95, 0.95, 1.0);
uniform float grid_size = 2.0;

void fragment() {
    // Creates a repeating grid based on world coordinates
    vec2 coord = UV * grid_size;
    vec2 grid = abs(fract(coord - 0.5) - 0.5) / fwidth(coord);
    float line = min(grid.x, grid.y);
    
    // Mix background color and grid line color
    vec3 color = mix(line_color.rgb, bg_color.rgb, clamp(line, 0.0, 1.0));
    ALBEDO = color;
    ROUGHNESS = 0.5;
}
