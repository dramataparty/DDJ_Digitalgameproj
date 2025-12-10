# StaplerManager.gd
extends Node

const STAPLE_CHECK_DISTANCE := 10.0 # Max distance to find a potential connection point
const ATTACH_FORCE := 100.0          # Used if items are physics bodies

var first_item: Sprite2D = null # The item selected first (the source)
var is_active: bool = false     # Flag to ensure actions only happen in the correct mode

# --- Initialization ---

func _ready():
	# Assuming your Mouse mode manager is also an Autoload named 'Mouse'
	if is_instance_valid(Mouse):
		Mouse.mode_changed.connect(_on_mouse_mode_changed)
		is_active = (Mouse.get_mode() == Mouse.Mode.SCISSORS_STAPLERS)

func _on_mouse_mode_changed(new_mode: Mouse.Mode):
	is_active = (new_mode == Mouse.Mode.SCISSORS_STAPLERS)
	
	# If the mode is deactivated, reset the selection state
	if not is_active:
		_reset_selection()

# --- Public Interface for Item Scripts ---

# Item scripts call this when they are left-clicked in STAPLERS mode
func handle_item_click(item: Sprite2D):
	if not is_active:
		return

	if first_item == null:
		# STEP 1: Select the source item
		_select_first_item(item)
	elif first_item == item:
		# Clicking the same item again deselects it
		_reset_selection()
	else:
		# STEP 2: Find and attach to a target
		_attempt_to_attach(item)

# --- Core Logic ---

func _select_first_item(item: Sprite2D):
	first_item = item
	# Optional: Apply visual feedback (e.g., green tint) to 'first_item'
	if item.has_method("apply_highlight"):
		item.apply_highlight(Color.GREEN)
	
	print("StaplerManager: Selected source item ", item.name)

func _reset_selection():
	if first_item and is_instance_valid(first_item):
		# Optional: Remove visual feedback from 'first_item'
		if first_item.has_method("remove_highlight"):
			first_item.remove_highlight()
			
	first_item = null
	print("StaplerManager: Selection reset.")

func _attempt_to_attach(target_item: Sprite2D):
	# Check if the target is close enough to the source
	if first_item.global_position.distance_to(target_item.global_position) <= STAPLE_CHECK_DISTANCE:
		# Perform the actual attachment
		_staple_items(first_item, target_item)
	else:
		print("StaplerManager: Target too far. Resetting selection.")
		_reset_selection()

func _staple_items(source: Sprite2D, target: Sprite2D):
	print("StaplerManager: STAPLING ", source.name, " to ", target.name)
	
	# --- Attachment Logic ---
	
	# Best practice for graphical attachment: use `RemoteTransform2D` or reparenting
	# Best practice for physics attachment: use a `PinJoint2D` or `FixedJoint2D`
	
	# For a simple, non-physics connection (attaching B to A):
	if target.get_parent() != source:
		# Save old parent reference if needed for unstapling
		
		# Reparent the target under the source
		target.reparent(source)
		
		# Position the target relative to the source
		# You might want to offset it by half its width or another connection point
		var relative_offset = source.to_local(target.global_position)
		target.position = relative_offset 

	# --- Cleanup ---
	
	# Notify items they have been attached (optional)
	if source.has_method("on_attached"):
		source.on_attached(target)
	
	_reset_selection()
	print("StaplerManager: Stapling complete.")
