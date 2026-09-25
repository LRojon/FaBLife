extends PanelContainer

##### DECLARATIONS #####

const MENU_EDITOR = preload("res://Scenes/Menus/Settings/menu_editor.tscn")

@onready var quit = $Quit

@onready var vmode = $MarginContainer/VBoxContainer/VModeLine/VModeContainer/VMode
@onready var menu_editor = $MarginContainer/VBoxContainer/CustomMenuLine/CustomMenuContainer/MenuEditor
@onready var fabrary_db    = $MarginContainer/VBoxContainer/DatabaseSrcLine/SettingsContainer/Fabrary
@onready var card_vault_db = $MarginContainer/VBoxContainer/DatabaseSrcLine/SettingsContainer/Cardvault

##### BUILT-IN #####

func _ready() -> void:
	init_settings()
	quit.connect("pressed", func(): 
		print('Settings: Quit button press')
		self.queue_free()
	)
	
	vmode.connect("pressed", _on_vmode_press)
	menu_editor.connect("pressed", _on_menu_editor_pressed)
	fabrary_db.pressed.connect(_on_db_src_f_pressed)
	card_vault_db.pressed.connect(_on_db_src_c_pressed)
	Event.connect("modev_changed", init_settings)
	Event.connect("db_src_changed", init_settings)

##### LOGIC #####

func init_settings():
	vmode.button_pressed = Settings.modeV
	
	fabrary_db.button_pressed    = Settings.db_src == "fabrary"
	fabrary_db.disabled          = Settings.db_src == "fabrary"
	card_vault_db.button_pressed = Settings.db_src == "cardvault"
	card_vault_db.disabled       = Settings.db_src == "cardvault"

##### SIGNAL RESPONSES #####

func _on_vmode_press():
	Event.emit_signal("change_modev")

func _on_menu_editor_pressed():
	var instance = MENU_EDITOR.instantiate()
	get_tree().root.add_child(instance)

func _on_db_src_f_pressed():
	Event.emit_signal("change_db_src", "fabrary")
func _on_db_src_c_pressed():
	Event.emit_signal("change_db_src", "cardvault")
