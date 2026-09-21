class_name Menu
extends Control

const FORMAT_MENU = preload("res://Scenes/Menus/format_menu.tscn")
const HISTORIQUE  = preload("res://Scenes/Menus/historique.tscn")

const ROTATE_ICON = {
	"V": preload("res://Assets/Icons/RotateV.png"),
	"H": preload("res://Assets/Icons/RotateH.png")
}

@onready var hero_btn   = $VBoxContainer/HBoxContainer/HeroBtn/Hero
@onready var histo_btn  = $VBoxContainer/HBoxContainer/HistoBtn/Historique
@onready var reset_btn  = $VBoxContainer/HBoxContainer/ResetBtn/Reset
@onready var rotate_btn = $VBoxContainer/HBoxContainer/RotateBtn/Rotate

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
	
	reset_btn.connect("pressed", func():
		Event.emit_signal("reset_game")
	)
	
	rotate_btn.connect("pressed", func():
		Event.emit_signal("change_modev")
	)
	Event.connect("modev_changed", func(): 
		rotate_btn.texture_normal = ROTATE_ICON["V" if Settings.modeV else "H"]
	)
