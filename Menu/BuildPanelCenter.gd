extends Node2D

export var radius : float = 100
export var thickness : float = 10
export var linecolor : Color = Color.gray
export var fillcolor : Color = Color.skyblue

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(Vector2.ZERO, radius, linecolor)
	draw_circle(Vector2.ZERO, radius - thickness, fillcolor)
