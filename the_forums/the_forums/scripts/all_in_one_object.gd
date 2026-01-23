extends Sprite2D

## ---- Exported Properties ----
@export var item_id: String = ""
@export var spriteinactive: Texture2D
@export var spriteactive: Texture2D

signal stapled_to(other: Sprite2D)
@export var min_z_index := -5
@export var max_z_index := 5
@export var z_step := 1

var is_split := false
@export var item_connection_point: Node2D

## ---- State ----
var dragging := false
var drag_offset := Vector2.ZERO
var potential_target: Sprite2D = null
var can_staple := false
var staple_lock := false


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
func _input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	
	if not get_rect().has_point(to_local(event.position)):
		return

	match Mouse.get_mode():
		Mouse.Mode.HAND:
			_handle_drag_input(event)
		Mouse.Mode.HAMMER_PLIERS:
			_handle_hammer_input(event)
		Mouse.Mode.SCISSORS:
			_handle_scissors_input(event)


## =========================================================
## DRAG MODE
## =========================================================
func _handle_drag_input(event: InputEventMouseButton):
	if event.button_index != MOUSE_BUTTON_LEFT:
		return

	if event.pressed:
		dragging = true
		can_staple = true
		drag_offset = global_position - event.position
	else:
		dragging = false
		can_staple = false


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
## SCISSORS MODE (on clicking the object, split it into two smaller objects down the middle, each should look like the right/left half of the original, their creation should be logged in command line for better use)
## =========================================================

