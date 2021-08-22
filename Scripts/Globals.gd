extends Node


enum TYPE { WATER, SAND, GRASS, ROCK, SNOW }

var materials : Array = []

func _init():
    print("Loading tile materials")
    materials.append(preload("res://Resources/SeaTile.material"))
    materials.append(preload("res://Resources/SandTile.material"))
    materials.append(preload("res://Resources/GrassTile.material"))
    materials.append(preload("res://Resources/RockTile.material"))
    materials.append(preload("res://Resources/SnowTile.material"))

