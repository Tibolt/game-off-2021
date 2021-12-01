extends actor

const deathEffect = preload("res://src/other/EnemyDeathEffect.tscn")

enum {
	IDLE,
	CHASE,
	WANDER,
}

onready var animation: AnimationPlayer = $AnimationPlayer
onready var stats = $Stats
onready var playerDetection = $PlayerDetection
onready var softCollision = $SoftCollision
onready var wanderManager = $WanderManager

var knockback = Vector2.ZERO
var state = CHASE

export var wander_target = 4


func _ready():
	randomize()
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderManager.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderManager.set_wander_timer(rand_range(1,4))
		CHASE:
			var player = playerDetection.player
			if player != null:
				var dir = -(player.global_position - global_position).normalized()
				velocity = velocity.move_toward(dir * max_speed, speed * delta)
				$Sprite.flip_h = velocity.x < 0
			else:
				state = IDLE
		WANDER:
			seek_player()
			if wanderManager.get_time_left() == 0:
				state = pick_random_state([IDLE, WANDER])
				wanderManager.set_wander_timer(rand_range(1,4))
				
			var dir = (wanderManager.target_pos - global_position).normalized()
			velocity = velocity.move_toward(dir * max_speed, speed * delta)
			
			if global_position.direction_to(wanderManager.target_pos) <= Vector2(wander_target,wander_target):
				state = pick_random_state([IDLE, WANDER])
				wanderManager.set_wander_timer(rand_range(1,4))
		
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400		
	velocity = move_and_slide(velocity)
	_animation(velocity)
	
func seek_player():
	if playerDetection.can_seek_player():
		state = CHASE
		
func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func _animation(velocity: Vector2) -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150


func _no_health():
	GlobalStats.worm_score += 1
	queue_free()
	var enemyDeathEffect = deathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
