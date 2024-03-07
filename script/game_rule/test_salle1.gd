extends Node

@export var marginTime : int = 150
@export var symbolCount : int = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false

func _ready():
	#$Control.btn_deplacement.connect($Player_constraint._on_appuie_des_boutons.bind())
	#$Salle/Interactable_action/Hitbox.shape.size = Vector3(2,2,2)s
	$Salle/Meshchange/Mesh.mesh = load("res://assets/Test_assets/Assets/column.obj")
	#$Player.hover_object.connect($Select_Object._on_selected_object.bind())
	$Player.hover_object.connect($Salle/Meshchange/UI_handler/SubView/Select_Object._on_selected_object.bind())
	$Player.hover_object.connect($Salle/Flower/UIHandler/SubViewport/Select_Object._on_selected_object.bind())
	$Player.fleur.connect($Salle/Flower._on_click.bind())
	$Salle/Flower.item_placed.connect($Player._on_pick_up.bind())
	$Salle/Flower/UIHandler/SubViewport/Select_Object.item_fully_selected.connect($Slot_selection._on_full_circle.bind())
	
func _process(delta):
	talkWith(marginTime, symbolCount, communicationDuration)
	$Salle/Meshchange/UI_handler.look_at($Player.position)
	$Salle/Meshchange/UI_handler.rotation.x = deg_to_rad(10)
	$Salle/Meshchange/UI_handler.rotation.z = deg_to_rad(10)
	$Salle/Flower/UIHandler.look_at($Player.position)
	$Salle/Flower/UIHandler.rotation.x = deg_to_rad(10)
	$Salle/Flower/UIHandler.rotation.z = deg_to_rad(10)

func talkWith(marginTime: int, symbolCount: int, communicationDuration: float):
	if Input.is_action_just_pressed("envoi_parole"):
		if isDialogVisible:
			$Talk.hide()
			isDialogVisible = false
		else:
			$Talk.show()
			$Talk.initialize(marginTime, symbolCount, communicationDuration)
			isDialogVisible = true
