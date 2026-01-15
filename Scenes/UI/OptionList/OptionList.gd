extends VBoxContainer
class_name OptionList

# Signals
signal option_activated(option_id)
signal value_changed(option_id, new_value)
signal navigation_changed(option_index)

export(bool) var wrap_around = true
export(bool) var horizontal_navigation = false  # For character select grid

var options = []
var current_index = 0
var is_active = true

#onready var selection_sound = $SelectionSound  # Future

func _ready():
	# Find all MenuOptionButton children
	for child in get_children():
		if child is MenuOptionButton:
			options.append(child)
			child.set_selected(false)
	
	# Connect signals
	for i in range(options.size()):
		var option = options[i]
		option.connect("option_activated", self, "_on_option_activated")
		option.connect("value_changed", self, "_on_value_changed")
	
	# Set initial selection
	if options.size() > 0:
		select_option(0)

func select_option(index: int):
	if index < 0 or index >= options.size():
		return
	
	# Deselect current
	if current_index  >= 0:
		options[current_index].set_selected(false)
	
	# Select new
	current_index = index
	options[current_index].set_selected(true)
	
	emit_signal("navigation_changed", current_index)

func activate_current():
	if options.size() > 0:
		options[current_index].activate()

func navigate(direction: Vector2):
	if not is_active:
		return
	
	var old_index = current_index
	
	if direction.y != 0:  # Up/down
		var new_index = current_index + direction.y
		if wrap_around:
			new_index = wrapi(new_index, 0, options.size())
		else:
			new_index = clamp(new_index, 0, options.size() - 1)
		
		if new_index != current_index:
			select_option(new_index)
	
	elif direction.x != 0:  # Left/right
		# Pass to current option for value changes
		var handled = options[current_index].handle_left_right(direction.x)
		if not handled and horizontal_navigation:
			# Horizontal navigation for grid layouts
			var new_index = current_index + direction.x
			if wrap_around:
				new_index = wrapi(new_index, 0, options.size())
			else:
				new_index = clamp(new_index, 0, options.size() - 1)
			
			if new_index != current_index:
				select_option(new_index)

func _on_option_activated(option_id):
	emit_signal("option_activated", option_id)

func _on_value_changed(new_value):
	emit_signal("value_changed", options[current_index].option_id, new_value)

# Public API
func enable():
	is_active = true
	if options.size() > 0:
		select_option(current_index)

func disable():
	is_active = false
	for option in options:
		option.set_selected(false)

func add_option(option_scene: PackedScene, text: String, id: String = ""):
	var new_option = option_scene.instance() as MenuOptionButton
	new_option.display_text = text
	new_option.option_id = id if id != "" else text.to_lower().replace(" ", "_")
	add_child(new_option)
	options.append(new_option)
	
	# Connect signals
	new_option.connect("option_activated", self, "_on_option_activated")
	new_option.connect("value_changed", self, "_on_value_changed")
