extends CharacterBody3D

# Define player parameters
@export_category("player Parameter")
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed: int = 5
@export var mouse_sensitivity: float = 0.002

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
var pickup

func _ready():
	# Set mouse mode to captured when the scene is ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
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
