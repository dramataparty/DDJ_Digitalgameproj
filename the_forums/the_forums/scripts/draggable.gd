extends Sprite2D

var dragging := false
var drag_offset := Vector2.ZERO

@export var item_id: String = ""

func _ready():
	self.pickable = true  # IMPORTANT: lets the engine detect clicks on topmost sprite

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_offset = global_position - event.position
			DragState.active_item = self
		else:
			dragging = false
			if DragState.active_item == self:
				DragState.active_item = null

func _process(delta):
	if dragging:
		global_position = get_viewport().get_mouse_position() + drag_offset
