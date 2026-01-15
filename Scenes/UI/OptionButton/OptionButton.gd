extends TextureButton
class_name MenuOptionButton

# Signals
signal option_selected
signal option_activated
signal value_changed(new_value)  # For max score type

export(String) var option_id = ""  # Unique identifier
export(String) var display_text = ""  # Text to show
export(bool) var is_selectable = true  # Can be selected
export(bool) var is_action_button = true  # Can be activated
export(bool) var is_value_changer = false  # For max score type
export(int) var min_value = 1
export(int) var max_value = 10
export(int) var current_value = 3
export(int) var step = 1

var value_labels = []  # For left/right arrows

onready var label_node = $Label

func _ready():
	if display_text != "":
		label_node.text = display_text
	
	# Initialize value display if applicable
	if is_value_changer:
		update_value_display()

func set_selected(selected: bool):
	if $FocusIndicator:
		$FocusIndicator.visible = selected
	modulate = Color(1, 1, 1, 1.0) if selected else Color(1, 1, 1, 0.7)
	
	if selected:
		emit_signal("option_selected")

func activate():
	if is_action_button:
		emit_signal("option_activated", option_id)
		# Future: Play activation animation
#		if $AnimationPlayer:
#			$AnimationPlayer.play("press")

func change_value(delta: int):
	if is_value_changer:
		current_value = clamp(current_value + (delta * step), min_value, max_value)
		update_value_display()
		emit_signal("value_changed", current_value)

func update_value_display():
	if is_value_changer:
		label_node.text = "%s" % [display_text]

# Called by parent OptionList when left/right pressed
func handle_left_right(direction: int):
	if is_value_changer:
		change_value(direction)
		return true  # Handled
	return false  # Not handled
