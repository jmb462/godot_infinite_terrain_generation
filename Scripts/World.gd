extends Spatial

var map_position = Vector2.ZERO

var speed : float = 20.0
var zoom_speed : float = 4.0

export var tile_offset = 1.5

export var mouse_sensitivity = 0.2
export var fix_cam_direction = 90
onready var world_camera = $CameraAnchor/Camera
onready var camera_anchor = $CameraAnchor
onready var fov_target = world_camera.fov
onready var cam_rotation_target = camera_anchor.rotation_degrees.y
var rotation_speed : float = 10.0
onready var map = $Map

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _process(delta) -> void:

	# Update fov changes interpolation
	if world_camera.fov != fov_target:
		world_camera.fov = lerp(world_camera.fov, fov_target, delta * zoom_speed)
	if cam_rotation_target != camera_anchor.rotation_degrees.y:
		camera_anchor.rotation_degrees.y = lerp(camera_anchor.rotation_degrees.y, cam_rotation_target, delta * rotation_speed)
	# Get direction
	#var direction : Vector2 = Vector2(0,0)
	# if Input.is_action_pressed("ui_left"):
	# 	direction+=Vector2(-1,0)
	# if Input.is_action_pressed("ui_right"):
	# 	direction+=Vector2(1,0)
	# if Input.is_action_pressed("ui_up"):
	# 	direction+=Vector2(0,-1)
	# if Input.is_action_pressed("ui_down"):
	# 	direction+=Vector2(0,1)
	if Input.is_action_pressed("ui_up"): 
		var direction = Vector2(0,-1).rotated(deg2rad(-camera_anchor.rotation_degrees.y))
		direction=direction.normalized()

		# Move the camera
		camera_anchor.translation += Vector3(direction.x, 0, direction.y) * delta * speed

	# Check if we need to recalcute map
	var old_pos_x = map_position.x
	var old_pos_y = map_position.y

	var new_pos_x = floor(camera_anchor.translation.x/tile_offset)
	var new_pos_y = floor(camera_anchor.translation.z/tile_offset)

	if old_pos_x!=new_pos_x and old_pos_y!=new_pos_y:
		map_position.x = new_pos_x
		map_position.y = new_pos_y
		map.update(map_position)
		map.translation+=Vector3(tile_offset*sign(new_pos_x-old_pos_x),0,tile_offset*sign(new_pos_y-old_pos_y))

	elif old_pos_x != new_pos_x:
		map_position.x = new_pos_x
		map.update(map_position)
		map.translation.x+=tile_offset*sign(new_pos_x-old_pos_x)

	elif old_pos_y != new_pos_y:
		map_position.y = new_pos_y
		map.update(map_position)
		map.translation.z+=tile_offset*sign(new_pos_y-old_pos_y)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_WHEEL_DOWN:
			fov_target=clamp(fov_target+2, 20, 110)
			print(fov_target)

		if event.button_index==BUTTON_WHEEL_UP:
			fov_target=clamp(fov_target-2, 20, 110)
			print(fov_target)

	if event is InputEventMouseMotion:
		cam_rotation_target = cam_rotation_target-event.relative.x * mouse_sensitivity
