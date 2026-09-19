class_name HistoricLine
extends HBoxContainer

const BUFFER_INF = preload("res://Assets/Fonts/BufferInf.tres")
const BUFFER_SUP = preload("res://Assets/Fonts/BufferSup.tres")

@export var hp       : int = 0
@export var modifier : int = 0

@onready var hpLbl       = $HP
@onready var modifierLbl = $Modifier

func _ready() -> void:
	hpLbl.text = str(hp)
	if modifier != 0:
		modifierLbl.text = ("+" if modifier > 0 else "") + str(modifier)
	if modifier < 0:
		modifierLbl.label_settings = BUFFER_INF
	else:
		modifierLbl.label_settings = BUFFER_SUP
