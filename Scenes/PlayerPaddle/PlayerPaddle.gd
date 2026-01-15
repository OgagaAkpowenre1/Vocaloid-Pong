extends PaddleBase
class_name PlayerPaddle

#const SPEED = 200
#const ACCELERATION = 800
#const FRICTION = 800
#const PADDLE_HALF_HEIGHT = 16  # Actually 2 (4px/2), not 16!
#
#var velocity = Vector2.ZERO
#var last_position = Vector2.ZERO
#var input_vector = Vector2.ZERO
#
#func _ready():
#	position = Vector2(10, 90)
#	last_position = position
#
#	# Add to paddle group for easy detection
#	add_to_group("paddle")
#
#	# Add collision shape if not in editor
#	if not has_node("CollisionShape2D"):
#		var shape = CollisionShape2D.new()
#		var rect = RectangleShape2D.new()
#		rect.extents = Vector2(16, 2)  # 32x4 paddle
#		shape.shape = rect
#		add_child(shape)
#
#func _physics_process(delta):
#	last_position = position  # Store for velocity calculation
#
#	input_vector = Vector2.ZERO
#
##	if Input.is_action_pressed("down"):
##		input_vector.y = 1
##	elif Input.is_action_pressed("up"):
##		input_vector.y = -1
#	get_player_input()
#
#	# Accelerate when moving
#	if input_vector != Vector2.ZERO:
#		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
#	# Decelerate when no input
#	else:
#		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
#
#	# Apply movement
#	move_and_collide(velocity * delta)
#
## Clamp with paddle height consideration
#	position.y = clamp(position.y, PADDLE_HALF_HEIGHT , 180 - PADDLE_HALF_HEIGHT)
#
#func get_velocity():
#	# Return current velocity for ball to use
#	return velocity
#
#func get_player_input():
#	if Input.is_action_pressed("down"):
#		input_vector.y = 1
#	elif Input.is_action_pressed("up"):
#		input_vector.y = -1

func _ready():
	._ready()  # Call parent's _ready
	position = Vector2(10, 90)  # Left side

func process_input():
	# Player input logic
	input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("down"):
		input_vector.y = 1
	elif Input.is_action_pressed("up"):
		input_vector.y = -1
