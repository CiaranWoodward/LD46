extends BeltItem

export var health : float = 50.0

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
