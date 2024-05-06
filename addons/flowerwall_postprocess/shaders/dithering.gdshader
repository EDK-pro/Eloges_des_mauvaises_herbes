shader_type canvas_item;

//Shader courtesy of sagokoliknet!!

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int color_depth : hint_range(1, 8) = 5;
uniform bool dithering = true;
uniform int resolution_scale:hint_range(1, 8, 1) = 4;

uniform bool enable_recolor = false;
uniform sampler2D to_gradient: hint_default_black;

int dithering_pattern(ivec2 fragcoord) {
    const int pattern[] = {
        -4, +0, -3, +1, 
        +2, -2, +3, -1, 
        -3, +1, -4, +0, 
        +3, -1, +2, -2
    };
    
    int x = fragcoord.x % 4;
    int y = fragcoord.y % 4;
    
    return pattern[y * 4 + x];
}
vec3 rgb2hsv(vec3 rgb) { //Converts RGB values to HSV
	float r = rgb.r;
	float g = rgb.g;
	float b = rgb.b;

	float cmax = max(r,max(g,b));
	float cmin = min(r,min(g,b));
	float delta = cmax - cmin;

	float h = 0.f; //hue

	if (delta > 0.f){
		if (cmax == r){
			h = (g-b)/delta;
			h = mod(h,6.f);
		} else if (cmax == g){
			h = ((b - r) / delta) + 2.f;
		} else {
			h = ((r-g)/delta) + 4.f;
		}
		h = h * 60.f;
	}

	float s = 0.f; //saturation
	if (cmax > 0.f){
		s = delta / cmax;
	}

	return vec3(h,s,cmax); // Keep original alpha value 

}

vec3 hsv2rgb(vec3 hsv) { //Converts HSV values to RGB
	float h = hsv.r;
	float s = hsv.g;
	float v = hsv.b;
	float c = v * s;
	//X = C × (1 - |(H / 60°) mod 2 - 1|)
	float x = h / 60.f;
	x = mod(x,2.f);
	x = abs(x - 1.f);
	x = c * (1.f - x);

	float m = v - c;

	vec3 rgb = vec3(0.f,0.f,0.f);

	if (h < 60.f) {
		rgb = vec3(c,x,0.f);
	} else if (h < 120.f){
		rgb = vec3(x,c,0.f);
	} else if (h < 180.f){
		rgb = vec3(0.f,c,x);
	} else if (h < 240.f){
		rgb = vec3(0.f,x,c);
	} else if (h < 300.f){
		rgb = vec3(x,0.f,c);
	} else if (h < 360.f){
		rgb = vec3(c,0.f,x);
	}
	rgb[0] = rgb[0] + m;
	rgb[1] = rgb[1] + m;
	rgb[2] = rgb[2] + m;

	return rgb; 
}

void fragment() {
    ivec2 uv = ivec2(FRAGCOORD.xy / float(resolution_scale));
    vec3 color = texelFetch(screen_texture, uv * resolution_scale, 0).rgb;
    
    // Convert from 0 to 1 to 0 to 255.
    ivec3 c = ivec3(round(color * 255.0));
    
    // Apply the dithering.
    if (dithering) {
        c += ivec3(dithering_pattern(uv));
    }
    
    // Truncate from 8 bits to color_depth bits.
    c >>= (8 - color_depth);
    // Convert back to 0 to 1.
    COLOR.rgb = vec3(c) / float(1 << color_depth);
	

}