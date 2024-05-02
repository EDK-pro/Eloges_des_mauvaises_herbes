extends CharacterBody3D


@export var speed = 10000	
@export var trigger_UI: Area3D
@export var sprite:Sprite3D
@export var foot:AudioStreamPlayer
@export var playerAnim:AnimationPlayer

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("gauche", "droite", "devant", "derriere")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var dir = sign(direction.x)
	sprite.flip_h = (dir ==-1)
	if velocity != Vector3.ZERO:
		playerAnim.play("walk")
	else:
		playerAnim.play("IDLE")
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	if trigger_UI.player_movement_available == true:
		move_and_slide()


func _on_animated_sprite_3d_animation_looped():
	if velocity != Vector3.ZERO:
		foot.play()
