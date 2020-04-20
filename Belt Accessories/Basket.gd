extends BeltItem

onready var eggparts = get_node("EggParticles")

func _ready():
	pass

func set_eggcontent(eggc : int):
	eggparts.amount = eggc
	eggparts.restart()
	.set_eggcontent(eggc)
