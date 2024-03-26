extends Area3D

@export var next_scene: PackedScene
@export var Ui_Text_Salon:Control
@export var Ui_Fondu:Control

func teleport() -> void:
	Ui_Text_Salon.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text_Salon, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)

func _on_body_entered(body):
	print("feur")
	var player = str(body).get_slice(":",0)
	if player == "Player2D":
		teleport()

func tween_finished():
	get_tree().change_scene_to_packed(next_scene)

func _on_button_yes_pressed():
	var tweeen = get_tree().create_tween()
	tweeen.tween_property(Ui_Text_Salon, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Fondu, "color",Color(0.0,0.0,0.0,1.0), 2).set_trans(Tween.TRANS_CUBIC)
	tween.connect("finished",tween_finished)


func _on_button_no_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text_Salon, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
