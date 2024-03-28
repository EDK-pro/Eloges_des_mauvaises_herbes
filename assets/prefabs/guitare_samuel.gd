extends Area3D

@export var message: RichTextLabel
@export var samuel: AudioStreamPlayer3D


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("play_guitar"):
		samuel.play()
		return

func _on_body_entered(body):
	if str(body).get_slice(":",0) == "Player":
		var tween = get_tree().create_tween()
		tween.tween_property(message, "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC)


func _on_body_exited(body: Node3D) -> void:
	if str(body).get_slice(":",0) == "Player":
		var tween = get_tree().create_tween()
		tween.tween_property(message, "modulate:a", 0, 0.5).set_trans(Tween.TRANS_CUBIC)
