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
export var speed : float = 5000

onready var firetimer = get_node("FireTimer")
onready var pathtimer = get_node("RepathTimer")
onready var firepoint = get_node("Farmer/Flipper/FirePoint")
onready var animp = get_node("AnimationPlayer")

onready var enemybullet = preload("res://Enemies/EnemyBullet.tscn")
onready var blood = preload("res://Enemies/Blood.tscn")

var cur_state = ai_state.idle
var path_to_player : PoolVector2Array = PoolVector2Array()

# Called when the node enters the scene tree for the first time.
func _ready():
	_change_ai_state(ai_state.towards)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if cur_state == ai_state.idle:
		pass
	elif cur_state == ai_state.towards:
		_move_to_player(delta)
	elif cur_state == ai_state.shoot:
		pass
	elif cur_state == ai_state.runaway:
		pass

func _change_ai_state(newstate):
	if cur_state == newstate:
		return
	var prev_state = cur_state
	
	if prev_state == ai_state.idle:
		pass
	if prev_state == ai_state.towards:
		pathtimer.stop()
		animp.stop(false)
	if prev_state == ai_state.shoot:
		firetimer.start()
	if prev_state == ai_state.runaway:
		pass
	if prev_state == ai_state.dead:
		pass
	
	if newstate == ai_state.idle:
		pass
	if newstate == ai_state.towards:
		_repath()
		pathtimer.start()
		animp.play("Walk")
	if newstate == ai_state.shoot:
		firetimer.stop()
	if newstate == ai_state.runaway:
		pass
	if newstate == ai_state.dead:
		_die()
	
	cur_state = newstate

func _move_to_player(delta : float):
	if path_to_player.empty():
		return
	
	var nextp = path_to_player[0]
	var dirvec = get_position().direction_to(nextp)
	self.apply_central_impulse(dirvec * speed * delta)
	
	if get_position().distance_to(nextp) < max(10, (self.linear_velocity.length() * delta * 1.2)):
		path_to_player.remove(0)
	

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
			_change_ai_state(ai_state.dead)

func _die():
	self.mass = 20
	self.collision_layer = 0
	self.collision_mask = 0
	self.z_index = -2
	animp.play("Death")

func _repath():
	path_to_player = Global.navmesh.get_simple_path(self.position, Global.player.position)

func _on_FireTimer_timeout():
	_shoot()

func _on_RepathTimer_timeout():
	_repath()
