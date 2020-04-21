extends MarginContainer

onready var mouseGrab = get_node("MouseGrab")

onready var player = preload("res://Player/Player.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	for itemb in get_node("HBoxContainer/ScrollContainer/VBoxContainer").get_children():
		itemb.connect("item_bought", self, "_on_item_bought")
	
	if Global.get_networth() < 25:
		get_node("EggCome").popup_centered()

func _on_item_bought(itemButton):
	mouseGrab.bind(itemButton.cost, itemButton.texture, itemButton.sceneTarget, itemButton.is_weapon)

func _on_BattleButton_pressed():
	var root = get_tree().get_root()
	var thisscene = root.get_child(root.get_child_count() - 1)
	root.remove_child(thisscene)
	root.add_child(Global.curScene)
	thisscene.call_deferred("free")
	
	var newplayer = player.instance()
	Global.curScene.find_node("YSort").add_child(newplayer)
	newplayer.set_global_position(Global.oldpos)
