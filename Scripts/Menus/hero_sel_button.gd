class_name HeroSelButton
extends TextureButton

const SWIPE_THRESHOLD = 1.0

var hero  : Hero = null
@export var p1    : bool = true

var touch_start_pos = Vector2.ZERO

func _ready() -> void:
	if hero != null:
		print(hero.id)
		texture_normal   = load("res://Assets/Sprites/Heroes/" + hero.id + ".jpg")
		texture_disabled = load("res://Assets/Sprites/Heroes/" + hero.id + ".jpg")
		texture_focused  = load("res://Assets/Sprites/Heroes/" + hero.id + ".jpg")
		texture_hover    = load("res://Assets/Sprites/Heroes/" + hero.id + ".jpg")
		texture_pressed  = load("res://Assets/Sprites/Heroes/" + hero.id + ".jpg")
	
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)


func _on_button_down():
	touch_start_pos = get_global_mouse_position()

func _on_button_up():
	var pos = get_global_mouse_position()
	if pos.distance_to(touch_start_pos) <= SWIPE_THRESHOLD:
		Event.emit_signal("hero_selected", hero, p1)
