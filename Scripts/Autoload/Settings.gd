extends Node

var modeV : bool = true
var menuOption : Array[Array] = [
	[3, true],
	[4, true],
	[7, true],
	[2, true],
	[6, true],
	[5, false],
	[0, false],
	[1, false],
]

func _ready() -> void:
	_load()
	Event.connect("change_modev", func ():
		modeV = !modeV
		Event.emit_signal("modev_changed")
	)
	


func _save():
	pass

func _load():
	pass
