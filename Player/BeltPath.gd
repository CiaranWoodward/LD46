extends Path2D

onready var temppf = get_node("PathFollow2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_belt_angle(angle : float):
	_set_belt_pos(temppf, angle - (PI/2))

func _set_belt_pos(pf : PathFollow2D, angle : float):
	if angle < 0:
		angle = angle + 2*PI
	
	var ratio = angle / (2*PI)
	
	pf.unit_offset = ratio
	
	#Z-level
	if ratio < 0.25 || ratio > 0.75:
		pf.z_index = 0
	else:
		pf.z_index = -1
	
	#Sprite
	var item = pf.get_children()[0]
	if is_instance_valid(item) && item.has_method("set_rotsprite"):
		if ratio < 0.175:
			item.set_rotsprite(0)
		elif ratio < 0.225:
			item.set_rotsprite(1)
		elif ratio < 0.275:
			item.set_rotsprite(2)
		elif ratio < 0.325:
			item.set_rotsprite(3)
		elif ratio < 0.675:
			item.set_rotsprite(4)
		elif ratio < 0.725:
			item.set_rotsprite(5)
		elif ratio < 0.775:
			item.set_rotsprite(6)
		elif ratio < 0.825:
			item.set_rotsprite(7)
		else:
			item.set_rotsprite(0)