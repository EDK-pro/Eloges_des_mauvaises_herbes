extends RigidBody3D

signal cable_connected(item)
signal cable_disconnected()

func _on_body_shape_entered(body_rid, body, body_shape_index, local_shape_index):
	cable_connected.emit(body)
	print(body)


func _on_body_shape_exited(body_rid, body, body_shape_index, local_shape_index):
	cable_disconnected.emit()
