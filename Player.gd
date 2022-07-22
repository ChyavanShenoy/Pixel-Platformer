extends KinematicBody2D

export (int) var MAX_SPEED = 50
export (int) var JUMP_FORCE = -130
export (int) var JUMP_RELEASE = -35
export (int) var ACCELERATION = 10
export (int) var FRICTION = 10
export (int) var GRAVITY = 4
export (int) var ADDITIONAL_FALL_GRAVITY = 4
var velocity = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(_delta: float) -> void:
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	if input.x == 0:
		apply_friction()
	else:
		apply_acceleration(input.x)
	if Input.is_action_pressed("right"):
		velocity.x = 50
	elif Input.is_action_pressed("left"):
		# get_node("Player").set_flip_h(false)
		velocity.x = -50 
	else:
		velocity.x = 0 
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_FORCE
	else:
		if Input.is_action_just_released("jump") and velocity.y < JUMP_RELEASE:
			velocity.y = -30

		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	velocity = move_and_slide(velocity, Vector2.UP)

func apply_gravity():
	velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(input_x_amount):
	velocity.x = move_toward(velocity.x, input_x_amount * MAX_SPEED, ACCELERATION)
