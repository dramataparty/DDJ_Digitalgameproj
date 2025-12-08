
extends Node

# Use "Mouse" as the prefix for enum values if this is an Autoload
# If not an Autoload, simply use the enum name. Assuming Autoload.
enum Mode { 
	NORMAL, 
	HAND, 
	HAMMER, 
	PLIERS, 
	SCISSORS, 
	STAPLERS
}

# The signal signature is correct.
signal mode_changed(new_mode: Mode)

# Var with a setter function is correct.
var _mode: Mode = Mode.NORMAL : set = set_mode

func set_mode(m: Mode) -> void:
	if _mode == m:
		return
	_mode = m
	mode_changed.emit(m)

func get_mode() -> Mode:
	return _mode

# This function is the signal receiver for when the mode changes.
# It should be connected to the 'mode_changed' signal.
#func _on_mode_changed(new_mode: Mode) -> void:
	# Set a default cursor texture
	#var t: Texture2D = preload("res://assets/arrow.png") 
	
	# Enum values are accessed via Mode.<VALUE>
	#match new_mode:
		#Mode.SCISSORS:
			#t = preload("res://assets/scissors.png")
		#Mode.STAPLERS: # Note: Enum is STAPLERS, not STAPLER (typo in original)
			#t = preload("res://assets/stapler.png")
	 #   Mode.HAND:
			# You might want a custom hand texture here
	  #      t = preload("res://assets/hand.png") 
		# Add more cases for other modes if needed, otherwise the default (arrow.png) is used.
	 #   _:
	   #     pass # Keep the default arrow.png

	# Use CURSOR_ARROW as the fallback for a custom cursor
	#Input.set_custom_mouse_cursor(t, Input.CURSOR_ARROW)
