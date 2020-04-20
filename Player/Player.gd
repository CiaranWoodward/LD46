extends RigidBody2D

export var speed : float = 5000
export var maxhealth : float = 200

onready var aimPoint = get_node("AimPoint")
onready var belt = get_node("BeltPath")
onready var spriteRoot = get_node("SpriteRoot")
onready var animtree = get_node("Side to Side/AnimationTree")
onready var animsm : AnimationNodeStateMachinePlayback = animtree["parameters/playback"]
onready var smoke = get_node("Smoke")
onready var smoke2 = get_node("Smoke2")
onready var smoke3 = get_node("Smoke3")
onready var smoke4 = get_node("Smoke4")

onready var sideimg = get_node("SpriteRoot/WobbleRoot/Side")
onready var frontimg = get_node("SpriteRoot/WobbleRoot/Front")
onready var backimg = get_node("SpriteRoot/WobbleRoot/Back")
onready var hitparts = preload("res://Player/HitParts.tscn")

var health : float

# Called when the node enters the scene tree for the first time.
func _ready():
	animtree.active = true
	animsm.start("Idle")
	health = maxhealth
	Global.bulletField = get_parent()
	Global.player = self
	Global.playerhealth = 100

func _die():
	var lwep = belt.get_left_weapon()
	var rwep = belt.get_right_weapon()
	
	if is_instance_valid(lwep):
		lwep.end_fire()
	if is_instance_valid(rwep):
		rwep.end_fire()
	if animsm.is_playing():
		_walk_idle()

func damage(damage : float, gpos : Vector2):
	health = health - damage
	
	if health < 0:
		health = 0
		_die()
	
	var healthfrac : float = health/maxhealth
	Global.playerhealth = int(healthfrac * 100)
	
	smoke.emitting = (healthfrac < 0.8)
	smoke2.emitting = (healthfrac < 0.55)
	smoke3.emitting = (healthfrac < 0.35)
	smoke4.emitting = (healthfrac < 0.15)
	
	if gpos != Vector2.INF:
		var hp = hitparts.instance()
		add_child(hp)
		hp.set_global_position(gpos)
		hp.emitting = true

func _physics_process(delta):
	if health > 0:
		_handle_input(delta)
	
func _walk_right():
	animsm.travel("Walk")
	sideimg.get_node("Lever").visible = true
	sideimg.visible = true
	frontimg.visible = false
	backimg.visible = false
	spriteRoot.scale.x = 1

func _walk_left():
	animsm.travel("Walk")
	sideimg.get_node("Lever").visible = false
	sideimg.visible = true
	frontimg.visible = false
	backimg.visible = false
	spriteRoot.scale.x = -1

func _walk_back():
	animsm.travel("BackWalk")
	sideimg.visible = false
	frontimg.visible = false
	backimg.visible = true
	spriteRoot.scale.x = 1

func _walk_front():
	animsm.travel("FrontWalk")
	sideimg.visible = false
	frontimg.visible = true
	backimg.visible = false
	spriteRoot.scale.x = 1

func _walk_idle():
	if animsm.get_current_node() == "Walk":
		animsm.travel("Idle")
	elif animsm.get_current_node() == "FrontWalk":
		animsm.travel("FrontIdle")
	elif animsm.get_current_node() == "BackWalk":
		animsm.travel("BackIdle")

func _handle_aim(delta):
	var mousepos = aimPoint.get_local_mouse_position()
	belt.set_belt_angle(mousepos.angle())

func get_heartpos() -> Vector2:
	return aimPoint.get_global_position()

func _handle_fire(delta):
	var lwep = belt.get_left_weapon()
	var rwep = belt.get_right_weapon()
	
	if is_instance_valid(lwep):
		if Input.is_action_just_pressed("player_leftshoot"):
			lwep.begin_fire(self)
		if Input.is_action_just_released("player_leftshoot"):
			lwep.end_fire()
	
	if is_instance_valid(rwep):
		if Input.is_action_just_pressed("player_rightshoot"):
			rwep.begin_fire(self)
		if Input.is_action_just_released("player_rightshoot"):
			rwep.end_fire()

func _handle_input(delta):
	var down = Input.is_action_pressed("player_down")
	var up = Input.is_action_pressed("player_up")
	var left = Input.is_action_pressed("player_left")
	var right = Input.is_action_pressed("player_right")
	
	var dirvec = Vector2.ZERO
	var deg45 = sqrt(1.0/2.0)
	
	if up && right:
		dirvec = Vector2(deg45, -deg45)
		_walk_right()
	elif down && right:
		dirvec = Vector2(deg45, deg45)
		_walk_right()
	elif down && left:
		dirvec = Vector2(-deg45, deg45)
		_walk_left()
	elif up && left:
		dirvec = Vector2(-deg45, -deg45)
		_walk_left()
	elif up:
		dirvec = Vector2(0, -1)
		_walk_back()
	elif right:
		dirvec = Vector2(1, 0)
		_walk_right()
	elif down:
		dirvec = Vector2(0, 1)
		_walk_front()
	elif left:
		dirvec = Vector2(-1, 0)
		_walk_left()
	elif animsm.is_playing():
		_walk_idle()
	
	# Match Projection
	# dirvec.y = dirvec.y / 2.0
	
	if dirvec != Vector2.ZERO:
		self.apply_central_impulse(dirvec * speed * delta)
	else:
		pass
	
	_handle_aim(delta)
	_handle_fire(delta)
