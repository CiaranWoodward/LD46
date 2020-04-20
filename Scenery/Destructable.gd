extends RigidBody2D

export var health : float = 50

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage(damage : float):
	health = health - damage
	if health <= 0:
		self.queue_free()
