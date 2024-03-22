extends Control
@export var Ui_Reset_Button:Control
@export var scene: String
@export var nextscene:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewportContainer/SubViewport/Salon_Proto/Player/Player_scene/Player.visual_degradation.connect(change_shader_quality.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_shader_quality(indice):
	if $SubViewportContainer.material.get_shader_parameter("enable_recolor"):
		var tweeen = get_tree().create_tween()
		Ui_Reset_Button.show()
		tweeen.tween_property(Ui_Reset_Button,"modulate",Color(1.0,1.0,1.0,1.0), 10.0 ).set_trans(Tween.TRANS_CUBIC)
	#Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if $SubViewportContainer.material.get_shader_parameter("target_resolution_scale") == indice:
		$SubViewportContainer.material.set_shader_parameter("enable_recolor",true)
	else:
		$SubViewportContainer.material.set_shader_parameter("target_resolution_scale",indice)
	


func _on_button_pressed():
	#get_tree().change_scene_to_packed(nextscene)
	pass
