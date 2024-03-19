extends Node3D


func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("step_up"):
		$AnimationPlayer.play("left_right",0.0,2.0)


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "left_right":
		print("ALORS : ",$Player/Camera3D.position)
		$Player.global_position = Vector3($Player/Camera3D.global_position.x,$Player/Camera3D.global_position.y ,$Player/Camera3D.global_position.z)
		#$Player/Camera3D.position = Vector3($Player.position.x,$Player.position.y - 1.6,$Player.position.z)
		$Player/Camera3D.position = Vector3(0.0,1.6,0.0)

		#$Player/Camera3D.position.y = $Player.position.y + 1.6
