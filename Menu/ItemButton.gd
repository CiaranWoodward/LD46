extends MarginContainer

export var description : String = "Flamethrower"
export var cost : int = 100
export var texture : Texture = null

onready var nameLabel = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/NameLabel")
onready var costLabel = get_node("PanelContainer/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer/CostLabel")
onready var itemImage = get_node("PanelContainer/MarginContainer/HBoxContainer/CenterContainer/ItemImage")

# Called when the node enters the scene tree for the first time.
func _ready():
	nameLabel.text = description
	costLabel.text = str(cost)
	if is_instance_valid(texture):
		itemImage.texture = texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
