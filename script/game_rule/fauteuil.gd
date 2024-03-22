extends StaticBody3D

signal player_can_climb(can_climb, faupeil)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_3d_body_entered(body):
	if str(body).get_slice(":",0) == "Player":
		player_can_climb.emit(true,self)

func _on_area_3d_body_exited(body):
	if str(body).get_slice(":",0) == "Player":
		player_can_climb.emit(false,self)
