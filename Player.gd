extends KinematicBody2D
class_name Player

export (int) var MAX_SPEED = 50
export (int) var JUMP_FORCE = -130
export (int) var JUMP_RELEASE = -35
export (int) var ACCELERATION = 10
export (int) var FRICTION = 10
export (int) var GRAVITY = 4
export (int) var ADDITIONAL_FALL_GRAVITY = 4
var velocity = Vector2.ZERO

onready var Sprite = get_node("Sprite")

func _ready() -> void:
	Sprite.frames = load("res://PlayerBlueSkin.tres")
	pass

func _physics_process(_delta: float) -> void:
	apply_gravity()
	var input = Vector2.ZERO
	input.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	if input.x == 0:
		apply_friction()
		Sprite.set_animation("idle")
	else:
		apply_acceleration(input.x)
		Sprite.set_animation("run")
	if Input.is_action_pressed("right"):
		velocity.x = 50
		Sprite.flip_h = true
	elif Input.is_action_pressed("left"):
		Sprite.flip_h = false
		velocity.x = -50 
	else:
		velocity.x = 0 
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y = JUMP_FORCE
	else:
		Sprite.set_animation("jump")
		if Input.is_action_just_released("jump") and velocity.y < JUMP_RELEASE:
			velocity.y = JUMP_RELEASE

		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		Sprite.set_animation("idle")
		velocity.y = 0

func apply_gravity():
	velocity.y += GRAVITY
	GRAVITY = clamp(GRAVITY, -MAX_SPEED, MAX_SPEED)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(input_x_amount):
	velocity.x = move_toward(velocity.x, input_x_amount * MAX_SPEED, ACCELERATION)
