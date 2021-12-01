extends actor

enum{
	IDLE,
	MOVE,
	}
var state = MOVE

onready var axe: Node2D = get_node("axe")
onready var axe_animation: AnimationPlayer = axe.get_node("AxeAnimationPlayer")
onready var hurtbox = $hurtbox
onready var playerAttackSound = $PlayerAttackSound

func _ready():
	PlayerStats.connect("no_health", self, "queue_free")
	state_machine = $AnimationTree.get("parameters/playback")
	playerAttackSound.volume_db = GlobalStats.sound_volume

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func _physics_process(delta: float):
	weapon_move()
	
	match state:
		IDLE:
			idle_state(delta)
		MOVE:
			move_state(delta)


func idle_state(delta:float):
	# velocity = move_and_slide(velocity)
	state_machine.travel("idle")

	if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		state = MOVE
		
	attack_animation()
	

func move_state(delta: float):
	var direction = get_direction()
	direction = direction.normalized()

	if direction != Vector2.ZERO:
		velocity = velocity.move_toward(direction * max_speed, speed * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)

	velocity = move_and_slide(velocity)
	
	_animation(direction)
	
	if velocity == Vector2.ZERO:
		state = IDLE
	
	state_machine.travel("run")
	
	attack_animation()

func _animation(direction: Vector2):
	var current = state_machine.get_current_node()

	if direction.x > 0 and $Sprite.flip_h == true:
		$Sprite.flip_h = false
	elif direction.x < 0 and $Sprite.flip_h == false:
		$Sprite.flip_h = true

# weapon moves with mouse	
func mouse_move():
	var mouse_direction: Vector2 = get_global_mouse_position() - global_position.normalized()
	
	if mouse_direction.x > 0 and $Sprite.flip_h == true:
		$Sprite.flip_h = false
	elif mouse_direction.x < 0 and $Sprite.flip_h == false:
		$Sprite.flip_h = true

	axe.rotation = mouse_direction.angle()
	if axe.scale.x == 1 and mouse_direction.x < 0:
		axe.scale.x = -1
	elif axe.scale.x == -1 and mouse_direction.x > 0:
		axe.scale.x = 1
		

# weapon moves with player movment	
func weapon_move():
	var direction = get_direction()
	
	if axe.scale.x == 1 and direction.x < 0:
		axe.scale.x = -1
	elif axe.scale.x == -1 and direction.x > 0:
		axe.scale.x = 1

func attack_animation():
	if Input.is_action_just_pressed("l_attack") and !axe_animation.is_playing():
		axe_animation.play("slash")


func _on_hurtbox_area_entered(area):
	PlayerStats.health -= 1
	hurtbox.start_invicibility(1)
	hurtbox.hit_effect()
