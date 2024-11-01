class_name AutoScroll
extends CameraControllerBase

@export var top_left: Vector2 = Vector2(-5, -5) 
@export var bottom_right: Vector2 = Vector2(5, 5) 
@export var autoscroll_speed: Vector3 = Vector3(1, 0, 0)  

var frame_origin: Vector3

func _ready() -> void:
	super()
	draw_camera_logic = true
	frame_origin = position
	
func _process(delta: float) -> void:
	if !current:
		return
		
	frame_origin += autoscroll_speed * delta
	
	position = frame_origin + Vector3(
		(top_left.x + bottom_right.x) / 2.0,
		0,
		(top_left.y + bottom_right.y) / 2.0
	)
	
	var left_edge = frame_origin.x + top_left.x
	if target.position.x - target.WIDTH/2 < left_edge:
		target.position.x = left_edge + target.WIDTH/2
		
	target.position.x = clampf(
		target.position.x,
		frame_origin.x + top_left.x + target.WIDTH/2,
		frame_origin.x + bottom_right.x - target.WIDTH/2
	)
	target.position.z = clampf(
		target.position.z,
		frame_origin.z + top_left.y + target.HEIGHT/2,
		frame_origin.z + bottom_right.y - target.HEIGHT/2
	)
	
	if draw_camera_logic:
		draw_logic()
		
	super(delta)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# draw frame border box
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# top line
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, top_left.y))
	
	# right line
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, top_left.y))
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, bottom_right.y))
	
	# bottom line
	immediate_mesh.surface_add_vertex(Vector3(bottom_right.x, 0, bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, bottom_right.y))
	
	# left line
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, bottom_right.y))
	immediate_mesh.surface_add_vertex(Vector3(top_left.x, 0, top_left.y))
	
	immediate_mesh.surface_end()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(frame_origin.x, target.global_position.y, frame_origin.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
