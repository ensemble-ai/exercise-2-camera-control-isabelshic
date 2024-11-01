class_name LeadingLerpCamera
extends CameraControllerBase

@export var lead_speed: float = 15.0 
@export var catchup_delay_duration: float = 0.5
@export var catchup_speed: float = 10.0 
@export var leash_distance: float = 10.0

var time_since_movement: float = 0.0
var last_input_direction: Vector2 = Vector2.ZERO

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
	
	# input direction
	var input_dir = Vector2(
		Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"),
		Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	).limit_length(1.0)
	
	# update last input 
	if input_dir.length() > 0.1:
		last_input_direction = input_dir
		time_since_movement = 0.0
	else:
		time_since_movement += delta
	
	# desired camera position
	var desired_position = position
	
	if input_dir.length() > 0.1:
		var lead_target = target.position + Vector3(last_input_direction.x, 0, last_input_direction.y) * leash_distance
		desired_position = lead_target
	elif time_since_movement >= catchup_delay_duration:
		desired_position = target.position
	
	# move camera
	var direction_to_desired = desired_position - position
	direction_to_desired.y = 0
	
	var current_speed = lead_speed if input_dir.length() > 0.1 else catchup_speed
	
	if direction_to_desired.length() > 0.01:
		var movement = direction_to_desired.normalized() * current_speed * delta
		if movement.length() > direction_to_desired.length():
			movement = direction_to_desired
		position += movement
	
	# check leash distance
	var distance_to_target = (target.position - position)
	distance_to_target.y = 0 
	if distance_to_target.length() > leash_distance:
		var leash_direction = distance_to_target.normalized()
		position = target.position - (leash_direction * leash_distance)
		position.y = target.position.y + dist_above_target
	
	if draw_camera_logic:
		draw_logic()

func draw_logic() -> void:
	var mesh_instance := MeshInstance3D.new()
	var immediate_mesh := ImmediateMesh.new()
	var material := ORMMaterial3D.new()
	
	mesh_instance.mesh = immediate_mesh
	mesh_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	
	# draw cross
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES, material)
	
	# horizontal line
	immediate_mesh.surface_add_vertex(Vector3(-2.5, 0, 0))
	immediate_mesh.surface_add_vertex(Vector3(2.5, 0, 0))
	
	# vertical line
	immediate_mesh.surface_add_vertex(Vector3(0, 0, -2.5))
	immediate_mesh.surface_add_vertex(Vector3(0, 0, 2.5))
	
	# input direction indicator if moving
	if last_input_direction.length() > 0.1:
		var end = Vector3(last_input_direction.x, 0, last_input_direction.y) * 3.0
		immediate_mesh.surface_add_vertex(Vector3.ZERO)
		immediate_mesh.surface_add_vertex(end)
	
	immediate_mesh.surface_end()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(position.x, target.global_position.y, position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
