extends Node2D
class_name BeltItem

export var description : String = "Basket"
export var cost : int = 5
export var is_weapon : bool = false
export var icon_texture : Texture = null
export var egg_capacity : int = 0

var cur_rotsprite = -1 setget set_rotsprite, get_rotsprite
var egg_content = 0 setget set_eggcontent, get_eggcontent

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_eggcontent(eggc : int):
	var diff = eggc - egg_content
	egg_content = eggc
	Global.mod_eggcontent(diff)

func mod_eggcontent(eggd):
	set_eggcontent(egg_content + eggd)

func get_eggcontent() -> int:
	return egg_content

func set_rotsprite(dir : int):
	if dir == cur_rotsprite:
		return
	assert(dir >= 0 && dir <= 7)
	for i in range(8):
		self.get_node(str(i)).visible = (i == dir)
	cur_rotsprite = dir

func get_rotsprite() -> int:
	return cur_rotsprite

func get_cost() -> int:
	return cost

func set_cost(acost : int):
	cost = acost

func begin_fire(body : RigidBody2D):
	pass

func end_fire():
	pass
