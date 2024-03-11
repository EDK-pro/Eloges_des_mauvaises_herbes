extends Node

@export var marginTime : int = 150
@export var symbolCount : int = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false

func _ready():
	print("feur")
	var cltablo: Array = get_tree().get_nodes_in_group("pickable_item")
	var circletablo: Array = get_tree().get_nodes_in_group("cercle_objet")
	#$Control.btn_deplacement.connect($Player_constraint._on_appuie_des_boutons.bind())
	#$Salle/Interactable_action/Hitbox.shape.size = Vector3(2,2,2)
	$Salle/Meshchange/Mesh.mesh = load("res://assets/Test_assets/Assets/column.obj")

	for i in cltablo.size() :
		print(cltablo[i])
		$Slot_selection.slot_accepted.connect(cltablo[i]._stop_value_circle.bind())
		$Slot_selection.slot_accepted.connect(cltablo[i]._on_click.bind())
		$Player.hover_object.connect(cltablo[i]._hovered.bind())
		cltablo[i].item_placed.connect($Player._on_pick_up.bind())
		circletablo[i].item_fully_selected.connect($Slot_selection._on_full_circle.bind())
		$Player.throw_object.connect(cltablo[i]._on_click.bind())
		#$Slot_selection.slot_accepted.connect($Salle/Flower._on_click.bind())

func _process(delta):
	talkWith(marginTime, symbolCount, communicationDuration)
	$Salle/Meshchange/UI_handler.look_at($Player.position)
	$Salle/Meshchange/UI_handler.rotation.x = deg_to_rad(10)
	$Salle/Meshchange/UI_handler.rotation.z = deg_to_rad(10)
	$Salle/Flower/UIHandler.look_at($Player.position)


func talkWith(marginTime: int, symbolCount: int, communicationDuration: float):
	if Input.is_action_just_pressed("envoi_parole"):
		if isDialogVisible:
			$Talk.hide()
			isDialogVisible = false
		else:
			$Talk.show()
			$Talk.initialize(marginTime, symbolCount, communicationDuration)
			isDialogVisible = true
