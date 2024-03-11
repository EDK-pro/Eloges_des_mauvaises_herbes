extends Node

@export var marginTime : int = 150
@export var symbolCount : int = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false

func _ready():
	## Array to get all the pickable item. Used to easily connect all nodes together
	var pickable_array: Array = get_tree().get_nodes_in_group("pickable_item")
	## Array to get each circles that will loop around pickable item. Used to know when their full. 
	var circle_array: Array = get_tree().get_nodes_in_group("circle_around_item")
	
	$Salle/Meshchange/Mesh.mesh = load("res://assets/Test_assets/Assets/column.obj")
	
	## For each interactable item 
	for i in pickable_array.size() :
		print(pickable_array[i])
		## When slot clicked, reset the circles
		$Slot_selection.slot_accepted.connect(pickable_array[i]._stop_value_circle.bind())
		## When slot clicked, put an item in if available
		$Slot_selection.slot_accepted.connect(pickable_array[i]._on_click.bind())
		## When an item is clicked, makes the circle appear
		$Player.hover_object.connect(pickable_array[i]._hovered.bind())
		## When item is placed in slot, put it on the correct slot on the player
		pickable_array[i].item_placed.connect($Player._on_pick_up.bind())
		## When the circle is full, makes the slot selection menu appaer
		circle_array[i].item_fully_selected.connect($Slot_selection._on_full_circle.bind())
		## When the object is thrown out, remove it from slot
		$Player.throw_object.connect(pickable_array[i]._on_click.bind())

func _process(delta):
	talkWith(marginTime, symbolCount, communicationDuration)
	$Salle/Meshchange/UI_handler.look_at($Player.position)
	$Salle/Meshchange/UI_handler.rotation.x = deg_to_rad(10)
	$Salle/Meshchange/UI_handler.rotation.z = deg_to_rad(10)
	
func talkWith(marginTime: int, symbolCount: int, communicationDuration: float):
	if Input.is_action_just_pressed("envoi_parole"):
		if isDialogVisible:
			$Talk.hide()
			isDialogVisible = false
		else:
			$Talk.show()
			$Talk.initialize(marginTime, symbolCount, communicationDuration)
			isDialogVisible = true
