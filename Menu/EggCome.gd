extends AcceptDialog

# Called when the node enters the scene tree for the first time.
func _ready():
	self.get_ok().text = "Thanks!"
	self.get_close_button().visible = false

func _on_EggCome_confirmed():
	Global.mod_eggcount(25)
