extends Control

const MENU_OPTION = preload("res://Scenes/Menus/Settings/menu_option_row.tscn")

@onready var quit          = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Quit
@onready var rowsContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/RowsContainer

func _ready() -> void:
	Event.connect("menu_changed", _update_options)
	_update_options()
	
	quit.connect("pressed", func(): queue_free())


func _update_options():
	for child in rowsContainer.get_children():
		child.queue_free()
	var n = 0
	for mo in Settings.menuOption:
		var instance: MenuOptionRow = MENU_OPTION.instantiate()
		instance.option = Data.MENU_OPTION[mo[0]]
		instance.menu_pos = n
		rowsContainer.add_child(instance)
		n += 1
