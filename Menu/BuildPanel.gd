extends PanelContainer

onready var centerPoint = get_node("BuildPanelCenter")
onready var mouseGrab = get_node("../../MouseGrab")

# Called when the node enters the scene tree for the first time.
func _ready():
	_on_BuildPanel_resized()

func _on_BuildPanel_resized():
	centerPoint.set_position(self.get_rect().size / 2)


func _on_BuildPanel_gui_input(event : InputEvent):
	if event is InputEventMouse:
		var relPos = event.get_position() - centerPoint.get_position()
		centerPoint.set_mousepos(relPos)
		if event.is_action_released("ui_accept") && mouseGrab.visible:
			if centerPoint.place_item(mouseGrab.get_texture(), mouseGrab.cost):
				mouseGrab.drop()
		if event.is_action_released("ui_cancel") && !mouseGrab.visible:
			centerPoint.remove_item()

