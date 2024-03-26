extends StaticBody3D

signal player_can_climb(can_climb, faupeil)

func _on_area_3d_body_entered(body):
	if str(body).get_slice(":",0) == "Player":
		player_can_climb.emit(true,self)

func _on_area_3d_body_exited(body):
	if str(body).get_slice(":",0) == "Player":
		player_can_climb.emit(false,self)
