extends MarginContainer

onready var mouseGrab = get_node("MouseGrab")

# Called when the node enters the scene tree for the first time.
func _ready():
	for itemb in get_node("HBoxContainer/ScrollContainer/VBoxContainer").get_children():
		itemb.connect("item_bought", self, "_on_item_bought")

func _on_item_bought(itemButton):
	mouseGrab.bind(itemButton.cost, itemButton.texture)
