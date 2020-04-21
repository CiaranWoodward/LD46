extends StaticBody2D

export var nextLevel : PackedScene = null

var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if enabled:
		if Input.is_action_just_released("interact"):
			get_tree().change_scene_to(nextLevel)
			get_tree().get_root()

func _on_LevelExit_body_entered(body : Node2D):
	if body.has_method("get_heartpos"):
		enabled = true
		get_node("p").visible = true

func _on_LevelExit_body_exited(body):
	if body.has_method("get_heartpos"):
		enabled = false
		get_node("p").visible = false
