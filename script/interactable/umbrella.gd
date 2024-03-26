extends RigidBody3D

@export var lightHint: Timer
@export var light: OmniLight3D
@export var lightfinisher: Timer

func _on_light_timer_timeout():
	var tween = get_tree().create_tween()
	
	tween.tween_property(light, "light_energy", 5.511, 1.0).set_trans(Tween.TRANS_CUBIC)
	lightfinisher.start()



func _on_finish_timer_timeout():
	var tween = get_tree().create_tween()
	tween.tween_property(light, "light_energy", 0.0, 0.5).set_trans(Tween.TRANS_BACK)
	lightHint.start()

