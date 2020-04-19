extends BeltItem

onready var animp = get_node("AnimationPlayer")

var isfiring : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_rotsprite(dir : int):
	if dir == cur_rotsprite:
		return
	assert(dir >= 0 && dir <= 7)
	for i in range(8):
		self.get_node(str(i) + "P").emitting = (i == dir && isfiring)

	.set_rotsprite(dir)

func begin_fire():
	animp.play("Fire")
	isfiring = true
	self.get_node(str(cur_rotsprite) + "P").emitting = true

func end_fire():
	animp.play("Idle")
	isfiring = false
	self.get_node(str(cur_rotsprite) + "P").emitting = false
