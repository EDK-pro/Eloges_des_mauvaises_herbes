extends Control

@export var message: Array[RichTextLabel] = []
@export var number: int = 0
@export var color: Color


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("advance_story"):
		var tween = get_tree().create_tween()
		tween.tween_property(message[number], "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC)
		await tween.finished
		print(number)
		number +=1
		return
