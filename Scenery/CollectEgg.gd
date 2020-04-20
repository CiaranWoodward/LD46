extends Area2D

func _ready():
	get_node("AnimationPlayer/AnimationTree").advance(rand_range(0, 1))

func collect():
	set_deferred("monitorable", false)
	get_node("Eggpop").pitch_scale = rand_range(0.8, 1.2)
	get_node("Eggpop").play()

func _on_Eggpop_finished():
	self.queue_free()
