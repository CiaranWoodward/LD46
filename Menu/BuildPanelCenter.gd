extends Node2D

export var radius : float = 100
export var thickness : float = 10
export var linecolor : Color = Color.gray
export var fillcolor : Color = Color.skyblue
export var selectcolor : Color = Color.aqua

const segcount = 8

var curseg : int = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _draw():
	draw_circle(Vector2.ZERO, radius, fillcolor)
	if(curseg != -1):
		draw_circle_arc_poly(Vector2.ZERO, curseg, selectcolor)
	draw_arc(Vector2.ZERO, radius, 0, PI * 2, 40, linecolor, 10, true)

func draw_circle_arc_poly(center, segno, color):
	var nb_points = 10
	var points_arc = PoolVector2Array()
	points_arc.push_back(center)
	var colors = PoolColorArray([color])
	
	var segangle = (2 * PI) / segcount
	var angle_from = segno * segangle + (PI/8)
	var angle_to = (segno + 1) * segangle + (PI/8)

	for i in range(nb_points + 1):
		var angle_point = angle_from + i * (angle_to - angle_from) / nb_points
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)
		colors.push_back(color)
	draw_polygon(points_arc, colors, PoolVector2Array(), null, null, true)

func set_mousepos(point : Vector2):
	var prevseg = curseg
	var mangle = point.angle() - (PI/8)
	if mangle < 0:
		mangle = mangle + PI * 2.0
	
	if point.length() > radius * 2.0:
		curseg = -1
	else:
		curseg = int(mangle / (2.0 * PI) * 8.0)
	if curseg != prevseg:
		update()
