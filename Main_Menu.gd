extends Control

@export var bt_jouer:Button
@export var bt_controle:Button
@export var bt_credits:Button
@export var bt_quitter:Button
@export var bt_commencer:Button
@export var animator:AnimationPlayer
@export var Ui_Text:TextureRect
@export var credits:Control
@export var nextscene:PackedScene



func _on_controle_pressed() -> void:
	animator.play("credit")

func _on_bt_quitter_pressed():
	get_tree().quit()


func _on_bt_jouer_pressed():
	get_tree().change_scene_to_packed(nextscene)

func _on_bt_credits_pressed():
	credits.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(credits, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)

func _on_bt_control_pressed():
	Ui_Text.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)


func _on_button_credit_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(credits, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)



