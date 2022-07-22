extends KinematicBody2D

var velocity = Vector2.ZERO

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	velocity.y += 4
	if Input.is_action_pressed("right"):
		velocity.x = 50
	elif Input.is_action_pressed("left"):
		velocity.x = -50 
	else:
		velocity.x = 0 
	if Input.is_action_just_pressed("jump"):
		velocity.y = -100
	velocity = move_and_slide(velocity)