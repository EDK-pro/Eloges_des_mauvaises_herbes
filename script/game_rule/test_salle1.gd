extends Node

@export var marginTime : int = 150
@export var symbolCount : int = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false
var checkDegradation: int = 0

func _ready():
	#$Control.btn_deplacement.connect($Player_constraint._on_appuie_des_boutons.bind())
	#$Salle/Interactable_action/Hitbox.shape.size = Vector3(2,2,2)
	$Salle/Meshchange/Mesh.mesh = load("res://assets/Test_assets/Assets/column.obj")
	#$Player.hover_object.connect($Select_Object._on_selected_object.bind())
	$Player.hover_object.connect($Salle/Meshchange/UI_handler/SubView/Select_Object._on_selected_object.bind())
	

func _process(delta):
	talkWith(marginTime, symbolCount, communicationDuration)
	#$Salle/Meshchange/UI_handler.look_at($Player.global_position)
	#$Salle/Meshchange/UI_handler.rotation.x = deg_to_rad(90)
	#$Salle/Meshchange/UI_handler.rotation.z = 0

func talkWith(marginTime: int, symbolCount: int, communicationDuration: float):
	if Input.is_action_just_pressed("envoi_parole"):
		if isDialogVisible:
			$Talk.hide()
			isDialogVisible = false
		else:
			$Talk.show()
			$Talk.initialize(marginTime, symbolCount, communicationDuration)
			isDialogVisible = true
