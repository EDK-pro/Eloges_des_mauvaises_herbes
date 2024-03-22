extends all_items


@export var lightHint: Timer
@export var light: OmniLight3D
@export var lightfinisher: Timer
func _ready():
	self.add_to_group("pickable_item")
	item_placed.connect(_on_item_placed.bind())

func _hovered(item_name):
	if item_name == Litems.UMBRELLA:
		$UIHandler/SubView/Select_Object._on_selected_object()
		is_being_selected = true

func _stop_value_circle(slot):
	$UIHandler/SubView/Select_Object.stop_processus()
	
func _on_click(slot):
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




func _on_light_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 5.511, 1).set_trans(Tween.TRANS_CUBIC)


func _on_finish_timer_timeout() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(light, "energy", 0, 0.5).set_trans(Tween.TRANS_CUBIC)
