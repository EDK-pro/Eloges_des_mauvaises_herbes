extends Control

@export var message: Array[RichTextLabel] = []
@export var number: int = 0
@export var color: Color


func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_story"):
		if number < message.size():
			var pitch_shift: float = randf_range(0.95,1.05)
			var volume_shift: float = randf_range(-1.0,0.0)
			$AudioStreamPlayer.pitch_scale = pitch_shift
			$AudioStreamPlayer.volume_db = volume_shift
			$AudioStreamPlayer.play()
			var tween = get_tree().create_tween()
			tween.tween_property(message[number], "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC)
			await tween.finished
		else:
			$CanvasLayer/ColorRect.material.set_shader_parameter("smear",2.0)
		print(number)
		number +=1
		return
