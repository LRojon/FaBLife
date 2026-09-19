extends HBoxContainer

func _ready() -> void:
	$Format.connect("pressed", func():
		for node in get_tree().get_nodes_in_group("FormatMenu"):
			if node is FormatMenu:
				node.queue_free()
	)
