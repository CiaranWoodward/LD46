extends Sprite

func _ready():
	Global.connect("playerhealth_change", self, "_on_health_change")

func _on_health_change():
	if Global.get_playerhealth() <= 0:
		self.visible = true
