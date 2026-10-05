class_name Player extends Control

##### DECLARATIONS #####

const MODE_V_PARAM = {
	"V" : {
		"HP_BAR": Vector2(0, 50),
		"BAR_FILL": ProgressBar.FILL_BEGIN_TO_END,
		"DEG_ROT_P1": 180,
		"DEG_ROT_P2": 0,
		"BTN_ORDER": [0, 1, 2],
		"HERO_BTN_X_P2": "src - btn - 20",
		"HERO_BTN_X_P1": "20"
	},
	"H" : {
		"HP_BAR": Vector2(0, 45),
		"BAR_FILL": ProgressBar.FILL_END_TO_BEGIN,
		"DEG_ROT_P1": -90,
		"DEG_ROT_P2": -90,
		"BTN_ORDER": [2, 1, 0],
		"HERO_BTN_X_P2": "20",
		"HERO_BTN_X_P1": "src - btn - 20"
	}
}

const LONG_PRESS_DELAY : float = 0.7
const BUFFER_DELAY     : float = 1.0
const HP_BAR_DELAY     : float = 0.5
const HP_BOF_THRESHOLD : float = 50.0
const HP_NOK_THRESHOLD : float = 25.0

const HP_OK          = preload("res://Assets/StyleBox/HP_OK.tres")
const HP_BOF         = preload("res://Assets/StyleBox/HP_BOF.tres")
const HP_NOK         = preload("res://Assets/StyleBox/HP_NOK.tres")
const BUFFER_SUP     = preload("res://Assets/Fonts/BufferSup.tres")
const BUFFER_INF     = preload("res://Assets/Fonts/BufferInf.tres")
const HERO_SELECTION = preload("res://Scenes/Menus/hero_selection.tscn")

@export var _hero : String = ""
@export var p1    : bool   = true

@onready var content     = $Content
@onready var bg          = $Content/BG
@onready var bg_texture  = $Content/BG/Texture
@onready var bg_darker   = $Content/BG/Darker

@onready var hero_btn    = $Content/HeroButton
@onready var particle    = $Content/VictoryParticle

@onready var blood       = $Content/Blood
@onready var remoteBlood = $Content/VBoxContainer/HBoxContainer/MarginContainer/NormalBar/RemoteBlood

@onready var sysContent  = $Content/VBoxContainer
@onready var hero_name   = $"Content/VBoxContainer/Hero Name"
@onready var hp_content  = $Content/VBoxContainer/HBoxContainer2
@onready var hp          = $"Content/VBoxContainer/HBoxContainer2/1_HP"
@onready var minus       = $"Content/VBoxContainer/HBoxContainer2/0_Minus"
@onready var plus        = $"Content/VBoxContainer/HBoxContainer2/2_Plus"
@onready var normBar     = $Content/VBoxContainer/HBoxContainer/MarginContainer/NormalBar
@onready var supBar      = $Content/VBoxContainer/HBoxContainer/MarginContainer/NormalBar/SupBar
@onready var bufferT     = $Content/VBoxContainer/Buffer
@onready var minusTimer  = $Content/MinusTimer
@onready var plusTimer   = $Content/PlusTimer
@onready var bufferTimer = $Content/BufferTimer

var cFormat		: Data.Format	= Data.Format.CC
var historic	: Array[int]	= []
var hero		: Hero			= null
var minusHold	: bool			= false
var plusHold	: bool			= false
var previous_hp : int 			= 0
var current_hp	: int 			= 0 :
	set(value):
		current_hp = value
		current_hp = 0 if current_hp < 0 else current_hp
		emit_signal("current_hp_changed")
		Event.emit_signal("player_change_hp", p1, current_hp)
var buffer		: int  = 0 :
	set(value):
		buffer = value
		emit_signal("buffer_changed")

signal buffer_changed
signal current_hp_changed

##### BUILT-IN #####

