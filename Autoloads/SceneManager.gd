extends Node

var current_scene = null
var transition_node = null

func _ready():
	current_scene = get_tree().current_scene

func change_scene(path: String, transition_type: String = "none"):
	# Future: Add transitions
	# For now, simple scene change
	get_tree().change_scene(path)
	
	# Call deferred to ensure scene is loaded
	call_deferred("_update_current_scene")

func _update_current_scene():
	current_scene = get_tree().current_scene

# Future transition methods
func fade_out():
	pass

func fade_in():
	pass

func slide_transition():
	pass
