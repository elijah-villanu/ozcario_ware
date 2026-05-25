extends Node2D

@onready var color_polygon : Polygon2D = $Polygon2D # TEMP UNTIL WE GET THE TEXTURE
@onready var in_progress_timer : Timer = $InProgressTimer
@onready var active_timer : Timer = $ActiveTimer
@onready var in_progress_sfx : AudioStreamPlayer = $InProgressSFX
@onready var mom_sprite : Sprite2D = $Mom
@onready var window_sprite : Sprite2D = $Window

# Signal to tell manager this entry has switched to rest
signal returned_to_rest
# Signal to tell manager this entry is active
signal became_active

var in_progress_min : float = 1.0
var in_progress_max : float = 4.0
var active_min : float = 2.0
var active_max : float = 3.0

enum EntryState {
	REST,
	IN_PROGRESS,
	ACTIVE
}
var state : EntryState

func _ready() -> void:
	if color_polygon:
		color_polygon.modulate = Color(0.01, 0.01, 0.3, 1)
	mom_sprite.modulate.a = 0
	# Initially start at rest
	state = EntryState.REST

# Called by mommy_manager when it's time for this entry to become active
# Will start state timers and switch the state of entry
# Switch to in-progress state
func activate() -> void:
	state = EntryState.IN_PROGRESS
	
	# Set timer times
	in_progress_timer.wait_time = randf_range(in_progress_min, in_progress_max)
	active_timer.wait_time = randf_range(active_min, active_max)
	
	in_progress_timer.start()
	# Change to yellow
	color_polygon.modulate = Color(0.3, 0, 0.125, 1)
	mom_sprite.modulate.a = 0.4
	# Play progress sfx
	in_progress_sfx.play()

# Switch to active state
func _on_in_progress_timer_timeout() -> void:
	state = EntryState.ACTIVE
	active_timer.start()
	color_polygon.modulate = Color(1, 0, 0, 1)
	mom_sprite.modulate.a = 1
	became_active.emit()
	
	# Play active sfx
	if in_progress_sfx.playing:
		in_progress_sfx.stop()
	# Active must be global
	AudioManager.play_active_sfx()
	
# Switch to rest state
func _on_active_timer_timeout() -> void:
	state = EntryState.REST
	color_polygon.modulate = Color(0.01, 0.01, 0.3, 1)
	mom_sprite.modulate.a = 0
	returned_to_rest.emit()
	
