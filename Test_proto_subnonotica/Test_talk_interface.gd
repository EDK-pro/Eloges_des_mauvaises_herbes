extends Control

var t = 0.0
var talking: bool = false
var start_time
var end_time
var score: int = 0
var margin_time: int = 200
var timestamp
var input_validated = []
var timer_array = []
var index_timer = 0
var index_temps_qui_passe = 0
var index_color = 0

func _ready():
	initialize(150,8)

func initialize(temps_marge,nb_symbole):
	margin_time = temps_marge
	timer_array.resize(nb_symbole)
	input_validated.resize(nb_symbole)
	input_validated.fill(0)
	var temps_entre_chaque_symbole: float = 1.0000 / nb_symbole
	print(temps_entre_chaque_symbole)
	for i in nb_symbole:
		timer_array[i] = temps_entre_chaque_symbole * 5000 * i
	print(timer_array)
	
func _physics_process(delta):
	if Input.is_action_pressed("talk"):
		talking = true
		$Timing/Arrow.position.x = $Timing/Line.position.x
		start_time = Time.get_ticks_msec()
		index_temps_qui_passe = 0
		index_color = 0
		$Timing/Arrow.color = Color(0.176,1,1,1)
		print("Distance = ",$Timing/Endline.position.x-$Timing/Arrow.position.x)
		print("Temps = ",($Timing/Endline.position.x-$Timing/Arrow.position.x) / (delta * 0.2))
		
	if talking == true:
		#Avec t += delta * 0.2, ça laisse environ 5 secondes pour faire tout l'input
		t += delta * 0.2
		if t <= 1.0 :
			$Timing/Arrow.position.x = $Timing/Line.position.lerp($Timing/Endline.position, t).x
			timestamp = Time.get_ticks_msec() - start_time
			if index_temps_qui_passe < timer_array.size():
				if timer_array[index_color] - margin_time < timestamp:
					$Timing/Arrow.color = Color(0.6,0.6,0.6,1)
				if timer_array[index_color] + margin_time < timestamp:
					$Timing/Arrow.color = Color(0.176,1,1,1)
					index_color = index_color + 1
				if timestamp > timer_array[index_temps_qui_passe]:
					print("Hop!!!")
					index_temps_qui_passe = index_temps_qui_passe + 1 

			if Input.is_action_just_pressed("envoi_parole"):
				nearest_timer()
				
		else:
			t = 0.0
			talking = false
			end_time = Time.get_ticks_msec()
			print(end_time - start_time)
			print(input_validated)
			if input_validated.count(1) == input_validated.size():
				$Resultat.color = Color(0,1,0)
			else:
				$Resultat.color = Color(1,0,0)
			
func nearest_timer():
	var index_select = 0
	var smallest = abs(timestamp - timer_array[index_select])
	index_select = index_select + 1
	while index_select < timer_array.size() :
		if abs(timestamp - timer_array[index_select]) < smallest:
			index_timer = index_select
			smallest = abs(timestamp - timer_array[index_select])
		index_select = index_select + 1
	if timer_array[index_timer] - margin_time < timestamp and timer_array[index_timer] + margin_time > timestamp:
		print("Yes !")
		input_validated[index_timer] = 1
	else:
		print("No !")
