extends Node

signal hero_selected(hero: Hero, p1: bool)
signal format_selected(format: Data.Format)
signal one_player_format_selected(format: Data.Format, p1: bool)
signal hero_selection_open()

signal reset_game()

signal player_change_hp(p1: bool, new_amt: int)
signal victory(p1: bool)
signal go_gameover()

# Settings signal
signal change_modev()
signal modev_changed()

signal change_menu()
signal menu_changed()

signal change_db_src(db_src: String)
signal db_src_changed()

# Menu Editor Signal
signal check_pressed(_id: int)
signal up_pressed(_id: int)
signal bottom_pressed(_id: int)
signal menu_editor_changed()
