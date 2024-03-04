extends Node

@export var marginTime : int = 150
@export var symbolCount : int = 4
@export var communicationDuration : float = 5.0
@export var isDialogVisible : bool = false

func _ready():
	#$Control.btn_deplacement.connect($Player_constraint._on_appuie_des_boutons.bind())
	$Salle/Interactable_action/Hitbox.shape.size = Vector3(2,2,2)
	

func _process(delta):
	talkWith(marginTime, symbolCount, communicationDuration)

func talkWith(marginTime: int, symbolCount: int, communicationDuration: float):
	if Input.is_action_just_pressed("envoi_parole"):
		if isDialogVisible:
			$Talk.hide()
			isDialogVisible = false
		else:
			$Talk.show()
			$Talk.initialize(marginTime, symbolCount, communicationDuration)
			isDialogVisible = true
