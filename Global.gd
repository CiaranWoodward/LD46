extends Node

signal eggcount_change

var eggcount = 0 setget set_eggcount, get_eggcount
var beltitems = [null, null, null, null, null, null, null, null]

func reset():
	eggcount = 0
	emit_signal("eggcount_change")

func set_eggcount(count : int):
	eggcount = count
	emit_signal("eggcount_change", eggcount)

func get_eggcount() -> int:
	return eggcount

func mod_eggcount(delta : int):
	eggcount = eggcount + delta
	emit_signal("eggcount_change", eggcount)

func get_networth() -> int:
	var worth = eggcount
	for item in beltitems:
		if is_instance_valid(item):
			var temp = item.instance()
			worth = worth + temp.cost
			temp.queue_free()
	return worth

func get_beltitem(index : int):
	return beltitems[index]

func set_beltitem(index : int, item):
	beltitems[index] = item
