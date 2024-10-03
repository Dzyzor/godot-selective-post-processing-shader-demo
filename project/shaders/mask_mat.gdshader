shader_type spatial;
render_mode unshaded;
#include "mat_id_lookup.gdshaderinc"

// Add to GeometryInstance3D properties a Material Overlay of type ShaderMaterial using this shader.
// Put in the Material Overlay->Next Pass property if the geometry has other material overlays.
const uint skip_layer_val = 1u; // Bitmask must include the primary target render layer.
const uint mask_layer_val = 2u; // Bitmask must match the cull mask used for MaskCamera.
// Layer values are not layer numbers! Hover over the cull mask layer in the inspector to see the correct value, i.e. for layer 10 the value is 512u.

uniform int material_id = 0; // Shader parameter set in the inspector.
uniform sampler2D depth_texture: source_color, hint_depth_texture, filter_linear_mipmap;

void fragment() {
	uint visible_layers = CAMERA_VISIBLE_LAYERS;
	ALBEDO = vec3(0.0);
	if ((visible_layers & skip_layer_val) == skip_layer_val) {
		discard; // Skip fragment on ignored render layers
	}
	if ((visible_layers & mask_layer_val) == mask_layer_val) {
		texture(depth_texture, SCREEN_UV); // Without this line material ID breaks for some reason?
		ALBEDO.r = encode_mat_id(material_id); // Storing material ID in the red channel
		//ALBEDO.gb; // You could store additional material IDs in the other channels
	}
}
