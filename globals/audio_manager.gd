extends Node2D
@onready var active_sfx : AudioStreamPlayer = $ActiveSFX

func play_active_sfx() -> void:
	if active_sfx:
		if !active_sfx.playing:
			active_sfx.play()
			
			# Only have it play for x seconds
			await get_tree().create_timer(4.0).timeout
			active_sfx.stop()
