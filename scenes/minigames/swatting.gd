extends Node2D

@onready var leaf: Node2D = $Leaf
@onready var leaf_2: Node2D = $Leaf2
@onready var leaf_3: Node2D = $Leaf3
@onready var leaf_4: Node2D = $Leaf4

@onready var l_hand: Sprite2D = $l_Hand
@onready var r_hand: Sprite2D = $r_Hand
@onready var l_timer: Timer = $l_timer
@onready var r_timer: Timer = $r_timer

var l_locked = false
var r_locked = false

var l_time = 0
var r_time = 0

const timeout = 5
var def_l
var def_r

var bugs_killed = 0
const score_needed = 67
var block_inp = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	leaf.bee_sting.connect(l_lockout)
	leaf_2.bee_sting.connect(l_lockout)
	leaf_3.bee_sting.connect(r_lockout)
	leaf_4.bee_sting.connect(r_lockout)
	l_hand.flip_h = true
	
	def_l = l_hand.global_position
	def_r = r_hand.global_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if bugs_killed >= score_needed:
		GameManager.trigger_win_condition()
	if Input.is_action_just_pressed("primary") and not l_locked and not block_inp:
		check_left()
	if Input.is_action_just_pressed("secondary") and not r_locked and not block_inp:
		check_right()
	
	if l_locked:
		l_time += delta
	if r_locked:
		r_time += delta

	if l_time >= timeout:
		l_unlock()
	if r_time >= timeout:
		r_unlock()
	
	if leaf.health <= 0 and leaf_2.health <= 0 and leaf_3.health <= 0 and leaf_4.health <= 0:
		GameManager.lose_msg = "IT DIED! :("
		GameManager.trigger_lose_condition()

func l_lockout():
	l_locked = true
	l_hand.modulate = Color("red")
	bugs_killed -= 1
	

func r_lockout():
	r_locked = true
	r_hand.modulate = Color("red")
	bugs_killed -= 1

func l_unlock():
	l_locked = false
	l_time = 0
	l_hand.modulate = Color("white")
	
func r_unlock():
	r_locked = false
	r_time = 0
	r_hand.modulate = Color("white")

func check_left():
	var ret = Vector2(10000,10000)
	if leaf.bug_count > 0:
		ret = leaf.remove_bug()
	if ret == Vector2(10000,10000):
		ret = leaf_2.remove_bug()
	if ret == Vector2(10000,10000):
		ret = leaf.remove_bug()
	if ret != Vector2(10000,10000):
		l_hand.global_position = ret
		l_timer.start(1)
		bugs_killed +=1

func check_right():
	var ret = Vector2(10000,10000)
	if leaf_3.bug_count > 0:
		ret = leaf_3.remove_bug()
	if ret == Vector2(10000,10000):
		ret = leaf_4.remove_bug()
	if ret == Vector2(10000,10000):
		ret = leaf_3.remove_bug()
	if ret != Vector2(10000,10000):
		r_hand.global_position = ret
		r_timer.start(1)
		bugs_killed +=1
	
func _on_l_timer_timeout() -> void:
	l_hand.global_position = def_l

func _on_r_timer_timeout() -> void:
	r_hand.global_position = def_r
