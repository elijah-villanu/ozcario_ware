extends Sprite2D

# Background music
@onready var bg_music : AudioStreamPlayer = $InGameMusic

# State machine for when the device is out or hidden
enum ScreenState {
	UNHIDDEN,
	HIDDEN
}

var state : ScreenState

# Signal used for room.gd to check the two states
signal screen_state_changed(new_state)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set initial state 
	state = ScreenState.HIDDEN
	self.visible = false
	bg_music.stream_paused = true
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		toggle_screen()

func toggle_screen():
	if state == ScreenState.UNHIDDEN:
		set_screen_state(ScreenState.HIDDEN)
	else:
		set_screen_state(ScreenState.UNHIDDEN)

func set_screen_state(new_state: ScreenState) -> void:
	if state == new_state:
		return
	
	state = new_state
	self.visible = state == ScreenState.UNHIDDEN
	bg_music.stream_paused = state != ScreenState.UNHIDDEN
	
	screen_state_changed.emit(state)

func is_unhidden() -> bool:
	return state == ScreenState.UNHIDDEN
