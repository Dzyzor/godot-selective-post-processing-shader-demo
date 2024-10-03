shader_type spatial;
render_mode unshaded;
#include "mat_id_lookup.gdshaderinc"
#include "number_printing.gdshaderinc"

uniform bool debug_view = false; // Shader parameter to enable displaying material ID numbers over materials
uniform sampler2D mask_texture: filter_linear, repeat_disable;

uniform sampler2D depth_texture: source_color, hint_depth_texture, filter_nearest, repeat_disable;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable, filter_nearest;

varying mat4 camera;

vec3 get_material_id_1_albedo() { return vec3(0.5); } // Example function for material ID-specific processing

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	camera = INV_VIEW_MATRIX;
}

void fragment() {
	vec4 mask = texelFetch(mask_texture, ivec2(FRAGCOORD.xy), 0); // Get the material ID showing for this fragment.
	int mat_id = decode_mat_id(mask.r);
	
	vec4 screen = textureLod(screen_texture, SCREEN_UV, 0.0); // Get the original color for this fragment.
	ALPHA = 0.0;
	
	switch (mat_id % 6) { // Handle material ID-specific conditional post processing.
		case 1:
			//ALBEDO = get_material_id_1_albedo(); ALPHA = 1.0;
			break;
		case 4:
			ALBEDO = vec3(screen.rgb * (sin(TIME) + 1.0)); ALPHA = screen.a;
			break;
		case 5:
			ALBEDO = vec3(CAMERA_DIRECTION_WORLD); ALPHA = 1.0;
			break;
	}
	
	if (debug_view) {
		vec3 debug_albedo = mat_id_debug_albedo(mat_id);
		vec2 grid_uv = fract(UV * 20.0);
		float has_number = print_number(grid_uv, float(mat_id)); // True or false
		
		if (has_number == 1.0) { // Whether a debug number pixel should be printed on this fragment.
			ALBEDO = debug_albedo;
			ALPHA = 1.0;
		}
	}
}
