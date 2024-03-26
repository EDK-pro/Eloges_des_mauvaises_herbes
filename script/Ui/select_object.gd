extends Control

var hovered: bool = false
var occupied_slots:Array[bool] = [false,false,false]
## Linked to slot_selection scene.
## Emitted when the circle is full. Makes the slot selection scene appear with _on_full_circle.
signal item_fully_selected(occupied_slots)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if hovered:
		$Circle.value += 2
		if $Circle.value >= $Circle.max_value:
			item_fully_selected.emit(occupied_slots)

func _on_selected_object(slots):
	hovered = true
	for i in 3:
		if slots[i] == null:
			occupied_slots[i] = false
		else:
			occupied_slots[i] = true

func stop_processus():
	hovered = false
	$Circle.value = 0
