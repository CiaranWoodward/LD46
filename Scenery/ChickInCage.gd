extends RigidBody2D

export var health : float = 50

var hitparts = preload("res://Player/HitParts.tscn")
var hitsound = preload("res://Scenery/Woodthud.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func damage(damage : float, gpos : Vector2):
	health = health - damage
	
	var hs = hitsound.instance()
	hs.stream = preload("res://Sounds/Dong.wav")
	add_child(hs)
	
	if gpos != Vector2.INF:
		var hp = hitparts.instance()
		add_child(hp)
		hp.set_global_position(gpos)
		hp.emitting = true
		if health <= 0:
			get_node("AnimationPlayer").play("Free")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "Free":
		self.queue_free()
