shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float ca_strength = 0;

void fragment() {
	vec2 ca_offset = vec2(ca_strength, 0.0) * SCREEN_PIXEL_SIZE;
	
	float red = texture(SCREEN_TEXTURE, SCREEN_UV - ca_offset).r;
	float green = texture(SCREEN_TEXTURE, SCREEN_UV).g;
	float blue = texture(SCREEN_TEXTURE, SCREEN_UV + ca_offset).b;
	
	COLOR = vec4(red,green,blue, 1.0);
}

