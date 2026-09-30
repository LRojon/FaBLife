class_name FormatMenu
extends Control

const FORMAT_BUTTON      = preload("res://Scenes/Menus/format_button.tscn")
const FORMAT_QUIT_BUTTON = preload("res://Scenes/Menus/format_quit_button.tscn")


@onready var list = $VBoxContainer/HBoxContainer2/Container
@onready var quit = $VBoxContainer/QuitContainer

func _ready() -> void:
	_update_buttons()
	
	Event.connect("format_selected", func(format):
		self.queue_free()
	)

func _update_buttons():
	for child in list.get_children():
		if child is FormatButton:
			child.queue_free()
	
	for f: Data.Format in Data.Format.values():
		var instance: FormatButton = FORMAT_BUTTON.instantiate()
		instance.format = f
		instance.disabled = f == Data.Format.UPF # UPF Coming soon
		list.add_child(instance)
	var instance = FORMAT_QUIT_BUTTON.instantiate()
	quit.add_child(instance)
