extends Control

var hovered: bool = false

## Linked to slot_selection scene.
## Emitted when the circle is full. Makes the slot selection scene appear with _on_full_circle.
signal item_fully_selected

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if hovered:
		$Circle.value += 1
		if $Circle.value >= $Circle.max_value:
			item_fully_selected.emit()

func _on_selected_object():
	hovered = true

func stop_processus():
	hovered = false
	$Circle.value = 0
