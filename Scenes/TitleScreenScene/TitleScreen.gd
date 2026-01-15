extends Control

onready var option_list = $CenterContainer/VBoxContainer/OptionList

func _ready():
	# Initialize option list
	var option_scene = preload("res://Scenes/UI/OptionButton/OptionButton.tscn")
	var max_score_scene = preload("res://Scenes/UI/MaxScoreButton/MaxScoreButton.tscn")
	
	# Clear default children
	for child in option_list.get_children():
		child.queue_free()
	
	# Add options
	option_list.add_option(max_score_scene, "Max Score: ", "max_score")
	option_list.add_option(option_scene, "Start Game", "start")
	option_list.add_option(option_scene, "Quit", "quit")
	
	# Connect signals
	option_list.connect("option_activated", self, "_on_option_activated")
	option_list.connect("value_changed", self, "_on_value_changed")
	
	# Register with navigation manager
	NavigationManager.register_menu(option_list)

func _input(event):
	if event.is_action_pressed("up"):
		NavigationManager.navigate(Vector2(0, -1))
	elif event.is_action_pressed("down"):
		NavigationManager.navigate(Vector2(0, 1))
	elif event.is_action_pressed("left"):
		NavigationManager.navigate(Vector2(-1, 0))
	elif event.is_action_pressed("right"):
		NavigationManager.navigate(Vector2(1, 0))
	elif event.is_action_pressed("special-btn"):  # Z key
		NavigationManager.activate()
	elif event.is_action_pressed("cancel-btn"):  # X key for back
		NavigationManager.go_back()

func _on_option_activated(option_id):
	match option_id:
		"max_score":
			# Already handled by value_changed
			pass
		"start":
			start_game()
		"quit":
			get_tree().quit()

func _on_value_changed(option_id, new_value):
	if option_id == "max_score":
		GlobalSettings.max_score = new_value
		print("Max score set to: ", new_value)

func start_game():
	print("starting game")
	# Store settings
	GlobalSettings.save_settings()
	
	# Change scene (with transition in future)
	SceneManager.change_scene("res://Scenes/TestScene/TestScene.tscn", "fade")
