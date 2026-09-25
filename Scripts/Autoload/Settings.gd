extends Node

const SAVE_PATH = ("user://settings.cfg")

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
	var config = ConfigFile.new()
	
	config.set_value("Settings", "modeV", modeV)
	config.set_value("Settings", "menuOption", menuOption)
	config.set_value("Settings", "dbSrc", db_src)
	
	config.save(SAVE_PATH)

func _load():
	var config = ConfigFile.new()
	
	var err = config.load(SAVE_PATH)
	if err != OK:
		return
	
	modeV = config.get_value("Settings", "modeV")
	menuOption = config.get_value("Settings", "menuOption")
	db_src = config.get_value("Settings", "dbSrc")
	
	for el in menuOption:
		Data.menuOption[el[0]].enabled = el[1]
