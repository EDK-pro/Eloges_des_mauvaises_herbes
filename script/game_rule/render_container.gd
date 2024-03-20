extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$SubViewportContainer/SubViewport/Salon/Player/Player_scene/Player.visual_degradation.connect(change_shader_quality.bind())
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func change_shader_quality(indice):
	if $SubViewportContainer.material.get_shader_parameter("target_resolution_scale") == indice:
		$SubViewportContainer.material.set_shader_parameter("enable_recolor",true)
	else:
		$SubViewportContainer.material.set_shader_parameter("target_resolution_scale",indice)
	
