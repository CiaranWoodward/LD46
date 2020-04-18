extends RigidBody2D

export var speed : float = 5000

onready var animtree = get_node("Side to Side/AnimationTree")
onready var animsm : AnimationNodeStateMachinePlayback = animtree["parameters/playback"]

# Called when the node enters the scene tree for the first time.
func _ready():
	animtree.active = true
	animsm.start("Idle")
	pass # Replace with function body.

func _physics_process(delta):
	_handle_input(delta)
	
func _handle_input(delta):
	var down = Input.is_action_pressed("player_down")
	var up = Input.is_action_pressed("player_up")
	var left = Input.is_action_pressed("player_left")
	var right = Input.is_action_pressed("player_right")
	
	var dirvec = Vector2.ZERO
	var deg45 = sqrt(1.0/2.0)
	
	if up && right:
		dirvec = Vector2(deg45, -deg45)
	elif down && right:
		dirvec = Vector2(deg45, deg45)
	elif down && left:
		dirvec = Vector2(-deg45, deg45)
	elif up && left:
		dirvec = Vector2(-deg45, -deg45)
	elif up:
		dirvec = Vector2(0, -1)
	elif right:
		dirvec = Vector2(1, 0)
		animsm.travel("Walk")
	elif down:
		dirvec = Vector2(0, 1)
	elif left:
		dirvec = Vector2(-1, 0)
	elif animsm.is_playing():
		animsm.travel("Idle")
	
	# Match Projection
	dirvec.y = dirvec.y / 2.0
	
	if dirvec != Vector2.ZERO:
		self.apply_central_impulse(dirvec * speed * delta)
	else:
		pass
