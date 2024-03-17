extends Node3D


var rope_start = PinJoint3D.new()
var rope_end = PinJoint3D.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	rope_start.position = $Armature/Depart.position
	rope_end.position = $Armature/Fin.position
	#print($Armature/Cylinder.get_aabb().size)
	print(rope_start.position, " ", rope_end.position, " ", position, " ", global_position)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
