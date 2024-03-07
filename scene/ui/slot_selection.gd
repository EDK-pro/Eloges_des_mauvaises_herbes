extends Control

var fade_in: Array[bool] = [false,false,false]
var fade_value: Array[float] = [0.0,0.0,0.0]
signal slot_accepted(slot_value)
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if fade_value[0] == 1.0:
				slot_accepted.emit(0)
				print("1")
				self.hide()
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if fade_value[1] == 1.0:
				slot_accepted.emit(1)
				print("1")
				self.hide()
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if fade_value[2] == 1.0:
				slot_accepted.emit(2)
				print("1")
				self.hide()
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if fade_in[0] == true : 
			if fade_value[0] <= 1.0:
				fade_value[0] += delta * 0.9
				$UnselectedSlot1/RectSlot1.modulate = Color(1,1,1,fade_value[0])
		elif fade_in[1] == true : 
			if fade_value[1] <= 1.0:
				fade_value[1] += delta * 0.9
				$UnselectedSlot2/RectSlot2.modulate = Color(1,1,1,fade_value[1])
				$"UnselectedSlot2-bis/RectSlot3".modulate = Color(1,1,1,fade_value[1])
		elif fade_in[2] == true : 
			if fade_value[2] <= 1.0 :
				fade_value[2] += delta * 0.9
				$UnselectedSlot3/RectSlot4.modulate = Color(1,1,1,fade_value[2])
		if fade_in[0] == false:
			if fade_value[0] >= 0.0:
				fade_value[0] -= delta * 0.9
				$UnselectedSlot1/RectSlot1.modulate = Color(1,1,1,fade_value[0])
		if fade_in[1] == false:
			if fade_value[1] >= 0.0:
				fade_value[1] -= delta * 0.9
				$UnselectedSlot2/RectSlot2.modulate = Color(1,1,1,fade_value[1])
				$"UnselectedSlot2-bis/RectSlot3".modulate = Color(1,1,1,fade_value[1])
		if fade_in[2] == false:
			if fade_value[2] >= 0.0 :
				fade_value[2] -= delta * 0.9
				$UnselectedSlot3/RectSlot4.modulate = Color(1,1,1,fade_value[2])
		

func _on_rect_slot_1_mouse_entered():
	fade_in[0] = true

	print("mouse_entered")


func _on_rect_slot_1_mouse_exited():
	fade_in[0] = false
	print("mouse_exited")



func _on_rect_slot_2_mouse_entered():
	fade_in[1] = true
	print("mouse_entered")


func _on_rect_slot_2_mouse_exited():
	fade_in[1] = false
	print("mouse_exited")


func _on_rect_slot_3_mouse_entered():
	fade_in[1] = true
	print("mouse_entered")


func _on_rect_slot_3_mouse_exited():
	fade_in[1] = false
	print("mouse_exited")


func _on_rect_slot_4_mouse_entered():
	fade_in[2] = true
	print("mouse_entered")


func _on_rect_slot_4_mouse_exited():
	fade_in[2] = false
	print("mouse_exited")

func _on_full_circle():
	self.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
