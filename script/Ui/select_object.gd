extends Control

var hovered: bool = false

## Linked to slot_selection scene.
## Emitted when the circle is full. Makes the slot selection scene appear with _on_full_circle.
signal item_fully_selected

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if hovered:
		$Circle.value += 2
		if $Circle.value >= $Circle.max_value:
			item_fully_selected.emit()

func _on_selected_object():
	hovered = true

func stop_processus():
	hovered = false
	$Circle.value = 0
