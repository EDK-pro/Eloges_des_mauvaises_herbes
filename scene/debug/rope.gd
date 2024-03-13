extends Node3D

@export var skeleton_path : NodePath
@export var rope_body : Resource
@export var bias : float = 0.4
@export var damping : float = 1
@export var impulse_clamp : float = 0

@export var depart : RigidBody3D
@export var fin : RigidBody3D

#Getting the skeleton.
@onready var skeleton : Skeleton3D = get_node(skeleton_path) as Skeleton3D

var skeleton_movement
var ROPE_BODIES : Array
var last_rigidbody

var last_rope_int = 17
var nope = false

 
func _ready()->void:
	#Adding a RigidBody for every bone. 
	for i in skeleton.get_bone_count(): 
		if i == last_rope_int:
			nope = true
		_add_rigidbody(skeleton.get_bone_global_pose(i))
	#_add_pin_joint(depart,ROPE_BODIES[0])
	#_add_pin_joint(fin,ROPE_BODIES[16])
	#_add_pin_joint(ROPE_BODIES[0],depart)
	#_add_pin_joint(ROPE_BODIES[16],fin)
	
func _physics_process(delta:float)->void:
	#Making the bones move as the rigidbodies move. 
	for i in skeleton.get_bone_count(): 
		var bone_name =skeleton.get_bone_name(i)
		var id = skeleton.find_bone(bone_name)
		skeleton_movement= ROPE_BODIES[i].transform
		skeleton.set_bone_global_pose_override(id, skeleton_movement, 1)
	pass 
	
##Adding a RigidBody for every bone.## 
func _add_rigidbody(pos:Transform3D)->void:
	#Instancing the rope_body scene, which is a RigigBody with collision.
	var rigidbody = rope_body.instantiate()
	rigidbody.position = pos.origin
	#Appending RigidBodies to the array to check later the transforms of the RigidBodies.
	ROPE_BODIES.append(rigidbody)
	add_child(rigidbody)
	#Adding a PinJoint between RigidBodies.
	if last_rigidbody != null or nope == true:
		_add_pin_joint(last_rigidbody,rigidbody)
	#Saving the last added RigidBody for _add_pin_joint function to get position between the old RigidBody and new RigidBody.
	last_rigidbody = rigidbody
	pass
	
##Adding a PinJoint between the RigidBodies.##
func _add_pin_joint(node_A, node_B)->void:
	#Creating a new PinJoint and setting the params for it.
	var pin = PinJoint3D.new()
	pin.set("params/bias",bias)
	pin.set("params/damping",damping)
	pin.set("params/impulse_clamp",impulse_clamp)
	#Setting the node_B(AKA rigidbody variable) for PinJoint
	pin.set_node_b(node_B.get_path())
	#Checking if the node_A(AKA  last_rigidbody variable) is null, and if it is true, PinJoint's translation = Vector.ZERO.  
	if node_A == null:
		pin.transform.origin = Vector3.ZERO 
	else:
		#If node_A is not = null then we are setting the node_A for PinJoint.  
		pin.set_node_a(node_A.get_path())
		#Getting the position between node_A and node_B (AKA last_rigidbody and rigidbody variables).
		var between = _get_pos_between_vectors(node_A.transform.origin,node_B.transform.origin)
		#Setting the given position for the PinJoint.
		pin.transform.origin = between 
		print(node_A.transform.origin,"",node_B.transform.origin,"",between)
	#Adding the PinJoint as a child.
	add_child(pin)
	pass

func _haha_add_pin_joint(node_A, node_B)->void:
	#Creating a new PinJoint and setting the params for it.
	var pin = PinJoint3D.new()
	#pin.set("params/bias",bias)
	#pin.set("params/damping",damping)
	#pin.set("params/impulse_clamp",impulse_clamp)
	#Setting the node_B(AKA rigidbody variable) for PinJoint
	pin.set_node_b(node_B.get_path())
	#Checking if the node_A(AKA  last_rigidbody variable) is null, and if it is true, PinJoint's translation = Vector.ZERO.  
	pin.set_node_a(node_A.get_path())
	#if node_A == null:
		#pin.transform.origin = Vector3.ZERO 
	#else:
		##If node_A is not = null then we are setting the node_A for PinJoint.  
		#pin.set_node_a(node_A.get_path())
		##Getting the position between node_A and node_B (AKA last_rigidbody and rigidbody variables).
		#var between = _get_pos_between_vectors(node_A.transform.origin,node_B.transform.origin)
		##Setting the given position for the PinJoint.
		#pin.transform.origin = between 
		#print(node_A.transform.origin,"",node_B.transform.origin,"",between)
	#Adding the PinJoint as a child.
	print(node_A.transform.origin,"",node_B.transform.origin)
	pin.transform.origin = node_A.transform.origin
	add_child(pin)
	pass
	
##Getting the position between two vectors.##
func _get_pos_between_vectors(A:Vector3,B:Vector3)->Vector3:
	return (A+B)/2

func _connect_first_pin_to_player(player):
	print("feur")
	_add_pin_joint(player,ROPE_BODIES[0])
	#ROPE_BODIES[0].get_child(0).disabled = true
	
	
func _connect_last_pin_to_player(node_3d):
	_add_pin_joint(node_3d,ROPE_BODIES[last_rope_int])
	#ROPE_BODIES[17].get_child(0).disabled = true

func _disable_collision():
	for i in ROPE_BODIES:
		if i == ROPE_BODIES[0] or i == ROPE_BODIES[last_rope_int]:
			pass
		else:
			i.get_child(0).disabled = true
	#for i in skeleton.get_bone_count(): 
		#var bone_name =skeleton.get_bone_name(i)
		#var id = skeleton.find_bone(bone_name)
		#id.animate_physical_bones = false
