extends Control

@export var message: Array[Node] = []
@export var number: int = 0
@export var color: Color
@export var error_sound:AudioStreamPlayer
@export var timer:Timer
@export var salon_end:PackedScene

func _ready():
	message = get_tree().get_nodes_in_group("message")
	$FlowerwallCrtConfigUi/Presets._on_preset_selected(4)
	flowerwall_pp_autoload.crt_shader.set("shader_parameter/chromatic_aberration_strength", 1.0)
	flowerwall_pp_autoload.dither_shader.set("shader_parameter/resolution_scale", 1.0)
	flowerwall_pp_autoload.preblur_x_shader.set("shader_parameter/radius", 1.0)
	flowerwall_pp_autoload.preblur_y_shader.set("shader_parameter/radius", 1.0)

	
func _input(event):
	if Input.is_action_just_pressed("advance_story"):
		if number < message.size():
			var pitch_shift: float = randf_range(0.95,1.05)
			var volume_shift: float = randf_range(-1.0,0.0)
			$AudioStreamPlayer.pitch_scale = pitch_shift
			$AudioStreamPlayer.volume_db = volume_shift
			$AudioStreamPlayer.play()
			var tween = get_tree().create_tween()
			tween.tween_property(message[number], "modulate:a", 1, 0.5).set_trans(Tween.TRANS_CUBIC)
			#await tween.finished
		elif number == message.size():
			var bugging = get_tree().create_tween()
			timer.start()
			bugging.tween_method(_crt_bug_shader,flowerwall_pp_autoload.crt_shader.get("shader_parameter/wiggle"),1.0,timer.wait_time + 2.0)
			error_sound.play()
		else:
			$CanvasLayer/ColorRect.material.set_shader_parameter("smear",2.0)
		number +=1
		return
func _process(_delta: float) -> void:
	pass

func _crt_bug_shader(value : float):
	flowerwall_pp_autoload.crt_shader.set("shader_parameter/chromatic_aberration_strength", 6 * value)
	flowerwall_pp_autoload.crt_shader.set("shader_parameter/wiggle", 0.5 * value)
	error_sound.volume_db = -10.0 + (10.0 * value)


func _on_timer_timeout():
	$FlowerwallCrtConfigUi/Presets._on_preset_selected(5)
	get_tree().change_scene_to_packed(salon_end)
	
