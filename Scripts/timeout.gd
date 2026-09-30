class_name TimeOut extends Control

const ANIM_TIME: float = 3.0

@onready var up		= $VBoxContainer/TimeoutUp
@onready var bottom	= $VBoxContainer/TimeoutBottom

func _ready() -> void:
	var screenSize = get_viewport_rect().size
	var targetSize = Vector2(screenSize.y, screenSize.x)
	
	size = targetSize
	var val = abs(targetSize.x - targetSize.y) / 2
	position = Vector2(-val, val)
	up.offset_transform_position.x = -targetSize.x
	bottom.offset_transform_position.x = targetSize.x
	
	var tweenU = create_tween()
	var tweenB = create_tween()
	tweenU.set_ease(Tween.EASE_IN_OUT); tweenB.set_ease(Tween.EASE_IN_OUT)
	tweenU.set_trans(Tween.TRANS_EXPO); tweenB.set_trans(Tween.TRANS_EXPO)
	tweenU.tween_property(up, "offset_transform_position", Vector2.ZERO, ANIM_TIME / 2)
	tweenB.tween_property(bottom, "offset_transform_position", Vector2.ZERO, ANIM_TIME / 2)
	await tweenB.finished
	var tweenF = create_tween()
	tweenF.set_trans(Tween.TRANS_EXPO); tweenB.set_trans(Tween.TRANS_EXPO)
	tweenF.tween_property(self, "modulate", Color.from_rgba8(255, 255, 255, 0), ANIM_TIME / 2)
	await tweenF.finished
	queue_free()
	
