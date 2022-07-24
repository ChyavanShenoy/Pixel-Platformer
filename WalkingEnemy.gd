extends KinematicBody2D

var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# # Called when the node enters the scene tree for the first time.
# func _ready() -> void:
# 	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# #func _process(delta: float) -> void:
# #	pass


func _physics_process(delta: float) -> void:
	velocity = direction * 25
	move_and_slide(velocity)