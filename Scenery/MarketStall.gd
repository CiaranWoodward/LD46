extends StaticBody2D

var colors = [Color("#309f08"), Color("#d91313"), Color("#b7e9e0"), Color("#1fa88f"), Color("#9785e2"), Color("#ffd200"), Color("#0061ff")]

# Called when the node enters the scene tree for the first time.
func _ready():
	var i = randi() % colors.size()
	
	get_node("ColourLayer_05x").modulate = colors[i]

