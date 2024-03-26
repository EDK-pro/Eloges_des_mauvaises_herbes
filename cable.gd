extends RigidBody3D

signal cable_connected(item)
signal cable_disconnected()

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	cable_connected.emit(body)
	print(body)


func _on_body_shape_exited(_body_rid, _body, _body_shape_index, _local_shape_index):
	cable_disconnected.emit()
