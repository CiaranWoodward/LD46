extends MarginContainer

signal item_bought

export var description : String = "Flamethrower"
export var cost : int = 100
export var texture : Texture = null

onready var nameLabel = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/NameLabel")
onready var costLabel = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CostLabel")
onready var itemImage = get_node("PanelContainer/MarginContainer/HBoxContainer/CenterContainer/ItemImage")
onready var button = get_node("PanelContainer/Button")

# Called when the node enters the scene tree for the first time.
func _ready():
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
