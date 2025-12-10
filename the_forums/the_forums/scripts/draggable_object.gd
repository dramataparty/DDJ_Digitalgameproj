extends Sprite2D

var dragging := false
var drag_offset := Vector2.ZERO

@export var item_id: String = ""

@export var spriteinactive: CompressedTexture2D
@export var spriteactive: CompressedTexture2D

func get_id():
	return item_id

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and Mouse.get_mode() == Mouse.Mode.HAND:
			# Start dragging if clicked on the sprite
			if event.pressed and get_rect().has_point(to_local(event.position)):
				dragging = true
				drag_offset = global_position - event.position
			# Stop dragging
			elif not event.pressed:
				dragging = false

func _process(delta):
	if dragging:
		global_position = get_viewport().get_mouse_position() + drag_offset
