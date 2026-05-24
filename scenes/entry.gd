extends Node2D

@onready var color_polygon : Polygon2D = $Polygon2D # TEMP UNTIL WE GET THE TEXTURE
@onready var in_progress_timer : Timer = $InProgressTimer
@onready var active_timer : Timer = $ActiveTimer

# Signal to tell manager this entry has switched to rest
signal returned_to_rest
# Signal to tell manager this entry is active
signal became_active

var in_progress_duration : float
var active_duration : float

enum EntryState {
	REST,
	IN_PROGRESS,
	ACTIVE
}
var state : EntryState

func _ready() -> void:
	if color_polygon:
		color_polygon.modulate = Color(1, 1, 1, 1)
	# Initially start at rest
	state = EntryState.REST

# Called by mommy_manager when it's time for this entry to become active
# Will start state timers and switch the state of entry
# Switch to in-progress state
func activate() -> void:
	state = EntryState.IN_PROGRESS
	
	# Set timer times
	in_progress_duration = randf_range(0.25, 3.0)
	active_duration = randf_range(1.0, 2.0)
	in_progress_timer.wait_time = in_progress_duration
	active_timer.wait_time = active_duration
	
	in_progress_timer.start()
	# Change to yellow
	color_polygon.modulate = Color(1, 1, 0, 1)

# Switch to active state
func _on_in_progress_timer_timeout() -> void:
	state = EntryState.ACTIVE
	active_timer.start()
	color_polygon.modulate = Color(1, 0, 0, 1)
	became_active.emit()
	
# Switch to rest state
func _on_active_timer_timeout() -> void:
	state = EntryState.REST
	color_polygon.modulate = Color(1, 1, 1, 1)
	returned_to_rest.emit()