func _ready() -> void:
	var screenSize = get_viewport_rect().size
	var targetSize = Vector2(screenSize.x, screenSize.y / 2)

	if p1:
		content.rotation_degrees = 180
	else:
		content.rotation_degrees = 0
	custom_minimum_size = targetSize
	custom_maximum_size = screenSize
	size = targetSize
	content.custom_minimum_size = targetSize
	content.custom_maximum_size = screenSize
	content.pivot_offset = targetSize / 2
	pivot_offset = targetSize / 2
	bg.pivot_offset = targetSize / 2
	
	hero_btn.position = Vector2(targetSize.x - hero_btn.size.x - 20, 100)
	
	particle.position = targetSize / 2
	particle.lifetime = Data.VICTORY_PARTICLE_TIME
	
	hero = Data._get_hero(_hero)
	update_hero(hero)
	
	_on_modev_changed()
	
	self.connect("buffer_changed", _on_buffer_changed)
	self.connect("current_hp_changed", _on_current_hp_changed)
	Event.connect("hero_selected", func (_hero, _p1):
		if _p1 == self.p1:
			update_hero(_hero)
			Event.emit_signal("reset_game")
	)
	Event.connect("format_selected", func(format : Data.Format):
		for child in content.get_children():
			if child is HeroSelection:
				child.queue_free()
		
		var instance : HeroSelection = HERO_SELECTION.instantiate()
		instance.format = format
		instance.p1 = self.p1
		instance.position.y += targetSize.y * 0.05
		content.add_child(instance)
		cFormat = format
	)
	Event.connect("one_player_format_selected", func(format : Data.Format, _p1: bool):
		if _p1 == p1:
			for child in content.get_children():
				if child is HeroSelection:
					child.queue_free()
			
			var instance : HeroSelection = HERO_SELECTION.instantiate()
			instance.format = format
			instance.p1 = self.p1
			instance.position.y += targetSize.y * 0.05
			content.add_child(instance)
			cFormat = format
	)
	Event.connect("reset_game", func ():
		update_hero(hero)
	)
	Event.connect("victory", func(_p1: bool):
		if _p1 == p1:
			particle.emitting = true
			await get_tree().create_timer(particle.lifetime).timeout
			Event.emit_signal("go_gameover", hero.name)
	)
	Event.connect("modev_changed", _on_modev_changed)
	bufferTimer.connect("timeout", _on_buffer_timeout)
	minus.connect("button_down", _on_minus_press)
	minus.connect("button_up"  , _on_minus_release)
	minusTimer.connect("timeout", _on_minus_timeout)
	plus.connect("button_down", _on_plus_press)
	plus.connect("button_up"  , _on_plus_release)
	plusTimer.connect("timeout", _on_plus_timeout)
	hero_btn.connect("pressed", func ():
		Event.emit_signal("one_player_format_selected", cFormat, p1)
	)

##### LOGIC #####

func update_hero(_hero: Hero):
	hero = _hero
	hero_name.text = _hero.name
	previous_hp = _hero.base_hp
	current_hp = _hero.base_hp
	bg_texture.texture = load("res://Assets/Sprites/Heroes/" + _hero.id + ".jpg")
	
	hp.text = str(_hero.base_hp)
	normBar.value = 100
	supBar.value  = 0
	bufferT.text  = ""
	historic = []

func change_bar(from : float, to : float):
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
			if Settings.blood and (from - to) > 0:
				remoteBlood.position = _get_blood_pos(normBar.value)
				var percent: float = (from - to) / 100.0
				var amt: float = 5 * (percent * hero.base_hp)
				blood.lifetime = HP_BAR_DELAY
				blood.direction = Vector2.RIGHT
				if p1 and !Settings.modeV:
					blood.direction = Vector2.LEFT
				blood.amount = min(amt, 200)
				blood.emitting = true
				var tweenB = create_tween()
				tweenB.set_trans(Tween.TRANS_EXPO)
				tweenB.set_ease(Tween.EASE_OUT)
				tweenB.tween_property(remoteBlood, "position", _get_blood_pos(to), HP_BAR_DELAY)
			
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(normBar, "value", to, HP_BAR_DELAY)
	else:
		if to >= 100.0:
			tween.set_ease(Tween.EASE_OUT)
			tween.tween_property(supBar, "value", to - 100.0, HP_BAR_DELAY)
		else:
			tween.tween_property(supBar, "value", 0.0, HP_BAR_DELAY / 2)
			await tween.finished
			var tween2 = create_tween()
			tween2.set_ease(Tween.EASE_OUT)
			tween2.set_trans(Tween.TRANS_EXPO)
			tween2.tween_property(normBar, "value", to, HP_BAR_DELAY / 2)

