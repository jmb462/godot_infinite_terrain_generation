extends Node

var materials : Array = []
var material_names : Array = ["SeaTile", "SandTile", "GrassTile", "RockTile", "SnowTile"]

func _init():
    print("Loading tile materials")
    materials.append(preload("res://Resources/SeaTile.material"))
    materials.append(preload("res://Resources/SandTile.material"))
    materials.append(preload("res://Resources/GrassTile.material"))
    materials.append(preload("res://Resources/RockTile.material"))
    materials.append(preload("res://Resources/SnowTile.material"))

