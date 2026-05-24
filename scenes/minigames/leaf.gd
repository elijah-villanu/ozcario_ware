extends Node2D

@onready var healthy: Sprite2D = $Healthy
@onready var bit: Sprite2D = $Bit
@onready var half: Sprite2D = $Half
@onready var gone: Sprite2D = $Gone
@onready var bee: Node2D = $Bee
@onready var snail: Node2D = $Snail
@onready var beetle: Node2D = $Beetle

@onready var spawn_1: Marker2D = $spawn1
@onready var spawn_2: Marker2D = $spawn2
@onready var spawn_3: Marker2D = $spawn3

@onready var bugs = [bee, snail, beetle]

@onready var spawns = [spawn_1.position, spawn_2.position, spawn_3.position]
@export var flip_h: bool

var health = 100
enum STATE {HEALTHY,BIT,DAMAGED,GONE}

const spawn_min = 3
const spawn_max = 8
const seconds_per_tick = 0.3

var ticks = 0
var time_past = 0

var state  = STATE.HEALTHY

var bug_count = 0

signal bee_sting

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if flip_h:
		healthy.flip_h = flip_h
		bit.flip_h = flip_h
		half.flip_h = flip_h
		gone.flip_h = flip_h
		snail.flip_h = flip_h
		for i in spawns.size():
			spawns[i].x = -spawns[i].x

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if state == STATE.GONE:
		return
	if time_past >= seconds_per_tick:
		ticks+=1
		time_past = 0
		calc_damage()
		change_state()
		if ticks % spawn_max == 0:
			spawn_bug()
		elif ticks % randi_range(spawn_min, spawn_max) == 0:
			spawn_bug()
	
	time_past += delta


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("hide"):
		remove_bug()
		print("removing bug")

func change_state():
	if state == STATE.HEALTHY and health <= 66:
		state = STATE.BIT
		healthy.visible=false
	if state == STATE.BIT and health <= 33:
		state = STATE.DAMAGED
		bit.visible=false
	if state == STATE.DAMAGED and health <= 0:
		state = STATE.GONE
		half.visible=false
		despawn_all()
		
func calc_damage():
	health -= bug_count
	print(health)

func despawn_all():
	for child in get_children():
		if child.is_in_group("bugs"):
			child.queue_free()
	bug_count = 0

func spawn_bug():
	if spawns.is_empty():
		return
	var template = bugs.pick_random()
	var new_bug = template.duplicate()
	add_child(new_bug)
	new_bug.add_to_group("bugs")
	new_bug.visible = true
	new_bug.play("default")
	print(new_bug)
	match template.name:
		"Bee":
			new_bug.flip_h = randi_range(0,1)
			print("bee spawned at ", name)
			new_bug.add_to_group("bee")
		"Beetle":
			bug_count+=1
			new_bug.flip_h = randi_range(0,1)
			print("Beetle spawned at ", name)
			new_bug.add_to_group("beetle")
		"Snail":
			bug_count+=2
			print("snail spawned at ", name)
		_:
			print("nothing found")
	var spawn_index = randi_range(0,len(spawns)-1)
	new_bug.position = spawns.pop_at(spawn_index)
	
func remove_bug():
	for child in get_children():
		if child.is_in_group("beetle"):
			bug_count-=1
			spawns.push_back(child.position)
			child.queue_free()
			return
		elif not child.is_in_group("bee") and child.is_in_group("bugs"):
			bug_count -=2
			spawns.push_back(child.position)
			child.queue_free()
			return
	for child in get_children():
		if child.is_in_group("bee"):
			spawns.push_back(child.position)
			child.queue_free()
			emit_signal("bee_sting")
			return
		
