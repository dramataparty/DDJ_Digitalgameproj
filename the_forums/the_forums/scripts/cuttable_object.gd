extends Sprite2D


@export var is_split: bool = false # Tracks if the item is already split
@export var item_connection_point: Node2D # A child Node2D used as the attach/staple point

signal item_split(new_half: Sprite2D)
signal item_attached(other_item: Sprite2D)

var potential_target: Sprite2D = null

func _ready():
	
	if not get_node_or_null("item_connection_point"):
		print_debug("WARNING: item_connection_point not found on ", name)

func _input(event):
	
	if Mouse.get_mode() != Mouse.Mode.SCISSORS_STAPLERS:
		return

	
	if not get_rect().has_point(to_local(event.position)):
		return

	
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		if not is_split:
			_split_item()
		get_viewport().set_input_as_handled()

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if potential_target:
			_attach_item(potential_target)
		
		else:
			_select_for_attachment()
		get_viewport().set_input_as_handled()


func _split_item():
	# This is a conceptual implementation. 
	# Real implementation requires duplicating the item and resizing/repositioning textures.
	
	# 1. Create a new instance of the current scene/item (the second half)
	var new_half = duplicate()
	
	# 2. Adjust properties for both halves (e.g., set new textures, update size/position)
	# This highly depends on how your sprites are set up (e.g., is it a single image or composed of children?)
	
	# Example: Simple separation (conceptual)
	new_half.global_position = global_position + Vector2(texture.get_width() / 2, 0)
	global_position -= Vector2(texture.get_width() / 2, 0)

	# 3. Add the new half to the scene tree
	get_parent().add_child(new_half)
	
	is_split = true
	new_half.is_split = true # Both are now halves
	item_split.emit(new_half)
	print("Item ", get("item_id"), " split successfully.")

func _select_for_attachment():
	# Simple selection: highlight the item and wait for a second click
	# This involves visual feedback (e.g., change modulation color)
	print("Item ", get("item_id"), " selected for stapling. Click a target item now.")

	# A more robust system would involve a global 'StapleManager'
	# For now, let's assume we use a global variable on the Mouse manager to track the first selected item
	# e.g., Mouse.set_first_staple_item(self)

func _attach_item(target: Sprite2D):
	# 1. Create a physical joint/connection
	# For a physics-based item, you'd use a PinJoint2D or another constraint.
	# For simple graphical elements, you could make one item a child of the other, 
	# or use a `RemoteTransform2D`.
	
	# Example: Simple parenting
	if target.get_parent() != self:
		target.reparent(self) # Target becomes a child of this item

		# Reposition the target to the connection point
		if item_connection_point:
			target.global_position = item_connection_point.global_position
	
	item_attached.emit(target)
	print("Item ", get("item_id"), " stapled to ", target.get("item_id"))

# --- Detection/Area Logic ---

# Use Area2D signals to detect nearby potential targets for the stapler
func _on_area_entered(area):
	# Check if the entered area belongs to another item
	if area.get_parent() is Sprite2D and area.get_parent() != self:
		potential_target = area.get_parent()
		# Optional: Add visual feedback that it can be stapled (e.g., pulsing glow)

func _on_area_exited(area):
	if area.get_parent() == potential_target:
		potential_target = null
		# Optional: Remove visual feedback
