extends BeltItem

onready var eggparts = get_node("EggParticles")
onready var eggsplode = preload("res://Belt Accessories/Eggsplode.tscn")

func _ready():
	pass

func set_eggcontent(eggc : int):
	if eggc < egg_content:
		var newsplode = eggsplode.instance()
		add_child(newsplode)
	
	eggparts.amount = eggc
	eggparts.restart()
	.set_eggcontent(eggc)
