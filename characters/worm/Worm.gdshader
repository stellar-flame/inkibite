shader_type canvas_item;

uniform vec4 tint_color : source_color = vec4(1.0, 1.0, 1.0, 1.0) ;
uniform vec4 eye_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);   
uniform float tolerance = 0.1; 

void fragment(){
	vec4 tex_color = texture(TEXTURE, UV);
    float diff = distance(tex_color.rgb, eye_color.rgb);

    if (diff > tolerance) {
        COLOR = tex_color * tint_color;
    } else {
        COLOR = tex_color;
    }
}

