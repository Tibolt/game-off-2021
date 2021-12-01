extends StaticBody2D

signal open_door

onready var animation = $AnimatedSprite

func _ready():
	animation.frame = 0
	
func open_door():
	animation.play("Animate")
	animation.stop()
	animation.frame = 4
	emit_signal("open_door")
	$CollisionShape2D.disabled = true
	
