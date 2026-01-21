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
var potential_target: Sprite2D = null


## =========================================================
## READY
## =========================================================
func _ready():
	if has_node("Area2D"):
		$Area2D.area_entered.connect(_on_area_entered)
		$Area2D.area_exited.connect(_on_area_exited)


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
## DRAG MODE
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
## HAMMER MODE
## =========================================================
func _handle_hammer_input(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT:
		_change_z(-z_step)
	elif event.button_index == MOUSE_BUTTON_RIGHT:
		_change_z(z_step)

	get_viewport().set_input_as_handled()


func _change_z(amount: int):
	z_index = clamp(z_index + amount, min_z_index, max_z_index)
	print("Item", item_id, "Z:", z_index)


## =========================================================
## SCISSORS MODE
## =========================================================
var cut_start: Vector2
var cut_end: Vector2
var is_cutting := false


func _handle_scissors_input(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_cutting = true
			cut_start = get_global_mouse_position()
		else:
			if is_cutting:
				is_cutting = false
				cut_end = get_global_mouse_position()
				_cut_item()


func _cut_item():
	if cut_start == cut_end:
		return

	var shape := $Area2D/CollisionShape2D.shape
	if not (shape is ConvexPolygonShape2D):
		return

	var local_start = to_local(cut_start)
	var local_end = to_local(cut_end)

	var orig_points: PackedVector2Array = shape.points

	var poly_a := PackedVector2Array()
	var poly_b := PackedVector2Array()

	if not _split_polygon_with_segment(orig_points, local_start, local_end, poly_a, poly_b):
		return

	var slice_a := _create_slice(poly_a)
	var slice_b := _create_slice(poly_b)

	var dir := (cut_end - cut_start).normalized()
	slice_a.position += dir * 4
	slice_b.position -= dir * 4

	queue_free()


func _create_slice(points: PackedVector2Array) -> Sprite2D:
	if points.size() < 3:
		return null

	var slice := duplicate() as Sprite2D
	slice.name = name + "_slice"
	slice.is_split = true

	var col_shape := slice.get_node("Area2D/CollisionShape2D") as CollisionShape2D
	var new_shape := ConvexPolygonShape2D.new()
	new_shape.points = points
	col_shape.shape = new_shape

	get_parent().add_child(slice)
	return slice


## =========================================================
## POLYGON SPLIT
## =========================================================
func _split_polygon_with_segment(
	points: PackedVector2Array,
	s: Vector2, e: Vector2,
	out_a: PackedVector2Array,
	out_b: PackedVector2Array
) -> bool:
	out_a.clear()
	out_b.clear()

	var dir := (e - s).normalized()

	for i in range(points.size()):
		var p1 := points[i]
		var p2 := points[(i + 1) % points.size()]

		var side1 := sign(dir.cross(p1 - s))
		var side2 := sign(dir.cross(p2 - s))

		if side1 >= 0:
			out_a.append(p1)
		if side1 <= 0:
			out_b.append(p1)

		if side1 * side2 < 0:
			var hit := Geometry2D.segment_intersects_segment(s, e, p1, p2)
			if hit != null:
				out_a.append(hit)
				out_b.append(hit)

	return out_a.size() >= 3 and out_b.size() >= 3


## =========================================================
## STAPLING
## =========================================================
func _on_area_entered(area):
	if area.get_parent() is Sprite2D and area.get_parent() != self:
		potential_target = area.get_parent()
		if is_split and potential_target.is_split:
			_attach_item(potential_target)


func _on_area_exited(area):
	if potential_target == area.get_parent():
		potential_target = null


func _attach_item(other: Sprite2D):
	if other.get_parent() == self:
		return

	other.reparent(self)
	if item_connection_point:
		other.global_position = item_connection_point.global_position

	print("Stapled:", item_id, "→", other.item_id)
