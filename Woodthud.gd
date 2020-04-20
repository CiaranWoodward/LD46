extends AudioStreamPlayer2D

func _ready():
	self.pitch_scale = rand_range(0.8, 1.2)
	self.play() 

func _on_Woodthud_finished():
	self.queue_free()
