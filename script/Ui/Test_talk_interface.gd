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

var indexTimer: float = 0

var timeIncrement: float

@export var communicationDuration: float
@export var symbolCount: int


func _ready():

	initialize(marginTime, symbolCount, communicationDuration)



func initialize(margintime: int, symbolcount: int, communicationduration: float):

	marginTime = margintime

	timerArray.resize(symbolcount)

	inputValidated.resize(symbolcount)

	inputValidated.fill(0)

	var timeBetweenSymbols: float = 1.0000 / symbolcount

	print(timeBetweenSymbols)

	for i in symbolcount:

		timerArray[i] = timeBetweenSymbols * 5000 * i

	print(timerArray)

	timeIncrement = communicationDuration / 0.01666666667 / (communicationDuration * 60 * communicationDuration)

	

func _physics_process(delta):

	if Input.is_action_pressed("talk"):

		isTalking = true

		$Timing/Arrow.position.x = $Timing/Line.position.x

		startTime = Time.get_ticks_msec()

		indexTimer = 0

		$Timing/Arrow.color = Color(0.176, 1, 1, 1)

		

	if isTalking:

		timeElapsed += delta * timeIncrement

		print(delta)

		if timeElapsed <= 1.0 :

			$Timing/Arrow.position.x = $Timing/Line.position.x + ($Timing/Endline.position.x - $Timing/Line.position.x) * timeElapsed

			timestamp = Time.get_ticks_msec() - startTime

			if indexTimer < timerArray.size():

				if timerArray[indexTimer] - marginTime < timestamp:

					$Timing/Arrow.color = Color(0.6, 0.6, 0.6, 1)

				if timerArray[indexTimer] + marginTime < timestamp:

					$Timing/Arrow.color = Color(0.176, 1, 1, 1)

					indexTimer += 1

				if timestamp > timerArray[indexTimer]:

					print("Hop!!!")

					indexTimer += 1 



			if Input.is_action_just_pressed("envoi_parole"):

				nearestTimer()

				

		else:

			timeElapsed = 0.0

			isTalking = false

			endTime = Time.get_ticks_msec()

			print(endTime - startTime)

			print(inputValidated)

			if inputValidated.count(1) == inputValidated.size():

				$Resultat.color = Color(0, 1, 0)

			else:

				$Resultat.color = Color(1, 0, 0)



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