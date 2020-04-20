extends RigidBody2D

export var health : float = 50

var hitparts = preload("res://Player/HitParts.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func damage(damage : float, gpos : Vector2):
	health = health - damage
	var hp = hitparts.instance()
	add_child(hp)
	hp.set_global_position(gpos)
	hp.emitting = true
	if health <= 0:
		self.queue_free()
