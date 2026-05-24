extends Node

@onready var window : Node2D = $Entry
@onready var door : Node2D = $Entry2
@onready var camera : Node2D = $Entry3
@onready var bed : Node2D = $Entry4

var all_entries : Dictionary

var waiting_to_choose_entry : bool = false

const cooldown_min : float = 4.0
const cooldown_max : float = 9.0
# Time at the beginning of game to wait until first appearance
const initial_wait : float = 15.0

# Signal used for room.gd to check the two states
signal entry_became_active

func _ready() -> void:
	all_entries = {
		"window" : window,
		"door" : door,
		"camera" : camera,
		"bed" : bed
	}
	
	# Connect returned to rest signal to each entry
	for entry in all_entries.values():
		entry.returned_to_rest.connect(_on_entry_returned_to_rest)
		entry.became_active.connect(_on_entry_became_active)
	
	# minimum initial wait time until first appearance, longer than cooldown
	await get_tree().create_timer(initial_wait).timeout
	
	# Initial entry
	choose_entry()

# Randomly chooses the next entry to activate
func choose_entry() -> void:
	# If there's already an active entry, don't do anything
	if has_active_entry():
		return
	
	var entry_keys = all_entries.keys()
	var chosen_entry = all_entries.get(entry_keys.pick_random())
	
	if chosen_entry:
		chosen_entry.activate()

# Returns true if any entries are currently active OR in progress
func has_active_entry() -> bool:
	for entry in all_entries.values():
		if entry:
			if entry.state != entry.EntryState.REST:
				return true
	return false

# Returns true if any entries are currently active ONLY
func has_active_entry_only() -> bool:
	for entry in all_entries.values():
		if entry and entry.state == entry.EntryState.ACTIVE:
			return true
	return false

# Runs when the active entry goes back 
func _on_entry_returned_to_rest() -> void:
	# Envoke cooldown before calling the next entry
	await get_tree().create_timer(randf_range(cooldown_min, cooldown_max)).timeout
	choose_entry()

# Runs when any entry goes active, tells room.gd
func _on_entry_became_active() -> void:
	entry_became_active.emit()
