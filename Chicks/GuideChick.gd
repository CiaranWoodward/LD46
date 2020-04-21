extends StaticBody2D

export (PoolStringArray) var speech : PoolStringArray = PoolStringArray()

var curSpeech = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextTimer_timeout():
	if speech.size() == 0:
		return
	
	if speech[curSpeech].length() == 0:
		get_node("TextBox").visible = false
	else:
		get_node("TextBox").visible = true
	
	get_node("TextBox/Label").text = speech[curSpeech]
	
	curSpeech = (curSpeech + 1) % speech.size()
