class_name Menu
extends Control

const FORMAT_MENU   = preload("res://Scenes/Menus/format_menu.tscn")
const HISTORIQUE    = preload("res://Scenes/Menus/historique.tscn")
const SETTINGS_MENU = preload("res://Scenes/Menus/Settings/settings_menu.tscn")

const ROTATE_ICON = {
	"V": preload("res://Assets/Icons/RotateV.png"),
	"H": preload("res://Assets/Icons/RotateH.png")
}

@onready var hero_btn     = $VBoxContainer/HBoxContainer/HeroBtn/Hero
@onready var histo_btn    = $VBoxContainer/HBoxContainer/HistoBtn/Historique
@onready var reset_btn    = $VBoxContainer/HBoxContainer/ResetBtn/Reset
@onready var rotate_btn   = $VBoxContainer/HBoxContainer/RotateBtn/Rotate
@onready var timer_strt   = $VBoxContainer/HBoxContainer/TimerBtn/TimerStart
@onready var settings_btn = $VBoxContainer/HBoxContainer/SettingsBtn/Settings

@onready var timer	 = $VBoxContainer/HBoxContainer/TimerBtn/Timer
@onready var disTime = $VBoxContainer/HBoxContainer/TimerBtn/DisTime

var format_timer : int = Data.TIMER[Data.Format.CC]

func _ready() -> void:
	hero_btn.connect("pressed", _on_hero_btn_pressed)
	histo_btn.connect("pressed", _on_histo_btn_pressed)
	reset_btn.connect("pressed", _on_reset_btn_pressed)
	rotate_btn.connect("pressed", _on_rotate_btn_pressed)
	timer_strt.connect("pressed", _on_timer_strt_pressed)
	settings_btn.connect("pressed", _on_settings_btn_pressed)
	
	Event.connect("modev_changed", func(): rotate_btn.texture_normal = ROTATE_ICON["V" if Settings.modeV else "H"])
	Event.connect("format_selected", func(format: Data.Format): 
		_reset_timer()
		format_timer = Data.TIMER[format]
	)

func _process(delta: float) -> void:
	if !timer.is_stopped():
		var minutes := int(timer.time_left / 60)
		var seconds := int(fmod(timer.time_left, 60))
		disTime.text = ("0" if minutes < 10 else "") + str(minutes) + ":"
		disTime.text += ("0" if seconds < 10 else "") + str(seconds)

func _reset_timer():
	timer.stop()
	timer_strt.visible = true
	disTime.visible = false

func _on_hero_btn_pressed():
	print("hero button press")
	Event.emit_signal("hero_selection_open")
	var instance : FormatMenu = FORMAT_MENU.instantiate()
	self.add_child(instance)
	
func _on_histo_btn_pressed():
	print("histo button press")
	var instance = HISTORIQUE.instantiate()
	
	for node in get_tree().get_nodes_in_group("MainScreen"):
		node.add_child(instance)
		break
	
func _on_reset_btn_pressed():
	_reset_timer()
	Event.emit_signal("reset_game")
	
func _on_rotate_btn_pressed():
	Event.emit_signal("change_modev")
	
func _on_timer_strt_pressed():
	if format_timer == -1:
		timer_strt.visible = false
		disTime.visible = true
		disTime.text = "∞"
	else:
		timer.start(format_timer)
		timer_strt.visible = false
		disTime.visible = true
	pass

func _on_settings_btn_pressed():
	print("Settings button press")
	var instance = SETTINGS_MENU.instantiate()
	for node in get_tree().get_nodes_in_group("MainScreen"):
		node.add_child(instance)
		break
