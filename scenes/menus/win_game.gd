extends Control

# Responsible for sending the player to either room or start menu scene

func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")


func _on_start_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/start_menu.tscn")
