extends MeshInstance

enum TYPE { WATER, SAND, GRASS, ROCK, SNOW}
var type : int = TYPE.WATER

onready var hexagon_material : SpatialMaterial = get_surface_material(0)

func _ready():
	pass

func set_type(p_type : int) -> void:
	if p_type != type:
		hexagon_material.uv1_offset.x = 0.1 * p_type
		type = p_type

func set_position(p_position : Vector3) -> void:
	translation = p_position
