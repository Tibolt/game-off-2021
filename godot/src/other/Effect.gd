extends AnimatedSprite


func _ready():
	frame = 0
	play("Animate")
	$AudioStreamPlayer.volume_db = GlobalStats.sound_volume
	
func _on_animation_finished():
	queue_free()
