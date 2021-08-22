extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var fps_label : Label = $Background/FPS

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



func _process(delta):
	fps_label.text = str(Performance.get_monitor(Performance.TIME_FPS))
