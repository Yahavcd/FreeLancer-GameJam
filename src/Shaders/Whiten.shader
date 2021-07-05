shader_type canvas_item;

uniform bool whiten = false;

void fragment()
{
	vec4 texture_color = texture (TEXTURE, UV);
	if (whiten)
	{
		vec3 white = vec3(1,1,1);
		vec3 whiten_texture_rgb = mix(texture_color.rgb, white, 0.8);
		COLOR = vec4(whiten_texture_rgb,texture_color.a);
	}
	else
	{
		COLOR = texture_color;
	}
}