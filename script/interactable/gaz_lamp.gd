extends all_items

func _ready():
	self.add_to_group("pickable_item")
	item_placed.connect(_on_item_placed.bind())

func _process(delta):
	if Input.is_action_just_pressed("light"):
		turn_on_light(3)

func turn_on_light(energy):
	$OmniLight3D.light_energy = energy

func turn_off_light():
	$OmniLight3D.light_energy = 0

func disable_coll():
	$CollisionShape3D.disabled = true

func enable_coll():
	$CollisionShape3D.disabled = false

func _hovered(item_name):
	if item_name == Litems.GAZLAMP:
		$UIHandler/SubView/Select_Object._on_selected_object()
		is_being_selected = true

func _stop_value_circle(slot):
	$UIHandler/SubView/Select_Object.stop_processus()
	
func _on_click(slot):
	match slot:
		0,1,2:
			if is_being_selected:
				put_in_slot(self,slot)
				print("Putting")
		3,4,5:
			remove_from_slot(slot-3)
			print("Remewing")
		_:
			print("echec match")
	print(slot_used)
