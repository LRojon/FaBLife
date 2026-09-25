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
var db_src: String = "fabrary"

func _ready() -> void:
	_load()
	Event.connect("change_modev", func ():
		modeV = !modeV
		_save()
		Event.emit_signal("modev_changed")
	)
	Event.connect("change_db_src", func(_id):
		db_src = _id
		_save()
		Event.emit_signal("db_src_changed")
	)
	


func _save():
	pass

func _load():
	pass
