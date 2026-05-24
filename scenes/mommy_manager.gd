extends Node

@onready var window : Node2D = $Entry
@onready var door : Node2D = $Entry2
@onready var camera : Node2D = $Entry3
@onready var bed : Node2D = $Entry4

var all_entries = {
	"window" : window,
	"door" : door,
	"camera" : camera,
	"bed" : bed
}

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
