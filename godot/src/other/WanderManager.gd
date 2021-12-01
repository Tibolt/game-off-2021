extends Node2D

onready var start_pos = global_position
onready var target_pos = global_position
onready var timer = $Timer

export(int) var wander_range = 32


func _ready():
	update_pos()

func update_pos():
	var target_vector = Vector2(rand_range(-wander_range,wander_range), rand_range(-wander_range,wander_range))
	target_pos = start_pos + target_vector

func get_time_left():
	return timer.time_left
	
func set_wander_timer(value):
	timer.start(value)

func _on_Timer_timeout():
	update_pos()
