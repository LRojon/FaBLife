class_name HeroSelection
extends PanelContainer

const HERO_SEL_BTN = preload("res://Scenes/Menus/hero_sel_button.tscn")

@export var p1 : bool = true
@export var format : Data.Format = Data.Format.CC :
	set(value):
		if value != format:
			format = value
			emit_signal("format_changed")

@onready var grid = $MarginContainer/ScrollContainer/GridContainer

signal format_changed

func _ready() -> void:
	connect("format_changed", _on_format_changed)
	Event.connect("hero_selected", _on_hero_selected)
	
	_update_heroes_selection()

func _update_heroes_selection():
	for child in grid.get_children():
		if child is HeroSelButton:
			child.queue_free()
	
	var formatHeroes : Array[Hero] = Data._get_heroes_by_format(format)
	for h in formatHeroes:
		var instance: HeroSelButton = HERO_SEL_BTN.instantiate()
		instance.p1 = p1
		instance.hero = h
		grid.add_child(instance)

func _on_format_changed():
	_update_heroes_selection()

func _on_hero_selected(_hero, _p1):
	if _p1 == p1:
		self.queue_free()
