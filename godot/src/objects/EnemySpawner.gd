extends Area2D

const bug = preload("res://src/actors/tall_bug_lvl3.tscn")
onready var timer = $Timer
onready var circle = $CollisionShape2D

var rand = RandomNumberGenerator.new()
var delta = 2

func _ready():
	randomize()
	next_spawn()
	
func _process(delta):
	pass

func spawn():
	var enemy = bug.instance()
	var main = get_tree().current_scene
	rand.randomize()
	var x = rand.randf_range(circle.global_position.x - circle.shape.radius, circle.global_position.x + circle.shape.radius)
	rand.randomize()
	var y = rand.randf_range(circle.global_position.y - circle.shape.radius, circle.global_position.y + circle.shape.radius)
	enemy.position.x = x
	enemy.position.y = y
	main.add_child(enemy)
	
	GlobalStats.enemies_number += 1
	
func  next_spawn():
	var next_time = delta+(randf() - 0.5) * 2
	timer.wait_time = next_time
	timer.start()

func _on_Timer_timeout():
	spawn()
	next_spawn()
