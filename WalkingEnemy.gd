extends KinematicBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var edge_check_right = $EdgeCheckRight
onready var edge_check_left = $EdgeCheckLeft
onready var Sprite = $AnimatedSprite

func _physics_process(_delta: float) -> void:
	var found_wall = is_on_wall()
	var found_edge = not edge_check_left.is_colliding() or not edge_check_right.is_colliding()
	if found_wall or found_edge:
		direction *= -1
	Sprite.flip_h = direction.x > 0
	velocity = direction * 25
	move_and_slide(velocity, Vector2.UP)