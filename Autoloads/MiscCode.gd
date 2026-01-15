#extends Node
#
## Ball.gd
#extends KinematicBody2D
#
#var velocity = Vector2(150, 150)
#var ball_radius = 2.5
#
#func _physics_process(delta):
#    var collision = move_and_collide(velocity * delta)
#
#    if collision:
#        # Bounce with reflection
#        velocity = velocity.bounce(collision.normal)
#
#        # Add small offset to prevent sticking
#        position += collision.normal * 0.1
#
#        # Optional: Adjust angle based on where ball hit paddle
#        if collision.collider.has_method("get_paddle_hit_factor"):
#            var hit_factor = collision.collider.get_paddle_hit_factor(collision.position)
#            velocity.y += hit_factor * 50  # Adjust vertical speed
#
#    # Screen boundaries
#    if position.y - ball_radius < 0:
#        position.y = ball_radius
#        velocity.y = abs(velocity.y)
#    elif position.y + ball_radius > 180:
#        position.y = 180 - ball_radius
#        velocity.y = -abs(velocity.y)

extends KinematicBody2D

const SPEED = 200
const ACCELERATION = 800
const FRICTION = 800
const PADDLE_HALF_HEIGHT = 16  # Half of 4px sprite

var velocity = Vector2.ZERO

func _ready():
	position = Vector2(10, 90)

func _physics_process(delta):
	var input_vector = Vector2.ZERO
	
	if Input.is_action_pressed("down"):
		input_vector.y = 1
	elif Input.is_action_pressed("up"):
		input_vector.y = -1
	
	# Accelerate when moving
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * SPEED, ACCELERATION * delta)
	# Decelerate when no input
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	# Apply movement
	move_and_collide(velocity * delta)
	
	# Clamp with paddle height consideration
	position.y = clamp(position.y, PADDLE_HALF_HEIGHT, 180 - PADDLE_HALF_HEIGHT)


	# Center the message label
#	message_label.rect_position = Vector2(160, 90)  # Center of screen
#	message_label.anchor_left = 0.5
#	message_label.anchor_right = 0.5
#	message_label.anchor_top = 0.5
#	message_label.anchor_bottom = 0.5
#	message_label.margin_left = -50  # Half of 100 width
#	message_label.margin_top = -25   # Half of 50 height
#	center_message_label()

func center_control_dynamic(control_node, max_size = null):
	"""
	Centers a control node based on its actual content size
	control_node: The Control node to center (Label, Button, etc.)
	max_size: Optional maximum size Vector2(width, height)
	"""
	
	# Wait for control to update its size
	yield(get_tree(), "idle_frame")
	
	# Get the control's actual size (after text is set)
	var content_size = control_node.rect_size
	
	# Use max_size if provided, otherwise use content_size
	var target_size = max_size if max_size else content_size
	
	# Set anchors to center
	control_node.anchor_left = 0.5
	control_node.anchor_top = 0.5
	control_node.anchor_right = 0.5
	control_node.anchor_bottom = 0.5
	
	# Center the control with its actual size
	control_node.margin_left = -target_size.x / 2
	control_node.margin_top = -target_size.y / 2
	control_node.margin_right = target_size.x / 2
	control_node.margin_bottom = target_size.y / 2
	
	# Set pivot to center for scaling
	control_node.rect_pivot_offset = target_size / 2
	
	return target_size
