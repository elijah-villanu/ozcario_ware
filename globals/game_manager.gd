extends Node

var lose_msg = "GO TO BED."

func trigger_lose_condition() -> void:
	# Pause the game in the background
	# get_tree().paused 
	# Pulls up game over menu
	get_tree().change_scene_to_file("res://scenes/menus/game_over.tscn")
	AudioManager.play_active_sfx()
