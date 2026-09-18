extends Control

##### DECLARATIONS #####

const LONG_PRESS_DELAY : float = 1.0
const BUFFER_DELAY     : float = 1.5
const HP_BAR_DELAY     : float = 0.5
const HP_BOF_THRESHOLD : float = 50.0
const HP_NOK_THRESHOLD : float = 25.0

const OFFSET_Y : int = 14

var HP_OK      = load("res://Assets/StyleBox/HP_OK.tres")
var HP_BOF     = load("res://Assets/StyleBox/HP_BOF.tres")
var HP_NOK     = load("res://Assets/StyleBox/HP_NOK.tres")
var BUFFER_SUP = load("res://Assets/Fonts/BufferSup.tres")
var BUFFER_INF = load("res://Assets/Fonts/BufferInf.tres")

@export var _hero : String = ""
@export var vMode : bool   = true
@export var p1    : bool   = true

@onready var content     = $Content
@onready var bg          = $Content/BG
@onready var bg_texture  = $Content/BG/Texture
@onready var hero_name   = $"Content/VBoxContainer/Hero Name"
@onready var hp          = $Content/VBoxContainer/HBoxContainer2/HP
@onready var minus       = $Content/VBoxContainer/HBoxContainer2/Minus
@onready var plus        = $Content/VBoxContainer/HBoxContainer2/Plus
@onready var normBar     = $Content/VBoxContainer/HBoxContainer/NormalBar
@onready var supBar      = $Content/VBoxContainer/HBoxContainer/NormalBar/SupBar
@onready var bufferT     = $Content/VBoxContainer/Buffer
@onready var minusTimer  = $Content/MinusTimer
@onready var plusTimer   = $Content/PlusTimer
@onready var bufferTimer = $Content/BufferTimer

var hero		: Hero = null
var minusHold	: bool = false
var plusHold	: bool = false
var previous_hp : int  = 0
var current_hp	: int  = 0 :
	set(value):
		current_hp = value
		emit_signal("current_hp_changed")
var buffer		: int  = 0 :
	set(value):
		buffer = value
		emit_signal("buffer_changed")

signal buffer_changed
signal current_hp_changed

##### BUILT-IN #####

func _ready() -> void:
	#if vMode:
		#self.rotation = 0
	#else:
		#self.rotation_degrees = -90
	if p1:
		content.rotation_degrees = 180
	bg.position += Vector2.UP * OFFSET_Y
	
	hero = Data._get_hero(_hero)
	hero_name.text = hero.name
	current_hp = hero.base_hp
	previous_hp = hero.base_hp
	#bg.texture = load("res://Assets/Sprites/Heroes/" + _hero + ".jpg")
	bg_texture.texture = load("res://Assets/Sprites/Heroes/Dio.jpg")
	
	hp.text = str(hero.base_hp)
	normBar.value = 100
	supBar.value  = 0
	bufferT.text  = ""
	
	self.connect("buffer_changed", _on_buffer_changed)
	self.connect("current_hp_changed", _on_current_hp_changed)
	bufferTimer.connect("timeout", _on_buffer_timeout)
	minus.connect("button_down", _on_minus_press)
	minus.connect("button_up"  , _on_minus_release)
	minusTimer.connect("timeout", _on_minus_timeout)
	plus.connect("button_down", _on_plus_press)
	plus.connect("button_up"  , _on_plus_release)
	plusTimer.connect("timeout", _on_plus_timeout)

##### LOGIC #####

func change_bar(from : float, to : float):
	print("Call change bar | from: ", from, " to: ", to)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_EXPO)
	if from <= 100.0:
		if to > 100.0:
			tween.tween_property(normBar, "value", 100.0, HP_BAR_DELAY / 2)
			await tween.finished
			var tween2 = create_tween()
			tween2.set_ease(Tween.EASE_OUT)
			tween2.set_trans(Tween.TRANS_EXPO)
			tween2. tween_property(supBar, "value", to - 100.0, HP_BAR_DELAY / 2)
		else:
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(normBar, "value", to, HP_BAR_DELAY)
	else:
		if to >= 100.0:
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(supBar, "value", to - 100.0, HP_BAR_DELAY)
		else:
			tween.tween_property(supBar, "value", 0.0, HP_BAR_DELAY / 2)
			await tween.finished
			print("supbar value: ", supBar.value)
			var tween2 = create_tween()
			tween2.set_ease(Tween.EASE_OUT)
			tween2.set_trans(Tween.TRANS_EXPO)
			tween2. tween_property(normBar, "value", to, HP_BAR_DELAY / 2)

##### EVENT #####

func _on_current_hp_changed():
	print("current_hp_changed")
	bufferTimer.stop()
	hp.text = str(current_hp)
	var from : float = float(previous_hp) / hero.base_hp * 100
	var to   : float = float(current_hp)  / hero.base_hp * 100
	change_bar(from, to)
	if to > HP_BOF_THRESHOLD:
		normBar.add_theme_stylebox_override("fill", HP_OK)
	elif to > HP_NOK_THRESHOLD:
		normBar.add_theme_stylebox_override("fill", HP_BOF)
	else:
		normBar.add_theme_stylebox_override("fill", HP_NOK)
	previous_hp = current_hp

func _on_buffer_changed():
	print("buffer_changed")
	bufferTimer.stop()
	if buffer != 0:
		bufferTimer.start(BUFFER_DELAY)
		bufferT.label_settings = BUFFER_SUP if buffer >= 0 else BUFFER_INF
		bufferT.text = ("+" if buffer >= 0 else "") + str(buffer)
	else:
		bufferT.text = ""

func _on_buffer_timeout():
	print("buffer_timeout")
	bufferTimer.stop()
	current_hp += buffer
	buffer = 0

func _on_minus_press():
	print("minus_press")
	minusTimer.start(LONG_PRESS_DELAY)

func _on_minus_release():
	print("minus_release")
	minusTimer.stop()
	if !minusHold:
		buffer -=1
	minusHold = false

func _on_minus_timeout():
	print("minus_timeout")
	buffer -= 5
	minusHold = true
	minusTimer.start(LONG_PRESS_DELAY / 2)

func _on_plus_press():
	print("plus_press")
	plusTimer.start(LONG_PRESS_DELAY)

func _on_plus_release():
	print("plus_release")
	plusTimer.stop()
	if !plusHold:
		buffer +=1
	plusHold = false

func _on_plus_timeout():
	print("plus_timeout")
	buffer += 5
	plusHold = true
	plusTimer.start(LONG_PRESS_DELAY / 2)
