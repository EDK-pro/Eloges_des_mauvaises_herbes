extends all_items

func _ready():
	self.add_to_group("pickable_item")
	item_placed.connect(_on_item_placed.bind())

func _hovered(item_name,occupied_slots):
	if item_name == Litems.FLOWER:
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
	#print("click_on ", slot_used)


