extends Spatial

enum TYPE { WATER, SAND, GRASS, ROCK, SNOW}

onready var tile_packed_scene : PackedScene = preload("res://Scenes/HexagonMeshInstance.tscn")

# Data array store tile references
var data : Array = []
var map_size : Vector2 = Vector2(70,70)
# Noise used for map generation
var noise : OpenSimplexNoise
# Ratio Width / Height of hexagonal tiles
export var ratio = sin(PI / 3.0)

var altitude : float = 0.0

var elevation_factor : float = 2.5
export var sea_level : float = -0.3
export var top_level : float = 0.8
export var rock_level : float = 0.6
export var grass_level : float = 0.2
export var sand_level : float = 0.1

func _ready() -> void:
	create_noise()
	create_tiles(map_size)

func create_noise(p_seed : int = 0) -> void:
	noise = OpenSimplexNoise.new()
	noise.seed = p_seed
	noise.octaves = 3
	noise.period = 20
	noise.persistence = 0.8
	noise.lacunarity = 2

func create_tiles(p_map_size) -> void:
	for x in p_map_size.x:
		var row = []
		for y in p_map_size.y:			
			var a_tile = tile_packed_scene.instance()
			add_child(a_tile)
			row.append(a_tile)
		data.append(row)
	update()

func update(map_position: Vector2 = Vector2.ZERO) -> void:
	for x in map_size.x:
		for y in map_size.y:
			var a_tile : MeshInstance = data[x][y]
			altitude = noise.get_noise_2d(x + map_position.x, y + map_position.y) * elevation_factor
			
			if altitude <= sea_level:
				a_tile.set_type(TYPE.WATER)
				altitude = sea_level
			elif altitude > top_level:
				a_tile.set_type(TYPE.SNOW)
				altitude *= 1.5
			elif altitude > rock_level:
				a_tile.set_type(TYPE.ROCK)
				altitude *= 1.25
			elif altitude > grass_level:
				a_tile.set_type(TYPE.GRASS)
			elif altitude > sand_level:
				a_tile.set_type(TYPE.SAND)
		
			else:
				a_tile.set_type(TYPE.SAND)
			
			a_tile.translation = Vector3((-map_size.x / 2.0 + x) , altitude,(-map_size.y / 2.0 + y))
			if  (int(map_position.y) % 2 == 0 and y % 2 == 1) or (int(map_position.y) % 2 != 0 and y % 2 == 0):
				a_tile.translation.x += 0.5

func get_altitude(map_position: Vector2 = Vector2.ZERO):
	return altitude