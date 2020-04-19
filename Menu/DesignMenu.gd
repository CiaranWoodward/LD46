extends MarginContainer

onready var mouseGrab = get_node("MouseGrab")
onready var nextScene = preload("res://Level.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for itemb in get_node("HBoxContainer/ScrollContainer/VBoxContainer").get_children():
		itemb.connect("item_bought", self, "_on_item_bought")
	
	if Global.get_networth() < 25:
		get_node("EggCome").popup_centered()

func _on_item_bought(itemButton):
	mouseGrab.bind(itemButton.cost, itemButton.texture, itemButton.sceneTarget)

func _on_BattleButton_pressed():
	get_tree().change_scene_to(nextScene)
