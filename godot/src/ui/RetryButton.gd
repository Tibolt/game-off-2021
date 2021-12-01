extends Button

func _on_button_up() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	GlobalStats.score = 0
	PlayerStats.health = PlayerStats.max_health
	GlobalStats.worm_score = 0
	GlobalStats.enemies_number = 0


