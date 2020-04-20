extends BeltItem

onready var eggparts = get_node("EggParticles")
onready var eggsplode = preload("res://Belt Accessories/Eggsplode.tscn")
onready var area = get_node("CollisionShape2D")

func _ready():
	pass

func set_eggcontent(eggc : int):
	if eggc < egg_content:
		var newsplode = eggsplode.instance()
		add_child(newsplode)
	
#	if eggc > 0:
#		area.disabled = false
#	else:
#		area.disabled = true
	
	eggparts.amount = eggc
	eggparts.restart()
	.set_eggcontent(eggc)

func damage(damage : float, gpos : Vector2):
	print("yo")
	set_eggcontent(egg_content - 1)
