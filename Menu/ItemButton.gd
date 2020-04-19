extends MarginContainer

signal item_bought

export var sceneTarget : PackedScene = null
var description : String = "Invalid"
var cost : int = 999999
var texture : Texture = null
var is_weapon : bool = false

onready var nameLabel = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/NameLabel")
onready var costLabel = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CostLabel")
onready var itemImage = get_node("PanelContainer/MarginContainer/HBoxContainer/CenterContainer/ItemImage")
onready var button = get_node("PanelContainer/Button")

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_instance_valid(sceneTarget):
		var tscene = sceneTarget.instance()
		description = tscene.description
		cost = tscene.cost
		texture = tscene.icon_texture
		is_weapon = tscene.is_weapon
		tscene.queue_free()
	
	nameLabel.text = description
	costLabel.text = str(cost)
	if is_instance_valid(texture):
		itemImage.texture = texture
	texture = itemImage.texture
	Global.connect("eggcount_change", self, "_on_eggcount_changed")
	_on_eggcount_changed(Global.get_eggcount())

func _on_eggcount_changed(count : int):
	if count >= cost:
		button.disabled = false
	else:
		button.disabled = true

func _on_Button_pressed():
	if Global.get_eggcount() >= cost:
		Global.mod_eggcount(-cost)
		emit_signal("item_bought", self)
