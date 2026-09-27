class_name FormatButton
extends HBoxContainer

var format : Data.Format = Data.Format.CC
var disabled : bool = false

@onready var btn = $PanelContainer/MarginContainer/Format

func _ready() -> void:
	btn.texture_normal   = Data.FORMAT_IMG[format]
	btn.texture_pressed  = btn.texture_normal
	btn.texture_hover    = btn.texture_normal
	btn.texture_disabled = btn.texture_normal
	btn.texture_focused  = btn.texture_normal
	
	btn.disabled = disabled
	
	btn.connect("pressed", func():
		Event.emit_signal("format_selected", format)
	)
