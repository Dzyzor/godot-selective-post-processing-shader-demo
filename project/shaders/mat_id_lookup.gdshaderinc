const float mat_id_1 = 0.1; // You can add more material IDs with arbitrary encoded values if needed.
const float mat_id_2 = 0.2;
const float mat_id_3 = 0.3;
const float mat_id_4 = 0.4;
const float mat_id_5 = 0.5;

int decode_mat_id(float encoded) {
	encoded -= 0.26; // Encoded value seems to get offset by about 0.26 somewhere between the shaders?
	int mat_id = -1;
	if (encoded < 0.05) { mat_id = 0; }
	else if (abs(mat_id_1 - encoded) < 0.025) { mat_id = 1; }
	else if (abs(mat_id_2 - encoded) < 0.025) { mat_id = 2; }
	else if (abs(mat_id_3 - encoded) < 0.025) { mat_id = 3; }
	else if (abs(mat_id_4 - encoded) < 0.025) { mat_id = 4; }
	else if (abs(mat_id_5 - encoded) < 0.025) { mat_id = 5; }
	return mat_id;
}

float encode_mat_id(int mat_id) {
	float encoded = 0.0;
	if (mat_id == 1) { return mat_id_1; }
	else if (mat_id == 2) { return mat_id_2; }
	else if (mat_id == 3) { return mat_id_3; }
	else if (mat_id == 4) { return mat_id_4; }
	else if (mat_id == 5) { return mat_id_5; }
	return encoded;
}

vec3 mat_id_debug_albedo(int mat_id) {
	vec3 color = vec3(0.05);
	if (mat_id < 0) { return color; }
	mat_id = mat_id % 6;
	if (mat_id == 0 || mat_id == 3 || mat_id == 5) { color.r = 0.8; }
	if (mat_id == 1 || mat_id == 3 || mat_id == 4) { color.g = 0.8; }
	if (mat_id == 2 || mat_id == 4 || mat_id == 5) { color.b = 0.8; }
	return color;
}
