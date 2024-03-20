extends Control



@export_category( "test" )

var timeElapsed: float = 0.0

var isTalking: bool = false

var startTime: float

var endTime: float

var score: int = 0

@export var marginTime: int = 200

var timestamp: float

var inputValidated = []

var timerArray = []

var indexTimer: int = 0

var indexColor : int = 0

var timeIncrement: float

var correctCombinaison = []

@export var communicationDuration: float = 5.0
@export var symbolCount: int = 4

var texture_arrow_no_click = load("res://assets/visuel/UI_sprite/rectangle_1_png.png")
var texture_arrow_click = load("res://assets/visuel/UI_sprite/rectangle_2_png.png")
var texture_result_good = load("res://assets/visuel/UI_sprite/son_2_png.png")
var texture_result_bad = load("res://assets/visuel/UI_sprite/son_1_png.png")

var result_base_position:float

func _ready():
	
	initialize(marginTime, symbolCount, communicationDuration,[0,1,0,1])


func initialize(margintime: int, symbolcount: float, communicationduration: float, correctcombinaison: Array):

	marginTime = margintime
	
	correctCombinaison.resize(correctcombinaison.size())
	timerArray.resize(int(symbolcount))
	inputValidated.resize(int(symbolcount))
	inputValidated.fill(0)

	var timeBetweenSymbols: float = communicationduration / (symbolcount+1.0)
	print(timeBetweenSymbols)
	
	for i in symbolcount:
		timerArray[i] = timeBetweenSymbols * 1000 * (i+1)

	print(timerArray)

	timeIncrement = communicationDuration / 0.01666666667 / (communicationDuration * 60 * communicationDuration)
	print(timeIncrement)

	correctCombinaison = correctcombinaison

func _physics_process(delta):

	if Input.is_action_pressed("talk"):
		isTalking = true
		$Timing/Arrow.position.x = $Timing/Line.position.x
		startTime = Time.get_ticks_msec()
		indexTimer = 0
		indexColor = 0
		$Timing/Arrow.texture = texture_arrow_no_click
		result_base_position = $Resultat.position.y
		#$Timing/Arrow.color = Color(0.176, 1, 1, 1)

	if isTalking:
		timeElapsed += delta * timeIncrement
		#print(timeElapsed)
		if timeElapsed <= 1.0 :
			$Timing/Arrow.position.x = $Timing/Line.position.x + ($Timing/Endline.position.x - $Timing/Line.position.x) * timeElapsed
			timestamp = Time.get_ticks_msec() - startTime
			## This if is here to prevent crashes (else, would return an error cause timerArray[indexTimer]
			## Would out of index on the last loops.
			if indexTimer < timerArray.size():
				if timerArray[indexColor] - marginTime < timestamp:
					$Timing/Arrow.texture = texture_arrow_click
					#$Timing/Arrow.color = Color(0.6, 0.6, 0.6, 1)
				if timerArray[indexColor] + marginTime < timestamp:
					$Timing/Arrow.texture = texture_arrow_no_click
					#$Timing/Arrow.color = Color(0.176, 1, 1, 1)
					indexColor += 1
				if timestamp > timerArray[indexTimer]:
					print("Hop!!!")
					indexTimer += 1
			else:
				if indexColor < timerArray.size():
					if timerArray[indexColor] + marginTime < timestamp:
						$Timing/Arrow.texture = texture_arrow_no_click
						#$Timing/Arrow.color = Color(0.176, 1, 1, 1)
						indexColor += 1
			if Input.is_action_just_pressed("envoi_parole"):
				$Resultat.texture = texture_result_good
				$Timer.start()
				nearestTimer()
			if $Timer.time_left != 0.0:
				var plic: float = $Timer.time_left - 0.2
				print(plic)
				$Resultat.position.y = pow(plic, 2.0) * 100 + result_base_position
			else: 
				$Resultat.position.y = result_base_position
		else:
			timeElapsed = 0.0
			isTalking = false
			endTime = Time.get_ticks_msec()
			print(endTime - startTime)
			print(inputValidated)
			if inputValidated == correctCombinaison:
				$Resultat.texture = texture_result_good
				#$Resultat.color = Color(0, 1, 0)
			else:
				$Resultat.texture = texture_result_bad
				#$Resultat.color = Color(1, 0, 0)

func nearestTimer():
	var indexSelect = 0
	var smallestDiff = abs(timestamp - timerArray[indexSelect])
	indexSelect += 1
	while indexSelect < timerArray.size() :
		if abs(timestamp - timerArray[indexSelect]) < smallestDiff:
			indexTimer = indexSelect
			smallestDiff = abs(timestamp - timerArray[indexSelect])
		indexSelect += 1
	if timerArray[indexTimer] - marginTime < timestamp and timerArray[indexTimer] + marginTime > timestamp:
		print("Yes !")
		inputValidated[indexTimer] = 1
	else:
		print("No !")


func _on_timer_timeout():
	$Resultat.texture = texture_result_bad
