extends CharacterBody3D


@export var speed = 10000	
@export var player_sprite: AnimatedSprite3D

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if velocity != Vector3.ZERO:
		player_sprite.play("walk")
	else:
		player_sprite.play("idle")
	if direction:
		velocity.x = direction.x * speed * delta
		velocity.z = direction.z * speed * delta
		
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	move_and_slide()
