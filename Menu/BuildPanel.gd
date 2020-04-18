extends PanelContainer

onready var centerPoint = get_node("BuildPanelCenter")

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_BuildPanel_resized()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BuildPanel_resized():
	centerPoint.set_position(self.get_rect().size / 2)
