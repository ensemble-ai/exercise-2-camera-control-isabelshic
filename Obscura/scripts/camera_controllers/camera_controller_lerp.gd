class_name LerpCamera
extends CameraControllerBase

@export var follow_speed: float = 10.0
@export var catchup_speed: float = 10.0 
@export var leash_distance: float = 10.0  

var last_target_pos: Vector3

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
	
	var target_velocity = (target.position - last_target_pos) / delta
	
	var speed_multiplier = follow_speed if target_velocity.length() > 0.1 else catchup_speed
	
	# move camera to target
	var direction_to_target = target.position - position
	direction_to_target.y = 0
	
	if direction_to_target.length() > 0.01:
		var movement = direction_to_target.normalized() * speed_multiplier * delta
		if movement.length() > direction_to_target.length():
			movement = direction_to_target
		position += movement
	
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
	
	immediate_mesh.surface_end()
	material.shading_mode = BaseMaterial3D.SHADING_MODE_UNSHADED
	material.albedo_color = Color.WHITE
	
	add_child(mesh_instance)
	mesh_instance.global_transform = Transform3D.IDENTITY
	mesh_instance.global_position = Vector3(position.x, target.global_position.y, position.z)
	
	await get_tree().process_frame
	mesh_instance.queue_free()
