extends RigidBody2D

onready var line = get_node("Line2D")
onready var shadow = get_node("Shadow")
onready var timer = get_node("Timer")

export var damage : float = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var angle = linear_velocity.angle()
	line.set_rotation(angle)
	shadow.set_rotation(angle)
	if linear_velocity.length_squared() < 20:
		self.queue_free()

func _on_Timer_timeout():
	self.queue_free()

func set_dir(angle : float):
	line.set_rotation(angle)
	shadow.set_rotation(angle)

func set_timeout(timeout : float):
	timer.start(timeout)

func _on_EnemyBullet_body_entered(body : Node):
	if body.has_method("damage"):
		body.damage(damage, self.get_global_position())
	self.queue_free()

func _on_EnemyBullet_body_exited(body : Node):
	_on_EnemyBullet_body_entered(body)
