extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(Global.eggcount)
	Global.connect("eggcount_change", self, "_on_eggcount_change")

func _on_eggcount_change(newcount : int):
	text = str(newcount)
