extends Node2D

export var enemiesToKill = 1

onready var door = $Fence_door


func _process(delta):
	if GlobalStats.worm_score == enemiesToKill:
		door.open_door()
	
