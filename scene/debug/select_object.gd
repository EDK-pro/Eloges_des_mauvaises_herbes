extends Control

var hovered: bool = false
signal item_fully_selected
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		$Circle.value += 1
		if $Circle.value >= 100:
			item_fully_selected.emit()

func _on_selected_object():
	hovered = true
