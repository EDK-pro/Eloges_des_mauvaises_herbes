extends Control

@export var Ui_Reset_Button:Control
@export var Ui_Text_Arrivee:Control
@export var Ui_Text_Item:Control
@export var Ui_Tab:Control

var tuto_item_once: bool = true
# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.visual_degradation.connect(change_shader_quality.bind())
	$SubViewportContainer/SubViewport/Salon_Proto.not_bright_enough.connect(_not_bright_enough.bind())
	$SubViewportContainer/SubViewport/Salon_Proto/Static/Fauteil.player_can_climb.connect(_space_bar.bind())
	Ui_Text_Arrivee.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text_Arrivee, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $SubViewportContainer/SubViewport/Salon_Proto.text_item_appearing:
		_text_item_appear()
		$SubViewportContainer/SubViewport/Salon_Proto.text_item_appearing = false
	if $SubViewportContainer/SubViewport/Salon_Proto.text_tab_appearing:
		_text_tab_appear()
		$SubViewportContainer/SubViewport/Salon_Proto.text_tab_appearing = false

func change_shader_quality(indice):
	if $SubViewportContainer.material.get_shader_parameter("enable_recolor"):
		var tweeen = get_tree().create_tween()
		Ui_Reset_Button.show()
		tweeen.tween_property(Ui_Reset_Button,"modulate",Color(1.0,1.0,1.0,1.0), 10.0 ).set_trans(Tween.TRANS_CUBIC)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if $SubViewportContainer.material.get_shader_parameter("target_resolution_scale") == indice:
		$SubViewportContainer.material.set_shader_parameter("enable_recolor",true)
	else:
		$SubViewportContainer.material.set_shader_parameter("target_resolution_scale",indice)

func reset_shader():
	$SubViewportContainer.material.set_shader_parameter("target_resolution_scale",3)
	$SubViewportContainer.material.set_shader_parameter("enable_recolor",false)

func _text_item_appear():
	if tuto_item_once:
		Ui_Text_Item.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(Ui_Text_Item, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
		$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		tuto_item_once = false
		Ui_Text_Arrivee.visible = false

func _text_tab_appear():
	Ui_Tab.visible = true
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Tab, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Ui_Text_Item.visible = false

func _not_bright_enough():
	$Hint.show()
	$Hint/Label.text = "Il fait trop sombre pour trouver l'embout de l'appareil"

func _space_bar(can_climb, _item):
	if can_climb:
		$Hint.show()
		$Hint/Label.text = "Appuyez sur la barre espace"
	else:
		$Hint.hide()

func _on_button_reset_pressed():
	get_tree().reload_current_scene()
	reset_shader()

func _on_button_arrivee_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text_Arrivee, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_item_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Text_Item, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_button_tab_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Tab, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
