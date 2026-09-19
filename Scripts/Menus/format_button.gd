class_name FormatButton
extends HBoxContainer

var format : Data.Format = Data.Format.CC
var disabled : bool = false

@onready var btn = $Format

func _ready() -> void:
	btn.text = " " + Data._get_str_format(format) + " "
	btn.disabled = disabled
	
	btn.connect("pressed", func():
		Event.emit_signal("format_selected", format)
	)
