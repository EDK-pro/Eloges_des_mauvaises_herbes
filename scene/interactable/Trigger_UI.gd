extends Area3D

@export var Ui_Text:Control
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	Ui_Text.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
	pass # Replace with function body.


func _on_body_exited(body):
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
