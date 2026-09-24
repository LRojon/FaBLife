extends PanelContainer

const MENU_EDITOR = preload("res://Scenes/Menus/Settings/menu_editor.tscn")

@onready var quit = $Quit

@onready var vmode = $MarginContainer/VBoxContainer/VModeLine/VModeContainer/VMode
@onready var menu_editor = $MarginContainer/VBoxContainer/CustomMenuLine/CustomMenuContainer/MenuEditor

func _ready() -> void:
	init_settings()
	quit.connect("pressed", func(): 
		print('Settings: Quit button press')
		self.queue_free()
	)
	
	vmode.connect("pressed", _on_vmode_press)
	menu_editor.connect("pressed", _on_menu_editor_pressed)
	Event.connect("modev_changed", init_settings)

func init_settings():
	vmode.button_pressed = Settings.modeV

func _on_vmode_press():
	Event.emit_signal("change_modev")
func _on_modev_changed():
	vmode.button_pressed = Settings.modeV

func _on_menu_editor_pressed():
	var instance = MENU_EDITOR.instantiate()
	get_tree().root.add_child(instance)
