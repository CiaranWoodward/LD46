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
export var health : float = 70.0
export var speed : float = 5000
export var perceived_range : float = 600.0
export var sight_range : float = 1100.0
export var pathlen_threshold : float = 1600.0

onready var sensetimer = get_node("SenseTimer")
onready var firetimer = get_node("FireTimer")
onready var pathtimer = get_node("RepathTimer")
onready var firepoint = get_node("Farmer/Flipper/FirePoint")
onready var animp = get_node("AnimationPlayer")
onready var frontsprite = get_node("Farmer/Flipper/Front_05x")
onready var backsprite = get_node("Farmer/Flipper/Back_05x")
onready var flipper = get_node("Farmer/Flipper")
onready var bang = get_node("Bang")
onready var thud = get_node("Thud")

onready var enemybullet = preload("res://Enemies/EnemyBullet.tscn")
onready var blood = preload("res://Enemies/Blood.tscn")

var cur_state = ai_state.idle
var path_to_player : PoolVector2Array = PoolVector2Array()
var pathlen : float = INF

# Called when the node enters the scene tree for the first time.
func _ready():
	#Randomize timers slightly for performance and beauty
	firetimer.wait_time *= rand_range(0.9, 1.1)
	pathtimer.wait_time *= rand_range(0.9, 1.1) 
	sensetimer.wait_time *= rand_range(0.9, 1.1) 
	#we start in idle
	sensetimer.start()

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
		sensetimer.stop()
	elif prev_state == ai_state.towards:
		pathtimer.stop()
		animp.stop(false)
	elif prev_state == ai_state.shoot:
		firetimer.stop()
	elif prev_state == ai_state.runaway:
		pass
	elif prev_state == ai_state.dead:
		pass
	
	cur_state = newstate
	
	if newstate == ai_state.idle:
		sensetimer.start()
	elif newstate == ai_state.towards:
		_repath()
		pathtimer.start()
		animp.play("Walk")
	elif newstate == ai_state.shoot:
		_shoot()
		firetimer.start()
	elif newstate == ai_state.runaway:
		pass
	elif newstate == ai_state.dead:
		_die()
	

func _move_to_player(delta : float):
	if path_to_player.empty():
		return
	
	var nextp = path_to_player[0]
	var dirvec = get_position().direction_to(nextp)
	
	if pathlen < pathlen_threshold:
		self.apply_central_impulse(dirvec * speed * delta)
	
	if self.linear_velocity.y > 10:
		frontsprite.visible = true
		backsprite.visible = false
	elif self.linear_velocity.y < -10:
		frontsprite.visible = false
		backsprite.visible = true
	
	if get_position().distance_to(nextp) < max(10, (self.linear_velocity.length() * delta * 1.2)):
		path_to_player.remove(0)
	
	if _can_see_player():
		_change_ai_state(ai_state.shoot)

func _can_see_player() -> bool:
	# Is player too far away?
	if firepoint.get_global_position().distance_to(Global.player.get_heartpos()) > perceived_range:
		return false
	# Is there hard scenery between us and player?
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(firepoint.get_global_position(), Global.player.get_heartpos(), [self], (1<<1)).empty()

func _get_pathlen() -> float:
	if path_to_player.empty():
		return INF
	
	var prev : Vector2 = Vector2.INF
	var count = 0
	for p in path_to_player:
		if prev != Vector2.INF:
			count = count + prev.distance_to(p)
		prev = p
	return count

func _can_sense_player() -> bool:
	# Is player really close?
	var playerdist = firepoint.get_global_position().distance_to(Global.player.get_heartpos()) 
	if playerdist < perceived_range:
		return true
	
	#Is Player too far away to reasonably see?
	if playerdist > sight_range:
		return false
		
	# Is there hard scenery between us and player?
	var space_state = get_world_2d().direct_space_state
	return space_state.intersect_ray(firepoint.get_global_position(), Global.player.get_heartpos(), [self], (1<<1)).empty()
	

func _sense():
	if cur_state != ai_state.idle:
		return
		
	if _can_sense_player():
		_change_ai_state(ai_state.towards)

func _aim():
	var toplayer = Global.player.get_heartpos() - firepoint.get_global_position()
	if toplayer.x > 50:
		flipper.scale.x = 1
	elif toplayer.x < -50:
		flipper.scale.x = -1

func _shoot():
	if cur_state != ai_state.shoot:
		return

	_aim()
	if !_can_see_player():
		_change_ai_state(ai_state.towards)
		return
	
	var fp = firepoint.get_global_position()
	var newBullet = enemybullet.instance()
	if !is_instance_valid(Global.bulletField):
		return
	Global.bulletField.add_child(newBullet)
	newBullet.set_global_position(fp)
	var toplayer = Global.player.get_heartpos() - firepoint.get_global_position()
	
	if toplayer.y > 50:
		frontsprite.visible = true
		backsprite.visible = false
	elif toplayer.y < -50:
		frontsprite.visible = false
		backsprite.visible = true
	
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
	
	bang.pitch_scale = rand_range(0.8, 1.2)
	bang.play()

func damage(damage : float, gpos : Vector2):
	health = health - damage
	
	if gpos != Vector2.INF:
		var hp = blood.instance()
		add_child(hp)
		hp.set_global_position(gpos)
		hp.emitting = true
		if health <= 0:
			_change_ai_state(ai_state.dead)
	
	thud.pitch_scale = rand_range(0.8, 1.2)
	thud.play()
	
	if cur_state == ai_state.idle:
		_change_ai_state(ai_state.shoot)

func _die():
	self.mass = 20
	self.collision_layer = 0
	self.collision_mask = 0
	self.z_index = -2
	animp.play("Death")

func _repath():
	if cur_state != ai_state.towards:
		return

	path_to_player = Global.navmesh.get_simple_path(self.position, Global.player.position)
	pathlen = _get_pathlen()

func _on_FireTimer_timeout():
	_shoot()

func _on_RepathTimer_timeout():
	_repath()

func _on_SenseTimer_timeout():
	_sense()
