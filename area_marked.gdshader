shader_type canvas_item;
uniform vec2 size;
uniform sampler2D noise;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 c = (UV-.5)/2.f;
	float r = TIME*3.;
	float rn = texture(noise,.5+vec2(c.x*sin(r)-c.y*cos(r),c.x*cos(r)+c.y*sin(r))).x;
	float lin = abs(.4-max(abs(UV-vec2(.5)).x,abs(UV-vec2(.5)).y))*8.;
	COLOR = vec4(1.,0.,0.,(.1-lin*rn)*5.);
	

}

//void light() {
	// Called for every pixel for every light affecting the CanvasItem.
	// Uncomment to replace the default light processing function with this one.
//}





















