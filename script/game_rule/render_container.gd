extends Control

@export var Ui_Reset_Button:Control
@export var Ui_Text_Arrivee:Control
@export var Ui_Text_Item:Control
@export var Ui_Tab:Control
@export var Ui_Slot_Selection:Control
@export var Ui_Talk:Control

@export var End_Game:PackedScene


var tuto_item_once: bool = true
var tuto_talk_once: bool = true
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
	$SubViewportContainer/SubViewport/Salon_Proto.Ui_Talk.reussite_signal.connect(_end_game.bind())
	for i in $SubViewportContainer/SubViewport/Salon_Proto.pickable_array.size():
		## When slot clicked, reset the circles
		Ui_Slot_Selection.slot_accepted.connect($SubViewportContainer/SubViewport/Salon_Proto.pickable_array[i]._stop_value_circle.bind())
		## When slot clicked, put an item in if available
		Ui_Slot_Selection.slot_accepted.connect($SubViewportContainer/SubViewport/Salon_Proto.pickable_array[i]._on_click.bind())
		$SubViewportContainer/SubViewport/Salon_Proto.circle_array[i].item_fully_selected.connect(Ui_Slot_Selection._on_full_circle.bind())
		$SubViewportContainer/SubViewport/Salon_Proto.circle_array[i].item_fully_selected.connect(_text_item_appear.bind())
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if $SubViewportContainer/SubViewport/Salon_Proto.text_item_appearing:
		_text_item_appear(1)
		$SubViewportContainer/SubViewport/Salon_Proto.text_item_appearing = false
	if $SubViewportContainer/SubViewport/Salon_Proto.text_tab_appearing:
		_text_tab_appear()
		$SubViewportContainer/SubViewport/Salon_Proto.text_tab_appearing = false
		
	if $SubViewportContainer/SubViewport/Salon_Proto.text_talk_appearing:
		_text_talk_appearing()
	if Input.is_action_just_pressed("yeet_item"):
		#Ui_Slot_Selection.visible = !Ui_Slot_Selection.visible
		#Input.mouse_mode = (2 - Input.mouse_mode)
		if !Ui_Slot_Selection.visible:
			var occupied_slots:Array[bool] = [true,true,true]
			for i in 3:
				if $SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.slots[i] == null:
					occupied_slots[i] = false
			Ui_Slot_Selection._on_full_circle(occupied_slots) 
		else:
			Input.mouse_mode = (2 - Input.mouse_mode)
			Ui_Slot_Selection.visible = !Ui_Slot_Selection.visible
		#Input.mouse_mode = (2 - Input.mouse_mode)
	if $SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.tuto_tab == 1:
		$SubViewportContainer/SubViewport/Salon_Proto.text_tab_appearing = true
		$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.tuto_tab = 2
	
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

func _text_item_appear(_on_ignore):
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


func _end_game():
	reset_shader()
	get_tree().change_scene_to_packed(End_Game)

func _text_talk_appearing():
	if tuto_talk_once:
		Ui_Talk.visible = true
		var tween = get_tree().create_tween()
		tween.tween_property(Ui_Talk, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
		$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = false
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		tuto_talk_once = false

func _on_button_talk_pressed():
	var tween = get_tree().create_tween()
	tween.tween_property(Ui_Talk, "scale", Vector2(), 1).set_trans(Tween.TRANS_CUBIC)
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.can_move = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
