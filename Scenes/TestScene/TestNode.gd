extends Node2D

func _ready():
	# Test 1: Print current sizes
	print("=== GODOT 3 RESOLUTION TEST ===")
	print("Viewport size: ", get_viewport().size)
	print("Screen size: ", OS.get_screen_size())
	print("Window size: ", OS.window_size)
	
	# Test 2: Create full-screen colored quad
	var quad = ColorRect.new()
	quad.color = Color(0, 0.5, 1, 0.3)  # Blue tint
	quad.rect_size = Vector2(320, 180)
	quad.rect_position = Vector2(0, 0)
	add_child(quad)
	
	# Test 3: Add border markers
	for i in range(4):
		var marker = ColorRect.new()
		marker.color = Color.red
		marker.rect_size = Vector2(4, 4)
		
		match i:
			0: marker.rect_position = Vector2(0, 0)        # Top-left
			1: marker.rect_position = Vector2(316, 0)      # Top-right
			2: marker.rect_position = Vector2(0, 176)      # Bottom-left
			3: marker.rect_position = Vector2(316, 176)    # Bottom-right
		
		add_child(marker)
