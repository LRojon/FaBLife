class_name Hero

var id      : String
var name    : String
var ll      : int
var base_hp : int
var classes : Array
var talents : Array
var formats : Array

func _init(_id, _name, _ll, _base_hp, _classes, _talents, _formats) -> void:
	id = _id
	name = _name
	ll = _ll
	base_hp = _base_hp
	classes = _classes
	talents = _talents
	formats = _formats

func get_img_path() -> String:
	return "res://Assets/Sprites/Heroes/" + self.id + ".jpg"
