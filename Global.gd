extends Node

signal eggcount_change
signal eggcontent_change
signal playerhealth_change

var eggcount = 0 setget set_eggcount, get_eggcount
var beltitems = [null, null, null, null, null, null, null, null]
var bulletField = null
var player : RigidBody2D = null
var navmesh : Navigation2D = null
var eggcapacity = 0
var eggcontent = 0
var playerhealth : int = 100 setget set_playerhealth, get_playerhealth
var curScene = null
var oldpos = Vector2.INF

func reset():
	eggcount = 0
	eggcapacity = 0
	eggcontent = 0
	emit_signal("eggcount_change", 0)
	emit_signal("eggcontent_change")

func set_playerhealth(health : int):
	playerhealth = health
	emit_signal("playerhealth_change")

func get_playerhealth() -> int:
	return playerhealth

func set_eggcount(count : int):
	eggcount = count
	emit_signal("eggcount_change", eggcount)

func get_eggcount() -> int:
	return eggcount

func mod_eggcount(delta : int):
	eggcount = eggcount + delta
	emit_signal("eggcount_change", eggcount)

func get_eggcapacity() -> int:
	return eggcapacity

func get_eggcontent() -> int:
	return eggcontent

#returns true if successfully added, otherwise false
func mod_eggcontent(delta : int):
	eggcontent = eggcontent + delta
	emit_signal("eggcontent_change")

func clear_eggcontent():
	eggcontent = 0
	emit_signal("eggcontent_change")

func get_networth() -> int:
	var worth = eggcount
	for item in beltitems:
		if is_instance_valid(item):
			var temp = item.instance()
			worth = worth + temp.cost
			temp.queue_free()
	worth = worth + get_eggcontent()
	return worth

func get_beltitem(index : int):
	return beltitems[index]

func destroy_beltitem(index: int):
	#defensive scripting
	if index < 0 || index > 7:
		return
	if is_instance_valid(beltitems[index]):
		var titem = beltitems[index].instance()
		if titem.egg_capacity > 0:
			eggcapacity = eggcapacity - titem.egg_capacity
			emit_signal("eggcontent_change")
		titem.queue_free()
	beltitems[index] = null

func set_beltitem(index : int, item):
	var egcc = false
	if is_instance_valid(beltitems[index]):
		var titem = beltitems[index].instance()
		if titem.egg_capacity > 0:
			eggcapacity = eggcapacity - titem.egg_capacity
			egcc = true
		titem.queue_free()
	beltitems[index] = item
	if is_instance_valid(item):
		var titem = item.instance()
		if titem.egg_capacity > 0:
			eggcapacity = eggcapacity + titem.egg_capacity
			egcc = true
		titem.queue_free()
	if egcc:
		emit_signal("eggcontent_change")
