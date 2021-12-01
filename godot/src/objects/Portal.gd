tool
extends Area2D

onready var animPlayer: AnimationPlayer = $AnimationPlayer
export var nextScene: PackedScene

func _get_configuration_warning() -> String:
	return "Next scene is empty" if not nextScene else ""
	
func teleport() -> void:
	animPlayer.play("Fade")
	# wait for animation to finish
	yield(animPlayer, "animation_finished")
	GlobalStats.score = 0
	GlobalStats.worm_score = 0
	PlayerStats.health = PlayerStats.max_health
	get_tree().change_scene_to(nextScene)

func _on_body_entered(body):
	teleport()
