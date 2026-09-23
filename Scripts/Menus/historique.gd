extends Control

const HISTORIC_LINE = preload("res://Scenes/Menus/historic_line.tscn")

@onready var quit_btn = $MarginContainer/Quit

@onready var heroP1Lbl = $"MarginContainer/Panel/MarginContainer/GridContainer/Player 1"
@onready var historicList1 = $MarginContainer/Panel/MarginContainer/GridContainer/ScrollContainer/HistoricP1
@onready var heroP2Lbl = $"MarginContainer/Panel/MarginContainer/GridContainer/Player 2"
@onready var historicList2 = $MarginContainer/Panel/MarginContainer/GridContainer/ScrollContainer2/HistoricP2

var heroP1 : Hero			= null
var historicP1 : Array[int]	= []
var heroP2 : Hero			= null
var historicP2 : Array[int]	= []

func _ready() -> void:
	quit_btn.connect("pressed", func ():
		print("histo quit btn pressed")
		self.queue_free()
	)
	
	position = Vector2.ZERO
	var screenSize = get_viewport_rect().size
	position.y = (screenSize.y / 2) - (size.y / 2)
	
	for child in get_tree().get_nodes_in_group("Player"):
		if child is Player:
			if child.p1:
				heroP1 = child.hero
				historicP1 = child.historic
			else:
				heroP2 = child.hero
				historicP2 = child.historic
	heroP1Lbl.text = heroP1.name
	heroP2Lbl.text = heroP2.name
	
	print("HistoricP1: ", historicP1)
	fill_historic(historicP1, true)
	fill_historic(historicP2, false)

func fill_historic(historic : Array[int], p1: bool):
	var start_hp : int = heroP1.base_hp if p1 else heroP2.base_hp
	var container : VBoxContainer = historicList1 if p1 else historicList2
	var line : HistoricLine = HISTORIC_LINE.instantiate()
	line.hp = start_hp
	line.modifier = 0
	for mod in historic:
		line.modifier = mod
		container.add_child(line)
		line = HISTORIC_LINE.instantiate()
		start_hp += mod
		line.hp = start_hp
		line.modifier = 0
		pass
	container.add_child(line)
