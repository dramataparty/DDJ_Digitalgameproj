extends Control

@export var is_cut_piece := false # created by scissors
@export var draggable := true
@export var z_step := 10
var _dragging := false
var _drag_start: Vector2
var _original_pos: Vector2
var _host: Control = null # set after stapling

func _ready() -> void:
	# make sure we have a minimum size so the player can grab it
	if size.x < 20 or size.y < 20:
		size = Vector2(60, 40)
	# Allows the control to pass mouse events down if not handled
	mouse_filter = Control.MOUSE_FILTER_STOP

# This function should be connected to the 'mouse_entered' signal of the child ColorRect.
func _on_color_rect_mouse_entered() -> void:
	# Use Mouse.get_mode() to check the current tool
	match Mouse.get_mode():
		Mouse.Mode.HAND:
			if draggable:
				Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		Mouse.Mode.HAMMER_PLIERS:
			Input.set_default_cursor_shape()
		Mouse.Mode.SCISSORS_STAPLERS:
			Input.set_default_cursor_shape()
		_: # Default case for other modes (e.g., NORMAL)
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# This function should be connected to the 'mouse_exited' signal of the child ColorRect.
func _on_color_rect_mouse_exited() -> void:
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

# Handles input events on this Control node.
func _gui_input(event: InputEvent) -> void:
	# Check for mouse button press (left click by default)
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		match Mouse.get_mode():
			Mouse.Mode.HAND:
				if draggable:
					_dragging = true
					# Use event.position for local drag start
					_drag_start = event.position 
					_original_pos = position
					get_viewport().set_input_as_handled()
					
	# Handle mouse movement while dragging
	elif _dragging and event is InputEventMouseMotion:
		# Use event.relative for simpler drag calculation, 
		# but the original logic is trying to calculate position based on global start/end points.
		# Fixed the position calculation (no need to multiply by scale unless the viewport is scaled).
		position = _original_pos + (event.global_position - _drag_start - _original_pos) 
		# A simpler way is: position += event.relative - but we'll stick closer to your original intent.
		
		# Corrected calculation (assuming event.position is local to the Control on click, 
		# and event.global_position is the current cursor position):
		position = get_parent().global_position + (event.global_position - _drag_start)
		
		get_viewport().set_input_as_handled()

	# Handle mouse button release to stop dragging
	elif _dragging and event is InputEventMouseButton and !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_dragging = false
		get_viewport().set_input_as_handled()

# another Element (or the Page itself) accepts a cut fragment
func accept_staple(piece: Control) -> void:
	piece._host = self
	piece.reparent(self) # sticks to us from now on
	# localise coords: new_position = old_global_position - new_parent_global_position
	piece.position = piece.global_position - global_position 
	piece.draggable = false # glued – drag the host instead
