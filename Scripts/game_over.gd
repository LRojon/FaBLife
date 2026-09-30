class_name GameOver extends Control

@export var winner: String = ""

@onready var line          = $MarginContainer/VBoxContainer/Line1
@onready var change_hero   = $MarginContainer/VBoxContainer/HBoxContainer/Hero
@onready var change_format = $MarginContainer/VBoxContainer/HBoxContainer/Format
@onready var same          = $MarginContainer/VBoxContainer/HBoxContainer/Same

var default_mess: String = ""

func _ready() -> void:
	var screenSize = get_viewport_rect().size
	var targetSize = Vector2(screenSize.y, screenSize.x)
	
	custom_maximum_size = targetSize
	custom_minimum_size = targetSize
	size = targetSize
	var val = abs(targetSize.x - targetSize.y) / 2
	position = Vector2(-val, val)
	
	default_mess = line.text
	line.text = default_mess.replace("%hero%", winner)
	
	# Apparition FadeIn
	modulate = "#FFFFFF00"
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"modulate", Color.from_rgba8(255, 255, 255, 255), 0.5)
	
	change_hero.connect("pressed", _on_change_hero_pressed)
	change_format.connect("pressed", _on_change_format_pressed)
	same.connect("pressed", _on_same_pressed)

func _on_change_hero_pressed():
	var format: Data.Format
	for node in get_tree().get_nodes_in_group("Player"):
		if node is Player:
			format = node.cFormat
	Event.emit_signal("format_selected", format)
	self.queue_free()

func _on_change_format_pressed():
	Event.emit_signal("reset_format")
	self.queue_free()

func _on_same_pressed():
	Event.emit_signal("reset_game")
	self.queue_free()
