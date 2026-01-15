extends Node

func _ready():
	randomize()
	# Set the target base resolution
	var base_width = 320
	var base_height = 180
	
	# Configure the stretch
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_VIEWPORT,
		SceneTree.STRETCH_ASPECT_KEEP,
		Vector2(base_width, base_height)
	)
	
	# Optionally set window size
	OS.window_size = Vector2(base_width * 2, base_height * 2)
	
	# Force viewport update
#	get_viewport().size = Vector2(base_width, base_height)
	
#	print("Resolution set to: ", base_width, "x", base_height)
#	print("Viewport is now: ", get_viewport().size)
