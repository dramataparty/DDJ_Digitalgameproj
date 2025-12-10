extends Sprite2D

## ---- Exported Properties ----
@export var item_id: String = ""
@export var spriteinactive: CompressedTexture2D
@export var spriteactive: CompressedTexture2D

@export var min_z_index := -5
@export var max_z_index := 5
@export var z_step := 1

@export var is_split := false
@export var item_connection_point: Node2D

## ---- State ----
var dragging := false
var drag_offset := Vector2.ZERO

var potential_target: Sprite2D = null     # for stapling


## =========================================================
## INPUT HANDLING
## =========================================================
func _input(event):
	if not event is InputEventMouseButton:
		return
	
	if not get_rect().has_point(to_local(event.position)):
		return

	match Mouse.get_mode():

		Mouse.Mode.HAND:
			_handle_drag_input(event)

		Mouse.Mode.HAMMER_PLIERS:
			_handle_hammer_input(event)

		Mouse.Mode.SCISSORS_STAPLERS:
			_handle_scissors_input(event)


## =========================================================
## DRAG MODE HANDLING
## =========================================================
func _handle_drag_input(event: InputEventMouseButton):
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if event.pressed:
		dragging = true
		drag_offset = global_position - event.position
	else:
		dragging = false


func _process(_delta):
	if dragging:
		global_position = get_viewport().get_mouse_position() + drag_offset


## =========================================================
## HAMMER MODE (Z-ORDER adjustment)
## =========================================================
func _handle_hammer_input(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT:
		_change_z(-z_step)

	elif event.button_index == MOUSE_BUTTON_RIGHT:
		_change_z(z_step)

	get_viewport().set_input_as_handled()


func _change_z(amount: int):
	var new_index = clamp(z_index + amount, min_z_index, max_z_index)
	z_index = new_index
	print("Item", item_id, "Z:", z_index)


## =========================================================
## SCISSORS MODE (Split + Staple)
## =========================================================
func _handle_scissors_input(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if not is_split:
			_split_item()
		get_viewport().set_input_as_handled()

	elif event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if potential_target:
			_attach_item(potential_target)
		else:
			_select_for_attachment()
		get_viewport().set_input_as_handled()


func _split_item():
	var new_half = duplicate()

	# simplistic offsetting
	new_half.global_position = global_position + Vector2(texture.get_width() / 2, 0)
	global_position -= Vector2(texture.get_width() / 2, 0)

	get_parent().add_child(new_half)
	is_split = true
	new_half.is_split = true

	print("Split item:", item_id)


func _select_for_attachment():
	print("Item", item_id, "selected for stapling.")


func _attach_item(other: Sprite2D):
	if other.get_parent() != self:
		other.reparent(self)

		if item_connection_point:
			other.global_position = item_connection_point.global_position

	print("Stapled:", item_id, "→", other.item_id)


## =========================================================
## AREA2D HOOKS FOR STAPLING
## =========================================================
func _on_area_entered(area):
	if area.get_parent() is Sprite2D and area.get_parent() != self:
		potential_target = area.get_parent()


func _on_area_exited(area):
	if potential_target == area.get_parent():
		potential_target = null
