class_name CameraControllerBase
extends Camera3D


@export var target:Vessel
@export var dist_above_target:float = 100.0
@export var zoom_speed:float = 10.0
@export var min_zoom:float = 5.0
@export var max_zoom:float = 100.0
@export var draw_camera_logic:bool = false

#camera tilt around the z axis in radians
#var _camera_tilt_rad:float = 0.0
#var _camera_tilt_speed:float = 0.1

func _ready() -> void:
	current = false
	position += Vector3(0.0, dist_above_target, 0.0) 


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("fire1"):
		draw_camera_logic = !draw_camera_logic
	if Input.is_action_pressed("zoom_in"):
		dist_above_target = clampf(dist_above_target - zoom_speed * delta, min_zoom, max_zoom)
	if Input.is_action_pressed("zoom_out"):
		dist_above_target = clampf(dist_above_target + zoom_speed * delta, min_zoom, max_zoom)
	
	#camera tilt code for the brave
	#if Input.is_action_pressed("camera_tilt_left"):
		#_camera_tilt_rad += _camera_tilt_speed * delta
		#rotation.z = _camera_tilt_rad
	#elif Input.is_action_pressed("camera_tilt_right"):
		#_camera_tilt_rad -= _camera_tilt_speed * delta
		#rotation.z = _camera_tilt_rad
	#else:
		#_camera_tilt_rad += -signf(_camera_tilt_rad) * _camera_tilt_speed * delta
		#if abs(_camera_tilt_rad) < 0.01:
			#_camera_tilt_rad = 0.0
		#rotation.z = _camera_tilt_rad
		
	position.y = target.position.y + dist_above_target



func draw_logic() -> void:
	pass
