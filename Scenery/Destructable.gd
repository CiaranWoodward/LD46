extends RigidBody2D

export var health : float = 50

var hitparts = preload("res://Player/HitParts.tscn")

onready var navpoly = get_node("NavigationPolygonInstance")

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid(navpoly) && is_instance_valid(Global.navmesh):
		Global.navmesh.get_children()[0].get_navigation_polygon().add_outline(navpoly.get_navigation_polygon().get_outline(0))
		Global.navmesh.get_children()[0].get_navigation_polygon().make_polygons_from_outlines()
	

func damage(damage : float, gpos : Vector2):
	health = health - damage
	
	if gpos != Vector2.INF:
		var hp = hitparts.instance()
		add_child(hp)
		hp.set_global_position(gpos)
		hp.emitting = true
		if health <= 0:
			self.queue_free()
