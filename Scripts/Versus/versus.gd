class_name Versus extends Control

@export var ANIM_DURATION: float = 3.0
const ANIM_SPLIT = [
	0.15,
	0.40,
	0.30,
	0.15
] # -> La somme doit faire 1

@onready var hero_p1: HeroVersus = $Container/VBoxContainer/HBoxContainer/HeroP1
@onready var hero_p2: HeroVersus = $Container/VBoxContainer/HBoxContainer/HeroP2
@onready var back: ColorRect     = $Container/Back
@onready var vs: TextureRect     = $Container/VBoxContainer/HBoxContainer/VBoxContainer/VS
@onready var flash: ColorRect    = $Container/Flash

func _ready() -> void:	
	back.color                        = Color("#0000")
	hero_p1.offset_transform_position = Vector2(350, -1400)
	hero_p2.offset_transform_position = Vector2(-350, -1400)
	vs.self_modulate                  = Color("#fff0")
	flash.self_modulate               = Color("#fff0")
	
	# Fade in ANIM_SPLIT[0]
	var tweenB = create_tween()
	tweenB.set_ease(Tween.EASE_IN_OUT) ; tweenB.set_trans(Tween.TRANS_EXPO)
	tweenB.tween_property(back, "color", Color("#00000080"), ANIM_DURATION * ANIM_SPLIT[0])
	
	var tweenH1 = create_tween()
	tweenH1.set_ease(Tween.EASE_IN_OUT) ; tweenH1.set_trans(Tween.TRANS_EXPO)
	tweenH1.tween_property(hero_p1, "offset_transform_position", Vector2.ZERO, ANIM_DURATION * ANIM_SPLIT[1])
	var delay = ANIM_DURATION  * ANIM_SPLIT[1] / 2
	await get_tree().create_timer(delay).timeout
	
	var tweenH2 = create_tween()
	tweenH2.set_ease(Tween.EASE_IN_OUT) ; tweenH2.set_trans(Tween.TRANS_EXPO)
	tweenH2.tween_property(hero_p2, "offset_transform_position", Vector2.ZERO, ANIM_DURATION  * ANIM_SPLIT[1] - delay)
	await tweenH2.finished
	
	# Flash puis VS Fade In ANIM_SPLIT[2]
	var tweenVS = create_tween()
	tweenVS.set_ease(Tween.EASE_IN_OUT) ; tweenVS.set_trans(Tween.TRANS_EXPO)
	tweenVS.tween_property(vs, "self_modulate", Color("#ffff"), ANIM_DURATION * ANIM_SPLIT[2])
	
	if Settings.flash:
		_flash()
	await tweenVS.finished
	
	# All Fade Out ANIM_SPLIT[3]
	var tweenFO = create_tween()
	tweenFO.set_ease(Tween.EASE_IN_OUT) ; tweenFO.set_trans(Tween.TRANS_EXPO)
	tweenFO.tween_property(self, "self_modulate", Color("#fff0"), ANIM_DURATION * ANIM_SPLIT[3])
	await tweenFO.finished
	
	queue_free()



func _flash():
	var flashDelay: float = ANIM_DURATION * ANIM_SPLIT[2] / 8
	
	var tweenFL1 = create_tween()
	tweenFL1.set_ease(Tween.EASE_IN_OUT) ; tweenFL1.set_trans(Tween.TRANS_EXPO)
	tweenFL1.tween_property(flash, "self_modulate", Color("#fffa"), flashDelay)
	await tweenFL1.finished
	
	var tweenFL2 = create_tween()
	tweenFL2.set_ease(Tween.EASE_IN_OUT) ; tweenFL2.set_trans(Tween.TRANS_EXPO)
	tweenFL2.tween_property(flash, "self_modulate", Color("#fff0"), flashDelay)
	await tweenFL2.finished
	
	var tweenFL3 = create_tween()
	tweenFL3.set_ease(Tween.EASE_IN_OUT) ; tweenFL3.set_trans(Tween.TRANS_EXPO)
	tweenFL3.tween_property(flash, "self_modulate", Color("#fffa"), flashDelay)
	await tweenFL3.finished
	
	var tweenFL4 = create_tween()
	tweenFL4.set_ease(Tween.EASE_IN_OUT) ; tweenFL4.set_trans(Tween.TRANS_EXPO)
	tweenFL4.tween_property(flash, "self_modulate", Color("#fff0"), flashDelay)
	await tweenFL4.finished
