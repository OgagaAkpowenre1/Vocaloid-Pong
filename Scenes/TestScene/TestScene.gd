extends Node2D

var left_score = 0
var right_score = 0
var game_started = false
var max_score = GlobalSettings.max_score
var countdown_sequence = ["3", "2", "1", "GO!"]
var current_countdown_index = 0
var is_paused = false
var was_in_countdown_before_pause = false
var resume_countdown_index = 0

onready var hud = $HUD
onready var countdown_timer = $CountdownTimer
onready var ball = $Ball
onready var left_paddle = $PlayerPaddle
onready var right_paddle = $PaddleAI
onready var pause_timer = $PauseResumeTimer

func _ready():
	# Start a new game
	new_game()

func new_game():
	game_started = false
	is_paused = false
	left_score = 0
	right_score = 0
	
	# Reset positions
	reset_positions()
	
	# Hide game elements during countdown
#	hide_game_elements()
	
	# Start countdown sequence
	hud.update_score(left_score, right_score)
	start_countdown_sequence()

func start_countdown_sequence():
	was_in_countdown_before_pause = true
	current_countdown_index = 0
	
	# Start with "3"
	hud.show_countdown(3, 1.0)  # Show "3" for 1 second
	
	# Start timer for countdown steps
	countdown_timer.wait_time = 1.0  # Each number lasts 1 second
	countdown_timer.start()

func reset_positions():
	if ball:
		ball.position = Vector2(160, 90)
		ball.velocity = Vector2.ZERO
	
	if left_paddle:
		left_paddle.position = Vector2(10, 90)
	
	if right_paddle:
		right_paddle.position = Vector2(310, 90)

func hide_game_elements():
	if ball:
		ball.hide()
		ball.velocity = Vector2.ZERO  # Stop movement
	if left_paddle:
		left_paddle.hide()
	if right_paddle:
		right_paddle.hide()

func show_game_elements():
	if ball:
		ball.show()
	if left_paddle:
		left_paddle.show()
	if right_paddle:
		right_paddle.show()

func start_game():
	game_started = true
	was_in_countdown_before_pause = false
	show_game_elements()
	
	# Start ball with random direction
	if ball:
		ball.reset_ball()

func score_point(player):
	if is_paused:
		return
	
	if player == "left":
		left_score += 1
	else:
		right_score += 1
#	reset_positions()
	
	hud.update_score(left_score, right_score)
	
	# Check win condition
	if left_score >= max_score or right_score >= max_score:
		print("game over - player " + player + " wins!")
		# Show win message
		hud.show_message(player.to_upper() + " WINS!")
		reset_positions()
		yield(get_tree().create_timer(2.0), "timeout")
		SceneManager.change_scene("res://Scenes/GameOverScreen/GameOverScreen.tscn", "fade")
		
	else:
		# Reset for next point
		reset_positions()
#		hide_game_elements()
		start_countdown_sequence()

func reset_scores():
	left_score = 0
	right_score = 0
	hud.update_score(left_score, right_score)

func _on_CountdownTimer_timeout():
	if is_paused:
		return
	
	current_countdown_index += 1
	
	if current_countdown_index < len(countdown_sequence) - 1:  # 3, 2, 1
		var number = 3 - current_countdown_index
		countdown_timer.start()
		hud.show_countdown(number, 1.0)
	elif current_countdown_index == len(countdown_sequence) - 1:  # "GO!"
		hud.show_countdown(0, 0.5)  # "GO!" for 0.5 seconds
		countdown_timer.wait_time = 0.5  # Shorter for "GO!"
		countdown_timer.start()
	else:  # After "GO!"
		hud.hide_message()
		start_game()
		countdown_timer.stop()


func toggle_pause():
	print("Pause toggled. Game started:", game_started)
	if !game_started:
		return
	
	is_paused = !is_paused
	print("is_paused set to:", is_paused)
	
	if is_paused:
		enter_pause_state()
	else:
		exit_pause_state()

func enter_pause_state():
	print("Entering pause state")
	
	# Store if we were in countdown
	was_in_countdown_before_pause = (countdown_timer.time_left > 0)
	print("Was in countdown:", was_in_countdown_before_pause, " Time left:", countdown_timer.time_left)
	
	# Stop timers
	countdown_timer.stop()  # Use stop() instead of paused = true
	pause_timer.stop()
	
	# Hide current countdown message if showing
	hud.hide_message()
	
	# Show pause message
	hud.show_message("PAUSED", true)
	
	# Set physics process for game objects to false
	set_physics_process_for_game_objects(false)
	
	# Also stop any active tweens on HUD
	hud.stop_all_tweens()
	print("Finished entering pause state")

func exit_pause_state():
	print("Game Resuming")
	
	# Hide pause message
	hud.hide_message()
	
	# Start resume countdown
	start_resume_countdown()

func start_resume_countdown():
	# Show resume countdown
	hud.show_countdown(3, 1.0)
	resume_countdown_index = 0
	
	# Start a separate timer for resume countdown
	pause_timer.wait_time = 1.0
	pause_timer.start()

func _on_PauseResumeTimer_timeout():
	# Handle resume countdown
	resume_countdown_index += 1
	print("Resume countdown index:", resume_countdown_index)
	
	if resume_countdown_index < len(countdown_sequence) - 1:  # 3, 2, 1
		var number = 3 - resume_countdown_index
		hud.show_countdown(number, 1.0)
		pause_timer.start()
	elif resume_countdown_index == len(countdown_sequence) - 1:  # "GO!"
		hud.show_countdown(0, 0.5)
		pause_timer.wait_time = 0.5
		pause_timer.start()
	else:  # After "GO!"
		hud.hide_message()
		complete_resume()

func complete_resume():
	# Resume game
	is_paused = false
	
	# Resume countdown timer if it was running
	if was_in_countdown_before_pause:
		# Restart the countdown timer with remaining time
		countdown_timer.start()
		print("Restarted game countdown timer")
	
	# Re-enable physics process for game objects
	set_physics_process_for_game_objects(true)
	
	# Reset resume index
	resume_countdown_index = 0

func set_physics_process_for_game_objects(enabled: bool):
	# Set physics process for all game objects
	if ball:
		ball.toggle_physics_processing(enabled)
	if left_paddle:
		left_paddle.toggle_physics_processing(enabled)
	if right_paddle:
		right_paddle.toggle_physics_processing(enabled)

func _input(event):
	# Pause toggle (let's use P key for pause)
	if event.is_action_pressed("pause"):
		toggle_pause()
	
	# Don't process game input while paused
	if is_paused:
		return
	
	# Debug scoring (remove in final game)
	if event.is_action_pressed("ui_left"):
		score_point("left")
	if event.is_action_pressed("ui_right"):
		score_point("right")
