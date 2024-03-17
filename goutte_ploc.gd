extends Area3D

var sound_array: Array
var sound_array_crushed: Array
var crushed: int

# Called when the node enters the scene tree for the first time.
func _ready():
	sound_array.resize(6)
	sound_array_crushed.resize(6)
	sound_array[0] = load("res://assets/Test_assets/sound_normal/droplet-001.ogg")
	sound_array[1] = load("res://assets/Test_assets/sound_normal/droplet-002.ogg")
	sound_array[2] = load("res://assets/Test_assets/sound_normal/droplet-003.ogg")
	sound_array[3] = load("res://assets/Test_assets/sound_normal/droplet-004.ogg")
	sound_array[4] = load("res://assets/Test_assets/sound_normal/droplet-005.ogg")
	sound_array[5] = load("res://assets/Test_assets/sound_normal/droplet-006.ogg")
	sound_array_crushed[0] = load("res://assets/Test_assets/sound_crushed/test_droplet_bitcrushed_0001-001.ogg")
	sound_array_crushed[1] = load("res://assets/Test_assets/sound_crushed/test_droplet_bitcrushed_0001-002.ogg")
	sound_array_crushed[2] = load("res://assets/Test_assets/sound_crushed/test_droplet_bitcrushed_0001-003.ogg")
	sound_array_crushed[3] = load("res://assets/Test_assets/sound_crushed/test_droplet_bitcrushed_0001-004.ogg")
	sound_array_crushed[4] = load("res://assets/Test_assets/sound_crushed/test_droplet_bitcrushed_0001-005.ogg")
	sound_array_crushed[5] = load("res://assets/Test_assets/sound_crushed/test_droplet_bitcrushed_0001-006.ogg")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y -= 0.1

func _on_body_entered(body):
	if crushed == 3:
		$Son_goutte.volume_db = -40.0
	elif crushed != 3:
		var chosen_drop = randi_range(0,5)
		var pitch_shift: float = randf_range(0.9,1.1)
		var volume_shift: float = randf_range(-3.0,0.0)
		if crushed == 0:
			$Son_goutte.stream = sound_array[chosen_drop]
			$Son_goutte.bus = "Master"
		if crushed >= 1:
			$Son_goutte.stream = sound_array_crushed[chosen_drop]
		if crushed == 2:
			$Son_goutte.bus = "Reducson"
		$Son_goutte.pitch_scale = pitch_shift
		$Son_goutte.volume_db = volume_shift
	$Son_goutte.play()
	$End_Drop.start()

func _on_end_drop_timeout():
	queue_free()