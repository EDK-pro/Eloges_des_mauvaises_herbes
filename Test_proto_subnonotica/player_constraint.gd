extends CharacterBody3D

var speed: int = 15
var previous_pos: Vector3
var previous_velocity: Vector3
var distance_pos: Vector3 = Vector3.ZERO

func _ready():
	pass
func _physics_process(delta):
	var direction = Vector3.ZERO

	if Input.is_action_just_pressed("droite"):
		direction.x += 1
	if Input.is_action_just_pressed("gauche"):
		direction.x -= 1
	if Input.is_action_just_pressed("derriere"):
		direction.z += 1
	if Input.is_action_just_pressed("devant"):
		direction.z -= 1
	
	if direction != Vector3.ZERO:
		previous_pos = position
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	distance_pos = abs(position - previous_pos)
	if distance_pos.x >= 2.0 or distance_pos.z >= 2.0 :
		velocity = Vector3.ZERO
		previous_pos = Vector3.ZERO

	move_and_slide()
	
func _on_appuie_des_boutons(type):
	var facing = $Camera3D.get_camera_transform().basis.z
	print(facing)
	print(Input.mouse_mode)
	match type:
		"gauche":
			position = Vector3(position.x + -1 * facing.z, 0, facing.x + position.z)
		"derriere":
			position = Vector3(position.x + facing.x, 0, position.z + facing.z)
		"droite":
			position = Vector3(position.x + facing.z, 0, -1 * facing.x + position.z)
		"devant":
			position = Vector3(position.x - facing.x, 0, position.z - facing.z)
		"vers_gauche":
			rotate_y(deg_to_rad(90))
		"vers_droite":
			rotate_y(deg_to_rad(-90))
	
