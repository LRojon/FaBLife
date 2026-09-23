extends PanelContainer


@onready var quit = $Quit

@onready var vmode = $MarginContainer/VBoxContainer/VModeLine/VModeContainer/VMode

func _ready() -> void:
	init_settings()
	quit.connect("pressed", func(): 
		print('Settings: Quit button press')
		self.queue_free()
	)
	
	vmode.connect("pressed", _on_vmode_press)
	Event.connect("modev_changed", init_settings)

func init_settings():
	vmode.button_pressed = Settings.modeV

func _on_vmode_press():
	Event.emit_signal("change_modev")
func _on_modev_changed():
	vmode.button_pressed = Settings.modeV
