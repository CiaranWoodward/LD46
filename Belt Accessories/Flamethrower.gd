extends BeltItem

export var damagemultiplier : float = 5
export var bulletforce : float = 300
export var spread : float = 0.5
export var bulletmass : float = 0.03
export var damage : float = 15

onready var flame = get_node("Flame")
onready var fireTimer = get_node("FireTimer")
onready var playerBullet = preload("res://Player/PlayerBullet.tscn")

var isfiring : bool = false
var parent : RigidBody2D = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta: float):
	if isfiring:
		flame.rotate(flame.get_local_mouse_position().angle())

func set_rotsprite(dir : int):
	if dir == cur_rotsprite:
		return
	assert(dir >= 0 && dir <= 7)
	flame.set_position(get_node("FP" + str(dir)).get_position())
	.set_rotsprite(dir)

func begin_fire(body : RigidBody2D):
	parent = body
	isfiring = true
	flame.rotate(flame.get_local_mouse_position().angle())
	flame.emitting = true
	if fireTimer.is_stopped():
		fireTimer.start()
		_shoot()

func end_fire():
	isfiring = false
	flame.emitting = false

func _shoot():
	var fp = self.get_node("FP" + str(cur_rotsprite)).get_global_position()
	var newBullet = playerBullet.instance()
	if !is_instance_valid(Global.bulletField):
		return
	Global.bulletField.add_child(newBullet)
	newBullet.set_global_position(fp)
	var newforce = newBullet.get_local_mouse_position().normalized() * bulletforce
	newforce.x = newforce.x * (1 + rand_range(-spread, spread))
	newforce.y = newforce.y * (1 + rand_range(-spread, spread))
	newBullet.mass = bulletmass
	newBullet.linear_velocity = newforce
	newBullet.set_dir(newforce.angle())
	newBullet.set_timeout(0.5)
	newBullet.damage = damage
	newBullet.visible = false

func _on_FireTimer_timeout():
	if isfiring:
		_shoot()
	else:
		fireTimer.stop()
