extends Node2D

# Will track the two states of screen hidden/unhidden
# and when an entry is active

@onready var mommy_manager : Node2D = $MommyManager
@onready var minigame_screen : Node2D = $MinigameScreen

var has_lost: bool = false

func _ready() -> void:
	# Reset lost state (needed for replaying)
	has_lost = false
	mommy_manager.entry_became_active.connect(_on_entry_became_active)
	minigame_screen.screen_state_changed.connect(_on_screen_state_changed)

# Whenever a state changes, check the state of the other
func _on_entry_became_active() -> void:
	check_caught_condition()

func _on_screen_state_changed(_new_state) -> void:
	check_caught_condition()

func check_caught_condition() -> void:
	if mommy_manager.has_active_entry_only() and minigame_screen.is_unhidden():
		# End game once caught
		if has_lost:
			return
		has_lost = true
		GameManager.trigger_lose_condition()
