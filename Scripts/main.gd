class_name Main extends Control

##### DECLARATIONS #####

const GAMEOVER = preload("res://Scenes/game_over.tscn")

enum State {
	IN_GAME,
	END_GAME,
	TIMEOUT
}

var state: State :
	get():
		return state
	set(value):
		if value != state:
			state = value
			emit_signal("state_changed", state)

signal state_changed(new_state: State)

##### BUILT-IN #####

func _ready() -> void:
	Event.connect("player_change_hp", _on_player_change_hp)
	Event.connect("go_gameover", _on_go_gameover)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

##### LOGIC #####

func state_change_for_in_game():
	pass

func state_change_for_end_game():
	pass

func state_change_for_timeout():
	pass

##### SIGNAL RESPONSES #####

func _on_go_gameover(winner: String):
	print("winner : ", winner)
	var instance: GameOver = GAMEOVER.instantiate()
	instance.winner = winner
	get_tree().root.add_child(instance)

func _on_player_change_hp(p1: bool, new_amt: int):
	if new_amt <= 0:
		Event.emit_signal("victory", !p1)

func _on_state_changed(_state: State):
	match _state:
		State.IN_GAME:
			state_change_for_in_game()
		State.END_GAME:
			state_change_for_end_game()
		State.TIMEOUT:
			state_change_for_timeout()
