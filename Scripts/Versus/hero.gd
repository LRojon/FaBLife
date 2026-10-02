extends TextureRect

@export var _hero: String	= "ArakniS"
@export var _p1: bool		= true

@onready var _texture = $Texture

var hero: Hero

func _ready() -> void:
	hero = Data._get_hero(_hero)
	_texture.texture = load(hero.get_img_path())
	flip_h = _p1


func expend():
	var t = create_tween()
	var poly: PackedVector2Array = [
		Vector2.ZERO,
		Vector2.RIGHT * 600,
		Vector2.ONE * 600,
		Vector2.DOWN * 600
	]
	t.tween_property(self, "polygon", poly, 1)
