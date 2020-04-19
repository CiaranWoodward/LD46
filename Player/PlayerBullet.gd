extends RigidBody2D

onready var line = get_node("Line2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	line.set_rotation(linear_velocity.angle())
	if linear_velocity.length_squared() < 20:
		self.queue_free()

func _on_Timer_timeout():
	self.queue_free()

func set_dir(angle : float):
	line.set_rotation(angle)
