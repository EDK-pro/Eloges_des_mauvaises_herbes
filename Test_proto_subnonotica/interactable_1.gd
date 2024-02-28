extends StaticBody3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(Input.mouse_mode)


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		print("roubeh")
	print(event)
	print("feur")
	print(Input.mouse_mode)


func _on_mouse_entered():
	print("coubeh")

func _input_event(camera, event, click_position, click_normal, shape_idx):
	if event is InputEventMouseButton:
		print("Mouse Click/Unclick at: ", event.position, " shape:", shape_idx)
		print(Input.mouse_mode)
