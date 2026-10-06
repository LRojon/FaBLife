class_name HeroVersus extends TextureRect

const LIGHT_FULL = preload("res://Assets/Sprites/Light_full.png")

@export var _p1: bool		= true

@onready var _texture = $Texture

signal expend_finished

var hero: Hero

func _ready() -> void:
	for node in get_tree().get_nodes_in_group("Player"):
		if node is Player:
			if node.p1 == _p1:
				hero = Data._get_hero(node.hero.id)
	_texture.texture = load(hero.get_img_path())
	flip_h = _p1


func expend(to : PackedVector2Array, duration: float = 1.0):
	var t = create_tween()
	t.tween_property(self, "texture", LIGHT_FULL, duration)
	await t.finished
	emit_signal("expend_finished")
