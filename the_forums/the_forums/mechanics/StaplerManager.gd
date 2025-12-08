# StaplerManager.gd
extends Node

# The StaplerManager's sole responsibility is to find a valid "host" 
# to staple the "piece" (cut fragment) to.

# You will need to define the maximum distance for the raycast/host check.
const STAPLE_CHECK_DISTANCE := 10.0 # Distance in pixels to check for a nearby host
# We will use the Mouse global variable for convenience.
# Assuming Mouse.gd (from the previous answer) is also an Autoload.

# Static function to attempt stapling
# piece: The Element Control node (the cut fragment) that is being stapled.
# This function is called by the piece itself via _request_staple().
func try_staple(piece: Control) -> bool:
	# 1. Check if the piece is actually a fragment that can be stapled
	if !piece.is_cut_piece:
		return false

	var global_pos: Vector2 = piece.get_global_mouse_position()
	
	# 2. Find a potential host (another Element or the Page/Container)
	# We will look for an Element near the cursor that is NOT the piece itself.
	# The simplest way to do a "ray-cast" on 2D Controls is to check the viewport 
	# for controls at the mouse position.

	# Get the top-most control at the cursor position
	var potential_host: Control = get_viewport().get_mouse_control()

	# If the mouse is not over any Control, or if the control is the fragment itself, 
	# or if the control is already a fragment (meaning it can't host), skip it.
	if !potential_host or potential_host == piece or potential_host.is_cut_piece:
		# Check nearby elements if the cursor is not exactly on the host.
		# A simple check is to iterate over the parent's children.
		potential_host = _find_nearby_host(piece.get_parent(), global_pos, piece)
		
		if !potential_host:
			# No valid host found.
			return false
	
	# 3. Check if the host is capable of accepting the staple
	# We check if the potential host has the 'accept_staple' method.
	if potential_host.has_method("accept_staple"):
		# Stapling successful! The host handles the reparenting logic.
		potential_host.accept_staple(piece)
		return true
	
	# Not stapled (host doesn't have the required method)
	return false

# Helper function to find a nearby Element host
func _find_nearby_host(parent: Node, global_pos: Vector2, stapling_piece: Control) -> Control:
	# Iterate through all children of the parent (the main canvas/page)
	for child in parent.get_children():
		# Ensure the child is a Control node (like your Element)
		if child is Control:
			var element: Control = child
			
			# Skip the piece being stapled, fragments, and pieces that aren't hosts
			if element == stapling_piece or element.is_cut_piece:
				continue

			# Check for proximity to the cursor's global position
			var element_rect := Rect2(element.global_position, element.size)
			
			# Check if the global mouse position is within the element's bounds
			if element_rect.has_point(global_pos):
				return element
				
			# If you want to check for elements *near* the cursor even if not overlapping:
			# You would need a more complex raycast or distance check, but the Rect2 check 
			# above is common for Control nodes.
			
	return null
