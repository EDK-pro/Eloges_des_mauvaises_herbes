@tool
extends RigidBody3D
class_name all_items


enum Items {FLOWER, GAZLAMP, UMBRELLA, LEVER}
@export var items: Items

const Litems := {FLOWER = "Flower", GAZLAMP = "GazLamp", UMBRELLA = "Umbrella", LEVER = "Lever"}

enum Slots {NONE, SLOT_1, SLOT_2, SLOT_3}
@export var status: Slots

## Description of Item as it'll appear in the HUD / Inventory menu
@export_multiline var description : String = ""
## Path to Scene that will be spawned when item is removed from inventory to be dropped into the world.
@export_file("*.tscn") var drop_scene

@export_subgroup("Audio")
## Audio that plays when item is used.
@export var sound_use : AudioStream
@export var sound_pickup : AudioStream
@export var sound_drop : AudioStream

@export_group("Consumable settings")
## Name of attribute that the item is going to replenish. (For example "health")
@export var attribute_name : String
## The change amount that gets applied to the attribute. (For example 25 to heal 25hp. Allows negative values too.)
@export var attribute_change_amount : float


@export_subgroup("Animations")
@export var equip_anim : String
@export var unequip_anim : String
@export var use_anim : String

var player_interaction_component
var is_being_selected : bool
var wielded_item

signal prendre_objet
signal item_placed(slot,etat)
signal poser_objet

@export var slots: Array
@export var feur: all_items
var slot_used: Array=[0,0,0]

var circle

func put_in_slot(item,slot):
	if slot_used[slot] != 1:
		self.status = slot+1
		set_collision_layer_value(1,false)
		self.freeze = true
		item_placed.emit(slot, 1, self)
	
func remove_from_slot(slot):
	if slot_used[slot] != 0:
		self.status = Slots.NONE
		set_collision_layer_value(1,true)
		self.freeze = false
		item_placed.emit(slot, 0, self)
	
func _on_item_placed(slot,state,useless):
	slot_used[slot] = state
