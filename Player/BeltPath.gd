extends Path2D

var pfs = Array()

const lweapon = 5
const rweapon = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(8):
		var newpf = PathFollow2D.new()
		newpf.set_rotate(false)
		add_child(newpf, true)
		pfs.push_back(newpf)
		if is_instance_valid(Global.get_beltitem(i)):
			var newitem = Global.get_beltitem(i).instance()
			newitem.slotno = i
			if i == 5:
				newitem.scale.x = -1
			newpf.add_child(newitem)

func set_belt_angle(angle : float):
	var angle_offset = -(PI/4)
	for i in range(8):
		if pfs[i].visible:
			_set_belt_pos(pfs[i], angle + angle_offset, i == 5)
		angle_offset += PI/4

func get_left_weapon() -> BeltItem:
	return _get_item(lweapon)

func get_right_weapon() -> BeltItem:
	return _get_item(rweapon)

func _add_egg() -> bool:
	var potentials = Array()
	for i in range(8):
		var item = _get_item(i)
		if is_instance_valid(item):
			if item.egg_capacity > item.egg_content:
				potentials.push_back(item)
	if potentials.size() == 0:
		return false
	var i = randi() % potentials.size()
	potentials[i].egg_content = potentials[i].egg_content + 1
	return true

func _get_item(slotno : int) -> BeltItem:
	var slot = pfs[slotno]
	if slot.visible && slot.get_child_count() > 0:
		return slot.get_children().front()
	return null

func _set_belt_pos(pf : PathFollow2D, angle : float, flipped := false):
	if angle < 0:
		angle = angle + 2*PI
	
	var ratio = angle / (2*PI)
	
	pf.unit_offset = ratio
	
	#Z-level
	if ratio < 0.25 || ratio > 0.75:
		pf.z_index = 0
	else:
		pf.z_index = -2
	
	#Sprite
	var item = null
	if pf.get_child_count() > 0:
		item = pf.get_children().front()
	if is_instance_valid(item) && item.has_method("set_rotsprite"):
		if ratio < 1.0/9.0:
			item.set_rotsprite(0)
		elif ratio < 2.0/9.0:
			item.set_rotsprite(1)
		elif ratio < 3.0/9.0:
			item.set_rotsprite(2)
		elif ratio < 4.0/9.0:
			item.set_rotsprite(3)
		elif ratio < 5.0/9.0:
			item.set_rotsprite(4)
		elif ratio < 6.0/9.0:
			item.set_rotsprite(5)
		elif ratio < 7.0/9.0:
			item.set_rotsprite(6)
		elif ratio < 8.0/9.0:
			item.set_rotsprite(7)
		else:
			item.set_rotsprite(0)
		
		if flipped:
			var currot = item.get_rotsprite()
			currot = (8 - currot) % 8
			item.set_rotsprite(currot)


func _on_EggCollect_area_entered(area):
	if area.has_method("collect") && _add_egg():
		area.collect()
