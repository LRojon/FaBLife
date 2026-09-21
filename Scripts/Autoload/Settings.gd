extends Node

var modeV : bool = true

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
