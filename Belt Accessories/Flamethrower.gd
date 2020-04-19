extends BeltItem

onready var fireTimer = get_node("FireTimer")

var isfiring : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta: float):
	if isfiring:
		for i in range(8):
			if i == cur_rotsprite:
				var pe = self.get_node("P" + str(i))
				pe.rotate(pe.get_local_mouse_position().angle())

func set_rotsprite(dir : int):
	if dir == cur_rotsprite:
		return
	assert(dir >= 0 && dir <= 7)
	for i in range(8):
		if i == dir && isfiring:
			self.get_node("P" + str(i)).preprocess = 1.9 - fireTimer.time_left
			self.get_node("P" + str(i)).emitting = true
		else:
			self.get_node("P" + str(i)).emitting = false

	.set_rotsprite(dir)

func begin_fire():
	isfiring = true
	self.get_node("P" + str(cur_rotsprite)).emitting = true
	fireTimer.start()

func end_fire():
	isfiring = false
	self.get_node("P" + str(cur_rotsprite)).emitting = false
	for i in range(8):
		self.get_node("P" + str(i)).preprocess = 0.1

func _shoot():
	pass
