@tool
extends MeshInstance3D

@export var target_camera: Camera3D = null

var mask_viewport: SubViewport = null
var mask_camera: Camera3D = null

var shader_material: ShaderMaterial = null


func _ready() -> void:
	mask_viewport = $MaskViewport
	mask_camera = $MaskViewport/MaskCamera
	if target_camera == null:
		var parent = get_parent_node_3d()
		if parent is Camera3D:
			target_camera = parent


func _process(delta: float) -> void:
	if mask_viewport == null && $MaskViewport.is_node_ready():
		mask_viewport = $MaskViewport
	
	if mask_camera == null && $MaskViewport/MaskCamera.is_node_ready():
		mask_camera = $MaskViewport/MaskCamera
	
	if shader_material == null:
		shader_material = get_surface_override_material(0)
	
	if Engine.is_editor_hint() and is_visible():
		var editor_viewport = EditorInterface.get_editor_viewport_3d(0)
		var editor_camera = editor_viewport.get_camera_3d();
		
		mask_camera.global_transform = editor_camera.global_transform
		mask_camera.fov = editor_camera.fov
		mask_viewport.size = editor_viewport.size
		
	elif target_camera != null:
		mask_camera.global_transform = target_camera.global_transform
		mask_camera.fov = target_camera.fov
		mask_viewport.size = get_viewport().size
