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


func _on_BuildPanel_gui_input(event : InputEvent):
	if event is InputEventMouse:
		var relPos = event.get_position() - centerPoint.get_position()
		centerPoint.set_mousepos(relPos)
