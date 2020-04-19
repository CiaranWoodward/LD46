extends Node2D

var cur_rotsprite = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_rotsprite(dir : int):
	if dir == cur_rotsprite:
		return
	assert(dir >= 0 && dir <= 7)
	for i in range(8):
		self.get_node(str(i)).visible = (i == dir)
	cur_rotsprite = dir
