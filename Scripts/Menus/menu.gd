class_name Menu
extends Control

const FORMAT_MENU = preload("res://Scenes/Menus/format_menu.tscn")
const HISTORIQUE  = preload("res://Scenes/Menus/historique.tscn")

@onready var hero_btn = $VBoxContainer/HBoxContainer/Button/Hero
@onready var histo_btn = $VBoxContainer/HBoxContainer/Button2/Historique

func _ready() -> void:
	hero_btn.connect("pressed", func():
		print("hero button press")
		Event.emit_signal("hero_selection_open")
		var instance : FormatMenu = FORMAT_MENU.instantiate()
		self.add_child(instance)
	)
	
	histo_btn.connect("pressed", func():
		print("histo button press")
		var instance = HISTORIQUE.instantiate()
		
		var parent
		for child in get_tree().get_nodes_in_group("MainScreen"):
			parent = child
			break
		if parent:
			parent.add_child(instance)
	)
