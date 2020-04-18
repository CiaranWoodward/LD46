extends Node

signal eggcount_change

var eggcount = 10

func reset():
	eggcount = 10
	emit_signal("eggcount_change")

func set_eggcount(count : int):
	eggcount = count
	emit_signal("eggcount_change", eggcount)

func get_eggcount() -> int:
	return eggcount

func mod_eggcount(delta : int):
	eggcount = eggcount + delta
	emit_signal("eggcount_change", eggcount)
