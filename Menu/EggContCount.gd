extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(Global.get_eggcontent()) + "/" + str(Global.get_eggcapacity())
	Global.connect("eggcontent_change", self, "_on_eggcont_change")

func _on_eggcont_change():
	text = str(Global.get_eggcontent()) + "/" + str(Global.get_eggcapacity())
