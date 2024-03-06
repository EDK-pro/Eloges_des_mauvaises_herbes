extends Control

var hovered: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		$Circle.value += 1

func _on_selected_object():
	hovered = true
