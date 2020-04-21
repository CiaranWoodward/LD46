extends StaticBody2D

onready var desMenu = preload("res://Menu/DesignMenu.tscn")

var enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	if enabled:
		if Input.is_action_just_released("interact"):
			Global.mod_eggcount(Global.get_eggcontent())
			Global.clear_eggcontent()
			var root = get_tree().get_root()
			Global.curScene = root.get_child(root.get_child_count() - 1)
			Global.oldpos = Global.player.get_global_position()
			Global.player.queue_free()
			root.remove_child(Global.curScene)
			var newscene = desMenu.instance()
			root.add_child(newscene)

func _on_BMZone_body_entered(body):
	if body.has_method("get_heartpos"):
		enabled = true
		get_node("p").visible = true


func _on_BMZone_body_exited(body):
	if body.has_method("get_heartpos"):
		enabled = false
		get_node("p").visible = false
