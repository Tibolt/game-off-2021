extends actor

const deathEffect = preload("res://src/other/EnemyDeathEffect.tscn")
onready var animation: AnimationPlayer = $AnimationPlayer

enum {
	IDLE,
	CHASE,
}

onready var stats = $Stats
onready var playerDetection = $PlayerDetection
var knockback = Vector2.ZERO
var state = CHASE


func _ready():
	# turn off physic proces at start of game
	#set_physics_process(false)
	pass

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
		CHASE:
			var player = playerDetection.player
			if player != null:
				var dir = -(player.global_position - global_position).normalized()
				velocity = velocity.move_toward(dir * max_speed, speed * delta)
				$Sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
				
	velocity = move_and_slide(velocity)
	if velocity > Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")
	#_animation(velocity)
	
func seek_player():
	if playerDetection.can_seek_player():
		state = CHASE

func _animation(velocity: Vector2) -> void:
	pass

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150


func _no_health():
	queue_free()
	var enemyDeathEffect = deathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