func change_child_order(parent: Node, order: Array):
	if parent.get_children().size() != order.size():
		push_error("change_child_order: the order array size must be equal to number of node child.")
		return
	var tmp_child: Array[Node] = parent.get_children()
	var n: int = 0
	for o in order:
		for child in tmp_child:
			if child.name.split("_")[0] == str(o):
				parent.move_child(child, n)
		n += 1

func _get_blood_pos(value: float) -> Vector2:
	if p1 and !Settings.modeV:
		var ini_pos = Vector2.ZERO
		ini_pos.y += normBar.size.y / 2
		ini_pos.x += normBar.size.x * (100.0-value) / 100
		return ini_pos
	
	var ini_pos = Vector2.ZERO
	ini_pos.y += normBar.size.y / 2
	ini_pos.x += normBar.size.x * value / 100
	return ini_pos

##### EVENT #####

func _on_current_hp_changed():
	print("current_hp_changed")
	bufferTimer.stop()
	hp.text = str(current_hp)
	print("hp | previous : ", previous_hp, " current : ", current_hp)
	var from : float = float(previous_hp) / hero.base_hp * 100
	var to   : float = float(current_hp)  / hero.base_hp * 100
	change_bar(from, to)
	if to > HP_BOF_THRESHOLD:
		normBar.add_theme_stylebox_override("fill", HP_OK)
	elif to > HP_NOK_THRESHOLD:
		normBar.add_theme_stylebox_override("fill", HP_BOF)
	else:
		normBar.add_theme_stylebox_override("fill", HP_NOK)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(bg_texture, "material:shader_parameter/intensity", (1.0 - (to / 100.0)) if to < 100.0 else 0.0, 0.5)
	#bg_texture.set_instance_shader_parameter("intensity", (1.0 - (to / 100.0)) if to < 100.0 else 0.0)
	
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
	historic.push_back(buffer)
	print("mod add: ", buffer)
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

func _on_modev_changed():
	var mode := "V" if Settings.modeV else "H"
	var targetSize : Vector2
	if mode == "H":
		targetSize = Vector2(self.size.y, self.size.x)
	else:
		targetSize = Vector2(self.size.x, self.size.y)
	
	content.pivot_offset = targetSize / 2
	if p1:
		content.rotation_degrees = MODE_V_PARAM[mode]["DEG_ROT_P1"]
		normBar.fill_mode = MODE_V_PARAM[mode]["BAR_FILL"]
		supBar.fill_mode  = MODE_V_PARAM[mode]["BAR_FILL"]
		change_child_order(hp_content, MODE_V_PARAM[mode]["BTN_ORDER"])
		
		var xoffset: float = evalue(MODE_V_PARAM[mode]["HERO_BTN_X_P1"], {
			"src" : targetSize.x,
			"btn" : hero_btn.size.x
		})
		hero_btn.position.x = xoffset
	else:
		content.rotation_degrees = MODE_V_PARAM[mode]["DEG_ROT_P2"]

		var xoffset: float = evalue(MODE_V_PARAM[mode]["HERO_BTN_X_P2"], {
			"src" : targetSize.x,
			"btn" : hero_btn.size.x
		})
		hero_btn.position.x = xoffset
			
	content.custom_maximum_size = targetSize 
	content.custom_minimum_size = targetSize


func evalue(expr: String, values: Dictionary) -> Variant :
	var _exp = Expression.new()
	var ret = _exp.parse(expr, values.keys())
	if ret != OK:
		push_error("Error parse expression")
		return 0
	var res = _exp.execute(values.values())
	if _exp.has_execute_failed():
		push_error("Expression execution error")
		return 0
	return res
