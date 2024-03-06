extends CharacterBody3D

# Define player parameters
@export_category("player Parameter")
@export var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed: int = 5
@export var mouse_sensitivity: float = 0.002

var slot1
var slot2
var slot3

signal hover_object
signal fleur

var selected: bool = false
var mouse = Vector2()
var mouse_confirm = Vector2.ZERO

func _ready():
	# Set mouse mode to captured when the scene is ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	# Check for pause action and adjust mouse mode accordingly
	if Input.is_action_pressed("Menu_pause"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

	# Handle player movement based on input
	var input = Input.get_vector("gauche", "droite", "devant", "derriere")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
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
			fleur.emit(0)
		if Input.is_action_pressed("slot2"):
			fleur.emit(1)
		if Input.is_action_pressed("slot3"):
			fleur.emit(2)
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
		print(result.collider)
		hover_object.emit()
		fleur.emit(3)


