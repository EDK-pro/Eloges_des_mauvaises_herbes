extends Control

@export var message: Array[RichTextLabel] = []
@export var number: int = 0
@export var color: Color

func _ready():
	#$FlowerwallCrtConfigUi/Presets._on_preset_selected(4)
	#flowerwall_pp_autoload.crt_shader.set("shader_parameter/chromatic_aberration_strength", 1.0)
	#flowerwall_pp_autoload.dither_shader.set("shader_parameter/resolution_scale", 1.0)
	#flowerwall_pp_autoload.preblur_x_shader.set("shader_parameter/radius", 1.0)
	#flowerwall_pp_autoload.preblur_y_shader.set("shader_parameter/radius", 1.0)
	pass
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("advance_story"):
		if number < message.size():
			var pitch_shift: float = randf_range(0.95,1.05)
			var volume_shift: float = randf_range(-1.0,0.0)
			$AudioStreamPlayer.pitch_scale = pitch_shift
			$AudioStreamPlayer.volume_db = volume_shift
			$AudioStreamPlayer.play()
			var tween = get_tree().create_tween()
			tween.tween_property(message[number], "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC)
			await tween.finished
		else:
			$CanvasLayer/ColorRect.material.set_shader_parameter("smear",2.0)
		number +=1
		return
