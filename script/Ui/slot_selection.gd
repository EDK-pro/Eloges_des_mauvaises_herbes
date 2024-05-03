extends Control

var fade_in: Array[bool] = [false,false,false]
var fade_value: Array[float] = [0.0,0.0,0.0]

var slot_images: Array[Texture2D]
## Emitted when you click on a slot, transmitted to each individual interactable item.
## Makes the circle around the item disappear, and call _on_click.
signal slot_accepted(slot_value)

func _ready():
	slot_images.resize(12)
	slot_images[0] = load("res://assets/visuel/UI_sprite/gradient_haut_inoccupe_gris_fonce.png")
	slot_images[1] = load("res://assets/visuel/UI_sprite/gradient_haut_inoccupe_gris_clair.png")
	slot_images[2] = load("res://assets/visuel/UI_sprite/gradient_haut_occupe_rouge_fonce.png")
	slot_images[3] = load("res://assets/visuel/UI_sprite/gradient_haut_occupe_rouge_clair.png")
	slot_images[4] = load("res://assets/visuel/UI_sprite/gradient_cote_inoccupe_gris_fonce.png")
	slot_images[5] = load("res://assets/visuel/UI_sprite/gradient_cote_inoccupe_gris_clair.png")
	slot_images[6] = load("res://assets/visuel/UI_sprite/gradient_cote_occupe_rouge_fonce.png")
	slot_images[7] = load("res://assets/visuel/UI_sprite/gradient_cote_occupe_rouge_clair.png")
	slot_images[8] = load("res://assets/visuel/UI_sprite/gradient_bas_inoccupe_gris_fonce.png")
	slot_images[9] = load("res://assets/visuel/UI_sprite/gradient_bas_inoccupe_gris_clair.png")
	slot_images[10] = load("res://assets/visuel/UI_sprite/gradient_bas_occupe_rouge_fonce.png")
	slot_images[11] = load("res://assets/visuel/UI_sprite/gradient_bas_occupe_rouge_clair.png")
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.visible == false:
		return
	if fade_in[0] == true : 
		if fade_value[0] <= 1.0:
			fade_value[0] += delta * 0.9
			$UnselectedSlot1/RectSlot1.modulate = Color(1,1,1,fade_value[0])
	elif fade_in[1] == true : 
		if fade_value[1] <= 1.0:
			fade_value[1] += delta * 0.9
			$UnselectedSlot2/RectSlot2.modulate = Color(1,1,1,fade_value[1])
	elif fade_in[2] == true : 
		if fade_value[2] <= 1.0 :
			fade_value[2] += delta * 0.9
			$UnselectedSlot3/RectSlot3.modulate = Color(1,1,1,fade_value[2])
	if fade_in[0] == false:
		if fade_value[0] >= 0.0:
			fade_value[0] -= delta * 0.9
			$UnselectedSlot1/RectSlot1.modulate = Color(1,1,1,fade_value[0])
	if fade_in[1] == false:
		if fade_value[1] >= 0.0:
			fade_value[1] -= delta * 0.9
			$UnselectedSlot2/RectSlot2.modulate = Color(1,1,1,fade_value[1])
	if fade_in[2] == false:
		if fade_value[2] >= 0.0 :
			fade_value[2] -= delta * 0.9
			$UnselectedSlot3/RectSlot3.modulate = Color(1,1,1,fade_value[2])

func _input(event):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if fade_in[0] == true:
			slot_accepted.emit(0)
			self.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if fade_in[1] == true:
			slot_accepted.emit(1)
			self.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if fade_in[2] == true:
			slot_accepted.emit(2)
			self.hide()
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_rect_slot_1_mouse_entered():
	fade_in[0] = true

func _on_rect_slot_1_mouse_exited():
	fade_in[0] = false

func _on_rect_slot_2_mouse_entered():
	fade_in[1] = true

func _on_rect_slot_2_mouse_exited():
	fade_in[1] = false

func _on_rect_slot_4_mouse_entered():
	fade_in[2] = true

func _on_rect_slot_4_mouse_exited():
	fade_in[2] = false

func _on_full_circle(occupe:Array[bool]):
	
	var unselected = $UnselectedSlot1.texture
	var selected = $UnselectedSlot1/RectSlot1.texture
	if occupe[0]:
		$UnselectedSlot1.texture = slot_images[2]
		$UnselectedSlot1/RectSlot1.texture = slot_images[3]
	else:
		$UnselectedSlot1.texture = slot_images[0]
		$UnselectedSlot1/RectSlot1.texture = slot_images[1]
	if occupe[1]:
		$UnselectedSlot2.texture = slot_images[6]
		$UnselectedSlot2/RectSlot2.texture = slot_images[7]
	else:
		$UnselectedSlot2.texture = slot_images[4]
		$UnselectedSlot2/RectSlot2.texture = slot_images[5]
	if occupe[2]:
		$UnselectedSlot3.texture = slot_images[10]
		$UnselectedSlot3/RectSlot3.texture = slot_images[11]
	else:
		$UnselectedSlot3.texture = slot_images[8]
		$UnselectedSlot3/RectSlot3.texture = slot_images[9]
		
	self.show()
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
