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

var tj = [0.0,0.0,0.0]
var t_cable = 0.0
var pickup
var cable_active = false
var taille_max

enum Condition {CORRECT,PARTIALLY_BROKEN,NEARLY_BROKEN,BROKEN}
var audio_state: int = Condition.CORRECT
var visual_state: int = Condition.CORRECT
var movement_state: int = Condition.CORRECT

var timer_1_shot: bool = false

func _ready():
	# Set mouse mode to captured when the scene is ready
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	taille_max = $Cable/Tube.mesh.height

func _physics_process(delta):
	#if Input.is_action_just_pressed("light"):
		#light.visible = true
	wire_handler(delta)
	slots_handler(delta)
	# Check for pause action and adjust mouse mode accordingly
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
	print("pick up ",slot," ", state," ", item)
	if state == 1:
		if slots[slot] == null:
			slots[slot] = item
			slots[slot].gravity_scale = 0
			tj[slot] = 0.0
			slots[slot].rotation = Vector3(0,0,0)
			slots[slot].sleeping = true
			pickup = Vector3(item.global_position)
	else:
		if slots[slot] != null:
			slots[slot].gravity_scale = 3
			var facing = $Camera3D.get_camera_transform().basis.z
			slots[slot].sleeping = false
			slots[slot].apply_force(Vector3(300*-facing.x,0,300*-facing.z))
			slots[slot] = null
	print(slots)

func slots_handler(delta):
	for i in 3:
		if slots[i] != null:
			var flower_on: bool = false
			var gazlamp_timing:float = 180.0
			var spacing
			if i == 0:
				spacing = Vector3(0,1.8,0)
				if slots[i].items == slots[i].Items.FLOWER:
					flower_on = true
			if i == 1:
				spacing = Vector3(0.5,0.8,0.5)
				if slots[i].items == slots[i].Items.FLOWER:
					flower_on = true
				if slots[i].items == slots[i].Items.LEVER:
					if Input.is_action_just_pressed("throw_rope"):
						cable_active = !cable_active
						$Cable/Interact_collide.disabled = !$Cable/Interact_collide.disabled
			if i == 2:
				spacing = Vector3(0,0.5,0)
				gazlamp_timing = 120.0
			if tj[i] <= 1.0:
				tj[i] += delta * 0.9
				slots[i].global_position = pickup + (Vector3(global_position.x + spacing.x,global_position.y + spacing.y,global_position.z + spacing.z) - pickup) * tj[i]
			else:
				slots[i].global_position = Vector3(global_position.x + spacing.x,global_position.y + spacing.y,global_position.z + spacing.z)
			if flower_on:
				if !timer_1_shot:
					$Timer_fleur.start()
					print("COUBEH", slots[i].items)
					timer_1_shot = true
			#if slots[i].items == slots[i].Items.GAZLAMP:
				#print("oups")

func wire_handler(delta):
	if cable_active == true:
		$Cable.show()
		if t_cable <= 1.0:
			t_cable += delta * 0.5
			$Cable/Tube.mesh.height = taille_max * t_cable
			if !$AudioStreamPlayer3D.playing:
				$AudioStreamPlayer3D.play()
		var face = $Camera3D.get_camera_transform().basis.z
		
		$Cable.global_position = self.global_position + Vector3(-0.1 * face.x, -1 * face.y +1.6 ,-0.4 * face.z) 
		$Cable.global_rotation = Vector3(-1 * face.x * face.y,self.rotation.y,-1 * face.z * face.y)
		$Cable.global_rotation.y += deg_to_rad(90)
		$Cable.global_rotation.z += deg_to_rad(-90)
		
	if cable_active == false:
		if t_cable >= 0.0:
			t_cable -= delta * 0.8
			$Cable/Tube.mesh.height = taille_max * t_cable
		else:
			$Cable.hide()

func _on_timer_timeout():
	if audio_state != Condition.BROKEN:
		audio_state = audio_state + 1 
		print("Audio state : ", audio_state)
		timer_1_shot = false


func _on_timer_gazlamp_timeout():
	pass # Replace with function body.
