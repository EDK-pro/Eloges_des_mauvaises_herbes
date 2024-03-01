extends Node

var dialogue = false
# Called when the node enters the scene tree for the first time.
func _ready():
	#$Control.btn_deplacement.connect($Player_constraint._on_appuie_des_boutons.bind())
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	talk_with(150,4,5.0)

func talk_with(temps_marge,nb_symbole, duree_communication):
	if Input.is_action_just_pressed("envoi_parole"):
		if dialogue :
			$Talk.hide()
			dialogue = false
		else:
			$Talk.show()
			$Talk.initialize(temps_marge,nb_symbole, duree_communication)
			dialogue = true
