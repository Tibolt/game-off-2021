extends AnimatedSprite


func _ready():
	frame = 0
	play("Animate")
	
func _on_animation_finished():
	queue_free()
