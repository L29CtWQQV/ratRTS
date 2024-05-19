shader_type spatial;
uniform sampler2D background;

void fragment() {
	// simple single color albedo.
	ALBEDO = texture(background,SCREEN_UV).rgb+.2;
	// start with 0 alpha so we can add multiple light shadows together in light()
	
}

void light() {
	// unshaded lighting

	DIFFUSE_LIGHT = vec3(max(.5,ATTENUATION*20.));
	
	// add alpha based on attenuation, which includes if we're in shadow, cap at our max opacity
	//ALPHA = min(ALPHA + shadow_opacity*(1.0 - ATTENUATION), shadow_max_opacity);
}