extends Node

var max_score = 3
var selected_character = "miku"
var game_mode = "free_play"

func save_settings():
	var save_data = {
		"max_score": max_score,
		"selected_character": selected_character
	}
	# Save to file or keep in memory
	return save_data

func load_settings():
	# Load from file
	pass
