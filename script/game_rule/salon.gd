extends Node

@export var marginTime : int = 150
@export var symbolCount : int = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false

var goutte_loaded = load("res://goutte_ploc.tscn")
var scene_goutte
func _ready():
	## Array to get all the pickable item. Used to easily connect all nodes together
	var pickable_array: Array = get_tree().get_nodes_in_group("pickable_item")
	## Array to get each circles that will loop around pickable item. Used to know when their full. 
	var circle_array: Array = get_tree().get_nodes_in_group("circle_around_item")
	
	$Player/Player_scene/Player/Cable.cable_connected.connect(talkWith.bind())
	$Player/Player_scene/Player/Cable.cable_disconnected.connect(endTalk.bind())
	## For each interactable item 
	for i in pickable_array.size() :
		print(pickable_array[i])
		## When slot clicked, reset the circles
		$UI/Slot_selection.slot_accepted.connect(pickable_array[i]._stop_value_circle.bind())
		## When slot clicked, put an item in if available
		$UI/Slot_selection.slot_accepted.connect(pickable_array[i]._on_click.bind())
		## When an item is clicked, makes the circle appear
		$Player/Player_scene/Player.hover_object.connect(pickable_array[i]._hovered.bind())
		## When item is placed in slot, put it on the correct slot on the player
		pickable_array[i].item_placed.connect($Player/Player_scene/Player._on_pick_up.bind())
		## When the circle is full, makes the slot selection menu appaer
		circle_array[i].item_fully_selected.connect($UI/Slot_selection._on_full_circle.bind())
		## When the object is thrown out, remove it from slot
		$Player/Player_scene/Player.throw_object.connect(pickable_array[i]._on_click.bind())

func _process(delta):
	if scene_goutte == null:
		scene_goutte = goutte_loaded.instantiate()
		scene_goutte.position = $Static/props/test_escabeau.position + Vector3(0,7,0)
		scene_goutte.crushed = $Player/Player_scene/Player.audio_state
		scene_goutte.watering.connect($GazLamp._wet_lamp.bind())
		add_child(scene_goutte)

func endTalk():
	$UI/Talk.hide()

func talkWith(item):
	var marginTime: int
	var symbolCount: int
	var communicationDuration: float
	var correctArray: Array
	var talkative_name = str(item).get_slice(":",0)
	print("Bah alors ",  talkative_name)
	if talkative_name == "book_shelf":
		marginTime = 250
		symbolCount = 4.0
		communicationDuration = 5.0
		correctArray = [0,1,0,1]
		$UI/Talk.show()
		$UI/Talk.initialize(marginTime, symbolCount, communicationDuration,correctArray)
