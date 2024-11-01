class_name PushZoneCamera
extends CameraControllerBase

@export var push_ratio: float = 1.5
@export var pushbox_top_left: Vector2 = Vector2(-10, -10)
@export var pushbox_bottom_right: Vector2 = Vector2(10, 10)
@export var speedup_zone_top_left: Vector2 = Vector2(-5, -5)
@export var speedup_zone_bottom_right: Vector2 = Vector2(5, 5)

func _ready() -> void:
	super()
	draw_camera_logic = true
	if target:
		position.x = target.position.x
		position.z = target.position.z

func _process(delta: float) -> void:
	if !current or !target:
		return
		
	super(delta)
	
	# vessel's position relative to camera's push zones
	var relative_pos = target.position - position
	relative_pos.y = 0 
	
	var relative_pos_2d = Vector2(relative_pos.x, relative_pos.z)
	
	var velocity = target.velocity
	var velocity_2d = Vector2(velocity.x, velocity.z)
	
	var camera_movement = Vector2.ZERO
	
	if velocity_2d.length() > 0.01:  
		if !is_in_speedup(relative_pos_2d):
			if is_in_pushbox(relative_pos_2d):

				var touching_left = relative_pos_2d.x <= pushbox_top_left.x
				var touching_right = relative_pos_2d.x >= pushbox_bottom_right.x
				var touching_top = relative_pos_2d.y <= pushbox_top_left.y
				var touching_bottom = relative_pos_2d.y >= pushbox_bottom_right.y
				
				if touching_left or touching_right:
					camera_movement.x = velocity_2d.x 
					camera_movement.y = velocity_2d.y * push_ratio 
				elif touching_top or touching_bottom:
					camera_movement.x = velocity_2d.x * push_ratio
					camera_movement.y = velocity_2d.y 
				else:
					camera_movement = velocity_2d * push_ratio
			else:
				camera_movement = velocity_2d
	
	# move camera
	position.x += camera_movement.x * delta
	position.z += camera_movement.y * delta

	if draw_camera_logic:
		draw_logic()

func is_in_pushbox(pos: Vector2) -> bool:
	return (pos.x >= pushbox_top_left.x && 
			pos.x <= pushbox_bottom_right.x &&
			pos.y >= pushbox_top_left.y && 
			pos.y <= pushbox_bottom_right.y)

func is_in_speedup(pos: Vector2) -> bool:
	return (pos.x >= speedup_zone_top_left.x && 
			pos.x <= speedup_zone_bottom_right.x &&
			pos.y >= speedup_zone_top_left.y && 
			pos.y <= speedup_zone_bottom_right.y)

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# draw inner speedup zone
	draw_box(immediate_mesh, speedup_zone_top_left, speedup_zone_bottom_right)
	
	immediate_mesh.surface_end()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(position.x, target.global_position.y, position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()

func draw_box(immediate_mesh: ImmediateMesh, top_left: Vector2, bottom_right: Vector2) -> void:
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