func _handle_scissors_input(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_cut_item()
		get_viewport().set_input_as_handled()

func _cut_item():
	# make resulting item id be the itemid of the original + rh or lh depending on the half
	# --- block reattach for one frame ---
	staple_lock = true
	await get_tree().process_frame
	staple_lock = false
	
	# --- safety guards ---
	if is_split:
		return
	is_split = true   
	if not texture:
		return

	var parent := get_parent()
	if not parent:
		return

	var tex_size := texture.get_size()
	if tex_size.x < 2:
		return

	# --- duplicate ---
	var new_half = duplicate(7)
	new_half.init_child_nodes()
	new_half.name = name + "_half"
	item_id += "_lh"
	new_half.item_id = item_id.replace("_lh", "_rh")


	# --- spacing ---
	# --- calculate cut ---
	var left_w := tex_size.x / 2
	var right_w := tex_size.x - left_w
	parent.add_child(new_half)
	var gap := left_w/2
	var dir := Vector2.RIGHT.rotated(global_rotation)

	var center := global_position

	global_position = center - dir * (gap * 0.5)
	new_half.global_position = center + dir * (gap * 0.5)



	

	# --- Left crop (this) ---
	texture = _crop_texture(texture, Rect2i(0, 0, left_w, tex_size.y))

	if spriteinactive:
		spriteinactive = _crop_texture(spriteinactive, Rect2i(0, 0, left_w, spriteinactive.get_size().y))
	if spriteactive:
		spriteactive = _crop_texture(spriteactive, Rect2i(0, 0, left_w, spriteactive.get_size().y))

	_resize_collision_to_texture()
	is_split = true

	# --- Right crop (new) ---
	new_half.texture = _crop_texture(new_half.texture, Rect2i(left_w, 0, right_w, tex_size.y))

	if new_half.spriteinactive:
		new_half.spriteinactive = _crop_texture(new_half.spriteinactive, Rect2i(left_w, 0, right_w, new_half.spriteinactive.get_size().y))
	if new_half.spriteactive:
		new_half.spriteactive = _crop_texture(new_half.spriteactive, Rect2i(left_w, 0, right_w, new_half.spriteactive.get_size().y))

	new_half._resize_collision_to_texture()
	new_half.is_split = true


	var puzzle = get_tree().get_first_node_in_group("puzzle")
	if puzzle:
		new_half.stapled_to.connect(puzzle._on_card_stapled.bind(new_half))
		stapled_to.connect(puzzle._on_card_stapled.bind(self))



	# --- debug ---
	print("CUT:", item_id, "→", name, "and", new_half.name)
	print(" Left size:", texture.get_size(), " Right size:", new_half.texture.get_size())



func init_child_nodes():
	if has_node("Area2D"):
		var area := $Area2D
		if not area.area_entered.is_connected(_on_area_entered):
			area.area_entered.connect(_on_area_entered)
		if not area.area_exited.is_connected(_on_area_exited):
			area.area_exited.connect(_on_area_exited)

	if has_node("Area2D/CollisionShape2D"):
		$Area2D/CollisionShape2D.shape = $Area2D/CollisionShape2D.shape.duplicate()

	if texture:
		texture = texture.duplicate()
	if spriteinactive:
		spriteinactive = spriteinactive.duplicate()
	if spriteactive:
		spriteactive = spriteactive.duplicate()

	return self



func _crop_right():
	if not texture:
		return

	var size = texture.get_size()
	var half_w := int((texture.get_size().x + 1) / 2)  # Consistent calc
	texture = _crop_texture(texture, Rect2i(texture.get_size().x - half_w, 0, half_w, size.y))

	if spriteinactive:
		spriteinactive = _crop_texture(spriteinactive, Rect2i(half_w, 0, half_w, spriteinactive.get_size().y))

	if spriteactive:
		spriteactive = _crop_texture(spriteactive, Rect2i(half_w, 0, half_w, spriteactive.get_size().y))

	_resize_collision_to_texture()


func _crop_texture(tex: Texture2D, region: Rect2i) -> Texture2D:
	var src: Image = tex.get_image()
	var dst := Image.create(region.size.x, region.size.y, false, src.get_format())
	dst.blit_rect(src, region, Vector2i.ZERO)
	return ImageTexture.create_from_image(dst)


func _resize_collision_to_texture():
	if has_node("Area2D/CollisionShape2D") and $Area2D/CollisionShape2D.shape is RectangleShape2D:
		var shape := $Area2D/CollisionShape2D.shape as RectangleShape2D
		if texture:
			shape.size = texture.get_size()




## =========================================================
## STAPLING/Attaching items to eachother (automatically happens on drag if the object was created via a cut)
## =========================================================
func _on_area_entered(area: Area2D) -> void:
	if staple_lock:
		return

	var other := area.get_parent()

	if other == self:
		return

	# Must be Sprite2D and running this script
	if not other is Sprite2D:
		return

	# Must actually have is_split property
	#if not other.has_variable("is_split"):
	#	return

	potential_target = other

	if can_staple and dragging and is_split and other.is_split:
		_attach_item(other)





func _on_area_exited(area):
	if potential_target == area.get_parent():
		potential_target = null


var _is_attaching := false


#make sure attached items retain their individual Z index
func _attach_item(other: Sprite2D) -> void:
	if _is_attaching:
		return
	_is_attaching = true

	# Prevent attaching to self or creating loops
	if other == self or other.is_ancestor_of(self):
		_is_attaching = false
		return

	# Already attached
	if other.get_parent() == self:
		_is_attaching = false
		return

	# Store original global position and z_index
	var gpos := other.global_position
	var original_z := other.z_index

	# Reparent
	other.reparent(self)
	other.global_position = gpos

	# Optional: move to connection point if it exists
	if item_connection_point:
		other.global_position = item_connection_point.global_position

	# Restore original Z index so it doesn't inherit parent
	other.z_index = original_z

	emit_signal("stapled_to", other)

	print("Stapled:", item_id, "→", other.item_id)

	_is_attaching = false



func get_global_rect() -> Rect2:
	if not texture:
		return Rect2(global_position, Vector2.ZERO)

	var size := texture.get_size() * scale
	var origin := global_position - size * 0.5
	return Rect2(origin, size)
