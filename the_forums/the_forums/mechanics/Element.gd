# Element.gd
extends Control

# Get the Mouse script if it's an Autoload, otherwise you need to reference the Mouse node.
# Assuming 'Mouse' is an Autoload for easy global access.

# Exports are correct
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
	mouse_filter = Control.MOUSE_FILTER_PASS

# This function should be connected to the 'mouse_entered' signal of the child ColorRect.
func _on_color_rect_mouse_entered() -> void:
	# Use Mouse.get_mode() to check the current tool
	match Mouse.get_mode():
		Mouse.Mode.HAND:
			if draggable:
				Input.set_default_cursor_shape(Input.CURSOR_DRAG)
		Mouse.Mode.HAMMER:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		Mouse.Mode.PLIERS:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		Mouse.Mode.SCISSORS:
			Input.set_default_cursor_shape(Input.CURSOR_CROSS)
		# Note: Enum is STAPLERS, not STAPLER
		Mouse.Mode.STAPLERS:
			Input.set_default_cursor_shape(Input.CURSOR_CAN_DROP if is_cut_piece else Input.CURSOR_FORBIDDEN)
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
			
			Mouse.Mode.HAMMER:
				z_index += z_step
				get_viewport().set_input_as_handled()
			
			Mouse.Mode.PLIERS:
				z_index = max(z_index - z_step, 0)
				get_viewport().set_input_as_handled()
			
			# --- SCISSORS ---
			Mouse.Mode.SCISSORS:
				# You can't cut a fragment again
				# if !is_cut_piece: 
					# local_to_map is not a standard Control method. 
					# Assuming you meant map_global_position_to_local for 'cut_local_x'.
					# Or simply event.position if you are cutting at the click point.
<<<<<<< HEAD
					var cut_local_x: float = get_local_mouse_position().x
					_split_self(cut_local_x)
=======
					# var cut_local_x: float = map_global_position_to_local(get_global_mouse_position()).x
					# _split_self(cut_local_x)
>>>>>>> f557ea6 (Dragging works, power selection works)
				get_viewport().set_input_as_handled()

			# --- STAPLER ---
			Mouse.Mode.STAPLERS:
				# Only fragments can be stapled
				if is_cut_piece: 
					_request_staple()
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


# create two thin slices and queue-free the original
func _split_self(cut_local_x: float) -> void:
	var parent = get_parent()
	var full = size.x

	# --- Left Half ---
	var left: Control = duplicate() as Control # Type cast to Control
	left.position = position
	left.size.x = cut_local_x
	left.is_cut_piece = true
	left.draggable = true
	parent.add_child(left)

	# --- Right Half ---
	var right: Control = duplicate() as Control # Type cast to Control
	# Right half starts at the original position + the width of the left piece
	right.position = position + Vector2(cut_local_x, 0)
	right.size.x = full - cut_local_x
	right.is_cut_piece = true
	right.draggable = true
	parent.add_child(right)

	# --- Optional Pretty Line ---
	var line = Line2D.new()
	# Line's points should be local to the new parent (the main canvas) if we add it directly
	line.position = position 
	line.points = PackedVector2Array([Vector2(cut_local_x, 0), Vector2(cut_local_x, size.y)])
	line.width = 2
	line.default_color = Color.RED
	parent.add_child(line)

	queue_free()

# ask the StaplerManager (see below) to do the ray-cast/host check
# Assuming StaplerManager is another Autoload/Global class
func _request_staple() -> void:
<<<<<<< HEAD
	Stapler.try_staple(self)
=======
	# StaplerManager.try_staple(self)
	pass
>>>>>>> f557ea6 (Dragging works, power selection works)

# another Element (or the Page itself) accepts a cut fragment
func accept_staple(piece: Control) -> void:
	piece._host = self
	piece.reparent(self) # sticks to us from now on
	# localise coords: new_position = old_global_position - new_parent_global_position
	piece.position = piece.global_position - global_position 
	piece.draggable = false # glued – drag the host instead
