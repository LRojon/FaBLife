extends Control

const ERR_POPUP = preload("res://Scenes/Menus/Popup/error_popup.tscn")
const MENU_OPTION = preload("res://Scenes/Menus/Settings/menu_option_row.tscn")
const MAX_BTN = 5

@onready var quit          = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Quit
@onready var rowsContainer = $MarginContainer/PanelContainer/MarginContainer/VBoxContainer/ScrollContainer/RowsContainer

func _ready() -> void:
	Event.connect("menu_changed", _update_options)
	Event.connect("check_pressed", _on_check_pressed)
	Event.connect("up_pressed", _on_up_pressed)
	Event.connect("bottom_pressed", _on_bottom_pressed)
	
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

func _get_nb_btn_enbaled():
	var ret : int = 0
	for el in Settings.menuOption:
		if el[1]:
			ret += 1
	return ret

func _on_check_pressed(_id: int):
	for el in Settings.menuOption:
		if el[0] == _id:
			if _get_nb_btn_enbaled() >= MAX_BTN and !el[1]:
				var instance: ErrorPopup = ERR_POPUP.instantiate()
				instance.message = "Vous ne pouvez pas avoir plus de 5 boutons."
				get_tree().root.add_child(instance)
				_update_options()
				return
			el[1] = !el[1]
			Data.menuOption[_id].enabled = !Data.menuOption[_id].enabled
			break
	Settings._save()
	Event.emit_signal("menu_editor_changed")
	_update_options()

func _on_up_pressed(_id: int):
	var pos = 0
	for el in Settings.menuOption:
		if el[0] == _id:
			break
		pos += 1
	if pos == 0:
		return
	var tmp: Array = Settings.menuOption[pos]
	Settings.menuOption[pos] = Settings.menuOption[pos - 1]
	Settings.menuOption[pos - 1] = tmp
	Settings._save()
	Event.emit_signal("menu_editor_changed")
	_update_options()


func _on_bottom_pressed(_id: int):
	var pos = 0
	for el in Settings.menuOption:
		if el[0] == _id:
			break
		pos += 1
	if pos == len(Settings.menuOption):
		return
	var tmp: Array = Settings.menuOption[pos]
	Settings.menuOption[pos] = Settings.menuOption[pos + 1]
	Settings.menuOption[pos + 1] = tmp
	Settings._save()
	Event.emit_signal("menu_editor_changed")
	_update_options()
