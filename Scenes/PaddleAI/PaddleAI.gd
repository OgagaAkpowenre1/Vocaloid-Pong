# AIPaddle.gd
extends PaddleBase
class_name AIPaddle

enum DIFFICULTY {EASY, MEDIUM, HARD}
export(DIFFICULTY) var difficulty = DIFFICULTY.MEDIUM

var ball = null
var error_margin = 10.0

func _ready():
	._ready()  # Call parent's _ready
	position = Vector2(310, 90)  # Right side
	setup_collision()
	find_ball()
	set_difficulty(difficulty)

func find_ball():
	var balls = get_tree().get_nodes_in_group("ball")
	if balls.size() > 0:
		ball = balls[0]
		return true
	return false

func set_difficulty(level):
	match level:
		DIFFICULTY.EASY:
			error_margin = 20.0
		DIFFICULTY.MEDIUM:
			error_margin = 10.0
		DIFFICULTY.HARD:
			error_margin = 5.0

func process_input():
	# AI input logic (overrides parent)
	if not ball or not is_instance_valid(ball):
		if not find_ball():
			input_vector = Vector2.ZERO
			return
	
	var target_y = calculate_target_position()
	var direction = 0
	
	if position.y < target_y - error_margin:
		direction = 1
	elif position.y > target_y + error_margin:
		direction = -1
	
	input_vector = Vector2(0, direction)

func calculate_target_position():
	if not ball:
		return position.y
	
	var predicted_y = ball.position.y
	
	# Simple prediction
	if ball.velocity.x > 0:  # Ball moving right
		var time_to_reach = (position.x - ball.position.x) / ball.velocity.x
		predicted_y = ball.position.y + (ball.velocity.y * time_to_reach)
	
	# Add random error based on difficulty
	predicted_y += rand_range(-error_margin, error_margin)
	
	return clamp(predicted_y, PADDLE_HALF_HEIGHT, 180 - PADDLE_HALF_HEIGHT)
