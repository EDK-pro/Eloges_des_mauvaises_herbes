extends all_items

var test = 0
func _ready():
	item_placed.connect(_on_item_placed.bind())

func _on_click(slot):
	if slot == 3:
		test = test ^ 1
	else:
		if test == 0:
			remove_from_slot(slot)
			print("Remewing")
		if test:
			put_in_slot(self,slot)
			print("Putting")

	print(status)
	print(slot_used)
	
	if test == 0:
		print("Remewing")
	if test:
		print("Putting")

