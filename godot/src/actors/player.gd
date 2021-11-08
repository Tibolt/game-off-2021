extends actor

enum{
	IDLE,
	MOVE,
	ATTACK,
	}

var state = MOVE

func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))

func _physics_process(delta: float):
	match state:
		IDLE:
			idle_state(delta)
		MOVE:
			move_state(delta)
		ATTACK:
			pass

func idle_state(delta:float):
	# velocity = move_and_slide(velocity)

	if Input.is_action_just_pressed("move_up") or Input.is_action_just_pressed("move_down") or Input.is_action_just_pressed("move_left") or Input.is_action_just_pressed("move_right"):
		state = MOVE

func move_state(delta: float):
	var direction = get_direction()
	
	if direction.x != 0.0:
		velocity.x = move_toward(velocity.x, direction.x * speed, speed * delta)
	if direction.x == 0.0:
		velocity.x = move_toward(velocity.x, 0, friction * delta)
		
	if direction.y != 0.0:
		velocity.y = move_toward(velocity.y, direction.y *speed, speed * delta)
	if direction.y == 0.0:
		velocity.y = move_toward(velocity.y, 0, friction * delta)

	velocity = move_and_slide(velocity)

	if velocity == Vector2(0,0):
		state = IDLE
		
