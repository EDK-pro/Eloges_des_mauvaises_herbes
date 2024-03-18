@tool
extends Area3D

@export var next_scene: PackedScene

func teleport() -> void:
	get_tree().change_scene_to_packed(next_scene)


func _on_body_entered(body):
	teleport()
