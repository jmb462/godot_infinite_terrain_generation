extends Spatial

var map_position = Vector2.ZERO

# Player properties
export var speed : float = 20.0
export var mouse_sensitivity : float = 0.2
var direction : Vector2 = Vector2.ZERO

# Camera properties
var zoom_speed : float = 4.0
var fov_target : float = 110.0
var cam_roll_target : float = 0.0
var cam_rotation_target : float = 0.0
var rotation_speed : float = 4.0
var camera_roll_attentuation : float = 0.2

# Node references
onready var world_camera : Camera = $CameraAnchor/Camera
onready var camera_anchor : Spatial = $CameraAnchor
onready var map : Spatial = $Map

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta) -> void:

	# Update camera movements interpolation
	if world_camera.fov != fov_target:
		world_camera.fov = lerp(world_camera.fov, fov_target, delta * zoom_speed)
	if cam_rotation_target != camera_anchor.rotation_degrees.y:
		camera_anchor.rotation_degrees.y = lerp(camera_anchor.rotation_degrees.y, cam_rotation_target, delta * rotation_speed)
	if camera_anchor.rotation_degrees.z != cam_roll_target:
		camera_anchor.rotation_degrees.z = lerp(camera_anchor.rotation_degrees.z, cam_roll_target, delta * rotation_speed/5.0)
	if cam_roll_target != 0:
		cam_roll_target = lerp(cam_roll_target, 0.0, camera_roll_attentuation)
	
	# Get direction
	direction = Vector2(0,-1).rotated(deg2rad(-camera_anchor.rotation_degrees.y))
	
	# Move the camera
	if direction != Vector2.ZERO:
		direction=direction.normalized()
		camera_anchor.translation += Vector3(direction.x, 0, direction.y) * delta * speed

	# Check if we need to regenerate map
	var new_position = Vector2(camera_anchor.translation.x, camera_anchor.translation.z).floor()

	if map_position.x!=new_position.x or map_position.y!=new_position.y:
		map.translation+=Vector3(sign(new_position.x-map_position.x),0,sign(new_position.y-map_position.y))
		map_position = new_position
		map.update(map_position)
	
		
func _input(event):
	# FOV control with mouse_wheel
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_WHEEL_DOWN:
			fov_target=clamp(fov_target + 2, 40, 130)
		if event.button_index==BUTTON_WHEEL_UP:
			fov_target=clamp(fov_target - 2, 40, 130)
	
	# Roll the view while turning
	if event is InputEventMouseMotion:
		var turn = clamp(event.relative.x, -20.0, 20.0)
		cam_rotation_target = cam_rotation_target-turn * mouse_sensitivity / 2
		cam_roll_target = clamp(cam_roll_target-event.relative.x * mouse_sensitivity * 2,-60, 60)
