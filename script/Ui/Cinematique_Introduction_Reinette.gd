extends VideoStreamPlayer

@export var nextscene:PackedScene

func _process(delta):
	if Input.is_action_just_pressed("advance_story"):
		_on_finished()

func _on_finished():
	get_tree().change_scene_to_packed(nextscene)
