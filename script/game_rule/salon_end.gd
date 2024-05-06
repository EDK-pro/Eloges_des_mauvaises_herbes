extends Node

@export var marginTime : int = 150
@export var symbolCount : float = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false

@export var Ui_Fondu:Control
@export var Ui_Reset_Button:Control
@export var Ui_Slot_Selection:Control
@export var Ui_Hint:Control
@export var Ui_Hint_Label:Control

##var player et les objets
@export var player: CharacterBody3D
@export var sofa:StaticBody3D
@export var ambient_sound:AudioStreamPlayer3D
@export var test: int = 0
var tuto_item_once: bool = true
var text_item_appearing: bool = false
var text_tab_appearing:bool = false
var text_talk_appearing:bool = false


var pickable_array: Array
var circle_array: Array

var goutte_loaded = load("res://interactable_object/goutte_ploc.tscn")
var scene_goutte 

var tuto_talk_once: bool = true

var shader_readable:bool = false

signal not_bright_enough

func _ready():
	## Array to get all the pickable item. Used to easily connect all nodes together
	pickable_array = get_tree().get_nodes_in_group("pickable_item")
	## Array to get each circles that will loop around pickable item. Used to know when their full. 
	circle_array = get_tree().get_nodes_in_group("circle_around_item")
	print(pickable_array.size(),circle_array.size())
	#Ui_Text_Arrivee.visible = true
	#var tween = get_tree().create_tween()
	#tween.tween_property(Ui_Text_Arrivee, "scale", Vector2(1,1), 2).set_trans(Tween.TRANS_CUBIC)
	#$Player/Player_scene/Player.can_move = false
	sofa.player_can_climb.connect($Player/Player_scene._can_climb.bind())
	## For each interactable item 
	for i in pickable_array.size() :
		print(pickable_array[i]," [] ",circle_array[i])
		## When slot clicked, reset the circles
		#$UI/Slot_selection.slot_accepted.connect(pickable_array[i]._stop_value_circle.bind())
		## When slot clicked, put an item in if available
		#$UI/Slot_selection.slot_accepted.connect(pickable_array[i]._on_click.bind())
		## When an item is clicked, makes the circle appear
		player.hover_object.connect(pickable_array[i]._hovered.bind())
		## When item is placed in slot, put it on the correct slot on the player
		pickable_array[i].item_placed.connect(player._on_pick_up.bind())
		## When the circle is full, makes the slot selection menu appaer
		#circle_array[i].item_fully_selected.connect($UI/Slot_selection._on_full_circle.bind())
		## When the object is thrown out, remove it from slot
		player.throw_object.connect(pickable_array[i]._on_click.bind())

	player.visual_degradation.connect(change_shader_quality.bind())
	sofa.player_can_climb.connect(_space_bar.bind())

	print(flowerwall_pp_autoload.preblur_x_shader.get("shader_parameter/radius"), " | ",flowerwall_pp_autoload.preblur_y_shader.get("shader_parameter/radius"))
	print(flowerwall_pp_autoload.crt_shader.get("shader_parameter/chromatic_aberration_strength"))
	toggle_shader_readability()
	for i in pickable_array.size():
		## when slot clicked, reset the circle
		Ui_Slot_Selection.slot_accepted.connect(pickable_array[i]._stop_value_circle.bind())
		Ui_Slot_Selection.slot_accepted.connect(pickable_array[i]._on_click.bind())
		## when slot clicked, put an item in if avaible
		circle_array[i].item_fully_selected.connect(Ui_Slot_Selection._on_full_circle.bind())
	player.can_move = true

func _input(event):
	if event.is_action_pressed("light"):
		$Environnement/SpotLight3D.spot_angle = 80.0
		$Environnement/SpotLight3D.light_energy = 1.5
	if Input.is_action_just_pressed("yeet_item"):
		#Ui_Slot_Selection.visible = !Ui_Slot_Selection.visible
		if !Ui_Slot_Selection.visible:
			var occupied_slots:Array[bool] = [true,true,true]
			for i in 3:
				if player.slots[i] == null:
					occupied_slots[i] = false
			Ui_Slot_Selection._on_full_circle(occupied_slots) 
		else:
			Input.mouse_mode = (2 - Input.mouse_mode)
			Ui_Slot_Selection.visible = !Ui_Slot_Selection.visible

func _process(_delta):
	if !ambient_sound.playing and player.audio_state == 2:
		ambient_sound.play()
	#print(Input.mouse_mode)
	if scene_goutte == null:
		scene_goutte = goutte_loaded.instantiate()
		scene_goutte.position = $Static/Fauteil.position + Vector3(0,7,0)
		scene_goutte.crushed = $Player/Player_scene/Player.audio_state
		scene_goutte.watering.connect($GazLamp._wet_lamp.bind())
		add_child(scene_goutte)
	#if $Player/Player_scene/Player.visual_state == 3:
		#_end_demo()
		# flowerwall_pp_autoload.dither_shader.set("shader_parameter/dithering", test)


func _end_demo():
	var tweeen = get_tree().create_tween()
	tweeen.tween_property(Ui_Fondu, "color", Color(0.0,0.0,0.0,1.0), 2).set_trans(Tween.TRANS_CUBIC)
	#for i in 4:
		#$Player/Player_scene/Player.visual_degradation.emit(6)

func change_shader_quality(indice):
	if flowerwall_pp_autoload.dither_shader.get("shader_parameter/enable_recolor"):
		var tweeen = get_tree().create_tween()
		Ui_Reset_Button.show()
		tweeen.tween_property(Ui_Reset_Button,"modulate",Color(1.0,1.0,1.0,1.0), 10.0 ).set_trans(Tween.TRANS_CUBIC)
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if flowerwall_pp_autoload.dither.get("shader_parameter/resolution_scale") == indice:
		flowerwall_pp_autoload.dither_shader.set("shader_parameter/enable_recolor", true)
	else:
		flowerwall_pp_autoload.dither_shader.set("shader_parameter/resolution_scale",indice)


func reset_shader():
	flowerwall_pp_autoload.dither_shader.set("shader_parameter/resolution_scale",3)
	flowerwall_pp_autoload.dither_shader.set("shader_parameter/enable_recolor", false)


func _on_button_reset_pressed():
	get_tree().reload_current_scene()
	reset_shader()

func _space_bar(can_climb, _item):
	if can_climb:
		Ui_Hint.show()
		Ui_Hint_Label.text = "Appuyez sur la barre espace"
	else:
		Ui_Hint.hide()
		
		
func _end_game():
	reset_shader()


func toggle_shader_readability():
	var tween_shader = get_tree().create_tween()
	if shader_readable:
		tween_shader.tween_method(_shader_readability,0.0,1.0,2.0)
	else:
		tween_shader.tween_method(_shader_readability,1.0,0.0,2.0)
	shader_readable = !shader_readable

func _shader_readability(end_value : float):
	flowerwall_pp_autoload.preblur_x_shader.set("shader_parameter/radius", end_value * 3.0)
	flowerwall_pp_autoload.preblur_y_shader.set("shader_parameter/radius", end_value * 3.0)
	flowerwall_pp_autoload.crt_shader.set("shader_parameter/chromatic_aberration_strength", end_value * 6.0)


func _on_end_body_entered(body):
	print(str(body).get_slice(":",0))
	if str(body).get_slice(":",0) == "Player":
		print("coubeh")
		Ui_Fondu.show()
		var tween = get_tree().create_tween()
		tween.tween_property(Ui_Fondu, "color", Color(0.326,0.326,0.326,1.0), 3).set_trans(Tween.TRANS_CUBIC)