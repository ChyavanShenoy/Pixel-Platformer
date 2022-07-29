extends KinematicBody2D
class_name Player

enum { MOVE, CLIMB }

export(Resource) var moveData

var velocity = Vector2.ZERO
var state = MOVE

onready var Sprite = $Sprite
onready var LadderCheck = $LadderCheck


func _ready() -> void:
	Sprite.frames = load("res://PlayerBlueSkin.tres")
	pass

func _physics_process(_delta: float) -> void:
	var input = Vector2.ZERO
	input.x = Input.get_axis("left", "right")
	input.y = Input.get_axis("ui_up", "ui_down")
	match state:
		MOVE: move_state(input)
		CLIMB: climb_state(input)


func apply_gravity():
	velocity.y += moveData.GRAVITY
	moveData.GRAVITY = clamp(moveData.GRAVITY, -moveData.MAX_SPEED, moveData.MAX_SPEED)

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.FRICTION)

func apply_acceleration(input_x_amount):
	velocity.x = move_toward(velocity.x, input_x_amount * moveData.MAX_SPEED, moveData.ACCELERATION)

func powerup(powerup_type):
	if powerup_type == "Movement":
		moveData = load("res://FastPlayerMovementData.tres")

func is_on_ladder():
	if not LadderCheck.is_colliding(): return false
	var collider = LadderCheck.get_collider()
	if not collider is Ladder: return false
	return true

func move_state(input):
	if is_on_ladder() and Input.is_action_pressed("ui_up"): state = CLIMB

	apply_gravity()
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
			velocity.y = moveData.JUMP_FORCE
	else:
		Sprite.set_animation("jump")
		if Input.is_action_just_released("jump") and velocity.y < moveData.JUMP_RELEASE:
			velocity.y = moveData.JUMP_RELEASE

		if velocity.y > 0:
			velocity.y += moveData.ADDITIONAL_FALL_GRAVITY
	var was_in_air = not is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() and was_in_air
	if just_landed:
		Sprite.set_animation("idle")
		velocity.y = 0

func climb_state(input):
	if not is_on_ladder(): state = MOVE
	if input.length() != 0:
		Sprite.set_animation("run")
	else:
		Sprite.set_animation("idle")
	velocity = input * 50
	velocity = move_and_slide(velocity, Vector2.UP)
