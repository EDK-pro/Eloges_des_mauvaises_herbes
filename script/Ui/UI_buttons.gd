extends Control

## Called when a button is pressed on the ui
signal btn_deplacement

func _on_btn_gauche_pressed():
	btn_deplacement.emit("gauche")

func _on_btn_derriere_pressed():
	btn_deplacement.emit("derriere")

func _on_btn_droite_pressed():
	btn_deplacement.emit("droite")

func _on_btn_vers_gauche_pressed():
	btn_deplacement.emit("vers_gauche")

func _on_btn_devant_pressed():
	btn_deplacement.emit("devant")

func _on_btn_vers_droite_pressed():
	btn_deplacement.emit("vers_droite")
