extends Node2D
class_name BeltItem

export var description : String = "Basket"
export var cost : int = 5
export var is_weapon : bool = false
export var icon_texture : Texture = null

var cur_rotsprite = 0 setget set_rotsprite, get_rotsprite

# Called when the node enters the scene tree for the first time.
func _ready():
	set_rotsprite(0)
	pass # Replace with function body.

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
