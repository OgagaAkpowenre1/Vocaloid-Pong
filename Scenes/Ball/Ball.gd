extends KinematicBody2D
class_name Ball

var velocity = Vector2.ZERO  # Consistent speed
var ball_radius = 2.5  # For 5x5 sprite (half size)
var is_paused = false

func _ready():
	# Random initial direction but consistent speed
	var speed = 150
	var angle = randf() * 2 * PI  # Random direction
	velocity = Vector2(cos(angle), sin(angle)) * speed
	add_to_group("ball")

func _physics_process(delta):
	if is_paused: 
		return
	# Move with collision detection
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		handle_collision(collision)
	
	# Screen boundaries
	check_boundaries()

func handle_collision(collision):
	var collider = collision.collider
	
	# Check if it's a paddle (by group, name, or class)
	if collider.is_in_group("paddle"):
		# Bounce off paddle
		velocity = velocity.bounce(collision.normal)
		
		# Add paddle velocity influence (for "English" effect)
		if collider.has_method("get_velocity"):
			var paddle_vel = collider.get_velocity()
			velocity.y += paddle_vel.y * 0.3  # Transfer some vertical velocity
		
		# Move ball slightly away to prevent sticking
		position += collision.normal * 0.5
		
		# Optional: Increase speed slightly on each hit
		velocity = velocity.normalized() * min(velocity.length() * 1.05, 300)  # Cap at 300
		
	# For walls (top/bottom), bounce normally
	else:
		velocity = velocity.bounce(collision.normal)
		position += collision.normal * 0.5

func check_boundaries():
	# Left boundary (score for right player)
	if position.x - ball_radius < 0:
		get_parent().score_point("right")  # Call parent's scoring function
#		reset_ball()
	
	# Right boundary (score for left player)
	elif position.x + ball_radius > 320:
		get_parent().score_point("left")
#		reset_ball()
	
	# Top boundary (bounce)
	if position.y - ball_radius < 0:
		position.y = ball_radius
		velocity.y = abs(velocity.y)
	
	# Bottom boundary (bounce)
	elif position.y + ball_radius > 180:
		position.y = 180 - ball_radius
		velocity.y = -abs(velocity.y)

func reset_ball():
	position = Vector2(160, 90)  # Center
	var angle = randf() * PI/3 - PI/6  # Random angle between -30 and 30 degrees
	var speed = 150
	velocity = Vector2(cos(angle), sin(angle)) * speed
	
	# Randomize left/right direction
	if randi() % 2 == 0:
		velocity.x *= -1

func toggle_physics_processing(enabled: bool):
	set_physics_process(enabled)
	is_paused = !enabled
