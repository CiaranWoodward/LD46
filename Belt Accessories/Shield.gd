extends BeltItem

export var health : float = 50.0

onready var dong = get_node("Dong")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _die():
	Global.destroy_beltitem(slotno)
	self.queue_free()

func damage(damage : float, gpos : Vector2):
	health = health - damage
	if health < 0:
		_die()
	
	dong.pitch_scale = rand_range(0.6, 0.9)
	dong.play()
