extends Area2D

func _ready():
	get_node("AnimationPlayer/AnimationTree").advance(rand_range(0, 1))

func collect():
	set_deferred("monitorable", false)
	self.queue_free()
