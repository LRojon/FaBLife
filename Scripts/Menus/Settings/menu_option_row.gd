class_name MenuOptionRow extends HBoxContainer

@export var option: MenuOptionData
@export var menu_pos: int

@onready var up     = $Up
@onready var bottom = $Bottom
@onready var check  = $Check
@onready var icon   = $Icon
@onready var label  = $Label


func _ready() -> void:
	up.connect("pressed", _on_up_pressed)
	bottom.connect("pressed", _on_bottom_pressed)
	check.connect("pressed", _on_check_pressed)
	
	icon.texture = option.icon
	check.button_pressed = option.enabled
	label.text = "  " + option.label
	
	up.disabled = menu_pos == 0
	up.self_modulate = Color.WHITE if !up.disabled else Color.from_string("#ffffff20", Color.DIM_GRAY)
	
	bottom.disabled = menu_pos == len(Settings.menuOption) - 1
	bottom.self_modulate = Color.WHITE if !bottom.disabled else Color.from_string("#ffffff20", Color.DIM_GRAY)
	
	check.disabled = !option.can_disabled
	check.self_modulate = Color.WHITE if !check.disabled else Color.from_string("#ffffff20", Color.DIM_GRAY)


func _on_up_pressed():
	pass


func _on_bottom_pressed():
	pass


func _on_check_pressed():
	pass
