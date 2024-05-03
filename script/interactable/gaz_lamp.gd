extends all_items

var is_on: bool = false
var lamp_energy_emission: float = 0.0

@export var material:StandardMaterial3D

func _ready():
	self.add_to_group("pickable_item")
	item_placed.connect(_on_item_placed.bind())

func _process(_delta):
	turn_on_light(lamp_energy_emission)
	if status == Slots.SLOT_3:
		if Input.is_action_just_pressed("Use_item"):
			is_on = !is_on
			if is_on: 
				lamp_energy_emission = 3.0
			else:
				lamp_energy_emission = 0.0
		
func _wet_lamp():
	$TimerWet.start()

func turn_on_light(energy):
	if $TimerWet.time_left >= 6.0:
		energy = 0.0
	var multiply = 1 - ($TimerWet.time_left / 6.0)
	$OmniLight3D.light_energy = energy * multiply

func _hovered(item_name,occupied_slots):
	if item_name == Litems.GAZLAMP:
		$UIHandler/SubView/Select_Object._on_selected_object(occupied_slots)
		is_being_selected = true

func _stop_value_circle(_slot):
	circle = $UIHandler/SubView/Select_Object/Circle.value
	$UIHandler/SubView/Select_Object.stop_processus()


func _on_click(slot):
	if circle == 0.0:
		slot += 3
	match slot:
		0,1,2:
			if is_being_selected:
				put_in_slot(self,slot)
				is_being_selected = false
		3,4,5:
			remove_from_slot(slot-3)
		_:
			print("echec match")
