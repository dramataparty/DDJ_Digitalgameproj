extends Control
@export var draggable := true
@export var z_step := 10   # how far it jumps per hammer/pliers click

var _dragging := false
var _drag_start : Vector2
var _original_pos : Vector2

func _ready():
	# make sure we have a minimum size so the player can grab it
	if size.x < 20 or size.y < 20:
		size = Vector2(60,40)
	mouse_filter = Control.MOUSE_FILTER_PASS

func _on_color_rect_mouse_entered():
	var shape := -1
	match Mouse.get_mode():
		Mouse.Mode.HAND:   shape = Control.CURSOR_DRAG if draggable else Control.CURSOR_ARROW
		Mouse.Mode.HAMMER: shape = Control.CURSOR_POINTING_HAND
		Mouse.Mode.PLIERS: shape = Control.CURSOR_POINTING_HAND
		_:                 shape = Control.CURSOR_ARROW
	add_theme_constant_override("mouse_default_cursor_shape", shape)

func _on_color_rect_mouse_exited():
	add_theme_constant_override("mouse_default_cursor_shape", Control.CURSOR_ARROW)

func _gui_input(event : InputEvent):
	if event is InputEventMouseButton and event.pressed:
		match Mouse.get_mode():
			Mouse.Mode.HAND:
				if draggable:
					_dragging = true
					_drag_start = event.position
					_original_pos = position
					get_viewport().set_input_as_handled()
			Mouse.Mode.HAMMER:
				z_index += z_step
				get_viewport().set_input_as_handled()
			Mouse.Mode.PLIERS:
				z_index = max(z_index - z_step, 0)
				get_viewport().set_input_as_handled()

	if _dragging and event is InputEventMouseMotion:
		position = _original_pos + (event.global_position - _drag_start * get_global_transform().get_scale())
		get_viewport().set_input_as_handled()

	if _dragging and event is InputEventMouseButton and !event.pressed:
		_dragging = false
		get_viewport().set_input_as_handled()
