extends Node

var current_menu = null
var menu_stack = []  # For back navigation

signal menu_changed
signal navigation_sound_requested

func register_menu(menu_node):
	current_menu = menu_node
	emit_signal("menu_changed", menu_node)

func navigate(direction: Vector2):
	if current_menu and current_menu.has_method("navigate"):
		current_menu.navigate(direction)
		emit_signal("navigation_sound_requested", "move")

func activate():
	if current_menu and current_menu.has_method("activate_current"):
		current_menu.activate_current()
		emit_signal("navigation_sound_requested", "select")

func go_back():
	if menu_stack.size() > 0:
		var previous_menu = menu_stack.pop_back()
		if previous_menu and previous_menu.has_method("enable"):
			previous_menu.enable()
			current_menu = previous_menu
			emit_signal("menu_changed", previous_menu)

func push_menu(new_menu):
	if current_menu and current_menu.has_method("disable"):
		current_menu.disable()
		menu_stack.append(current_menu)
	register_menu(new_menu)
