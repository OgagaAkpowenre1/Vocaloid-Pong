extends MenuOptionButton

onready var left_arrow = $HBoxContainer/LeftArrow
onready var right_arrow = $HBoxContainer/RightArrow
onready var value_label = $HBoxContainer/ValueLabel

func _ready():
	# Override parent initialization
	is_value_changer = true
	update_display()

func update_display():
	value_label.text = "First to %d" % current_value

func change_value(delta: int):
	.change_value(delta)  # Call parent
	update_display()
	
	# Animate arrows
	if delta < 0:
		pulse_arrow(left_arrow)
	else:
		pulse_arrow(right_arrow)

func pulse_arrow(arrow):
	pass
#	if $AnimationPlayer:
#		$AnimationPlayer.play("arrow_pulse")

# Future: Add visual feedback when min/max reached
func is_at_min():
	return current_value == min_value

func is_at_max():
	return current_value == max_value
