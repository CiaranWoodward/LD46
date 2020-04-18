extends Node2D

onready var sprite : Sprite = get_node("Sprite")

var cost = 0
var active : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	_set_active(false)

func _set_active(active: bool):
	self.active = active
	self.visible = active

func bind(cost : int, texture : Texture):
	unbind()
	self.cost = cost
	sprite.set_texture(texture)
	_set_active(true)

func unbind():
	if(self.active):
		_set_active(false)
		Global.mod_eggcount(self.cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_released("ui_cancel"):
		unbind()
	if active:
		set_position(get_parent().get_local_mouse_position())
