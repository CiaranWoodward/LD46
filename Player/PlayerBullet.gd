extends RigidBody2D

onready var line = get_node("Line2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	line.set_rotation(linear_velocity.angle())

func _on_Timer_timeout():
	self.queue_free()
