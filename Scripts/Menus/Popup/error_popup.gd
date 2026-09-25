class_name ErrorPopup extends MarginContainer

@export var message: String = "Erreur"
@export var lifetime: float = 3.0

@onready var label = $PanelContainer/VBoxContainer/MarginContainer/Label
@onready var timer = $Timer
@onready var bar = $PanelContainer/VBoxContainer/ProgressBar

func _ready() -> void:
	label.text = message
	timer.start(lifetime)
	
	timer.connect("timeout", func(): queue_free())


func _process(delta: float) -> void:
	if !timer.is_stopped():
		bar.value = timer.time_left / lifetime * 100
