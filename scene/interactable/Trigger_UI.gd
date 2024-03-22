extends Area3D

var player_movement_available: bool = true
var body_once: bool = false
@export var Ui_Text:Control
# Called when the node enters the scene tree for the first time.
func _ready():
	Ui_Text.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
	player_movement_available = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
	player_movement_available = true
