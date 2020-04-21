extends StaticBody2D

export var nextLevel : PackedScene = null

var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	if enabled && is_instance_valid(nextLevel):
		if Input.is_action_just_released("interact"):
			var root = get_tree().get_root()
			Global.oldpos = Vector2.INF
			Global.curScene = null
			Global.mod_eggcount(Global.get_eggcontent())
			Global.clear_eggcontent()
			
			var thisscene = root.get_child(root.get_child_count() - 1)
			root.remove_child(thisscene)
			root.add_child(nextLevel.instance())
			thisscene.call_deferred("free")

func _on_LevelExit_body_entered(body : Node2D):
	if body.has_method("get_heartpos") && is_instance_valid(nextLevel):
		enabled = true
		get_node("p").visible = true

func _on_LevelExit_body_exited(body):
	if body.has_method("get_heartpos") && is_instance_valid(nextLevel):
		enabled = false
		get_node("p").visible = false
