# PaddleBase.gd (abstract class, not meant to be used directly)
extends KinematicBody2D
class_name PaddleBase

const SPEED = 200
const ACCELERATION = 800
const FRICTION = 800
const PADDLE_HALF_HEIGHT = 16  # 2px for 4px tall paddle

var velocity = Vector2.ZERO
var input_vector = Vector2.ZERO
var is_paused = false

func _ready():
	# Common initialization
	add_to_group("paddle")
	setup_collision()

func setup_collision():
	if not has_node("CollisionShape2D"):
		var shape = CollisionShape2D.new()
		var rect = RectangleShape2D.new()
		rect.extents = Vector2(2, 16)  # 32x4 paddle
		shape.shape = rect
		add_child(shape)

func _physics_process(delta):
	if is_paused:
		return
	# Get input (to be overridden by child classes)
	process_input()
	
	# Common movement logic
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Apply movement
	move_and_collide(velocity * delta)
	
	# Clamp position
	position.y = clamp(position.y, PADDLE_HALF_HEIGHT, 180 - PADDLE_HALF_HEIGHT)

# To be overridden by child classes
func process_input():
	# Base class does nothing - child classes implement
	pass

func get_velocity():
	return velocity

# Add this method to be called by main game
func toggle_physics_processing(enabled: bool):
	set_physics_process(enabled)
	is_paused = !enabled
