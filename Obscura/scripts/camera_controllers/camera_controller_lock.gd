class_name PositionLockCamera
extends CameraControllerBase

func _ready() -> void:
	super._ready()
	draw_camera_logic = true

func _process(delta: float) -> void:
	super._process(delta)
	
	# camera is centered on vessel
	position.x = target.position.x
	position.z = target.position.z
	
	if draw_camera_logic:
		draw_logic()

func draw_logic() -> void:
	var mesh := ImmediateMesh.new()
	mesh.clear_surfaces()
	
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	
	# cross - horizontal line
	mesh.surface_add_vertex(Vector3(-2.5, target.position.y, 0))
	mesh.surface_add_vertex(Vector3(2.5, target.position.y, 0))
	
	# cross - vertical line
	mesh.surface_add_vertex(Vector3(0, target.position.y, -2.5))
	mesh.surface_add_vertex(Vector3(0, target.position.y, 2.5))
	
	mesh.surface_end()
	
	var mesh_instance: MeshInstance3D
	if has_node("DebugMesh"):
		mesh_instance = get_node("DebugMesh")
	else:
		mesh_instance = MeshInstance3D.new()
		mesh_instance.name = "DebugMesh"
		add_child(mesh_instance)
	
	mesh_instance.mesh = mesh
	
	if mesh_instance.get_surface_override_material(0) == null:
		var material := StandardMaterial3D.new()
		material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
		material.albedo_color = Color.WHITE
		mesh_instance.set_surface_override_material(0, material)
