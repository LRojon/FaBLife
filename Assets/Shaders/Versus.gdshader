shader_type canvas_item;

uniform sampler2D mask_texture : source_color;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    vec4 mask_color = texture(mask_texture, UV);
    
    // Multiply the base alpha by the mask's alpha value
    base_color.a = mask_color.a;
    
    COLOR = base_color;
}