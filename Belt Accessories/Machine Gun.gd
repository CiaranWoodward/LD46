extends BeltItem

export var bulletforce : float = 900
export var spread : float = 0.2
export var bulletmass : float = 0.1
export var damage : float = 8.0

onready var animp = get_node("AnimationPlayer")
onready var fireTimer = get_node("FireTimer")
onready var playerBullet = preload("res://Player/PlayerBullet.tscn")
onready var bang = get_node("bang")

var isfiring : bool = false
var parent : RigidBody2D = null

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

func begin_fire(body : RigidBody2D):
	parent = body
	animp.play("Fire")
	isfiring = true
	self.get_node(str(cur_rotsprite) + "P").emitting = true
	if fireTimer.is_stopped():
		fireTimer.start()
		_shoot()

func end_fire():
	animp.play("Idle")
	isfiring = false
	self.get_node(str(cur_rotsprite) + "P").emitting = false

func _shoot():
	var fp = self.get_node(str(cur_rotsprite) + "FP").get_global_position()
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
	newBullet.damage = damage
	newBullet.set_dir(newforce.angle())
	
	bang.pitch_scale = rand_range(0.8, 1.2)
	bang.play()
	
	if is_instance_valid(parent):
		parent.apply_central_impulse(newforce * -bulletmass)

func _on_FireTimer_timeout():
	if isfiring:
		_shoot()
	else:
		fireTimer.stop()
