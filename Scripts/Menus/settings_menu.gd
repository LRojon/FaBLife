extends MarginContainer

##### DECLARATIONS #####

const MENU_EDITOR = preload("res://Scenes/Menus/Settings/menu_editor.tscn")

@onready var quit = $VBoxContainer/SettingsPanel/Quit

@onready var vmode = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/VModeLine/VModeContainer/VMode
@onready var blood = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/BloodLine/BloodContainer/Blood
@onready var flash = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/FlashLine/FlashContainer/Flash
@onready var menu_editor = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/CustomMenuLine/CustomMenuContainer/MenuEditor
@onready var fabrary_db    = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/DatabaseSrcLine/SettingsContainer/Fabrary
@onready var card_vault_db = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/DatabaseSrcLine/SettingsContainer/Cardvault

@onready var same   = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/NewGameLine/NewGameContainer/Same
@onready var format = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/NewGameLine/NewGameContainer/Format
@onready var hero   = $VBoxContainer/SettingsPanel/MarginContainer/VBoxContainer/NewGameLine/NewGameContainer/Hero

##### BUILT-IN #####

func _ready() -> void:
	init_settings()
	quit.connect("pressed", func(): 
		print('Settings: Quit button press')
		self.queue_free()
	)
	
	same.connect("pressed", _on_same_pressed)
	format.connect("pressed", _on_format_pressed)
	hero.connect("pressed", _on_hero_pressed)
	
	vmode.connect("pressed", _on_vmode_press)
	blood.connect("pressed", _on_blood_press)
	flash.connect("pressed", _on_flash_press)
	menu_editor.connect("pressed", _on_menu_editor_pressed)
	fabrary_db.pressed.connect(_on_db_src_f_pressed)
	card_vault_db.pressed.connect(_on_db_src_c_pressed)
	Event.connect("modev_changed", init_settings)
	Event.connect("blood_changed", init_settings)
	Event.connect("flash_changed", init_settings)
	Event.connect("db_src_changed", init_settings)

##### LOGIC #####

func init_settings():
	vmode.button_pressed = Settings.modeV
	blood.button_pressed = Settings.blood
	flash.button_pressed = Settings.flash
	
	fabrary_db.button_pressed    = Settings.db_src == "fabrary"
	fabrary_db.disabled          = Settings.db_src == "fabrary"
	card_vault_db.button_pressed = Settings.db_src == "cardvault"
	card_vault_db.disabled       = Settings.db_src == "cardvault"

##### SIGNAL RESPONSES #####

func _on_vmode_press():
	Event.emit_signal("change_modev")
func _on_blood_press():
	Event.emit_signal("change_blood")
func _on_flash_press():
	Event.emit_signal("change_flash")

func _on_menu_editor_pressed():
	var instance = MENU_EDITOR.instantiate()
	get_tree().root.add_child(instance)

func _on_db_src_f_pressed():
	Event.emit_signal("change_db_src", "fabrary")
func _on_db_src_c_pressed():
	Event.emit_signal("change_db_src", "cardvault")

func _on_hero_pressed():
	var format: Data.Format
	for node in get_tree().get_nodes_in_group("Player"):
		if node is Player:
			format = node.cFormat
	Event.emit_signal("format_selected", format)
	self.queue_free()

func _on_format_pressed():
	Event.emit_signal("reset_format")
	self.queue_free()

func _on_same_pressed():
	Event.emit_signal("reset_game")
	self.queue_free()
