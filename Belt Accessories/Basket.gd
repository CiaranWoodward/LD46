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
	
	if eggc > 0:
		self.collision_layer = 1
		self.collision_mask = 32
	else:
		self.collision_layer = 0
		self.collision_mask = 0
	
	eggparts.amount = eggc
	eggparts.restart()
	.set_eggcontent(eggc)

func damage(damage : float, gpos : Vector2):
	if egg_content <= 0:
		return
	set_eggcontent(egg_content - 1)
	get_node("Eggsplat").pitch_scale = rand_range(0.8, 1.2)
	get_node("Eggsplat").play()
