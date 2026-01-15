extends CanvasLayer

onready var left_score_label = $LeftScoreLabel
onready var right_score_label = $RightScoreLabel
onready var center_line = $CenterLine
onready var message_label = $MessageLabel
onready var pause_message_label = $PauseMessageLabel

var base_font_size = 48
var current_font_size = 48
var target_font_size = 96  # Max size for animation
var countdown_tween = null
var pause_tween = null

func _ready():
	# Hide message initially
	message_label.hide()
	
	# Setup scores
	update_score(0, 0)
	
	# Setup center line
	setup_center_line()
	
	configure_message_label()

func update_score(left, right):
	left_score_label.text = str(left)
	right_score_label.text = str(right)

func setup_center_line():
	var viewport_size = get_viewport().size
	
	var line = $CenterLine
	line.width = 2
	line.default_color = Color.white
	
	var dash_texture = preload("res://Assets/DashTexture.png")
	line.texture = dash_texture
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	
	line.points = [Vector2(viewport_size.x / 2, 0), 
				   Vector2(viewport_size.x / 2, viewport_size.y)]

func show_countdown(number, time_left):
	var text = str(number)
	if number == 0:
		text = "GO!"
	
	# Reset to base size
	reset_font_size()
	
	# Hide pause message if showing
	if pause_message_label and pause_message_label.visible:
		pause_message_label.hide()
	
	# Set text and show
	message_label.text = text
	
	message_label.show()
	update_pivot_from_text()
	
	
	# Animate font size growth over time_left seconds
	animate_font_growth(time_left)

func reset_font_size():
	# Reset to base size
	var font = message_label.get_font("font")
	if font:
		font.size = base_font_size
	message_label.rect_scale = Vector2(1, 1)  # Reset scale
	update_pivot_from_text()

func animate_font_growth(duration):
	if countdown_tween and countdown_tween.is_active():
		countdown_tween.stop_all()
	
	countdown_tween = Tween.new()
	add_child(countdown_tween)
	
	# Store initial scale
	var initial_scale = message_label.rect_scale
	
	# Update pivot before animating (to ensure it's centered)
	update_pivot_from_text()
	
	countdown_tween.interpolate_property(
		message_label, "rect_scale",
		Vector2(1, 1), Vector2(1.5, 1.5),
		duration, Tween.TRANS_BACK, Tween.EASE_OUT
	)
	
	countdown_tween.start()

func hide_message():
	if countdown_tween and countdown_tween.is_active():
		countdown_tween.stop_all()
		countdown_tween.queue_free()
		countdown_tween = null
	
	message_label.hide()
	reset_font_size()

#func show_message(message):
#	message_label.text = str(message)
#	message_label.show()
#	update_pivot_from_text()

func show_message(text, is_pause_message = false):
	if is_pause_message and pause_message_label:
		# Use separate pause label
		pause_message_label.text = text
		pause_message_label.show()
		center_pause_message()
	else:
		# Use regular message label
		message_label.text = text
		message_label.show()
		update_pivot_from_text()
		center_message_label()
	
	# Animate pause message differently
	if is_pause_message:
		animate_pause_message()

func center_message_label():
	# Method 1: Using preset (simplest)
#	message_label.rect_min_size = Vector2(100, 50)
#	message_label.set_anchors_and_margins_preset(Control.PRESET_CENTER)
#	message_label.rect_pivot_offset = Vector2(50, 25)  # Center pivot
	
	# Method 2: Manual (if preset doesn't work)
	var viewport_size = get_viewport().size
	message_label.rect_size = Vector2(100, 50)
	message_label.rect_position = (viewport_size - Vector2(100, 50)) / 2
	message_label.rect_pivot_offset = Vector2(50, 25)

func update_pivot_from_text():
	# Wait one frame for label to update its size
	yield(get_tree(), "idle_frame")
	
	# Now the label has its proper size for the current text
	var label_size = message_label.rect_size
	
	# Update pivot to center of current text
	message_label.rect_pivot_offset = label_size / 2
	
	# Update margins to center based on current size
	message_label.margin_left = -label_size.x / 2
	message_label.margin_top = -label_size.y / 2
	message_label.margin_right = label_size.x / 2
	message_label.margin_bottom = label_size.y / 2	

func configure_message_label():
	# Enable auto-sizing
	message_label.autowrap = false  # Don't wrap text
	message_label.clip_text = false  # Don't clip text
	message_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	message_label.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	
	# Set anchors to center
	message_label.anchor_left = 0.5
	message_label.anchor_top = 0.5
	message_label.anchor_right = 0.5
	message_label.anchor_bottom = 0.5
	
	# Set initial margins to 0 (will be adjusted after text is set)
	message_label.margin_left = 0
	message_label.margin_top = 0
	message_label.margin_right = 0
	message_label.margin_bottom = 0

func animate_pause_message():
	if pause_message_label:
		if pause_tween and pause_tween.is_active():
			pause_tween.stop_all()
			pause_tween.queue_free()
		
		pause_tween = Tween.new()
		add_child(pause_tween)
		
		# Pause message pulse effect
		pause_tween.interpolate_property(
			pause_message_label, "rect_scale",
			Vector2(1, 1), Vector2(1.1, 1.1),
			0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT
		)
		
		pause_tween.interpolate_property(
			pause_message_label, "rect_scale",
			Vector2(1.1, 1.1), Vector2(1, 1),
			0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT,
			0.5  # Start after first animation
		)
		
		pause_tween.set_repeat(true)
		pause_tween.start()

func center_pause_message():
	if pause_message_label:
		pause_message_label.rect_pivot_offset = pause_message_label.rect_size / 2
		pause_message_label.rect_position = (get_viewport().size - pause_message_label.rect_size) / 2

func stop_all_tweens():
	if countdown_tween and countdown_tween.is_active():
		countdown_tween.stop_all()
		countdown_tween.queue_free()
		countdown_tween = null
	
	if pause_tween and pause_tween.is_active():
		pause_tween.stop_all()
		pause_tween.queue_free()
		pause_tween = null
