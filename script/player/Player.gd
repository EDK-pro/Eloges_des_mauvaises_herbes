extends CharacterBody3D

# Define player parameters
@export_category("player Parameter")
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed: int = 5
@export var mouse_sensitivity: float = 0.002
@export var light: OmniLight3D

var slot1: all_items
var slot2: all_items
var slot3: all_items

var slots: Array[all_items] = [null,null,null]

## When an item is clicked on, emit this signal. 
## TODO : emitted when hovered for a long enough time, not just on click.
signal hover_object
## Emitted when U, I, or O is pressed when an item is in a slot.
signal throw_object

var selected: bool = false
var mouse = Vector2()
var mouse_confirm = Vector2.ZERO

var t = 0.0
var t_cable = 0.0
var pickup
var cable_active = false
var taille_max

var rope_scene = load("res://scene/debug/rope.tscn")
var instance

func _ready():
	# Set mouse mode to captured when the scene is ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	taille_max = $Cable/Tube.mesh.height

func _physics_process(delta):
	if cable_active == true:
		$Cable.show()
		if t_cable <= 1.0:
			t_cable += delta * 0.5
			$Cable/Tube.mesh.height = taille_max * t_cable
		var face = $Camera3D.get_camera_transform().basis.z
		
		$Cable.global_position = self.global_position + Vector3(-0.1 * face.x, -1 * face.y +1.6 ,-0.4 * face.z) 
		$Cable.global_rotation = Vector3(-1 * face.x * face.y,self.rotation.y,-1 * face.z * face.y)
		$Cable.global_rotation.y += deg_to_rad(90)
		$Cable.global_rotation.z += deg_to_rad(-90)
		
	if cable_active == false:
		if t_cable >= 0.0:
			t_cable -= delta * 0.5
			$Cable/Tube.mesh.height = taille_max * t_cable
		else:
			$Cable.hide()

	if instance != null:
		instance.depart.position += Vector3(position.x,0.0,position.z) 
		instance.fin.position = position
		print(instance.fin.position)
		#var face = $Camera3D.get_camera_transform().basis.z

	if Input.is_action_just_pressed("light"):
		light.visible = true
	# Check for pause action and adjust mouse mode accordingly
	for i in 3:
		if slots[i] != null:
			var spacing
			if i == 0:
				spacing = Vector3(0,1.8,0)
			if i == 1:
				spacing = Vector3(0.5,0.8,0.5)
			if i == 2:
				spacing = Vector3(0,0.5,0)
			if t <= 1.0:
				t += delta * 0.9
				slots[i].global_position = pickup + (Vector3(global_position.x + spacing.x,global_position.y + spacing.y,global_position.z + spacing.z) - pickup) * t
			else:
				slots[i].global_position = Vector3(global_position.x + spacing.x,global_position.y + spacing.y,global_position.z + spacing.z)

	if Input.is_action_pressed("Menu_pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Handle player movement based on input
	var input = Input.get_vector("gauche", "droite", "devant", "derriere")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.y -= gravity * 0.1
	velocity.z = movement_dir.z * speed
	move_and_slide()
	
func _input(event):
	# Handle mouse motion and button events for camera control and object selection
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
		$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))

		
	if mouse_confirm == mouse:
		if Input.is_action_pressed("slot1"):
			throw_object.emit(3)
		if Input.is_action_pressed("slot2"):
			throw_object.emit(4)
		if Input.is_action_pressed("slot3"):
			throw_object.emit(5)

	if event is InputEventMouse:
		mouse = event.position
		mouse_confirm = mouse

	if event is InputEventMouseButton and event.pressed:
		if event.button_index == MOUSE_BUTTON_LEFT:
			get_selection()
	
	if Input.is_action_just_pressed("throw_rope"):
		#instance = rope_scene.instantiate()
		##instance.position += $Start_cable_player.position
		##instance.position.x += 2.0
		##instance.position.y += 0.5
		##instance.depart.position = position
		##instance.depart.position.y = position.y + 4.0
		#add_child(instance)
		#
		##instance._connect_first_pin_to_player($End_cable_player)
		#instance._connect_first_pin_to_player($Camera3D/Start_cable_player)
		#instance._connect_last_pin_to_player($Camera3D/End_cable_player)
		cable_active = !cable_active
		$Cable/Interact_collide.disabled = !$Cable/Interact_collide.disabled
		#instance.depart.position = position
		#instance.depart.position.y = position.y + 4.0
		#instance.rotate_z(90)
		#instance.position.y += position.y + 2.0
		

# Method to select objects in the game world using the mouse
func get_selection():
	var worldspace = get_world_3d().direct_space_state
	var start = $Camera3D.project_ray_origin(mouse)
	var end = $Camera3D.project_position(mouse, 10)
	var result = worldspace.intersect_ray(PhysicsRayQueryParameters3D.create(start, end))
	if !result.is_empty():
		selected = true
		var collider = str(result.collider).get_slice(":",0)
		print(collider)
		hover_object.emit(collider)

func _on_pick_up(slot, state, item):
	print(slot," ", state," ", item)
	if state == 1:
		if slots[slot] == null:
			slots[slot] = item
			slots[slot].gravity_scale = 0
			slots[slot].disable_coll()
			t = 0.0
			slots[slot].rotation = Vector3(0,0,0)
			slots[slot].sleeping = true
			pickup = Vector3(item.global_position)
	else:
		if slots[slot] != null:
			slots[slot].gravity_scale = 3
			slots[slot].enable_coll()
			var facing = $Camera3D.get_camera_transform().basis.z
			slots[slot].sleeping = false
			slots[slot].apply_force(Vector3(300*facing.x,0,300*facing.z))
			slots[slot] = null
