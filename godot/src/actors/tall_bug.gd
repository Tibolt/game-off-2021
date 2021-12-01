extends actor

const deathEffect = preload("res://src/other/EnemyDeathEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE,
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
	state = pick_random_state([IDLE, WANDER])

func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, 200 * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
			seek_player()
			if wanderManager.get_time_left() == 0:
				update_wander()
		WANDER:
			seek_player()
			if wanderManager.get_time_left() == 0:
				update_wander()
				
			move_toward_point(wanderManager.target_pos, delta)
			
			if global_position.direction_to(wanderManager.target_pos) <= Vector2(wander_target,wander_target):
				update_wander()
		CHASE:
			var player = playerDetection.player
			if $Sprite.flip_h:
				$Position2D.rotation_degrees = 180
			else:
				$Position2D.rotation_degrees = 0
			if player != null:
				move_toward_point(player.global_position, delta)
			else:
				state = IDLE
				
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 400
	velocity = move_and_slide(velocity)
	_animation(velocity)

func move_toward_point(point, delta):
	var dir = global_position.direction_to(point)
	velocity = velocity.move_toward(dir * max_speed, speed * delta)
	$Sprite.flip_h = velocity.x < 0

func seek_player():
	if playerDetection.can_seek_player():
		state = CHASE

func pick_random_state(state_list: Array):
	state_list.shuffle()
	return state_list.pop_front()

func update_wander():
	state = pick_random_state([IDLE, WANDER])
	wanderManager.set_wander_timer(rand_range(1,3))

func _animation(velocity: Vector2) -> void:
	if velocity != Vector2.ZERO:
		animation.play("run")
	else:
		animation.play("idle")

func _on_hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * 150


func _no_health():
	queue_free()
	GlobalStats.score += 1
	GlobalStats.enemies_number -= 1
	var enemyDeathEffect = deathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
