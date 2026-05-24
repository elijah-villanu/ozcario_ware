extends Control

# Responsible for sending player to room scene

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/room.tscn")
