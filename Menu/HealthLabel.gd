extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	text = str(Global.get_playerhealth()) + "%"
	Global.connect("playerhealth_change", self, "_on_health_change")

func _on_health_change():
	text = str(Global.get_playerhealth()) + "%"
