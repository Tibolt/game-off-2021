extends Area2D

onready var sprite = $Sprite

func _on_visibility_body_entered(body):
	sprite.modulate = Color(1,1,1,0.39)
	
func _on_visibility_body_exited(body):
	sprite.modulate = Color(1,1,1,1)
