extends Area3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	print(Input.mouse_mode)
	print("feur")


func _on_area_entered(area):
	print(area)
	print("coubeh") 


func _on_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	print(area)
	print("coubeh")


func _on_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		print("roubeh")
