extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_node("Yolk").emitting = true
	get_node("White").emitting = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !get_node("Yolk").emitting && !get_node("White").emitting:
		self.queue_free()
