class_name DiceUI extends Control

const DICE_FACES: Array = [
	preload("res://Assets/Sprites/Dice/Dice_1.png"),
	preload("res://Assets/Sprites/Dice/Dice_2.png"),
	preload("res://Assets/Sprites/Dice/Dice_3.png"),
	preload("res://Assets/Sprites/Dice/Dice_4.png"),
	preload("res://Assets/Sprites/Dice/Dice_5.png"),
	preload("res://Assets/Sprites/Dice/Dice_6.png"),
]

@onready var texture = $TextureRect

func _ready() -> void:
	var nb_res: int = randi_range(10, 50)
	for i in range(nb_res):
		var res = randi_range(0, 5)
		texture.texture = DICE_FACES[res]
		await get_tree().create_timer(0.1).timeout
	await  get_tree().create_timer(1.5).timeout
	
	queue_free()
