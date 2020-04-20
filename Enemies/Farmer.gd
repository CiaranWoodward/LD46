extends RigidBody2D

enum ai_state{
	idle,
	towards,
	shoot,
	runaway,
	dead
	}

export var bulletforce : float = 900
export var spread : float = 0.2
export var bulletmass : float = 0.1
export var health : float = 100.0

onready var firetimer = get_node("FireTimer")
onready var firepoint = get_node("Farmer/Flipper/FirePoint")
onready var animp = get_node("AnimationPlayer")

onready var enemybullet = preload("res://Enemies/EnemyBullet.tscn")
onready var blood = preload("res://Enemies/Blood.tscn")

var cur_state = ai_state.shoot

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if cur_state == ai_state.idle:
		pass
	elif cur_state == ai_state.towards:
		pass
	elif cur_state == ai_state.shoot:
		pass
	elif cur_state == ai_state.runaway:
		pass

func _change_ai_state(newstate):
	cur_state = newstate

func _shoot():
	if cur_state != ai_state.shoot:
		return
	var fp = firepoint.get_global_position()
	var newBullet = enemybullet.instance()
	if !is_instance_valid(Global.bulletField):
		return
	Global.bulletField.add_child(newBullet)
	newBullet.set_global_position(fp)
	var toplayer = Global.player.get_global_position() - firepoint.get_global_position()
	# Extrapolate player's future position
	var timetoplayer = toplayer.length() / bulletforce
	toplayer = toplayer + timetoplayer * Global.player.linear_velocity
	var newforce = toplayer.normalized() * bulletforce
	newforce.x = newforce.x * (1 + rand_range(-spread, spread))
	newforce.y = newforce.y * (1 + rand_range(-spread, spread))
	newBullet.mass = bulletmass
	newBullet.linear_velocity = newforce
	newBullet.set_dir(newforce.angle())
	animp.play("Wobble")

func damage(damage : float, gpos : Vector2):
	health = health - damage
	
	if gpos != Vector2.INF:
		var hp = blood.instance()
		add_child(hp)
		hp.set_global_position(gpos)
		hp.emitting = true
		if health <= 0:
			_die()

func _die():
	self.mass = 20
	self.collision_layer = 0
	self.collision_mask = 0
	self.z_index = -2
	animp.play("Death")
	_change_ai_state(ai_state.dead)

func _on_FireTimer_timeout():
	_shoot()
