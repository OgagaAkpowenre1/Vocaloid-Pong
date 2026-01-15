extends Control

onready var option_list = $VBoxContainer/OptionList

func _ready():
	var option_scene = preload("res://Scenes/UI/OptionButton/OptionButton.tscn")
	
	# Clear and add options
	for child in option_list.get_children():
		child.queue_free()
	
	option_list.add_option(option_scene, "Play Again", "replay")
	option_list.add_option(option_scene, "Return to Title", "title")
	option_list.add_option(option_scene, "Quit", "quit")
	
	option_list.connect("option_activated", self, "_on_option_activated")
	NavigationManager.register_menu(option_list)

func _on_option_activated(option_id):
	match option_id:
		"replay":
			SceneManager.change_scene("res://Scenes/TestScene/TestScene.tscn")
		"title":
			SceneManager.change_scene("res://Scenes/TitleScreenScene/TitleScreen.tscn")
		"quit":
			get_tree().quit()

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
